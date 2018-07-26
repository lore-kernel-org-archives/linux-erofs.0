From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 26 Jul 2018 20:22:03 +0800
Subject: [PATCH 20/25] staging: erofs: introduce superblock registration
In-Reply-To: <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
References: <1527764767-22190-1-git-send-email-gaoxiang25@huawei.com>
 <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532607728-103372-21-git-send-email-gaoxiang25@huawei.com>

In order to introducing shrinker solution for erofs,
let's manage all mounted erofs instances at first.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h |  6 ++++++
 drivers/staging/erofs/super.c    |  4 ++++
 drivers/staging/erofs/utils.c    | 17 +++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index e61d417..18e7b9c 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -64,6 +64,9 @@ struct erofs_fault_info {
 typedef u64 erofs_nid_t;
 
 struct erofs_sb_info {
+	/* list for all registered superblocks, mainly for shrinker */
+	struct list_head list;
+
 	u32 blocks;
 	u32 meta_blkaddr;
 #ifdef CONFIG_EROFS_FS_XATTR
@@ -410,6 +413,9 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 /* utils.c */
 extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
 
+extern void erofs_register_super(struct super_block *sb);
+extern void erofs_unregister_super(struct super_block *sb);
+
 #ifndef lru_to_page
 #define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
 #endif
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 054375d..f455d71 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -326,6 +326,8 @@ static int erofs_read_super(struct super_block *sb,
 	snprintf(sbi->dev_name, PATH_MAX, "%s", dev_name);
 	sbi->dev_name[PATH_MAX - 1] = '\0';
 
+	erofs_register_super(sb);
+
 	/*
 	 * We already have a positive dentry, which was instantiated
 	 * by d_make_root. Just need to d_rehash it.
@@ -373,6 +375,8 @@ static void erofs_put_super(struct super_block *sb)
 	infoln("unmounted for %s", sbi->dev_name);
 	__putname(sbi->dev_name);
 
+	erofs_unregister_super(sb);
+
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 }
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 3dec4f8..6748def 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
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
