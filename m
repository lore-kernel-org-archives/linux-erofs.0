From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 14 Nov 2018 23:25:47 +0800
Subject: [PATCH chao/erofs-dev rebased v2 08/12] staging: erofs: add a full
 barrier in erofs_workgroup_unfreeze
In-Reply-To: <20181114152548.37921-1-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
Message-ID: <20181114152548.37921-8-gaoxiang25@huawei.com>

Just like other generic locks, insert a full barrier
in case of memory reorder.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index de1e189515d6..c91bc2ea9c26 100644
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
