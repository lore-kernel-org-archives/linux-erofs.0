From: sicilia.cristian@gmail.com (Cristian Sicilia)
Date: Mon, 12 Nov 2018 21:43:57 +0100
Subject: [PATCH 1/3] staging: erofs: unzip_vle.c: Replace comparison to NULL.
In-Reply-To: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>
References: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>
Message-ID: <1542055439-24444-2-git-send-email-sicilia.cristian@gmail.com>

Replace equal to NULL with logic unary operator,
and removing not equal to NULL comparison.

Signed-off-by: Cristian Sicilia <sicilia.cristian at gmail.com>
---
 drivers/staging/erofs/unzip_vle.c | 86 +++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 79d3ba6..1ffeeaa 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -20,8 +20,8 @@ static struct kmem_cache *z_erofs_workgroup_cachep __read_mostly;
 
 void z_erofs_exit_zip_subsystem(void)
 {
-	BUG_ON(z_erofs_workqueue == NULL);
-	BUG_ON(z_erofs_workgroup_cachep == NULL);
+	BUG_ON(!z_erofs_workqueue);
+	BUG_ON(!z_erofs_workgroup_cachep);
 
 	destroy_workqueue(z_erofs_workqueue);
 	kmem_cache_destroy(z_erofs_workgroup_cachep);
@@ -39,7 +39,7 @@ static inline int init_unzip_workqueue(void)
 		WQ_UNBOUND | WQ_HIGHPRI | WQ_CPU_INTENSIVE,
 		onlinecpus + onlinecpus / 4);
 
-	return z_erofs_workqueue != NULL ? 0 : -ENOMEM;
+	return z_erofs_workqueue ? 0 : -ENOMEM;
 }
 
 int __init z_erofs_init_zip_subsystem(void)
@@ -49,7 +49,7 @@ int __init z_erofs_init_zip_subsystem(void)
 		Z_EROFS_WORKGROUP_SIZE, 0,
 		SLAB_RECLAIM_ACCOUNT, NULL);
 
-	if (z_erofs_workgroup_cachep != NULL) {
+	if (z_erofs_workgroup_cachep) {
 		if (!init_unzip_workqueue())
 			return 0;
 
@@ -112,21 +112,21 @@ static bool grab_managed_cache_pages(struct address_space *mapping,
 	for (i = 0; i < clusterblks; ++i) {
 		struct page *page, *found;
 
-		if (READ_ONCE(compressed_pages[i]) != NULL)
+		if (READ_ONCE(compressed_pages[i]))
 			continue;
 
 		page = found = find_get_page(mapping, start + i);
-		if (found == NULL) {
+		if (!found) {
 			noio = false;
 			if (!reserve_allocation)
 				continue;
 			page = EROFS_UNALLOCATED_CACHED_PAGE;
 		}
 
-		if (NULL == cmpxchg(compressed_pages + i, NULL, page))
+		if (!cmpxchg(compressed_pages + i, NULL, page))
 			continue;
 
-		if (found != NULL)
+		if (found)
 			put_page(found);
 	}
 	return noio;
@@ -149,7 +149,7 @@ int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 	for (i = 0; i < clusterpages; ++i) {
 		struct page *page = grp->compressed_pages[i];
 
-		if (page == NULL || page->mapping != mapping)
+		if (!page || page->mapping != mapping)
 			continue;
 
 		/* block other users from reclaiming or migrating the page */
@@ -210,7 +210,7 @@ static inline bool try_to_reuse_as_compressed_page(
 {
 	while (b->compressed_deficit) {
 		--b->compressed_deficit;
-		if (NULL == cmpxchg(b->compressed_pages++, NULL, page))
+		if (!cmpxchg(b->compressed_pages++, NULL, page))
 			return true;
 	}
 
@@ -293,7 +293,7 @@ z_erofs_vle_work_lookup(const struct z_erofs_vle_work_finder *f)
 	struct z_erofs_vle_work *work;
 
 	egrp = erofs_find_workgroup(f->sb, f->idx, &tag);
-	if (egrp == NULL) {
+	if (!egrp) {
 		*f->grp_ret = NULL;
 		return NULL;
 	}
@@ -366,11 +366,11 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 	struct z_erofs_vle_work *work;
 
 	/* if multiref is disabled, grp should never be nullptr */
-	BUG_ON(grp != NULL);
+	BUG_ON(grp);
 
 	/* no available workgroup, let's allocate one */
 	grp = kmem_cache_zalloc(z_erofs_workgroup_cachep, GFP_NOFS);
-	if (unlikely(grp == NULL))
+	if (unlikely(!grp))
 		return ERR_PTR(-ENOMEM);
 
 	grp->obj.index = f->idx;
@@ -431,7 +431,7 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
 	};
 	struct z_erofs_vle_work *work;
 
-	DBG_BUGON(builder->work != NULL);
+	DBG_BUGON(builder->work);
 
 	/* must be Z_EROFS_WORK_TAIL or the next chained work */
 	DBG_BUGON(*owned_head == Z_EROFS_VLE_WORKGRP_NIL);
@@ -441,7 +441,7 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
 
 repeat:
 	work = z_erofs_vle_work_lookup(&finder);
-	if (work != NULL) {
+	if (work) {
 		unsigned int orig_llen;
 
 		/* increase workgroup `llen' if needed */
@@ -519,7 +519,7 @@ z_erofs_vle_work_iter_end(struct z_erofs_vle_work_builder *builder)
 {
 	struct z_erofs_vle_work *work = builder->work;
 
-	if (work == NULL)
+	if (!work)
 		return false;
 
 	z_erofs_pagevec_ctor_exit(&builder->vector, false);
@@ -542,7 +542,7 @@ static inline struct page *__stagingpage_alloc(struct list_head *pagepool,
 {
 	struct page *page = erofs_allocpage(pagepool, gfp);
 
-	if (unlikely(page == NULL))
+	if (unlikely(!page))
 		return NULL;
 
 	page->mapping = Z_EROFS_MAPPING_STAGING;
@@ -740,10 +740,10 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 		bool cachemngd = false;
 
 		DBG_BUGON(PageUptodate(page));
-		BUG_ON(page->mapping == NULL);
+		BUG_ON(!page->mapping);
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (unlikely(mngda == NULL && !z_erofs_is_stagingpage(page))) {
+		if (unlikely(!mngda && !z_erofs_is_stagingpage(page))) {
 			struct inode *const inode = page->mapping->host;
 			struct super_block *const sb = inode->i_sb;
 
@@ -814,7 +814,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 			sizeof(struct page *), GFP_KERNEL);
 
 		/* fallback to global pagemap for the lowmem scenario */
-		if (unlikely(pages == NULL)) {
+		if (unlikely(!pages)) {
 			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
 				goto repeat;
 			else {
@@ -836,8 +836,8 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		page = z_erofs_pagevec_ctor_dequeue(&ctor, &page_type);
 
 		/* all pages in pagevec ought to be valid */
-		DBG_BUGON(page == NULL);
-		DBG_BUGON(page->mapping == NULL);
+		DBG_BUGON(!page);
+		DBG_BUGON(!page->mapping);
 
 		if (z_erofs_gather_if_stagingpage(page_pool, page))
 			continue;
@@ -848,7 +848,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 			pagenr = z_erofs_onlinepage_index(page);
 
 		BUG_ON(pagenr >= nr_pages);
-		BUG_ON(pages[pagenr] != NULL);
+		BUG_ON(pages[pagenr]);
 
 		pages[pagenr] = page;
 	}
@@ -865,8 +865,8 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		page = compressed_pages[i];
 
 		/* all compressed pages ought to be valid */
-		DBG_BUGON(page == NULL);
-		DBG_BUGON(page->mapping == NULL);
+		DBG_BUGON(!page);
+		DBG_BUGON(!page->mapping);
 
 		if (z_erofs_is_stagingpage(page))
 			continue;
@@ -882,7 +882,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		pagenr = z_erofs_onlinepage_index(page);
 
 		BUG_ON(pagenr >= nr_pages);
-		BUG_ON(pages[pagenr] != NULL);
+		BUG_ON(pages[pagenr]);
 		++sparsemem_pages;
 		pages[pagenr] = page;
 
@@ -915,7 +915,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	}
 
 	for (i = 0; i < nr_pages; ++i) {
-		if (pages[i] != NULL)
+		if (pages[i])
 			continue;
 
 		pages[i] = __stagingpage_alloc(page_pool, GFP_NOFS);
@@ -932,7 +932,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 out:
 	for (i = 0; i < nr_pages; ++i) {
 		page = pages[i];
-		DBG_BUGON(page->mapping == NULL);
+		DBG_BUGON(!page->mapping);
 
 		/* recycle all individual staging pages */
 		if (z_erofs_gather_if_stagingpage(page_pool, page))
@@ -1021,20 +1021,20 @@ prepare_io_handler(struct super_block *sb,
 
 	if (!background) {
 		/* waitqueue available for foreground io */
-		BUG_ON(io == NULL);
+		BUG_ON(!io);
 
 		init_waitqueue_head(&io->u.wait);
 		atomic_set(&io->pending_bios, 0);
 		goto out;
 	}
 
-	if (io != NULL)
+	if (io)
 		BUG();
 	else {
 		/* allocate extra io descriptor for background io */
 		iosb = kvzalloc(sizeof(struct z_erofs_vle_unzip_io_sb),
 			GFP_KERNEL | __GFP_NOFAIL);
-		BUG_ON(iosb == NULL);
+		BUG_ON(!iosb);
 
 		io = &iosb->io;
 	}
@@ -1154,7 +1154,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		if (page == EROFS_UNALLOCATED_CACHED_PAGE) {
 			cachemngd = true;
 			goto do_allocpage;
-		} else if (page != NULL) {
+		} else if (page) {
 			if (page->mapping != mngda)
 				BUG_ON(PageUptodate(page));
 			else if (recover_managed_page(grp, page)) {
@@ -1166,7 +1166,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		} else {
 do_allocpage:
 #else
-		if (page != NULL)
+		if (page)
 			BUG_ON(PageUptodate(page));
 		else {
 #endif
@@ -1185,13 +1185,13 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 			}
 		}
 
-		if (bio != NULL && force_submit) {
+		if (bio && force_submit) {
 submit_bio_retry:
 			__submit_bio(bio, REQ_OP_READ, 0);
 			bio = NULL;
 		}
 
-		if (bio == NULL) {
+		if (!bio) {
 			bio = erofs_grab_bio(sb, first_index + i,
 				BIO_MAX_PAGES, z_erofs_vle_read_endio, true);
 			bio->bi_private = tagptr_cast_ptr(bi_private);
@@ -1220,12 +1220,12 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 				Z_EROFS_VLE_WORKGRP_TAIL_CLOSED :
 				owned_head;
 
-			if (lstgrp_io == NULL)
+			if (!lstgrp_io)
 				ios[1]->head = iogrp_next;
 			else
 				WRITE_ONCE(lstgrp_io->next, iogrp_next);
 
-			if (lstgrp_noio == NULL)
+			if (!lstgrp_noio)
 				ios[0]->head = grp;
 			else
 				WRITE_ONCE(lstgrp_noio->next, grp);
@@ -1235,13 +1235,13 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 #endif
 	} while (owned_head != Z_EROFS_VLE_WORKGRP_TAIL);
 
-	if (bio != NULL)
+	if (bio)
 		__submit_bio(bio, REQ_OP_READ, 0);
 
 #ifndef EROFS_FS_HAS_MANAGED_CACHE
 	BUG_ON(!nr_bios);
 #else
-	if (lstgrp_noio != NULL)
+	if (lstgrp_noio)
 		WRITE_ONCE(lstgrp_noio->next, Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
 
 	if (!force_fg && !nr_bios) {
@@ -1300,7 +1300,7 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 
 	z_erofs_submit_and_unzip(&f, &pagepool, true);
 out:
-	if (f.m_iter.mpage != NULL)
+	if (f.m_iter.mpage)
 		put_page(f.m_iter.mpage);
 
 	/* clean up the remaining free pages */
@@ -1344,7 +1344,7 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
 		head = page;
 	}
 
-	while (head != NULL) {
+	while (head) {
 		struct page *page = head;
 		int err;
 
@@ -1366,7 +1366,7 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
 
 	z_erofs_submit_and_unzip(&f, &pagepool, sync);
 
-	if (f.m_iter.mpage != NULL)
+	if (f.m_iter.mpage)
 		put_page(f.m_iter.mpage);
 
 	/* clean up the remaining free pages */
@@ -1561,7 +1561,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	mblk = vle_extent_blkaddr(inode, lcn);
 
 	if (!mpage || mpage->index != mblk) {
-		if (mpage != NULL)
+		if (mpage)
 			put_page(mpage);
 
 		mpage = erofs_get_meta_page(ctx.sb, mblk, false);
-- 
2.7.4
