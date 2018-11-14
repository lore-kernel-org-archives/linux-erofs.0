From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 14 Nov 2018 23:25:45 +0800
Subject: [PATCH chao/erofs-dev rebased v2 06/12] staging: erofs:
 atomic_cond_read_relaxed on ref-locked workgroup
In-Reply-To: <20181114152548.37921-1-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
Message-ID: <20181114152548.37921-6-gaoxiang25@huawei.com>

It's better to use atomic_cond_read_relaxed, which is implemented
in hardware instructions to monitor a variable changes currently
for ARM64, instead of open-coded busy waiting.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 57575c7f5635..8e25e5c39f69 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -221,23 +221,29 @@ static inline void erofs_workgroup_unfreeze(
 	preempt_enable();
 }
 
+#if defined(CONFIG_SMP)
+static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
+{
+	return atomic_cond_read_relaxed(&grp->refcount,
+					VAL != EROFS_LOCKED_MAGIC);
+}
+#else
+static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
+{
+	int v = atomic_read(&grp->refcount);
+
+	/* workgroup is never freezed on uniprocessor systems */
+	DBG_BUGON(v == EROFS_LOCKED_MAGIC);
+	return v;
+}
+#endif
+
 static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
 {
-	const int locked = (int)EROFS_LOCKED_MAGIC;
 	int o;
 
 repeat:
-	o = atomic_read(&grp->refcount);
-
-	/* spin if it is temporarily locked at the reclaim path */
-	if (unlikely(o == locked)) {
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-		do
-			cpu_relax();
-		while (atomic_read(&grp->refcount) == locked);
-#endif
-		goto repeat;
-	}
+	o = erofs_wait_on_workgroup_freezed(grp);
 
 	if (unlikely(o <= 0))
 		return -1;
-- 
2.14.4
