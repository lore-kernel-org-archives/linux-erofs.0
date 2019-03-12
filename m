From: julianmr97@gmail.com (Julian Merida)
Date: Tue, 12 Mar 2019 01:18:27 -0300
Subject: [PATCH] staging: erofs: fix parenthesis alignment
Message-ID: <20190312041827.6176-1-julianmr97@gmail.com>

Fix all checkpatch issues: "CHECK: Alignment should match open parenthesis"

Signed-off-by: Julian Merida <julianmr97 at gmail.com>
---
 drivers/staging/erofs/inode.c     | 13 +++----
 drivers/staging/erofs/namei.c     |  3 +-
 drivers/staging/erofs/super.c     | 26 +++++++-------
 drivers/staging/erofs/unzip_vle.c | 57 ++++++++++++++++---------------
 drivers/staging/erofs/utils.c     |  2 +-
 drivers/staging/erofs/xattr.c     | 35 ++++++++++---------
 6 files changed, 73 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 924b8dfc7a8f..4ab03a533cc1 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -25,7 +25,7 @@ static int read_inode(struct inode *inode, void *data)
 
 	if (unlikely(vi->data_mapping_mode >= EROFS_INODE_LAYOUT_MAX)) {
 		errln("unknown data mapping mode %u of nid %llu",
-			vi->data_mapping_mode, vi->nid);
+		      vi->data_mapping_mode, vi->nid);
 		DBG_BUGON(1);
 		return -EIO;
 	}
@@ -38,7 +38,7 @@ static int read_inode(struct inode *inode, void *data)
 
 		inode->i_mode = le16_to_cpu(v2->i_mode);
 		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-						S_ISLNK(inode->i_mode)) {
+		    S_ISLNK(inode->i_mode)) {
 			vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
 		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 			inode->i_rdev =
@@ -68,7 +68,7 @@ static int read_inode(struct inode *inode, void *data)
 
 		inode->i_mode = le16_to_cpu(v1->i_mode);
 		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-						S_ISLNK(inode->i_mode)) {
+		    S_ISLNK(inode->i_mode)) {
 			vi->raw_blkaddr = le32_to_cpu(v1->i_u.raw_blkaddr);
 		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 			inode->i_rdev =
@@ -92,7 +92,7 @@ static int read_inode(struct inode *inode, void *data)
 		inode->i_size = le32_to_cpu(v1->i_size);
 	} else {
 		errln("unsupported on-disk inode version %u of nid %llu",
-			__inode_version(advise), vi->nid);
+		      __inode_version(advise), vi->nid);
 		DBG_BUGON(1);
 		return -EIO;
 	}
@@ -173,7 +173,7 @@ static int fill_inode(struct inode *inode, int isdir)
 
 	if (IS_ERR(page)) {
 		errln("failed to get inode (nid: %llu) page, err %ld",
-			vi->nid, PTR_ERR(page));
+		      vi->nid, PTR_ERR(page));
 		return PTR_ERR(page);
 	}
 
@@ -260,7 +260,8 @@ static inline struct inode *erofs_iget_locked(struct super_block *sb,
 }
 
 struct inode *erofs_iget(struct super_block *sb,
-	erofs_nid_t nid, bool isdir)
+			 erofs_nid_t nid,
+			 bool isdir)
 {
 	struct inode *inode = erofs_iget_locked(sb, nid);
 
diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index 3f4fa52c10fa..d8d9dc9dab43 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -211,7 +211,8 @@ int erofs_namei(struct inode *dir,
 
 /* NOTE: i_mutex is already held by vfs */
 static struct dentry *erofs_lookup(struct inode *dir,
-	struct dentry *dentry, unsigned int flags)
+				   struct dentry *dentry,
+				   unsigned int flags)
 {
 	int err;
 	erofs_nid_t nid;
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 15c784fba879..9994066c2ae0 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -32,9 +32,9 @@ static void init_once(void *ptr)
 
 static int __init erofs_init_inode_cache(void)
 {
-	erofs_inode_cachep = kmem_cache_create("erofs_inode",
-		sizeof(struct erofs_vnode), 0,
-		SLAB_RECLAIM_ACCOUNT, init_once);
+	erofs_inode_cachep =
+	kmem_cache_create("erofs_inode", sizeof(struct erofs_vnode), 0,
+			  SLAB_RECLAIM_ACCOUNT, init_once);
 
 	return erofs_inode_cachep != NULL ? 0 : -ENOMEM;
 }
@@ -105,7 +105,7 @@ static int superblock_read(struct super_block *sb)
 	/* 9(512 bytes) + LOG_SECTORS_PER_BLOCK == LOG_BLOCK_SIZE */
 	if (unlikely(blkszbits != LOG_BLOCK_SIZE)) {
 		errln("blksize %u isn't supported on this platform",
-			1 << blkszbits);
+		      1 << blkszbits);
 		goto out;
 	}
 
@@ -121,7 +121,7 @@ static int superblock_read(struct super_block *sb)
 
 	if (1 << (sbi->clusterbits - PAGE_SHIFT) > Z_EROFS_CLUSTER_MAX_PAGES)
 		errln("clusterbits %u is not supported on this kernel",
-			sbi->clusterbits);
+		      sbi->clusterbits);
 #endif
 
 	sbi->root_nid = le16_to_cpu(layout->root_nid);
@@ -132,7 +132,7 @@ static int superblock_read(struct super_block *sb)
 
 	memcpy(&sb->s_uuid, layout->uuid, sizeof(layout->uuid));
 	memcpy(sbi->volume_name, layout->volume_name,
-		sizeof(layout->volume_name));
+	       sizeof(layout->volume_name));
 
 	ret = 0;
 out:
@@ -313,7 +313,8 @@ static int managed_cache_releasepage(struct page *page, gfp_t gfp_mask)
 }
 
 static void managed_cache_invalidatepage(struct page *page,
-	unsigned int offset, unsigned int length)
+					 unsigned int offset,
+					 unsigned int length)
 {
 	const unsigned int stop = length + offset;
 
@@ -352,7 +353,8 @@ static struct inode *erofs_init_managed_cache(struct super_block *sb)
 #endif
 
 static int erofs_read_super(struct super_block *sb,
-	const char *dev_name, void *data, int silent)
+			    const char *dev_name,
+			    void *data, int silent)
 {
 	struct inode *inode;
 	struct erofs_sb_info *sbi;
@@ -424,7 +426,7 @@ static int erofs_read_super(struct super_block *sb,
 
 	if (!S_ISDIR(inode->i_mode)) {
 		errln("rootino(nid %llu) is not a directory(i_mode %o)",
-			ROOT_NID(sbi), inode->i_mode);
+		      ROOT_NID(sbi), inode->i_mode);
 		err = -EINVAL;
 		iput(inode);
 		goto err_iget;
@@ -450,7 +452,7 @@ static int erofs_read_super(struct super_block *sb,
 
 	if (!silent)
 		infoln("mounted on %s with opts: %s.", dev_name,
-			(char *)data);
+		       (char *)data);
 	return 0;
 	/*
 	 * please add a label for each exit point and use
@@ -515,7 +517,7 @@ struct erofs_mount_private {
 
 /* support mount_bdev() with options */
 static int erofs_fill_super(struct super_block *sb,
-	void *_priv, int silent)
+			    void *_priv, int silent)
 {
 	struct erofs_mount_private *priv = _priv;
 
@@ -635,7 +637,7 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 #endif
 	if (test_opt(sbi, FAULT_INJECTION))
 		seq_printf(seq, ",fault_injection=%u",
-			erofs_get_fault_rate(sbi));
+			   erofs_get_fault_rate(sbi));
 	return 0;
 }
 
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 8715bc50e09c..bf98fc3cca87 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -313,12 +313,12 @@ static int z_erofs_vle_work_add_page(
 
 	/* give priority for the compressed data storage */
 	if (builder->role >= Z_EROFS_VLE_WORK_PRIMARY &&
-		type == Z_EROFS_PAGE_TYPE_EXCLUSIVE &&
-		try_to_reuse_as_compressed_page(builder, page))
+	    type == Z_EROFS_PAGE_TYPE_EXCLUSIVE &&
+	    try_to_reuse_as_compressed_page(builder, page))
 		return 0;
 
 	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector,
-		page, type, &occupied);
+					   page, type, &occupied);
 	builder->work->vcnt += (unsigned int)ret;
 
 	return ret ? 0 : -EAGAIN;
@@ -464,10 +464,9 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 	grp->obj.index = f->idx;
 	grp->llen = map->m_llen;
 
-	z_erofs_vle_set_workgrp_fmt(grp,
-		(map->m_flags & EROFS_MAP_ZIPPED) ?
-			Z_EROFS_VLE_WORKGRP_FMT_LZ4 :
-			Z_EROFS_VLE_WORKGRP_FMT_PLAIN);
+	z_erofs_vle_set_workgrp_fmt(grp, (map->m_flags & EROFS_MAP_ZIPPED) ?
+				    Z_EROFS_VLE_WORKGRP_FMT_LZ4 :
+				    Z_EROFS_VLE_WORKGRP_FMT_PLAIN);
 
 	/* new workgrps have been claimed as type 1 */
 	WRITE_ONCE(grp->next, *f->owned_head);
@@ -554,7 +553,8 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
 		return PTR_ERR(work);
 got_it:
 	z_erofs_pagevec_ctor_init(&builder->vector,
-		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, work->vcnt);
+				  Z_EROFS_VLE_INLINE_PAGEVECS,
+				  work->pagevec, work->vcnt);
 
 	if (builder->role >= Z_EROFS_VLE_WORK_PRIMARY) {
 		/* enable possibly in-place decompression */
@@ -595,7 +595,8 @@ void erofs_workgroup_free_rcu(struct erofs_workgroup *grp)
 }
 
 static void __z_erofs_vle_work_release(struct z_erofs_vle_workgroup *grp,
-	struct z_erofs_vle_work *work __maybe_unused)
+				       struct z_erofs_vle_work
+				       *work __maybe_unused)
 {
 	erofs_workgroup_put(&grp->obj);
 }
@@ -715,7 +716,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 
 	/* lucky, within the range of the current map_blocks */
 	if (offset + cur >= map->m_la &&
-		offset + cur < map->m_la + map->m_llen) {
+	    offset + cur < map->m_la + map->m_llen) {
 		/* didn't get a valid unzip work previously (very rare) */
 		if (!builder->work)
 			goto restart_now;
@@ -781,8 +782,9 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 		struct page *const newpage =
 			__stagingpage_alloc(page_pool, GFP_NOFS);
 
-		err = z_erofs_vle_work_add_page(builder,
-			newpage, Z_EROFS_PAGE_TYPE_EXCLUSIVE);
+		err =
+		z_erofs_vle_work_add_page(builder, newpage,
+					  Z_EROFS_PAGE_TYPE_EXCLUSIVE);
 		if (likely(!err))
 			goto retry;
 	}
@@ -890,8 +892,8 @@ static struct page *z_pagemap_global[Z_EROFS_VLE_VMAP_GLOBAL_PAGES];
 static DEFINE_MUTEX(z_pagemap_global_lock);
 
 static int z_erofs_vle_unzip(struct super_block *sb,
-	struct z_erofs_vle_workgroup *grp,
-	struct list_head *page_pool)
+			     struct z_erofs_vle_workgroup *grp,
+			     struct list_head *page_pool)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(sb);
 	const unsigned int clusterpages = erofs_clusterpages(sbi);
@@ -919,12 +921,12 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	if (likely(nr_pages <= Z_EROFS_VLE_VMAP_ONSTACK_PAGES))
 		pages = pages_onstack;
 	else if (nr_pages <= Z_EROFS_VLE_VMAP_GLOBAL_PAGES &&
-		mutex_trylock(&z_pagemap_global_lock))
+		 mutex_trylock(&z_pagemap_global_lock))
 		pages = z_pagemap_global;
 	else {
 repeat:
-		pages = kvmalloc_array(nr_pages,
-			sizeof(struct page *), GFP_KERNEL);
+		pages = kvmalloc_array(nr_pages, sizeof(struct page *),
+				       GFP_KERNEL);
 
 		/* fallback to global pagemap for the lowmem scenario */
 		if (unlikely(!pages)) {
@@ -940,8 +942,8 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	for (i = 0; i < nr_pages; ++i)
 		pages[i] = NULL;
 
-	z_erofs_pagevec_ctor_init(&ctor,
-		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, 0);
+	z_erofs_pagevec_ctor_init(&ctor, Z_EROFS_VLE_INLINE_PAGEVECS,
+				  work->pagevec, 0);
 
 	for (i = 0; i < work->vcnt; ++i) {
 		unsigned int pagenr;
@@ -1005,7 +1007,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 
 	if (z_erofs_vle_workgrp_fmt(grp) == Z_EROFS_VLE_WORKGRP_FMT_PLAIN) {
 		err = z_erofs_vle_plain_copy(compressed_pages, clusterpages,
-			pages, nr_pages, work->pageofs);
+					     pages, nr_pages, work->pageofs);
 		goto out;
 	}
 
@@ -1030,8 +1032,9 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 skip_allocpage:
 	vout = erofs_vmap(pages, nr_pages);
 
-	err = z_erofs_vle_unzip_vmap(compressed_pages,
-		clusterpages, vout, llen, work->pageofs, overlapped);
+	err =
+	z_erofs_vle_unzip_vmap(compressed_pages, clusterpages, vout,
+			       llen, work->pageofs, overlapped);
 
 	erofs_vunmap(vout, nr_pages);
 
@@ -1567,7 +1570,7 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
 			struct erofs_vnode *vi = EROFS_V(inode);
 
 			errln("%s, readahead error at page %lu of nid %llu",
-				__func__, page->index, vi->nid);
+			      __func__, page->index, vi->nid);
 		}
 
 		put_page(page);
@@ -1722,8 +1725,8 @@ vle_get_logical_extent_head(const struct vle_map_blocks_iter_ctx *ctx,
 }
 
 int z_erofs_map_blocks_iter(struct inode *inode,
-	struct erofs_map_blocks *map,
-	int flags)
+			    struct erofs_map_blocks *map,
+			    int flags)
 {
 	void *kaddr;
 	const struct vle_map_blocks_iter_ctx ctx = {
@@ -1830,7 +1833,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		/* logical cluster number should be >= 1 */
 		if (unlikely(!lcn)) {
 			errln("invalid logical cluster 0 at nid %llu",
-				EROFS_V(inode)->nid);
+			      EROFS_V(inode)->nid);
 			err = -EIO;
 			goto unmap_out;
 		}
@@ -1850,7 +1853,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		break;
 	default:
 		errln("unknown cluster type %u at offset %llu of nid %llu",
-			cluster_type, ofs, EROFS_V(inode)->nid);
+		      cluster_type, ofs, EROFS_V(inode)->nid);
 		err = -EIO;
 		goto unmap_out;
 	}
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 5f61f99f4c10..f1725c2c45ea 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -221,7 +221,7 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 	erofs_workstn_lock(sbi);
 
 	found = radix_tree_gang_lookup(&sbi->workstn_tree,
-		batch, first_index, PAGEVEC_SIZE);
+				       batch, first_index, PAGEVEC_SIZE);
 
 	for (i = 0; i < found; ++i) {
 		struct erofs_workgroup *grp = xa_untag_pointer(batch[i]);
diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index f716ab0446e5..d249177539e7 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -122,8 +122,9 @@ static int init_inode_xattrs(struct inode *inode)
 			BUG_ON(it.ofs != EROFS_BLKSIZ);
 			xattr_iter_end(&it, atomic_map);
 
-			it.page = erofs_get_meta_page(sb,
-				++it.blkaddr, S_ISDIR(inode->i_mode));
+			it.page =
+			erofs_get_meta_page(sb, ++it.blkaddr,
+					    S_ISDIR(inode->i_mode));
 			if (IS_ERR(it.page)) {
 				kfree(vi->xattr_shared_xattrs);
 				vi->xattr_shared_xattrs = NULL;
@@ -187,7 +188,7 @@ static inline int xattr_iter_fixup(struct xattr_iter *it)
 }
 
 static int inline_xattr_iter_begin(struct xattr_iter *it,
-	struct inode *inode)
+				   struct inode *inode)
 {
 	struct erofs_vnode *const vi = EROFS_V(inode);
 	struct erofs_sb_info *const sbi = EROFS_SB(inode->i_sb);
@@ -217,7 +218,8 @@ static int inline_xattr_iter_begin(struct xattr_iter *it,
  * `ofs' pointing to the next xattr item rather than an arbitrary position.
  */
 static int xattr_foreach(struct xattr_iter *it,
-	const struct xattr_iter_handlers *op, unsigned int *tlimit)
+			 const struct xattr_iter_handlers *op,
+			 unsigned int *tlimit)
 {
 	struct erofs_xattr_entry entry;
 	unsigned int value_sz, processed, slice;
@@ -321,7 +323,7 @@ struct getxattr_iter {
 };
 
 static int xattr_entrymatch(struct xattr_iter *_it,
-	struct erofs_xattr_entry *entry)
+			    struct erofs_xattr_entry *entry)
 {
 	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
 
@@ -330,7 +332,7 @@ static int xattr_entrymatch(struct xattr_iter *_it,
 }
 
 static int xattr_namematch(struct xattr_iter *_it,
-	unsigned int processed, char *buf, unsigned int len)
+			   unsigned int processed, char *buf, unsigned int len)
 {
 	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
 
@@ -338,7 +340,7 @@ static int xattr_namematch(struct xattr_iter *_it,
 }
 
 static int xattr_checkbuffer(struct xattr_iter *_it,
-	unsigned int value_sz)
+			     unsigned int value_sz)
 {
 	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
 	int err = it->buffer_size < value_sz ? -ERANGE : 0;
@@ -348,7 +350,8 @@ static int xattr_checkbuffer(struct xattr_iter *_it,
 }
 
 static void xattr_copyvalue(struct xattr_iter *_it,
-	unsigned int processed, char *buf, unsigned int len)
+			    unsigned int processed,
+			    char *buf, unsigned int len)
 {
 	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
 
@@ -429,8 +432,8 @@ static bool erofs_xattr_trusted_list(struct dentry *dentry)
 }
 
 int erofs_getxattr(struct inode *inode, int index,
-	const char *name,
-	void *buffer, size_t buffer_size)
+		   const char *name,
+		   void *buffer, size_t buffer_size)
 {
 	int ret;
 	struct getxattr_iter it;
@@ -460,8 +463,8 @@ int erofs_getxattr(struct inode *inode, int index,
 }
 
 static int erofs_xattr_generic_get(const struct xattr_handler *handler,
-		struct dentry *unused, struct inode *inode,
-		const char *name, void *buffer, size_t size)
+				   struct dentry *unused, struct inode *inode,
+				   const char *name, void *buffer, size_t size)
 {
 	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
 
@@ -527,7 +530,7 @@ struct listxattr_iter {
 };
 
 static int xattr_entrylist(struct xattr_iter *_it,
-	struct erofs_xattr_entry *entry)
+			   struct erofs_xattr_entry *entry)
 {
 	struct listxattr_iter *it =
 		container_of(_it, struct listxattr_iter, it);
@@ -558,7 +561,7 @@ static int xattr_entrylist(struct xattr_iter *_it,
 }
 
 static int xattr_namelist(struct xattr_iter *_it,
-	unsigned int processed, char *buf, unsigned int len)
+			  unsigned int processed, char *buf, unsigned int len)
 {
 	struct listxattr_iter *it =
 		container_of(_it, struct listxattr_iter, it);
@@ -569,7 +572,7 @@ static int xattr_namelist(struct xattr_iter *_it,
 }
 
 static int xattr_skipvalue(struct xattr_iter *_it,
-	unsigned int value_sz)
+			   unsigned int value_sz)
 {
 	struct listxattr_iter *it =
 		container_of(_it, struct listxattr_iter, it);
@@ -641,7 +644,7 @@ static int shared_listxattr(struct listxattr_iter *it)
 }
 
 ssize_t erofs_listxattr(struct dentry *dentry,
-	char *buffer, size_t buffer_size)
+			char *buffer, size_t buffer_size)
 {
 	int ret;
 	struct listxattr_iter it;
-- 
2.17.1
