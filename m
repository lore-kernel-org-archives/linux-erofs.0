From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 13:27:48 +0800
Subject: [NOMERGE] [RFC PATCH v2 4/4] erofs-utils: adapt new compression
 framework to mkfs
In-Reply-To: <20190116052748.24709-1-gaoxiang25@huawei.com>
References: <20190116052748.24709-1-gaoxiang25@huawei.com>
Message-ID: <20190116052748.24709-4-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 mkfs/Makefile.am        |   4 +-
 mkfs/erofs_compressor.c | 110 +++++++++++++++++++++++++++++++++---------------
 mkfs/erofs_compressor.h |   3 +-
 mkfs/erofs_lz4hc.c      |  52 -----------------------
 mkfs/erofs_lz4hc.h      |  21 ---------
 mkfs/mkfs_file.c        |  24 -----------
 6 files changed, 79 insertions(+), 135 deletions(-)
 delete mode 100644 mkfs/erofs_lz4hc.c
 delete mode 100644 mkfs/erofs_lz4hc.h

diff --git a/mkfs/Makefile.am b/mkfs/Makefile.am
index 0f57761..844cfa6 100644
--- a/mkfs/Makefile.am
+++ b/mkfs/Makefile.am
@@ -3,7 +3,6 @@ AUTOMAKE_OPTIONS = foreign
 bin_PROGRAMS     = mkfs.erofs
 mkfs_erofs_SOURCES = erofs_compressor.c \
 		     mkfs_file.c \
-		     erofs_lz4hc.c \
 		     mkfs_main.c \
 		     erofs_cache.c \
 		     erofs_io.c \
@@ -13,7 +12,6 @@ mkfs_erofs_SOURCES = erofs_compressor.c \
 noinst_HEADERS = erofs_config.h  \
 		 mkfs_inode.h \
 		 erofs_error.h \
-		 erofs_lz4hc.h \
 		 erofs_cache.h \
 		 erofs_debug.h \
 		 mkfs_erofs.h \
@@ -22,6 +20,8 @@ noinst_HEADERS = erofs_config.h  \
 		 mkfs_file.h
 
 mkfs_erofs_CFLAGS = -Wall -Werror -I$(top_srcdir)/include
+# workaround since I don't know how to properly link LZ4 staticlly
+LIBS = -Wl,$(top_builddir)/lib/liberofs.a ${LIB_LZ4} ${LIB_ZLIB}
 
 if SUPPORT_LARG_FILE_AT_BIT32
     mkfs_erofs_CFLAGS += -D_FILE_OFFSET_BITS=64
diff --git a/mkfs/erofs_compressor.c b/mkfs/erofs_compressor.c
index 591b5ce..05c57f5 100644
--- a/mkfs/erofs_compressor.c
+++ b/mkfs/erofs_compressor.c
@@ -11,36 +11,95 @@
 
 #include "erofs_error.h"
 #include "erofs_compressor.h"
-#include "erofs_lz4hc.h"
 #include "erofs_debug.h"
 #include "mkfs_erofs.h"
+#include "erofs/compressor.h"
+
+#define EROFS_COMPR_LZ4HC_DEF_LVL       (9)
+#define EROFS_COMPR_ZLIB_DEF_LVL        (-1)
+
+static struct erofs_compress lz4hc_compress, zlib_compress;
+
+static void __erofs_deinit(void *ctx)
+{
+	erofs_compressor_exit((struct erofs_compress *)ctx);
+}
+
+static void *erofs_lz4hc_init(void)
+{
+	int ret = erofs_compressor_init(&lz4hc_compress, "lz4hc");
+
+	if (ret)
+		return ERR_PTR(ret);
+	return &lz4hc_compress;
+}
+
+static void *erofs_zlib_init(void)
+{
+	int ret = erofs_compressor_init(&zlib_compress, "zlib");
+
+	if (ret)
+		return ERR_PTR(ret);
+
+	return &zlib_compress;
+}
+
+static int64_t __erofs_compress_destsize(char *in, size_t insz, char *out,
+					 size_t outsz, size_t *inszptr,
+					 int level, void *ctx)
+{
+	int ret;
+	unsigned int __uinsz = insz;
+
+	ret = erofs_compress_destsize((struct erofs_compress *)ctx,
+				      level, in, &__uinsz, out, outsz);
+
+	*inszptr = __uinsz;
+
+#if 1
+	/* temporary workaround for the old implementation */
+	if (ret == -EAGAIN) {
+		*inszptr = 0;
+		return outsz;
+	}
+#endif
+
+	if (ret < 0) {
+		erofs_err("Failed to compress, ret[%d]", ret);
+		return EROFS_COMPRESS_ERROR;
+	}
+	return outsz;
+}
 
 static struct erofs_compr_alg erofs_compr_desc[EROFS_COMPR_ALG_MAX] = {
 	[EROFS_COMPR_NONE] = {
 		.ca_name    = "none",
 		.ca_idx     = EROFS_COMPR_NONE,
-		.ca_max_lvl = 0,
-		.ca_min_lvl = 0,
 		.ca_def_lvl = 0,
 		.ca_compress    = NULL,
 		.ca_init    = NULL,
 		.ca_deinit  = NULL,
 	},
 	[EROFS_COMPR_LZ4HC] = {
-		.ca_name    = "lz4hc",
-		.ca_idx     = EROFS_COMPR_LZ4HC,
-		.ca_max_lvl = LZ4HC_CLEVEL_MAX,
-		.ca_min_lvl = LZ4HC_CLEVEL_MIN,
-		.ca_def_lvl = EROFS_COMPR_LZ4HC_DEF_LVL,
-		.ca_compress    = erofs_lz4hc_compress,
-		.ca_init    = erofs_lz4hc_init,
-		.ca_deinit  = erofs_lz4hc_deinit,
+		.ca_name        = "lz4hc",
+		.ca_idx         = EROFS_COMPR_LZ4HC,
+		.ca_def_lvl     = EROFS_COMPR_LZ4HC_DEF_LVL,
+		.ca_compress    = __erofs_compress_destsize,
+		.ca_init        = erofs_lz4hc_init,
+		.ca_deinit      = __erofs_deinit,
+	},
+	[EROFS_COMPR_ZLIB] = {
+		.ca_name    = "zlib",
+		.ca_idx     = EROFS_COMPR_ZLIB,
+		.ca_def_lvl = EROFS_COMPR_ZLIB_DEF_LVL,
+		.ca_compress = __erofs_compress_destsize,
+		.ca_init     = erofs_zlib_init,
+		.ca_deinit   = __erofs_deinit,
 	},
 };
 
 void erofs_compress_alg_init(const char *name)
 {
-	int level;
 	struct erofs_compr_alg *alg;
 
 	if (!name) {
@@ -57,8 +116,11 @@ void erofs_compress_alg_init(const char *name)
 	erofs_cfg.c_compr_alg   = alg;
 	erofs_cfg.c_compr_maxsz = BLK_ALIGN(EROFS_CONFIG_COMPR_MAX_SZ);
 
-	level = erofs_adjust_compress_level(alg, EROFS_COMPR_LZ4HC_DEF_LVL);
-	erofs_cfg.c_compr_lvl	 = level;
+	if (!alg || alg->ca_idx == EROFS_COMPR_NONE)
+		erofs_cfg.c_compr_lvl = 0;
+	else
+		erofs_cfg.c_compr_lvl	= alg->ca_def_lvl;
+
 	erofs_cfg.c_compr_boundary    = EROFS_CONFIG_COMPR_DEF_BOUNDARY;
 	erofs_cfg.c_compr_ratio_limit = EROFS_CONFIG_COMPR_RATIO_MAX_LIMIT;
 }
@@ -74,26 +136,6 @@ struct erofs_compr_alg *erofs_get_compress_alg(const char *name)
 	return NULL;
 }
 
-int erofs_adjust_compress_level(struct erofs_compr_alg *alg, int lvl)
-{
-	if (!alg || alg->ca_idx == EROFS_COMPR_NONE)
-		return 0;
-
-	if (lvl > alg->ca_max_lvl) {
-		erofs_err("Compress level(%d) is greater than max level(%d), adjust it to default level(%d).\n",
-			   lvl, alg->ca_max_lvl, EROFS_COMPR_LZ4HC_DEF_LVL);
-		return alg->ca_def_lvl;
-	}
-
-	if (lvl < alg->ca_min_lvl) {
-		erofs_err("Compress level(%d) is less than min level(%d), adjust it to default level(%d).\n",
-			   lvl, alg->ca_min_lvl, EROFS_COMPR_LZ4HC_DEF_LVL);
-		return alg->ca_def_lvl;
-	}
-
-	return lvl;
-}
-
 void *erofs_compress_init(struct erofs_compr_alg *alg)
 {
 	void *ctx;
diff --git a/mkfs/erofs_compressor.h b/mkfs/erofs_compressor.h
index b60f79d..2c8411b 100644
--- a/mkfs/erofs_compressor.h
+++ b/mkfs/erofs_compressor.h
@@ -16,6 +16,7 @@
 enum erofs_compr_algs {
 	EROFS_COMPR_NONE,
 	EROFS_COMPR_LZ4HC,
+	EROFS_COMPR_ZLIB,
 	EROFS_COMPR_ALG_MAX,
 };
 
@@ -28,8 +29,6 @@ typedef void (*deinit_func)(void *cctx);
 struct erofs_compr_alg {
 	char *ca_name;
 	int ca_idx;
-	int ca_max_lvl;
-	int ca_min_lvl;
 	int ca_def_lvl;
 	compress_func ca_compress;
 	init_func ca_init;
diff --git a/mkfs/erofs_lz4hc.c b/mkfs/erofs_lz4hc.c
deleted file mode 100644
index c6277c6..0000000
--- a/mkfs/erofs_lz4hc.c
+++ /dev/null
@@ -1,52 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * erofs_lz4hc.c
- *
- * Copyright (C) 2018 HUAWEI, Inc.
- *             http://www.huawei.com/
- * Created by Li Guifu <bluce.liguifu at huawei.com>
- */
-#include <errno.h>
-#define LZ4_HC_STATIC_LINKING_ONLY (1)
-#include <lz4hc.h>
-
-#include "erofs_error.h"
-#include "erofs_lz4hc.h"
-#include "erofs_compressor.h"
-#include "erofs_debug.h"
-
-void *erofs_lz4hc_init(void)
-{
-	LZ4_streamHC_t *ctx;
-
-	ctx = LZ4_createStreamHC();
-	if (!ctx) {
-		erofs_err("Cannot allocate LZ4HC context");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	return (void *)ctx;
-}
-
-void erofs_lz4hc_deinit(void *ctx)
-{
-	if (!ctx)
-		return;
-
-	LZ4_freeStreamHC((LZ4_streamHC_t *)ctx);
-}
-
-int64_t erofs_lz4hc_compress(char *in, size_t insz, char *out, size_t outsz,
-			     size_t *inszptr, int level, void *ctx)
-{
-	int count;
-
-	*inszptr = insz;
-	count = LZ4_compress_HC_destSize((LZ4_streamHC_t *)ctx, in, out,
-					 (int *)inszptr, outsz, level);
-	if (count <= 0) {
-		erofs_err("Failed to compress data by LZ4HC");
-		return EROFS_COMPRESS_ERROR;
-	}
-	return (int64_t)count;
-}
diff --git a/mkfs/erofs_lz4hc.h b/mkfs/erofs_lz4hc.h
deleted file mode 100644
index d80340a..0000000
--- a/mkfs/erofs_lz4hc.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0+ */
-/*
- * erofs_lz4hc.h
- *
- * Copyright (C) 2018 HUAWEI, Inc.
- *             http://www.huawei.com/
- * Created by Li Guifu <bluce.liguifu at huawei.com>
- */
-#ifndef __EROFS_LZ4HC_H__
-#define __EROFS_LZ4HC_H__
-
-#include <stdint.h>
-#include <lz4hc.h>
-
-#define EROFS_COMPR_LZ4HC_DEF_LVL (9)
-
-void *erofs_lz4hc_init(void);
-void erofs_lz4hc_deinit(void *ctx);
-int64_t erofs_lz4hc_compress(char *in, size_t insz, char *out, size_t outsz,
-			     size_t *inszptr, int level, void *);
-#endif
diff --git a/mkfs/mkfs_file.c b/mkfs/mkfs_file.c
index 382e9b6..262063c 100644
--- a/mkfs/mkfs_file.c
+++ b/mkfs/mkfs_file.c
@@ -317,30 +317,6 @@ erofs_compr_idx_host_to_disk(struct erofs_compr_idx *hidx,
 static int erofs_compress_inline_file_data(struct erofs_compr_info *cinfo,
 					   struct erofs_compr_ctx *ctx)
 {
-	int64_t compr_count;
-	size_t comprsz = 0;
-
-	assert(ctx->cc_srclen <= EROFS_BLKSIZE);
-	assert(ctx->cc_buflen >= 2 * EROFS_BLKSIZE);
-
-	compr_count = erofs_compress(cinfo->ci_alg,
-				     ctx->cc_srcbuf,
-				     ctx->cc_srclen,
-				     ctx->cc_dstbuf,
-				     EROFS_BLKSIZE,
-				     &comprsz,
-				     cinfo->ci_lvl);
-
-	if (compr_count == 0 || compr_count == EROFS_COMPRESS_ERROR) {
-		erofs_err("Failed to compress data by %s",
-			  cinfo->ci_alg->ca_name);
-		return -EIO;
-	}
-
-	assert(comprsz == (size_t)ctx->cc_srclen);
-
-	ctx->cc_dstlen = (int)compr_count;
-	ctx->cc_nidxs  = EROFS_COMPR_CTX_INLINED_DATA;
 	return 0;
 }
 
-- 
2.14.4
