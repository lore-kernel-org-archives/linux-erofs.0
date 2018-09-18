From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 22:25:35 +0800
Subject: [PATCH v2 3/8] staging: erofs: complete error handing of
 z_erofs_map_blocks_iter
In-Reply-To: <1537280740-122019-1-git-send-email-gaoxiang25@huawei.com>
References: <1537280740-122019-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1537280740-122019-4-git-send-email-gaoxiang25@huawei.com>

This patch completes error handing of z_erofs_map_blocks_iter
and vle_get_logical_extent_head, including no memory and
io error cases.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 1e89ff6..94c35b8 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1500,7 +1500,11 @@ struct vle_map_blocks_iter_ctx {
 		unlock_page(mpage);
 		put_page(mpage);
 
-		mpage = erofs_get_meta_page_nofail(ctx->sb, mblk, false);
+		mpage = erofs_get_meta_page(ctx->sb, mblk, false);
+		if (IS_ERR(mpage)) {
+			*ctx->mpage_ret = NULL;
+			return PTR_ERR(mpage);
+		}
 		*ctx->mpage_ret = mpage;
 		*ctx->kaddr_ret = kmap_atomic(mpage);
 	}
@@ -1511,9 +1515,12 @@ struct vle_map_blocks_iter_ctx {
 	switch (cluster_type) {
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
 		delta0 = le16_to_cpu(di->di_u.delta[0]);
-		DBG_BUGON(!delta0);
-		DBG_BUGON(lcn < delta0);
-
+		if (unlikely(!delta0 || delta0 > lcn)) {
+			errln("invalid NONHEAD dl0 %u at lcn %u of nid %llu",
+			      delta0, lcn, EROFS_V(ctx->inode)->nid);
+			DBG_BUGON(1);
+			return -EIO;
+		}
 		return vle_get_logical_extent_head(ctx,
 			lcn - delta0, ofs, pblk, flags);
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
@@ -1526,7 +1533,10 @@ struct vle_map_blocks_iter_ctx {
 		*pblk = le32_to_cpu(di->di_u.blkaddr);
 		break;
 	default:
-		BUG_ON(1);
+		errln("unknown cluster type %u at lcn %u of nid %llu",
+		      cluster_type, lcn, EROFS_V(ctx->inode)->nid);
+		DBG_BUGON(1);
+		return -EIO;
 	}
 	return 0;
 }
@@ -1583,7 +1593,11 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		if (mpage != NULL)
 			put_page(mpage);
 
-		mpage = erofs_get_meta_page_nofail(ctx.sb, mblk, false);
+		mpage = erofs_get_meta_page(ctx.sb, mblk, false);
+		if (IS_ERR(mpage)) {
+			err = PTR_ERR(mpage);
+			goto out;
+		}
 		*mpage_ret = mpage;
 	} else {
 		lock_page(mpage);
@@ -1646,8 +1660,11 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 						  &pblk, &map->m_flags);
 		mpage = *mpage_ret;
 
-		if (unlikely(err))
-			goto unmap_out;
+		if (unlikely(err)) {
+			if (mpage)
+				goto unmap_out;
+			goto out;
+		}
 		break;
 	default:
 		errln("unknown cluster type %u at offset %llu of nid %llu",
@@ -1671,7 +1688,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 		map->m_llen, map->m_plen, map->m_flags);
 
 	/* aggressively BUG_ON iff CONFIG_EROFS_FS_DEBUG is on */
-	DBG_BUGON(err < 0);
+	DBG_BUGON(err < 0 && err != -ENOMEM);
 	return err;
 }
 
-- 
1.9.1
