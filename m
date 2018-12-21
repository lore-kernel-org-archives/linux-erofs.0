From: bluce.liguifu@huawei.com (Li Guifu)
Date: Fri, 21 Dec 2018 09:47:19 +0800
Subject: [PATCH] erofs-utils:erofs-utils: fix the missing trailing '\0' of the
 last dirent name
Message-ID: <20181221014719.14301-1-bluce.liguifu@huawei.com>

caused by the buffer is not cleanned before using, fix it.

Signed-off-by: Li Guifu <bluce.liguifu at huawei.com>
---
 mkfs_inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mkfs_inode.c b/mkfs_inode.c
index 0985e77..41dfc33 100644
--- a/mkfs_inode.c
+++ b/mkfs_inode.c
@@ -391,6 +391,7 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 			    EROFS_BLKSIZE) {
 				const u32 blkaddr = inode->i_blkaddr + blk_cnt;
 
+				memset(pbuf, 0, EROFS_BLKSIZE);
 				write_dirents(pbuf, sum, start, pos);
 				ret = blk_write(pbuf, blkaddr);
 				if (ret < 0) {
@@ -412,8 +413,10 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 
 		/* write last page names */
 		if (start != pos) {
-			s32 len = write_dirents(pbuf, sum, start, pos);
+			s32 len;
 
+			memset(pbuf, 0, EROFS_BLKSIZE);
+			len = write_dirents(pbuf, sum, start, pos);
 			inode->i_inline_data    = pbuf;
 			inode->i_inline_datalen = len;
 		}
@@ -440,6 +443,7 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 			    EROFS_BLKSIZE) {
 				const u32 blkaddr = inode->i_blkaddr + blk_cnt;
 
+				memset(pbuf, 0, EROFS_BLKSIZE);
 				write_dirents(pbuf, sum, start, pos);
 				blk_write(pbuf, blkaddr);
 				if (ret < 0) {
@@ -463,6 +467,7 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 		if (start != pos) {
 			const u32 blkaddr = inode->i_blkaddr + blk_cnt;
 
+			memset(pbuf, 0, EROFS_BLKSIZE);
 			write_dirents(pbuf, sum, start, pos);
 			ret = blk_write(pbuf, blkaddr);
 			if (ret < 0) {
-- 
2.17.1
