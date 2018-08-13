From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 14 Aug 2018 03:41:47 +0800
Subject: [PREVIEW] [PATCH v2 staging-next 6/8] staging: erofs: fix
 vle_decompressed_index_clusterofs
In-Reply-To: <1534189309-924-1-git-send-email-hsiangkao@aol.com>
References: <1534189309-924-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1534189309-924-6-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

This patch adds error handing code, and fixes a missing
endian conversion in vle_decompressed_index_clusterofs.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
change log v2:
 - fix as pointed out by Dan Carpenter <dan.carpenter at oracle.com>:
     don't make functions inline

 drivers/staging/erofs/unzip_vle.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index f597f07..e31393a 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1419,24 +1419,24 @@ const struct address_space_operations z_erofs_vle_normalaccess_aops = {
 #define vle_cluster_type(di)	\
 	__vle_cluster_type((di)->di_advise)
 
-static inline unsigned
-vle_compressed_index_clusterofs(unsigned clustersize,
-	struct z_erofs_vle_decompressed_index *di)
+static int
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
2.7.4
