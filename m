From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 25 Jul 2018 10:26:37 +0800
Subject: [RFC PATCH v2 24/25] staging: erofs: introduce cached decompression
In-Reply-To: <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
 <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532485598-63393-25-git-send-email-gaoxiang25@huawei.com>

This patch adds an optional choice which can be
enabled by users in order to cache both incomplete
ends of compressed clusters as a complement to
the in-place decompression in order to boost random
read, but it costs more memory than the in-place
decompression only.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Kconfig     |  38 ++++++
 drivers/staging/erofs/internal.h  |  26 ++++
 drivers/staging/erofs/super.c     |  73 ++++++++++
 drivers/staging/erofs/unzip_vle.c | 274 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/erofs/utils.c     |  17 ++-
 5 files changed, 427 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index b55ce1c..663b755 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -101,3 +101,41 @@ config EROFS_FS_CLUSTER_PAGE_LIMIT
 	  than 2. Otherwise, the image cannot be mounted
 	  correctly on this kernel.
 
+choice
+	prompt "EROFS VLE Data Decompression mode"
+	depends on EROFS_FS_ZIP
+	default EROFS_FS_ZIP_CACHE_BIPOLAR
+	help
+	  EROFS supports three options for VLE decompression.
+	  "In-place Decompression Only" consumes the minimum memory
+	  with lowest random read.
+
+	  "Bipolar Cached Decompression" consumes the maximum memory
+	  with highest random read.
+
+	  If unsure, select "Bipolar Cached Decompression"
+
+config EROFS_FS_ZIP_NO_CACHE
+	bool "In-place Decompression Only"
+	help
+	  Read compressed data into page cache and do in-place
+	  decompression directly.
+
+config EROFS_FS_ZIP_CACHE_UNIPOLAR
+	bool "Unipolar Cached Decompression"
+	help
+	  For each request, it caches the last compressed page
+	  for further reading.
+	  It still decompresses in place for the rest compressed pages.
+
+config EROFS_FS_ZIP_CACHE_BIPOLAR
+	bool "Bipolar Cached Decompression"
+	help
+	  For each request, it caches the both end compressed pages
+	  for further reading.
+	  It still decompresses in place for the rest compressed pages.
+
+	  Recommended for performance priority.
+
+endchoice
+
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 3adec7d..669f93a 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -58,6 +58,18 @@ struct erofs_fault_info {
 };
 #endif
 
+#ifdef CONFIG_EROFS_FS_ZIP_CACHE_BIPOLAR
+#define EROFS_FS_ZIP_CACHE_LVL	(2)
+#elif defined(EROFS_FS_ZIP_CACHE_UNIPOLAR)
+#define EROFS_FS_ZIP_CACHE_LVL	(1)
+#else
+#define EROFS_FS_ZIP_CACHE_LVL	(0)
+#endif
+
+#if (!defined(EROFS_FS_HAS_MANAGED_CACHE) && (EROFS_FS_ZIP_CACHE_LVL > 0))
+#define EROFS_FS_HAS_MANAGED_CACHE
+#endif
+
 /* EROFS_SUPER_MAGIC_V1 to represent the whole file system */
 #define EROFS_SUPER_MAGIC   EROFS_SUPER_MAGIC_V1
 
@@ -82,6 +94,11 @@ struct erofs_sb_info {
 
 	/* the dedicated workstation for compression */
 	struct radix_tree_root workstn_tree;
+
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	struct inode *managed_cache;
+#endif
+
 #endif
 
 	u32 build_time_nsec;
@@ -240,6 +257,15 @@ static inline void erofs_workstation_cleanup_all(struct super_block *sb)
 	erofs_shrink_workstation(EROFS_SB(sb), ~0UL, true);
 }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+#define EROFS_UNALLOCATED_CACHED_PAGE	((void *)0x5F0EF00D)
+
+extern int try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
+	struct erofs_workgroup *egrp);
+extern int try_to_free_cached_page(struct address_space *mapping,
+	struct page *page);
+#endif
+
 #endif
 
 /* we strictly follow PAGE_SIZE and no buffer head yet */
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index f1c1703..14c1dcd 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -256,6 +256,63 @@ static int parse_options(struct super_block *sb, char *options)
 	return 0;
 }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+
+static const struct address_space_operations managed_cache_aops;
+
+static int managed_cache_releasepage(struct page *page, gfp_t gfp_mask)
+{
+	int ret = 1;	/* 0 - busy */
+	struct address_space *const mapping = page->mapping;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(mapping->a_ops != &managed_cache_aops);
+
+	if (PagePrivate(page))
+		ret = try_to_free_cached_page(mapping, page);
+
+	return ret;
+}
+
+static void managed_cache_invalidatepage(struct page *page,
+	unsigned int offset, unsigned int length)
+{
+	const unsigned int stop = length + offset;
+
+	BUG_ON(!PageLocked(page));
+
+	/* Check for overflow */
+	BUG_ON(stop > PAGE_SIZE || stop < length);
+
+	if (offset == 0 && stop == PAGE_SIZE)
+		while (!managed_cache_releasepage(page, GFP_NOFS))
+			cond_resched();
+}
+
+static const struct address_space_operations managed_cache_aops = {
+	.releasepage = managed_cache_releasepage,
+	.invalidatepage = managed_cache_invalidatepage,
+};
+
+struct inode *erofs_init_managed_cache(struct super_block *sb)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (unlikely(inode == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	set_nlink(inode, 1);
+	inode->i_size = OFFSET_MAX;
+
+	inode->i_mapping->a_ops = &managed_cache_aops;
+	mapping_set_gfp_mask(inode->i_mapping,
+			     GFP_NOFS | __GFP_HIGHMEM |
+			     __GFP_MOVABLE |  __GFP_NOFAIL);
+	return inode;
+}
+
+#endif
+
 static int erofs_read_super(struct super_block *sb,
 	const char *dev_name, void *data, int silent)
 {
@@ -307,6 +364,14 @@ static int erofs_read_super(struct super_block *sb,
 	INIT_RADIX_TREE(&sbi->workstn_tree, GFP_ATOMIC);
 #endif
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	sbi->managed_cache = erofs_init_managed_cache(sb);
+	if (IS_ERR(sbi->managed_cache)) {
+		err = PTR_ERR(sbi->managed_cache);
+		goto err_init_managed_cache;
+	}
+#endif
+
 	/* get the root inode */
 	inode = erofs_iget(sb, ROOT_NID(sbi), true);
 	if (IS_ERR(inode)) {
@@ -361,6 +426,10 @@ static int erofs_read_super(struct super_block *sb,
 	if (sb->s_root == NULL)
 		iput(inode);
 err_iget:
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	iput(sbi->managed_cache);
+err_init_managed_cache:
+#endif
 err_parseopt:
 err_sbread:
 	sb->s_fs_info = NULL;
@@ -386,6 +455,10 @@ static void erofs_put_super(struct super_block *sb)
 	infoln("unmounted for %s", sbi->dev_name);
 	__putname(sbi->dev_name);
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	iput(sbi->managed_cache);
+#endif
+
 	mutex_lock(&sbi->umount_mutex);
 
 #ifdef CONFIG_EROFS_FS_ZIP
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 829740f..6508def 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -95,6 +95,111 @@ struct z_erofs_vle_work_builder {
 #define VLE_WORK_BUILDER_INIT()	\
 	{ .work = NULL, .role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+
+static bool grab_managed_cache_pages(struct address_space *mapping,
+				     erofs_blk_t start,
+				     struct page **compressed_pages,
+				     int clusterblks,
+				     bool reserve_allocation)
+{
+	bool noio = true;
+	unsigned int i;
+
+	/* TODO: optimize by introducing find_get_pages_range */
+	for (i = 0; i < clusterblks; ++i) {
+		struct page *page, *found;
+
+		if (READ_ONCE(compressed_pages[i]) != NULL)
+			continue;
+
+		page = found = find_get_page(mapping, start + i);
+		if (found == NULL) {
+			noio = false;
+			if (!reserve_allocation)
+				continue;
+			page = EROFS_UNALLOCATED_CACHED_PAGE;
+		}
+
+		if (NULL == cmpxchg(compressed_pages + i, NULL, page))
+			continue;
+
+		if (found != NULL)
+			put_page(found);
+	}
+	return noio;
+}
+
+/* called by erofs_shrinker to get rid of all compressed_pages */
+int try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
+				 struct erofs_workgroup *egrp)
+{
+	struct z_erofs_vle_workgroup *const grp =
+		container_of(egrp, struct z_erofs_vle_workgroup, obj);
+	struct address_space *const mapping = sbi->managed_cache->i_mapping;
+	const int clusterpages = erofs_clusterpages(sbi);
+	int i;
+
+	/*
+	 * refcount of workgroup is now freezed as 1,
+	 * therefore no need to worry about available decompression users.
+	 */
+	for (i = 0; i < clusterpages; ++i) {
+		struct page *page = grp->compressed_pages[i];
+
+		if (page == NULL || page->mapping != mapping)
+			continue;
+
+		/* block other users from reclaiming or migrating the page */
+		if (!trylock_page(page))
+			return -EBUSY;
+
+		/* barrier is implied in the following 'unlock_page' */
+		WRITE_ONCE(grp->compressed_pages[i], NULL);
+
+		set_page_private(page, 0);
+		ClearPagePrivate(page);
+
+		unlock_page(page);
+		put_page(page);
+	}
+	return 0;
+}
+
+int try_to_free_cached_page(struct address_space *mapping, struct page *page)
+{
+	struct erofs_sb_info *const sbi = EROFS_SB(mapping->host->i_sb);
+	const unsigned int clusterpages = erofs_clusterpages(sbi);
+
+	struct z_erofs_vle_workgroup *grp;
+	int ret = 0;	/* 0 - busy */
+
+	/* prevent the workgroup from being freed */
+	rcu_read_lock();
+	grp = (void *)page_private(page);
+
+	if (erofs_workgroup_try_to_freeze(&grp->obj, 1)) {
+		unsigned int i;
+
+		for (i = 0; i < clusterpages; ++i) {
+			if (grp->compressed_pages[i] == page) {
+				WRITE_ONCE(grp->compressed_pages[i], NULL);
+				ret = 1;
+				break;
+			}
+		}
+		erofs_workgroup_unfreeze(&grp->obj, 1);
+	}
+	rcu_read_unlock();
+
+	if (ret) {
+		ClearPagePrivate(page);
+		put_page(page);
+	}
+	return ret;
+}
+#endif
+
 /* page_type must be Z_EROFS_PAGE_TYPE_EXCLUSIVE */
 static inline bool try_to_reuse_as_compressed_page(
 	struct z_erofs_vle_work_builder *b,
@@ -463,6 +568,9 @@ struct z_erofs_vle_frontend {
 	z_erofs_vle_owned_workgrp_t owned_head;
 
 	bool initial;
+#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
+	erofs_off_t cachedzone_la;
+#endif
 };
 
 #define VLE_FRONTEND_INIT(__i) { \
@@ -489,6 +597,12 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	bool tight = builder_is_followed(builder);
 	struct z_erofs_vle_work *work = builder->work;
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	struct address_space *const mngda = sbi->managed_cache->i_mapping;
+	struct z_erofs_vle_workgroup *grp;
+	bool noio_outoforder;
+#endif
+
 	enum z_erofs_page_type page_type;
 	unsigned cur, end, spiltted, index;
 	int err;
@@ -529,6 +643,21 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	if (unlikely(err))
 		goto err_out;
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	grp = fe->builder.grp;
+
+	/* let's do out-of-order decompression for noio */
+	noio_outoforder = grab_managed_cache_pages(mngda,
+		erofs_blknr(map->m_pa),
+		grp->compressed_pages, erofs_blknr(map->m_plen),
+		/* compressed page caching selection strategy */
+		fe->initial | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
+			map->m_la < fe->cachedzone_la : 0));
+
+	if (noio_outoforder && builder_is_followed(builder))
+		builder->role = Z_EROFS_VLE_WORK_PRIMARY;
+#endif
+
 	tight &= builder_is_followed(builder);
 	work = builder->work;
 hitted:
@@ -607,15 +736,39 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 	const int err = bio->bi_status;
 	unsigned i;
 	struct bio_vec *bvec;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	struct address_space *mngda = NULL;
+#endif
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
+		bool cachemngd = false;
 
 		DBG_BUGON(PageUptodate(page));
 		BUG_ON(page->mapping == NULL);
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (unlikely(mngda == NULL && !z_erofs_is_stagingpage(page))) {
+			struct inode *const inode = page->mapping->host;
+			struct super_block *const sb = inode->i_sb;
+
+			mngda = EROFS_SB(sb)->managed_cache->i_mapping;
+		}
+
+		/*
+		 * If mngda has not gotten, it equals NULL,
+		 * however, page->mapping never be NULL if working properly.
+		 */
+		cachemngd = (page->mapping == mngda);
+#endif
+
 		if (unlikely(err))
 			SetPageError(page);
+		else if (cachemngd)
+			SetPageUptodate(page);
+
+		if (cachemngd)
+			unlock_page(page);
 	}
 
 	z_erofs_vle_unzip_kickoff(bio->bi_private, -1);
@@ -630,6 +783,9 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	struct list_head *page_pool)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(sb);
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	struct address_space *const mngda = sbi->managed_cache->i_mapping;
+#endif
 	const unsigned clusterpages = erofs_clusterpages(sbi);
 
 	struct z_erofs_pagevec_ctor ctor;
@@ -727,6 +883,13 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 
 		if (z_erofs_is_stagingpage(page))
 			continue;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		else if (page->mapping == mngda) {
+			BUG_ON(PageLocked(page));
+			BUG_ON(!PageUptodate(page));
+			continue;
+		}
+#endif
 
 		/* only non-head page could be reused as a compressed page */
 		pagenr = z_erofs_onlinepage_index(page);
@@ -804,6 +967,10 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	for (i = 0; i < clusterpages; ++i) {
 		page = compressed_pages[i];
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (page->mapping == mngda)
+			continue;
+#endif
 		/* recycle all individual staging pages */
 		(void)z_erofs_gather_if_stagingpage(page_pool, page);
 
@@ -898,7 +1065,31 @@ static void z_erofs_vle_unzip_wq(struct work_struct *work)
 	return io;
 }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+/* true - unlocked (noio), false - locked (need submit io) */
+static inline bool recover_managed_page(struct z_erofs_vle_workgroup *grp,
+					struct page *page)
+{
+	wait_on_page_locked(page);
+	if (PagePrivate(page) && PageUptodate(page))
+		return true;
+
+	lock_page(page);
+	if (unlikely(!PagePrivate(page))) {
+		set_page_private(page, (unsigned long)grp);
+		SetPagePrivate(page);
+	}
+	if (unlikely(PageUptodate(page))) {
+		unlock_page(page);
+		return true;
+	}
+	return false;
+}
+
+#define __FSIO_1 1
+#else
 #define __FSIO_1 0
+#endif
 
 static bool z_erofs_vle_submit_all(struct super_block *sb,
 				   z_erofs_vle_owned_workgrp_t owned_head,
@@ -909,6 +1100,10 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	struct erofs_sb_info *const sbi = EROFS_SB(sb);
 	const unsigned clusterpages = erofs_clusterpages(sbi);
 	const gfp_t gfp = GFP_NOFS;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	struct address_space *const mngda = sbi->managed_cache->i_mapping;
+	struct z_erofs_vle_workgroup *lstgrp_noio = NULL, *lstgrp_io = NULL;
+#endif
 	struct z_erofs_vle_unzip_io *ios[1 + __FSIO_1];
 	struct bio *bio;
 	tagptr1_t bi_private;
@@ -924,6 +1119,10 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	 * force_fg == 1, (io, fg_io[0]) no io, (io, fg_io[1]) need submit io
 	 * force_fg == 0, (io, fg_io[0]) no io; (io[1], bg_io) need submit io
 	 */
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	ios[0] = prepare_io_handler(sb, fg_io + 0, false);
+#endif
+
 	if (force_fg) {
 		ios[__FSIO_1] = prepare_io_handler(sb, fg_io + __FSIO_1, false);
 		bi_private = tagptr_fold(tagptr1_t, ios[__FSIO_1], 0);
@@ -944,6 +1143,10 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		struct page **compressed_pages, *oldpage, *page;
 		pgoff_t first_index;
 		unsigned i = 0;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		unsigned int noio = 0;
+		bool cachemngd;
+#endif
 		int err;
 
 		/* no possible 'owned_head' equals the following */
@@ -964,15 +1167,40 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		/* fulfill all compressed pages */
 		oldpage = page = READ_ONCE(compressed_pages[i]);
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		cachemngd = false;
+
+		if (page == EROFS_UNALLOCATED_CACHED_PAGE) {
+			cachemngd = true;
+			goto do_allocpage;
+		} else if (page != NULL) {
+			if (page->mapping != mngda)
+				BUG_ON(PageUptodate(page));
+			else if (recover_managed_page(grp, page)) {
+				/* page is uptodate, skip io submission */
+				force_submit = true;
+				++noio;
+				goto skippage;
+			}
+		} else {
+do_allocpage:
+#else
 		if (page != NULL)
 			BUG_ON(PageUptodate(page));
 		else {
+#endif
 			page = __stagingpage_alloc(pagepool, gfp);
 
 			if (oldpage != cmpxchg(compressed_pages + i,
 				oldpage, page)) {
 				list_add(&page->lru, pagepool);
 				goto repeat;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+			} else if (cachemngd && !add_to_page_cache_lru(page,
+				mngda, first_index + i, gfp)) {
+				set_page_private(page, (unsigned long)grp);
+				SetPagePrivate(page);
+#endif
 			}
 		}
 
@@ -996,14 +1224,51 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 		force_submit = false;
 		last_index = first_index + i;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+skippage:
+#endif
 		if (++i < clusterpages)
 			goto repeat;
+
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (noio < clusterpages) {
+			lstgrp_io = grp;
+		} else {
+			z_erofs_vle_owned_workgrp_t iogrp_next =
+				owned_head == Z_EROFS_VLE_WORKGRP_TAIL ?
+				Z_EROFS_VLE_WORKGRP_TAIL_CLOSED :
+				owned_head;
+
+			if (lstgrp_io == NULL)
+				ios[1]->head = iogrp_next;
+			else
+				WRITE_ONCE(lstgrp_io->next, iogrp_next);
+
+			if (lstgrp_noio == NULL)
+				ios[0]->head = grp;
+			else
+				WRITE_ONCE(lstgrp_noio->next, grp);
+
+			lstgrp_noio = grp;
+		}
+#endif
 	} while (owned_head != Z_EROFS_VLE_WORKGRP_TAIL);
 
 	if (bio != NULL)
 		__submit_bio(bio, REQ_OP_READ, 0);
 
+#ifndef EROFS_FS_HAS_MANAGED_CACHE
 	BUG_ON(!nr_bios);
+#else
+	if (lstgrp_noio != NULL)
+		WRITE_ONCE(lstgrp_noio->next, Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+
+	if (!force_fg && !nr_bios) {
+		kvfree(container_of(ios[1],
+			struct z_erofs_vle_unzip_io_sb, io));
+		return true;
+	}
+#endif
 
 	z_erofs_vle_unzip_kickoff(tagptr_cast_ptr(bi_private), nr_bios);
 	return true;
@@ -1019,6 +1284,9 @@ static void z_erofs_submit_and_unzip(struct z_erofs_vle_frontend *f,
 	if (!z_erofs_vle_submit_all(sb, f->owned_head, pagepool, io, force_fg))
 		return;
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	z_erofs_vle_unzip_all(sb, &io[0], pagepool);
+#endif
 	if (!force_fg)
 		return;
 
@@ -1038,6 +1306,9 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	int err;
 	LIST_HEAD(pagepool);
 
+#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
+	f.cachedzone_la = page->index << PAGE_SHIFT;
+#endif
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_vle_work_iter_end(&f.builder);
 
@@ -1068,6 +1339,9 @@ static inline int __z_erofs_vle_normalaccess_readpages(
 	struct page *head = NULL;
 	LIST_HEAD(pagepool);
 
+#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
+	f.cachedzone_la = lru_to_page(pages)->index << PAGE_SHIFT;
+#endif
 	for (; nr_pages; --nr_pages) {
 		struct page *page = lru_to_page(pages);
 
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 6530035..ee70bb9 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -143,13 +143,28 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 		if (cleanup)
 			BUG_ON(cnt != 1);
 
+#ifndef EROFS_FS_HAS_MANAGED_CACHE
 		else if (cnt > 1)
+#else
+		if (!erofs_workgroup_try_to_freeze(grp, 1))
+#endif
 			continue;
 
 		if (radix_tree_delete(&sbi->workstn_tree,
-			grp->index) != grp)
+			grp->index) != grp) {
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+skip:
+			erofs_workgroup_unfreeze(grp, 1);
+#endif
 			continue;
+		}
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (try_to_free_all_cached_pages(sbi, grp))
+			goto skip;
+
+		erofs_workgroup_unfreeze(grp, 1);
+#endif
 		/* (rarely) grabbed again when freeing */
 		erofs_workgroup_put(grp);
 
-- 
1.9.1
