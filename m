From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 16:59:53 +0800
Subject: [PATCH 2/5] staging: erofs: localize erofs_workgroup_get
In-Reply-To: <20190116085956.21004-1-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
Message-ID: <20190116085956.21004-2-gaoxiang25@huawei.com>

Staticize erofs_workgroup_get since no external user
out of utils.c directly calls erofs_workgroup_get.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 21 ---------------------
 drivers/staging/erofs/utils.c    | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 80cc09ea787d..967ec1a56726 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -252,28 +252,7 @@ static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 }
 #endif
 
-static inline int erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
-{
-	int o;
-
-repeat:
-	o = erofs_wait_on_workgroup_freezed(grp);
-
-	if (unlikely(o <= 0))
-		return -1;
-
-	if (unlikely(atomic_cmpxchg(&grp->refcount, o, o + 1) != o))
-		goto repeat;
-
-	*ocnt = o;
-	return 0;
-}
-
-#define __erofs_workgroup_get(grp)	atomic_inc(&(grp)->refcount)
-#define __erofs_workgroup_put(grp)	atomic_dec(&(grp)->refcount)
-
 extern int erofs_workgroup_put(struct erofs_workgroup *grp);
-
 extern struct erofs_workgroup *erofs_find_workgroup(
 	struct super_block *sb, pgoff_t index, bool *tag);
 
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index aed211cd5875..d24945aab133 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -31,6 +31,25 @@ struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 static atomic_long_t erofs_global_shrink_cnt;
 
 #ifdef CONFIG_EROFS_FS_ZIP
+#define __erofs_workgroup_get(grp)	atomic_inc(&(grp)->refcount)
+#define __erofs_workgroup_put(grp)	atomic_dec(&(grp)->refcount)
+
+static int erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
+{
+	int o;
+
+repeat:
+	o = erofs_wait_on_workgroup_freezed(grp);
+
+	if (unlikely(o <= 0))
+		return -1;
+
+	if (unlikely(atomic_cmpxchg(&grp->refcount, o, o + 1) != o))
+		goto repeat;
+
+	*ocnt = o;
+	return 0;
+}
 
 struct erofs_workgroup *erofs_find_workgroup(
 	struct super_block *sb, pgoff_t index, bool *tag)
-- 
2.14.4
