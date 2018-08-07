From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 7 Aug 2018 18:59:32 +0800
Subject: [WIP] [PATCH 2/2] staging: erofs: cleanup
 vle_decompressed_index_clusterofs
In-Reply-To: <1533639572-20153-1-git-send-email-gaoxiang25@huawei.com>
References: <1533639572-20153-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533639572-20153-2-git-send-email-gaoxiang25@huawei.com>

This patch adds error handing code, and fixes a missing
endian conversion in vle_decompressed_index_clusterofs.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index f597f07..ae99b68 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1419,24 +1419,24 @@ static int z_erofs_vle_normalaccess_readpages(
 #define vle_cluster_type(di)	\
 	__vle_cluster_type((di)->di_advise)
 
-static inline unsigned
-vle_compressed_index_clusterofs(unsigned clustersize,
-	struct z_erofs_vle_decompressed_index *di)
+static inline int
+vle_decompressed_index_clusterofs(unsigned int *clusterofs,
+				  unsigned int clustersize,
+				  struct z_erofs_vle_decompressed_index *di)
 {
-	debugln("%s, vle=%pK, advise=%x (type %u), clusterofs=%x blkaddr=%x",
-		__func__, di, di->di_advise, vle_cluster_type(di),
-		di->di_clusterofs, di->di_u.blkaddr);
-
 	switch (vle_cluster_type(di)) {
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		*clusterofs = clustersize;
 		break;
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
-		return di->di_clusterofs;
+		*clusterofs = le16_to_cpu(di->di_clusterofs);
+		break;
 	default:
-		BUG_ON(1);
+		DBG_BUGON(1);
+		return -EIO;
 	}
-	return clustersize;
+	return 0;
 }
 
 static inline erofs_blk_t
@@ -1581,7 +1581,11 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	debugln("%s, lcn %u e_blkaddr %u e_blkoff %u", __func__, lcn,
 		e_blkaddr, vle_extent_blkoff(inode, lcn));
 
-	logical_cluster_ofs = vle_compressed_index_clusterofs(clustersize, di);
+	err = vle_decompressed_index_clusterofs(&logical_cluster_ofs,
+						clustersize, di);
+	if (unlikely(err))
+		goto unmap_out;
+
 	if (!initial) {
 		/* [walking mode] 'map' has been already initialized */
 		map->m_llen += logical_cluster_ofs;
-- 
1.9.1
