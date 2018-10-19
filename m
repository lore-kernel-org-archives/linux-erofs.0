From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 19 Oct 2018 17:52:52 +0800
Subject: [PREVIEW] [RFC PATCH 1/2] staging: erofs: atomic_cond_read_relaxed on
 ref-locked workgroup
Message-ID: <20181019095253.32004-1-gaoxiang25@huawei.com>

It's better to use atomic_cond_read_relaxed, which is implemented
in hardware instructions to monitor a variable changes currently
for ARM64, instead of open-coded busy waiting.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 57575c7f5635..a2604ae33e74 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -227,17 +227,13 @@ static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
 	int o;
 
 repeat:
+#if defined(CONFIG_SMP)
+	o = atomic_cond_read_relaxed(&grp->refcount, VAL != locked);
+#else
 	o = atomic_read(&grp->refcount);
 
-	/* spin if it is temporarily locked at the reclaim path */
-	if (unlikely(o == locked)) {
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-		do
-			cpu_relax();
-		while (atomic_read(&grp->refcount) == locked);
+	BUG_ON(o == locked);
 #endif
-		goto repeat;
-	}
 
 	if (unlikely(o <= 0))
 		return -1;
-- 
2.14.4
