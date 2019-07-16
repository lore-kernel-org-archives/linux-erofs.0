From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 16 Jul 2019 17:44:22 +0800
Subject: [PATCH v2] staging: erofs: avoid opened loop codes
Message-ID: <20190716094422.110805-1-yuchao0@huawei.com>

Use __GFP_NOFAIL to avoid opened loop codes in z_erofs_vle_unzip().

Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
v2:
- change variable name from 'flags' to 'gfp_flags' to avoid common
name.
 drivers/staging/erofs/unzip_vle.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index f0dab81ff816..56c009cf611e 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -921,18 +921,18 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		 mutex_trylock(&z_pagemap_global_lock))
 		pages = z_pagemap_global;
 	else {
-repeat:
+		gfp_t gfp_flags = GFP_KERNEL;
+
+		if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
+			gfp_flags |= __GFP_NOFAIL;
+
 		pages = kvmalloc_array(nr_pages, sizeof(struct page *),
-				       GFP_KERNEL);
+				       gfp_flags);
 
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
