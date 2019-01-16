From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 16:59:54 +0800
Subject: [PATCH 3/5] staging: erofs: decrease the shrink count in
 erofs_workgroup_get
In-Reply-To: <20190116085956.21004-1-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
Message-ID: <20190116085956.21004-3-gaoxiang25@huawei.com>

It is more suitable to update in erofs_workgroup_get since
it's actually the one matched with erofs_workgroup_put.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/utils.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index d24945aab133..5695efaeb43a 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -34,29 +34,29 @@ static atomic_long_t erofs_global_shrink_cnt;
 #define __erofs_workgroup_get(grp)	atomic_inc(&(grp)->refcount)
 #define __erofs_workgroup_put(grp)	atomic_dec(&(grp)->refcount)
 
-static int erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
+static int erofs_workgroup_get(struct erofs_workgroup *grp)
 {
 	int o;
 
 repeat:
 	o = erofs_wait_on_workgroup_freezed(grp);
-
 	if (unlikely(o <= 0))
 		return -1;
 
 	if (unlikely(atomic_cmpxchg(&grp->refcount, o, o + 1) != o))
 		goto repeat;
 
-	*ocnt = o;
+	/* decrease refcount paired by erofs_workgroup_put */
+	if (unlikely(o == 1))
+		atomic_long_dec(&erofs_global_shrink_cnt);
 	return 0;
 }
 
-struct erofs_workgroup *erofs_find_workgroup(
-	struct super_block *sb, pgoff_t index, bool *tag)
+struct erofs_workgroup *erofs_find_workgroup(struct super_block *sb,
+					     pgoff_t index, bool *tag)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 	struct erofs_workgroup *grp;
-	int oldcount;
 
 repeat:
 	rcu_read_lock();
@@ -65,15 +65,12 @@ struct erofs_workgroup *erofs_find_workgroup(
 		*tag = xa_pointer_tag(grp);
 		grp = xa_untag_pointer(grp);
 
-		if (erofs_workgroup_get(grp, &oldcount)) {
+		if (erofs_workgroup_get(grp)) {
 			/* prefer to relax rcu read side */
 			rcu_read_unlock();
 			goto repeat;
 		}
 
-		/* decrease refcount added by erofs_workgroup_put */
-		if (unlikely(oldcount == 1))
-			atomic_long_dec(&erofs_global_shrink_cnt);
 		DBG_BUGON(index != grp->index);
 	}
 	rcu_read_unlock();
-- 
2.14.4
