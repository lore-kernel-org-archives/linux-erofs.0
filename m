From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 04:10:33 +0800
Subject: [PREVIEW] [PATCH v3 05/10] staging: erofs: fix integer overflow on
 32-bit platform
In-Reply-To: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533931838-47642-5-git-send-email-gaoxiang25@huawei.com>

This patch fixes integer overflow on multiplication
of 32-bit lcn in z_erofs_map_blocks_iter.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v3:
 - spilt into small patches at Chao's suggestion.

 drivers/staging/erofs/unzip_vle.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index c59f4c6..6404e02 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1515,7 +1515,7 @@ static erofs_off_t vle_get_logical_extent_head(
 		*flags ^= EROFS_MAP_ZIPPED;
 	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
 		/* clustersize should be a power of two */
-		ofs = ((unsigned long long)lcn << clusterbits) +
+		ofs = ((u64)lcn << clusterbits) +
 			(le16_to_cpu(di->di_clusterofs) & (clustersize - 1));
 		*pcn = le32_to_cpu(di->di_u.blkaddr);
 		break;
@@ -1597,7 +1597,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	/* by default, compressed */
 	map->m_flags |= EROFS_MAP_ZIPPED;
 
-	end = (u64)(lcn + 1) * clustersize;
+	end = ((u64)lcn + 1) * clustersize;
 
 	cluster_type = vle_cluster_type(di);
 
@@ -1613,7 +1613,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		}
 
 		if (ofs_rem > logical_cluster_ofs) {
-			ofs = lcn * clustersize | logical_cluster_ofs;
+			ofs = (u64)lcn * clustersize | logical_cluster_ofs;
 			pcn = le32_to_cpu(di->di_u.blkaddr);
 			break;
 		}
@@ -1625,7 +1625,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 			err = -EIO;
 			goto unmap_out;
 		}
-		end = (lcn-- * clustersize) | logical_cluster_ofs;
+		end = ((u64)lcn-- * clustersize) | logical_cluster_ofs;
 		/* fallthrough */
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
 		/* get the correspoinding first chunk */
-- 
1.9.1
