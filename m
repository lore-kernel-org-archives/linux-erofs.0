From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 23:57:45 +0800
Subject: [PATCH v2 15/22] staging: erofs: tidy up zpvec.h
In-Reply-To: <20190731155752.210602-1-gaoxiang25@huawei.com>
References: <20190731155752.210602-1-gaoxiang25@huawei.com>
Message-ID: <20190731155752.210602-16-gaoxiang25@huawei.com>

- use shorter function names:
  z_erofs_pagevec_enqueue and z_erofs_pagevec_dequeue;
- minor code cleanup.

In order to keep in line with erofs-outofstaging patchset.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/zdata.c |  6 +++---
 drivers/staging/erofs/zpvec.h | 25 +++++++++----------------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 3078510e350d..88c8c4082498 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -314,8 +314,8 @@ static int z_erofs_vle_work_add_page(
 	    try_to_reuse_as_compressed_page(builder, page))
 		return 0;
 
-	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector,
-					   page, type, &occupied);
+	ret = z_erofs_pagevec_enqueue(&builder->vector,
+				      page, type, &occupied);
 	builder->work->vcnt += (unsigned int)ret;
 
 	return ret ? 0 : -EAGAIN;
@@ -938,7 +938,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	for (i = 0; i < work->vcnt; ++i) {
 		unsigned int pagenr;
 
-		page = z_erofs_pagevec_ctor_dequeue(&ctor, &page_type);
+		page = z_erofs_pagevec_dequeue(&ctor, &page_type);
 
 		/* all pages in pagevec ought to be valid */
 		DBG_BUGON(!page);
diff --git a/drivers/staging/erofs/zpvec.h b/drivers/staging/erofs/zpvec.h
index 77bf6877bad8..9798f5627786 100644
--- a/drivers/staging/erofs/zpvec.h
+++ b/drivers/staging/erofs/zpvec.h
@@ -11,7 +11,7 @@
 
 #include "tagptr.h"
 
-/* page type in pagevec for unzip subsystem */
+/* page type in pagevec for decompress subsystem */
 enum z_erofs_page_type {
 	/* including Z_EROFS_VLE_PAGE_TAIL_EXCLUSIVE */
 	Z_EROFS_PAGE_TYPE_EXCLUSIVE,
@@ -103,16 +103,14 @@ static inline void z_erofs_pagevec_ctor_init(struct z_erofs_pagevec_ctor *ctor,
 			z_erofs_pagevec_ctor_pagedown(ctor, false);
 		}
 	}
-
 	ctor->next = z_erofs_pagevec_ctor_next_page(ctor, i);
 	ctor->index = i;
 }
 
-static inline bool
-z_erofs_pagevec_ctor_enqueue(struct z_erofs_pagevec_ctor *ctor,
-			     struct page *page,
-			     enum z_erofs_page_type type,
-			     bool *occupied)
+static inline bool z_erofs_pagevec_enqueue(struct z_erofs_pagevec_ctor *ctor,
+					   struct page *page,
+					   enum z_erofs_page_type type,
+					   bool *occupied)
 {
 	*occupied = false;
 	if (unlikely(!ctor->next && type))
@@ -131,15 +129,13 @@ z_erofs_pagevec_ctor_enqueue(struct z_erofs_pagevec_ctor *ctor,
 		ctor->next = page;
 		*occupied = true;
 	}
-
-	ctor->pages[ctor->index++] =
-		tagptr_fold(erofs_vtptr_t, page, type);
+	ctor->pages[ctor->index++] = tagptr_fold(erofs_vtptr_t, page, type);
 	return true;
 }
 
 static inline struct page *
-z_erofs_pagevec_ctor_dequeue(struct z_erofs_pagevec_ctor *ctor,
-			     enum z_erofs_page_type *type)
+z_erofs_pagevec_dequeue(struct z_erofs_pagevec_ctor *ctor,
+			enum z_erofs_page_type *type)
 {
 	erofs_vtptr_t t;
 
@@ -156,11 +152,8 @@ z_erofs_pagevec_ctor_dequeue(struct z_erofs_pagevec_ctor *ctor,
 	if (*type == (uintptr_t)ctor->next)
 		ctor->next = tagptr_unfold_ptr(t);
 
-	ctor->pages[ctor->index++] =
-		tagptr_fold(erofs_vtptr_t, NULL, 0);
-
+	ctor->pages[ctor->index++] = tagptr_fold(erofs_vtptr_t, NULL, 0);
 	return tagptr_unfold_ptr(t);
 }
-
 #endif
 
-- 
2.17.1
