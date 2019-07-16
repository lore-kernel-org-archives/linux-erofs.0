From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 16 Jul 2019 16:52:59 +0800
Subject: [PATCH] staging: erofs: avoid opened loop codes
Message-ID: <20190716085259.103481-1-yuchao0@huawei.com>

Use __GFP_NOFAIL to avoid opened loop codes in z_erofs_vle_unzip().

Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index f0dab81ff816..3a0dbcb8cc9f 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -921,18 +921,17 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		 mutex_trylock(&z_pagemap_global_lock))
 		pages = z_pagemap_global;
 	else {
-repeat:
-		pages = kvmalloc_array(nr_pages, sizeof(struct page *),
-				       GFP_KERNEL);
+		gfp_t flags = GFP_KERNEL;
+
+		if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
+			flags |= __GFP_NOFAIL;
+
+		pages = kvmalloc_array(nr_pages, sizeof(struct page *), flags);
 
 		/* fallback to global pagemap for the lowmem scenario */
 		if (unlikely(!pages)) {
-			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
-				goto repeat;
-			else {
-				mutex_lock(&z_pagemap_global_lock);
-				pages = z_pagemap_global;
-			}
+			mutex_lock(&z_pagemap_global_lock);
+			pages = z_pagemap_global;
 		}
 	}
 
-- 
2.18.0.rc1
