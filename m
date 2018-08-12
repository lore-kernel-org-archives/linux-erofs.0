From: chao@kernel.org (Chao Yu)
Date: Sun, 12 Aug 2018 22:01:49 +0800
Subject: [PATCH 7/8] staging: erofs: fix integer overflow on 32-bit platform
In-Reply-To: <20180812140150.13397-1-chao@kernel.org>
References: <20180812140150.13397-1-chao@kernel.org>
Message-ID: <20180812140150.13397-8-chao@kernel.org>

From: Gao Xiang <gaoxiang25@huawei.com>

This patch fixes integer overflow on multiplication
of 32-bit `lcn' in z_erofs_map_blocks_iter.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index ae99b6811d4a..6c5b0a312592 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1513,7 +1513,7 @@ static erofs_off_t vle_get_logical_extent_head(
 		*flags ^= EROFS_MAP_ZIPPED;
 	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
 		/* clustersize should be a power of two */
-		ofs = ((unsigned long long)lcn << clusterbits) +
+		ofs = ((u64)lcn << clusterbits) +
 			(le16_to_cpu(di->di_clusterofs) & (clustersize - 1));
 		*pcn = le32_to_cpu(di->di_u.blkaddr);
 		break;
@@ -1595,7 +1595,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	/* by default, compressed */
 	map->m_flags |= EROFS_MAP_ZIPPED;
 
-	end = (u64)(lcn + 1) * clustersize;
+	end = ((u64)lcn + 1) * clustersize;
 
 	cluster_type = vle_cluster_type(di);
 
@@ -1611,7 +1611,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		}
 
 		if (ofs_rem > logical_cluster_ofs) {
-			ofs = lcn * clustersize | logical_cluster_ofs;
+			ofs = (u64)lcn * clustersize | logical_cluster_ofs;
 			pcn = le32_to_cpu(di->di_u.blkaddr);
 			break;
 		}
@@ -1623,7 +1623,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 			err = -EIO;
 			goto unmap_out;
 		}
-		end = (lcn-- * clustersize) | logical_cluster_ofs;
+		end = ((u64)lcn-- * clustersize) | logical_cluster_ofs;
 		/* fallthrough */
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
 		/* get the correspoinding first chunk */
-- 
2.18.0
