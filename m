From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 13 Aug 2019 10:30:53 +0800
Subject: [PATCH 2/3] staging: erofs: remove incomplete cleancache
In-Reply-To: <20190813023054.73126-1-gaoxiang25@huawei.com>
References: <20190813023054.73126-1-gaoxiang25@huawei.com>
Message-ID: <20190813023054.73126-2-gaoxiang25@huawei.com>

cleancache was not fully implemented in EROFS.
In addition, it's tend to remove the whole cleancache in
related attempt [1].

[1] https://lore.kernel.org/linux-fsdevel/20190527103207.13287-3-jgross at suse.com/
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/data.c     | 6 ------
 drivers/staging/erofs/internal.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 75b859e48084..4cdb743c8b8d 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -201,12 +201,6 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 		goto has_updated;
 	}
 
-	if (cleancache_get_page(page) == 0) {
-		err = 0;
-		SetPageUptodate(page);
-		goto has_updated;
-	}
-
 	/* note that for readpage case, bio also equals to NULL */
 	if (bio &&
 	    /* not continuous */
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 118e7c7e4d4d..4ce5991c381f 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -15,7 +15,6 @@
 #include <linux/pagemap.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
-#include <linux/cleancache.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include "erofs_fs.h"
-- 
2.17.1
