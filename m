From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sun, 2 Dec 2018 02:32:07 +0800
Subject: [PATCH chao/erofs-dev 3/7] staging: erofs: localize
 UNALLOCATED_CACHED_PAGE placeholder
In-Reply-To: <20181201183211.27406-1-gaoxiang25@huawei.com>
References: <20181201183211.27406-1-gaoxiang25@huawei.com>
Message-ID: <20181201183211.27406-3-gaoxiang25@huawei.com>

In practice, in order to avoid in-place decompression for cached
decompression and reuse pages from page_pool instead of allocation
as much as possible, an unallocated placeholder was introduce to
mark all in compressed_pages[] and they will be replaced at the time
of submission.

Previously EROFS_UNALLOCATED_CACHED_PAGE was included in internal.h,
which is unnecessary since it's only internally used in decompression
subsystem, move it to unzip_vle.c and rename it to PAGE_UNALLOCATED.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h  |  2 --
 drivers/staging/erofs/unzip_vle.c | 10 ++++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index b78d6e4c12ab..e049d00c087a 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -289,8 +289,6 @@ static inline void erofs_workstation_cleanup_all(struct super_block *sb)
 }
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-#define EROFS_UNALLOCATED_CACHED_PAGE	((void *)0x5F0EF00D)
-
 extern int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 	struct erofs_workgroup *egrp);
 extern int erofs_try_to_free_cached_page(struct address_space *mapping,
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 966b28b0b2f1..52961ef6682b 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -15,6 +15,12 @@
 
 #include <trace/events/erofs.h>
 
+/*
+ * a compressed_pages[] placeholder in order to avoid
+ * being filled with file pages for in-place decompression.
+ */
+#define PAGE_UNALLOCATED     ((void *)0x5F0E4B1D)
+
 static struct workqueue_struct *z_erofs_workqueue __read_mostly;
 static struct kmem_cache *z_erofs_workgroup_cachep __read_mostly;
 
@@ -147,7 +153,7 @@ static bool grab_managed_cache_pages(struct address_space *mapping,
 			noio = false;
 			if (!reserve_allocation)
 				continue;
-			page = EROFS_UNALLOCATED_CACHED_PAGE;
+			page = PAGE_UNALLOCATED;
 		}
 
 		if (!cmpxchg(compressed_pages + i, NULL, page))
@@ -1180,7 +1186,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 		cachemngd = false;
 
-		if (page == EROFS_UNALLOCATED_CACHED_PAGE) {
+		if (page == PAGE_UNALLOCATED) {
 			cachemngd = true;
 			goto do_allocpage;
 		} else if (page) {
-- 
2.14.4
