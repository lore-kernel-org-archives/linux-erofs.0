From: bluce.liguifu@huawei.com (Li Guifu)
Date: Tue, 11 Dec 2018 22:27:19 +0800
Subject: [PREVIEW] [PATCH 3/5] erofs-mkfs: support to build a image from the
 specific root directory
In-Reply-To: <20181211142721.24451-1-bluce.liguifu@huawei.com>
References: <20181211142721.24451-1-bluce.liguifu@huawei.com>
Message-ID: <20181211142721.24451-4-bluce.liguifu@huawei.com>

Currently, regular files, directories, special files defined in POSIX
are supported and the generated image can be mounted by kernel.

Signed-off-by: Li Guifu <bluce.liguifu at huawei.com>
Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Fang Wei <fangwei1 at huawei.com>
---
 erofs_cache.c | 207 ++++++++++++
 erofs_cache.h |  58 ++++
 mkfs_file.c   | 290 +++++++++++++++++
 mkfs_file.h   |  79 +++++
 mkfs_inode.c  | 852 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs_inode.h  |  83 +++++
 mkfs_main.c   |  31 +-
 7 files changed, 1599 insertions(+), 1 deletion(-)
 create mode 100644 erofs_cache.c
 create mode 100644 erofs_cache.h
 create mode 100644 mkfs_file.c
 create mode 100644 mkfs_file.h
 create mode 100644 mkfs_inode.c
 create mode 100644 mkfs_inode.h

diff --git a/erofs_cache.c b/erofs_cache.c
new file mode 100644
index 0000000..5b80592
--- /dev/null
+++ b/erofs_cache.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs_cache.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Miao Xie <miaoxie at huawei.com>
+ */
+#include <string.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <errno.h>
+
+#include "erofs_types.h"
+#include "erofs_cache.h"
+#include "erofs_error.h"
+#include "erofs_debug.h"
+#include "erofs_io.h"
+#include "mkfs_erofs.h"
+#include "mkfs_inode.h"
+
+/* The 1st block is used for SUPER BLOCK, so skip it. */
+static u64 erofs_current_block = 1;
+static LIST_HEAD(erofs_global_blocks);
+static LIST_HEAD(erofs_free_blocks);
+static LIST_HEAD(erofs_full_blocks);
+
+/*
+ * Note: Since we reserved the 1st block for super block, so we can reuse
+ * this block number as a special number, we use it to tell the caller that
+ * there is NO ENOUGH FREE SPACE!!!!
+ *
+ * So the result value:
+ * !0 : Allocate the blocks successfully, this is block number of
+ *      the 1st block.
+ * 0  : ENOSPC, There is no enough space.
+ */
+u32 erofs_alloc_blocks(u32 nblocks)
+{
+	u32 blkaddr;
+	u64 devlen;
+
+	assert(nblocks);
+
+	devlen = dev_length();
+	if (erofs_current_block > (u64)UINT32_MAX ||
+	    erofs_current_block + nblocks > ((u64)UINT32_MAX) + 1 ||
+	    (erofs_current_block + nblocks) << EROFS_BLOCKSIZE_BITS > devlen) {
+		erofs_err("There is no enough free space(curr: %llu, need: %u, device blocks: %llu).",
+			  (unsigned long long)erofs_current_block, nblocks,
+			  (unsigned long long)devlen >> EROFS_BLOCKSIZE_BITS);
+		return 0;
+	}
+
+	blkaddr = (u32)erofs_current_block;
+	erofs_current_block += nblocks;
+
+	return blkaddr;
+}
+
+u64 erofs_get_total_blocks(void)
+{
+	return erofs_current_block;
+}
+
+block_buffer_t *erofs_alloc_multi_block_buffer(u32 nblocks)
+{
+	block_buffer_t *blk;
+	block_buffer_t *next;
+	block_buffer_t *first;
+	struct list_head blocks;
+	u32 blkaddr;
+	u32 i;
+	int ret;
+
+	init_list_head(&blocks);
+
+	for (i = 0; i < nblocks; i++) {
+		blk = (block_buffer_t *)malloc(sizeof(block_buffer_t));
+		if (!blk) {
+			erofs_err("Fail to alloc memory for block buffer");
+			ret = -ENOMEM;
+			goto free_block_buffer;
+		}
+		memset(blk, 0, sizeof(block_buffer_t));
+		init_list_head(&blk->bb_metadata_list);
+
+		list_add_tail(&blk->bb_global_node, &blocks);
+	}
+
+	blkaddr = erofs_alloc_blocks(nblocks);
+	if (!blkaddr) {
+		ret = -ENOSPC;
+		goto free_block_buffer;
+	}
+
+	first = list_first_entry(&blocks, block_buffer_t, bb_global_node);
+	list_for_each_entry_safe(blk, next, &blocks, bb_global_node) {
+		blk->bb_blkaddr = blkaddr;
+		blkaddr++;
+
+		list_del(&blk->bb_global_node);
+		list_add_tail(&blk->bb_global_node, &erofs_global_blocks);
+		list_add_tail(&blk->bb_alloc_node, &erofs_free_blocks);
+	}
+
+	return first;
+
+free_block_buffer:
+	list_for_each_entry_safe(blk, next, &blocks, bb_global_node) {
+		list_del(&blk->bb_global_node);
+		free(blk);
+	}
+	return ERR_PTR(ret);
+}
+
+block_buffer_t *erofs_alloc_single_block_buffer(void)
+{
+	return erofs_alloc_multi_block_buffer(1);
+}
+
+block_buffer_t *erofs_look_up_free_pos(int request_size)
+{
+	block_buffer_t *blk = NULL;
+
+	list_for_each_entry(blk, &erofs_free_blocks, bb_alloc_node) {
+		if ((request_size + blk->bb_free_slot * EROFS_SLOTSIZE) <
+		    EROFS_BLKSIZE)
+			return blk;
+	}
+
+	blk = erofs_alloc_single_block_buffer();
+	return blk;
+}
+
+int erofs_flush_all_blocks(void)
+{
+	struct block_buffer *blk;
+	struct erofs_meta_node *node;
+	struct erofs_node_info *inode;
+	struct erofs_index_info *index;
+	char *erofs_blk_buf;
+	char *pbuf;
+	int count;
+	int ret;
+	u32 addr;
+
+	erofs_blk_buf = malloc(EROFS_BLKSIZE);
+	if (!erofs_blk_buf)
+		return -ENOMEM;
+
+	list_for_each_entry(blk, &erofs_global_blocks, bb_global_node) {
+		pbuf = erofs_blk_buf;
+		memset(pbuf, 0, EROFS_BLKSIZE);
+
+		list_for_each_entry(node, &blk->bb_metadata_list, m_node) {
+			switch (node->m_type) {
+			case EROFS_META_INODE:
+				inode = (struct erofs_node_info *)node;
+
+				count = erofs_write_inode_buffer(inode, pbuf);
+				break;
+			case EROFS_META_INDEX:
+				index = (struct erofs_index_info *)node;
+
+				count = erofs_write_index_buffer(index, pbuf);
+				break;
+			default:
+				erofs_err("Wrong metadata type");
+				assert(0);
+			}
+
+			count = round_up(count, EROFS_SLOTSIZE);
+			assert(count == node->m_len);
+			pbuf += count;
+		}
+
+		addr = blk->bb_blkaddr;
+
+		ret = dev_write(
+			erofs_blk_buf, BLKNO_TO_ADDR(addr), EROFS_BLKSIZE);
+		if (ret)
+			break;
+	}
+
+	free(erofs_blk_buf);
+
+	return ret;
+}
+
+void erofs_put_block_buffer(struct block_buffer *blk)
+{
+	if (blk->bb_free_slot == MAX_NID_INDEX_PER_BLK) {
+		list_del(&blk->bb_alloc_node);
+		list_add_tail(&blk->bb_alloc_node, &erofs_full_blocks);
+	} else if (blk->bb_free_slot > MAX_NID_INDEX_PER_BLK) {
+		erofs_err("block buffer overflow: free_slot = %d, MAX_NID_INDEX_PER_BLK = %d",
+			  blk->bb_free_slot, MAX_NID_INDEX_PER_BLK);
+		assert(0);
+	}
+}
+
+int erofs_cache_init(u64 start_blk)
+{
+	erofs_current_block = start_blk;
+	return 0;
+}
diff --git a/erofs_cache.h b/erofs_cache.h
new file mode 100644
index 0000000..ca0702a
--- /dev/null
+++ b/erofs_cache.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs_cache.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __EROFS_CACHE_H__
+#define __EROFS_CACHE_H__
+#include "mkfs_erofs.h"
+#include "list_head.h"
+
+enum erofs_meta_type {
+	EROFS_META_INODE,
+	EROFS_META_INDEX,
+	EROFS_META_MAX_TYPES,
+};
+
+struct erofs_meta_node {
+	struct list_head m_node;
+	struct block_buffer *m_blk;
+	int m_type;
+	int m_slot;
+	int m_len;
+};
+
+static inline void erofs_meta_node_init(struct erofs_meta_node *node, int type)
+{
+	init_list_head(&node->m_node);
+	node->m_type = type;
+	node->m_blk  = NULL;
+	node->m_slot = 0;
+	node->m_len  = 0;
+}
+
+typedef struct block_buffer {
+	/* These two members are used to block management. */
+	struct list_head bb_global_node;
+	struct list_head bb_alloc_node;
+
+	/* This is the head of all metadata which is hold in this block. */
+	struct list_head bb_metadata_list;
+
+	u32 bb_blkaddr;
+	int bb_free_slot;
+} block_buffer_t;
+
+block_buffer_t *erofs_alloc_single_block_buffer(void);
+block_buffer_t *erofs_alloc_multi_block_buffer(u32 nblocks);
+block_buffer_t *erofs_look_up_free_pos(int request_size);
+int erofs_flush_all_blocks(void);
+int erofs_cache_init(u64 start_blk);
+void erofs_cache_deinit(void);
+u32 erofs_alloc_blocks(u32 nblocks);
+void erofs_put_block_buffer(struct block_buffer *blk);
+u64 erofs_get_total_blocks(void);
+#endif
diff --git a/mkfs_file.c b/mkfs_file.c
new file mode 100644
index 0000000..a7be11f
--- /dev/null
+++ b/mkfs_file.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * mkfs_file.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#define _LARGEFILE64_SOURCE
+#include <assert.h>
+#include <libgen.h>
+#include <stdio.h>
+#include <inttypes.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <string.h>
+#include <dirent.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <linux/kdev_t.h>
+
+#ifndef O_BINARY
+#define O_BINARY 0
+#endif
+#include "erofs_types.h"
+#include "list_head.h"
+#include "erofs_cache.h"
+
+#define pr_fmt(fmt) "MKFS-FILE: " FUNC_LINE_FMT fmt "\n"
+#include "erofs_debug.h"
+
+#include "mkfs_erofs.h"
+#include "mkfs_file.h"
+#include "mkfs_inode.h"
+#include "erofs_io.h"
+
+#define DIRENT_MAX_NAME_LEN 256
+
+static u8 get_file_type(struct stat64 *st)
+{
+	u8 file_type = EROFS_FT_MAX;
+
+	switch (st->st_mode & S_IFMT) {
+	case S_IFREG:
+		file_type = EROFS_FT_REG_FILE;
+		break;
+
+	case S_IFDIR:
+		file_type = EROFS_FT_DIR;
+		break;
+
+	case S_IFLNK:
+		file_type = EROFS_FT_SYMLINK;
+		break;
+
+	case S_IFCHR:
+		file_type = EROFS_FT_CHRDEV;
+		break;
+
+	case S_IFBLK:
+		file_type = EROFS_FT_BLKDEV;
+		break;
+
+	case S_IFIFO:
+		file_type = EROFS_FT_FIFO;
+		break;
+
+	case S_IFSOCK:
+		file_type = EROFS_FT_SOCK;
+		break;
+
+	default:
+		erofs_err("file type[0x%X]", st->st_mode & S_IFMT);
+		break;
+	}
+
+	return file_type;
+}
+
+static inline u32 new_encode_dev(dev_t dev)
+{
+	unsigned int major = MAJOR(dev);
+	unsigned int minor = MINOR(dev);
+
+	return (minor & 0xff) | (major << 8) | ((minor & ~0xff) << 12);
+}
+
+struct erofs_node_info *erofs_init_inode(char *full_path_name)
+{
+	int ret;
+	struct stat64 st;
+	struct erofs_node_info *inode = NULL;
+	char *file_name		      = NULL;
+
+	file_name = strrchr(full_path_name, '/');
+	if (!file_name)
+		file_name = full_path_name;
+	else
+		file_name = file_name + 1;
+
+	inode = alloc_erofs_node();
+	if (!inode) {
+		erofs_err("inode is NULL, alloc failed");
+		goto Err_alloc;
+	}
+
+	ret = snprintf(inode->i_name, MAX_NAME, "%s", file_name);
+	if (ret < 0 || ret >= MAX_PATH) {
+		erofs_err("snprintf errorly file_name[%s] ret[%d]",
+			  file_name,
+			  ret);
+		goto Err_alloced;
+	}
+	ret = snprintf(inode->i_fullpath, MAX_PATH, "%s", full_path_name);
+	if (ret < 0 || ret >= MAX_PATH) {
+		erofs_err("snprintf errorly full_path_name[%s] ret[%d]",
+			  full_path_name,
+			  ret);
+		goto Err_alloced;
+	}
+
+	ret = lstat64(inode->i_fullpath, &st);
+	if (ret) {
+		erofs_err("stat failed path[%s]", inode->i_fullpath);
+		goto Err_alloced;
+	}
+
+	/* It is ugly code that is for old code everywhere */
+	inode->i_mode  = st.st_mode;
+	inode->i_uid   = st.st_uid;
+	inode->i_gid   = st.st_gid;
+	inode->i_nlink = st.st_nlink;
+	inode->i_type  = get_file_type(&st);
+
+	if (S_ISCHR(st.st_mode) || S_ISBLK(st.st_mode) ||
+	    S_ISFIFO(st.st_mode) || S_ISSOCK(st.st_mode)) {
+		inode->i_rdev = new_encode_dev(st.st_rdev);
+		inode->i_size = 0;
+	} else {
+		inode->i_size = st.st_size;
+	}
+
+	return inode;
+
+Err_alloced:
+	free(inode);
+
+Err_alloc:
+	return NULL;
+}
+
+int erofs_create_files_list(struct erofs_node_info *inode)
+{
+	int ret    = 0;
+	u64 d_size = 0;
+	DIR *dirp  = NULL;
+	char file_path[MAX_PATH + 1];
+	struct stat64 s;
+	struct dirent *dp;
+	struct list_head *pos;
+	struct erofs_node_info *dl;
+
+	if (!strncmp(inode->i_name, "lost+found", strlen("lost+found")))
+		return 0;
+
+	if (lstat64(inode->i_fullpath, &s) == 0) {
+		if (S_ISREG(s.st_mode)) {
+			erofs_err("[%s] is a regular file",
+				  inode->i_fullpath);
+			ret = -ENOTDIR;
+			goto error;
+		}
+	} else {
+		erofs_err("stat failed [%s]", inode->i_fullpath);
+		ret = -ENOENT;
+		goto error;
+	}
+
+	dirp = opendir(inode->i_fullpath);
+	if (!dirp) {
+		erofs_info("dirp is NULL dir=%s errno=%s",
+			   inode->i_fullpath,
+			   strerror(errno));
+		ret = -errno;
+		goto error;
+	}
+
+	errno = 0;
+	while ((dp = readdir(dirp)) != NULL) {
+		if (!strcmp(dp->d_name, ".") || !strcmp(dp->d_name, ".."))
+			continue;
+
+		ret = snprintf(file_path, MAX_PATH, "%s/%s",
+			       inode->i_fullpath, dp->d_name);
+		if (ret < 0 || ret >= MAX_PATH) {
+			erofs_err("snprintf errorly ret[%d]", ret);
+			ret = -ENOMEM;
+			goto error;
+		}
+		dl = erofs_init_inode(file_path);
+		if (!dl) {
+			erofs_err("init inode failed !!");
+			ret = -ENOENT;
+			goto error;
+		}
+
+		dl->i_iver = erofs_check_disk_inode_version(dl);
+		list_add_sort(&inode->i_subdir_head, dl);
+	}
+
+	if (errno != 0) {
+		erofs_err("inode[%s] error[%s]",
+			  inode->i_name, strerror(EBADF));
+		ret = -errno;
+		goto error;
+	}
+
+	list_for_each(pos, &inode->i_subdir_head) {
+		struct erofs_node_info *d =
+			container_of(pos, struct erofs_node_info, i_list);
+		if (((d_size & (EROFS_BLKSIZE - 1)) + EROFS_DIRENT_SIZE +
+		     strlen(d->i_name)) > EROFS_BLKSIZE) {
+			d_size = round_up(d_size, EROFS_BLKSIZE);
+		}
+		d_size += EROFS_DIRENT_SIZE + strlen(d->i_name);
+	}
+	inode->i_size = d_size;
+
+	list_for_each(pos, &inode->i_subdir_head) {
+		struct erofs_node_info *d =
+			container_of(pos, struct erofs_node_info, i_list);
+		if (d->i_type == EROFS_FT_DIR) {
+			ret = erofs_create_files_list(d);
+			if (ret < 0)
+				goto error;
+		}
+	}
+
+	closedir(dirp);
+	return 0;
+error:
+	return ret;
+}
+
+int list_add_sort(struct list_head *head, struct erofs_node_info *inode)
+{
+	struct list_head *pos;
+
+	if (list_empty(head)) {
+		list_add(&inode->i_list, head);
+		return 0;
+	}
+
+	list_for_each(pos, head) {
+		struct erofs_node_info *d =
+			container_of(pos, struct erofs_node_info, i_list);
+
+		if (strcmp(d->i_name, inode->i_name) <= 0)
+			continue;
+
+		list_add_tail(&inode->i_list, &d->i_list);
+		return 0;
+	}
+
+	list_add_tail(&inode->i_list, head);
+	return 0;
+}
+
+struct erofs_node_info *alloc_erofs_node(void)
+{
+	struct erofs_node_info *f = calloc(sizeof(struct erofs_node_info), 1);
+
+	if (!f) {
+		erofs_err("calloc failed!!!");
+		return NULL;
+	}
+
+	f->i_inline_align_size = EROFS_INLINE_GENERIC_ALIGN_SIZE;
+	erofs_meta_node_init(&f->i_meta_node, EROFS_META_INODE);
+	init_list_head(&f->i_subdir_head);
+	init_list_head(&f->i_compr_idxs_list);
+	init_list_head(&f->i_xattr_head);
+
+	return f;
+}
diff --git a/mkfs_file.h b/mkfs_file.h
new file mode 100644
index 0000000..3b23d00
--- /dev/null
+++ b/mkfs_file.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * mkfs_file.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __MKFS_FILE_H
+#define __MKFS_FILE_H
+
+#include <assert.h>
+#include <stdint.h>
+#include <sys/types.h>
+#include <stdio.h>
+#include <unistd.h>
+#include "list_head.h"
+#include "mkfs_erofs.h"
+
+#define FILE_TYPE_NONE (0)
+#define FILE_TYPE_COMPR (1)
+#define FILE_TYPE_MAX (2)
+
+/*
+ * Some micros for generic compress index conversion:
+ * CIG: Compress Index Generic
+ * D0: Delta0
+ * D1: Delta1
+ * LO: low 4 bits
+ * HI: high 4 bits
+ */
+#define EROFS_CIG_D0_LO_MASK (0xF)
+#define EROFS_CIG_D0_LO_SHL (12)
+#define EROFS_CIG_D0_HI_MASK (0xF0)
+#define EROFS_CIG_D0_HI_SHR (0)
+#define EROFS_CIG_D1_SHIFT (8)
+
+struct erofs_compr_idx {
+	u16 di_advise;
+	u16 di_clusterofs;
+	u16 delta[2]; /* [0] - relative index to the 1st block */
+	/* [1] - relative index to the last block */
+	u32 blkaddr;
+};
+
+/* cc_nidxs == -1 means it is a inlined compress data */
+#define EROFS_COMPR_CTX_INLINED_DATA (-1)
+
+struct erofs_compr_ctx {
+	char *cc_srcbuf;
+	char *cc_dstbuf;
+	u64 cc_pos;
+	int cc_buflen;
+	int cc_srclen;
+	int cc_dstlen;
+	struct erofs_compr_idx *cc_idxs;
+	int cc_nidxs;
+};
+
+struct erofs_compr_info {
+	struct erofs_compr_alg *ci_alg;
+	int ci_lvl;
+};
+
+struct erofs_node_info;
+
+struct erofs_node_info *alloc_erofs_node(void);
+struct erofs_node_info *erofs_init_inode(char *full_path_name);
+int list_add_sort(struct list_head *head, struct erofs_node_info *entry);
+void dump_inode(struct erofs_inode_v1 *inode);
+int erofs_create_files_list(struct erofs_node_info *entry);
+u32 erofs_calc_inline_data_size(struct erofs_node_info *inode);
+int erofs_check_compressible(struct erofs_node_info *inode);
+int erofs_compress_file(struct erofs_node_info *inode);
+void erofs_dump_compr_radio(void);
+int erofs_init_compress_context(struct erofs_compr_ctx *ctx);
+void erofs_deinit_compress_context(struct erofs_compr_ctx *ctx);
+void erofs_reset_compress_context(struct erofs_compr_ctx *ctx);
+#endif
diff --git a/mkfs_inode.c b/mkfs_inode.c
new file mode 100644
index 0000000..7271ab6
--- /dev/null
+++ b/mkfs_inode.c
@@ -0,0 +1,852 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * mkfs_inode.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <inttypes.h>
+#include <libgen.h>
+
+#include "erofs_cache.h"
+#include "erofs_error.h"
+#include "mkfs_erofs.h"
+#include "mkfs_file.h"
+#include "mkfs_inode.h"
+#include "erofs_io.h"
+
+#define pr_fmt(fmt) "MKFS_INODE: " FUNC_LINE_FMT fmt "\n"
+#include "erofs_debug.h"
+
+extern struct erofs_super_block *sb;
+
+u32 erofs_calc_inode_base_size(struct erofs_node_info *inode)
+{
+	u32 size;
+
+	if (inode->i_iver == EROFS_INODE_LAYOUT_V1)
+		size = EROFS_INODE_V1_SIZE;
+	else
+		size = EROFS_INODE_V2_SIZE;
+
+	return size;
+}
+
+u32 erofs_calc_inline_data_size(struct erofs_node_info *inode)
+{
+	u32 size = erofs_calc_inode_base_size(inode);
+
+	if (size >= EROFS_BLKSIZE)
+		return 0;
+	else
+		return (EROFS_BLKSIZE - size);
+}
+
+static inline u64 erofs_calc_compr_index_count(struct erofs_node_info *inode)
+{
+	return round_up(inode->i_size, EROFS_BLKSIZE) / EROFS_BLKSIZE;
+}
+
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
+u8 erofs_check_disk_inode_version(struct erofs_node_info *inode)
+{
+#if 1
+	(void)inode;
+	return EROFS_INODE_LAYOUT_V1;
+#else
+	/*
+	 * Check if the members of v0 inode structure can hold the data,
+	 * Check Item:
+	 * - i_size: 32bits vs 64 bits
+	 * - i_uid:  16bits vs 32bits
+	 * - i_gid:  16bits vs 32bits
+	 * - i_nlink:16bits vs 32bits
+	 * - i_ctime:If it is set or not
+	 */
+#endif
+}
+
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
+void mkfs_rank_inode(struct erofs_node_info *inode)
+{
+	block_buffer_t *blk;
+	block_buffer_t *next;
+	struct erofs_meta_node *node;
+	struct erofs_index_info *indexes;
+	u64 request_size;
+	u64 noninline_nidxs;
+	u64 first_idx;
+	u64 idx_nblks;
+	int nidxs;
+	int inline_size = 0;
+
+	node	 = &inode->i_meta_node;
+	request_size = erofs_calc_inode_base_size(inode);
+
+	request_size = round_up(request_size, inode->i_inline_align_size);
+
+	if (inode->i_dmode == EROFS_INODE_LAYOUT_INLINE) {
+		inline_size = inode->i_size % EROFS_BLKSIZE;
+		/* we put inode into inline mode asasp */
+		if (inline_size + request_size > EROFS_BLKSIZE) {
+			erofs_err("inode[%s] inline data overflow  i_size=%u slots size=%d",
+				  inode->i_name, inode->i_dmode, inline_size);
+			assert(0);
+		}
+
+	} else if (inode->i_dmode == EROFS_INODE_LAYOUT_COMPRESSION) {
+		inline_size += inode->i_inline_datalen;
+
+		/* we put inode into inline mode asasp */
+		if (inline_size + request_size > EROFS_BLKSIZE) {
+			erofs_err("inode[%s] inline data overflow  i_size=%" PRIu64 " slots size=%d",
+				  inode->i_name, inode->i_size, inline_size);
+			assert(0);
+		}
+	}
+	request_size += inline_size;
+
+	/*
+	 * If no compress indexes or all indexes are inlined, noninline_nidxs
+	 * should be zero.
+	 */
+	noninline_nidxs = inode->i_compr_nidxs - inode->i_compr_inlined_nidxs;
+	idx_nblks       = noninline_nidxs * EROFS_DECOMPR_IDX_SZ;
+	idx_nblks       = round_up(idx_nblks, EROFS_BLKSIZE) / EROFS_BLKSIZE;
+
+	if (idx_nblks) {
+		assert(request_size == EROFS_BLKSIZE);
+
+		blk = erofs_alloc_multi_block_buffer(idx_nblks + 1);
+	} else {
+		blk = erofs_look_up_free_pos(request_size);
+	}
+
+	if (IS_ERR(blk))
+		assert(0);
+
+	node->m_blk  = blk;
+	node->m_slot = blk->bb_free_slot;
+	node->m_len  = round_up(request_size, EROFS_SLOTSIZE);
+	list_add_tail(&node->m_node, &blk->bb_metadata_list);
+	inode->i_base_addr = BLKNO_TO_ADDR(blk->bb_blkaddr) +
+			     blk->bb_free_slot * EROFS_SLOTSIZE;
+	blk->bb_free_slot += node->m_len / EROFS_SLOTSIZE;
+	next = list_next_entry(blk, bb_global_node);
+	erofs_put_block_buffer(blk);
+	blk       = next;
+	first_idx = inode->i_compr_inlined_nidxs;
+
+	while (noninline_nidxs) {
+		if (noninline_nidxs >= EROFS_DECOMPR_IDXS_PER_BLK) {
+			nidxs	= EROFS_DECOMPR_IDXS_PER_BLK;
+			request_size = EROFS_BLKSIZE;
+		} else {
+			nidxs	= noninline_nidxs;
+			request_size = nidxs * EROFS_DECOMPR_IDX_SZ;
+			request_size = round_up(request_size, EROFS_SLOTSIZE);
+		}
+
+		indexes = malloc(sizeof(*indexes) + request_size);
+		if (!indexes) {
+			erofs_err("Failed to alloc memory for index info structure");
+			exit(EXIT_FAILURE);
+		}
+
+		erofs_meta_node_init(&indexes->i_meta_node, EROFS_META_INDEX);
+		indexes->i_1st_idx = first_idx;
+		indexes->i_nidxs   = nidxs;
+		memset(indexes->i_idxs, 0, request_size);
+		list_add_tail(&indexes->i_node, &inode->i_compr_idxs_list);
+
+		node	 = &indexes->i_meta_node;
+		node->m_blk  = blk;
+		node->m_type = EROFS_META_INDEX;
+
+		node->m_slot = blk->bb_free_slot;
+		blk->bb_free_slot += request_size / EROFS_SLOTSIZE;
+
+		node->m_len = request_size;
+		list_add_tail(&node->m_node, &blk->bb_metadata_list);
+
+		noninline_nidxs -= nidxs;
+		first_idx += nidxs;
+
+		next = list_next_entry(blk, bb_global_node);
+		erofs_put_block_buffer(blk);
+		blk = next;
+	}
+}
+
+struct erofs_node_info *mkfs_prepare_root_inode(char *root)
+{
+	if (!root)
+		return NULL;
+	return erofs_init_inode(root);
+}
+
+int mkfs_relocate_sub_inodes(struct erofs_node_info *inode)
+{
+	int ret;
+	u32 blkaddr;
+	u32 nblocks;
+	u32 unaligned;
+	struct erofs_node_info *d = inode;
+
+	switch (d->i_type) {
+	case EROFS_FT_REG_FILE:
+	case EROFS_FT_DIR:
+	case EROFS_FT_SYMLINK:
+		unaligned = d->i_size % EROFS_BLKSIZE;
+		nblocks   = d->i_size / EROFS_BLKSIZE;
+
+		if (unaligned > erofs_calc_inline_data_size(d) ||
+		    (unaligned == 0 && nblocks != 0)) {
+			d->i_dmode = EROFS_INODE_LAYOUT_PLAIN;
+			mkfs_rank_inode(d);
+
+			if (unaligned != 0)
+				nblocks++;
+			blkaddr = erofs_alloc_blocks(nblocks);
+			if (!blkaddr)
+				return -ENOSPC;
+
+			d->i_blkaddr = blkaddr;
+		} else {
+			d->i_dmode	  = EROFS_INODE_LAYOUT_INLINE;
+			d->i_inline_datalen = unaligned;
+			mkfs_rank_inode(d);
+
+			if (nblocks > 0) {
+				blkaddr = erofs_alloc_blocks(nblocks);
+				if (!blkaddr)
+					return -ENOSPC;
+
+				d->i_blkaddr = blkaddr;
+			} else {
+				d->i_blkaddr = 0;
+			}
+		}
+		break;
+	case EROFS_FT_BLKDEV:
+	case EROFS_FT_CHRDEV:
+	case EROFS_FT_FIFO:
+	case EROFS_FT_SOCK:
+		mkfs_rank_inode(d);
+		break;
+
+	default:
+		erofs_err("inode[%s] file_type error =%d",
+			  d->i_fullpath,
+			  d->i_type);
+		return -EINVAL;
+	}
+
+	list_for_each_entry(d, &inode->i_subdir_head, i_list) {
+		ret = mkfs_relocate_sub_inodes(d);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static u32 write_dirents(char *buf, u32 sum, struct list_head *start,
+			 struct list_head *end)
+{
+	char *pbuf       = buf;
+	u32 size	 = 0;
+	u32 base_nameoff = 0;
+	struct erofs_dirent dirent;
+	struct list_head *start_tmp = NULL;
+
+	base_nameoff = sum * EROFS_DIRENT_SIZE;
+	start_tmp    = start;
+	while (start_tmp != end) {
+		struct erofs_node_info *d =
+			container_of(start_tmp, struct erofs_node_info, i_list);
+		u32 name_len = strlen(d->i_name);
+
+		d->i_nameoff = base_nameoff;
+		memcpy(pbuf + base_nameoff, d->i_name, name_len);
+		base_nameoff += name_len;
+		start_tmp = start_tmp->next;
+	}
+
+	start_tmp = start;
+	while (start_tmp != end) {
+		struct erofs_node_info *d =
+			container_of(start_tmp, struct erofs_node_info, i_list);
+		memset(&dirent, 0, EROFS_DIRENT_SIZE);
+
+		dirent.nid = cpu_to_le64(mkfs_addr_to_nid(d->i_base_addr));
+		dirent.file_type = d->i_type;
+		dirent.nameoff   = cpu_to_le16(d->i_nameoff);
+		memcpy(pbuf + size, &dirent, EROFS_DIRENT_SIZE);
+		size += EROFS_DIRENT_SIZE;
+		start_tmp = start_tmp->next;
+	}
+	assert(base_nameoff <= EROFS_BLKSIZE);
+
+	return base_nameoff;
+}
+static int mkfs_write_inode_dir(struct erofs_node_info *inode)
+{
+	struct list_head *pos;
+	struct list_head *start;
+	u32 sum		 = 0;
+	u32 blk_cnt      = 0;
+	u32 dentrys_size = 0;
+	char *pbuf       = NULL;
+	int ret		 = 0;
+
+	/* dentrys were at inline area */
+	if (inode->i_dmode == EROFS_INODE_LAYOUT_INLINE) {
+		start = (&inode->i_subdir_head)->next;
+		/* dentry begin from the next block offset to inode,
+		 * so page_num should be 1
+		 */
+		pbuf = calloc(EROFS_BLKSIZE, 1);
+
+		if (!pbuf) {
+			erofs_err("calloc inode[%s] error[%s]",
+				  inode->i_fullpath,
+				  strerror(errno));
+			return -ENOMEM;
+		}
+
+		list_for_each(pos, &inode->i_subdir_head)
+		{
+			struct erofs_node_info *d;
+			u32 len;
+
+			d   = container_of(pos, struct erofs_node_info, i_list);
+			len = strlen(d->i_name);
+
+			if (dentrys_size + EROFS_DIRENT_SIZE + len >
+			    EROFS_BLKSIZE) {
+				const u32 addr = inode->i_blkaddr + blk_cnt;
+
+				write_dirents(pbuf, sum, start, pos);
+				ret = dev_write(pbuf,
+						BLKNO_TO_ADDR(addr),
+						EROFS_BLKSIZE);
+				if (ret < 0) {
+					erofs_err(
+						"dev_write inode[%s] error[%s]",
+						inode->i_fullpath,
+						strerror(errno));
+					return ret;
+				}
+
+				blk_cnt += 1;
+				sum	  = 0;
+				dentrys_size = 0;
+				start	= pos;
+			}
+
+			dentrys_size += EROFS_DIRENT_SIZE + len;
+			sum += 1;
+		}
+
+		/* write last page names */
+		if (start != pos) {
+			s32 len = write_dirents(pbuf, sum, start, pos);
+
+			inode->i_inline_data    = pbuf;
+			inode->i_inline_datalen = len;
+		}
+
+	} else if (inode->i_dmode == EROFS_INODE_LAYOUT_PLAIN) {
+		start = (&inode->i_subdir_head)->next;
+		/* dentry begin from the next block offset to inode,
+		 * so page_num should be 1
+		 */
+		pbuf = calloc(EROFS_BLKSIZE, 1);
+		if (!pbuf) {
+			perror("calloc");
+			return -ENOMEM;
+		}
+
+		list_for_each(pos, &inode->i_subdir_head)
+		{
+			struct erofs_node_info *d;
+			u32 len;
+
+			d   = container_of(pos, struct erofs_node_info, i_list);
+			len = strlen(d->i_name);
+			if (dentrys_size + EROFS_DIRENT_SIZE + len >
+			    EROFS_BLKSIZE) {
+				const u32 addr = inode->i_blkaddr + blk_cnt;
+
+				write_dirents(pbuf, sum, start, pos);
+				dev_write(pbuf,
+					  BLKNO_TO_ADDR(addr),
+					  EROFS_BLKSIZE);
+				if (ret < 0) {
+					erofs_err(
+						"dev_write inode[%s] error[%s]",
+						inode->i_fullpath,
+						strerror(errno));
+					return ret;
+				}
+
+				blk_cnt += 1;
+				sum	  = 0;
+				dentrys_size = 0;
+				start	= pos;
+			}
+
+			dentrys_size += EROFS_DIRENT_SIZE + len;
+			sum += 1;
+		}
+
+		/* write last page names */
+		if (start != pos) {
+			const u32 addr = inode->i_blkaddr + blk_cnt;
+
+			write_dirents(pbuf, sum, start, pos);
+			ret = dev_write(
+				pbuf, BLKNO_TO_ADDR(addr), EROFS_BLKSIZE);
+			if (ret < 0) {
+				erofs_err("dev_write inode[%s] error[%s]",
+					  inode->i_fullpath,
+					  strerror(errno));
+				return ret;
+			}
+		}
+
+		free(pbuf);
+
+	} else {
+		erofs_err("inode->i_dmode[%u]mode 1 is not support right now",
+			  inode->i_dmode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
+{
+	char *pbuf     = NULL;
+	int ret	= 0;
+	u32 i	  = 0;
+	int fd	 = 0;
+	u32 nblocks    = 0;
+	int unaligned  = 0;
+	u32 page_cnt   = inode->i_size / EROFS_BLKSIZE;
+	char *filepath = inode->i_fullpath;
+
+	fd = open(filepath, O_RDONLY);
+	if (fd < 0) {
+		erofs_err("current path=%s filepath=%s",
+			  getcwd(NULL, 0),
+			  filepath);
+		return -errno;
+	}
+
+	switch (inode->i_dmode) {
+	case EROFS_INODE_LAYOUT_PLAIN:
+		if ((inode->i_size % EROFS_BLKSIZE) != 0)
+			page_cnt += 1;
+
+		pbuf = calloc(EROFS_BLKSIZE, 1);
+		if (!pbuf) {
+			erofs_err("calloc inode[%s] error[%s]",
+				  inode->i_fullpath,
+				  strerror(errno));
+			return -errno;
+		}
+
+		for (i = 0; i < page_cnt; i++) {
+			u32 addr;
+
+			ret = read(fd, pbuf, EROFS_BLKSIZE);
+			if (ret < 0) {
+				erofs_err("read inode[%s] error[%s]",
+					  filepath,
+					  strerror(errno));
+				return -errno;
+			}
+
+			addr = inode->i_blkaddr + i;
+
+			ret = dev_write(
+				pbuf, BLKNO_TO_ADDR(addr), EROFS_BLKSIZE);
+			if (ret < 0) {
+				erofs_err("dev_write inode[%s] ret[%d]",
+					  filepath,
+					  ret);
+				return ret;
+			}
+		}
+
+		free(pbuf);
+		break;
+
+	case EROFS_INODE_LAYOUT_COMPRESSION:
+	case EROFS_INODE_LAYOUT_INLINE:
+		if (inode->i_size == 0)
+			break;
+
+		nblocks   = inode->i_size / EROFS_BLKSIZE;
+		unaligned = inode->i_size % EROFS_BLKSIZE;
+		if (nblocks > 0) {
+			assert(inode->i_blkaddr != 0);
+
+			pbuf = calloc(EROFS_BLKSIZE, 1);
+			if (!pbuf) {
+				erofs_err("calloc inode[%s] error[%s]",
+					  inode->i_fullpath,
+					  strerror(errno));
+				return -errno;
+			}
+
+			for (i = 0; i < nblocks; i++) {
+				u32 addr;
+
+				ret = read(fd, pbuf, EROFS_BLKSIZE);
+				if (ret < 0) {
+					erofs_err("read inode[%s] error[%s]",
+						  filepath,
+						  strerror(errno));
+					exit(EXIT_FAILURE);
+				}
+				addr = inode->i_blkaddr + i;
+
+				ret = dev_write(pbuf,
+						BLKNO_TO_ADDR(addr),
+						EROFS_BLKSIZE);
+				if (ret < 0) {
+					erofs_err("dev_write inode[%s] ret[%d]",
+						  filepath,
+						  ret);
+					return ret;
+				}
+			}
+
+			free(pbuf);
+		}
+
+		if (unaligned > 0) {
+			s32 len;
+
+			inode->i_inline_data = calloc(EROFS_BLKSIZE, 1);
+			if (!inode->i_inline_data) {
+				erofs_err("calloc inode[%s] error[%s]",
+					  filepath,
+					  strerror(errno));
+				return -errno;
+			}
+
+			(void)lseek(fd, nblocks * EROFS_BLKSIZE, SEEK_SET);
+
+			len = read(fd, inode->i_inline_data, unaligned);
+			if (len < 0) {
+				erofs_err("read inode[%s] error[%s]",
+					  filepath,
+					  strerror(errno));
+				return -errno;
+			}
+			inode->i_inline_datalen = len;
+		}
+		break;
+
+	default:
+		erofs_err(
+			"Inode[%s] mode error [%d]", filepath, inode->i_dmode);
+		return -EINVAL;
+	}
+
+	close(fd);
+	return 0;
+}
+
+static int mkfs_write_inode_symfile(struct erofs_node_info *inode)
+{
+	char *pbuf = NULL;
+	int ret    = 0;
+
+	switch (inode->i_dmode) {
+	case EROFS_INODE_LAYOUT_PLAIN:
+		pbuf = calloc(EROFS_BLKSIZE, 1);
+		if (!pbuf) {
+			erofs_err("calloc inode[%s] error[%s]",
+				  inode->i_fullpath,
+				  strerror(errno));
+			return -errno;
+		}
+
+		ret = readlink(inode->i_fullpath, pbuf, inode->i_size);
+		if (ret < 0) {
+			erofs_err("readlink inode[%s] error[%s]",
+				  inode->i_fullpath,
+				  strerror(errno));
+			return -errno;
+		}
+
+		ret = dev_write(
+			pbuf, BLKNO_TO_ADDR(inode->i_blkaddr), EROFS_BLKSIZE);
+		if (ret < 0) {
+			erofs_err("dev_write inode[%s] error[%s]",
+				  inode->i_fullpath,
+				  strerror(errno));
+			return ret;
+		}
+		free(pbuf);
+		break;
+
+	case EROFS_INODE_LAYOUT_COMPRESSION:
+		break;
+
+	case EROFS_INODE_LAYOUT_INLINE:
+		if (inode->i_size == 0)
+			break;
+
+		inode->i_inline_data = calloc(EROFS_BLKSIZE, 1);
+		if (!inode->i_inline_data) {
+			perror("calloc");
+			return -errno;
+		}
+
+		inode->i_inline_datalen = readlink(
+			inode->i_fullpath, inode->i_inline_data, inode->i_size);
+		if (inode->i_inline_datalen < 0) {
+			perror("readlink");
+			return -errno;
+		}
+
+		break;
+
+	default:
+		erofs_err("Inode mode error [%d]", inode->i_dmode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int mkfs_do_write_inodes_data(struct erofs_node_info *inode)
+{
+	int ret;
+	struct list_head *pos;
+
+	switch (inode->i_type) {
+	case EROFS_FT_DIR:
+		ret = mkfs_write_inode_dir(inode);
+		if (ret)
+			return ret;
+		break;
+
+	case EROFS_FT_REG_FILE:
+		ret = mkfs_write_inode_regfile(inode);
+		if (ret)
+			return ret;
+		break;
+
+	case EROFS_FT_SYMLINK:
+		ret = mkfs_write_inode_symfile(inode);
+		if (ret)
+			return ret;
+		break;
+
+	default:
+		/* special devices file eg. chr block pipe sock */
+		break;
+	}
+
+	if (!list_empty(&inode->i_subdir_head)) {
+		list_for_each(pos, &inode->i_subdir_head)
+		{
+			struct erofs_node_info *d;
+
+			d   = container_of(pos, struct erofs_node_info, i_list);
+			ret = mkfs_do_write_inodes_data(d);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int erofs_do_write_inode_buffer(struct erofs_node_info *inode, char *buf)
+{
+	struct erofs_inode_v1 *v1;
+	struct erofs_inode_v2 *v2;
+
+	if (inode->i_iver == EROFS_INODE_LAYOUT_V1) {
+		v1 = (struct erofs_inode_v1 *)buf;
+		v1->i_advise = cpu_to_le16(inode->i_iver|(inode->i_dmode<<1));
+		v1->i_xattr_icount = cpu_to_le16(inode->i_xattr_scnt);
+		v1->i_mode = cpu_to_le16(inode->i_mode);
+		v1->i_nlink = cpu_to_le16((u16)inode->i_nlink);
+		v1->i_size = cpu_to_le32((u32)inode->i_size);
+		v1->i_ino = cpu_to_le32(inode->i_ino);
+		v1->i_uid = cpu_to_le16((u16)inode->i_uid);
+		v1->i_gid = cpu_to_le16((u16)inode->i_gid);
+
+		switch (inode->i_type) {
+		case EROFS_FT_CHRDEV:
+		case EROFS_FT_BLKDEV:
+		case EROFS_FT_FIFO:
+		case EROFS_FT_SOCK:
+			v1->i_u.rdev = cpu_to_le32(inode->i_rdev);
+			break;
+
+		default:
+			if (inode->i_dmode == EROFS_INODE_LAYOUT_COMPRESSION)
+				v1->i_u.compressed_blocks =
+					cpu_to_le32(inode->i_blocks);
+			else
+				v1->i_u.raw_blkaddr =
+					cpu_to_le32(inode->i_blkaddr);
+
+			break;
+		}
+
+		v1->i_checksum = 0;
+		return EROFS_INODE_V1_SIZE;
+	}
+
+	v2 = (struct erofs_inode_v2 *)buf;
+	v2->i_advise = cpu_to_le16(inode->i_iver|(inode->i_dmode<<1));
+	v2->i_xattr_icount = cpu_to_le16(inode->i_xattr_scnt);
+	v2->i_mode = cpu_to_le16(inode->i_mode);
+	v2->i_size = cpu_to_le64(inode->i_size);
+	v2->i_u.raw_blkaddr = cpu_to_le32(inode->i_blkaddr);
+	v2->i_ino = cpu_to_le32(inode->i_ino);
+	v2->i_uid = cpu_to_le32(inode->i_uid);
+	v2->i_gid = cpu_to_le32(inode->i_gid);
+	v2->i_ctime = cpu_to_le64(inode->i_ctime);
+	v2->i_ctime_nsec = cpu_to_le32(inode->i_ctime_nsec);
+	v2->i_nlink = cpu_to_le32(inode->i_nlink);
+
+	switch (inode->i_type) {
+	case EROFS_FT_CHRDEV:
+	case EROFS_FT_BLKDEV:
+	case EROFS_FT_FIFO:
+	case EROFS_FT_SOCK:
+		v2->i_u.rdev = cpu_to_le32(inode->i_rdev);
+		break;
+
+	default:
+		if (inode->i_dmode == EROFS_INODE_LAYOUT_COMPRESSION)
+			v2->i_u.compressed_blocks =
+				cpu_to_le32(inode->i_blocks);
+		else
+			v2->i_u.raw_blkaddr =
+				cpu_to_le32(inode->i_blkaddr);
+
+		break;
+	}
+
+	v2->i_checksum = 0;
+	return EROFS_INODE_V2_SIZE;
+}
+
+int erofs_write_inode_buffer(struct erofs_node_info *inode, char *buf)
+{
+	char *pbuf = buf;
+	int count  = 0;
+
+	count += erofs_do_write_inode_buffer(inode, pbuf + count);
+
+	switch (inode->i_dmode) {
+	/* Compress File */
+	case EROFS_INODE_LAYOUT_COMPRESSION:
+	/* Inline softlink or dir or file */
+	case EROFS_INODE_LAYOUT_INLINE:
+		count = round_up(count, inode->i_inline_align_size);
+		if (inode->i_size > 0) {
+			memcpy(pbuf + count,
+			       inode->i_inline_data,
+			       inode->i_inline_datalen);
+			count += inode->i_inline_datalen;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	count = SLOT_ALIGN(count);
+	return count;
+}
+
+int erofs_write_index_buffer(struct erofs_index_info *index, char *buf)
+{
+	int count;
+
+	assert(index->i_nidxs);
+
+	count = index->i_nidxs * EROFS_DECOMPR_IDX_SZ;
+	memcpy(buf, index->i_idxs, count);
+
+	return count;
+}
+
+u64 mkfs_addr_to_nid(u64 addr)
+{
+	if (!IS_SLOT_ALIGN(addr)) {
+		erofs_err("SLOT NOT ALIGN: addr=0x%08" PRIX64 "", addr);
+		exit(EXIT_FAILURE);
+	}
+	return (u64)((addr - (u64)sb->meta_blkaddr * EROFS_BLKSIZE) / 32);
+}
diff --git a/mkfs_inode.h b/mkfs_inode.h
new file mode 100644
index 0000000..100e788
--- /dev/null
+++ b/mkfs_inode.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs_inode.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef CONFIG_EROFS_MKFS_INODE_H
+#define CONFIG_EROFS_MKFS_INODE_H
+
+#include "list_head.h"
+#include "erofs_cache.h"
+#include "mkfs_file.h"
+
+#define MAX_PATH 4096
+#define MAX_NAME 256
+
+struct erofs_index_info {
+	/* Link to its block buffer */
+	struct erofs_meta_node i_meta_node;
+
+	/* Link to its inode */
+	struct list_head i_node;
+
+	u64 i_1st_idx;
+	s32 i_nidxs;
+	struct z_erofs_vle_decompressed_index i_idxs[0];
+};
+
+struct erofs_node_info {
+	struct erofs_meta_node i_meta_node;
+
+	/* Original member */
+	struct list_head i_list;
+	struct list_head i_subdir_head; /* sub dirs or files */
+	struct list_head i_xattr_head;
+
+	u64 i_base_addr;       /* base address of a inode */
+	char i_name[MAX_NAME]; /* the name of current inode */
+	char i_fullpath[MAX_PATH + 1];
+	u16 i_nameoff;
+	u16 i_iver;       /* Inode Version */
+	u16 i_dmode;      /* Data mode */
+	u16 i_xattr_scnt; /* Inline xattr space count */
+	u16 i_shared_count;
+	u16 i_mode;
+	u8 i_type; /* Inode type: File, Dir...*/
+	u64 i_size;
+	union {
+		u32 i_blkaddr;
+		u32 i_blocks;
+		u32 i_rdev;
+	};
+	u32 i_ino;
+	u32 i_uid;
+	u32 i_gid;
+	u64 i_ctime;
+	u32 i_ctime_nsec;
+	u32 i_nlink;
+
+	/* If compress file, we use it store index info */
+	char *i_inline_data;
+	s32 i_inline_datalen;
+	s32 i_inline_align_size;
+
+	struct erofs_compr_info i_compressor;
+	struct erofs_compr_ctx i_compr_ctx;
+	u64 i_compr_nidxs;
+	u32 i_compr_inlined_nidxs;
+	struct list_head i_compr_idxs_list;
+	struct erofs_index_info *i_compr_cur_index_info;
+};
+
+struct erofs_node_info *mkfs_prepare_root_inode(char *root);
+int mkfs_relocate_sub_inodes(struct erofs_node_info *droot);
+int mkfs_do_write_inodes_data(struct erofs_node_info *droot);
+u64 mkfs_addr_to_nid(u64 addr);
+int erofs_write_inode_buffer(struct erofs_node_info *inode, char *buf);
+int erofs_write_index_buffer(struct erofs_index_info *index, char *buf);
+u8 erofs_check_disk_inode_version(struct erofs_node_info *inode);
+
+#endif
diff --git a/mkfs_main.c b/mkfs_main.c
index c11c9b6..bb91067 100644
--- a/mkfs_main.c
+++ b/mkfs_main.c
@@ -126,6 +126,8 @@ void mkfs_update_erofs_header(u64 root_addr)
 	}
 
 	sb->meta_blkaddr = cpu_to_le32(ADDR_TO_BLKNO(size));
+	sb->blocks       = cpu_to_le32(erofs_get_total_blocks());
+	sb->root_nid     = cpu_to_le16(mkfs_addr_to_nid(root_addr));
 
 	sb_buf = calloc(size, 1);
 	if (!sb_buf) {
@@ -151,11 +153,38 @@ int main(int argc, char **argv)
 	mkfs_init_configure();
 	mkfs_parse_options_cfg(argc, argv);
 
+	proot_node = mkfs_prepare_root_inode(erofs_cfg.c_src_path);
+	if (!proot_node)
+		goto exit;
+	err = erofs_create_files_list(proot_node);
+	if (err)
+		goto exit;
+
+	err = erofs_cache_init(ADDR_TO_BLKNO(BLK_ALIGN(EROFS_SUPER_END)));
+	if (err)
+		goto exit;
+
+	err = mkfs_relocate_sub_inodes(proot_node);
+	if (err)
+		goto exit;
+
+	err = mkfs_do_write_inodes_data(proot_node);
+	if (err)
+		goto exit;
+
+	err = erofs_flush_all_blocks();
+	if (err)
+		goto exit;
+
 	mkfs_update_erofs_header(proot_node->i_base_addr);
 
+	erofs_info("done");
+
+exit:
 	dev_close();
 	mkfs_free_config();
-	erofs_info("done");
 
+	if (err)
+		erofs_err("\tError: Could not format the device!!!\n");
 	return err;
 }
-- 
2.17.1
