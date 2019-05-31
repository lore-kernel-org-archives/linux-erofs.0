From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 31 May 2019 08:50:47 +0800
Subject: [PATCH 13/13] erofs-utils: fix potential erofs_bh_balloon failure
In-Reply-To: <20190531005047.22093-1-hsiangkao@aol.com>
References: <20190531005047.22093-1-hsiangkao@aol.com>
Message-ID: <20190531005047.22093-14-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

erofs_write_tail_end is called at the last end
of erofs_mkfs_build_tree, which is of course
after traversing all sub-tree inodes.

Therefore, erofs_bh_balloon could fail if
corresponding block is allocated, fix it.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
Will be wrapped in the original patch.

 lib/inode.c | 61 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index b7fcf0e..9f7a4e4 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -399,6 +399,35 @@ static struct erofs_bhops erofs_write_inode_bhops = {
 	.flush = erofs_bh_flush_write_inode,
 };
 
+int erofs_prepare_tail_block(struct erofs_inode *inode)
+{
+	struct erofs_buffer_head *bh;
+	int ret;
+
+	if (!inode->idata_size)
+		return 0;
+
+	bh = inode->bh_data;
+	if (!bh) {
+		bh = erofs_balloc(DATA, EROFS_BLKSIZ, 0, 0);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
+		bh->op = &erofs_skip_write_bhops;
+
+		/* get blkaddr of bh */
+		ret = erofs_mapbh(bh->block, true);
+		DBG_BUGON(ret < 0);
+		inode->u.i_blkaddr = bh->block->blkaddr;
+
+		inode->bh_data = bh;
+		return 0;
+	}
+	/* expend a block as the tail block (should be successful) */
+	ret = erofs_bh_balloon(bh, EROFS_BLKSIZ);
+	DBG_BUGON(ret);
+	return 0;
+}
+
 int erofs_prepare_inode_buffer(struct erofs_inode *inode)
 {
 	unsigned int inodesize;
@@ -421,11 +450,18 @@ int erofs_prepare_inode_buffer(struct erofs_inode *inode)
 
 	bh = erofs_balloc(INODE, inodesize, 0, inode->idata_size);
 	if (bh == ERR_PTR(-ENOSPC)) {
+		int ret;
+
 		inode->data_mapping_mode = EROFS_INODE_LAYOUT_PLAIN;
 noinline:
+		/* expend an extra block for tail-end data */
+		ret = erofs_prepare_tail_block(inode);
+		if (ret)
+			return ret;
 		bh = erofs_balloc(INODE, inodesize, 0, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
+		DBG_BUGON(inode->bh_inline);
 	} else if (IS_ERR(bh)) {
 		return PTR_ERR(bh);
 	} else if (inode->idata_size) {
@@ -485,28 +521,11 @@ int erofs_write_tail_end(struct erofs_inode *inode)
 		ibh->op = &erofs_write_inline_bhops;
 	} else {
 		int ret;
-		erofs_off_t off;
-
-		if (bh) {
-			/* expend a block (should be successful) */
-			ret = erofs_bh_balloon(bh, EROFS_BLKSIZ);
-			DBG_BUGON(ret);
-
-			erofs_mapbh(bh->block, true);
-			off = erofs_btell(bh, true) - EROFS_BLKSIZ;
-		} else {
-			bh = erofs_balloc(DATA, EROFS_BLKSIZ, 0, 0);
-			if (IS_ERR(bh))
-				return PTR_ERR(bh);
-
-			bh->op = &erofs_skip_write_bhops;
-			erofs_mapbh(bh->block, true);
-			off = erofs_btell(bh, false);
-			inode->u.i_blkaddr = erofs_blknr(off);
-			inode->bh_data = bh;
-		}
 
-		ret = dev_write(inode->idata, off, inode->idata_size);
+		erofs_mapbh(bh->block, true);
+		ret = dev_write(inode->idata,
+				erofs_btell(bh, true) - EROFS_BLKSIZ,
+				inode->idata_size);
 		if (ret)
 			return ret;
 
-- 
2.17.1
