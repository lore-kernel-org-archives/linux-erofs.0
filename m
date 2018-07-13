From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 13 Jul 2018 21:17:09 +0800
Subject: [PATCH 2/2] temp commit 2
In-Reply-To: <1531487829-84202-1-git-send-email-gaoxiang25@huawei.com>
References: <1531163839-29830-11-git-send-email-gaoxiang25@huawei.com>
 <1531487829-84202-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1531487829-84202-2-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/internal.h  |  61 ++++++++++++++++
 fs/erofs/super.c     |  79 ++++++++++++++++++++-
 fs/erofs/unzip_vle.c | 197 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/erofs/unzip_vle.h |   8 ---
 4 files changed, 323 insertions(+), 22 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 8d7b6ab..edba0da 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -59,6 +59,22 @@ struct erofs_fault_info {
 };
 #endif
 
+#ifdef CONFIG_EROFS_FS_ZIP_BIDIRECTIONAL
+#define EROFS_FS_ZIP_CACHE_LVL	(2)
+#elif defined(CONFIG_EROFS_FS_ZIP_UNIDIRECTIONAL)
+#define EROFS_FS_ZIP_CACHE_LVL	(1)
+#else
+#define EROFS_FS_ZIP_CACHE_LVL	(0)
+#endif
+
+#if (!defined(EROFS_FS_HAS_MANAGED_CACHE) && (EROFS_FS_ZIP_CACHE_LVL > 0))
+#define EROFS_FS_HAS_MANAGED_CACHE
+
+#define EROFS_UNALLOCATED_CACHED_PAGE	((void *)0x5F0EF00D)
+
+extern int try_to_free_cached_page(struct address_space *, struct page *);
+#endif
+
 /* EROFS_SUPER_MAGIC_V1 to represent the whole file system */
 #define EROFS_SUPER_MAGIC   EROFS_SUPER_MAGIC_V1
 
@@ -88,6 +104,11 @@ struct erofs_sb_info {
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
@@ -176,13 +197,53 @@ struct erofs_workgroup {
 	atomic_t refcount;
 };
 
+#define EROFS_LOCKED_MAGIC     (INT_MIN | 0xE0F510CCL)
+
+static inline bool erofs_workgroup_try_to_freeze(
+	struct erofs_workgroup *grp, int v)
+{
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+	if (v != atomic_cmpxchg(&grp->refcount,
+		v, EROFS_LOCKED_MAGIC))
+		return false;
+	preempt_disable();
+#else
+	preempt_disable();
+	if (atomic_read(&grp->refcount) != v) {
+		preempt_enable();
+		return false;
+	}
+#endif
+	return true;
+}
+
+static inline void erofs_workgroup_unfreeze(
+	struct erofs_workgroup *grp, int v)
+{
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+	atomic_set(&grp->refcount, v);
+#endif
+	preempt_enable();
+}
+
 static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
 {
+	const int locked = (int)EROFS_LOCKED_MAGIC;
 	int o;
 
 repeat:
 	o = atomic_read(&grp->refcount);
 
+	/* spin if it is temporarily locked at the reclaim path */
+	if (unlikely(o == locked)) {
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+		do
+			cpu_relax();
+		while (atomic_read(&grp->refcount) == locked);
+#endif
+		goto repeat;
+	}
+
 	if (unlikely(o <= 0))
 		return -1;
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 546a308..fc4d750 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -245,6 +245,67 @@ static int parse_options(struct super_block *sb, char *options)
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
+	                     __GFP_MOVABLE |  __GFP_NOFAIL
+#if defined(CONFIG_CMA) && defined(___GFP_CMA)
+	                     | ___GFP_CMA
+#endif
+	                    );
+	return inode;
+}
+
+#endif
+
 static int erofs_read_super(struct super_block *sb,
 	const char *dev_name, void *data, int silent)
 {
@@ -299,11 +360,19 @@ static int erofs_read_super(struct super_block *sb,
 #endif
 #endif
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	sbi->managed_cache = erofs_init_managed_cache(sb);
+	if (sbi->managed_cache == NULL) {
+		err = -ENOMEM;
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
@@ -346,6 +415,10 @@ static int erofs_read_super(struct super_block *sb,
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
@@ -368,6 +441,10 @@ static void erofs_put_super(struct super_block *sb)
 	infoln("unmounted for %s", sbi->dev_name);
 	__putname(sbi->dev_name);
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	iput(sbi->managed_cache);
+#endif
+
 	mutex_lock(&sbi->umount_mutex);
 
 #ifdef CONFIG_EROFS_FS_ZIP
diff --git a/fs/erofs/unzip_vle.c b/fs/erofs/unzip_vle.c
index 7ca1d5d..0920851 100644
--- a/fs/erofs/unzip_vle.c
+++ b/fs/erofs/unzip_vle.c
@@ -77,6 +77,107 @@ struct z_erofs_vle_work_handler {
 #define VLE_WORK_HANDLER_INIT()	\
 	{ .curr = NULL, .role = Z_EROFS_VLE_WORK_PRIMARY_OWNER }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+int try_to_free_cached_page(struct address_space *mapping, struct page *page)
+{
+	struct inode *inode = mapping->host;
+	unsigned clusterpages = erofs_clusterpages(EROFS_SB(inode->i_sb));
+	struct z_erofs_vle_workgroup *grp = (void *)page_private(page);
+	int i, ret = 0;
+
+	/* prevent the workgroup from being freed */
+	rcu_read_lock();
+
+	if (!erofs_workgroup_try_to_freeze(&grp->obj, 1))
+		goto out;
+
+	for(i = 0; i < clusterpages; ++i) {
+		if (grp->compressed_pages[i] == page) {
+			WRITE_ONCE(grp->compressed_pages[i], NULL);
+			ret = 1;
+			break;
+		}
+	}
+	erofs_workgroup_unfreeze(&grp->obj, 1);
+out:
+	rcu_read_unlock();
+
+	if (ret) {
+		ClearPagePrivate(page);
+		put_page(page);
+	}
+	return ret;
+}
+
+static inline void grab_compressed_pages_in_managed_cache(
+	struct super_block *sb,
+	pgoff_t start,
+	struct page **compressed_pages,
+	int clusterpages, bool alloc_reserve)
+{
+	pgoff_t cur;
+#if 0
+	struct page *pages[clusterpages];
+#endif
+	unsigned i, j, found;
+
+	for (i = 0; i < clusterpages; ++i) {
+		if (READ_ONCE(compressed_pages[i]) == NULL) {
+			cur = (start += i);
+			compressed_pages += i;
+			clusterpages -= i;		
+			goto hitted;
+		}
+	}
+
+	return;
+hitted:
+#if 0
+	found = find_get_pages_range(EROFS_SB(sb)->managed_cache->i_mapping,
+		&cur, start + clusterpages, clusterpages, pages);
+#endif
+
+	i = 0;
+	for (j = 0; i < clusterpages && j < found; ++i) {
+		struct page *page;
+
+#if 0
+		cur = pages[j]->index - start;
+		if (cur != i) {
+			if (!alloc_reserve)
+				continue;
+			page = EROFS_UNALLOCATED_CACHED_PAGE;
+		} else
+			page = pages[j++];
+#else
+		page = find_get_page(EROFS_SB(sb)->managed_cache->i_mapping,
+			start + j);
+		if (page == NULL) {
+			if (!alloc_reserve)
+				continue;
+			page = EROFS_UNALLOCATED_CACHED_PAGE;
+		}
+#endif
+
+		if (cmpxchg(compressed_pages + cur, NULL, page) == NULL)
+			continue;
+
+		if (cur == i)
+			put_page(page);
+	}
+
+	if (!alloc_reserve)
+		return;
+
+	while (i < clusterpages) {
+		cmpxchg(compressed_pages + i, NULL,
+			EROFS_UNALLOCATED_CACHED_PAGE);
+		++i;
+	}
+}
+
+#endif
+
 /* page_type must be Z_EROFS_PAGE_TYPE_EXCLUSIVE */
 static inline bool try_to_reuse_as_compressed_page(
 	struct z_erofs_vle_work_handler *w,
@@ -308,6 +409,13 @@ static inline void __update_workgrp_llen(struct z_erofs_vle_workgroup *grp,
 	}
 }
 
+#define handler_is_owner(w) ((w)->role >= Z_EROFS_VLE_WORK_PRIMARY_OWNER)
+
+struct z_erofs_vle_frontend {
+	bool initial;
+	erofs_off_t cachedzone_la;
+};
+
 static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_handler *w,
 				       struct super_block *sb,
 				       struct erofs_map_blocks *map,
@@ -386,8 +494,6 @@ void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
 	erofs_workgroup_put(&grp->obj);
 }
 
-#define handler_is_owner(w) ((w)->role >= Z_EROFS_VLE_WORK_PRIMARY_OWNER)
-
 static inline void
 z_erofs_vle_work_iter_end(struct z_erofs_vle_work_handler *w)
 {
@@ -408,7 +514,8 @@ void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
 	w->curr = NULL;
 }
 
-static int z_erofs_do_read_page(struct page *page,
+static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
+				struct page *page,
 				struct z_erofs_vle_work_handler *h,
 				struct erofs_map_blocks_iter *m,
 				z_erofs_vle_owned_workgrp_t *owned_head,
@@ -458,6 +565,14 @@ static int z_erofs_do_read_page(struct page *page,
 	if (unlikely(err))
 		goto err_out;
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	grab_compressed_pages_in_managed_cache(sb,
+		m->map.m_pa / EROFS_BLKSIZ, h->compressed_pages,
+		h->compressed_deficit, fe->initial || m->map.m_la <= fe->cachedzone_la);
+
+	fe->initial = false;
+#endif
+
 	owned &= handler_is_owner(h);
 	work = h->curr;
 hitted:
@@ -542,6 +657,7 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 {
 	unsigned i;
 	struct bio_vec *bvec;
+
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 13, 0))
 	const int err = bio->bi_status;
 #elif (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 3, 0))
@@ -550,16 +666,25 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
+		bool cachedpage = false;
 
 		DBG_BUGON(PageUptodate(page));
+
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
-
-		/* FIXME: the following snippets are for cached work */
-		else if (0)
+		else if (cachedpage)
 			SetPageUptodate(page);
 
-		if (0)
+		if (cachedpage)
 			unlock_page(page);
 	}
 
@@ -574,7 +699,8 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	struct z_erofs_vle_workgroup *grp,
 	struct list_head *page_pool)
 {
-	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	unsigned clusterpages = erofs_clusterpages(sbi);
 	struct z_erofs_pagevec_ctor ctor;
 	unsigned nr_pages;
 #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
@@ -666,6 +792,10 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 
 		if (page->mapping == NULL)
 			continue;
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (page->mapping->host == sbi->managed_cache)
+			continue;
+#endif
 
 		pagenr = z_erofs_onlinepage_index(page);
 
@@ -747,6 +877,10 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		if (page->mapping == NULL)
 			list_add(&page->lru, page_pool);
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		else if (page->mapping->host == sbi->managed_cache)
+			continue;
+#endif
 		WRITE_ONCE(compressed_pages[i], NULL);
 	}
 
@@ -841,7 +975,8 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 				   struct z_erofs_vle_unzip_io *io)
 {
 	struct bio *bio = NULL;
-	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	unsigned clusterpages = erofs_clusterpages(sbi);
 	pgoff_t last_page;
 	bool sync;
 	unsigned bios_submitted;
@@ -878,15 +1013,34 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		/* fulfill all compressed pages */
 		for (i = 0; i < clusterpages; ++i) {
 			struct page *page;
+			struct page *old = READ_ONCE(compressed_pages[i]);
+			bool cached = (old == EROFS_UNALLOCATED_CACHED_PAGE);
 
-			if (READ_ONCE(compressed_pages[i]) != NULL)
+			if (old != NULL && !cached)
 				continue;
 
 			page = erofs_allocpage(page_pool, GFP_KERNEL);
 			page->mapping = NULL;
+			if (cached) {
+				if (add_to_page_cache_lru(page,
+					sbi->managed_cache->i_mapping,
+					grp->obj.index + i, GFP_KERNEL))
+					cached = false;
+				else {
+					if (cmpxchg(compressed_pages + i,
+						old, page) == old) {
+						set_page_private(page, (unsigned long)grp);
+						SetPagePrivate(page);
+					} else {
+						put_page(page);
+					}
+					continue;
+				}
+			}
 
-			if (cmpxchg(compressed_pages + i, NULL, page) != NULL)
+			if (cmpxchg(compressed_pages + i, old, page) != old) {
 				list_add(&page->lru, page_pool);
+			}
 		}
 
 		current_page = grp->obj.index;
@@ -898,6 +1052,19 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 			bio = NULL;
 		}
 repeat:
+		if (compressed_pages[i]->mapping == sbi->managed_cache->i_mapping) {
+			if (PageUptodate(compressed_pages[i])) {
+				if (++i < clusterpages) {
+					if (bio != NULL)
+						goto submit_bio_retry;
+					else
+						goto repeat;
+				}
+				continue;
+			}
+			BUG_ON(!PageLocked(compressed_pages[i]));
+		}
+
 		if (bio == NULL) {
 			bio = prepare_bio(sb, current_page,
 				BIO_MAX_PAGES, z_erofs_vle_read_endio);
@@ -927,6 +1094,8 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 static int z_erofs_vle_normalaccess_readpage(struct file *file,
                                              struct page *page)
 {
+	struct z_erofs_vle_frontend fe = { .initial = true,
+		.cachedzone_la = page->index << PAGE_SHIFT };
 	struct erofs_map_blocks_iter m_iter = {
 		.map = { .m_llen = 0, .m_plen = 0 },
 		.mpage = NULL
@@ -937,7 +1106,7 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	struct z_erofs_vle_unzip_io io;
 	LIST_HEAD(pagepool);
 
-	int err = z_erofs_do_read_page(page,
+	int err = z_erofs_do_read_page(&fe, page,
 		&h, &m_iter, &owned_head, &pagepool);
 
 	z_erofs_vle_work_iter_end(&h);
@@ -971,6 +1140,8 @@ static inline int __z_erofs_vle_normalaccess_readpages(
 	struct address_space *mapping,
 	struct list_head *pages, unsigned nr_pages, bool sync)
 {
+	struct z_erofs_vle_frontend fe = { .initial = true,
+		.cachedzone_la = lru_to_page(pages)->index << PAGE_SHIFT };
 	struct erofs_map_blocks_iter m_iter = {
 		.map = { .m_llen = 0, .m_plen = 0 },
 		.mpage = NULL
@@ -1006,7 +1177,7 @@ static inline int __z_erofs_vle_normalaccess_readpages(
 		/* traversal in reverse order */
 		head = (void *)page_private(page);
 
-		err = z_erofs_do_read_page(page,
+		err = z_erofs_do_read_page(&fe, page,
 			&h, &m_iter, &owned_head, &pagepool);
 		if (err) {
 			struct erofs_vnode *vi = EROFS_V(inode);
diff --git a/fs/erofs/unzip_vle.h b/fs/erofs/unzip_vle.h
index 2a446f9..91e4a80 100644
--- a/fs/erofs/unzip_vle.h
+++ b/fs/erofs/unzip_vle.h
@@ -16,14 +16,6 @@
 #include "internal.h"
 #include "unzip_pagevec.h"
 
-#ifdef CONFIG_EROFS_FS_ZIP_BIDIRECTIONAL
-#define EROFS_FS_ZIP_CACHE_LVL	(2)
-#elif defined(CONFIG_EROFS_FS_ZIP_UNIDIRECTIONAL)
-#define EROFS_FS_ZIP_CACHE_LVL	(1)
-#else
-#define EROFS_FS_ZIP_CACHE_LVL	(0)
-#endif
-
 /*
  * Structure fields follow one of the following exclusion rules.
  *
-- 
1.9.1
