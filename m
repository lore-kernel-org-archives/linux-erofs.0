From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 1 Aug 2018 17:36:54 +0800
Subject: [PATCH RESEND 1/2] staging: erofs: add the missing break in
 z_erofs_map_blocks_iter
In-Reply-To: <ea978a27-efd4-9d58-e4c0-f9d00420304f@huawei.com>
References: <ea978a27-efd4-9d58-e4c0-f9d00420304f@huawei.com>
Message-ID: <1533116214-70017-1-git-send-email-gaoxiang25@huawei.com>

This patch adds a missing break after adding the default case.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
As pointed out by Dan Carpenter:
 - fix the wrong place of fallthrough comments

 drivers/staging/erofs/unzip_vle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index bd2d7a8..1030ca5 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1599,6 +1599,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 		if (ofs_rem >= logical_cluster_ofs)
 			map->m_flags ^= EROFS_MAP_ZIPPED;
+		/* fallthrough */
 	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
 		if (ofs_rem == logical_cluster_ofs) {
 			pcn = le32_to_cpu(di->di_u.blkaddr);
@@ -1619,11 +1620,13 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 			goto unmap_out;
 		}
 		end = (lcn-- * clustersize) | logical_cluster_ofs;
+		/* fallthrough */
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
 		/* get the correspoinding first chunk */
 		ofs = vle_get_logical_extent_head(inode, mpage_ret,
 			&kaddr, lcn, &pcn, &map->m_flags);
 		mpage = *mpage_ret;
+		break;
 	default:
 		errln("unknown cluster type %u at offset %llu of nid %llu",
 			cluster_type, ofs, EROFS_V(inode)->nid);
-- 
1.9.1
