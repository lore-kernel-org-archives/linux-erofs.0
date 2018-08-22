From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 22 Aug 2018 19:09:24 +0800
Subject: [WIP] [PREVIEW] [RFC PATCH 3/3] staging: erofs: fix submitting
 compressed pages flow
In-Reply-To: <1534936164-112151-1-git-send-email-gaoxiang25@huawei.com>
References: <1534936164-112151-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1534936164-112151-3-git-send-email-gaoxiang25@huawei.com>

This patch fully closes race between page reclaiming and
compressed pages submitting, which could cause very low
probability of reference leak and double free.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 235 +++++++++++++++++++++++---------------
 drivers/staging/erofs/unzip_vle.h |   3 +
 2 files changed, 144 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index a8b86717..0ecea45 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -98,38 +98,55 @@ struct z_erofs_vle_work_builder {
 	{ .work = NULL, .role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED }
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-
-static bool grab_managed_cache_pages(struct address_space *mapping,
-				     erofs_blk_t start,
-				     struct page **compressed_pages,
-				     int clusterblks,
-				     bool reserve_allocation)
+static void z_erofs_vle_scan_cachepages(struct z_erofs_vle_work_builder *bl,
+					struct address_space *mapping,
+					pgoff_t index,
+					unsigned int clusterpages,
+					bool reserve_allocation)
 {
-	bool noio = true;
-	unsigned int i;
+	struct page **const compressed_pages = bl->compressed_pages;
+	const unsigned int compressed_deficit = bl->compressed_deficit;
+	bool standalone = true;
+	unsigned int i, j = 0;
+
+	if (bl->role < Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED)
+		return;
+
+	index += clusterpages - compressed_deficit;
 
 	/* TODO: optimize by introducing find_get_pages_range */
-	for (i = 0; i < clusterblks; ++i) {
-		struct page *page, *found;
+	for (i = 0; i < compressed_deficit; ++i) {
+		struct page *page;
+		z_erofs_ctptr_t v;
 
 		if (READ_ONCE(compressed_pages[i]) != NULL)
 			continue;
 
-		page = found = find_get_page(mapping, start + i);
-		if (found == NULL) {
-			noio = false;
-			if (!reserve_allocation)
-				continue;
-			page = EROFS_UNALLOCATED_CACHED_PAGE;
+		page = find_get_page(mapping, index + i);
+		if (page != NULL)
+			v = tagptr_fold(z_erofs_ctptr_t, page, 1);
+		else if (reserve_allocation)
+			v = tagptr_init(z_erofs_ctptr_t,
+					EROFS_UNALLOCATED_CACHED_PAGE);
+		else {
+			if (standalone)
+				j = i;
+			standalone = false;
+			continue;
 		}
 
-		if (NULL == cmpxchg(compressed_pages + i, NULL, page))
+		if (cmpxchg(&compressed_pages[i],
+			    NULL, tagptr_cast_ptr(v)) == NULL)
 			continue;
 
-		if (found != NULL)
-			put_page(found);
+		if (page != NULL)
+			put_page(page);
 	}
-	return noio;
+
+	bl->compressed_pages += j;
+	bl->compressed_deficit = compressed_deficit - j;
+	if (standalone)
+		bl->role = Z_EROFS_VLE_WORK_PRIMARY;
 }
 
 /* called by erofs_shrinker to get rid of all compressed_pages */
@@ -590,12 +607,6 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	bool tight = builder_is_followed(builder);
 	struct z_erofs_vle_work *work = builder->work;
 
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mngda = MNGD_MAPPING(sbi);
-	struct z_erofs_vle_workgroup *grp;
-	bool noio_outoforder;
-#endif
-
 	enum z_erofs_page_type page_type;
 	unsigned cur, end, spiltted, index;
 	int err = 0;
@@ -638,18 +649,12 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 		goto err_out;
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	grp = fe->builder.grp;
-
-	/* let's do out-of-order decompression for noio */
-	noio_outoforder = grab_managed_cache_pages(mngda,
+	z_erofs_vle_scan_cachepages(builder, MNGD_MAPPING(sbi),
 		erofs_blknr(map->m_pa),
-		grp->compressed_pages, erofs_blknr(map->m_plen),
+		erofs_blknr(map->m_plen),
 		/* compressed page caching selection strategy */
 		fe->initial | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
-			map->m_la < fe->cachedzone_la : 0));
-
-	if (noio_outoforder && builder_is_followed(builder))
-		builder->role = Z_EROFS_VLE_WORK_PRIMARY;
+			       map->m_la < fe->cachedzone_la : 0));
 #endif
 
 	tight &= builder_is_followed(builder);
@@ -1048,27 +1053,105 @@ static void z_erofs_vle_unzip_wq(struct work_struct *work)
 	return io;
 }
 
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-/* true - unlocked (noio), false - locked (need submit io) */
-static inline bool recover_managed_page(struct z_erofs_vle_workgroup *grp,
-					struct page *page)
+static struct page *
+z_erofs_workgrp_grab_page_for_submission(struct z_erofs_vle_workgroup *grp,
+					 pgoff_t first_index,
+					 unsigned int nr,
+					 struct list_head *pagepool,
+					 gfp_t gfp,
+					 struct address_space *mc)
 {
-	wait_on_page_locked(page);
-	if (PagePrivate(page) && PageUptodate(page))
-		return true;
+	struct address_space *mapping;
+	struct page *oldpage, *page;
+	bool tocache = false;
+	z_erofs_ctptr_t t;
+	int justfound;
+
+repeat:
+	oldpage = page = READ_ONCE(grp->compressed_pages[nr]);
+
+	if (page == NULL)
+		goto out_allocpage;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	if (page == EROFS_UNALLOCATED_CACHED_PAGE) {
+		tocache = true;
+		goto out_allocpage;
+	}
+#endif
+
+	/* parse the compressed tagged pointer */
+	t = tagptr_init(z_erofs_ctptr_t, page);
+	justfound = tagptr_unfold_tags(t);
+	page = tagptr_unfold_ptr(t);
+
+	mapping = READ_ONCE(page->mapping);
+
+#ifndef EROFS_FS_HAS_MANAGED_CACHE
+	/* if managed cache is disabled, it is impossible `justfound' */
+	DBG_BUGON(justfound);
+
+	/* and it should be locked, not uptodate, and not truncated */
+	DBG_BUGON(!PageLocked(page));
+	DBG_BUGON(PageUptodate(page));
+	DBG_BUGON(mapping == NULL);
+
+	goto out;
+#else
+	/* all unmanaged pages are locked, so it's impossible to be NULL */
+	if (mapping != NULL && mapping != mc)
+		/* ought to be unmanaged pages */
+		goto out;
 
 	lock_page(page);
-	if (unlikely(!PagePrivate(page))) {
+	/* page reclaim went wrong, should never happen */
+	DBG_BUGON(justfound && PagePrivate(page));
+
+	if (page->mapping == mc) {
+		WRITE_ONCE(grp->compressed_pages[nr], page);
+
+		if (!PagePrivate(page)) {
+			if (!justfound)
+				get_page(page);
+			justfound = 0;
+			set_page_private(page, (unsigned long)grp);
+			SetPagePrivate(page);
+		}
+
+		if (PageUptodate(page)) {
+			unlock_page(page);
+			page = NULL;
+		}
+		goto out;
+	}
+
+	/* for the truncation case (page locked) */
+	DBG_BUGON(page->mapping != NULL);
+
+	tocache = true;
+	unlock_page(page);
+	put_page(page);
+	/* fallthrough */
+#endif
+out_allocpage:
+	page = __stagingpage_alloc(pagepool, gfp);
+	if (oldpage != cmpxchg(&grp->compressed_pages[nr], oldpage, page)) {
+		list_add(&page->lru, pagepool);
+		cpu_relax();
+		goto repeat;
+	}
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	if (!tocache)
+		goto out;
+	if (!add_to_page_cache_lru(page, mc, first_index + nr, gfp)) {
 		set_page_private(page, (unsigned long)grp);
 		SetPagePrivate(page);
 	}
-	if (unlikely(PageUptodate(page))) {
-		unlock_page(page);
-		return true;
-	}
-	return false;
+#endif
+out:	/* the only exit (for tracing and debugging) */
+	return page;
 }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
 #define __FSIO_1 1
 #else
 #define __FSIO_1 0
@@ -1084,7 +1167,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	const unsigned clusterpages = erofs_clusterpages(sbi);
 	const gfp_t gfp = GFP_NOFS;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mngda = MNGD_MAPPING(sbi);
+	struct address_space *const mc = MNGD_MAPPING(sbi);
 	struct z_erofs_vle_workgroup *lstgrp_noio = NULL, *lstgrp_io = NULL;
 #endif
 	struct z_erofs_vle_unzip_io *ios[1 + __FSIO_1];
@@ -1123,13 +1206,10 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 	do {
 		struct z_erofs_vle_workgroup *grp;
-		struct page **compressed_pages, *oldpage, *page;
 		pgoff_t first_index;
+		struct page *page;
 		unsigned i = 0;
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
 		unsigned int noio = 0;
-		bool cachemngd;
-#endif
 		int err;
 
 		/* no possible 'owned_head' equals the following */
@@ -1143,48 +1223,17 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 			Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
 
 		first_index = grp->obj.index;
-		compressed_pages = grp->compressed_pages;
-
 		force_submit |= (first_index != last_index + 1);
-repeat:
-		/* fulfill all compressed pages */
-		oldpage = page = READ_ONCE(compressed_pages[i]);
 
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		cachemngd = false;
-
-		if (page == EROFS_UNALLOCATED_CACHED_PAGE) {
-			cachemngd = true;
-			goto do_allocpage;
-		} else if (page != NULL) {
-			if (page->mapping != mngda)
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
-		if (page != NULL)
-			BUG_ON(PageUptodate(page));
-		else {
-#endif
-			page = __stagingpage_alloc(pagepool, gfp);
+		/* fulfill all compressed pages */
+repeat:
+		page = z_erofs_workgrp_grab_page_for_submission(grp,
+			first_index, i, pagepool, gfp, mc);
 
-			if (oldpage != cmpxchg(compressed_pages + i,
-				oldpage, page)) {
-				list_add(&page->lru, pagepool);
-				goto repeat;
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-			} else if (cachemngd && !add_to_page_cache_lru(page,
-				mngda, first_index + i, gfp)) {
-				set_page_private(page, (unsigned long)grp);
-				SetPagePrivate(page);
-#endif
-			}
+		if (page == NULL) {
+			force_submit = true;
+			++noio;
+			goto skippage;
 		}
 
 		if (bio != NULL && force_submit) {
@@ -1207,9 +1256,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 		force_submit = false;
 		last_index = first_index + i;
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
 skippage:
-#endif
 		if (++i < clusterpages)
 			goto repeat;
 
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 3316bc3..cbc534e 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -69,6 +69,9 @@ struct z_erofs_vle_work {
 
 typedef struct z_erofs_vle_workgroup *z_erofs_vle_owned_workgrp_t;
 
+/* compressed page tagged pointer (bit 0 - with an extra reference) */
+typedef tagptr1_t z_erofs_ctptr_t;
+
 struct z_erofs_vle_workgroup {
 	struct erofs_workgroup obj;
 	struct z_erofs_vle_work work;
-- 
1.9.1
