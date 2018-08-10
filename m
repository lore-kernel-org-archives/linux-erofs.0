From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 04:10:35 +0800
Subject: [PREVIEW] [PATCH v3 07/10] staging: erofs: clean up
 z_erofs_map_blocks_iter
In-Reply-To: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533931838-47642-7-git-send-email-gaoxiang25@huawei.com>

This patch mainly introduces `vle_map_blocks_iter_ctx' to clean up
z_erofs_map_blocks_iter and vle_get_logical_extent_head.

It changes the return value of `vle_get_logical_extent_head' to int
for the later error handing. In addition, it also renames `pcn' to
`pblk' since only `pblk' exists in erofs compression ondisk format.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v3:
 - spilt into small patches at Chao's suggestion.

 drivers/staging/erofs/unzip_vle.c | 139 +++++++++++++++++++++-----------------
 1 file changed, 77 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index f81b2a6..74d2530 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1410,6 +1410,13 @@ static int z_erofs_vle_normalaccess_readpages(
 	.readpages = z_erofs_vle_normalaccess_readpages,
 };
 
+/*
+ * Variable-sized Logical Extent (Fixed Physical Cluster) Compression Mode
+ * ---
+ * VLE compression mode attempts to compress a number of logical data into
+ * a physical cluster with a fixed size.
+ * VLE compression mode uses "struct z_erofs_vle_decompressed_index".
+ */
 #define __vle_cluster_advise(x, bit, bits) \
 	((le16_to_cpu(x) >> (bit)) & ((1 << (bits)) - 1))
 
@@ -1465,90 +1472,95 @@ static int z_erofs_vle_normalaccess_readpages(
 	return erofs_blkoff(iloc(sbi, vi->nid) + ofs);
 }
 
-/*
- * Variable-sized Logical Extent (Fixed Physical Cluster) Compression Mode
- * ---
- * VLE compression mode attempts to compress a number of logical data into
- * a physical cluster with a fixed size.
- * VLE compression mode uses "struct z_erofs_vle_decompressed_index".
- */
-static erofs_off_t vle_get_logical_extent_head(
-	struct inode *inode,
-	struct page **page_iter,
-	void **kaddr_iter,
-	unsigned lcn,	/* logical cluster number */
-	erofs_blk_t *pcn,
-	unsigned *flags)
+struct vle_map_blocks_iter_ctx {
+	struct inode *inode;
+	struct super_block *sb;
+	unsigned int clusterbits;
+
+	struct page **mpage_ret;
+	void **kaddr_ret;
+};
+
+static int
+vle_get_logical_extent_head(const struct vle_map_blocks_iter_ctx *ctx,
+			    unsigned int lcn,	/* logical cluster number */
+			    unsigned long long *ofs,
+			    erofs_blk_t *pblk,
+			    unsigned int *flags)
 {
-	/* for extent meta */
-	struct page *page = *page_iter;
-	erofs_blk_t blkaddr = vle_extent_blkaddr(inode, lcn);
+	const unsigned int clustersize = 1 << ctx->clusterbits;
+	const erofs_blk_t mblk = vle_extent_blkaddr(ctx->inode, lcn);
+	struct page *mpage = *ctx->mpage_ret;	/* extent metapage */
+
 	struct z_erofs_vle_decompressed_index *di;
-	unsigned long long ofs;
-	struct super_block *const sb = inode->i_sb;
-	const unsigned int clusterbits = EROFS_SB(sb)->clusterbits;
-	const unsigned int clustersize = 1 << clusterbits;
-	unsigned delta0;
-
-	if (page->index != blkaddr) {
-		kunmap_atomic(*kaddr_iter);
-		unlock_page(page);
-		put_page(page);
+	unsigned int cluster_type, delta0;
+
+	if (mpage->index != mblk) {
+		kunmap_atomic(*ctx->kaddr_ret);
+		unlock_page(mpage);
+		put_page(mpage);
 
-		page = erofs_get_meta_page_nofail(sb, blkaddr, false);
-		*page_iter = page;
-		*kaddr_iter = kmap_atomic(page);
+		mpage = erofs_get_meta_page_nofail(ctx->sb, mblk, false);
+		*ctx->mpage_ret = mpage;
+		*ctx->kaddr_ret = kmap_atomic(mpage);
 	}
 
-	di = *kaddr_iter + vle_extent_blkoff(inode, lcn);
-	switch (vle_cluster_type(di)) {
+	di = *ctx->kaddr_ret + vle_extent_blkoff(ctx->inode, lcn);
+
+	cluster_type = vle_cluster_type(di);
+	switch (cluster_type) {
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
 		delta0 = le16_to_cpu(di->di_u.delta[0]);
 		DBG_BUGON(!delta0);
 		DBG_BUGON(lcn < delta0);
 
-		ofs = vle_get_logical_extent_head(inode,
-			page_iter, kaddr_iter,
-			lcn - delta0, pcn, flags);
-		break;
+		return vle_get_logical_extent_head(ctx,
+			lcn - delta0, ofs, pblk, flags);
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 		*flags ^= EROFS_MAP_ZIPPED;
+		/* fallthrough */
 	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
 		/* clustersize should be a power of two */
-		ofs = ((u64)lcn << clusterbits) +
+		*ofs = ((u64)lcn << ctx->clusterbits) +
 			(le16_to_cpu(di->di_clusterofs) & (clustersize - 1));
-		*pcn = le32_to_cpu(di->di_u.blkaddr);
+		*pblk = le32_to_cpu(di->di_u.blkaddr);
 		break;
 	default:
 		BUG_ON(1);
 	}
-	return ofs;
+	return 0;
 }
 
 int z_erofs_map_blocks_iter(struct inode *inode,
 	struct erofs_map_blocks *map,
 	struct page **mpage_ret, int flags)
 {
+	void *kaddr;
+	const struct vle_map_blocks_iter_ctx ctx = {
+		.inode = inode,
+		.sb = inode->i_sb,
+		.clusterbits = EROFS_I_SB(inode)->clusterbits,
+		.mpage_ret = mpage_ret,
+		.kaddr_ret = &kaddr
+	};
+	const unsigned int clustersize = 1 << ctx.clusterbits;
+	/* if both m_(l,p)len are 0, regularize l_lblk, l_lofs, etc... */
+	const bool initial = !map->m_llen;
+
 	/* logicial extent (start, end) offset */
 	unsigned long long ofs, end;
-	struct z_erofs_vle_decompressed_index *di;
-	erofs_blk_t e_blkaddr, pcn;
-	unsigned lcn, logical_cluster_ofs, cluster_type;
+	unsigned int lcn;
 	u32 ofs_rem;
+
+	erofs_blk_t mblk, pblk;
 	struct page *mpage = *mpage_ret;
-	void *kaddr;
-	bool initial;
-	struct super_block *const sb = inode->i_sb;
-	const unsigned int clusterbits = EROFS_SB(sb)->clusterbits;
-	const unsigned int clustersize = 1 << clusterbits;
+	struct z_erofs_vle_decompressed_index *di;
+	unsigned int cluster_type, logical_cluster_ofs;
 	int err = 0;
 
-	/* if both m_(l,p)len are 0, regularize l_lblk, l_lofs, etc... */
-	initial = !map->m_llen;
-
 	/* when trying to read beyond EOF, leave it unmapped */
 	if (unlikely(map->m_la >= inode->i_size)) {
-		BUG_ON(!initial);
+		DBG_BUGON(!initial);
 		map->m_llen = map->m_la + 1 - inode->i_size;
 		map->m_la = inode->i_size;
 		map->m_flags = 0;
@@ -1561,16 +1573,16 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	ofs = map->m_la + map->m_llen;
 
 	/* clustersize should be power of two */
-	lcn = ofs >> clusterbits;
+	lcn = ofs >> ctx.clusterbits;
 	ofs_rem = ofs & (clustersize - 1);
 
-	e_blkaddr = vle_extent_blkaddr(inode, lcn);
+	mblk = vle_extent_blkaddr(inode, lcn);
 
-	if (mpage == NULL || mpage->index != e_blkaddr) {
+	if (mpage == NULL || mpage->index != mblk) {
 		if (mpage != NULL)
 			put_page(mpage);
 
-		mpage = erofs_get_meta_page_nofail(sb, e_blkaddr, false);
+		mpage = erofs_get_meta_page_nofail(ctx.sb, mblk, false);
 		*mpage_ret = mpage;
 	} else {
 		lock_page(mpage);
@@ -1580,8 +1592,8 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	kaddr = kmap_atomic(mpage);
 	di = kaddr + vle_extent_blkoff(inode, lcn);
 
-	debugln("%s, lcn %u e_blkaddr %u e_blkoff %u", __func__, lcn,
-		e_blkaddr, vle_extent_blkoff(inode, lcn));
+	debugln("%s, lcn %u mblk %u e_blkoff %u", __func__, lcn,
+		mblk, vle_extent_blkoff(inode, lcn));
 
 	err = vle_decompressed_index_clusterofs(&logical_cluster_ofs,
 						clustersize, di);
@@ -1608,13 +1620,13 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		/* fallthrough */
 	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
 		if (ofs_rem == logical_cluster_ofs) {
-			pcn = le32_to_cpu(di->di_u.blkaddr);
+			pblk = le32_to_cpu(di->di_u.blkaddr);
 			goto exact_hitted;
 		}
 
 		if (ofs_rem > logical_cluster_ofs) {
 			ofs = (u64)lcn * clustersize | logical_cluster_ofs;
-			pcn = le32_to_cpu(di->di_u.blkaddr);
+			pblk = le32_to_cpu(di->di_u.blkaddr);
 			break;
 		}
 
@@ -1629,9 +1641,12 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		/* fallthrough */
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
 		/* get the correspoinding first chunk */
-		ofs = vle_get_logical_extent_head(inode, mpage_ret,
-			&kaddr, lcn, &pcn, &map->m_flags);
+		err = vle_get_logical_extent_head(&ctx, lcn, &ofs,
+						  &pblk, &map->m_flags);
 		mpage = *mpage_ret;
+
+		if (unlikely(err))
+			goto unmap_out;
 		break;
 	default:
 		errln("unknown cluster type %u at offset %llu of nid %llu",
@@ -1644,7 +1659,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 exact_hitted:
 	map->m_llen = end - ofs;
 	map->m_plen = clustersize;
-	map->m_pa = blknr_to_addr(pcn);
+	map->m_pa = blknr_to_addr(pblk);
 	map->m_flags |= EROFS_MAP_MAPPED;
 unmap_out:
 	kunmap_atomic(kaddr);
-- 
1.9.1
