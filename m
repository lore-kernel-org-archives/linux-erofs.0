From: arshad.super@gmail.com (Arshad Hussain)
Date: Wed, 13 Mar 2019 02:36:40 +0530
Subject: [PATCH] [PATCH 1/1] staging: erofs: Add function comment for
 erofs/super.c
Message-ID: <20190312210640.2175-1-arshad.super@gmail.com>

This patch adds functions comment for file erofs/super.c in
sphinx format.

Signed-off-by: Arshad Hussain <arshad.super at gmail.com>
---
 drivers/staging/erofs/super.c | 135 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 131 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 15c784fba879..60bfc3e8db7a 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -30,6 +30,11 @@ static void init_once(void *ptr)
 	inode_init_once(&vi->vfs_inode);
 }
 
+/**
+ * erofs_init_inode_cache(): Create & initialize inode cache
+ *
+ * Returns: 0 on Success. Errno Otherwise.
+ */
 static int __init erofs_init_inode_cache(void)
 {
 	erofs_inode_cachep = kmem_cache_create("erofs_inode",
@@ -39,11 +44,21 @@ static int __init erofs_init_inode_cache(void)
 	return erofs_inode_cachep != NULL ? 0 : -ENOMEM;
 }
 
+/**
+ * erofs_exit_inode_cache(): Destroy inode cache
+ */
 static void erofs_exit_inode_cache(void)
 {
 	kmem_cache_destroy(erofs_inode_cachep);
 }
 
+/**
+ * alloc_inode(): Allocate and initialize inode
+ *
+ * @sb: VFS superblock structure
+ *
+ * Returns: Pointer to inode structure
+ */
 static struct inode *alloc_inode(struct super_block *sb)
 {
 	struct erofs_vnode *vi =
@@ -57,6 +72,11 @@ static struct inode *alloc_inode(struct super_block *sb)
 	return &vi->vfs_inode;
 }
 
+/**
+ * i_callback(): Release slab Memory
+ *
+ * @head: RCU callback structure
+ */
 static void i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
@@ -71,11 +91,23 @@ static void i_callback(struct rcu_head *head)
 	kmem_cache_free(erofs_inode_cachep, vi);
 }
 
+/**
+ * destroy_inode(): Release Inode Resources allocated by alloc_inode()
+ *
+ * @inode: VFS Inode structure
+ */
 static void destroy_inode(struct inode *inode)
 {
 	call_rcu(&inode->i_rcu, i_callback);
 }
 
+/**
+ * superblock_read(): Read superblock into buffer
+ *
+ * @sb: VFS Superblock structure
+ *
+ * Returns: 0 on Success. Errno otherwise
+ */
 static int superblock_read(struct super_block *sb)
 {
 	struct erofs_sb_info *sbi;
@@ -230,6 +262,14 @@ static match_table_t erofs_tokens = {
 	{Opt_err, NULL}
 };
 
+/**
+ * parse_options(): Parse and set additional mount option for erofs
+ *
+ * @sb: VFS superblock structure
+ * @options: Mount options
+ *
+ * Returns: 0 on Success. Errno otherwise
+ */
 static int parse_options(struct super_block *sb, char *options)
 {
 	substring_t args[MAX_OPT_ARGS];
@@ -351,6 +391,22 @@ static struct inode *erofs_init_managed_cache(struct super_block *sb)
 
 #endif
 
+/**
+ * erofs_read_super(): Helper function to erofs_fill_super()
+ *
+ * @sb: VFS superblock structure
+ * @dev_name: Name of device where erofs is mounted
+ * @data: Additional mount options
+ * @silent: if TRUE print message on error.
+ * 	    Silent/quite otherwise
+ *
+ * Helper function to actual callback function erofs_fill_super
+ * This function sets the blocksize. Reads the superblock into
+ * buffer. Parses and sets mount options. Populates root inode
+ * and creates root directory.
+ *
+ * Returns: 0 on Success. Errno otherwise
+ */
 static int erofs_read_super(struct super_block *sb,
 	const char *dev_name, void *data, int silent)
 {
@@ -472,8 +528,12 @@ static int erofs_read_super(struct super_block *sb,
 	return err;
 }
 
-/*
- * could be triggered after deactivate_locked_super()
+/**
+ * erofs_put_super(): Free superblock structure
+ *
+ * @sb: VFS superblock structure
+ *
+ * Could be triggered after deactivate_locked_super()
  * is called, thus including umount and failed to initialize.
  */
 static void erofs_put_super(struct super_block *sb)
@@ -513,7 +573,20 @@ struct erofs_mount_private {
 	char *options;
 };
 
-/* support mount_bdev() with options */
+/**
+ * erofs_fill_super(): Fill erofs superblock
+ *
+ * @sb: VFS superblock structure
+ * @_priv: Additional Mount options
+ * @silent: if TRUE print message on error.
+ * 	    Silent/quite otherwise
+ *
+ * This function fills erofs superblock information into
+ * the VFS superblock stucture. Additionally it supports
+ * mount_bdev() with options
+ *
+ * Returns: 0 on Success
+ */
 static int erofs_fill_super(struct super_block *sb,
 	void *_priv, int silent)
 {
@@ -523,6 +596,17 @@ static int erofs_fill_super(struct super_block *sb,
 		priv->options, silent);
 }
 
+/**
+ * erofs_mount(): Function called when erofs is mounted
+ *
+ * @fs_type: Describes the erofs filesystem
+ * @flags: Mount flags/options
+ * @dev_name: Name of device where erofs is mounted
+ * @data: Mount options
+ *
+ * Returns: Pointer to VFS dentry structure.
+ * 	    The root dentry.
+ */
 static struct dentry *erofs_mount(
 	struct file_system_type *fs_type, int flags,
 	const char *dev_name, void *data)
@@ -532,10 +616,21 @@ static struct dentry *erofs_mount(
 		.options = data
 	};
 
+	/*
+	 * Mount filesystem residing on a block device
+	 * provide a callback (erofs_fill_super)  to
+	 * populate superblock
+	 */
 	return mount_bdev(fs_type, flags, dev_name,
 		&priv, erofs_fill_super);
 }
 
+/**
+ * erofs_kill_sb(): Called when erofs is getting shutdown/killed 
+ *
+ * @sb: VFS superblock structure
+ *
+ */
 static void erofs_kill_sb(struct super_block *sb)
 {
 	kill_block_super(sb);
@@ -550,6 +645,11 @@ static struct file_system_type erofs_fs_type = {
 };
 MODULE_ALIAS_FS("erofs");
 
+/**
+ * erofs_module_init(): Called when module is loaded
+ *
+ * returns: 0 on Success. Error Otherwise
+ */
 static int __init erofs_module_init(void)
 {
 	int err;
@@ -586,6 +686,9 @@ static int __init erofs_module_init(void)
 	return err;
 }
 
+/**
+ * erofs_module_exit(): Called when module is un-loaded
+ */
 static void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
@@ -595,7 +698,14 @@ static void __exit erofs_module_exit(void)
 	infoln("successfully finalize erofs");
 }
 
-/* get filesystem statistics */
+/**
+ * erofs_statfs(): Get erofs statistics
+ *
+ * @dentry: Directory from where stats is collected
+ * @buf: Buffer where stats info is stored
+ *
+ * Returns: 0 on Success
+ */
 static int erofs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -617,6 +727,14 @@ static int erofs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
+/**
+ * erofs_show_options(): Show currently active mount options
+ *
+ * @seq: Sequence interface (iterator)
+ * @root: VFS dentry structure of mounted FS
+ *
+ * Returns: 0 on Success, < 0 on error
+ */
 static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct erofs_sb_info *sbi __maybe_unused = EROFS_SB(root->d_sb);
@@ -639,6 +757,15 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 	return 0;
 }
 
+/**
+ * erofs_remount(): Called when erofs is remounted
+ *
+ * @sb: VFS superblock structure
+ * @flags: Mount flags/options
+ * @data: Mount options
+ *
+ * Returns: 0 on Success. Errno otherwise
+ */
 static int erofs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
-- 
2.14.3
