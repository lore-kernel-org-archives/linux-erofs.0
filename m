From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 1 Aug 2018 14:38:30 +0800
Subject: [PATCH 1/2] staging: erofs: add the missing break in
 z_erofs_map_blocks_iter
In-Reply-To: <1532915461-2512-1-git-send-email-gaoxiang25@huawei.com>
References: <1532915461-2512-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533105511-26197-1-git-send-email-gaoxiang25@huawei.com>

This patch adds a missing break after adding the default case.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

Hi Greg,
There are two erofs bugfix & cleanup patches ready for staging-next upstream.
The original preview thread:
  https://lists.ozlabs.org/pipermail/linux-erofs/2018-July/000281.html
  https://lists.ozlabs.org/pipermail/linux-erofs/2018-August/000294.html 

With regard to linux-next conflicts, there are also patches to solve them.
Chao will send them in batch to Stephen later.

Thanks,
Gao Xiang

 drivers/staging/erofs/unzip_vle.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index bd2d7a8..6d3ab31 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1596,10 +1596,10 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	cluster_type = vle_cluster_type(di);
 
 	switch (cluster_type) {
-	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
+	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:	/* fallthrough */
 		if (ofs_rem >= logical_cluster_ofs)
 			map->m_flags ^= EROFS_MAP_ZIPPED;
-	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
+	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:	/* fallthrough */
 		if (ofs_rem == logical_cluster_ofs) {
 			pcn = le32_to_cpu(di->di_u.blkaddr);
 			goto exact_hitted;
@@ -1624,6 +1624,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		ofs = vle_get_logical_extent_head(inode, mpage_ret,
 			&kaddr, lcn, &pcn, &map->m_flags);
 		mpage = *mpage_ret;
+		break;
 	default:
 		errln("unknown cluster type %u at offset %llu of nid %llu",
 			cluster_type, ofs, EROFS_V(inode)->nid);
-- 
1.9.1
