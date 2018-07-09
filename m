From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 10 Jul 2018 03:17:16 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.7 07/10] erofs: introduce superblock
 registration
In-Reply-To: <1531163839-29830-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1531163839-29830-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1531163839-29830-8-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/internal.h |  6 ++++++
 fs/erofs/super.c    |  4 ++++
 fs/erofs/utils.c    | 17 +++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 038d77b..cc898b4 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -65,6 +65,9 @@ struct erofs_fault_info {
 typedef u64 erofs_nid_t;
 
 struct erofs_sb_info {
+	/* list for all registered superblocks, mainly for shrinker */
+	struct list_head list;
+
 	u32 blocks;
 	u32 meta_blkaddr;
 #ifdef CONFIG_EROFS_FS_XATTR
@@ -430,5 +433,8 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 /* utils.c */
 extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
 
+extern void erofs_register_super(struct super_block *sb);
+extern void erofs_unregister_super(struct super_block *sb);
+
 #endif
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 0dcf9c7..3d286f4 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -315,6 +315,8 @@ static int erofs_read_super(struct super_block *sb,
 	snprintf(sbi->dev_name, PATH_MAX, "%s", dev_name);
 	sbi->dev_name[PATH_MAX - 1] = '\0';
 
+	erofs_register_super(sb);
+
 	/*
 	 * We already have a positive dentry, which was instantiated
 	 * by d_make_root. Just need to d_rehash it.
@@ -352,6 +354,8 @@ static void erofs_put_super(struct super_block *sb)
 	infoln("unmounted for %s", sbi->dev_name);
 	__putname(sbi->dev_name);
 
+	erofs_unregister_super(sb);
+
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 }
diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index dce5177..78731c5 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -29,3 +29,20 @@ struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 	return page;
 }
 
+static DEFINE_MUTEX(erofs_sb_list_lock);
+static LIST_HEAD(erofs_sb_list);
+
+void erofs_register_super(struct super_block *sb)
+{
+	mutex_lock(&erofs_sb_list_lock);
+	list_add(&EROFS_SB(sb)->list, &erofs_sb_list);
+	mutex_unlock(&erofs_sb_list_lock);
+}
+
+void erofs_unregister_super(struct super_block *sb)
+{
+	mutex_lock(&erofs_sb_list_lock);
+	list_del(&EROFS_SB(sb)->list);
+	mutex_unlock(&erofs_sb_list_lock);
+}
+
-- 
1.9.1
