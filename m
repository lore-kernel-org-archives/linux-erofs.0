From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 21 Aug 2018 14:50:58 +0800
Subject: [PREVIEW] [PATCH 3/3] staging: erofs: drop multiref support
 temporarily
In-Reply-To: <1534834258-36401-1-git-send-email-gaoxiang25@huawei.com>
References: <1534834258-36401-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1534834258-36401-3-git-send-email-gaoxiang25@huawei.com>

Multiref support means that a compressed page could have
more than one reference, which is designed for on-disk data
deduplication. However, mkfs doesn't support this mode
at this moment, and the kernel implementation is also broken.

Let's drop multiref support. If it is fully implemented
in the future, it can be reverted later.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 36 +++++-------------------------------
 drivers/staging/erofs/unzip_vle.h | 12 +-----------
 2 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 016c82d..6c5739a 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -301,12 +301,9 @@ struct z_erofs_vle_work_finder {
 	grp = container_of(egrp, struct z_erofs_vle_workgroup, obj);
 	*f->grp_ret = grp;
 
-#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
 	work = z_erofs_vle_grab_work(grp, f->pageofs);
+	/* if multiref is disabled, `primary' is always true */
 	primary = true;
-#else
-	BUG();
-#endif
 
 	DBG_BUGON(work->pageofs != f->pageofs);
 
@@ -368,12 +365,9 @@ struct z_erofs_vle_work_finder {
 	struct z_erofs_vle_workgroup *grp = *f->grp_ret;
 	struct z_erofs_vle_work *work;
 
-#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	/* if multiref is disabled, grp should never be nullptr */
 	BUG_ON(grp != NULL);
-#else
-	if (grp != NULL)
-		goto skip;
-#endif
+
 	/* no available workgroup, let's allocate one */
 	grp = kmem_cache_zalloc(z_erofs_workgroup_cachep, GFP_NOFS);
 	if (unlikely(grp == NULL))
@@ -396,13 +390,7 @@ struct z_erofs_vle_work_finder {
 	*f->hosted = true;
 
 	gnew = true;
-#ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
-skip:
-	/* currently unimplemented */
-	BUG();
-#else
 	work = z_erofs_vle_grab_primary_work(grp);
-#endif
 	work->pageofs = f->pageofs;
 
 	mutex_init(&work->lock);
@@ -797,9 +785,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 
 	struct z_erofs_pagevec_ctor ctor;
 	unsigned nr_pages;
-#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
 	unsigned sparsemem_pages = 0;
-#endif
 	struct page *pages_onstack[Z_EROFS_VLE_VMAP_ONSTACK_PAGES];
 	struct page **pages, **compressed_pages, *page;
 	unsigned i, llen;
@@ -811,11 +797,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	int err;
 
 	might_sleep();
-#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
 	work = z_erofs_vle_grab_primary_work(grp);
-#else
-	BUG();
-#endif
 	BUG_ON(!READ_ONCE(work->nr_pages));
 
 	mutex_lock(&work->lock);
@@ -866,13 +848,11 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 			pagenr = z_erofs_onlinepage_index(page);
 
 		BUG_ON(pagenr >= nr_pages);
-
-#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
 		BUG_ON(pages[pagenr] != NULL);
-		++sparsemem_pages;
-#endif
+
 		pages[pagenr] = page;
 	}
+	sparsemem_pages = i;
 
 	z_erofs_pagevec_ctor_exit(&ctor, true);
 
@@ -902,10 +882,8 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		pagenr = z_erofs_onlinepage_index(page);
 
 		BUG_ON(pagenr >= nr_pages);
-#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
 		BUG_ON(pages[pagenr] != NULL);
 		++sparsemem_pages;
-#endif
 		pages[pagenr] = page;
 
 		overlapped = true;
@@ -931,12 +909,10 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	if (err != -ENOTSUPP)
 		goto out_percpu;
 
-#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
 	if (sparsemem_pages >= nr_pages) {
 		BUG_ON(sparsemem_pages > nr_pages);
 		goto skip_allocpage;
 	}
-#endif
 
 	for (i = 0; i < nr_pages; ++i) {
 		if (pages[i] != NULL)
@@ -945,9 +921,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		pages[i] = __stagingpage_alloc(page_pool, GFP_NOFS);
 	}
 
-#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
 skip_allocpage:
-#endif
 	vout = erofs_vmap(pages, nr_pages);
 
 	err = z_erofs_vle_unzip_vmap(compressed_pages,
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 3939985..3316bc3 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -47,13 +47,6 @@ static inline bool z_erofs_gather_if_stagingpage(struct list_head *page_pool,
 #define Z_EROFS_VLE_INLINE_PAGEVECS     3
 
 struct z_erofs_vle_work {
-	/* struct z_erofs_vle_work *left, *right; */
-
-#ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
-	struct list_head list;
-
-	atomic_t refcount;
-#endif
 	struct mutex lock;
 
 	/* I: decompression offset in page */
@@ -107,10 +100,8 @@ static inline void z_erofs_vle_set_workgrp_fmt(
 	grp->flags = fmt | (grp->flags & ~Z_EROFS_VLE_WORKGRP_FMT_MASK);
 }
 
-#ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
-#error multiref decompression is unimplemented yet
-#else
 
+/* definitions if multiref is disabled */
 #define z_erofs_vle_grab_primary_work(grp)	(&(grp)->work)
 #define z_erofs_vle_grab_work(grp, pageofs)	(&(grp)->work)
 #define z_erofs_vle_work_workgroup(wrk, primary)	\
@@ -118,7 +109,6 @@ static inline void z_erofs_vle_set_workgrp_fmt(
 		struct z_erofs_vle_workgroup, work) : \
 		({ BUG(); (void *)NULL; }))
 
-#endif
 
 #define Z_EROFS_WORKGROUP_SIZE       sizeof(struct z_erofs_vle_workgroup)
 
-- 
1.9.1
