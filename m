From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 19 Oct 2018 17:52:53 +0800
Subject: [PREVIEW] [RFC PATCH 2/2] staging: erofs: fix
 `erofs_workgroup_{try_to_freeze, unfreeze}'
In-Reply-To: <20181019095253.32004-1-gaoxiang25@huawei.com>
References: <20181019095253.32004-1-gaoxiang25@huawei.com>
Message-ID: <20181019095253.32004-2-gaoxiang25@huawei.com>

There are two minor issues in the current freeze interface:

   1) Freeze interfaces have not related with CONFIG_DEBUG_SPINLOCK,
      therefore fix the incorrect conditions;

   2) For SMP platforms, it should also disable preemption before
      doing atomic_cmpxchg in case that some high priority tasks
      preempt between atomic_cmpxchg and disable_preempt, then spin
      on the locked refcount later.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index a2604ae33e74..9d7ed3d130e3 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -194,29 +194,31 @@ struct erofs_workgroup {
 
 #define EROFS_LOCKED_MAGIC     (INT_MIN | 0xE0F510CCL)
 
-static inline bool erofs_workgroup_try_to_freeze(
-	struct erofs_workgroup *grp, int v)
+static inline bool
+erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
+			      int val)
 {
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	if (v != atomic_cmpxchg(&grp->refcount,
-		v, EROFS_LOCKED_MAGIC))
-		return false;
+
 	preempt_disable();
+#if defined(CONFIG_SMP)
+	if (val != atomic_cmpxchg(&grp->refcount, val,
+				  EROFS_LOCKED_MAGIC)) {
 #else
-	preempt_disable();
-	if (atomic_read(&grp->refcount) != v) {
+	/* no need to spin on UP platforms, just disable preemption. */
+	if (val != atomic_read(&grp->refcount)) {
+#endif
 		preempt_enable();
 		return false;
 	}
-#endif
 	return true;
 }
 
-static inline void erofs_workgroup_unfreeze(
-	struct erofs_workgroup *grp, int v)
+static inline void
+erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
+			 int orig_val)
 {
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	atomic_set(&grp->refcount, v);
+#if defined(CONFIG_SMP)
+	atomic_set(&grp->refcount, orig_val);
 #endif
 	preempt_enable();
 }
-- 
2.14.4
