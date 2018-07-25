From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 25 Jul 2018 10:26:34 +0800
Subject: [RFC PATCH v2 21/25] staging: erofs: introduce erofs shrinker
In-Reply-To: <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
 <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532485598-63393-22-git-send-email-gaoxiang25@huawei.com>

This patch adds a dedicated shrinker targeting to free unneeded
memory consumed by a number of erofs in-memory data structures.

Like F2FS and UBIFS, it also adds:
  - sbi->umount_mutex to avoid races on shrinker and put_super
  - sbi->shrinker_run_no to not revisit recently scaned objects

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h |  7 ++++
 drivers/staging/erofs/super.c    | 15 +++++++
 drivers/staging/erofs/utils.c    | 85 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 18e7b9c..42455f0 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -66,6 +66,7 @@ struct erofs_fault_info {
 struct erofs_sb_info {
 	/* list for all registered superblocks, mainly for shrinker */
 	struct list_head list;
+	struct mutex umount_mutex;
 
 	u32 blocks;
 	u32 meta_blkaddr;
@@ -93,6 +94,7 @@ struct erofs_sb_info {
 	char *dev_name;
 
 	unsigned int mount_opt;
+	unsigned int shrinker_run_no;
 
 #ifdef CONFIG_EROFS_FAULT_INJECTION
 	struct erofs_fault_info fault_info;	/* For fault injection */
@@ -416,6 +418,11 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 extern void erofs_register_super(struct super_block *sb);
 extern void erofs_unregister_super(struct super_block *sb);
 
+extern unsigned long erofs_shrink_count(struct shrinker *shrink,
+	struct shrink_control *sc);
+extern unsigned long erofs_shrink_scan(struct shrinker *shrink,
+	struct shrink_control *sc);
+
 #ifndef lru_to_page
 #define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
 #endif
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index e42d3a5..61132f3 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -375,7 +375,9 @@ static void erofs_put_super(struct super_block *sb)
 	infoln("unmounted for %s", sbi->dev_name);
 	__putname(sbi->dev_name);
 
+	mutex_lock(&sbi->umount_mutex);
 	erofs_unregister_super(sb);
+	mutex_unlock(&sbi->umount_mutex);
 
 	kfree(sbi);
 	sb->s_fs_info = NULL;
@@ -415,6 +417,12 @@ static void erofs_kill_sb(struct super_block *sb)
 	kill_block_super(sb);
 }
 
+static struct shrinker erofs_shrinker_info = {
+	.scan_objects = erofs_shrink_scan,
+	.count_objects = erofs_shrink_count,
+	.seeks = DEFAULT_SEEKS,
+};
+
 static struct file_system_type erofs_fs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "erofs",
@@ -435,6 +443,10 @@ int __init erofs_module_init(void)
 	if (err)
 		goto icache_err;
 
+	err = register_shrinker(&erofs_shrinker_info);
+	if (err)
+		goto shrinker_err;
+
 	err = register_filesystem(&erofs_fs_type);
 	if (err)
 		goto fs_err;
@@ -443,6 +455,8 @@ int __init erofs_module_init(void)
 	return 0;
 
 fs_err:
+	unregister_shrinker(&erofs_shrinker_info);
+shrinker_err:
 	erofs_exit_inode_cache();
 icache_err:
 	return err;
@@ -451,6 +465,7 @@ int __init erofs_module_init(void)
 void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
+	unregister_shrinker(&erofs_shrinker_info);
 	erofs_exit_inode_cache();
 	infoln("successfully finalize erofs");
 }
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 6748def..c1d83ce 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -29,20 +29,93 @@ struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 	return page;
 }
 
-static DEFINE_MUTEX(erofs_sb_list_lock);
+
+/* protected by 'erofs_sb_list_lock' */
+static unsigned int shrinker_run_no;
+
+/* protects the mounted 'erofs_sb_list' */
+static DEFINE_SPINLOCK(erofs_sb_list_lock);
 static LIST_HEAD(erofs_sb_list);
 
+/* global shrink count (for all mounted EROFS instances) */
+static atomic_long_t erofs_global_shrink_cnt;
+
 void erofs_register_super(struct super_block *sb)
 {
-	mutex_lock(&erofs_sb_list_lock);
-	list_add(&EROFS_SB(sb)->list, &erofs_sb_list);
-	mutex_unlock(&erofs_sb_list_lock);
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+
+	mutex_init(&sbi->umount_mutex);
+
+	spin_lock(&erofs_sb_list_lock);
+	list_add(&sbi->list, &erofs_sb_list);
+	spin_unlock(&erofs_sb_list_lock);
 }
 
 void erofs_unregister_super(struct super_block *sb)
 {
-	mutex_lock(&erofs_sb_list_lock);
+	spin_lock(&erofs_sb_list_lock);
 	list_del(&EROFS_SB(sb)->list);
-	mutex_unlock(&erofs_sb_list_lock);
+	spin_unlock(&erofs_sb_list_lock);
+}
+
+unsigned long erofs_shrink_count(struct shrinker *shrink,
+				 struct shrink_control *sc)
+{
+	return atomic_long_read(&erofs_global_shrink_cnt);
+}
+
+unsigned long erofs_shrink_scan(struct shrinker *shrink,
+				struct shrink_control *sc)
+{
+	struct erofs_sb_info *sbi;
+	struct list_head *p;
+
+	unsigned long nr = sc->nr_to_scan;
+	unsigned int run_no;
+	unsigned long freed = 0;
+
+	spin_lock(&erofs_sb_list_lock);
+	do
+		run_no = ++shrinker_run_no;
+	while (run_no == 0);
+
+	/* Iterate over all mounted superblocks and try to shrink them */
+	p = erofs_sb_list.next;
+	while (p != &erofs_sb_list) {
+		sbi = list_entry(p, struct erofs_sb_info, list);
+
+		/*
+		 * We move the ones we do to the end of the list, so we stop
+		 * when we see one we have already done.
+		 */
+		if (sbi->shrinker_run_no == run_no)
+			break;
+
+		if (!mutex_trylock(&sbi->umount_mutex)) {
+			p = p->next;
+			continue;
+		}
+
+		spin_unlock(&erofs_sb_list_lock);
+		sbi->shrinker_run_no = run_no;
+
+		/* add scan handlers here */
+
+		spin_lock(&erofs_sb_list_lock);
+		/* Get the next list element before we move this one */
+		p = p->next;
+
+		/*
+		 * Move this one to the end of the list to provide some
+		 * fairness.
+		 */
+		list_move_tail(&sbi->list, &erofs_sb_list);
+		mutex_unlock(&sbi->umount_mutex);
+
+		if (freed >= nr)
+			break;
+	}
+	spin_unlock(&erofs_sb_list_lock);
+	return freed;
 }
 
-- 
1.9.1
