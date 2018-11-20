From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 22:14:38 +0800
Subject: [PATCH v3 chao/erofs-dev 04/14] staging: erofs: fix
 `erofs_workgroup_{try_to_freeze, unfreeze}'
In-Reply-To: <20181120141448.29483-1-gaoxiang25@huawei.com>
References: <20181120141448.29483-1-gaoxiang25@huawei.com>
Message-ID: <20181120141448.29483-4-gaoxiang25@huawei.com>

There are two minor issues in the current freeze interface:

   1) Freeze interfaces have not related with CONFIG_DEBUG_SPINLOCK,
      therefore fix the incorrect conditions;

   2) For SMP platforms, it should also disable preemption before
      doing atomic_cmpxchg in case that some high priority tasks
      preempt between atomic_cmpxchg and disable_preempt, then spin
      on the locked refcount later.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 41 ++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index eb80ba44d072..2e0ef92c138b 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -194,40 +194,49 @@ struct erofs_workgroup {
 
 #define EROFS_LOCKED_MAGIC     (INT_MIN | 0xE0F510CCL)
 
-static inline bool erofs_workgroup_try_to_freeze(
-	struct erofs_workgroup *grp, int v)
+#if defined(CONFIG_SMP)
+static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
+						 int val)
 {
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	if (v != atomic_cmpxchg(&grp->refcount,
-		v, EROFS_LOCKED_MAGIC))
-		return false;
 	preempt_disable();
-#else
-	preempt_disable();
-	if (atomic_read(&grp->refcount) != v) {
+	if (val != atomic_cmpxchg(&grp->refcount, val, EROFS_LOCKED_MAGIC)) {
 		preempt_enable();
 		return false;
 	}
-#endif
 	return true;
 }
 
-static inline void erofs_workgroup_unfreeze(
-	struct erofs_workgroup *grp, int v)
+static inline void erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
+					    int orig_val)
 {
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	atomic_set(&grp->refcount, v);
-#endif
+	atomic_set(&grp->refcount, orig_val);
 	preempt_enable();
 }
 
-#if defined(CONFIG_SMP)
 static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 {
 	return atomic_cond_read_relaxed(&grp->refcount,
 					VAL != EROFS_LOCKED_MAGIC);
 }
 #else
+static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
+						 int val)
+{
+	preempt_disable();
+	/* no need to spin on UP platforms, let's just disable preemption. */
+	if (val != atomic_read(&grp->refcount)) {
+		preempt_enable();
+		return false;
+	}
+	return true;
+}
+
+static inline void erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
+					    int orig_val)
+{
+	preempt_enable();
+}
+
 static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 {
 	int v = atomic_read(&grp->refcount);
-- 
2.14.4
