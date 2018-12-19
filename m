From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 19 Dec 2018 20:40:25 +0800
Subject: [PATCH 2/2] erofs-utils: introduce blk_write and clean up related code
In-Reply-To: <20181219124025.17947-1-gaoxiang25@huawei.com>
References: <20181219124025.17947-1-gaoxiang25@huawei.com>
Message-ID: <20181219124025.17947-2-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 erofs_cache.c |  3 +--
 erofs_io.c    |  7 -------
 erofs_io.h    |  8 ++++++--
 mkfs_inode.c  | 56 +++++++++++++++++++-------------------------------------
 4 files changed, 26 insertions(+), 48 deletions(-)

diff --git a/erofs_cache.c b/erofs_cache.c
index cfecd7f..c8af3de 100644
--- a/erofs_cache.c
+++ b/erofs_cache.c
@@ -174,8 +174,7 @@ int erofs_flush_all_blocks(void)
 			pbuf += count;
 		}
 
-		ret = dev_write(erofs_blk_buf,
-				blknr_to_addr(blk->bb_blkaddr), EROFS_BLKSIZE);
+		ret = blk_write(erofs_blk_buf, blk->bb_blkaddr);
 		if (ret)
 			break;
 	}
diff --git a/erofs_io.c b/erofs_io.c
index 563ca3f..1b6087d 100644
--- a/erofs_io.c
+++ b/erofs_io.c
@@ -119,13 +119,6 @@ int dev_write(void *buf, u64 offset, size_t len)
 	return 0;
 }
 
-int dev_write_block(void *buf, u32 blkaddr)
-{
-	erofs_info("Write data to block %u", blkaddr);
-
-	return dev_write(buf, blknr_to_addr(blkaddr), EROFS_BLKSIZE);
-}
-
 int dev_fsync(void)
 {
 	int ret;
diff --git a/erofs_io.h b/erofs_io.h
index b447062..caec141 100644
--- a/erofs_io.h
+++ b/erofs_io.h
@@ -10,15 +10,19 @@
 #define __EROFS_IO_H
 
 #include <sys/cdefs.h>
-#include "erofs_types.h"
+#include "mkfs_erofs.h"
 
 int dev_open(const char *devname);
 void dev_close(void);
 int dev_write(void *buf, u64 offset, size_t len);
-int dev_write_block(void *buf, u32 blkaddr);
 int dev_fsync(void);
 u64 dev_length(void);
 
+static inline int blk_write(void *buf, u32 blkaddr)
+{
+	return dev_write(buf, blknr_to_addr(blkaddr), EROFS_BLKSIZE);
+}
+
 #endif
 
 
diff --git a/mkfs_inode.c b/mkfs_inode.c
index db8e586..0985e77 100644
--- a/mkfs_inode.c
+++ b/mkfs_inode.c
@@ -389,17 +389,14 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 
 			if (dentrys_size + EROFS_DIRENT_SIZE + len >
 			    EROFS_BLKSIZE) {
-				const u32 addr = inode->i_blkaddr + blk_cnt;
+				const u32 blkaddr = inode->i_blkaddr + blk_cnt;
 
 				write_dirents(pbuf, sum, start, pos);
-				ret = dev_write(pbuf,
-						blknr_to_addr(addr),
-						EROFS_BLKSIZE);
+				ret = blk_write(pbuf, blkaddr);
 				if (ret < 0) {
-					erofs_err(
-						"dev_write inode[%s] error[%s]",
-						inode->i_fullpath,
-						strerror(errno));
+					erofs_err("blk_write(file %s, err %s)",
+						  inode->i_fullpath,
+						  strerror(errno));
 					return ret;
 				}
 
@@ -441,17 +438,14 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 			len = strlen(d->i_name);
 			if (dentrys_size + EROFS_DIRENT_SIZE + len >
 			    EROFS_BLKSIZE) {
-				const u32 addr = inode->i_blkaddr + blk_cnt;
+				const u32 blkaddr = inode->i_blkaddr + blk_cnt;
 
 				write_dirents(pbuf, sum, start, pos);
-				dev_write(pbuf,
-					  blknr_to_addr(addr),
-					  EROFS_BLKSIZE);
+				blk_write(pbuf, blkaddr);
 				if (ret < 0) {
-					erofs_err(
-						"dev_write inode[%s] error[%s]",
-						inode->i_fullpath,
-						strerror(errno));
+					erofs_err("blk_write(file %s, err %s)",
+						  inode->i_fullpath,
+						  strerror(errno));
 					return ret;
 				}
 
@@ -467,13 +461,12 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 
 		/* write last page names */
 		if (start != pos) {
-			const u32 addr = inode->i_blkaddr + blk_cnt;
+			const u32 blkaddr = inode->i_blkaddr + blk_cnt;
 
 			write_dirents(pbuf, sum, start, pos);
-			ret = dev_write(pbuf, blknr_to_addr(addr),
-					EROFS_BLKSIZE);
+			ret = blk_write(pbuf, blkaddr);
 			if (ret < 0) {
-				erofs_err("dev_write inode[%s] error[%s]",
+				erofs_err("blk_write(file %s, err %s)",
 					  inode->i_fullpath,
 					  strerror(errno));
 				return ret;
@@ -524,8 +517,6 @@ static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
 		}
 
 		for (i = 0; i < page_cnt; i++) {
-			u32 addr;
-
 			ret = read(fd, pbuf, EROFS_BLKSIZE);
 			if (ret < 0) {
 				erofs_err("read inode[%s] error[%s]",
@@ -534,12 +525,9 @@ static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
 				return -errno;
 			}
 
-			addr = inode->i_blkaddr + i;
-
-			ret = dev_write(pbuf, blknr_to_addr(addr),
-					EROFS_BLKSIZE);
+			ret = blk_write(pbuf, inode->i_blkaddr + i);
 			if (ret < 0) {
-				erofs_err("dev_write inode[%s] ret[%d]",
+				erofs_err("blk_write inode[%s] ret[%d]",
 					  filepath,
 					  ret);
 				return ret;
@@ -575,8 +563,6 @@ static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
 			}
 
 			for (i = 0; i < nblocks; i++) {
-				u32 addr;
-
 				ret = read(fd, pbuf, EROFS_BLKSIZE);
 				if (ret < 0) {
 					erofs_err("read inode[%s] error[%s]",
@@ -584,13 +570,10 @@ static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
 						  strerror(errno));
 					exit(EXIT_FAILURE);
 				}
-				addr = inode->i_blkaddr + i;
 
-				ret = dev_write(pbuf,
-						blknr_to_addr(addr),
-						EROFS_BLKSIZE);
+				ret = blk_write(pbuf, inode->i_blkaddr + i);
 				if (ret < 0) {
-					erofs_err("dev_write inode[%s] ret[%d]",
+					erofs_err("blk_write inode[%s] ret[%d]",
 						  filepath,
 						  ret);
 					return ret;
@@ -657,10 +640,9 @@ static int mkfs_write_inode_symfile(struct erofs_node_info *inode)
 			return -errno;
 		}
 
-		ret = dev_write(pbuf, blknr_to_addr(inode->i_blkaddr),
-				EROFS_BLKSIZE);
+		ret = blk_write(pbuf, inode->i_blkaddr);
 		if (ret < 0) {
-			erofs_err("dev_write inode[%s] error[%s]",
+			erofs_err("blk_write inode[%s] error[%s]",
 				  inode->i_fullpath,
 				  strerror(errno));
 			return ret;
-- 
2.14.4
