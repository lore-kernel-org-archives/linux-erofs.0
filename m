From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 14 Nov 2018 23:25:42 +0800
Subject: [PATCH chao/erofs-dev rebased v2 03/12] staging: erofs: unzip_vle.c:
 Align parameter to the parentesis
In-Reply-To: <20181114152548.37921-1-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
Message-ID: <20181114152548.37921-3-gaoxiang25@huawei.com>

From: Cristian Sicilia <sicilia.cristian@gmail.com>

Align parameters to the opened parentesis.

Signed-off-by: Cristian Sicilia <sicilia.cristian at gmail.com>
---
 drivers/staging/erofs/unzip_vle.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 35add4eb3057..6a283f618f46 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -35,9 +35,10 @@ static inline int init_unzip_workqueue(void)
 	 * we don't need too many threads, limiting threads
 	 * could improve scheduling performance.
 	 */
-	z_erofs_workqueue = alloc_workqueue("erofs_unzipd",
-		WQ_UNBOUND | WQ_HIGHPRI | WQ_CPU_INTENSIVE,
-		onlinecpus + onlinecpus / 4);
+	z_erofs_workqueue =
+		alloc_workqueue("erofs_unzipd",
+				WQ_UNBOUND | WQ_HIGHPRI | WQ_CPU_INTENSIVE,
+				onlinecpus + onlinecpus / 4);
 
 	return z_erofs_workqueue ? 0 : -ENOMEM;
 }
@@ -46,8 +47,8 @@ int __init z_erofs_init_zip_subsystem(void)
 {
 	z_erofs_workgroup_cachep =
 		kmem_cache_create("erofs_compress",
-		Z_EROFS_WORKGROUP_SIZE, 0,
-		SLAB_RECLAIM_ACCOUNT, NULL);
+				  Z_EROFS_WORKGROUP_SIZE, 0,
+				  SLAB_RECLAIM_ACCOUNT, NULL);
 
 	if (z_erofs_workgroup_cachep) {
 		if (!init_unzip_workqueue())
-- 
2.14.4
