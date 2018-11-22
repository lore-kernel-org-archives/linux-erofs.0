From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 23 Nov 2018 01:16:03 +0800
Subject: [PATCH v2 06/10] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <1542906967-249-1-git-send-email-hsiangkao@aol.com>
References: <1542906967-249-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1542906967-249-7-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

Just like other generic locks, insert a full barrier
in case of memory reorder.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 399a7003e783..892944355867 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -209,6 +209,11 @@ static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
 static inline void erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
 					    int orig_val)
 {
+	/*
+	 * other observers should notice all modifications
+	 * in the freezing period.
+	 */
+	smp_mb();
 	atomic_set(&grp->refcount, orig_val);
 	preempt_enable();
 }
-- 
2.11.0
