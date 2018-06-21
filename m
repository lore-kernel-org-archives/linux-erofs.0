From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Jun 2018 21:40:19 +0800
Subject: [erofs-dev] [RFC PATCH RESEND 05/12] erofs: add inode operations
In-Reply-To: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
References: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1529588426-111662-6-git-send-email-gaoxiang25@huawei.com>

This adds core functions to get, read an inode.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/inode.c | 222 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 222 insertions(+)
 create mode 100644 fs/erofs/inode.c

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
new file mode 100644
index 0000000..94f8ce5
--- /dev/null
+++ b/fs/erofs/inode.c
@@ -0,0 +1,222 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/inode.c
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
+#include <linux/slab.h>
+
+/* no locking */
+static int read_inode(struct inode *inode, void *data)
+{
+	struct erofs_vnode *vi = EROFS_V(inode);
+	struct erofs_inode_v1 *v1 = data;
+	unsigned advise = le16_to_cpu(v1->i_advise);
+
+	vi->data_mapping_mode = __inode_data_mapping(advise);
+	BUG_ON(vi->data_mapping_mode >= EROFS_INODE_LAYOUT_MAX);
+
+	if (__inode_version(advise) == EROFS_INODE_V2) {
+		struct erofs_inode_v2 *v2 = data;
+
+		vi->inode_isize = sizeof(struct erofs_inode_v2);
+		vi->xattr_isize = ondisk_xattr_ibody_size(v2->i_xattr_icount);
+
+		vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
+		inode->i_mode = le16_to_cpu(v2->i_mode);
+
+		i_uid_write(inode, le32_to_cpu(v2->i_uid));
+		i_gid_write(inode, le32_to_cpu(v2->i_gid));
+		set_nlink(inode, le32_to_cpu(v2->i_nlink));
+
+		/* ns timestamp */
+		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
+			le64_to_cpu(v2->i_ctime);
+		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
+			le32_to_cpu(v2->i_ctime_nsec);
+
+		inode->i_size = le64_to_cpu(v2->i_size);
+	} else {
+		struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
+
+		vi->inode_isize = sizeof(struct erofs_inode_v1);
+		vi->xattr_isize = ondisk_xattr_ibody_size(v1->i_xattr_icount);
+
+		vi->raw_blkaddr = le32_to_cpu(v1->i_u.raw_blkaddr);
+		inode->i_mode = le16_to_cpu(v1->i_mode);
+
+		i_uid_write(inode, le16_to_cpu(v1->i_uid));
+		i_gid_write(inode, le16_to_cpu(v1->i_gid));
+		set_nlink(inode, le16_to_cpu(v1->i_nlink));
+
+		/* use build time */
+		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
+			sbi->build_time;
+		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
+			sbi->build_time_nsec;
+
+		inode->i_size = le32_to_cpu(v1->i_size);
+	}
+
+	/* measure inode.i_blocks as the generic filesystem */
+	inode->i_blocks = ((inode->i_size - 1) >> 9) + 1;
+	return 0;
+}
+
+/*
+ * try_lock can be required since locking order is:
+ *   file data(fs_inode)
+ *        meta(bd_inode)
+ * but the majority of the callers is "iget",
+ * in that case we are pretty sure no deadlock since
+ * no data operations exist. However I tend to
+ * try_lock since it takes no much overhead and
+ * will success immediately.
+ */
+int fill_inline_data(struct inode *inode, void *data, unsigned m_pofs)
+{
+	struct erofs_vnode *vi = EROFS_V(inode);
+	int mode = vi->data_mapping_mode;
+
+	BUG_ON(mode >= EROFS_INODE_LAYOUT_MAX);
+
+	/* should be inode inline C */
+	if (mode != EROFS_INODE_LAYOUT_INLINE)
+		return 0;
+
+	/* fast symlink (following ext4) */
+	if (S_ISLNK(inode->i_mode) && inode->i_size < PAGE_SIZE) {
+		char *lnk = kmalloc(inode->i_size + 1, GFP_KERNEL);
+
+		if (unlikely(lnk == NULL))
+			return -ENOMEM;
+
+		m_pofs += vi->inode_isize + vi->xattr_isize;
+		BUG_ON(m_pofs + inode->i_size > PAGE_SIZE);
+
+		/* get in-page inline data */
+		memcpy(lnk, data + m_pofs, inode->i_size);
+		lnk[inode->i_size] = '\0';
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 2, 0))
+		vi->i_link = lnk;
+#else
+		inode->i_link = lnk;
+#endif
+		set_inode_fast_symlink(inode);
+	}
+	return -EAGAIN;
+}
+
+int fill_inode(struct inode *inode, int isdir)
+{
+	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
+	struct erofs_vnode *vi = EROFS_V(inode);
+	struct page *page;
+	void *data;
+	int err;
+	erofs_blk_t blkaddr;
+	unsigned ofs;
+
+	blkaddr = erofs_blknr(iloc(sbi, vi->nid));
+	ofs = erofs_blkoff(iloc(sbi, vi->nid));
+
+	debugln("%s, reading inode nid %llu at %u of blkaddr %u",
+		__func__, vi->nid, ofs, blkaddr);
+
+	page = erofs_get_meta_page(inode->i_sb, blkaddr, isdir);
+
+	if (IS_ERR(page)) {
+		errln("failed to get inode (nid: %llu) page, err %ld",
+			vi->nid, PTR_ERR(page));
+		return PTR_ERR(page);
+	}
+
+	BUG_ON(!PageUptodate(page));
+	data = page_address(page);
+
+	err = read_inode(inode, data + ofs);
+	if (!err) {
+		/* setup the new inode */
+		if (S_ISREG(inode->i_mode)) {
+			inode->i_fop = &generic_ro_fops;
+		} else if (S_ISDIR(inode->i_mode)) {
+			inode->i_op =
+				&erofs_dir_iops;
+			inode->i_fop = &erofs_dir_fops;
+		} else if (S_ISLNK(inode->i_mode)) {
+			/* by default, page_get_link is used for symlink */
+			inode->i_op =
+				&page_symlink_inode_operations;
+			inode_nohighmem(inode);
+		} else {
+			err = -EIO;
+			goto out_unlock;
+		}
+
+		if (!is_inode_layout_compression(inode)) {
+			inode->i_mapping->a_ops = &erofs_raw_access_aops;
+
+			/* fill to the last page if inline data is available */
+			fill_inline_data(inode, data, ofs);
+			goto out_unlock;
+		}
+
+		/* for compression or unknown data mapping mode */
+		err = -ENOTSUPP;
+	}
+
+out_unlock:
+	unlock_page(page);
+	put_page(page);
+	return err;
+}
+
+struct inode *erofs_iget(struct super_block *sb,
+	erofs_nid_t nid, bool isdir)
+{
+	struct inode *inode = iget_locked(sb, nid);
+
+	if (unlikely(inode == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	if (inode->i_state & I_NEW) {
+		int err;
+		struct erofs_vnode *vi = EROFS_V(inode);
+		vi->nid = nid;
+
+		err = fill_inode(inode, isdir);
+		if (likely(!err))
+			unlock_new_inode(inode);
+		else {
+			iget_failed(inode);
+			inode = ERR_PTR(err);
+		}
+	}
+	return inode;
+}
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 2, 0))
+#include <linux/namei.h>
+
+static void *erofs_follow_fast_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct erofs_vnode *vi = EROFS_V(d_inode(dentry));
+
+	nd_set_link(nd, (char *)vi->i_link);
+	return NULL;
+}
+
+const struct inode_operations simple_symlink_inode_operations = {
+	.follow_link = erofs_follow_fast_link,
+	.readlink = generic_readlink
+};
+#endif
+
-- 
1.9.1
