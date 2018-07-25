From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 25 Jul 2018 10:26:22 +0800
Subject: [RFC PATCH v2 09/25] staging: erofs: introduce xattr & acl support
In-Reply-To: <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
 <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532485598-63393-10-git-send-email-gaoxiang25@huawei.com>

This implements xattr and acl functionalities.

Inline and shared xattrs are introduced for flexibility.
Specifically, if the same xattr occurs for many times
in a large number of inodes or the value of a xattr is so large
that it isn't suitable to be inlined, a shared xattr
kept in the xattr meta will be used instead.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Kconfig    |  37 +++
 drivers/staging/erofs/Makefile   |   1 +
 drivers/staging/erofs/inode.c    |  33 ++-
 drivers/staging/erofs/internal.h |  22 ++
 drivers/staging/erofs/namei.c    |   4 +
 drivers/staging/erofs/super.c    |  67 +++++
 drivers/staging/erofs/xattr.c    | 579 +++++++++++++++++++++++++++++++++++++++
 drivers/staging/erofs/xattr.h    |  93 +++++++
 8 files changed, 835 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/erofs/xattr.c
 create mode 100644 drivers/staging/erofs/xattr.h

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index 077430f..1a5ec1b 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -26,6 +26,43 @@ config EROFS_FS_DEBUG
 
 	  For daily use, say N.
 
+config EROFS_FS_XATTR
+	bool "EROFS extended attributes"
+	depends on EROFS_FS
+	default y
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+config EROFS_FS_POSIX_ACL
+	bool "EROFS Access Control Lists"
+	depends on EROFS_FS_XATTR
+	select FS_POSIX_ACL
+	default y
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the POSIX ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N.
+
+config EROFS_FS_SECURITY
+	bool "EROFS Security Labels"
+	depends on EROFS_FS_XATTR
+	help
+	  Security labels provide an access control facility to support Linux
+	  Security Models (LSMs) accepted by AppArmor, SELinux, Smack and TOMOYO
+	  Linux. This option enables an extended attribute handler for file
+	  security labels in the erofs filesystem, so that it requires enabling
+	  the extended attribute support in advance.
+
+	  If you are not using a security module, say N.
+
 config EROFS_FS_USE_VM_MAP_RAM
 	bool "EROFS VM_MAP_RAM Support"
 	depends on EROFS_FS
diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index 31e909e..977b7e0 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_EROFS_FS) += erofs.o
 # staging requirement: to be self-contained in its own directory
 ccflags-y += -I$(src)/include
 erofs-objs := super.o inode.o data.o namei.o dir.o
+erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
 
diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index c33ad56..587f15b 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -10,7 +10,7 @@
  * License.  See the file COPYING in the main directory of the Linux
  * distribution for more details.
  */
-#include "internal.h"
+#include "xattr.h"
 
 /* no locking */
 static int read_inode(struct inode *inode, void *data)
@@ -152,15 +152,26 @@ int fill_inode(struct inode *inode, int isdir)
 	if (!err) {
 		/* setup the new inode */
 		if (S_ISREG(inode->i_mode)) {
+#ifdef CONFIG_EROFS_FS_XATTR
+			if (vi->xattr_isize)
+				inode->i_op = &erofs_generic_xattr_iops;
+#endif
 			inode->i_fop = &generic_ro_fops;
 		} else if (S_ISDIR(inode->i_mode)) {
 			inode->i_op =
+#ifdef CONFIG_EROFS_FS_XATTR
+				vi->xattr_isize ? &erofs_dir_xattr_iops :
+#endif
 				&erofs_dir_iops;
 			inode->i_fop = &erofs_dir_fops;
 		} else if (S_ISLNK(inode->i_mode)) {
 			/* by default, page_get_link is used for symlink */
 			inode->i_op =
+#ifdef CONFIG_EROFS_FS_XATTR
+				&erofs_symlink_xattr_iops,
+#else
 				&page_symlink_inode_operations;
+#endif
 			inode_nohighmem(inode);
 		} else {
 			err = -EIO;
@@ -208,3 +219,23 @@ struct inode *erofs_iget(struct super_block *sb,
 	return inode;
 }
 
+#ifdef CONFIG_EROFS_FS_XATTR
+const struct inode_operations erofs_generic_xattr_iops = {
+	.listxattr = erofs_listxattr,
+};
+#endif
+
+#ifdef CONFIG_EROFS_FS_XATTR
+const struct inode_operations erofs_symlink_xattr_iops = {
+	.get_link = page_get_link,
+	.listxattr = erofs_listxattr,
+};
+#endif
+
+#ifdef CONFIG_EROFS_FS_XATTR
+const struct inode_operations erofs_fast_symlink_xattr_iops = {
+	.get_link = simple_get_link,
+	.listxattr = erofs_listxattr,
+};
+#endif
+
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index d0992d2..8a8caf0 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -50,6 +50,9 @@
 struct erofs_sb_info {
 	u32 blocks;
 	u32 meta_blkaddr;
+#ifdef CONFIG_EROFS_FS_XATTR
+	u32 xattr_blkaddr;
+#endif
 
 	/* inode slot unit size in bit shift */
 	unsigned char islotbits;
@@ -72,6 +75,10 @@ struct erofs_sb_info {
 #define EROFS_SB(sb) ((struct erofs_sb_info *)(sb)->s_fs_info)
 #define EROFS_I_SB(inode) ((struct erofs_sb_info *)(inode)->i_sb->s_fs_info)
 
+/* Mount flags set via mount options or defaults */
+#define EROFS_MOUNT_XATTR_USER		0x00000010
+#define EROFS_MOUNT_POSIX_ACL		0x00000020
+
 #define clear_opt(sbi, option)	((sbi)->mount_opt &= ~EROFS_MOUNT_##option)
 #define set_opt(sbi, option)	((sbi)->mount_opt |= EROFS_MOUNT_##option)
 #define test_opt(sbi, option)	((sbi)->mount_opt & EROFS_MOUNT_##option)
@@ -237,17 +244,32 @@ int erofs_namei(struct inode *dir, struct qstr *name,
 	erofs_nid_t *nid, unsigned *d_type);
 
 /* xattr.c */
+#ifdef CONFIG_EROFS_FS_XATTR
 extern const struct xattr_handler *erofs_xattr_handlers[];
+#endif
 
 /* symlink */
+#ifdef CONFIG_EROFS_FS_XATTR
+extern const struct inode_operations erofs_symlink_xattr_iops;
+extern const struct inode_operations erofs_fast_symlink_xattr_iops;
+#endif
+
 static inline void set_inode_fast_symlink(struct inode *inode)
 {
+#ifdef CONFIG_EROFS_FS_XATTR
+	inode->i_op = &erofs_fast_symlink_xattr_iops;
+#else
 	inode->i_op = &simple_symlink_inode_operations;
+#endif
 }
 
 static inline bool is_inode_fast_symlink(struct inode *inode)
 {
+#ifdef CONFIG_EROFS_FS_XATTR
+	return inode->i_op == &erofs_fast_symlink_xattr_iops;
+#else
 	return inode->i_op == &simple_symlink_inode_operations;
+#endif
 }
 
 static inline void *erofs_vmap(struct page **pages, unsigned int count)
diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index 27b6712..4e24357 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -11,6 +11,7 @@
  * distribution for more details.
  */
 #include "internal.h"
+#include "xattr.h"
 
 /* based on the value of qn->len is accurate */
 static inline int dirnamecmp(struct qstr *qn,
@@ -239,5 +240,8 @@ struct dentry *erofs_lookup(struct inode *dir,
 
 const struct inode_operations erofs_dir_xattr_iops = {
 	.lookup = erofs_lookup,
+#ifdef CONFIG_EROFS_FS_XATTR
+	.listxattr = erofs_listxattr,
+#endif
 };
 
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 33405f1..d1860c4 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -14,6 +14,7 @@
 #include <linux/buffer_head.h>
 #include <linux/statfs.h>
 #include <linux/parser.h>
+#include <linux/seq_file.h>
 #include "internal.h"
 
 static struct kmem_cache *erofs_inode_cachep __read_mostly;
@@ -107,6 +108,9 @@ static int superblock_read(struct super_block *sb)
 
 	sbi->blocks = le32_to_cpu(layout->blocks);
 	sbi->meta_blkaddr = le32_to_cpu(layout->meta_blkaddr);
+#ifdef CONFIG_EROFS_FS_XATTR
+	sbi->xattr_blkaddr = le32_to_cpu(layout->xattr_blkaddr);
+#endif
 	sbi->islotbits = ffs(sizeof(struct erofs_inode_v1)) - 1;
 
 	sbi->root_nid = le16_to_cpu(layout->root_nid);
@@ -127,13 +131,28 @@ static int superblock_read(struct super_block *sb)
 
 static void default_options(struct erofs_sb_info *sbi)
 {
+#ifdef CONFIG_EROFS_FS_XATTR
+	set_opt(sbi, XATTR_USER);
+#endif
+
+#ifdef CONFIG_EROFS_FS_POSIX_ACL
+	set_opt(sbi, POSIX_ACL);
+#endif
 }
 
 enum {
+	Opt_user_xattr,
+	Opt_nouser_xattr,
+	Opt_acl,
+	Opt_noacl,
 	Opt_err
 };
 
 static match_table_t erofs_tokens = {
+	{Opt_user_xattr, "user_xattr"},
+	{Opt_nouser_xattr, "nouser_xattr"},
+	{Opt_acl, "acl"},
+	{Opt_noacl, "noacl"},
 	{Opt_err, NULL}
 };
 
@@ -155,6 +174,36 @@ static int parse_options(struct super_block *sb, char *options)
 		token = match_token(p, erofs_tokens, args);
 
 		switch (token) {
+#ifdef CONFIG_EROFS_FS_XATTR
+		case Opt_user_xattr:
+			set_opt(EROFS_SB(sb), XATTR_USER);
+			break;
+		case Opt_nouser_xattr:
+			clear_opt(EROFS_SB(sb), XATTR_USER);
+			break;
+#else
+		case Opt_user_xattr:
+			infoln("user_xattr options not supported");
+			break;
+		case Opt_nouser_xattr:
+			infoln("nouser_xattr options not supported");
+			break;
+#endif
+#ifdef CONFIG_EROFS_FS_POSIX_ACL
+		case Opt_acl:
+			set_opt(EROFS_SB(sb), POSIX_ACL);
+			break;
+		case Opt_noacl:
+			clear_opt(EROFS_SB(sb), POSIX_ACL);
+			break;
+#else
+		case Opt_acl:
+			infoln("acl options not supported");
+			break;
+		case Opt_noacl:
+			infoln("noacl options not supported");
+			break;
+#endif
 		default:
 			errln("Unrecognized mount option \"%s\" "
 					"or missing value", p);
@@ -197,6 +246,10 @@ static int erofs_read_super(struct super_block *sb,
 
 	sb->s_op = &erofs_sops;
 
+#ifdef CONFIG_EROFS_FS_XATTR
+	sb->s_xattr = erofs_xattr_handlers;
+#endif
+
 	/* set erofs default mount options */
 	default_options(sbi);
 
@@ -386,6 +439,20 @@ static int erofs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 {
+	struct erofs_sb_info *sbi __maybe_unused = EROFS_SB(root->d_sb);
+
+#ifdef CONFIG_EROFS_FS_XATTR
+	if (test_opt(sbi, XATTR_USER))
+		seq_puts(seq, ",user_xattr");
+	else
+		seq_puts(seq, ",nouser_xattr");
+#endif
+#ifdef CONFIG_EROFS_FS_POSIX_ACL
+	if (test_opt(sbi, POSIX_ACL))
+		seq_puts(seq, ",acl");
+	else
+		seq_puts(seq, ",noacl");
+#endif
 	return 0;
 }
 
diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
new file mode 100644
index 0000000..10928ad
--- /dev/null
+++ b/drivers/staging/erofs/xattr.c
@@ -0,0 +1,579 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/drivers/staging/erofs/xattr.c
+ *
+ * Copyright (C) 2017-2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include <linux/security.h>
+#include "xattr.h"
+
+struct xattr_iter {
+	struct super_block *sb;
+	struct page *page;
+	void *kaddr;
+
+	erofs_blk_t blkaddr;
+	unsigned ofs;
+};
+
+static inline void xattr_iter_end(struct xattr_iter *it, bool atomic)
+{
+	/* only init_inode_xattrs use non-atomic once */
+	if (unlikely(!atomic))
+		kunmap(it->page);
+	else
+		kunmap_atomic(it->kaddr);
+	unlock_page(it->page);
+	put_page(it->page);
+}
+
+static void init_inode_xattrs(struct inode *inode)
+{
+	struct xattr_iter it;
+	unsigned i;
+	struct erofs_xattr_ibody_header *ih;
+	struct erofs_sb_info *sbi;
+	struct erofs_vnode *vi;
+	bool atomic_map;
+
+	if (likely(inode_has_inited_xattr(inode)))
+		return;
+
+	vi = EROFS_V(inode);
+	BUG_ON(!vi->xattr_isize);
+
+	sbi = EROFS_I_SB(inode);
+	it.blkaddr = erofs_blknr(iloc(sbi, vi->nid) + vi->inode_isize);
+	it.ofs = erofs_blkoff(iloc(sbi, vi->nid) + vi->inode_isize);
+
+	it.page = erofs_get_inline_page(inode, it.blkaddr);
+	BUG_ON(IS_ERR(it.page));
+
+	/* read in shared xattr array (non-atomic, see kmalloc below) */
+	it.kaddr = kmap(it.page);
+	atomic_map = false;
+
+	ih = (struct erofs_xattr_ibody_header *)(it.kaddr + it.ofs);
+
+	vi->xattr_shared_count = ih->h_shared_count;
+	vi->xattr_shared_xattrs = (unsigned *)kmalloc_array(
+		vi->xattr_shared_count, sizeof(unsigned),
+		GFP_KERNEL | __GFP_NOFAIL);
+
+	/* let's skip ibody header */
+	it.ofs += sizeof(struct erofs_xattr_ibody_header);
+
+	for (i = 0; i < vi->xattr_shared_count; ++i) {
+		if (unlikely(it.ofs >= EROFS_BLKSIZ)) {
+			/* cannot be unaligned */
+			BUG_ON(it.ofs != EROFS_BLKSIZ);
+			xattr_iter_end(&it, atomic_map);
+
+			it.page = erofs_get_meta_page(inode->i_sb,
+				++it.blkaddr, S_ISDIR(inode->i_mode));
+			BUG_ON(IS_ERR(it.page));
+
+			it.kaddr = kmap_atomic(it.page);
+			atomic_map = true;
+			it.ofs = 0;
+		}
+		vi->xattr_shared_xattrs[i] =
+			le32_to_cpu(*(__le32 *)(it.kaddr + it.ofs));
+		it.ofs += sizeof(__le32);
+	}
+	xattr_iter_end(&it, atomic_map);
+
+	inode_set_inited_xattr(inode);
+}
+
+struct xattr_iter_handlers {
+	int (*entry)(struct xattr_iter *, struct erofs_xattr_entry *);
+	int (*name)(struct xattr_iter *, unsigned, char *, unsigned);
+	int (*alloc_buffer)(struct xattr_iter *, unsigned);
+	void (*value)(struct xattr_iter *, unsigned, char *, unsigned);
+};
+
+static void xattr_iter_fixup(struct xattr_iter *it)
+{
+	if (unlikely(it->ofs >= EROFS_BLKSIZ)) {
+		xattr_iter_end(it, true);
+
+		it->blkaddr += erofs_blknr(it->ofs);
+		it->page = erofs_get_meta_page(it->sb, it->blkaddr, false);
+		BUG_ON(IS_ERR(it->page));
+
+		it->kaddr = kmap_atomic(it->page);
+		it->ofs = erofs_blkoff(it->ofs);
+	}
+}
+
+static int inline_xattr_iter_begin(struct xattr_iter *it,
+	struct inode *inode)
+{
+	struct erofs_vnode *const vi = EROFS_V(inode);
+	struct erofs_sb_info *const sbi = EROFS_SB(inode->i_sb);
+	unsigned xattr_header_sz, inline_xattr_ofs;
+
+	xattr_header_sz = inlinexattr_header_size(inode);
+	if (unlikely(xattr_header_sz >= vi->xattr_isize)) {
+		BUG_ON(xattr_header_sz > vi->xattr_isize);
+		return -ENOATTR;
+	}
+
+	inline_xattr_ofs = vi->inode_isize + xattr_header_sz;
+
+	it->blkaddr = erofs_blknr(iloc(sbi, vi->nid) + inline_xattr_ofs);
+	it->ofs = erofs_blkoff(iloc(sbi, vi->nid) + inline_xattr_ofs);
+
+	it->page = erofs_get_inline_page(inode, it->blkaddr);
+	BUG_ON(IS_ERR(it->page));
+	it->kaddr = kmap_atomic(it->page);
+
+	return vi->xattr_isize - xattr_header_sz;
+}
+
+static int xattr_foreach(struct xattr_iter *it,
+	struct xattr_iter_handlers *op, unsigned *tlimit)
+{
+	struct erofs_xattr_entry entry;
+	unsigned value_sz, processed, slice;
+	int err;
+
+	/* 0. fixup blkaddr, ofs, ipage */
+	xattr_iter_fixup(it);
+
+	/*
+	 * 1. read xattr entry to the memory,
+	 *    since we do EROFS_XATTR_ALIGN
+	 *    therefore entry should be in the page
+	 */
+	entry = *(struct erofs_xattr_entry *)(it->kaddr + it->ofs);
+	if (tlimit != NULL) {
+		unsigned entry_sz = EROFS_XATTR_ENTRY_SIZE(&entry);
+
+		BUG_ON(*tlimit < entry_sz);
+		*tlimit -= entry_sz;
+	}
+
+	it->ofs += sizeof(struct erofs_xattr_entry);
+	value_sz = le16_to_cpu(entry.e_value_size);
+
+	/* handle entry */
+	err = op->entry(it, &entry);
+	if (err) {
+		it->ofs += entry.e_name_len + value_sz;
+		goto out;
+	}
+
+	/* 2. handle xattr name (ofs will finally be at the end of name) */
+	processed = 0;
+
+	while (processed < entry.e_name_len) {
+		if (it->ofs >= EROFS_BLKSIZ) {
+			BUG_ON(it->ofs > EROFS_BLKSIZ);
+
+			xattr_iter_fixup(it);
+			it->ofs = 0;
+		}
+
+		slice = min_t(unsigned, PAGE_SIZE - it->ofs,
+			entry.e_name_len - processed);
+
+		/* handle name */
+		err = op->name(it, processed, it->kaddr + it->ofs, slice);
+		if (err) {
+			it->ofs += entry.e_name_len - processed + value_sz;
+			goto out;
+		}
+
+		it->ofs += slice;
+		processed += slice;
+	}
+
+	/* 3. handle xattr value */
+	processed = 0;
+
+	if (op->alloc_buffer != NULL) {
+		err = op->alloc_buffer(it, value_sz);
+		if (err) {
+			it->ofs += value_sz;
+			goto out;
+		}
+	}
+
+	while (processed < value_sz) {
+		if (it->ofs >= EROFS_BLKSIZ) {
+			BUG_ON(it->ofs > EROFS_BLKSIZ);
+			xattr_iter_fixup(it);
+			it->ofs = 0;
+		}
+
+		slice = min_t(unsigned, PAGE_SIZE - it->ofs,
+			value_sz - processed);
+		op->value(it, processed, it->kaddr + it->ofs, slice);
+		it->ofs += slice;
+		processed += slice;
+	}
+
+out:
+	/* we assume that ofs is aligned with 4 bytes */
+	it->ofs = EROFS_XATTR_ALIGN(it->ofs);
+	return err;
+}
+
+struct getxattr_iter {
+	struct xattr_iter it;
+
+	char *buffer;
+	int buffer_size, index;
+	struct qstr name;
+};
+
+static int xattr_entrymatch(struct xattr_iter *_it,
+	struct erofs_xattr_entry *entry)
+{
+	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
+
+	return (it->index != entry->e_name_index ||
+		it->name.len != entry->e_name_len) ? -ENOATTR : 0;
+}
+
+static int xattr_namematch(struct xattr_iter *_it,
+	unsigned processed, char *buf, unsigned len)
+{
+	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
+
+	return memcmp(buf, it->name.name + processed, len) ? -ENOATTR : 0;
+}
+
+static int xattr_checkbuffer(struct xattr_iter *_it,
+	unsigned value_sz)
+{
+	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
+	int err = it->buffer_size < value_sz ? -ERANGE : 0;
+
+	it->buffer_size = value_sz;
+	return it->buffer == NULL ? 1 : err;
+}
+
+static void xattr_copyvalue(struct xattr_iter *_it,
+	unsigned processed, char *buf, unsigned len)
+{
+	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
+
+	memcpy(it->buffer + processed, buf, len);
+}
+
+struct xattr_iter_handlers find_xattr_handlers = {
+	.entry = xattr_entrymatch,
+	.name = xattr_namematch,
+	.alloc_buffer = xattr_checkbuffer,
+	.value = xattr_copyvalue
+};
+
+static int inline_getxattr(struct inode *inode, struct getxattr_iter *it)
+{
+	int ret;
+	unsigned remaining;
+
+	ret = inline_xattr_iter_begin(&it->it, inode);
+	if (ret < 0)
+		return ret;
+
+	remaining = ret;
+	while (remaining) {
+		if ((ret = xattr_foreach(&it->it,
+			&find_xattr_handlers, &remaining)) >= 0)
+			break;
+	}
+	xattr_iter_end(&it->it, true);
+
+	return ret < 0 ? ret : it->buffer_size;
+}
+
+static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
+{
+	struct erofs_vnode *const vi = EROFS_V(inode);
+	struct erofs_sb_info *const sbi = EROFS_SB(inode->i_sb);
+	unsigned i;
+	int ret = -ENOATTR;
+
+	for (i = 0; i < vi->xattr_shared_count; ++i) {
+		erofs_blk_t blkaddr =
+			xattrblock_addr(sbi, vi->xattr_shared_xattrs[i]);
+
+		it->it.ofs = xattrblock_offset(sbi, vi->xattr_shared_xattrs[i]);
+
+		if (!i || blkaddr != it->it.blkaddr) {
+			if (i)
+				xattr_iter_end(&it->it, true);
+
+			it->it.page = erofs_get_meta_page(inode->i_sb,
+				blkaddr, false);
+			BUG_ON(IS_ERR(it->it.page));
+			it->it.kaddr = kmap_atomic(it->it.page);
+			it->it.blkaddr = blkaddr;
+		}
+
+		if ((ret = xattr_foreach(&it->it,
+			&find_xattr_handlers, NULL)) >= 0)
+			break;
+	}
+	if (vi->xattr_shared_count)
+		xattr_iter_end(&it->it, true);
+
+	return ret < 0 ? ret : it->buffer_size;
+}
+
+static bool erofs_xattr_user_list(struct dentry *dentry)
+{
+	return test_opt(EROFS_SB(dentry->d_sb), XATTR_USER);
+}
+
+static bool erofs_xattr_trusted_list(struct dentry *dentry)
+{
+	return capable(CAP_SYS_ADMIN);
+}
+
+int erofs_getxattr(struct inode *inode, int index,
+	const char *name,
+	void *buffer, size_t buffer_size)
+{
+	int ret;
+	struct getxattr_iter it;
+
+	if (unlikely(name == NULL))
+		return -EINVAL;
+
+	init_inode_xattrs(inode);
+
+	it.index = index;
+
+	it.name.len = strlen(name);
+	if (it.name.len > EROFS_NAME_LEN)
+		return -ERANGE;
+	it.name.name = name;
+
+	it.buffer = buffer;
+	it.buffer_size = buffer_size;
+
+	it.it.sb = inode->i_sb;
+	ret = inline_getxattr(inode, &it);
+	if (ret == -ENOATTR)
+		ret = shared_getxattr(inode, &it);
+	return ret;
+}
+
+static int erofs_xattr_generic_get(const struct xattr_handler *handler,
+		struct dentry *unused, struct inode *inode,
+		const char *name, void *buffer, size_t size)
+{
+	struct erofs_vnode *const vi = EROFS_V(inode);
+	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
+
+	switch (handler->flags) {
+	case EROFS_XATTR_INDEX_USER:
+		if (!test_opt(sbi, XATTR_USER))
+			return -EOPNOTSUPP;
+		break;
+	case EROFS_XATTR_INDEX_TRUSTED:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		break;
+	case EROFS_XATTR_INDEX_SECURITY:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!vi->xattr_isize)
+		return -ENOATTR;
+
+	return erofs_getxattr(inode, handler->flags, name, buffer, size);
+}
+
+const struct xattr_handler erofs_xattr_user_handler = {
+	.prefix	= XATTR_USER_PREFIX,
+	.flags	= EROFS_XATTR_INDEX_USER,
+	.list	= erofs_xattr_user_list,
+	.get	= erofs_xattr_generic_get,
+};
+
+const struct xattr_handler erofs_xattr_trusted_handler = {
+	.prefix	= XATTR_TRUSTED_PREFIX,
+	.flags	= EROFS_XATTR_INDEX_TRUSTED,
+	.list	= erofs_xattr_trusted_list,
+	.get	= erofs_xattr_generic_get,
+};
+
+#ifdef CONFIG_EROFS_FS_SECURITY
+const struct xattr_handler __maybe_unused erofs_xattr_security_handler = {
+	.prefix	= XATTR_SECURITY_PREFIX,
+	.flags	= EROFS_XATTR_INDEX_SECURITY,
+	.get	= erofs_xattr_generic_get,
+};
+#endif
+
+#ifdef CONFIG_EROFS_FS_XATTR
+const struct xattr_handler *erofs_xattr_handlers[] = {
+	&erofs_xattr_user_handler,
+#ifdef CONFIG_EROFS_FS_POSIX_ACL
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
+#endif
+	&erofs_xattr_trusted_handler,
+#ifdef CONFIG_EROFS_FS_SECURITY
+	&erofs_xattr_security_handler,
+#endif
+	NULL,
+};
+#endif
+
+struct listxattr_iter {
+	struct xattr_iter it;
+
+	struct dentry *dentry;
+	char *buffer;
+	int buffer_size, buffer_ofs;
+};
+
+static int xattr_entrylist(struct xattr_iter *_it,
+	struct erofs_xattr_entry *entry)
+{
+	struct listxattr_iter *it =
+		container_of(_it, struct listxattr_iter, it);
+	unsigned prefix_len;
+	const char *prefix;
+
+	const struct xattr_handler *h =
+		erofs_xattr_handler(entry->e_name_index);
+
+	if (h == NULL || (h->list != NULL && !h->list(it->dentry)))
+		return 1;
+
+	/* Note that at least one of 'prefix' and 'name' should be non-NULL */
+	prefix = h->prefix != NULL ? h->prefix : h->name;
+	prefix_len = strlen(prefix);
+
+	if (it->buffer == NULL) {
+		it->buffer_ofs += prefix_len + entry->e_name_len + 1;
+		return 1;
+	}
+
+	if (it->buffer_ofs + prefix_len
+		+ entry->e_name_len + 1 > it->buffer_size)
+		return -ERANGE;
+
+	memcpy(it->buffer + it->buffer_ofs, prefix, prefix_len);
+	it->buffer_ofs += prefix_len;
+	return 0;
+}
+
+static int xattr_namelist(struct xattr_iter *_it,
+	unsigned processed, char *buf, unsigned len)
+{
+	struct listxattr_iter *it =
+		container_of(_it, struct listxattr_iter, it);
+
+	memcpy(it->buffer + it->buffer_ofs, buf, len);
+	it->buffer_ofs += len;
+	return 0;
+}
+
+static int xattr_skipvalue(struct xattr_iter *_it,
+	unsigned value_sz)
+{
+	struct listxattr_iter *it =
+		container_of(_it, struct listxattr_iter, it);
+
+	it->buffer[it->buffer_ofs++] = '\0';
+	return 1;
+}
+
+struct xattr_iter_handlers list_xattr_handlers = {
+	.entry = xattr_entrylist,
+	.name = xattr_namelist,
+	.alloc_buffer = xattr_skipvalue,
+	.value = NULL
+};
+
+static int inline_listxattr(struct listxattr_iter *it)
+{
+	int ret;
+	unsigned remaining;
+
+	ret = inline_xattr_iter_begin(&it->it, d_inode(it->dentry));
+	if (ret < 0)
+		return ret;
+
+	remaining = ret;
+	while (remaining) {
+		if ((ret = xattr_foreach(&it->it,
+			&list_xattr_handlers, &remaining)) < 0)
+			break;
+	}
+	xattr_iter_end(&it->it, true);
+	return ret < 0 ? ret : it->buffer_ofs;
+}
+
+static int shared_listxattr(struct listxattr_iter *it)
+{
+	struct inode *const inode = d_inode(it->dentry);
+	struct erofs_vnode *const vi = EROFS_V(inode);
+	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
+	unsigned i;
+	int ret = 0;
+
+	for (i = 0; i < vi->xattr_shared_count; ++i) {
+		erofs_blk_t blkaddr =
+			xattrblock_addr(sbi, vi->xattr_shared_xattrs[i]);
+
+		it->it.ofs = xattrblock_offset(sbi, vi->xattr_shared_xattrs[i]);
+		if (!i || blkaddr != it->it.blkaddr) {
+			if (i)
+				xattr_iter_end(&it->it, true);
+
+			it->it.page = erofs_get_meta_page(inode->i_sb,
+				blkaddr, false);
+			BUG_ON(IS_ERR(it->it.page));
+			it->it.kaddr = kmap_atomic(it->it.page);
+			it->it.blkaddr = blkaddr;
+		}
+
+		if ((ret = xattr_foreach(&it->it,
+			&list_xattr_handlers, NULL)) < 0)
+			break;
+	}
+	if (vi->xattr_shared_count)
+		xattr_iter_end(&it->it, true);
+
+	return ret < 0 ? ret : it->buffer_ofs;
+}
+
+ssize_t erofs_listxattr(struct dentry *dentry,
+	char *buffer, size_t buffer_size)
+{
+	int ret;
+	struct listxattr_iter it;
+
+	init_inode_xattrs(d_inode(dentry));
+
+	it.dentry = dentry;
+	it.buffer = buffer;
+	it.buffer_size = buffer_size;
+	it.buffer_ofs = 0;
+
+	it.it.sb = dentry->d_sb;
+
+	ret = inline_listxattr(&it);
+	if (ret < 0 && ret != -ENOATTR)
+		return ret;
+	return shared_listxattr(&it);
+}
+
diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
new file mode 100644
index 0000000..0c73792
--- /dev/null
+++ b/drivers/staging/erofs/xattr.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * linux/drivers/staging/erofs/xattr.h
+ *
+ * Copyright (C) 2017-2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#ifndef __EROFS_XATTR_H
+#define __EROFS_XATTR_H
+
+#include "internal.h"
+#include <linux/posix_acl_xattr.h>
+#include <linux/xattr.h>
+
+/* Attribute not found */
+#define ENOATTR         ENODATA
+
+static inline unsigned inlinexattr_header_size(struct inode *inode)
+{
+	return sizeof(struct erofs_xattr_ibody_header)
+		+ sizeof(u32) * EROFS_V(inode)->xattr_shared_count;
+}
+
+static inline erofs_blk_t
+xattrblock_addr(struct erofs_sb_info *sbi, unsigned xattr_id)
+{
+#ifdef CONFIG_EROFS_FS_XATTR
+	return sbi->xattr_blkaddr +
+		xattr_id * sizeof(__u32) / EROFS_BLKSIZ;
+#else
+	return 0;
+#endif
+}
+
+static inline unsigned
+xattrblock_offset(struct erofs_sb_info *sbi, unsigned xattr_id)
+{
+	return (xattr_id * sizeof(__u32)) % EROFS_BLKSIZ;
+}
+
+extern const struct xattr_handler erofs_xattr_user_handler;
+extern const struct xattr_handler erofs_xattr_trusted_handler;
+#ifdef CONFIG_EROFS_FS_SECURITY
+extern const struct xattr_handler erofs_xattr_security_handler;
+#endif
+
+static inline const struct xattr_handler *erofs_xattr_handler(unsigned index)
+{
+static const struct xattr_handler *xattr_handler_map[] = {
+	[EROFS_XATTR_INDEX_USER] = &erofs_xattr_user_handler,
+#ifdef CONFIG_EROFS_FS_POSIX_ACL
+	[EROFS_XATTR_INDEX_POSIX_ACL_ACCESS] = &posix_acl_access_xattr_handler,
+	[EROFS_XATTR_INDEX_POSIX_ACL_DEFAULT] =
+		&posix_acl_default_xattr_handler,
+#endif
+	[EROFS_XATTR_INDEX_TRUSTED] = &erofs_xattr_trusted_handler,
+#ifdef CONFIG_EROFS_FS_SECURITY
+	[EROFS_XATTR_INDEX_SECURITY] = &erofs_xattr_security_handler,
+#endif
+};
+	return index && index < ARRAY_SIZE(xattr_handler_map) ?
+		xattr_handler_map[index] : NULL;
+}
+
+#ifdef CONFIG_EROFS_FS_XATTR
+
+extern const struct inode_operations erofs_generic_xattr_iops;
+extern const struct inode_operations erofs_dir_xattr_iops;
+
+int erofs_getxattr(struct inode *, int, const char *, void *, size_t);
+ssize_t erofs_listxattr(struct dentry *, char *, size_t);
+#else
+static int __maybe_unused erofs_getxattr(struct inode *inode, int index,
+	const char *name,
+	void *buffer, size_t buffer_size)
+{
+	return -ENOTSUPP;
+}
+
+static ssize_t __maybe_unused erofs_listxattr(struct dentry *dentry,
+	char *buffer, size_t buffer_size)
+{
+	return -ENOTSUPP;
+}
+#endif
+
+#endif
+
-- 
1.9.1
