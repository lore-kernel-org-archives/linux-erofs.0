From: gongchen4@huawei.com (Chen Gong)
Date: Tue, 21 Aug 2018 14:04:08 +0800
Subject: [PREVIEW] [PATCH] staging: erofs: replace BUG_ON with DBG_BUGON
Message-ID: <1534831448-54952-1-git-send-email-gongchen4@huawei.com>

This patch replace BUG_ON with DBG_BUGON, and add necessary error
handler.

Signed-off-by: Chen Gong <gongchen4 at huawei.com>
---
 drivers/staging/erofs/data.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 0570af5..174feac 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -25,7 +25,7 @@ static inline void read_endio(struct bio *bio)
 		struct page *page = bvec->bv_page;
 
 		/* page is already locked */
-		BUG_ON(PageUptodate(page));
+		DBG_BUGON(PageUptodate(page));
 
 		if (unlikely(err))
 			SetPageError(page);
@@ -108,12 +108,12 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 	struct erofs_map_blocks *map,
 	int flags)
 {
+	int err = 0;
 	erofs_blk_t nblocks, lastblk;
 	u64 offset = map->m_la;
 	struct erofs_vnode *vi = EROFS_V(inode);
 
 	trace_erofs_map_blocks_flatmode_enter(inode, map, flags);
-	BUG_ON(is_inode_layout_compression(inode));
 
 	nblocks = DIV_ROUND_UP(inode->i_size, PAGE_SIZE);
 	lastblk = nblocks - is_inode_layout_inline(inode);
@@ -140,18 +140,27 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 		map->m_plen = inode->i_size - offset;
 
 		/* inline data should locate in one meta block */
-		BUG_ON(erofs_blkoff(map->m_pa) + map->m_plen > PAGE_SIZE);
+		if(erofs_blkoff(map->m_pa) + map->m_plen > PAGE_SIZE){
+			DBG_BUGON(1);
+			err = -EIO;
+			goto err_out;
+		}
+
 		map->m_flags |= EROFS_MAP_META;
 	} else {
 		errln("internal error @ nid: %llu (size %llu), m_la 0x%llx",
 			vi->nid, inode->i_size, map->m_la);
-		BUG();
+		DBG_BUGON(1);
+		err = -EIO;
+		goto err_out;
 	}
 
 out:
 	map->m_llen = map->m_plen;
+
+err_out:
 	trace_erofs_map_blocks_flatmode_exit(inode, map, flags, 0);
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_EROFS_FS_ZIP
@@ -207,7 +216,7 @@ static inline struct bio *erofs_read_raw_page(
 	erofs_off_t current_block = (erofs_off_t)page->index;
 	int err;
 
-	BUG_ON(!nblocks);
+	DBG_BUGON(!nblocks);
 
 	if (PageUptodate(page)) {
 		err = 0;
@@ -250,7 +259,7 @@ static inline struct bio *erofs_read_raw_page(
 		}
 
 		/* for RAW access mode, m_plen must be equal to m_llen */
-		BUG_ON(map.m_plen != map.m_llen);
+		DBG_BUGON(map.m_plen != map.m_llen);
 
 		blknr = erofs_blknr(map.m_pa);
 		blkoff = erofs_blkoff(map.m_pa);
@@ -260,7 +269,7 @@ static inline struct bio *erofs_read_raw_page(
 			void *vsrc, *vto;
 			struct page *ipage;
 
-			BUG_ON(map.m_plen > PAGE_SIZE);
+			DBG_BUGON(map.m_plen > PAGE_SIZE);
 
 			ipage = erofs_get_meta_page(inode->i_sb, blknr, 0);
 
@@ -287,7 +296,7 @@ static inline struct bio *erofs_read_raw_page(
 		}
 
 		/* pa must be block-aligned for raw reading */
-		BUG_ON(erofs_blkoff(map.m_pa) != 0);
+		DBG_BUGON(erofs_blkoff(map.m_pa));
 
 		/* max # of continuous pages */
 		if (nblocks > DIV_ROUND_UP(map.m_plen, PAGE_SIZE))
@@ -355,7 +364,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	BUG_ON(bio != NULL);	/* since we have only one bio -- must be NULL */
+	DBG_BUGON(bio != NULL);	/* since we have only one bio -- must be NULL */
 	return 0;
 }
 
@@ -393,7 +402,7 @@ static int erofs_raw_access_readpages(struct file *filp,
 		/* pages could still be locked */
 		put_page(page);
 	}
-	BUG_ON(!list_empty(pages));
+	DBG_BUGON(!list_empty(pages));
 
 	/* the rare case (end in gaps) */
 	if (unlikely(bio != NULL))
-- 
1.9.1
