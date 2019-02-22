From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 22 Feb 2019 23:46:32 +0800
Subject: [PATCH for-4.20 2/7] staging: erofs: atomic_cond_read_relaxed on
 ref-locked workgroup
In-Reply-To: <20190222154637.22785-1-gaoxiang25@huawei.com>
References: <20190222154637.22785-1-gaoxiang25@huawei.com>
Message-ID: <20190222154637.22785-3-gaoxiang25@huawei.com>

commit df134b8d17b90c1e7720e318d36416b57424ff7a upstream.

It's better to use atomic_cond_read_relaxed, which is implemented
in hardware instructions to monitor a variable changes currently
for ARM64, instead of open-coded busy waiting.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 3ac4599bbe01..f933ab602c37 100644
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
2.14.5
