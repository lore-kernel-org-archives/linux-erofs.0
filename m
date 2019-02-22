From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 22 Feb 2019 23:46:34 +0800
Subject: [PATCH for-4.20 4/7] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <20190222154637.22785-1-gaoxiang25@huawei.com>
References: <20190222154637.22785-1-gaoxiang25@huawei.com>
Message-ID: <20190222154637.22785-5-gaoxiang25@huawei.com>

commit 948bbdb1818b7ad6e539dad4fbd2dd4650793ea9 upstream.

Just like other generic locks, insert a full barrier
in case of memory reorder.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
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
2.14.5
