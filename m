From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 22:14:39 +0800
Subject: [PATCH v3 chao/erofs-dev 05/14] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <20181120141448.29483-1-gaoxiang25@huawei.com>
References: <20181120141448.29483-1-gaoxiang25@huawei.com>
Message-ID: <20181120141448.29483-5-gaoxiang25@huawei.com>

Just like other generic locks, insert a full barrier
in case of memory reorder.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 2e0ef92c138b..f77653d33633 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -209,6 +209,7 @@ static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
 static inline void erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
 					    int orig_val)
 {
+	smp_mb();
 	atomic_set(&grp->refcount, orig_val);
 	preempt_enable();
 }
-- 
2.14.4
