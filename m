From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 20 Jul 2018 10:52:42 +0800
Subject: [RFC PATCH v2 07/11] erofs: introduce superblock registration
In-Reply-To: <1532055166-96837-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1532055166-96837-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532055166-96837-8-git-send-email-gaoxiang25@huawei.com>

In order to introducing shrink solution for erofs,
let's manage all mounted erofs instances at first.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/internal.h |  6 ++++++
 fs/erofs/super.c    |  4 ++++
 fs/erofs/utils.c    | 17 +++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 2d1df84..06cf508 100644
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
@@ -431,5 +434,8 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 /* utils.c */
 extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
 
+extern void erofs_register_super(struct super_block *sb);
+extern void erofs_unregister_super(struct super_block *sb);
+
 #endif
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ab0e4cd..6d51ec5 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -317,6 +317,8 @@ static int erofs_read_super(struct super_block *sb,
 	snprintf(sbi->dev_name, PATH_MAX, "%s", dev_name);
 	sbi->dev_name[PATH_MAX - 1] = '\0';
 
+	erofs_register_super(sb);
+
 	/*
 	 * We already have a positive dentry, which was instantiated
 	 * by d_make_root. Just need to d_rehash it.
@@ -354,6 +356,8 @@ static void erofs_put_super(struct super_block *sb)
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
