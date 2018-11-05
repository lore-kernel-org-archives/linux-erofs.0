From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 18:45:00 +0800
Subject: [PATCH 4.20-rc1 rebased 07/10] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <20181105104503.45627-1-gaoxiang25@huawei.com>
References: <20181105104503.45627-1-gaoxiang25@huawei.com>
Message-ID: <20181105104503.45627-7-gaoxiang25@huawei.com>

Just like other generic locks, insert a full barrier
in case of memory reorder.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 660b2c5985dd..950b845346f9 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -217,6 +217,8 @@ erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
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
