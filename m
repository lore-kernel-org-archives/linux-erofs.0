From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:49 +0800
Subject: [PATCH 12/22] staging: erofs: refine erofs_allocpage()
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-13-gaoxiang25@huawei.com>

remove duplicated code in decompressor by introducing
failable erofs_allocpage().

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/decompressor.c | 12 +++---------
 drivers/staging/erofs/internal.h     |  2 +-
 drivers/staging/erofs/utils.c        |  5 +++--
 drivers/staging/erofs/zdata.c        |  2 +-
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/erofs/decompressor.c b/drivers/staging/erofs/decompressor.c
index ee5762351f80..744c43a456e9 100644
--- a/drivers/staging/erofs/decompressor.c
+++ b/drivers/staging/erofs/decompressor.c
@@ -74,15 +74,9 @@ static int lz4_prepare_destpages(struct z_erofs_decompress_req *rq,
 			victim = availables[--top];
 			get_page(victim);
 		} else {
-			if (!list_empty(pagepool)) {
-				victim = lru_to_page(pagepool);
-				list_del(&victim->lru);
-				DBG_BUGON(page_ref_count(victim) != 1);
-			} else {
-				victim = alloc_pages(GFP_KERNEL, 0);
-				if (!victim)
-					return -ENOMEM;
-			}
+			victim = erofs_allocpage(pagepool, GFP_KERNEL, false);
+			if (unlikely(!victim))
+				return -ENOMEM;
 			victim->mapping = Z_EROFS_MAPPING_STAGING;
 		}
 		rq->out[i] = victim;
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index b206a85776b4..e35c7d8f75d2 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -517,7 +517,7 @@ int erofs_namei(struct inode *dir, struct qstr *name,
 extern const struct file_operations erofs_dir_fops;
 
 /* utils.c / zdata.c */
-struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
+struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp, bool nofail);
 
 #if (EROFS_PCPUBUF_NR_PAGES > 0)
 void *erofs_get_pcpubuf(unsigned int pagenr);
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 0e86e44d60d0..260ea2970b4b 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -9,15 +9,16 @@
 #include "internal.h"
 #include <linux/pagevec.h>
 
-struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
+struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp, bool nofail)
 {
 	struct page *page;
 
 	if (!list_empty(pool)) {
 		page = lru_to_page(pool);
+		DBG_BUGON(page_ref_count(page) != 1);
 		list_del(&page->lru);
 	} else {
-		page = alloc_pages(gfp | __GFP_NOFAIL, 0);
+		page = alloc_pages(gfp | (nofail ? __GFP_NOFAIL : 0), 0);
 	}
 	return page;
 }
diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index bc478eebf509..02560b940558 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -634,7 +634,7 @@ z_erofs_vle_work_iter_end(struct z_erofs_vle_work_builder *builder)
 static inline struct page *__stagingpage_alloc(struct list_head *pagepool,
 					       gfp_t gfp)
 {
-	struct page *page = erofs_allocpage(pagepool, gfp);
+	struct page *page = erofs_allocpage(pagepool, gfp, true);
 
 	if (unlikely(!page))
 		return NULL;
-- 
2.17.1
