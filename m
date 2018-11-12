From: sicilia.cristian@gmail.com (Cristian Sicilia)
Date: Mon, 12 Nov 2018 21:43:59 +0100
Subject: [PATCH 3/3] staging: erofs: unzip_vle.c: Align parameter to the
 parentesis
In-Reply-To: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>
References: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>
Message-ID: <1542055439-24444-4-git-send-email-sicilia.cristian@gmail.com>

Align parameters to the opened parentesis.

Signed-off-by: Cristian Sicilia <sicilia.cristian at gmail.com>
---
 drivers/staging/erofs/unzip_vle.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 35add4e..6a283f6 100644
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
2.7.4
