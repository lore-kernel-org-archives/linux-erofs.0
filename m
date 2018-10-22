From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 22 Oct 2018 17:51:22 +0800
Subject: [PATCH chao/erofs-dev] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <b4ec415e-2d3e-a9bc-bfa4-6b38cc5228b5@kernel.org>
References: <b4ec415e-2d3e-a9bc-bfa4-6b38cc5228b5@kernel.org>
Message-ID: <20181022095122.2129-1-gaoxiang25@huawei.com>

Just like other generic locks, insert a full barrier
in case of memory reorder.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 9d7ed3d130e3..bec439e2b428 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -218,6 +218,8 @@ erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
 			 int orig_val)
 {
 #if defined(CONFIG_SMP)
+	smp_mb();
+
 	atomic_set(&grp->refcount, orig_val);
 #endif
 	preempt_enable();
-- 
2.14.4
