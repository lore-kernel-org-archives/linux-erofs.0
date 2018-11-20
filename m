From: bluce.liguifu@huawei.com (Li Guifu)
Date: Tue, 20 Nov 2018 22:32:38 +0800
Subject: [PREVIEW] [RFC PATCH v2 4/5] erofs-mkfs: add compression support
In-Reply-To: <20181120143239.58976-1-bluce.liguifu@huawei.com>
References: <20181120143239.58976-1-bluce.liguifu@huawei.com>
Message-ID: <20181120143239.58976-5-bluce.liguifu@huawei.com>

This patch introduces a compression framework, so it can support
different compression algorithm in principle, currently lz4hc is
added right now due to the kernel implementation.

Signed-off-by: Li Guifu <bluce.liguifu at huawei.com>
Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Fang Wei <fangwei1 at huawei.com>
---
 erofs_compressor.c | 144 ++++++++++
 erofs_compressor.h |  49 ++++
 erofs_lz4hc.c      |  52 ++++
 erofs_lz4hc.h      |  22 ++
 mkfs_file.c        | 698 +++++++++++++++++++++++++++++++++++++++++++++
 mkfs_inode.c       |  61 +++-
 mkfs_main.c        |   4 +
 7 files changed, 1028 insertions(+), 2 deletions(-)
 create mode 100644 erofs_compressor.c
 create mode 100644 erofs_compressor.h
 create mode 100644 erofs_lz4hc.c
 create mode 100644 erofs_lz4hc.h

diff --git a/erofs_compressor.c b/erofs_compressor.c
new file mode 100644
index 0000000..139ae53
--- /dev/null
+++ b/erofs_compressor.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs_compressor.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Miao Xie <miaoxie at huawei.com>
+ */
+#include <string.h>
+#include <assert.h>
+
+#include "erofs_error.h"
+#include "erofs_compressor.h"
+#include "erofs_lz4hc.h"
+#include "erofs_debug.h"
+#include "mkfs_erofs.h"
+
+static struct erofs_compr_alg erofs_compr_desc[EROFS_COMPR_ALG_MAX] = {
+	[EROFS_COMPR_NONE] = {
+		.ca_name    = "none",
+		.ca_idx     = EROFS_COMPR_NONE,
+		.ca_max_lvl = 0,
+		.ca_min_lvl = 0,
+		.ca_def_lvl = 0,
+		.ca_compress    = NULL,
+		.ca_init    = NULL,
+		.ca_deinit  = NULL,
+	},
+	[EROFS_COMPR_LZ4HC] = {
+		.ca_name    = "lz4hc",
+		.ca_idx     = EROFS_COMPR_LZ4HC,
+		.ca_max_lvl = LZ4HC_CLEVEL_MAX,
+		.ca_min_lvl = LZ4HC_CLEVEL_MIN,
+		.ca_def_lvl = EROFS_COMPR_LZ4HC_DEF_LVL,
+		.ca_compress    = erofs_lz4hc_compress,
+		.ca_init    = erofs_lz4hc_init,
+		.ca_deinit  = erofs_lz4hc_deinit,
+	},
+};
+
+void erofs_compress_alg_init(const char *name)
+{
+	int level;
+	struct erofs_compr_alg *alg;
+
+	if (!name) {
+		erofs_err("compress alg name is NULL !!!");
+		exit(EXIT_FAILURE);
+	}
+
+	/* name:  lz4hc or none */
+	alg = erofs_get_compress_alg(name);
+	if (!alg) {
+		erofs_err("can found alg[%s]", name);
+		exit(EXIT_FAILURE);
+	}
+	erofs_cfg.c_compr_alg       = alg;
+	erofs_cfg.c_compr_maxsz = BLK_ALIGN(EROFS_CONFIG_COMPR_MAX_SZ);
+
+	level = erofs_adjust_compress_level(alg, EROFS_COMPR_LZ4HC_DEF_LVL);
+	erofs_cfg.c_compr_lvl       = level;
+	erofs_cfg.c_compr_boundary  = EROFS_CONFIG_COMPR_DEF_BOUNDARY;
+	erofs_cfg.c_compr_ratio_limit   = EROFS_CONFIG_COMPR_RATIO_MAX_LIMIT;
+
+}
+struct erofs_compr_alg *erofs_get_compress_alg(const char *name)
+{
+	int i;
+
+	for (i = EROFS_COMPR_NONE; i < EROFS_COMPR_ALG_MAX; i++) {
+		if (strcmp(name, erofs_compr_desc[i].ca_name) == 0)
+			return &erofs_compr_desc[i];
+	}
+
+	return NULL;
+}
+
+int erofs_adjust_compress_level(struct erofs_compr_alg *alg, int lvl)
+{
+	if (!alg || alg->ca_idx == EROFS_COMPR_NONE)
+		return 0;
+
+	if (lvl > alg->ca_max_lvl) {
+		erofs_err("Compress level(%d) is greater than max level(%d), adjust it to default level(%d).\n",
+			   lvl, alg->ca_max_lvl, EROFS_COMPR_LZ4HC_DEF_LVL);
+		return alg->ca_def_lvl;
+	}
+
+	if (lvl < alg->ca_min_lvl) {
+		erofs_err("Compress level(%d) is less than min level(%d), adjust it to default level(%d).\n",
+			   lvl, alg->ca_min_lvl, EROFS_COMPR_LZ4HC_DEF_LVL);
+		return alg->ca_def_lvl;
+	}
+
+	return lvl;
+}
+
+void *erofs_compress_init(struct erofs_compr_alg *alg)
+{
+	void *ctx;
+
+	if (!alg->ca_init)
+		return NULL;
+
+	ctx = alg->ca_init();
+
+	return ctx;
+}
+
+void erofs_compress_deinit(struct erofs_compr_alg *alg, void *cctx)
+{
+	if (!alg->ca_deinit)
+		return;
+
+	alg->ca_deinit(cctx);
+}
+
+int64_t erofs_compress_onctx(struct erofs_compr_alg *alg, void *ctx,
+			     char *in, size_t insz,
+			     char *out, size_t outsz, size_t *srcsz, int lvl)
+{
+	assert(alg->ca_compress);
+
+	return alg->ca_compress(in, insz, out, outsz, srcsz, lvl, ctx);
+}
+
+int64_t erofs_compress(struct erofs_compr_alg *alg, char *in, size_t insz,
+		       char *out, size_t outsz, size_t *srcsz, int lvl)
+{
+	void *ctx = NULL;
+	int64_t ret;
+
+	if (alg->ca_init) {
+		ctx = alg->ca_init();
+		if (IS_ERR(ctx))
+			return EROFS_COMPRESS_ERROR;
+	}
+
+	ret = alg->ca_compress(in, insz, out, outsz, srcsz, lvl, ctx);
+	if (alg->ca_deinit)
+		alg->ca_deinit(ctx);
+
+	return ret;
+}
diff --git a/erofs_compressor.h b/erofs_compressor.h
new file mode 100644
index 0000000..f2d8b09
--- /dev/null
+++ b/erofs_compressor.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs_compressor.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __EROFS_COMPRESSOR_H__
+#define __EROFS_COMPRESSOR_H__
+
+#include <stdint.h>
+
+#define EROFS_COMPRESS_ERROR    (-1LL)
+
+enum erofs_compr_algs {
+	EROFS_COMPR_NONE,
+	EROFS_COMPR_LZ4HC,
+	EROFS_COMPR_ALG_MAX,
+};
+
+typedef int64_t (*compress_func)(char *in, size_t insize, char *out,
+				 size_t outsize, size_t *insizeptr, int level,
+				 void*);
+typedef void* (*init_func)();
+typedef void (*deinit_func)(void *cctx);
+
+struct erofs_compr_alg {
+	char        *ca_name;
+	int         ca_idx;
+	int         ca_max_lvl;
+	int         ca_min_lvl;
+	int         ca_def_lvl;
+	compress_func   ca_compress;
+	init_func       ca_init;
+	deinit_func     ca_deinit;
+};
+
+void erofs_compress_alg_init(const char *name);
+struct erofs_compr_alg *erofs_get_compress_alg(const char *name);
+int erofs_adjust_compress_level(struct erofs_compr_alg *alg, int lvl);
+void *erofs_compress_init(struct erofs_compr_alg *alg);
+void erofs_compress_deinit(struct erofs_compr_alg *alg, void *cctx);
+int64_t erofs_compress_onctx(struct erofs_compr_alg *alg, void *ctx,
+			     char *in, size_t insz,
+			     char *out, size_t outsz, size_t *srcsz, int lvl);
+int64_t erofs_compress(struct erofs_compr_alg *alg, char *in, size_t insz,
+		       char *out, size_t outsz, size_t *srcsz, int lvl);
+#endif
diff --git a/erofs_lz4hc.c b/erofs_lz4hc.c
new file mode 100644
index 0000000..1d155b7
--- /dev/null
+++ b/erofs_lz4hc.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs_lz4hc.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#include <errno.h>
+#define LZ4_HC_STATIC_LINKING_ONLY  (1)
+#include <lz4hc.h>
+
+#include "erofs_error.h"
+#include "erofs_lz4hc.h"
+#include "erofs_compressor.h"
+#include "erofs_debug.h"
+
+void *erofs_lz4hc_init(void)
+{
+	LZ4_streamHC_t *ctx;
+
+	ctx = LZ4_createStreamHC();
+	if (!ctx) {
+		erofs_err("Cannot allocate LZ4HC context");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return (void *)ctx;
+}
+
+void erofs_lz4hc_deinit(void *ctx)
+{
+	if (!ctx)
+		return;
+
+	LZ4_freeStreamHC((LZ4_streamHC_t *)ctx);
+}
+
+int64_t erofs_lz4hc_compress(char *in, size_t insz, char *out, size_t outsz,
+			     size_t *inszptr, int level, void *ctx)
+{
+	int count;
+
+	*inszptr = insz;
+	count = LZ4_compress_HC_destSize((LZ4_streamHC_t *)ctx, in, out,
+					 (int *)inszptr, outsz, level);
+	if (count <= 0) {
+		erofs_err("Failed to compress data by LZ4HC");
+		return EROFS_COMPRESS_ERROR;
+	}
+	return (int64_t)count;
+}
diff --git a/erofs_lz4hc.h b/erofs_lz4hc.h
new file mode 100644
index 0000000..029c4f4
--- /dev/null
+++ b/erofs_lz4hc.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs_lz4hc.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __EROFS_LZ4HC_H__
+#define __EROFS_LZ4HC_H__
+
+#include <stdint.h>
+#include <lz4hc.h>
+
+#define EROFS_COMPR_LZ4HC_DEF_LVL       (9)
+
+void *erofs_lz4hc_init(void);
+void erofs_lz4hc_deinit(void *ctx);
+int64_t erofs_lz4hc_compress(char *in, size_t insz, char *out,
+			     size_t outsz, size_t *inszptr,
+			     int level, void*);
+#endif
diff --git a/mkfs_file.c b/mkfs_file.c
index beeb89d..a979c14 100644
--- a/mkfs_file.c
+++ b/mkfs_file.c
@@ -36,6 +36,7 @@
 #include "erofs_types.h"
 #include "list_head.h"
 #include "erofs_cache.h"
+#include "erofs_compressor.h"
 
 #define pr_fmt(fmt) "MKFS-FILE: "FUNC_LINE_FMT fmt"\n"
 #include "erofs_debug.h"
@@ -304,3 +305,700 @@ struct erofs_node_info *alloc_erofs_node(void)
 	init_list_head(&f->i_xattr_head);
 
 	return f;
+}
+
+static void
+erofs_compr_idx_host_to_disk(struct erofs_compr_idx *hidx,
+			     struct z_erofs_vle_decompressed_index *didx)
+{
+	switch (hidx->di_advise) {
+	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
+	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
+		didx->di_advise = cpu_to_le16(hidx->di_advise);
+		didx->di_clusterofs = cpu_to_le16(hidx->di_clusterofs);
+		didx->di_u.blkaddr = cpu_to_le32(hidx->blkaddr);
+		break;
+
+	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		didx->di_advise = cpu_to_le16(hidx->di_advise);
+		didx->di_clusterofs = cpu_to_le16(hidx->di_clusterofs);
+		didx->di_u.delta[0] = cpu_to_le16(hidx->delta[0]);
+		didx->di_u.delta[1] = cpu_to_le16(hidx->delta[1]);
+		break;
+
+	default:
+		assert(0);
+		break;
+	}
+}
+
+static int erofs_compress_inline_file_data(struct erofs_compr_info *cinfo,
+					   struct erofs_compr_ctx *ctx)
+{
+	int64_t         compr_count;
+	size_t          comprsz = 0;
+
+	assert(ctx->cc_srclen <= EROFS_BLKSIZE);
+	assert(ctx->cc_buflen >= 2 * EROFS_BLKSIZE);
+
+	compr_count = erofs_compress(cinfo->ci_alg,
+				     ctx->cc_srcbuf, ctx->cc_srclen,
+				     ctx->cc_dstbuf, EROFS_BLKSIZE,
+				     &comprsz, cinfo->ci_lvl);
+
+	if (compr_count == 0 || compr_count == EROFS_COMPRESS_ERROR) {
+		erofs_err("Failed to compress data by %s",
+			   cinfo->ci_alg->ca_name);
+		return -EIO;
+	}
+
+	assert(comprsz == (size_t)ctx->cc_srclen);
+
+	ctx->cc_dstlen = (int)compr_count;
+	ctx->cc_nidxs = EROFS_COMPR_CTX_INLINED_DATA;
+	return 0;
+}
+
+/* Note: it is not for inline data compress */
+static int
+erofs_compress_noinline_file_data(struct erofs_compr_info *cinfo,
+				  struct erofs_compr_ctx *ctx)
+{
+	char        *in;
+	char        *out;
+	size_t      insz;
+	size_t      outsz;
+	u32         blkaddr;
+	size_t      comprsz;
+	int64_t     compr_count;
+	long long   pos;
+	int         start;
+	int         end;
+	int         i;
+	int         advise;
+	int         clusterofs;
+	int         delta;
+	int         cross;
+	int         nidxs;
+	struct erofs_compr_idx *idx;
+
+	in = ctx->cc_srcbuf;
+	insz = ctx->cc_srclen;
+	out = ctx->cc_dstbuf;
+	outsz = EROFS_BLKSIZE;
+	blkaddr = 0;
+	pos = ctx->cc_pos;
+	nidxs = 0;
+
+	assert(pos % EROFS_BLKSIZE == 0);
+	assert(insz % EROFS_BLKSIZE == 0);
+
+	while (insz > 0) {
+		advise = Z_EROFS_VLE_CLUSTER_TYPE_MAX;
+		/* Data is less than a block, don't compress */
+		if (insz <= EROFS_BLKSIZE) {
+			advise = Z_EROFS_VLE_CLUSTER_TYPE_PLAIN;
+			comprsz = insz;
+			compr_count = insz;
+			memcpy(out, in, insz);
+			goto update_index;
+		}
+
+		comprsz = 0;
+		compr_count = erofs_compress(cinfo->ci_alg, in, insz,
+					     out, outsz,
+					     &comprsz, cinfo->ci_lvl);
+
+		if (compr_count == 0 ||
+		    compr_count == EROFS_COMPRESS_ERROR) {
+			erofs_err("Failed to compress data by %s",
+				   cinfo->ci_alg->ca_name);
+			return -EIO;
+		}
+
+		/* compress ratio is very bad, don't compress */
+		if ((int)comprsz - (int)compr_count <
+		    erofs_cfg.c_compr_boundary) {
+			advise = Z_EROFS_VLE_CLUSTER_TYPE_PLAIN;
+
+			if (pos % EROFS_BLKSIZE == 0)
+				comprsz = EROFS_BLKSIZE;
+			else
+				comprsz = (int)(round_up(pos,
+							 EROFS_BLKSIZE) - pos);
+
+			compr_count = comprsz;
+			memcpy(out, in, comprsz);
+			goto update_index;
+		}
+
+		if ((pos + comprsz) % EROFS_BLKSIZE <=
+			(unsigned int)erofs_cfg.c_compr_boundary)
+			comprsz -= (int)((pos + comprsz) % EROFS_BLKSIZE);
+
+		assert(comprsz);
+
+update_index:
+		start = (int)((pos - ctx->cc_pos) / EROFS_BLKSIZE);
+		end = (int)((pos + comprsz - ctx->cc_pos) / EROFS_BLKSIZE);
+
+		assert(end > start);
+
+		if ((pos + comprsz) % EROFS_BLKSIZE != 0)
+			cross = end - start + 1;
+		else
+			cross = end - start;
+
+		clusterofs = pos % PAGE_SIZE;
+		delta = 0;
+
+		/*
+		 * Here we against the rule that the length of code should
+		 * less than 80 bytes, it is because we want to make
+		 * the readability of mathematical expression be better.
+		 */
+		erofs_dbg("Compress range(Original[%lld - %lld], Index[%d - %d], Aligned[%lld - %lld], Index[%lld - %lld]) Start index %s, end index %s, end pos %s\n",
+			  pos, pos + comprsz - 1,
+			  start, end,
+			  round_down(pos, EROFS_BLKSIZE),
+			  round_up(pos + comprsz - 1, EROFS_BLKSIZE) - 1,
+			  (round_down(pos, EROFS_BLKSIZE) - ctx->cc_pos) / EROFS_BLKSIZE,
+			  (round_up(pos + comprsz - 1, EROFS_BLKSIZE) - ctx->cc_pos) / EROFS_BLKSIZE - 1,
+			  start == (int)(round_down(pos, EROFS_BLKSIZE) - ctx->cc_pos) / EROFS_BLKSIZE ?  "SAME" : "DIFF",
+			  end == (int)(round_up(pos + comprsz - 1, EROFS_BLKSIZE) - ctx->cc_pos) / EROFS_BLKSIZE - 1 ?  "SAME" : "DIFF",
+			  pos + comprsz - 1 == round_up(pos + comprsz - 1, EROFS_BLKSIZE) - 1 ?  "SAME" : "DIFF");
+
+		for (i = start; i < end; i++) {
+			idx = &ctx->cc_idxs[i];
+			if (advise == Z_EROFS_VLE_CLUSTER_TYPE_MAX) {
+				if (delta == 0) {
+					idx->di_advise =
+						Z_EROFS_VLE_CLUSTER_TYPE_HEAD;
+				} else {
+					idx->di_advise =
+						Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD;
+				}
+			} else {
+				idx->di_advise = advise;
+			}
+			idx->di_clusterofs = clusterofs;
+			idx->delta[0] = delta;
+			idx->delta[1] = cross - delta - 1;
+			/* Allocate the blocks later */
+			idx->blkaddr = blkaddr;
+
+			erofs_dbg("Compress Index: advise - %u, clusterofs - %u, delta0 - %u, delta1 - %u, blkaddr - %u",
+				  idx->di_advise, clusterofs,
+				  delta, cross - delta,
+				  blkaddr);
+			delta++;
+			nidxs++;
+		}
+
+		insz -= comprsz;
+		in += comprsz;
+		out += EROFS_BLKSIZE;
+		pos += comprsz;
+		blkaddr++;
+	}
+
+	ctx->cc_dstlen = (int)(out - ctx->cc_dstbuf);
+	ctx->cc_nidxs  = nidxs;
+	return 0;
+}
+
+int erofs_write_compress_data(struct erofs_compr_ctx *cctx)
+{
+	u32 nblocks;
+	u32 blkaddr;
+	int ret;
+	int i;
+
+	nblocks = cctx->cc_dstlen / EROFS_BLKSIZE;
+	blkaddr = erofs_alloc_blocks(nblocks);
+
+	if (!blkaddr)
+		return -ENOSPC;
+
+	ret = dev_write(cctx->cc_dstbuf, BLKNO_TO_ADDR(blkaddr),
+			cctx->cc_dstlen);
+
+	if (ret)
+		return -EIO;
+
+	for (i  = 0; i < cctx->cc_nidxs; i++)
+		cctx->cc_idxs[i].blkaddr += blkaddr;
+
+	return 0;
+}
+
+int erofs_update_indexes(struct erofs_node_info *inode,
+			 struct erofs_compr_ctx *cctx)
+{
+	u64 index = cctx->cc_pos / EROFS_BLKSIZE;
+	struct erofs_index_info *iinfo;
+	struct z_erofs_vle_decompressed_index *didx;
+	int i;
+	int j = 0;
+	int end;
+
+	iinfo = inode->i_compr_cur_index_info;
+
+	/* Find index struct which we want */
+	if (iinfo && index >= iinfo->i_1st_idx)
+		goto search_next_index_info;
+
+	if (index >= inode->i_compr_inlined_nidxs)
+		goto search_from_1st_index_info;
+
+	didx = (void *)(inode->i_inline_data +
+			sizeof(struct erofs_extent_header));
+	end = inode->i_compr_inlined_nidxs;
+
+	for (i = (int)index; i < end && j < cctx->cc_nidxs; i++, j++)
+		erofs_compr_idx_host_to_disk(&cctx->cc_idxs[j], &didx[i]);
+
+	if (j == cctx->cc_nidxs)
+		return 0;
+
+	index = i;
+search_from_1st_index_info:
+	iinfo = list_first_entry(&inode->i_compr_idxs_list,
+				 struct erofs_index_info, i_node);
+search_next_index_info:
+	list_for_each_entry_from(iinfo, &inode->i_compr_idxs_list, i_node) {
+		if (index < iinfo->i_1st_idx + iinfo->i_nidxs)
+			break;
+	}
+
+	assert(index >= iinfo->i_1st_idx);
+
+	do {
+		didx = iinfo->i_idxs;
+		i = index - iinfo->i_1st_idx;
+		end = iinfo->i_nidxs;
+
+		for (; i < end && j < cctx->cc_nidxs; i++, j++)
+			erofs_compr_idx_host_to_disk(&cctx->cc_idxs[j],
+						     &didx[i]);
+
+		if (j == cctx->cc_nidxs)
+			break;
+
+		index = i + iinfo->i_1st_idx;
+		iinfo = list_next_entry(iinfo, i_node);
+	} while (1);
+
+	inode->i_compr_cur_index_info = iinfo;
+	return 0;
+}
+
+int erofs_compress_file(struct erofs_node_info *inode)
+{
+	int         fd = -1;
+	size_t      read_count;
+	off64_t     pos = 0;
+	u64         isize = inode->i_size;
+	u64         itotal = 0;
+	u64         ototal = 0;
+	u64         nidxs = 0;
+	int         ret = 0;
+	struct erofs_compr_ctx *cctx = &inode->i_compr_ctx;
+	struct erofs_compr_info *compressor = &inode->i_compressor;
+	struct erofs_extent_header *header;
+
+	assert(!inode->i_inline_data);
+	assert(inode->i_size > 0);
+
+	inode->i_inline_data = malloc(EROFS_BLKSIZE);
+
+	if (!inode->i_inline_data) {
+		erofs_err("Fail to alloc inline data buffer(%s)",
+			  inode->i_name);
+		return -ENOMEM;
+	}
+
+	memset(inode->i_inline_data, 0, EROFS_BLKSIZE);
+
+	/* Init header */
+	header = (struct erofs_extent_header *)inode->i_inline_data;
+	header->eh_checksum = 0;
+
+	/*
+	 * We have compressed some data at the head of the file when we check
+	 * the compressible, so we should go to the branch, put a assert here
+	 * to check LOGICAL BUG in the code.
+	 */
+	if (cctx->cc_pos != 0 || cctx->cc_nidxs == 0) {
+		assert(0);
+		return -EIO;
+	}
+
+	/*
+	 * Check cctx, write out the compress data and update the metadatae if
+	 * we have compressed some data before.
+	 */
+	if (cctx->cc_nidxs == EROFS_COMPR_CTX_INLINED_DATA) {
+		/*
+		 * TODO: Now we don't support inlined compress data,
+		 * we will implement it in the future, add a assert
+		 * here to avoid someone making a mistake.
+		 *
+		 * ? where can we keep the compress data len? i_blocks?
+		 */
+		assert(0);
+		erofs_dbg("Size: %d(%"PRIu64") ==> %d, Inline Compress, Compress Ratio %.2lf%%.\n",
+			  cctx->cc_srclen, isize, cctx->cc_dstlen,
+			  (double)cctx->cc_dstlen * 100 / (double)cctx->cc_srclen);
+		return 0;
+	} else if (cctx->cc_nidxs < 0) {
+		/* There is something wrong with nidxs */
+		assert(0);
+		return -EIO;
+	}
+
+	ret = erofs_write_compress_data(cctx);
+
+	if (ret)
+		return ret;
+
+	ret = erofs_update_indexes(inode, cctx);
+
+	if (ret)
+		return ret;
+
+	itotal = cctx->cc_srclen;
+	ototal = cctx->cc_dstlen;
+	nidxs = cctx->cc_nidxs;
+
+	pos = cctx->cc_pos + cctx->cc_srclen;
+
+	if ((u64)pos >= inode->i_size)
+		goto compress_complete;
+
+	fd = open(inode->i_fullpath, O_RDONLY | O_BINARY);
+
+	if (fd < 0) {
+		erofs_err("Fail to open a file(%s)", inode->i_name);
+		return -ENOENT;
+	}
+
+	pos = lseek64(fd, pos, SEEK_SET);
+
+	if (pos == (off64_t) -1ULL) {
+		ret = -EINVAL;
+		goto close_file;
+	}
+
+	assert(pos != 0);
+
+	while (1) {
+		erofs_reset_compress_context(cctx);
+
+		read_count = read(fd, cctx->cc_srcbuf, cctx->cc_buflen);
+
+		if (read_count == 0) {
+			if (itotal == isize) {
+				/* EOF, go out and complete compression */
+				ret = 0;
+			} else {
+				/*
+				 * Read error happened and the operation was
+				 * interrupted.
+				 */
+				erofs_err("Read file(%s) interrupted at offset - %lld",
+					  inode->i_name, (long long)pos);
+				ret = -EIO;
+			}
+
+			break;
+		}
+
+		itotal += read_count;
+
+		if (itotal > isize) {
+			erofs_err("Read overflow(File: %s, Real Size:%llu, Read Size: %llu)",
+				  inode->i_name, (long long unsigned)isize,
+				  (long long unsigned)itotal);
+			ret = -EIO;
+			break;
+		} else if (itotal == isize) {
+			read_count = round_up(read_count, EROFS_BLKSIZE);
+		} else {
+			if (read_count % EROFS_BLKSIZE != 0) {
+				erofs_err("Read size is not aligned(File: %s, Pos: %"PRIu64", Size: %zd)",
+					  inode->i_name, (u64)pos, read_count);
+				ret = -EIO;
+				break;
+			}
+		}
+
+		cctx->cc_pos = pos;
+		cctx->cc_srclen = read_count;
+
+		ret = erofs_compress_noinline_file_data(compressor, cctx);
+
+		if (ret) {
+			erofs_err("Compress file Fail(File: %s, Pos: %"PRIu64", Size: %zd)",
+				  inode->i_name, (u64)pos, read_count);
+			ret = -EIO;
+			break;
+		}
+
+		ret = erofs_write_compress_data(cctx);
+
+		if (ret)
+			break;
+
+		ret = erofs_update_indexes(inode, cctx);
+
+		if (ret)
+			break;
+
+		ototal += cctx->cc_dstlen;
+		nidxs += cctx->cc_nidxs;
+		pos += read_count;
+	}
+
+compress_complete:
+
+	if (!ret) {
+		inode->i_blocks = (u32)(ototal / EROFS_BLKSIZE);
+		erofs_dbg("Size: %"PRIu64"(%"PRIu64") ==> %"PRIu64", Indexs %"PRIu64", Compress Ratio %.2lf%%.\n",
+			  itotal, isize, ototal, nidxs,
+			  (double)ototal * 100 / (double)itotal);
+	}
+
+close_file:
+
+	if (fd >= 0)
+		close(fd);
+
+	return ret;
+}
+
+int erofs_try_compress_file_once(struct erofs_node_info *inode,
+				 struct erofs_compr_info *cinfo,
+				 struct erofs_compr_ctx *cctx)
+{
+	int         fd;
+	size_t      read_count;
+	loff_t      pos = 0;
+	u64         isize = inode->i_size;
+	int         inlined = 0;
+	int         ret = 0;
+
+	assert(cinfo->ci_alg);
+	assert(cinfo->ci_alg->ca_idx != EROFS_COMPR_NONE);
+	assert(cctx->cc_buflen > EROFS_BLKSIZE &&
+	       cctx->cc_buflen % EROFS_BLKSIZE == 0);
+	assert(cctx->cc_pos == 0);
+	assert(inode->i_size > 0);
+	assert(inode->i_compressor.ci_alg == NULL);
+	assert(inode->i_compr_ctx.cc_srcbuf == NULL);
+
+	fd = open(inode->i_fullpath, O_RDONLY | O_BINARY);
+
+	if (fd < 0) {
+		erofs_err("Fail to open a file(%s)", inode->i_fullpath);
+		return -ENOENT;
+	}
+
+	read_count = read(fd, cctx->cc_srcbuf, cctx->cc_buflen);
+
+	if (read_count == 0) {
+		erofs_err("Read file(%s) interrupted at offset - %"PRIu64"",
+			  inode->i_name, (u64)pos);
+		ret = -EIO;
+		goto close_file;
+	}
+
+	if (read_count > isize) {
+		erofs_err("Read overflow(File: %s, Real Size:%"PRIu64", Read Size: %zd)",
+			  inode->i_name, (u64)isize, read_count);
+		ret = -EIO;
+		goto close_file;
+	} else if (read_count == isize) {
+		if (isize > EROFS_BLKSIZE)
+			read_count = round_up(read_count, EROFS_BLKSIZE);
+		else
+			inlined = 1;
+	} else {
+		if (read_count % EROFS_BLKSIZE != 0) {
+			erofs_err("Read size is not aligned(File: %s, Pos: %"PRIu64", Size: %zd)",
+				  inode->i_name, (u64)pos, read_count);
+			ret = -EIO;
+			goto close_file;
+		}
+	}
+
+	cctx->cc_pos = 0;
+	cctx->cc_srclen = read_count;
+
+	if (inlined)
+		ret = erofs_compress_inline_file_data(cinfo, cctx);
+	else
+		ret = erofs_compress_noinline_file_data(cinfo, cctx);
+
+	if (ret) {
+		erofs_err("Compress file Fail(File: %s, Pos: %"PRIu64", Size: %zd)",
+			  inode->i_name, (u64)pos, read_count);
+		ret = -EIO;
+	}
+
+close_file:
+	close(fd);
+	return ret;
+}
+
+static int erofs_get_node_compress_info(struct erofs_node_info *inode,
+					struct erofs_compr_info *cinfo)
+{
+	/* Get specified compress algorithm which is set in the config file */
+	/*
+	 * Now we have not implement it, just use the algorithm
+	 * set in command line.
+	 */
+	(void)inode;
+	cinfo->ci_alg = erofs_cfg.c_compr_alg;
+	cinfo->ci_lvl = erofs_cfg.c_compr_lvl;
+
+	return 0;
+}
+
+void erofs_deinit_compress_context(struct erofs_compr_ctx *ctx)
+{
+	if (ctx->cc_srcbuf)
+		free(ctx->cc_srcbuf);
+
+	if (ctx->cc_dstbuf)
+		free(ctx->cc_dstbuf);
+
+	if (ctx->cc_idxs)
+		free(ctx->cc_idxs);
+
+	memset(ctx, 0, sizeof(struct erofs_compr_ctx));
+}
+
+int erofs_init_compress_context(struct erofs_compr_ctx *ctx)
+{
+	memset(ctx, 0, sizeof(struct erofs_compr_ctx));
+
+	ctx->cc_srcbuf = malloc(erofs_cfg.c_compr_maxsz);
+	ctx->cc_dstbuf = malloc(erofs_cfg.c_compr_maxsz * 2);
+	ctx->cc_idxs = calloc(erofs_cfg.c_compr_maxsz / EROFS_BLKSIZE,
+			      sizeof(struct erofs_compr_idx));
+
+	if (!ctx->cc_srcbuf || !ctx->cc_dstbuf || !ctx->cc_idxs) {
+		erofs_deinit_compress_context(ctx);
+		return -ENOMEM;
+	}
+
+	ctx->cc_buflen = erofs_cfg.c_compr_maxsz;
+
+	memset(ctx->cc_srcbuf, 0, ctx->cc_buflen);
+	memset(ctx->cc_dstbuf, 0, ctx->cc_buflen);
+	memset(ctx->cc_idxs, 0,
+	       ctx->cc_buflen / EROFS_BLKSIZE * sizeof(struct erofs_compr_idx));
+
+	return 0;
+}
+
+void erofs_reset_compress_context(struct erofs_compr_ctx *ctx)
+{
+	ctx->cc_pos = 0;
+	ctx->cc_srclen = 0;
+	ctx->cc_dstlen = 0;
+	ctx->cc_nidxs = 0;
+	memset(ctx->cc_srcbuf, 0, ctx->cc_buflen);
+	memset(ctx->cc_dstbuf, 0, ctx->cc_buflen);
+	memset(ctx->cc_idxs, 0,
+	       ctx->cc_buflen / EROFS_BLKSIZE * sizeof(struct erofs_compr_idx));
+}
+
+int erofs_check_compressible(struct erofs_node_info *inode)
+{
+	struct erofs_compr_info cinfo;
+	struct erofs_compr_ctx ctx;
+	int ratio;
+	int ret;
+
+	if (erofs_cfg.c_compr_alg->ca_idx == EROFS_COMPR_NONE) {
+		/* Compress is disable by the user */
+		return 0;
+	}
+
+	if (inode->i_type != EROFS_FT_REG_FILE)
+		return 0;
+
+	/* check if we can inline data directly */
+	if (inode->i_size <= erofs_calc_inline_data_size(inode))
+		return 0;
+
+	/* check if the user don't want to compress this file */
+	cinfo.ci_alg = NULL;
+	cinfo.ci_lvl = 0;
+
+	ret = erofs_get_node_compress_info(inode, &cinfo);
+
+	if (ret) {
+		erofs_err("Failed to get compress algorithm for %s",
+			  inode->i_name);
+		assert(ret < 0);
+		return ret;
+	}
+
+	if (!cinfo.ci_alg || cinfo.ci_alg->ca_idx == EROFS_COMPR_NONE)
+		return 0;
+
+	assert(erofs_cfg.c_compr_maxsz % EROFS_BLKSIZE == 0);
+	ret = erofs_init_compress_context(&ctx);
+
+	if (ret)
+		return ret;
+
+	ret = erofs_try_compress_file_once(inode, &cinfo, &ctx);
+
+	if (ret) {
+		erofs_deinit_compress_context(&ctx);
+		return ret;
+	}
+
+	/* FIXME: Now we don't implement inline compress, so... */
+	if (inode->i_size <= EROFS_BLKSIZE) {
+		/*
+		 * TODO: Now we haven't support inline compress data, so
+		 * disable compress if
+		 *  inline_data_size < i_size <= block_size
+		 */
+#ifdef CONFIG_EROFS_INLINE_COMPRESS_DATA
+		if (ctx.dstlen > erofs_calc_inline_data_size(inode)) {
+		    erofs_deinit_compress_context(&ctx);
+			return 0;
+		}
+
+#else
+		erofs_deinit_compress_context(&ctx);
+		return 0;
+#endif
+	} else {
+		ratio = ctx.cc_dstlen * 100 / ctx.cc_srclen;
+
+		if (ratio > erofs_cfg.c_compr_ratio_limit ||
+		    ctx.cc_srclen - ctx.cc_dstlen < EROFS_BLKSIZE) {
+			erofs_deinit_compress_context(&ctx);
+			return 0;
+		}
+	}
+
+	/*
+	 * Check the file compress ratio by trying to compress the 1st segment,
+	 * If the ratio is greater than the limit or we can not save a block,
+	 * don't compress.
+	 */
+	inode->i_compressor.ci_alg = cinfo.ci_alg;
+	inode->i_compressor.ci_lvl = cinfo.ci_lvl;
+	memcpy(&inode->i_compr_ctx, &ctx, sizeof(struct erofs_compr_ctx));
+	return 1;
+}
+
diff --git a/mkfs_inode.c b/mkfs_inode.c
index e190853..4089e18 100644
--- a/mkfs_inode.c
+++ b/mkfs_inode.c
@@ -61,6 +61,23 @@ static inline u64 erofs_calc_compr_index_count(struct erofs_node_info *inode)
 	return round_up(inode->i_size, EROFS_BLKSIZE) / EROFS_BLKSIZE;
 }
 
+static int erofs_calc_inline_compr_index_count(struct erofs_node_info *inode)
+{
+	int size;
+
+	size = erofs_calc_inode_base_size(inode);
+	size = round_up(size, EROFS_INLINE_INDEX_ALIGN_SIZE);
+	size += sizeof(struct erofs_extent_header);
+
+	assert(size < EROFS_BLKSIZE);
+
+	size = EROFS_BLKSIZE - size;
+
+	assert(size % EROFS_DECOMPR_IDX_SZ == 0);
+
+	return size / EROFS_DECOMPR_IDX_SZ;
+}
+
 u8 erofs_check_disk_inode_version(struct erofs_node_info *inode)
 {
 #if 1
@@ -79,6 +96,33 @@ u8 erofs_check_disk_inode_version(struct erofs_node_info *inode)
 #endif
 }
 
+static void erofs_init_compress_inode(struct erofs_node_info *inode)
+{
+	int inlined_nidxs;
+
+	inode->i_dmode = EROFS_INODE_LAYOUT_COMPRESSION;
+
+	if (inode->i_compr_ctx.cc_nidxs == EROFS_COMPR_CTX_INLINED_DATA) {
+		inode->i_inline_datalen = inode->i_compr_ctx.cc_dstlen;
+		return;
+	}
+
+	inode->i_compr_nidxs = erofs_calc_compr_index_count(inode);
+
+	inlined_nidxs = erofs_calc_inline_compr_index_count(inode);
+
+	if (inode->i_compr_nidxs > (u64)inlined_nidxs)
+		inode->i_compr_inlined_nidxs = inlined_nidxs;
+	else
+		inode->i_compr_inlined_nidxs = inode->i_compr_nidxs;
+
+	inlined_nidxs = inode->i_compr_inlined_nidxs * EROFS_DECOMPR_IDX_SZ;
+	inode->i_inline_datalen = sizeof(struct erofs_extent_header);
+	inode->i_inline_datalen += inlined_nidxs;
+
+	inode->i_inline_align_size = EROFS_INLINE_INDEX_ALIGN_SIZE;
+}
+
 void mkfs_rank_inode(struct erofs_node_info *inode)
 {
 	block_buffer_t *blk;
@@ -201,6 +245,7 @@ struct erofs_node_info *mkfs_prepare_root_inode(char *root)
 
 void mkfs_relocate_sub_inodes(struct erofs_node_info *inode)
 {
+	int compressible;
 	u32 blkaddr;
 	u32 nblocks;
 	u32 unaligned;
@@ -208,6 +253,14 @@ void mkfs_relocate_sub_inodes(struct erofs_node_info *inode)
 
 	switch (d->i_type) {
 	case EROFS_FT_REG_FILE:
+		compressible = erofs_check_compressible(d);
+		if (compressible < 0) {
+			assert(0);
+		} else if (compressible > 0) {
+			erofs_init_compress_inode(d);
+			mkfs_rank_inode(d);
+			break;
+		}
 	case EROFS_FT_DIR:
 	case EROFS_FT_SYMLINK:
 		unaligned = d->i_size % EROFS_BLKSIZE;
@@ -488,8 +541,12 @@ static void mkfs_write_inode_regfile(struct erofs_node_info *inode)
 		break;
 
 	case EROFS_INODE_LAYOUT_COMPRESSION:
-		/* it isn't supported right now */
-		assert(0);
+		ret = erofs_compress_file(inode);
+		if (ret) {
+			erofs_err("Compress file failed");
+			exit(EXIT_FAILURE);
+		}
+		break;
 
 	case EROFS_INODE_LAYOUT_INLINE:
 		if (inode->i_size == 0)
diff --git a/mkfs_main.c b/mkfs_main.c
index 6e1423f..a334bb9 100644
--- a/mkfs_main.c
+++ b/mkfs_main.c
@@ -18,6 +18,7 @@
 #include "mkfs_erofs.h"
 #include "erofs_io.h"
 #include "mkfs_inode.h"
+#include "erofs_compressor.h"
 #define pr_fmt(fmt) "MKFS: "FUNC_LINE_FMT fmt"\n"
 #include "erofs_debug.h"
 
@@ -107,6 +108,9 @@ static void mkfs_parse_options_cfg(int argc, char *argv[])
 		usage(argv[0]);
 	}
 
+	assert(erofs_cfg.c_alg_name);
+	erofs_compress_alg_init(erofs_cfg.c_alg_name);
+
 	mkfs_dump_config();
 
 	if (dev_open(erofs_cfg.c_img_path) < 0) {
-- 
2.17.1
