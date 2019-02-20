From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 20 Feb 2019 17:18:51 +0800
Subject: [PATCH for-4.19 09/12] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <20190220091854.19242-1-gaoxiang25@huawei.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
Message-ID: <20190220091854.19242-10-gaoxiang25@huawei.com>

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
index c4c9caf84639..2e9a9a4b4226 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -199,6 +199,11 @@ static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
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
2.14.4
