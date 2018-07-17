From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 17 Jul 2018 22:18:57 +0800
Subject: [RFC PATCH v1 11/11] erofs: introduce cached decompression
In-Reply-To: <1531837137-129079-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1531837137-129079-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1531837137-129079-12-git-send-email-gaoxiang25@huawei.com>

This patch adds the cached decompression as a complement
to the in-place decompression in order to boost random read.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/Kconfig     |  38 ++++++++
 fs/erofs/internal.h  |  25 +++++
 fs/erofs/super.c     |  75 ++++++++++++++-
 fs/erofs/unzip_vle.c | 255 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/utils.c     |  17 +++-
 5 files changed, 408 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 00e811c..d08c019 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -99,3 +99,41 @@ config EROFS_FS_CLUSTER_PAGE_LIMIT
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
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 8dd674f..b7e01b7 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -59,6 +59,18 @@ struct erofs_fault_info {
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
 
@@ -88,6 +100,11 @@ struct erofs_sb_info {
 		spinlock_t lock;
 #endif
 	} workstn;
+
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	struct inode *managed_cache;
+#endif
+
 #endif
 
 	u32 build_time_nsec;
@@ -251,6 +268,14 @@ static inline void erofs_workstation_cleanup_all(struct super_block *sb)
 	erofs_shrink_workstation(EROFS_SB(sb), ~0UL, true);
 }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+#define EROFS_UNALLOCATED_CACHED_PAGE	((void *)0x5F0EF00D)
+
+extern int try_to_free_cached_page(struct address_space *, struct page *);
+extern int try_to_free_all_cached_pages(struct erofs_sb_info *,
+	struct erofs_workgroup *);
+#endif
+
 #endif
 
 /* we strictly follow PAGE_SIZE and no buffer head */
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 546a308..9414030 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -245,6 +245,63 @@ static int parse_options(struct super_block *sb, char *options)
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
+		while(!managed_cache_releasepage(page, GFP_NOFS))
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
+	                     GFP_NOFS | __GFP_HIGHMEM |
+	                     __GFP_MOVABLE |  __GFP_NOFAIL);
+	return inode;
+}
+
+#endif
+
 static int erofs_read_super(struct super_block *sb,
 	const char *dev_name, void *data, int silent)
 {
@@ -299,11 +356,19 @@ static int erofs_read_super(struct super_block *sb,
 #endif
 #endif
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	sbi->managed_cache = erofs_init_managed_cache(sb);
+	if (IS_ERR(sbi->managed_cache)) {
+		err = PTR_ERR(sbi->managed_cache);
+		goto err_sbi;
+	}
+#endif
+
 	/* get the root inode */
 	inode = erofs_iget(sb, ROOT_NID(sbi), true);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
-		goto err_sbi;
+		goto iget_err;
 	}
 
 	if (!S_ISDIR(inode->i_mode)) {
@@ -346,6 +411,10 @@ static int erofs_read_super(struct super_block *sb,
 err_iput:
 	if (sb->s_root == NULL)
 		iput(inode);
+iget_err:
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	iput(sbi->managed_cache);
+#endif
 err_sbi:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
@@ -368,6 +437,10 @@ static void erofs_put_super(struct super_block *sb)
 	infoln("unmounted for %s", sbi->dev_name);
 	__putname(sbi->dev_name);
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	iput(sbi->managed_cache);
+#endif
+
 	mutex_lock(&sbi->umount_mutex);
 
 #ifdef CONFIG_EROFS_FS_ZIP
diff --git a/fs/erofs/unzip_vle.c b/fs/erofs/unzip_vle.c
index 4966a9d..689ed3e 100644
--- a/fs/erofs/unzip_vle.c
+++ b/fs/erofs/unzip_vle.c
@@ -78,6 +78,107 @@ struct z_erofs_vle_work_builder {
 #define VLE_WORK_BUILDER_INIT()	\
 	{ .curr = NULL, .role = Z_EROFS_VLE_WORK_PRIMARY_OWNER }
 
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
+                        continue;
+
+		if (found != NULL)
+			put_page(found);
+	}
+	return noio;
+}
+
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
+		/* block from reclaiming or migrating the page */
+		if (!trylock_page(page))
+			return -EBUSY;
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
+	const unsigned clusterpages = erofs_clusterpages(sbi);
+
+	struct z_erofs_vle_workgroup *grp;
+	int ret = 0;	/* 0 - busy */
+
+	/* prevent the workgroup from being freed */
+	rcu_read_lock();
+	grp = (void *)page_private(page);
+
+	if (erofs_workgroup_try_to_freeze(&grp->obj, 1)) {
+		unsigned i;
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
@@ -415,6 +516,9 @@ struct z_erofs_vle_frontend {
 	z_erofs_vle_owned_workgrp_t owned_head;
 
 	bool initial;
+#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
+	erofs_off_t cachedzone_la;
+#endif
 };
 
 #define VLE_FRONTEND_INIT(__i) { \
@@ -480,6 +584,28 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	if (unlikely(err))
 		goto err_out;
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	else {
+		struct z_erofs_vle_workgroup *grp = fe->builder.grp;
+		struct address_space *mapping = sbi->managed_cache->i_mapping;
+
+		/* let's do out of order decompression for noio */
+		bool noio_outoforder = grab_managed_cache_pages(mapping,
+			erofs_blknr(map->m_pa),
+			grp->compressed_pages, erofs_blknr(map->m_plen),
+			fe->initial
+#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
+			| (map->m_la <= fe->cachedzone_la)
+#endif
+		);
+
+		if (noio_outoforder && builder_is_owner(builder)) {
+			__erofs_workgroup_get(&grp->obj);
+			builder->role = Z_EROFS_VLE_WORK_PRIMARY;
+		}
+	}
+#endif
+
 	owned &= builder_is_owner(builder);
 	work = builder->curr;
 hitted:
@@ -577,6 +703,15 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 
 		DBG_BUGON(PageUptodate(page));
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (page->mapping != NULL) {
+			struct inode *inode = page->mapping->host;
+
+			cachedpage = (inode ==
+				EROFS_SB(inode->i_sb)->managed_cache);
+		}
+#endif
+
 		if (unlikely(err))
 			SetPageError(page);
 		else if (cachedpage)
@@ -690,6 +825,13 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 
 		if (page->mapping == NULL)
 			continue;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (page->mapping->host == sbi->managed_cache) {
+			BUG_ON(PageLocked(page));
+			BUG_ON(!PageUptodate(page));
+			continue;
+		}
+#endif
 
 		pagenr = z_erofs_onlinepage_index(page);
 
@@ -771,6 +913,10 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		if (page->mapping == NULL)
 			list_add(&page->lru, page_pool);
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		else if (page->mapping->host == sbi->managed_cache)
+			continue;
+#endif
 		WRITE_ONCE(compressed_pages[i], NULL);
 	}
 
@@ -862,7 +1008,32 @@ static void z_erofs_vle_unzip_wq(struct work_struct *work)
 	return io;
 }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+/* true - unlocked (noio), false - locked (need submit io) */
+static inline bool recover_managed_page(
+	struct z_erofs_vle_workgroup *grp,
+	struct page *page)
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
@@ -873,6 +1044,11 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	struct erofs_sb_info *const sbi = EROFS_SB(sb);
 	const unsigned clusterpages = erofs_clusterpages(sbi);
 	const gfp_t gfp = GFP_NOFS;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	struct address_space *const managed_cache_mapping =
+		sbi->managed_cache->i_mapping;
+	struct z_erofs_vle_workgroup *lstgrp_noio = NULL, *lstgrp_io = NULL;
+#endif
 	struct z_erofs_vle_unzip_io *ios[1 + __FSIO_1];
 	struct bio *bio;
 	tagptr1_t bi_private;
@@ -887,6 +1063,10 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
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
@@ -907,6 +1087,10 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		struct page **compressed_pages, *oldpage, *page;
 		pgoff_t first_index;
 		unsigned i = 0;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		unsigned noio = 0;
+		bool cachemanaged;
+#endif
 		int err;
 
 		/* no possible 'owned_head' equals the following */
@@ -926,9 +1110,28 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		/* fulfill all compressed pages */
 		oldpage = page = READ_ONCE(compressed_pages[i]);
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		cachemanaged = false;
+
+		if (page == EROFS_UNALLOCATED_CACHED_PAGE) {
+			cachemanaged = true;
+			goto do_allocpage;
+		} else if (page != NULL) {
+			if (page->mapping != managed_cache_mapping)
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
 			page = erofs_allocpage(pagepool, gfp);
 			page->mapping = NULL;
 
@@ -936,6 +1139,12 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 				oldpage, page)) {
 				list_add(&page->lru, pagepool);
 				goto repeat;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+			} else if (cachemanaged && !add_to_page_cache_lru(page,
+				managed_cache_mapping, first_index + i, gfp)) {
+				set_page_private(page, (unsigned long)grp);
+				SetPagePrivate(page);
+#endif
 			}
 		}
 
@@ -959,14 +1168,51 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 		force_submit = false;
 		last_index = first_index + i;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+skippage:
+#endif
 		if (++i < clusterpages)
 			goto repeat;
+
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (noio < clusterpages)
+			lstgrp_io = grp;
+		else {
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
@@ -982,6 +1228,9 @@ static void z_erofs_submit_and_unzip(struct z_erofs_vle_frontend *f,
 	if (!z_erofs_vle_submit_all(sb, f->owned_head, pagepool, io, force_fg))
 		return;
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	z_erofs_vle_unzip_all(sb, &io[0], pagepool);
+#endif
 	if (!force_fg)
 		return;
 
@@ -1001,6 +1250,9 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	int err;
 	LIST_HEAD(pagepool);
 
+#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
+	f.cachedzone_la = page->index << PAGE_SHIFT;
+#endif
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_vle_work_iter_end(&f.builder);
 
@@ -1031,6 +1283,9 @@ static inline int __z_erofs_vle_normalaccess_readpages(
 	struct page *head = NULL;
 	LIST_HEAD(pagepool);
 
+#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
+	f.cachedzone_la = lru_to_page(pages)->index << PAGE_SHIFT;
+#endif
 	for (; nr_pages; --nr_pages) {
 		struct page *page = lru_to_page(pages);
 
diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index dd1ce5f..b669ca3 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -143,13 +143,28 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 		if (cleanup)
 			BUG_ON(cnt != 1);
 
+#ifndef EROFS_FS_HAS_MANAGED_CACHE
 		else if (cnt > 1)
+#else
+		if (!erofs_workgroup_try_to_freeze(grp, 1))
+#endif
 			continue;
 
 		if (radix_tree_delete(&sbi->workstn.tree,
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
