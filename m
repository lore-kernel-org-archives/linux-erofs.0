From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Jun 2018 21:40:20 +0800
Subject: [erofs-dev] [RFC PATCH RESEND 06/12] erofs: add directory operations
In-Reply-To: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
References: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1529588426-111662-7-git-send-email-gaoxiang25@huawei.com>

This adds functions for directory, mainly readdir.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/dir.c | 143 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)
 create mode 100644 fs/erofs/dir.c

diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
new file mode 100644
index 0000000..7d3448b
--- /dev/null
+++ b/fs/erofs/dir.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/dir.c
+ *
+ * Copyright (C) 2017-2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include "internal.h"
+
+const unsigned char erofs_filetype_table[EROFS_FT_MAX] = {
+	[EROFS_FT_UNKNOWN]	= DT_UNKNOWN,
+	[EROFS_FT_REG_FILE]	= DT_REG,
+	[EROFS_FT_DIR]		= DT_DIR,
+	[EROFS_FT_CHRDEV]	= DT_CHR,
+	[EROFS_FT_BLKDEV]	= DT_BLK,
+	[EROFS_FT_FIFO]		= DT_FIFO,
+	[EROFS_FT_SOCK]		= DT_SOCK,
+	[EROFS_FT_SYMLINK]	= DT_LNK,
+};
+
+static int erofs_fill_dentries(struct dir_context *ctx,
+	void *dentry_blk, unsigned *ofs,
+	unsigned nameoff, unsigned maxsize)
+{
+	struct erofs_dirent *de = dentry_blk;
+	const struct erofs_dirent *end = dentry_blk + nameoff;
+
+	de = dentry_blk + *ofs;
+	while (de < end) {
+		const char *de_name;
+		int de_namelen;
+		unsigned char d_type;
+#ifdef CONFIG_EROFS_FS_DEBUG
+		unsigned dbg_namelen;
+		unsigned char dbg_namebuf[EROFS_NAME_LEN];
+#endif
+
+		if (unlikely(de->file_type < EROFS_FT_MAX))
+			d_type = erofs_filetype_table[de->file_type];
+		else
+			d_type = DT_UNKNOWN;
+
+		de_name = (char *)dentry_blk + de->nameoff;
+
+		de_namelen = unlikely(de + 1 >= end) ?
+			/* last directory entry */
+			strnlen(de_name, maxsize - de->nameoff) :
+			de[1].nameoff - de->nameoff;
+
+		/* the corrupted directory found */
+		BUG_ON(de_namelen < 0);
+
+#ifdef CONFIG_EROFS_FS_DEBUG
+		dbg_namelen = min(EROFS_NAME_LEN - 1, de_namelen);
+		memcpy(dbg_namebuf, de_name, dbg_namelen);
+		dbg_namebuf[dbg_namelen] = '\0';
+
+		debugln("%s, found de_name %s de_len %d d_type %d", __func__,
+			dbg_namebuf, de_namelen, d_type);
+#endif
+
+		if (!dir_emit(ctx, de_name, de_namelen, de->nid, d_type))
+			/* stoped by some reason */
+			return 1;
+		++de;
+		*ofs += sizeof(struct erofs_dirent);
+	}
+	*ofs = maxsize;
+	return 0;
+}
+
+static int erofs_readdir(struct file *f, struct dir_context *ctx)
+{
+	struct inode *dir = file_inode(f);
+	struct address_space *mapping = dir->i_mapping;
+	const size_t dirsize = i_size_read(dir);
+	unsigned i = ctx->pos / EROFS_BLKSIZ;
+	unsigned ofs = ctx->pos % EROFS_BLKSIZ;
+	int err = 0;
+	bool initial = true;
+
+	while (ctx->pos < dirsize) {
+		struct page *dentry_page;
+		struct erofs_dirent *de;
+		unsigned nameoff, maxsize;
+
+		dentry_page = read_mapping_page(mapping, i, NULL);
+		if (IS_ERR(dentry_page))
+			continue;
+
+		lock_page(dentry_page);
+		de = (struct erofs_dirent *)kmap(dentry_page);
+
+		nameoff = de->nameoff;
+
+		if (unlikely(nameoff < sizeof(struct erofs_dirent) ||
+			nameoff >= PAGE_SIZE)) {
+			errln("%s, invalid de[0].nameoff %u",
+				__func__, nameoff);
+
+			err = -EIO;
+			goto skip_this;
+		}
+
+		maxsize = min_t(unsigned, dirsize - ctx->pos + ofs, PAGE_SIZE);
+
+		/* search dirents at the arbitrary position */
+		if (unlikely(initial)) {
+			initial = false;
+
+			ofs = roundup(ofs, sizeof(struct erofs_dirent));
+			if (unlikely(ofs >= nameoff))
+				goto skip_this;
+		}
+
+		err = erofs_fill_dentries(ctx, de, &ofs, nameoff, maxsize);
+skip_this:
+		kunmap(dentry_page);
+
+		unlock_page(dentry_page);
+		put_page(dentry_page);
+
+		ctx->pos = i * EROFS_BLKSIZ + ofs;
+
+		if (unlikely(err))
+			break;
+		++i;
+		ofs = 0;
+	}
+	return err < 0 ? err : 0;
+}
+
+const struct file_operations erofs_dir_fops = {
+	.llseek		= generic_file_llseek,
+	.read		= generic_read_dir,
+	.iterate	= erofs_readdir,
+};
+
-- 
1.9.1
