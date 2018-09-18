From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 22:25:33 +0800
Subject: [PATCH v2 1/8] staging: erofs: fix a missing endian conversion
In-Reply-To: <1537280740-122019-1-git-send-email-gaoxiang25@huawei.com>
References: <1537280740-122019-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1537280740-122019-2-git-send-email-gaoxiang25@huawei.com>

This patch fixes a missing endian conversion in
vle_get_logical_extent_head.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 21874b7..d16e3dc 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1488,6 +1488,7 @@ static erofs_off_t vle_get_logical_extent_head(
 	struct super_block *const sb = inode->i_sb;
 	const unsigned int clusterbits = EROFS_SB(sb)->clusterbits;
 	const unsigned int clustersize = 1 << clusterbits;
+	unsigned int delta0;
 
 	if (page->index != blkaddr) {
 		kunmap_atomic(*kaddr_iter);
@@ -1502,12 +1503,13 @@ static erofs_off_t vle_get_logical_extent_head(
 	di = *kaddr_iter + vle_extent_blkoff(inode, lcn);
 	switch (vle_cluster_type(di)) {
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
-		BUG_ON(!di->di_u.delta[0]);
-		BUG_ON(lcn < di->di_u.delta[0]);
+		delta0 = le16_to_cpu(di->di_u.delta[0]);
+		DBG_BUGON(!delta0);
+		DBG_BUGON(lcn < delta0);
 
 		ofs = vle_get_logical_extent_head(inode,
 			page_iter, kaddr_iter,
-			lcn - di->di_u.delta[0], pcn, flags);
+			lcn - delta0, pcn, flags);
 		break;
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 		*flags ^= EROFS_MAP_ZIPPED;
-- 
1.9.1
