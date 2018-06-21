From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Jun 2018 21:40:17 +0800
Subject: [erofs-dev] [RFC PATCH RESEND 03/12] erofs: add super block
 operations
In-Reply-To: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
References: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1529588426-111662-4-git-send-email-gaoxiang25@huawei.com>

This commit adds erofs super block operations, including (u)mount,
remount_fs, show_options, statfs, in addition to some private
icache management functions.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/super.c | 362 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 362 insertions(+)
 create mode 100644 fs/erofs/super.c

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
new file mode 100644
index 0000000..a2612e2
--- /dev/null
+++ b/fs/erofs/super.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/super.c
+ *
+ * Copyright (C) 2017-2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include <linux/module.h>
+#include <linux/buffer_head.h>
+#include <linux/slab.h>
+#include <linux/statfs.h>
+#include "internal.h"
+
+static struct kmem_cache *erofs_inode_cachep __read_mostly;
+
+static void init_once(void *ptr)
+{
+	struct erofs_vnode *vi = ptr;
+
+	inode_init_once(&vi->vfs_inode);
+}
+
+static int erofs_init_inode_cache(void)
+{
+	erofs_inode_cachep = kmem_cache_create("erofs_inode",
+		sizeof(struct erofs_vnode), 0,
+		SLAB_RECLAIM_ACCOUNT, init_once);
+
+	return erofs_inode_cachep != NULL ? 0 : -ENOMEM;
+}
+
+static struct inode *alloc_inode(struct super_block *sb)
+{
+	struct erofs_vnode *vi =
+		kmem_cache_alloc(erofs_inode_cachep, GFP_KERNEL);
+
+	if (vi != NULL) {
+		/* zero out everything except vfs_inode */
+		memset(vi, 0, offsetof(struct erofs_vnode, vfs_inode));
+		return &vi->vfs_inode;
+	}
+	return ERR_PTR(-ENOMEM);
+}
+
+static void i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct erofs_vnode *vi = EROFS_V(inode);
+
+	/* be careful RCU symlink path (see ext4_inode_info->i_data)! */
+	if (is_inode_fast_symlink(inode))
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 2, 0))
+		kfree(vi->i_link);
+#else
+		kfree(inode->i_link);
+#endif
+
+	if (vi->xattr_shared_xattrs != NULL)
+		kfree(vi->xattr_shared_xattrs);
+
+	kmem_cache_free(erofs_inode_cachep, vi);
+}
+
+static void destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, i_callback);
+}
+
+static int superblock_read(struct super_block *sb)
+{
+	struct erofs_sb_info *sbi;
+	struct buffer_head *bh;
+	struct erofs_super_block *layout;
+	unsigned blkszbits;
+	int ret;
+
+	bh = sb_bread(sb, 0);
+
+	if (bh == NULL) {
+		errln("Cannot read erofs superblock");
+		return -EIO;
+	}
+
+	sbi = EROFS_SB(sb);
+	layout = (struct erofs_super_block *)((u8 *)bh->b_data
+		 + EROFS_SUPER_OFFSET);
+
+	ret = -EINVAL;
+	if (le32_to_cpu(layout->magic) != EROFS_SUPER_MAGIC_V1) {
+		errln("Cannot find valid erofs superblock");
+		goto out;
+	}
+
+	blkszbits = layout->blkszbits;
+	/* 9(512 bytes) + LOG_SECTORS_PER_BLOCK == LOG_BLOCK_SIZE */
+	if (unlikely(blkszbits != LOG_BLOCK_SIZE)) {
+		errln("blksize %u isn't supported on this platform",
+			1 << blkszbits);
+		goto out;
+	}
+
+	sbi->blocks = le32_to_cpu(layout->blocks);
+	sbi->meta_blkaddr = le32_to_cpu(layout->meta_blkaddr);
+	sbi->islotbits = ffs(sizeof(struct erofs_inode_v1)) - 1;
+
+	sbi->root_nid = le64_to_cpu(layout->root_nid);
+	sbi->inos = le64_to_cpu(layout->inos);
+
+	sbi->build_time = le64_to_cpu(layout->build_time);
+	sbi->build_time_nsec = le32_to_cpu(layout->build_time_nsec);
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 13, 0))
+	memcpy(sb->s_uuid, layout->uuid, sizeof(layout->uuid));
+#else
+	memcpy(&sb->s_uuid, layout->uuid, sizeof(layout->uuid));
+#endif
+	memcpy(sbi->volume_name, layout->volume_name,
+		sizeof(layout->volume_name));
+
+	ret = 0;
+out:
+	brelse(bh);
+	return ret;
+}
+
+static void default_options(struct erofs_sb_info *sbi)
+{
+}
+
+static int erofs_read_super(struct super_block *sb,
+	const char *dev_name, void *data, int silent)
+{
+	struct inode *inode;
+	struct erofs_sb_info *sbi;
+	int err = -EINVAL;
+
+	infoln("read_super, device -> %s", dev_name);
+	infoln("options -> %s", (char *)data);
+
+	if (unlikely(!sb_set_blocksize(sb, EROFS_BLKSIZ))) {
+		errln("Failed to set erofs blksize");
+		goto err;
+	}
+
+	sbi = kzalloc(sizeof(struct erofs_sb_info), GFP_KERNEL);
+	if (unlikely(sbi == NULL)) {
+		err = -ENOMEM;
+		goto err;
+	}
+	sb->s_fs_info = sbi;
+
+	err = superblock_read(sb);
+	if (err)
+		goto err_sbi;
+
+	sb->s_magic = EROFS_SUPER_MAGIC;
+	sb->s_flags |= MS_RDONLY | MS_NOATIME;
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_time_gran = 1;
+
+	sb->s_op = &erofs_sops;
+
+	/* set erofs default mount options */
+	default_options(sbi);
+
+	if (!silent)
+		infoln("root inode @ nid %llu", ROOT_NID(sbi));
+
+	/* get the root inode */
+	inode = erofs_iget(sb, ROOT_NID(sbi), true);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_sbi;
+	}
+
+	if (!S_ISDIR(inode->i_mode)) {
+		errln("rootino(nid %llu) is not a directory(i_mode %o)",
+			ROOT_NID(sbi), inode->i_mode);
+		err = -EINVAL;
+		goto err_iput;
+	}
+
+	sb->s_root = d_make_root(inode);
+	if (sb->s_root == NULL) {
+		err = -ENOMEM;
+		goto err_iput;
+	}
+
+	/* save the device name to sbi */
+	sbi->dev_name = __getname();
+	if (sbi->dev_name == NULL) {
+		err = -ENOMEM;
+		goto err_dput;
+	}
+
+	snprintf(sbi->dev_name, PATH_MAX, "%s", dev_name);
+	sbi->dev_name[PATH_MAX - 1] = '\0';
+
+	/*
+	 * We already have a positive dentry, which was instantiated
+	 * by d_make_root. Just need to d_rehash it.
+	 */
+	d_rehash(sb->s_root);
+
+	if (!silent)
+		infoln("mounted on %s with opts: %s.", dev_name,
+			(char *)data);
+	return 0;
+err_dput:
+	dput(sb->s_root);
+err_iput:
+	if (sb->s_root == NULL)
+		iput(inode);
+err_sbi:
+	sb->s_fs_info = NULL;
+	kfree(sbi);
+err:
+	return err;
+}
+
+/*
+ * could be triggered after deactivate_locked_super()
+ * is called, thus including umount and failed to initialize.
+ */
+static void erofs_put_super(struct super_block *sb)
+{
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+
+	/* for cases which are failed in "read_super" */
+	if (sbi == NULL)
+		return;
+
+	infoln("unmounted for %s", sbi->dev_name);
+	__putname(sbi->dev_name);
+
+	kfree(sbi);
+	sb->s_fs_info = NULL;
+}
+
+
+struct erofs_mount_private {
+	const char *dev_name;
+	char *options;
+};
+
+/* support mount_bdev() with options */
+static int erofs_fill_super(struct super_block *sb,
+	void *_priv, int silent)
+{
+	struct erofs_mount_private *priv = _priv;
+
+	return erofs_read_super(sb, priv->dev_name,
+		priv->options, silent);
+}
+
+static struct dentry *erofs_mount(
+	struct file_system_type *fs_type, int flags,
+	const char *dev_name, void *data)
+{
+	struct erofs_mount_private priv = {
+		.dev_name = dev_name,
+		.options = data
+	};
+
+	return mount_bdev(fs_type, flags, dev_name,
+		&priv, erofs_fill_super);
+}
+
+static void erofs_kill_sb(struct super_block *sb)
+{
+	WARN_ON(sb->s_magic != EROFS_SUPER_MAGIC);
+
+	kill_block_super(sb);
+}
+
+static struct file_system_type erofs_fs_type = {
+	.owner          = THIS_MODULE,
+	.name           = "erofs",
+	.mount          = erofs_mount,
+	.kill_sb        = erofs_kill_sb,
+	.fs_flags       = FS_REQUIRES_DEV,
+};
+
+int __init erofs_module_init(void)
+{
+	int err;
+
+	infoln("Initializing erofs " EROFS_VERSION);
+
+	err = erofs_init_inode_cache();
+	if (!err) {
+		err = register_filesystem(&erofs_fs_type);
+		if (!err) {
+			infoln("Successfully to initialize erofs");
+			return 0;
+		}
+	}
+	return err;
+}
+
+void __exit erofs_module_exit(void)
+{
+	unregister_filesystem(&erofs_fs_type);
+	infoln("Successfully finalize erofs");
+}
+
+/* get filesystem statistics */
+static int erofs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
+
+	buf->f_type = sb->s_magic;
+	buf->f_bsize = EROFS_BLKSIZ;
+	buf->f_blocks = sbi->blocks;
+	buf->f_bfree = buf->f_bavail = 0;
+
+	buf->f_files = ULLONG_MAX;
+	buf->f_ffree = ULLONG_MAX - sbi->inos;
+
+	buf->f_namelen = EROFS_NAME_LEN;
+
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+	return 0;
+}
+
+static int erofs_show_options(struct seq_file *seq, struct dentry *root)
+{
+	return 0;
+}
+
+static int erofs_remount(struct super_block *sb, int *flags, char *data)
+{
+	BUG_ON(!sb_rdonly(sb));
+
+	*flags |= MS_RDONLY;
+	return 0;
+}
+
+const struct super_operations erofs_sops = {
+	.put_super = erofs_put_super,
+	.alloc_inode = alloc_inode,
+	.destroy_inode = destroy_inode,
+	.statfs = erofs_statfs,
+	.show_options = erofs_show_options,
+	.remount_fs = erofs_remount,
+};
+
+module_init(erofs_module_init);
+module_exit(erofs_module_exit);
+
+MODULE_DESCRIPTION("Enhanced ROM File System");
+MODULE_AUTHOR("Gao Xiang, Yu Chao, Miao Xie, CONSUMER BG, HUAWEI Inc.");
+MODULE_LICENSE("GPL");
+
-- 
1.9.1
