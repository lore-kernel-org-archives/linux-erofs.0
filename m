From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sun, 2 Dec 2018 02:32:09 +0800
Subject: [PATCH chao/erofs-dev 5/7] staging: erofs: refine compressed pages
 preloading flow
In-Reply-To: <20181201183211.27406-1-gaoxiang25@huawei.com>
References: <20181201183211.27406-1-gaoxiang25@huawei.com>
Message-ID: <20181201183211.27406-5-gaoxiang25@huawei.com>

Currently, there are two kinds of compressed pages in erofs:
  1) file pages for the in-place decompression and
  2) managed pages for cached decompression.
Both are all stored in grp->compressed_page[].

For managed pages, they could already exist or could be preloaded
in this round, including the following cases in detail:
  1) Already valid (loaded in some previous round);
  2) PAGE_UNALLOCATED, should be allocated at the time of submission;
  3) Just found in the managed cache, and with an extra page ref.
Currently, 1) and 3) can be distinguishable by lock_page and
checking its PG_private, which is guaranteed by the reclaim path,
but it's better to make a double check by using an extra tag.

This patch reworks the preloading flow by introducing such a tag
by using tagged pointer, too many #ifdefs are removed as well.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 161 ++++++++++++++++++++++++++++----------
 drivers/staging/erofs/unzip_vle.h |   6 ++
 2 files changed, 124 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index afa189c71b9d..45ba85faf610 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -21,6 +21,13 @@
  */
 #define PAGE_UNALLOCATED     ((void *)0x5F0E4B1D)
 
+/* how to allocate cached pages for a workgroup */
+enum z_erofs_cache_alloctype {
+	DONTALLOC,	/* don't allocate any cached pages */
+	DELAYEDALLOC,	/* delayed allocation (at the time of submitting io) */
+};
+
+
 static struct workqueue_struct *z_erofs_workqueue __read_mostly;
 static struct kmem_cache *z_erofs_workgroup_cachep __read_mostly;
 
@@ -131,38 +138,61 @@ struct z_erofs_vle_work_builder {
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
 
-	/* TODO: optimize by introducing find_get_pages_range */
-	for (i = 0; i < clusterblks; ++i) {
-		struct page *page, *found;
+	if (bl->role < Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED)
+		return;
+
+	gfp = mapping_gfp_constraint(mc, gfp) & ~__GFP_RECLAIM;
+
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
-				continue;
-			page = PAGE_UNALLOCATED;
+		page = find_get_page(mc, index + i);
+
+		if (page) {
+			t = z_erofs_ctptr_tag_justfound(page);
+		} else if (type == DELAYEDALLOC) {
+			t = tagptr_init(z_erofs_ctptr_t, PAGE_UNALLOCATED);
+		} else {	/* DONTALLOC */
+			if (standalone)
+				j = i;
+			standalone = false;
+			continue;
 		}
 
-		if (!cmpxchg(compressed_pages + i, NULL, page))
+		if (!cmpxchg_relaxed(&pages[i], NULL, tagptr_cast_ptr(t)))
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
@@ -234,6 +264,17 @@ int erofs_try_to_free_cached_page(struct address_space *mapping,
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
@@ -608,6 +649,26 @@ struct z_erofs_vle_frontend {
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
@@ -622,12 +683,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
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
@@ -667,20 +723,16 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
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
+	/* preload all compressed pages (maybe downgrade role if necessary) */
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
@@ -1062,6 +1114,9 @@ pickup_page_for_submission(struct z_erofs_vle_workgroup *grp,
 	struct address_space *mapping;
 	struct page *oldpage, *page;
 
+	z_erofs_ctptr_t t;
+	int justfound;
+
 repeat:
 	page = READ_ONCE(grp->compressed_pages[nr]);
 	oldpage = page;
@@ -1078,6 +1133,11 @@ pickup_page_for_submission(struct z_erofs_vle_workgroup *grp,
 		goto out_allocpage;
 	}
 
+	/* process the target tagged pointer */
+	t = tagptr_init(z_erofs_ctptr_t, page);
+	justfound = tagptr_unfold_tags(t);
+	page = tagptr_unfold_ptr(t);
+
 	mapping = READ_ONCE(page->mapping);
 
 	/*
@@ -1085,7 +1145,10 @@ pickup_page_for_submission(struct z_erofs_vle_workgroup *grp,
 	 * get such a cached-like page.
 	 */
 	if (nocache) {
-		/* should be locked, not uptodate, and not truncated */
+		/* if managed cache is disabled, it is impossible `justfound' */
+		DBG_BUGON(justfound);
+
+		/* and it should be locked, not uptodate, and not truncated */
 		DBG_BUGON(!PageLocked(page));
 		DBG_BUGON(PageUptodate(page));
 		DBG_BUGON(!mapping);
@@ -1102,11 +1165,22 @@ pickup_page_for_submission(struct z_erofs_vle_workgroup *grp,
 
 	lock_page(page);
 
+	/* only true if page reclaim goes wrong, should never happen */
+	DBG_BUGON(justfound && PagePrivate(page));
+
 	/* the page is still in manage cache */
 	if (page->mapping == mc) {
 		WRITE_ONCE(grp->compressed_pages[nr], page);
 
 		if (!PagePrivate(page)) {
+			/*
+			 * impossible to be !PagePrivate(page) for
+			 * the current restriction as well if
+			 * the page is already in compressed_pages[].
+			 */
+			DBG_BUGON(!justfound);
+
+			justfound = 0;
 			set_page_private(page, (unsigned long)grp);
 			SetPagePrivate(page);
 		}
@@ -1124,6 +1198,7 @@ pickup_page_for_submission(struct z_erofs_vle_workgroup *grp,
 	 * reuse this one, let's allocate a new cache-managed page.
 	 */
 	DBG_BUGON(page->mapping);
+	DBG_BUGON(!justfound);
 
 	tocache = true;
 	unlock_page(page);
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 3316bc36965d..c25421cbb69f 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -69,6 +69,12 @@ struct z_erofs_vle_work {
 
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
