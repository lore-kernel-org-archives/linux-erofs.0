From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 16:59:55 +0800
Subject: [PATCH 4/5] staging: erofs: staticize erofs_shrink_count,
 erofs_shrink_scan
In-Reply-To: <20190116085956.21004-1-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
Message-ID: <20190116085956.21004-4-gaoxiang25@huawei.com>

Move erofs_shrinker_info to utils.c and therefore
no need to globalize erofs_shrink_count and erofs_shrink_scan.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h |  5 +----
 drivers/staging/erofs/super.c    |  6 ------
 drivers/staging/erofs/utils.c    | 14 ++++++++++----
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 967ec1a56726..304c79d253ae 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -589,10 +589,7 @@ extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
 extern void erofs_register_super(struct super_block *sb);
 extern void erofs_unregister_super(struct super_block *sb);
 
-extern unsigned long erofs_shrink_count(struct shrinker *shrink,
-	struct shrink_control *sc);
-extern unsigned long erofs_shrink_scan(struct shrinker *shrink,
-	struct shrink_control *sc);
+extern struct shrinker erofs_shrinker_info;
 
 #ifndef lru_to_page
 #define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 69e1840d3842..af5140eede18 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -539,12 +539,6 @@ static void erofs_kill_sb(struct super_block *sb)
 	kill_block_super(sb);
 }
 
-static struct shrinker erofs_shrinker_info = {
-	.scan_objects = erofs_shrink_scan,
-	.count_objects = erofs_shrink_count,
-	.seeks = DEFAULT_SEEKS,
-};
-
 static struct file_system_type erofs_fs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "erofs",
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 5695efaeb43a..5f61f99f4c10 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -270,14 +270,14 @@ void erofs_unregister_super(struct super_block *sb)
 	spin_unlock(&erofs_sb_list_lock);
 }
 
-unsigned long erofs_shrink_count(struct shrinker *shrink,
-				 struct shrink_control *sc)
+static unsigned long erofs_shrink_count(struct shrinker *shrink,
+					struct shrink_control *sc)
 {
 	return atomic_long_read(&erofs_global_shrink_cnt);
 }
 
-unsigned long erofs_shrink_scan(struct shrinker *shrink,
-				struct shrink_control *sc)
+static unsigned long erofs_shrink_scan(struct shrinker *shrink,
+				       struct shrink_control *sc)
 {
 	struct erofs_sb_info *sbi;
 	struct list_head *p;
@@ -333,3 +333,9 @@ unsigned long erofs_shrink_scan(struct shrinker *shrink,
 	return freed;
 }
 
+struct shrinker erofs_shrinker_info = {
+	.scan_objects = erofs_shrink_scan,
+	.count_objects = erofs_shrink_count,
+	.seeks = DEFAULT_SEEKS,
+};
+
-- 
2.14.4
