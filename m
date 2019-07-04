From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 4 Jul 2019 18:58:51 +0800
Subject: [PATCH] staging: erofs: support bmap
Message-ID: <20190704105851.66304-1-yuchao0@huawei.com>

Add erofs_bmap() to support FIBMAP ioctl on flatmode inode.

Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/data.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index fbce71403d87..03da57f04347 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -308,9 +308,38 @@ static int erofs_raw_access_readpages(struct file *filp,
 	return iomap_readpages(mapping, pages, nr_pages, &erofs_iomap_ops);
 }
 
+static int erofs_get_block(struct inode *inode, sector_t iblock,
+			   struct buffer_head *bh, int create)
+{
+	struct erofs_map_blocks map = {
+		.m_la = iblock << 9,
+	};
+	int err;
+
+	err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
+	if (err)
+		return err;
+
+	if (map.m_flags & EROFS_MAP_MAPPED)
+		bh->b_blocknr = erofs_blknr(map.m_pa);
+
+	return err;
+}
+
+static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
+{
+	struct inode *inode = mapping->host;
+
+	if (is_inode_flat_inline(inode))
+		return 0;
+
+	return generic_block_bmap(mapping, block, erofs_get_block);
+}
+
 /* for uncompressed (aligned) files and raw access for other files */
 const struct address_space_operations erofs_raw_access_aops = {
 	.readpage = erofs_raw_access_readpage,
 	.readpages = erofs_raw_access_readpages,
+	.bmap = erofs_bmap,
 };
 
-- 
2.18.0.rc1
