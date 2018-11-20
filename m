From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 22:14:46 +0800
Subject: [PATCH v3 chao/erofs-dev 12/14] staging: erofs: fix compressed pages
 submission flow
In-Reply-To: <20181120141448.29483-1-gaoxiang25@huawei.com>
References: <20181120141448.29483-1-gaoxiang25@huawei.com>
Message-ID: <20181120141448.29483-12-gaoxiang25@huawei.com>

This patch fully closes race between page reclaiming and
compressed pages submitting, which could cause very low
probability of reference leak and double free.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 344 +++++++++++++++++++++++++-------------
 drivers/staging/erofs/unzip_vle.h |  15 ++
 2 files changed, 247 insertions(+), 112 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index fbdf9483b860..aed426230860 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -15,6 +15,15 @@
 
 #include <trace/events/erofs.h>
 
+/* how to allocate cached pages for a workgroup */
+enum z_erofs_cache_alloctype {
+	DONTALLOC,	/* don't allocate any cached pages */
+	TRYALLOC,	/* minimal effort (w/o page reclaiming) */
+	DELAYEDALLOC,	/* delayed allocation (at the time of submitting io) */
+};
+
+#define PAGE_UNALLOCATED	((void *)0x5F0EF00D)
+
 static struct workqueue_struct *z_erofs_workqueue __read_mostly;
 static struct kmem_cache *z_erofs_workgroup_cachep __read_mostly;
 
@@ -125,38 +134,68 @@ struct z_erofs_vle_work_builder {
 	{ .work = NULL, .role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED }
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-
-static bool grab_managed_cache_pages(struct address_space *mapping,
-				     erofs_blk_t start,
-				     struct page **compressed_pages,
-				     int clusterblks,
-				     bool reserve_allocation)
+static void preload_compressed_pages(struct z_erofs_vle_work_builder *bl,
+				     struct address_space *mc,
+				     pgoff_t index,
+				     unsigned int clusterpages,
+				     enum z_erofs_cache_alloctype type,
+				     struct list_head *pagepool,
+				     gfp_t gfp)
 {
-	bool noio = true;
-	unsigned int i;
+	struct page **const pages = bl->compressed_pages;
+	const unsigned int remaining = bl->compressed_deficit;
+	bool standalone = true;
+	unsigned int i, j = 0;
+
+	if (bl->role < Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED)
+		return;
+
+	gfp = mapping_gfp_constraint(mc, gfp) & ~__GFP_RECLAIM;
 
-	/* TODO: optimize by introducing find_get_pages_range */
-	for (i = 0; i < clusterblks; ++i) {
-		struct page *page, *found;
+	index += clusterpages - remaining;
 
-		if (READ_ONCE(compressed_pages[i]))
+	for (i = 0; i < remaining; ++i) {
+		struct page *page, *newpage = NULL;
+		z_erofs_ctptr_t t;
+
+		/* the compressed page was loaded before */
+		if (READ_ONCE(pages[i]))
 			continue;
 
-		page = found = find_get_page(mapping, start + i);
-		if (!found) {
-			noio = false;
-			if (!reserve_allocation)
+		page = find_get_page(mc, index + i);
+
+		if (page) {
+			t = z_erofs_ctptr_tag_justfound(page);
+		} else if (type == DELAYEDALLOC) {
+			t = tagptr_init(z_erofs_ctptr_t, PAGE_UNALLOCATED);
+		} else if (type == TRYALLOC) {
+			newpage = erofs_allocpage(pagepool, gfp);
+
+			if (!newpage)
 				continue;
-			page = EROFS_UNALLOCATED_CACHED_PAGE;
+			newpage->mapping = Z_EROFS_MAPPING_PREALLOCATED;
+			t = z_erofs_ctptr_tag_justfound(newpage);
+		} else {			/* DONTALLOC */
+			if (standalone)
+				j = i;
+			standalone = false;
+			continue;
 		}
 
-		if (!cmpxchg(compressed_pages + i, NULL, page))
+		if (!cmpxchg(&pages[i], NULL, tagptr_cast_ptr(t)))
 			continue;
 
-		if (found)
-			put_page(found);
+		if (page)
+			put_page(page);
+		else if (newpage)
+			/* someone just allocated this page, drop our attempt */
+			list_add(&page->lru, pagepool);
 	}
-	return noio;
+	bl->compressed_pages += j;
+	bl->compressed_deficit = remaining - j;
+
+	if (standalone)
+		bl->role = Z_EROFS_VLE_WORK_PRIMARY;
 }
 
 /* called by erofs_shrinker to get rid of all compressed_pages */
@@ -228,6 +267,17 @@ int erofs_try_to_free_cached_page(struct address_space *mapping,
 	}
 	return ret;
 }
+#else
+static void preload_compressed_pages(struct z_erofs_vle_work_builder *bl,
+				     struct address_space *mc,
+				     pgoff_t index,
+				     unsigned int clusterpages,
+				     enum z_erofs_cache_alloctype type,
+				     struct list_head *pagepool,
+				     gfp_t gfp)
+{
+	/* nowhere to load compressed pages from */
+}
 #endif
 
 /* page_type must be Z_EROFS_PAGE_TYPE_EXCLUSIVE */
@@ -601,6 +651,26 @@ struct z_erofs_vle_frontend {
 	.owned_head = Z_EROFS_VLE_WORKGRP_TAIL, \
 	.backmost = true, }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+static inline bool
+should_alloc_managed_pages(struct z_erofs_vle_frontend *fe, erofs_off_t la)
+{
+	if (fe->backmost)
+		return true;
+
+	if (EROFS_FS_ZIP_CACHE_LVL >= 2)
+		return la < fe->headoffset;
+
+	return false;
+}
+#else
+static inline bool
+should_alloc_managed_pages(struct z_erofs_vle_frontend *fe, erofs_off_t la)
+{
+	return false;
+}
+#endif
+
 static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 				struct page *page,
 				struct list_head *page_pool)
@@ -615,12 +685,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	bool tight = builder_is_followed(builder);
 	struct z_erofs_vle_work *work = builder->work;
 
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mc = MNGD_MAPPING(sbi);
-	struct z_erofs_vle_workgroup *grp;
-	bool noio_outoforder;
-#endif
-
+	enum z_erofs_cache_alloctype cache_strategy;
 	enum z_erofs_page_type page_type;
 	unsigned int cur, end, spiltted, index;
 	int err = 0;
@@ -660,20 +725,16 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	if (unlikely(err))
 		goto err_out;
 
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-	grp = fe->builder.grp;
-
-	/* let's do out-of-order decompression for noio */
-	noio_outoforder = grab_managed_cache_pages(mc,
-		erofs_blknr(map->m_pa),
-		grp->compressed_pages, erofs_blknr(map->m_plen),
-		/* compressed page caching selection strategy */
-		fe->backmost | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
-				map->m_la < fe->headoffset : 0));
-
-	if (noio_outoforder && builder_is_followed(builder))
-		builder->role = Z_EROFS_VLE_WORK_PRIMARY;
-#endif
+	/* preload all compressed pages and downgrade role if necessary */
+	if (should_alloc_managed_pages(fe, map->m_la))
+		cache_strategy = DELAYEDALLOC;
+	else
+		cache_strategy = DONTALLOC;
+
+	preload_compressed_pages(builder, MNGD_MAPPING(sbi),
+				 map->m_pa / PAGE_SIZE,
+				 map->m_plen / PAGE_SIZE,
+				 cache_strategy, page_pool, GFP_KERNEL);
 
 	tight &= builder_is_followed(builder);
 	work = builder->work;
@@ -1035,6 +1096,124 @@ static void z_erofs_vle_unzip_wq(struct work_struct *work)
 	kvfree(iosb);
 }
 
+static struct page *
+pickup_page_for_submission(struct z_erofs_vle_workgroup *grp,
+			   unsigned int nr,
+			   struct list_head *pagepool,
+			   struct address_space *mc,
+			   gfp_t gfp)
+{
+	/* determined at compile time to avoid using macros. */
+	const bool nocache = __builtin_constant_p(mc) ? !mc : false;
+	const pgoff_t index = grp->obj.index;
+	bool tocache = false;
+
+	struct address_space *mapping;
+	struct page *oldpage, *page;
+
+	z_erofs_ctptr_t t;
+	int justfound;
+
+repeat:
+	page = READ_ONCE(grp->compressed_pages[nr]);
+	oldpage = page;
+
+	if (!page)
+		goto out_allocpage;
+
+	if (!nocache) {
+		if (page == PAGE_UNALLOCATED) {
+			tocache = true;
+			goto out_allocpage;
+		}
+
+		if (z_erofs_is_preallocatedpage(page))
+			goto out_add_to_managed_cache;
+	}
+
+	/* process the target tagged pointer */
+	t = tagptr_init(z_erofs_ctptr_t, page);
+	justfound = tagptr_unfold_tags(t);
+	page = tagptr_unfold_ptr(t);
+
+	mapping = READ_ONCE(page->mapping);
+
+	if (nocache) {
+		/* if managed cache is disabled, it is impossible `justfound' */
+		DBG_BUGON(justfound);
+
+		/* and it should be locked, not uptodate, and not truncated */
+		DBG_BUGON(!PageLocked(page));
+		DBG_BUGON(PageUptodate(page));
+		DBG_BUGON(!mapping);
+		goto out;
+	}
+
+	/*
+	 * unmanaged pages are all locked,
+	 * therefore it is impossible for `mapping' to be NULL.
+	 */
+	if (mapping && mapping != mc)
+		/* ought to be unmanaged pages */
+		goto out;
+
+	lock_page(page);
+	/* only true if page reclaim goes wrong, should never happen */
+	DBG_BUGON(justfound && PagePrivate(page));
+
+	if (page->mapping == mc) {
+		WRITE_ONCE(grp->compressed_pages[nr], page);
+
+		if (!PagePrivate(page)) {
+			/*
+			 * impossible to be !PagePrivate(page) for the current
+			 * implementation as well if the page is already in
+			 * compressed_pages[].
+			 */
+			DBG_BUGON(!justfound);
+
+			justfound = 0;
+			set_page_private(page, (unsigned long)grp);
+			SetPagePrivate(page);
+		}
+
+		/* no need to submit bio if the page is already up-to-date */
+		if (PageUptodate(page)) {
+			unlock_page(page);
+			page = NULL;
+		}
+		goto out;
+	}
+
+	/* and for the truncation case (page is still locked) */
+	DBG_BUGON(page->mapping);
+	/* truncation is only after disconnected currently */
+	DBG_BUGON(!justfound);
+
+	tocache = true;
+	unlock_page(page);
+	put_page(page);
+out_allocpage:
+	page = __stagingpage_alloc(pagepool, gfp);
+	if (oldpage != cmpxchg(&grp->compressed_pages[nr], oldpage, page)) {
+		list_add(&page->lru, pagepool);
+		cpu_relax();
+		goto repeat;
+	}
+	if (nocache || !tocache)
+		goto out;
+out_add_to_managed_cache:
+	if (add_to_page_cache_lru(page, mc, index + nr, gfp)) {
+		page->mapping = Z_EROFS_MAPPING_STAGING;
+		goto out;
+	}
+
+	set_page_private(page, (unsigned long)grp);
+	SetPagePrivate(page);
+out:	/* the only exit (for tracing and debugging) */
+	return page;
+}
+
 static inline struct z_erofs_vle_unzip_io *
 prepare_io_handler(struct super_block *sb,
 		   struct z_erofs_vle_unzip_io *io,
@@ -1070,26 +1249,6 @@ prepare_io_handler(struct super_block *sb,
 }
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-/* true - unlocked (noio), false - locked (need submit io) */
-static inline bool recover_managed_page(struct z_erofs_vle_workgroup *grp,
-					struct page *page)
-{
-	wait_on_page_locked(page);
-	if (PagePrivate(page) && PageUptodate(page))
-		return true;
-
-	lock_page(page);
-	if (unlikely(!PagePrivate(page))) {
-		set_page_private(page, (unsigned long)grp);
-		SetPagePrivate(page);
-	}
-	if (unlikely(PageUptodate(page))) {
-		unlock_page(page);
-		return true;
-	}
-	return false;
-}
-
 #define __FSIO_1 1
 #else
 #define __FSIO_1 0
@@ -1105,7 +1264,6 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	const unsigned int clusterpages = erofs_clusterpages(sbi);
 	const gfp_t gfp = GFP_NOFS;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mc = MNGD_MAPPING(sbi);
 	struct z_erofs_vle_workgroup *lstgrp_noio = NULL, *lstgrp_io = NULL;
 #endif
 	struct z_erofs_vle_unzip_io *ios[1 + __FSIO_1];
@@ -1144,13 +1302,9 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 	do {
 		struct z_erofs_vle_workgroup *grp;
-		struct page **compressed_pages, *oldpage, *page;
 		pgoff_t first_index;
-		unsigned int i = 0;
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		unsigned int noio = 0;
-		bool cachemngd;
-#endif
+		struct page *page;
+		unsigned int i = 0, nr_uptodate = 0;
 		int err;
 
 		/* no possible 'owned_head' equals the following */
@@ -1161,51 +1315,19 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 		/* close the main owned chain at first */
 		owned_head = cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_TAIL,
-			Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+				     Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
 
 		first_index = grp->obj.index;
-		compressed_pages = grp->compressed_pages;
-
 		force_submit |= (first_index != last_index + 1);
-repeat:
-		/* fulfill all compressed pages */
-		oldpage = page = READ_ONCE(compressed_pages[i]);
-
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		cachemngd = false;
-
-		if (page == EROFS_UNALLOCATED_CACHED_PAGE) {
-			cachemngd = true;
-			goto do_allocpage;
-		} else if (page) {
-			if (page->mapping != mc)
-				BUG_ON(PageUptodate(page));
-			else if (recover_managed_page(grp, page)) {
-				/* page is uptodate, skip io submission */
-				force_submit = true;
-				++noio;
-				goto skippage;
-			}
-		} else {
-do_allocpage:
-#else
-		if (page)
-			BUG_ON(PageUptodate(page));
-		else {
-#endif
-			page = __stagingpage_alloc(pagepool, gfp);
 
-			if (oldpage != cmpxchg(compressed_pages + i,
-				oldpage, page)) {
-				list_add(&page->lru, pagepool);
-				goto repeat;
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-			} else if (cachemngd && !add_to_page_cache_lru(page,
-				   mc, first_index + i, gfp)) {
-				set_page_private(page, (unsigned long)grp);
-				SetPagePrivate(page);
-#endif
-			}
+		/* fulfill all compressed pages */
+repeat:
+		page = pickup_page_for_submission(grp, i, pagepool,
+						  MNGD_MAPPING(sbi), gfp);
+		if (!page) {
+			force_submit = true;
+			++nr_uptodate;
+			goto skippage;
 		}
 
 		if (bio && force_submit) {
@@ -1228,14 +1350,12 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 		force_submit = false;
 		last_index = first_index + i;
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
 skippage:
-#endif
 		if (++i < clusterpages)
 			goto repeat;
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (noio < clusterpages) {
+		if (nr_uptodate < clusterpages) {
 			lstgrp_io = grp;
 		} else {
 			z_erofs_vle_owned_workgrp_t iogrp_next =
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 3316bc36965d..6f4c7440aeb1 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -36,6 +36,15 @@ static inline bool z_erofs_gather_if_stagingpage(struct list_head *page_pool,
 	return false;
 }
 
+/*
+ *  - 0x6A110C8D ('pallocated', Z_EROFS_MAPPING_PREALLOCATED) -
+ * preallocated cached pages, will be added into managed cache later
+ */
+#define Z_EROFS_MAPPING_PREALLOCATED	((void *)0x6A110C8D)
+
+#define z_erofs_is_preallocatedpage(page)	\
+	((page)->mapping == Z_EROFS_MAPPING_PREALLOCATED)
+
 /*
  * Structure fields follow one of the following exclusion rules.
  *
@@ -69,6 +78,12 @@ struct z_erofs_vle_work {
 
 typedef struct z_erofs_vle_workgroup *z_erofs_vle_owned_workgrp_t;
 
+/* compressed page tagptr (bit 0 - justfound, with an extra reference) */
+typedef tagptr1_t z_erofs_ctptr_t;
+
+#define z_erofs_ctptr_tag_justfound(page) \
+	tagptr_fold(z_erofs_ctptr_t, page, 1)
+
 struct z_erofs_vle_workgroup {
 	struct erofs_workgroup obj;
 	struct z_erofs_vle_work work;
-- 
2.14.4
