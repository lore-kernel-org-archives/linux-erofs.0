From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 22 Mar 2019 10:38:16 +0800
Subject: [PATCH v3] staging: erofs: Use !x or x in place of NULL comparision
Message-ID: <20190322023816.5077-1-gaoxiang25@huawei.com>

From: Bhanusree Pola <bhanusreemahesh@gmail.com>

Test for NULL as !x instead of NULL comparisions.
Issue found using coccinelle
Semantic patch used to solve the problem is as follows

// <smpl>
@@
expression x;
statement S;
@@

x = (\(kmalloc\|devm_kzalloc\|kmalloc_array\|devm_ioremap\|
usb_alloc_urb\|alloc_netdev\|dev_alloc_skb\)(...));

-if(x==NULL)
+if(!x)
S

@@
expression e;
@@

-e == NULL
+!e
// </smpl>

Signed-off-by: Bhanusree Pola <bhanusreemahesh at gmail.com>
[ Gao Xiang: fix x != NULL comparision to x as well. ]
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v3:
 - based on Bhanusree's patch;
 - rebase code and fix x != NULL comparision to x as well.

 drivers/staging/erofs/inode.c         |  4 ++--
 drivers/staging/erofs/internal.h      |  6 +++---
 drivers/staging/erofs/super.c         |  2 +-
 drivers/staging/erofs/unzip_pagevec.h |  6 +++---
 drivers/staging/erofs/utils.c         |  2 +-
 drivers/staging/erofs/xattr.c         | 16 ++++++++--------
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 2df096afe91f..c7d3b815a798 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -129,7 +129,7 @@ static int fill_inline_data(struct inode *inode, void *data,
 	if (S_ISLNK(inode->i_mode) && inode->i_size < PAGE_SIZE) {
 		char *lnk = erofs_kmalloc(sbi, inode->i_size + 1, GFP_KERNEL);
 
-		if (unlikely(lnk == NULL))
+		if (unlikely(!lnk))
 			return -ENOMEM;
 
 		m_pofs += vi->inode_isize + vi->xattr_isize;
@@ -265,7 +265,7 @@ struct inode *erofs_iget(struct super_block *sb,
 {
 	struct inode *inode = erofs_iget_locked(sb, nid);
 
-	if (unlikely(inode == NULL))
+	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
 
 	if (inode->i_state & I_NEW) {
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index e3bfde00c7d2..1286b98ffd0a 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -469,7 +469,7 @@ erofs_grab_bio(struct super_block *sb,
 	do {
 		if (nr_pages == 1) {
 			bio = bio_alloc(gfp | (nofail ? __GFP_NOFAIL : 0), 1);
-			if (unlikely(bio == NULL)) {
+			if (unlikely(!bio)) {
 				DBG_BUGON(nofail);
 				return ERR_PTR(-ENOMEM);
 			}
@@ -477,7 +477,7 @@ erofs_grab_bio(struct super_block *sb,
 		}
 		bio = bio_alloc(gfp, nr_pages);
 		nr_pages /= 2;
-	} while (unlikely(bio == NULL));
+	} while (unlikely(!bio));
 
 	bio->bi_end_io = endio;
 	bio_set_dev(bio, sb->s_bdev);
@@ -565,7 +565,7 @@ static inline void *erofs_vmap(struct page **pages, unsigned int count)
 	while (1) {
 		void *addr = vm_map_ram(pages, count, -1, PAGE_KERNEL);
 		/* retry two more times (totally 3 times) */
-		if (addr != NULL || ++i >= 3)
+		if (addr || ++i >= 3)
 			return addr;
 		vm_unmap_aliases();
 	}
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 40766519b443..7b460a3ca4d6 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -240,7 +240,7 @@ static int parse_options(struct super_block *sb, char *options)
 	if (!options)
 		return 0;
 
-	while ((p = strsep(&options, ",")) != NULL) {
+	while ((p = strsep(&options, ","))) {
 		int token;
 
 		if (!*p)
diff --git a/drivers/staging/erofs/unzip_pagevec.h b/drivers/staging/erofs/unzip_pagevec.h
index 23856ba2742d..f37d8fd14771 100644
--- a/drivers/staging/erofs/unzip_pagevec.h
+++ b/drivers/staging/erofs/unzip_pagevec.h
@@ -43,7 +43,7 @@ struct z_erofs_pagevec_ctor {
 static inline void z_erofs_pagevec_ctor_exit(struct z_erofs_pagevec_ctor *ctor,
 					     bool atomic)
 {
-	if (ctor->curr == NULL)
+	if (!ctor->curr)
 		return;
 
 	if (atomic)
@@ -59,7 +59,7 @@ z_erofs_pagevec_ctor_next_page(struct z_erofs_pagevec_ctor *ctor,
 	unsigned index;
 
 	/* keep away from occupied pages */
-	if (ctor->next != NULL)
+	if (ctor->next)
 		return ctor->next;
 
 	for (index = 0; index < nr; ++index) {
@@ -121,7 +121,7 @@ z_erofs_pagevec_ctor_enqueue(struct z_erofs_pagevec_ctor *ctor,
 			     bool *occupied)
 {
 	*occupied = false;
-	if (unlikely(ctor->next == NULL && type))
+	if (unlikely(!ctor->next && type))
 		if (ctor->index + 1 == ctor->nr)
 			return false;
 
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index f1725c2c45ea..3e7d30b6de1d 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -61,7 +61,7 @@ struct erofs_workgroup *erofs_find_workgroup(struct super_block *sb,
 repeat:
 	rcu_read_lock();
 	grp = radix_tree_lookup(&sbi->workstn_tree, index);
-	if (grp != NULL) {
+	if (grp) {
 		*tag = xa_pointer_tag(grp);
 		grp = xa_untag_pointer(grp);
 
diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index 3fa825672ce3..df40654b9fbb 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -36,7 +36,7 @@ static inline void xattr_iter_end(struct xattr_iter *it, bool atomic)
 
 static inline void xattr_iter_end_final(struct xattr_iter *it)
 {
-	if (it->page == NULL)
+	if (!it->page)
 		return;
 
 	xattr_iter_end(it, true);
@@ -107,7 +107,7 @@ static int init_inode_xattrs(struct inode *inode)
 	vi->xattr_shared_count = ih->h_shared_count;
 	vi->xattr_shared_xattrs = kmalloc_array(vi->xattr_shared_count,
 						sizeof(uint), GFP_KERNEL);
-	if (vi->xattr_shared_xattrs == NULL) {
+	if (!vi->xattr_shared_xattrs) {
 		xattr_iter_end(&it, atomic_map);
 		ret = -ENOMEM;
 		goto out_unlock;
@@ -235,7 +235,7 @@ static int xattr_foreach(struct xattr_iter *it,
 	 *    therefore entry should be in the page
 	 */
 	entry = *(struct erofs_xattr_entry *)(it->kaddr + it->ofs);
-	if (tlimit != NULL) {
+	if (tlimit) {
 		unsigned int entry_sz = EROFS_XATTR_ENTRY_SIZE(&entry);
 
 		BUG_ON(*tlimit < entry_sz);
@@ -282,7 +282,7 @@ static int xattr_foreach(struct xattr_iter *it,
 	/* 3. handle xattr value */
 	processed = 0;
 
-	if (op->alloc_buffer != NULL) {
+	if (op->alloc_buffer) {
 		err = op->alloc_buffer(it, value_sz);
 		if (err) {
 			it->ofs += value_sz;
@@ -345,7 +345,7 @@ static int xattr_checkbuffer(struct xattr_iter *_it,
 	int err = it->buffer_size < value_sz ? -ERANGE : 0;
 
 	it->buffer_size = value_sz;
-	return it->buffer == NULL ? 1 : err;
+	return !it->buffer ? 1 : err;
 }
 
 static void xattr_copyvalue(struct xattr_iter *_it,
@@ -437,7 +437,7 @@ int erofs_getxattr(struct inode *inode, int index,
 	int ret;
 	struct getxattr_iter it;
 
-	if (unlikely(name == NULL))
+	if (unlikely(!name))
 		return -EINVAL;
 
 	ret = init_inode_xattrs(inode);
@@ -539,13 +539,13 @@ static int xattr_entrylist(struct xattr_iter *_it,
 	const struct xattr_handler *h =
 		erofs_xattr_handler(entry->e_name_index);
 
-	if (h == NULL || (h->list != NULL && !h->list(it->dentry)))
+	if (!h || (h->list && !h->list(it->dentry)))
 		return 1;
 
 	prefix = xattr_prefix(h);
 	prefix_len = strlen(prefix);
 
-	if (it->buffer == NULL) {
+	if (!it->buffer) {
 		it->buffer_ofs += prefix_len + entry->e_name_len + 1;
 		return 1;
 	}
-- 
2.12.2
