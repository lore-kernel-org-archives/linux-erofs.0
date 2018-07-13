From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 13 Jul 2018 21:17:08 +0800
Subject: [PATCH 1/2] temp commit 1
In-Reply-To: <1531163839-29830-11-git-send-email-gaoxiang25@huawei.com>
References: <1531163839-29830-11-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1531487829-84202-1-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/Kconfig     |  38 ++++++
 fs/erofs/Makefile    |   2 +-
 fs/erofs/unzip_vle.c | 374 +++++++++++++++++++++++++++++----------------------
 fs/erofs/unzip_vle.h | 103 +++++++-------
 4 files changed, 308 insertions(+), 209 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 00e811c..583a7b3 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -99,3 +99,41 @@ config EROFS_FS_CLUSTER_PAGE_LIMIT
 	  than 2. Otherwise, the image cannot be mounted
 	  correctly on this kernel.
 
+choice
+	prompt "EROFS VLE Data Decompression mode"
+	depends on EROFS_FS_ZIP
+	help
+	  EROFS supports three options for VLE decompression.
+	  "In-place Decompression Only" consumes the minimum memory
+	  with lowest random read.
+
+	  "Bidirectional Cached Decompression" consumes the maximum memory
+	  with highest random read.
+
+	  If unsure, select "Bidirectional Cached Decompression"
+
+config EROFS_FS_ZIP_0
+	bool "In-place Decompression Only"
+	help
+	  Read compressed data into page cache and do in-place
+	  decompression directly.
+
+config EROFS_FS_ZIP_UNIDIRECTIONAL
+	bool "Unidirectional Cached Decompression"
+	help
+	  For each request, it caches the last compressed page
+	  for further reading.
+	  It still decompresses in place for the rest compressed pages.
+
+config EROFS_FS_ZIP_BIDIRECTIONAL
+	bool "Bidirectional Cached Decompression"
+	default y
+	help
+	  For each request, it caches the both end compressed pages
+	  for further reading.
+	  It still decompresses in place for the rest compressed pages.
+
+	  Recommended for performance priority.
+
+endchoice
+
diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
index fa9d179..0c34265 100644
--- a/fs/erofs/Makefile
+++ b/fs/erofs/Makefile
@@ -1,6 +1,6 @@
 EROFS_VERSION = "1.0"
 
-EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
+EXTRA_CFLAGS += -g -O1 -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 
 obj-$(CONFIG_EROFS_FS) += erofs.o
 erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
diff --git a/fs/erofs/unzip_vle.c b/fs/erofs/unzip_vle.c
index 04c50cd..7ca1d5d 100644
--- a/fs/erofs/unzip_vle.c
+++ b/fs/erofs/unzip_vle.c
@@ -56,8 +56,16 @@ int z_erofs_init_zip_subsystem(void)
 	return -ENOMEM;
 }
 
+enum z_erofs_vle_workrole {
+	Z_EROFS_VLE_WORK_SECONDARY,
+	Z_EROFS_VLE_WORK_PRIMARY,
+	Z_EROFS_VLE_WORK_PRIMARY_OWNER,
+	Z_EROFS_VLE_WORK_MAX
+};
+
 struct z_erofs_vle_work_handler {
-	bool owner;
+	enum z_erofs_vle_workrole role;
+
 	struct z_erofs_vle_work *curr;
 	struct z_erofs_pagevec_ctor vector;
 
@@ -66,6 +74,9 @@ struct z_erofs_vle_work_handler {
 	unsigned compressed_deficit;
 };
 
+#define VLE_WORK_HANDLER_INIT()	\
+	{ .curr = NULL, .role = Z_EROFS_VLE_WORK_PRIMARY_OWNER }
+
 /* page_type must be Z_EROFS_PAGE_TYPE_EXCLUSIVE */
 static inline bool try_to_reuse_as_compressed_page(
 	struct z_erofs_vle_work_handler *w,
@@ -91,7 +102,8 @@ static int z_erofs_vle_work_add_page(
 	bool occupied;
 
 	/* give priority for the compressed data storage */
-	if (type == Z_EROFS_PAGE_TYPE_EXCLUSIVE &&
+	if (w->role >= Z_EROFS_VLE_WORK_PRIMARY &&
+		type == Z_EROFS_PAGE_TYPE_EXCLUSIVE &&
 		try_to_reuse_as_compressed_page(w, page))
 		return 0;
 
@@ -102,16 +114,45 @@ static int z_erofs_vle_work_add_page(
 	return ret ? 0 : -EAGAIN;
 }
 
-static inline
-struct z_erofs_vle_work *z_erofs_vle_work_find(struct super_block *sb,
+static inline bool try_to_claim_workgroup(
+	struct z_erofs_vle_workgroup *grp,
+	z_erofs_vle_owned_workgrp_t *owned_head)
+{
+	/* let's claim these following types of workgroup */
+retry:
+	if (grp->next == Z_EROFS_VLE_WORKGRP_NIL) {
+		/* type 1, nil workgroup */
+		if (Z_EROFS_VLE_WORKGRP_NIL != cmpxchg(&grp->next,
+			Z_EROFS_VLE_WORKGRP_NIL, *owned_head))
+			goto retry;
+
+		*owned_head = grp;
+	} else if (grp->next == Z_EROFS_VLE_WORKGRP_TAIL) {
+		/* type 2, link to the end of a existing chain */
+		if (Z_EROFS_VLE_WORKGRP_TAIL != cmpxchg(&grp->next,
+			Z_EROFS_VLE_WORKGRP_TAIL, *owned_head))
+			goto retry;
+
+		*owned_head = Z_EROFS_VLE_WORKGRP_TAIL;
+	} else
+		return false;	/* :( better luck next time */
+
+	return true;	/* lucky, I am the owner :) */
+}
+
+struct z_erofs_vle_work *
+z_erofs_vle_work_lookup(struct super_block *sb,
 	pgoff_t idx, unsigned pageofs,
-	bool *cached_ret,
-	struct z_erofs_vle_workgroup **grp_ret)
+	struct z_erofs_vle_workgroup **grp_ret,
+	enum z_erofs_vle_workrole *role,
+	z_erofs_vle_owned_workgrp_t *owned_head)
 {
-	bool cached;
-	struct erofs_workgroup *egrp = erofs_find_workgroup(sb, idx, &cached);
+	bool tag, primary;
+	struct erofs_workgroup *egrp;
 	struct z_erofs_vle_workgroup *grp;
+	struct z_erofs_vle_work *work;
 
+	egrp = erofs_find_workgroup(sb, idx, &tag);
 	if (egrp == NULL) {
 		*grp_ret = NULL;
 		return NULL;
@@ -119,21 +160,73 @@ struct z_erofs_vle_work *z_erofs_vle_work_find(struct super_block *sb,
 
 	*grp_ret = grp = container_of(egrp,
 		struct z_erofs_vle_workgroup, obj);
-	*cached_ret = cached;
 
-	return cached ? z_erofs_vle_work_cached(grp, pageofs) :
-		z_erofs_vle_work_uncached(grp, pageofs);
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	work = z_erofs_vle_grab_work(grp, pageofs);
+	primary = true;
+#else
+	BUG();
+#endif
+
+	/*
+	 * lock must be taken first to avoid grp->next == NIL between
+	 * claiming workgroup and adding pages:
+	 *                        grp->next != NIL
+	 *   grp->next = NIL
+	 *   mutex_unlock_all
+	 *                        mutex_lock(&work->lock)
+	 *                        add all pages to pagevec
+	 *
+	 * [correct locking case 1]:
+	 *   mutex_lock(grp->work[a])
+	 *   ...
+	 *   mutex_lock(grp->work[b])     mutex_lock(grp->work[c])
+	 *   ...                          *role = SECONDARY
+	 *                                add all pages to pagevec
+	 *                                ...
+	 *                                mutex_unlock(grp->work[c])
+	 *   mutex_lock(grp->work[c])
+	 *   ...
+	 *   grp->next = NIL
+	 *   mutex_unlock_all
+	 *
+	 * [correct locking case 2]:
+	 *   mutex_lock(grp->work[b])
+	 *   ...
+	 *   mutex_lock(grp->work[a])
+	 *   ...
+	 *   mutex_lock(grp->work[c])
+	 *   ...
+	 *   grp->next = NIL
+	 *   mutex_unlock_all
+	 *                                mutex_lock(grp->work[a])
+	 *                                *role = PRIMARY_OWNER
+	 *                                add all pages to pagevec
+	 *                                ...
+	 */
+	mutex_lock(&work->lock);
+
+	if (!primary)
+		*role = Z_EROFS_VLE_WORK_SECONDARY;
+	/* claim the workgroup if possible */
+	else if (try_to_claim_workgroup(grp, owned_head))
+		*role = Z_EROFS_VLE_WORK_PRIMARY_OWNER;
+	else
+		*role = Z_EROFS_VLE_WORK_PRIMARY;
+
+	return work;
 }
 
-static inline struct z_erofs_vle_work *
+struct z_erofs_vle_work *
 z_erofs_vle_work_register(struct super_block *sb,
-			  struct z_erofs_vle_workgroup *grp,
-			  bool cached,
+			  struct z_erofs_vle_workgroup **grp_ret,
 			  struct erofs_map_blocks *map,
 			  pgoff_t index, unsigned pageofs,
-			  erofs_wtptr_t *owned_head)
+			  enum z_erofs_vle_workrole *role,
+			  z_erofs_vle_owned_workgrp_t *owned_head)
 {
 	bool newgrp = false;
+	struct z_erofs_vle_workgroup *grp = *grp_ret;
 	struct z_erofs_vle_work *work;
 
 #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
@@ -150,29 +243,31 @@ struct z_erofs_vle_work *z_erofs_vle_work_find(struct super_block *sb,
 	grp->obj.index = index;
 	grp->llen = map->m_llen;
 
-	z_erofs_vle_set_work_format(grp,
+	z_erofs_vle_set_workgrp_fmt(grp,
 		(map->m_flags & EROFS_MAP_ZIPPED) ?
-			Z_EROFS_WORK_FORMAT_LZ4 :
-			Z_EROFS_WORK_FORMAT_PLAIN);
+			Z_EROFS_VLE_WORKGRP_FMT_LZ4 :
+			Z_EROFS_VLE_WORKGRP_FMT_PLAIN);
 	atomic_set(&grp->obj.refcount, 1);
 
+	/* new workgrps have been claimed as type 1 */
+	WRITE_ONCE(grp->next, *owned_head);
+	/* primary & owner work role for new workgrps */
+	*role = Z_EROFS_VLE_WORK_PRIMARY_OWNER;
+
 	newgrp = true;
 #ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
 skip:
-	/* currently not implemented */
+	/* currently unimplemented */
 	BUG();
 #else
-	work = cached ? z_erofs_vle_work_cached(grp, pageofs) :
-		z_erofs_vle_work_uncached(grp, pageofs);
+	work = z_erofs_vle_grab_primary_work(grp);
 #endif
 	work->pageofs = pageofs;
 
 	mutex_init(&work->lock);
-	/* new works have been claimed as type 1 */
-	WRITE_ONCE(work->next, *owned_head);
 
 	if (newgrp) {
-		int err = erofs_register_workgroup(sb, &grp->obj, cached);
+		int err = erofs_register_workgroup(sb, &grp->obj, 0);
 
 		if (err) {
 			kmem_cache_free(z_erofs_workgroup_cachep, grp);
@@ -180,61 +275,45 @@ struct z_erofs_vle_work *z_erofs_vle_work_find(struct super_block *sb,
 		}
 	}
 
-	*owned_head = tagptr_fold(erofs_wtptr_t, work, cached);
-	return work;
-}
-
-static inline bool try_to_claim_work(struct z_erofs_vle_work *work,
-     erofs_wtptr_t *owned_head, bool cached)
-{
-	/* let's claim these following types of work */
-retry:
-	if (tagptr_eq(work->next, Z_EROFS_WORK_TPTR_TAIL)) {
-		/* type 2, link to a existing chain */
-		if (!tagptr_eq(tagptr_cmpxchg(&work->next,
-			Z_EROFS_WORK_TPTR_TAIL, *owned_head),
-			Z_EROFS_WORK_TPTR_TAIL))
-			goto retry;
-
-		*owned_head = Z_EROFS_WORK_TPTR_TAIL;
-	} else if (tagptr_eq(work->next, Z_EROFS_WORK_TPTR_NIL)) {
-		/* type 1 */
-		if (!tagptr_eq(tagptr_cmpxchg(&work->next,
-			Z_EROFS_WORK_TPTR_NIL, *owned_head),
-			Z_EROFS_WORK_TPTR_NIL))
-			goto retry;
-
-		*owned_head = tagptr_fold(erofs_wtptr_t, work, cached);
-	} else
-		return false;	/* :( better luck next time */
+	*owned_head = *grp_ret = grp;
 
-	return true;	/* lucky, I am the owner :) */
+	mutex_lock(&work->lock);
+	return work;
 }
 
 static inline void __reset_compressed_pages(
 	struct z_erofs_vle_work_handler *w,
-	struct z_erofs_vle_work *work, bool cached,
+	struct z_erofs_vle_workgroup *grp, bool page_reuse,
 	unsigned clusterpages)
 {
-	if (!cached) {
-		w->compressed_pages =
-			z_erofs_vle_work_uncached_mux(work);
+	if (page_reuse) {
+		w->compressed_pages = grp->compressed_pages;
 		w->compressed_deficit = clusterpages;
 		return;
 	}
 
-	/* TODO! get cached pages before submitting io */
 	w->compressed_pages = NULL;
 	w->compressed_deficit = 0;
 }
 
+static inline void __update_workgrp_llen(struct z_erofs_vle_workgroup *grp,
+					 unsigned int llen)
+{
+	while(1) {
+		unsigned int orig_llen = grp->llen;
+
+		if (orig_llen >= llen || cmpxchg(&grp->llen,
+			orig_llen, llen) == orig_llen)
+			break;
+	}
+}
+
 static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_handler *w,
 				       struct super_block *sb,
 				       struct erofs_map_blocks *map,
-				       erofs_wtptr_t *owned_head)
+				       z_erofs_vle_owned_workgrp_t *owned_head)
 {
 	struct z_erofs_vle_workgroup *grp;
-	bool cached;
 	pgoff_t index = map->m_pa / EROFS_BLKSIZ;
 	struct z_erofs_vle_work *work;
 	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
@@ -243,48 +322,39 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_handler *w,
 	BUG_ON(w->curr != NULL);
 
 	/* must be Z_EROFS_WORK_TAIL or the next chained work */
-	BUG_ON(tagptr_cast_ptr(*owned_head) == NULL);
+	BUG_ON(*owned_head == Z_EROFS_VLE_WORKGRP_NIL);
+	BUG_ON(*owned_head == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+
 	BUG_ON(map->m_pa % EROFS_BLKSIZ);
 
 repeat:
-	work = z_erofs_vle_work_find(sb, index,
-		pageofs, &cached, &grp);
+	work = z_erofs_vle_work_lookup(sb, index,
+		pageofs, &grp, &w->role, owned_head);
 	if (work != NULL) {
 		BUG_ON(index != grp->obj.index);
-
-		__reset_compressed_pages(w, work, cached, clusterpages);
 		BUG_ON(work->pageofs != pageofs);
 
-		mutex_lock(&work->lock);
-
-		if (grp->llen < map->m_llen)
-			grp->llen = map->m_llen;
-
-		w->owner = false;
-		/* claim the work if it can */
-		if (try_to_claim_work(work, owned_head, cached))
-			w->owner = true;
-
+		__update_workgrp_llen(grp, map->m_llen);
 		goto got_it;
 	}
 
-	work = z_erofs_vle_work_register(sb, grp,
-		false, map, index, pageofs, owned_head);
+	work = z_erofs_vle_work_register(sb, &grp,
+		map, index, pageofs, &w->role, owned_head);
 
 	if (unlikely(work == ERR_PTR(-EAGAIN)))
 		goto repeat;
 
 	if (unlikely(IS_ERR(work)))
 		return PTR_ERR(work);
-
-	__reset_compressed_pages(w, work, cached, clusterpages);
-	w->owner = true;
-
-	mutex_lock(&work->lock);
-
 got_it:
 	z_erofs_pagevec_ctor_init(&w->vector,
 		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, work->vcnt);
+
+	if (w->role >= Z_EROFS_VLE_WORK_PRIMARY)
+		__reset_compressed_pages(w, grp, true, clusterpages);
+	else
+		__reset_compressed_pages(w, grp, false, 0);
+
 	w->curr = work;
 	return 0;
 }
@@ -293,7 +363,8 @@ static void z_erofs_rcu_callback(struct rcu_head *head)
 {
 	struct z_erofs_vle_work *work =	container_of(head,
 		struct z_erofs_vle_work, rcu);
-	struct z_erofs_vle_workgroup *grp = z_erofs_vle_work_workgroup(work);
+	struct z_erofs_vle_workgroup *grp =
+		z_erofs_vle_work_workgroup(work, true);
 
 	kmem_cache_free(z_erofs_workgroup_cachep, grp);
 }
@@ -302,7 +373,7 @@ void erofs_workgroup_free_rcu(struct erofs_workgroup *grp)
 {
 	struct z_erofs_vle_workgroup *const vgrp = container_of(grp,
 		struct z_erofs_vle_workgroup, obj);
-	struct z_erofs_vle_work *const work = &vgrp->u.work;
+	struct z_erofs_vle_work *const work = &vgrp->work;
 
 	call_rcu(&work->rcu, z_erofs_rcu_callback);
 }
@@ -310,11 +381,13 @@ void erofs_workgroup_free_rcu(struct erofs_workgroup *grp)
 void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
 {
 	struct z_erofs_vle_workgroup *grp =
-		z_erofs_vle_work_workgroup(work);
+		z_erofs_vle_work_workgroup(work, true);
 
 	erofs_workgroup_put(&grp->obj);
 }
 
+#define handler_is_owner(w) ((w)->role >= Z_EROFS_VLE_WORK_PRIMARY_OWNER)
+
 static inline void
 z_erofs_vle_work_iter_end(struct z_erofs_vle_work_handler *w)
 {
@@ -327,7 +400,7 @@ void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
 	 * if all pending pages are added, don't hold work reference
 	 * any longer if the current handler is not the owner.
 	 */
-	if (!w->owner)
+	if (!handler_is_owner(w))
 		z_erofs_vle_work_release(work);
 
 	z_erofs_pagevec_ctor_exit(&w->vector, false);
@@ -338,13 +411,13 @@ void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
 static int z_erofs_do_read_page(struct page *page,
 				struct z_erofs_vle_work_handler *h,
 				struct erofs_map_blocks_iter *m,
-				erofs_wtptr_t *owned_head,
+				z_erofs_vle_owned_workgrp_t *owned_head,
 				struct list_head *page_pool)
 {
 	struct inode *const inode = page->mapping->host;
 	struct super_block *const sb = inode->i_sb;
 	const loff_t offset = page_offset(page);
-	bool owned = h->owner;
+	bool owned = handler_is_owner(h);
 	struct z_erofs_vle_work *work = h->curr;
 	enum z_erofs_page_type page_type;
 	unsigned cur, end, spiltted, index;
@@ -385,7 +458,7 @@ static int z_erofs_do_read_page(struct page *page,
 	if (unlikely(err))
 		goto err_out;
 
-	owned &= h->owner;
+	owned &= handler_is_owner(h);
 	work = h->curr;
 hitted:
 	cur = end - min_t(unsigned, offset + end - m->map.m_la, end);
@@ -498,8 +571,8 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 static DEFINE_MUTEX(z_pagemap_global_lock);
 
 static int z_erofs_vle_unzip(struct super_block *sb,
-	struct z_erofs_vle_work *work,
-	bool cached, struct list_head *page_pool)
+	struct z_erofs_vle_workgroup *grp,
+	struct list_head *page_pool)
 {
 	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
 	struct z_erofs_pagevec_ctor ctor;
@@ -513,12 +586,17 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 
 	enum z_erofs_page_type page_type;
 	bool overlapped;
-	struct z_erofs_vle_workgroup *grp;
+	struct z_erofs_vle_work *work;
 	void *vout;
 	int err;
 
-	BUG_ON(!READ_ONCE(work->nr_pages));
 	might_sleep();
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	work = z_erofs_vle_grab_primary_work(grp);
+#else
+	BUG();
+#endif
+	BUG_ON(!READ_ONCE(work->nr_pages));
 
 	mutex_lock(&work->lock);
 	nr_pages = work->nr_pages;
@@ -578,38 +656,32 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	z_erofs_pagevec_ctor_exit(&ctor, true);
 
 	overlapped = false;
-	if (cached) {
-		grp = z_erofs_vle_work_workgroup(work);
-		compressed_pages = z_erofs_vle_cached_managed(grp);
-	} else {
-		grp = z_erofs_vle_work_workgroup(work);
-		compressed_pages = z_erofs_vle_work_uncached_mux(work);
+	compressed_pages = grp->compressed_pages;
 
-		for(i = 0; i < clusterpages; ++i) {
-			unsigned pagenr;
+	for(i = 0; i < clusterpages; ++i) {
+		unsigned pagenr;
 
-			BUG_ON(compressed_pages[i] == NULL);
-			page = compressed_pages[i];
+		BUG_ON(compressed_pages[i] == NULL);
+		page = compressed_pages[i];
 
-			if (page->mapping == NULL)
-				continue;
+		if (page->mapping == NULL)
+			continue;
 
-			pagenr = z_erofs_onlinepage_index(page);
+		pagenr = z_erofs_onlinepage_index(page);
 
-			BUG_ON(pagenr >= nr_pages);
+		BUG_ON(pagenr >= nr_pages);
 #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
-			BUG_ON(pages[pagenr] != NULL);
-			++sparsemem_pages;
+		BUG_ON(pages[pagenr] != NULL);
+		++sparsemem_pages;
 #endif
-			pages[pagenr] = page;
+		pages[pagenr] = page;
 
-			overlapped = true;
-		}
+		overlapped = true;
 	}
 
 	llen = (nr_pages << PAGE_SHIFT) - work->pageofs;
 
-	if (z_erofs_vle_workgroup_fmt(grp) == Z_EROFS_WORK_FORMAT_PLAIN) {
+	if (z_erofs_vle_workgrp_fmt(grp) == Z_EROFS_VLE_WORKGRP_FMT_PLAIN) {
 		BUG_ON(grp->llen != llen);
 
 		err = z_erofs_vle_plain_copy(compressed_pages, clusterpages,
@@ -675,8 +747,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		if (page->mapping == NULL)
 			list_add(&page->lru, page_pool);
 
-		if (!cached)
-			WRITE_ONCE(compressed_pages[i], NULL);
+		WRITE_ONCE(compressed_pages[i], NULL);
 	}
 
 	if (pages == z_pagemap_global)
@@ -687,8 +758,14 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	work->nr_pages = 0;
 	work->vcnt = 0;
 
-	WRITE_ONCE(work->next, Z_EROFS_WORK_TPTR_NIL);
+	/* all work locks MUST be taken before */
+
+	WRITE_ONCE(grp->next, Z_EROFS_VLE_WORKGRP_NIL);
+
+	/* all work locks SHOULD be released right now */
 	mutex_unlock(&work->lock);
+
+	z_erofs_vle_work_release(work);
 	return err;
 }
 
@@ -696,26 +773,23 @@ static void z_erofs_vle_unzip_all(struct super_block *sb,
 				  struct z_erofs_vle_unzip_io *io,
 				  struct list_head *page_pool)
 {
-	erofs_wtptr_t owned = io->head;
-	struct z_erofs_vle_work *work;
-	bool cached;
+	z_erofs_vle_owned_workgrp_t owned = io->head;
 
-	BUG_ON(tagptr_eq(owned, Z_EROFS_WORK_TPTR_TAIL_CLOSED));
+	BUG_ON(owned == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
 	do {
+		struct z_erofs_vle_workgroup *grp;
+
 		/* no possible that 'owned' equals Z_EROFS_WORK_TPTR_TAIL */
-		BUG_ON(tagptr_eq(owned, Z_EROFS_WORK_TPTR_TAIL));
+		BUG_ON(owned == Z_EROFS_VLE_WORKGRP_TAIL);
 
 		/* no possible that 'owned' equals NULL */
-		BUG_ON(tagptr_eq(owned, Z_EROFS_WORK_TPTR_NIL));
-
-		work = tagptr_unfold_ptr(owned);
-		cached = tagptr_unfold_tags(owned);
+		BUG_ON(owned == Z_EROFS_VLE_WORKGRP_NIL);
 
-		owned = READ_ONCE(work->next);
-		z_erofs_vle_unzip(sb, work, cached, page_pool);
+		grp = owned;
+		owned = READ_ONCE(grp->next);
 
-		z_erofs_vle_work_release(work);
-	} while (!tagptr_eq(owned, Z_EROFS_WORK_TPTR_TAIL_CLOSED));
+		z_erofs_vle_unzip(sb, grp, page_pool);
+	} while (owned != Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
 }
 
 static void z_erofs_vle_unzip_wq(struct work_struct *work)
@@ -762,7 +836,7 @@ static inline tagptr1_t prepare_io_handler(
 }
 
 static bool z_erofs_vle_submit_all(struct super_block *sb,
-				   erofs_wtptr_t owned_head,
+				   z_erofs_vle_owned_workgrp_t owned_head,
 				   struct list_head *page_pool,
 				   struct z_erofs_vle_unzip_io *io)
 {
@@ -773,7 +847,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	unsigned bios_submitted;
 	tagptr1_t tio;
 
-	if (unlikely(tagptr_eq(owned_head, Z_EROFS_WORK_TPTR_TAIL)))
+	if (unlikely(owned_head == Z_EROFS_VLE_WORKGRP_TAIL))
 		return false;
 
 	tio = prepare_io_handler(sb, io, &sync);
@@ -784,36 +858,23 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	bios_submitted = 0;
 
 	do {
-		struct z_erofs_vle_work *work;
 		struct z_erofs_vle_workgroup *grp;
-		bool cached, locked;
 		struct page **compressed_pages;
 		pgoff_t current_page;
 		unsigned i;
 		int err;
 
 		/* no possible 'owned_head' equals the following */
-		BUG_ON(tagptr_eq(owned_head, Z_EROFS_WORK_TPTR_TAIL_CLOSED));
-		BUG_ON(tagptr_eq(owned_head, Z_EROFS_WORK_TPTR_NIL));
+		BUG_ON(owned_head == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+		BUG_ON(owned_head == Z_EROFS_VLE_WORKGRP_NIL);
 
-		work = tagptr_unfold_ptr(owned_head);
-		cached = tagptr_unfold_tags(owned_head);
+		grp = owned_head;
 
 		/* close the owned chain at first */
-		owned_head = tagptr_cmpxchg(&work->next,
-			Z_EROFS_WORK_TPTR_TAIL, Z_EROFS_WORK_TPTR_TAIL_CLOSED);
-
-		grp = z_erofs_vle_work_workgroup(work);
-
-		BUG_ON(cached);
+		owned_head = cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_TAIL,
+			Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
 
-		locked = false;
-		if (unlikely(mutex_is_locked(&work->lock))) {
-			mutex_lock(&work->lock);
-			locked = true;
-		}
-
-		compressed_pages = z_erofs_vle_work_uncached_mux(work);
+		compressed_pages = grp->compressed_pages;
 		/* fulfill all compressed pages */
 		for (i = 0; i < clusterpages; ++i) {
 			struct page *page;
@@ -828,9 +889,6 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 				list_add(&page->lru, page_pool);
 		}
 
-		if (unlikely(locked))
-			mutex_unlock(&work->lock);
-
 		current_page = grp->obj.index;
 		i = 0;
 
@@ -857,7 +915,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 		if (++i < clusterpages)
 			goto repeat;
-	} while (!tagptr_eq(owned_head, Z_EROFS_WORK_TPTR_TAIL));
+	} while (owned_head != Z_EROFS_VLE_WORKGRP_TAIL);
 
 	if (bio != NULL)
 		__submit_bio(bio, REQ_OP_READ, 0);
@@ -873,8 +931,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 		.map = { .m_llen = 0, .m_plen = 0 },
 		.mpage = NULL
 	};
-	struct z_erofs_vle_work_handler h = { .curr = NULL, .owner = true };
-	erofs_wtptr_t owned_head = Z_EROFS_WORK_TPTR_TAIL;
+	struct z_erofs_vle_work_handler h = VLE_WORK_HANDLER_INIT();
+	z_erofs_vle_owned_workgrp_t owned_head = Z_EROFS_VLE_WORKGRP_TAIL;
 	struct super_block *sb;
 	struct z_erofs_vle_unzip_io io;
 	LIST_HEAD(pagepool);
@@ -917,12 +975,12 @@ static inline int __z_erofs_vle_normalaccess_readpages(
 		.map = { .m_llen = 0, .m_plen = 0 },
 		.mpage = NULL
 	};
-	struct z_erofs_vle_work_handler h = { .curr = NULL, .owner = true };
+	struct z_erofs_vle_work_handler h = VLE_WORK_HANDLER_INIT();
+	z_erofs_vle_owned_workgrp_t owned_head = Z_EROFS_VLE_WORKGRP_TAIL;
 	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	struct page *head = NULL;
 	struct inode *inode = mapping->host;
 	struct super_block *sb = inode->i_sb;
-	erofs_wtptr_t owned_head = Z_EROFS_WORK_TPTR_TAIL;
 	LIST_HEAD(pagepool);
 
 	for (; nr_pages; --nr_pages) {
diff --git a/fs/erofs/unzip_vle.h b/fs/erofs/unzip_vle.h
index 7542aa8..2a446f9 100644
--- a/fs/erofs/unzip_vle.h
+++ b/fs/erofs/unzip_vle.h
@@ -16,22 +16,13 @@
 #include "internal.h"
 #include "unzip_pagevec.h"
 
-/* (uncached/cached) work tagged pointer */
-typedef tagptr1_t       erofs_wtptr_t;
-
-/* let's avoid the 32-bit valid kernel address */
-
-/* the chained works haven't io submitted (still open) */
-#define Z_EROFS_WORK_TAIL               0x5F0ECAFE
-/* the chained works have already io submitted */
-#define Z_EROFS_WORK_TAIL_CLOSED        0x5F0EDEAD
-
-
-#define Z_EROFS_WORK_TPTR_TAIL  tagptr_init(erofs_wtptr_t, Z_EROFS_WORK_TAIL)
-#define Z_EROFS_WORK_TPTR_TAIL_CLOSED \
-	tagptr_init(erofs_wtptr_t, Z_EROFS_WORK_TAIL_CLOSED)
-
-#define Z_EROFS_WORK_TPTR_NIL   tagptr_init(erofs_wtptr_t, NULL)
+#ifdef CONFIG_EROFS_FS_ZIP_BIDIRECTIONAL
+#define EROFS_FS_ZIP_CACHE_LVL	(2)
+#elif defined(CONFIG_EROFS_FS_ZIP_UNIDIRECTIONAL)
+#define EROFS_FS_ZIP_CACHE_LVL	(1)
+#else
+#define EROFS_FS_ZIP_CACHE_LVL	(0)
+#endif
 
 /*
  * Structure fields follow one of the following exclusion rules.
@@ -45,11 +36,13 @@
 
 struct z_erofs_vle_work {
 	/* struct z_erofs_vle_work *left, *right; */
-	struct mutex lock;
 
 #ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
+	struct list_head list;
+
 	atomic_t refcount;
 #endif
+	struct mutex lock;
 
 	/* I: decompression offset in page */
 	unsigned short pageofs;
@@ -57,8 +50,6 @@ struct z_erofs_vle_work {
 
 	/* L: queued pages in pagevec[] */
 	unsigned vcnt;
-	/* L: the next owned work */
-	erofs_wtptr_t next;
 
 	union {
 		/* L: pagevec */
@@ -67,54 +58,66 @@ struct z_erofs_vle_work {
 	};
 };
 
-#define Z_EROFS_WORK_FORMAT_PLAIN       0
-#define Z_EROFS_WORK_FORMAT_LZ4         1
-#define Z_EROFS_WORK_FORMAT_MASK        1
+#define Z_EROFS_VLE_WORKGRP_FMT_PLAIN        0
+#define Z_EROFS_VLE_WORKGRP_FMT_LZ4          1
+#define Z_EROFS_VLE_WORKGRP_FMT_MASK         1
 
-struct z_erofs_vle_work_uncached {
-	struct z_erofs_vle_work work;
+typedef struct z_erofs_vle_workgroup *z_erofs_vle_owned_workgrp_t;
 
-	/* multi-usage (both used for decompressed / compressed pages) */
-	struct page *mux[Z_EROFS_CLUSTER_MAX_PAGES];
-};
-
-struct z_erofs_vle_cached_header {
+struct z_erofs_vle_workgroup {
+	struct erofs_workgroup obj;
 	struct z_erofs_vle_work work;
 
-	struct page *managed[Z_EROFS_CLUSTER_MAX_PAGES];
-};
+#if (EROFS_FS_ZIP_CACHE_LVL > 0)
+	/* used for cached compressed pages reclaim serialization */
+	rwlock_t reclaim_lock;
+#endif
 
-struct z_erofs_vle_workgroup {
-	struct erofs_workgroup obj;
-	union {
-		struct z_erofs_vle_work work;
-		struct z_erofs_vle_work_uncached uncached;
-		struct z_erofs_vle_cached_header cached;
-	} u;
+	/* next owned workgroup */
+	z_erofs_vle_owned_workgrp_t next;
 
+	/* compressed pages (including multi-usage pages) */
+	struct page *compressed_pages[Z_EROFS_CLUSTER_MAX_PAGES];
 	unsigned int llen, flags;
 };
 
-#define z_erofs_vle_workgroup_fmt(grp)	\
-	((grp)->flags & Z_EROFS_WORK_FORMAT_MASK)
+/* let's avoid the valid 32-bit kernel addresses */
+
+/* the chained workgroup has't submitted io (still open) */
+#define Z_EROFS_VLE_WORKGRP_TAIL        ((void *)0x5F0ECAFE)
+/* the chained workgroup has already submitted io */
+#define Z_EROFS_VLE_WORKGRP_TAIL_CLOSED ((void *)0x5F0EDEAD)
 
-#define z_erofs_vle_set_work_format(grp, fmt) \
-	((grp)->flags = ((grp)->flags & ~Z_EROFS_WORK_FORMAT_MASK) | (fmt))
+#define Z_EROFS_VLE_WORKGRP_NIL         (NULL)
 
-#define z_erofs_vle_work_uncached(grp, pageofs) (&(grp)->u.uncached.work)
-#define z_erofs_vle_work_uncached_mux(wrk)      \
-	(container_of(wrk, struct z_erofs_vle_work_uncached, work)->mux)
-#define z_erofs_vle_work_cached(grp, pageofs)   (&(grp)->u.cached.work)
-#define z_erofs_vle_cached_managed(grp)         ((grp)->u.cached.managed)
-#define z_erofs_vle_work_workgroup(wrk) \
-	container_of(wrk, struct z_erofs_vle_workgroup, u.work)
+#define z_erofs_vle_workgrp_fmt(grp)	\
+	((grp)->flags & Z_EROFS_VLE_WORKGRP_FMT_MASK)
 
+static inline void z_erofs_vle_set_workgrp_fmt(
+	struct z_erofs_vle_workgroup *grp,
+	unsigned int fmt)
+{
+	grp->flags = fmt | (grp->flags & ~Z_EROFS_VLE_WORKGRP_FMT_MASK);
+}
+
+#ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
+#error multiref decompression is unimplemented yet
+#else
+
+#define z_erofs_vle_grab_primary_work(grp)	(&(grp)->work)
+#define z_erofs_vle_grab_work(grp, pageofs)	(&(grp)->work)
+#define z_erofs_vle_work_workgroup(wrk, primary)	\
+	((primary) ? container_of(wrk,	\
+		struct z_erofs_vle_workgroup, work) : \
+		({ BUG(); (void *)NULL; }))
+
+#endif
 
 #define Z_EROFS_WORKGROUP_SIZE       sizeof(struct z_erofs_vle_workgroup)
 
 struct z_erofs_vle_unzip_io {
 	atomic_t pending_bios;
-	erofs_wtptr_t head;
+	z_erofs_vle_owned_workgrp_t head;
 
 	union {
 		wait_queue_head_t wait;
-- 
1.9.1
