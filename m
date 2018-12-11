From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 12 Dec 2018 03:14:44 +0800
Subject: [PATCH] erofs-mkfs: mkfs_erofs.h: clean up definitions
Message-ID: <20181211191444.14820-1-hsiangkao@aol.com>

remove some duplicated definitions and
keep in line with kernel names.

Signed-off-by: Gao Xiang <hsiangkao at aol.com>
---
 erofs_cache.c | 11 ++++-------
 erofs_io.c    |  3 +--
 mkfs_erofs.h  | 23 ++++++++++-------------
 mkfs_file.c   |  4 ++--
 mkfs_inode.c  | 28 ++++++++++++++--------------
 mkfs_main.c   |  6 +++---
 6 files changed, 34 insertions(+), 41 deletions(-)

diff --git a/erofs_cache.c b/erofs_cache.c
index 5b80592..cfecd7f 100644
--- a/erofs_cache.c
+++ b/erofs_cache.c
@@ -45,10 +45,10 @@ u32 erofs_alloc_blocks(u32 nblocks)
 	devlen = dev_length();
 	if (erofs_current_block > (u64)UINT32_MAX ||
 	    erofs_current_block + nblocks > ((u64)UINT32_MAX) + 1 ||
-	    (erofs_current_block + nblocks) << EROFS_BLOCKSIZE_BITS > devlen) {
+	    blknr_to_addr(erofs_current_block + nblocks) > devlen) {
 		erofs_err("There is no enough free space(curr: %llu, need: %u, device blocks: %llu).",
 			  (unsigned long long)erofs_current_block, nblocks,
-			  (unsigned long long)devlen >> EROFS_BLOCKSIZE_BITS);
+			  (unsigned long long)erofs_blknr(devlen));
 		return 0;
 	}
 
@@ -143,7 +143,6 @@ int erofs_flush_all_blocks(void)
 	char *pbuf;
 	int count;
 	int ret;
-	u32 addr;
 
 	erofs_blk_buf = malloc(EROFS_BLKSIZE);
 	if (!erofs_blk_buf)
@@ -175,10 +174,8 @@ int erofs_flush_all_blocks(void)
 			pbuf += count;
 		}
 
-		addr = blk->bb_blkaddr;
-
-		ret = dev_write(
-			erofs_blk_buf, BLKNO_TO_ADDR(addr), EROFS_BLKSIZE);
+		ret = dev_write(erofs_blk_buf,
+				blknr_to_addr(blk->bb_blkaddr), EROFS_BLKSIZE);
 		if (ret)
 			break;
 	}
diff --git a/erofs_io.c b/erofs_io.c
index 8112ade..57e283e 100644
--- a/erofs_io.c
+++ b/erofs_io.c
@@ -155,8 +155,7 @@ int dev_write_block(void *buf, u32 blkaddr)
 {
 	erofs_info("Write data to block %u", blkaddr);
 
-	return dev_write(buf, ((off64_t)blkaddr) << EROFS_BLOCKSIZE_BITS,
-			 EROFS_BLKSIZE);
+	return dev_write(buf, blknr_to_addr(blkaddr), EROFS_BLKSIZE);
 }
 
 int dev_fsync(void)
diff --git a/mkfs_erofs.h b/mkfs_erofs.h
index be6305e..e5bfc72 100644
--- a/mkfs_erofs.h
+++ b/mkfs_erofs.h
@@ -9,6 +9,7 @@
  */
 #ifndef __EROFS_MKFS_H
 #define __EROFS_MKFS_H
+
 #include <linux/limits.h>
 #include "list_head.h"
 #include "erofs_types.h"
@@ -19,19 +20,12 @@ typedef unsigned int __u32;
 
 #include "erofs_fs.h"
 
-#ifndef PAGE_SIZE
-#define PAGE_SIZE               (4096)
-#endif
-
-#ifndef EROFS_BLKSIZE
+#define LOG_BLOCK_SIZE          (12)
 #define EROFS_BLKSIZE           (4096)
 #define EROFS_BLOCKSIZE_BITS    (12)
-#endif
 
-#define EROFS_BLOCK_SIZE_SHIFT_BITS     (12)
 #define EROFS_SLOTSIZE_BITS             (5)
 #define EROFS_SLOTSIZE                  (32)
-#define MKFS_DIFF_SHIFT_8_BITS          (8)
 
 #define __round_mask(x, y)      ((__typeof__(x))((y)-1))
 #define round_up(x, y)          ((((x)-1) | __round_mask(x, y))+1)
@@ -39,16 +33,19 @@ typedef unsigned int __u32;
 
 #define SIZE_ALIGN(val, size)   (((val) + (size) - 1) & (~(size-1)))
 #define SLOT_ALIGN(slots)       SIZE_ALIGN(slots, EROFS_SLOTSIZE)
-#define PAGE_ALIGN(pages)       SIZE_ALIGN(pages, PAGE_SIZE)
 #define BLK_ALIGN(blks)         SIZE_ALIGN(blks, EROFS_BLKSIZE)
 #define IS_SLOT_ALIGN(__ADDR)   (((__ADDR)%(EROFS_SLOTSIZE))?0:1)
 #define IS_BLK_ALIGN(__ADDR)    (((__ADDR)%(EROFS_BLKSIZE))?0:1)
-#define ADDR_TO_BLKNO(__ADDR)   ((__ADDR) >> EROFS_BLOCKSIZE_BITS)
-#define BLKNO_TO_ADDR(__ADDR)   ((u64)(__ADDR) << EROFS_BLOCKSIZE_BITS)
 #define MAX_NID_INDEX_PER_BLK   (EROFS_BLKSIZE / EROFS_SLOTSIZE)
 
-#define EROFS_INODE_V1_SIZE     sizeof(struct erofs_inode_v1)
-#define EROFS_INODE_V2_SIZE     sizeof(struct erofs_inode_v2)
+typedef u64 erofs_off_t;
+
+/* data type for filesystem-wide blocks number */
+typedef u32 erofs_blk_t;
+
+#define erofs_blknr(addr)       ((addr) / EROFS_BLKSIZ)
+#define erofs_blkoff(addr)      ((addr) % EROFS_BLKSIZ)
+#define blknr_to_addr(nr)       ((erofs_off_t)(nr) * EROFS_BLKSIZ)
 
 #define EROFS_DIRENT_SIZE       sizeof(struct erofs_dirent)
 
diff --git a/mkfs_file.c b/mkfs_file.c
index 634208e..9aa62e2 100644
--- a/mkfs_file.c
+++ b/mkfs_file.c
@@ -437,7 +437,7 @@ static int erofs_compress_noinline_file_data(struct erofs_compr_info *cinfo,
 		else
 			cross = end - start;
 
-		clusterofs = pos % PAGE_SIZE;
+		clusterofs = pos % EROFS_BLKSIZE;
 		delta = 0;
 
 		/*
@@ -508,7 +508,7 @@ int erofs_write_compress_data(struct erofs_compr_ctx *cctx)
 	if (!blkaddr)
 		return -ENOSPC;
 
-	ret = dev_write(cctx->cc_dstbuf, BLKNO_TO_ADDR(blkaddr),
+	ret = dev_write(cctx->cc_dstbuf, blknr_to_addr(blkaddr),
 			cctx->cc_dstlen);
 
 	if (ret)
diff --git a/mkfs_inode.c b/mkfs_inode.c
index 102fa55..db8e586 100644
--- a/mkfs_inode.c
+++ b/mkfs_inode.c
@@ -38,9 +38,9 @@ u32 erofs_calc_inode_base_size(struct erofs_node_info *inode)
 	u32 size;
 
 	if (inode->i_iver == EROFS_INODE_LAYOUT_V1)
-		size = EROFS_INODE_V1_SIZE;
+		size = sizeof(struct erofs_inode_v1);
 	else
-		size = EROFS_INODE_V2_SIZE;
+		size = sizeof(struct erofs_inode_v2);
 
 	return size;
 }
@@ -184,7 +184,7 @@ void mkfs_rank_inode(struct erofs_node_info *inode)
 	node->m_slot = blk->bb_free_slot;
 	node->m_len  = round_up(request_size, EROFS_SLOTSIZE);
 	list_add_tail(&node->m_node, &blk->bb_metadata_list);
-	inode->i_base_addr = BLKNO_TO_ADDR(blk->bb_blkaddr) +
+	inode->i_base_addr = blknr_to_addr(blk->bb_blkaddr) +
 			     blk->bb_free_slot * EROFS_SLOTSIZE;
 	blk->bb_free_slot += node->m_len / EROFS_SLOTSIZE;
 	next = list_next_entry(blk, bb_global_node);
@@ -393,7 +393,7 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 
 				write_dirents(pbuf, sum, start, pos);
 				ret = dev_write(pbuf,
-						BLKNO_TO_ADDR(addr),
+						blknr_to_addr(addr),
 						EROFS_BLKSIZE);
 				if (ret < 0) {
 					erofs_err(
@@ -445,7 +445,7 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 
 				write_dirents(pbuf, sum, start, pos);
 				dev_write(pbuf,
-					  BLKNO_TO_ADDR(addr),
+					  blknr_to_addr(addr),
 					  EROFS_BLKSIZE);
 				if (ret < 0) {
 					erofs_err(
@@ -470,8 +470,8 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 			const u32 addr = inode->i_blkaddr + blk_cnt;
 
 			write_dirents(pbuf, sum, start, pos);
-			ret = dev_write(
-				pbuf, BLKNO_TO_ADDR(addr), EROFS_BLKSIZE);
+			ret = dev_write(pbuf, blknr_to_addr(addr),
+					EROFS_BLKSIZE);
 			if (ret < 0) {
 				erofs_err("dev_write inode[%s] error[%s]",
 					  inode->i_fullpath,
@@ -536,8 +536,8 @@ static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
 
 			addr = inode->i_blkaddr + i;
 
-			ret = dev_write(
-				pbuf, BLKNO_TO_ADDR(addr), EROFS_BLKSIZE);
+			ret = dev_write(pbuf, blknr_to_addr(addr),
+					EROFS_BLKSIZE);
 			if (ret < 0) {
 				erofs_err("dev_write inode[%s] ret[%d]",
 					  filepath,
@@ -587,7 +587,7 @@ static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
 				addr = inode->i_blkaddr + i;
 
 				ret = dev_write(pbuf,
-						BLKNO_TO_ADDR(addr),
+						blknr_to_addr(addr),
 						EROFS_BLKSIZE);
 				if (ret < 0) {
 					erofs_err("dev_write inode[%s] ret[%d]",
@@ -657,8 +657,8 @@ static int mkfs_write_inode_symfile(struct erofs_node_info *inode)
 			return -errno;
 		}
 
-		ret = dev_write(
-			pbuf, BLKNO_TO_ADDR(inode->i_blkaddr), EROFS_BLKSIZE);
+		ret = dev_write(pbuf, blknr_to_addr(inode->i_blkaddr),
+				EROFS_BLKSIZE);
 		if (ret < 0) {
 			erofs_err("dev_write inode[%s] error[%s]",
 				  inode->i_fullpath,
@@ -778,7 +778,7 @@ static int erofs_do_write_inode_buffer(struct erofs_node_info *inode, char *buf)
 		}
 
 		v1->i_checksum = 0;
-		return EROFS_INODE_V1_SIZE;
+		return sizeof(*v1);
 	}
 
 	v2 = (struct erofs_inode_v2 *)buf;
@@ -814,7 +814,7 @@ static int erofs_do_write_inode_buffer(struct erofs_node_info *inode, char *buf)
 	}
 
 	v2->i_checksum = 0;
-	return EROFS_INODE_V2_SIZE;
+	return sizeof(*v2);
 }
 
 int erofs_write_inode_buffer(struct erofs_node_info *inode, char *buf)
diff --git a/mkfs_main.c b/mkfs_main.c
index d26d050..17611f4 100644
--- a/mkfs_main.c
+++ b/mkfs_main.c
@@ -29,7 +29,7 @@
 
 static struct erofs_super_block erosb = {
 	.magic     = cpu_to_le32(EROFS_SUPER_MAGIC_V1),
-	.blkszbits = EROFS_BLOCK_SIZE_SHIFT_BITS,
+	.blkszbits = LOG_BLOCK_SIZE,
 	.root_nid  = cpu_to_le16(ROOT_INODE_NUM),
 	.inos   = 0,
 	.blocks = 0,
@@ -128,7 +128,7 @@ void mkfs_update_erofs_header(u64 root_addr)
 		sb->build_time_nsec = cpu_to_le32(t.tv_usec);
 	}
 
-	sb->meta_blkaddr = cpu_to_le32(ADDR_TO_BLKNO(size));
+	sb->meta_blkaddr = cpu_to_le32(erofs_blknr(size));
 	sb->blocks       = cpu_to_le32(erofs_get_total_blocks());
 	sb->root_nid     = cpu_to_le16(mkfs_addr_to_nid(root_addr));
 
@@ -163,7 +163,7 @@ int main(int argc, char **argv)
 	if (err)
 		goto exit;
 
-	err = erofs_cache_init(ADDR_TO_BLKNO(BLK_ALIGN(EROFS_SUPER_END)));
+	err = erofs_cache_init(erofs_blknr(BLK_ALIGN(EROFS_SUPER_END)));
 	if (err)
 		goto exit;
 
-- 
2.11.0
