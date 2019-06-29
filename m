From: yuchao0@huawei.com (Chao Yu)
Date: Sat, 29 Jun 2019 16:55:39 +0800
Subject: [PATCH 2/2] staging: erofs: use iomap interface for raw data access
In-Reply-To: <20190629085539.29237-1-yuchao0@huawei.com>
References: <20190629085539.29237-1-yuchao0@huawei.com>
Message-ID: <20190629085539.29237-2-yuchao0@huawei.com>

As Christoph suggested, for the raw data access interfaces,
we'd better use iomap framework interface instead, it can
help to avoid a lot of duplicated codes, and also it can get
rid of accessing private field of block layer directly.

https://lkml.org/lkml/2019/4/12/605

Suggested-by: Christoph Hellwig <hch at lst.de>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/data.c | 249 ++++++++++++-----------------------
 1 file changed, 83 insertions(+), 166 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 08c55e4278ee..6201a77dfb99 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -12,6 +12,7 @@
  */
 #include "internal.h"
 #include <linux/prefetch.h>
+#include <linux/iomap.h>
 
 #include <trace/events/erofs.h>
 
@@ -111,6 +112,15 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
 	return ERR_PTR(err);
 }
 
+struct page *__erofs_find_meta_page(struct super_block *sb,
+				    erofs_blk_t blkaddr)
+{
+	struct inode *const bd_inode = sb->s_bdev->bd_inode;
+	struct address_space *const mapping = bd_inode->i_mapping;
+
+	return find_get_page(mapping, blkaddr);
+}
+
 static int erofs_map_blocks_flatmode(struct inode *inode,
 				     struct erofs_map_blocks *map,
 				     int flags)
@@ -185,167 +195,106 @@ int erofs_map_blocks(struct inode *inode,
 	return erofs_map_blocks_flatmode(inode, map, flags);
 }
 
-static inline struct bio *erofs_read_raw_page(struct bio *bio,
-					      struct address_space *mapping,
-					      struct page *page,
-					      erofs_off_t *last_block,
-					      unsigned int nblocks,
-					      bool ra)
+static int erofs_iomap_begin(struct inode *inode, loff_t pos,
+			     loff_t length, unsigned int flags,
+			     struct iomap *iomap)
 {
-	struct inode *const inode = mapping->host;
-	struct super_block *const sb = inode->i_sb;
-	erofs_off_t current_block = (erofs_off_t)page->index;
+	struct erofs_map_blocks map = {
+		.m_la = pos,
+	};
+	erofs_blk_t blknr;
+	unsigned int blkoff;
 	int err;
 
-	DBG_BUGON(!nblocks);
-
-	if (PageUptodate(page)) {
-		err = 0;
-		goto has_updated;
-	}
-
-	if (cleancache_get_page(page) == 0) {
-		err = 0;
-		SetPageUptodate(page);
-		goto has_updated;
-	}
+	err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
+	if (unlikely(err))
+		return err;
 
-	/* note that for readpage case, bio also equals to NULL */
-	if (bio &&
-	    /* not continuous */
-	    *last_block + 1 != current_block) {
-submit_bio_retry:
-		__submit_bio(bio, REQ_OP_READ, 0);
-		bio = NULL;
+	/* holed page */
+	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+		iomap->length = EROFS_BLKSIZ;
+		return 0;
 	}
 
-	if (!bio) {
-		struct erofs_map_blocks map = {
-			.m_la = blknr_to_addr(current_block),
-		};
-		erofs_blk_t blknr;
-		unsigned int blkoff;
-
-		err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
-		if (unlikely(err))
-			goto err_out;
-
-		/* zero out the holed page */
-		if (unlikely(!(map.m_flags & EROFS_MAP_MAPPED))) {
-			zero_user_segment(page, 0, PAGE_SIZE);
-			SetPageUptodate(page);
-
-			/* imply err = 0, see erofs_map_blocks */
-			goto has_updated;
-		}
-
-		/* for RAW access mode, m_plen must be equal to m_llen */
-		DBG_BUGON(map.m_plen != map.m_llen);
+	/* for RAW access mode, m_plen must be equal to m_llen */
+	DBG_BUGON(map.m_plen != map.m_llen);
 
-		blknr = erofs_blknr(map.m_pa);
-		blkoff = erofs_blkoff(map.m_pa);
+	blknr = erofs_blknr(map.m_pa);
+	blkoff = erofs_blkoff(map.m_pa);
 
-		/* deal with inline page */
-		if (map.m_flags & EROFS_MAP_META) {
-			void *vsrc, *vto;
-			struct page *ipage;
+	/* deal with inline page */
+	if (map.m_flags & EROFS_MAP_META) {
+		struct page *ipage;
+		void *addr;
 
-			DBG_BUGON(map.m_plen > PAGE_SIZE);
+		DBG_BUGON(map.m_plen > PAGE_SIZE);
 
-			ipage = erofs_get_meta_page(inode->i_sb, blknr, 0);
+		ipage = erofs_get_meta_page(inode->i_sb, blknr, false);
+		if (IS_ERR(ipage))
+			return PTR_ERR(ipage);
 
-			if (IS_ERR(ipage)) {
-				err = PTR_ERR(ipage);
-				goto err_out;
-			}
-
-			vsrc = kmap_atomic(ipage);
-			vto = kmap_atomic(page);
-			memcpy(vto, vsrc + blkoff, map.m_plen);
-			memset(vto + map.m_plen, 0, PAGE_SIZE - map.m_plen);
-			kunmap_atomic(vto);
-			kunmap_atomic(vsrc);
-			flush_dcache_page(page);
-
-			SetPageUptodate(page);
-			/* TODO: could we unlock the page earlier? */
-			unlock_page(ipage);
-			put_page(ipage);
+		addr = kmap_atomic(ipage);
 
-			/* imply err = 0, see erofs_map_blocks */
-			goto has_updated;
-		}
-
-		/* pa must be block-aligned for raw reading */
-		DBG_BUGON(erofs_blkoff(map.m_pa));
-
-		/* max # of continuous pages */
-		if (nblocks > DIV_ROUND_UP(map.m_plen, PAGE_SIZE))
-			nblocks = DIV_ROUND_UP(map.m_plen, PAGE_SIZE);
-		if (nblocks > BIO_MAX_PAGES)
-			nblocks = BIO_MAX_PAGES;
-
-		bio = erofs_grab_bio(sb, blknr, nblocks, sb,
-				     read_endio, false);
-		if (IS_ERR(bio)) {
-			err = PTR_ERR(bio);
-			bio = NULL;
-			goto err_out;
-		}
+		iomap->addr = map.m_pa;
+		iomap->offset = map.m_la;
+		iomap->length = map.m_plen;
+		if (!map.m_la)
+			iomap->type = IOMAP_INLINE;
+		else
+			iomap->type = IOMAP_TAIL;
+		iomap->private = addr;
+		iomap->inline_data = addr + blkoff;
+		return 0;
 	}
 
-	err = bio_add_page(bio, page, PAGE_SIZE, 0);
-	/* out of the extent or bio is full */
-	if (err < PAGE_SIZE)
-		goto submit_bio_retry;
+	/* pa must be block-aligned for raw reading */
+	DBG_BUGON(blkoff);
 
-	*last_block = current_block;
+	iomap->addr = map.m_pa;
+	iomap->offset = map.m_la;
+	iomap->length = map.m_llen;
+	iomap->type = IOMAP_MAPPED;
+	iomap->flags |= IOMAP_F_MERGED;
+	iomap->bdev = inode->i_sb->s_bdev;
+	return 0;
+}
 
-	/* shift in advance in case of it followed by too many gaps */
-	if (bio->bi_iter.bi_size >= bio->bi_max_vecs * PAGE_SIZE) {
-		/* err should reassign to 0 after submitting */
-		err = 0;
-		goto submit_bio_out;
-	}
+static int erofs_iomap_end(struct inode *inode, loff_t pos,
+			   loff_t length, ssize_t written,
+			   unsigned int flags, struct iomap *iomap)
+{
+	if (iomap->type == IOMAP_INLINE || iomap->type == IOMAP_TAIL) {
+		struct page *ipage;
+		void *addr = (void *)iomap->private;
 
-	return bio;
+		kunmap_atomic(addr);
 
-err_out:
-	/* for sync reading, set page error immediately */
-	if (!ra) {
-		SetPageError(page);
-		ClearPageUptodate(page);
-	}
-has_updated:
-	unlock_page(page);
-
-	/* if updated manually, continuous pages has a gap */
-	if (bio)
-submit_bio_out:
-		__submit_bio(bio, REQ_OP_READ, 0);
+		ipage = __erofs_find_meta_page(inode->i_sb,
+					       erofs_blknr(iomap->addr));
+		DBG_BUGON(!ipage);
 
-	return unlikely(err) ? ERR_PTR(err) : NULL;
+		unlock_page(ipage);
+		put_page(ipage);
+		put_page(ipage);
+	}
+	return 0;
 }
 
+const struct iomap_ops erofs_iomap_ops = {
+	.iomap_begin		= erofs_iomap_begin,
+	.iomap_end		= erofs_iomap_end,
+};
+
 /*
  * since we dont have write or truncate flows, so no inode
  * locking needs to be held at the moment.
  */
 static int erofs_raw_access_readpage(struct file *file, struct page *page)
 {
-	erofs_off_t last_block;
-	struct bio *bio;
-
 	trace_erofs_readpage(page, true);
-
-	bio = erofs_read_raw_page(NULL, page->mapping,
-				  page, &last_block, 1, false);
-
-	if (IS_ERR(bio))
-		return PTR_ERR(bio);
-
-	DBG_BUGON(bio);	/* since we have only one bio -- must be NULL */
-	return 0;
+	return iomap_readpage(page, &erofs_iomap_ops);
 }
 
 static int erofs_raw_access_readpages(struct file *filp,
@@ -353,42 +302,10 @@ static int erofs_raw_access_readpages(struct file *filp,
 				      struct list_head *pages,
 				      unsigned int nr_pages)
 {
-	erofs_off_t last_block;
-	struct bio *bio = NULL;
-	gfp_t gfp = readahead_gfp_mask(mapping);
 	struct page *page = list_last_entry(pages, struct page, lru);
 
 	trace_erofs_readpages(mapping->host, page, nr_pages, true);
-
-	for (; nr_pages; --nr_pages) {
-		page = list_entry(pages->prev, struct page, lru);
-
-		prefetchw(&page->flags);
-		list_del(&page->lru);
-
-		if (!add_to_page_cache_lru(page, mapping, page->index, gfp)) {
-			bio = erofs_read_raw_page(bio, mapping, page,
-						  &last_block, nr_pages, true);
-
-			/* all the page errors are ignored when readahead */
-			if (IS_ERR(bio)) {
-				pr_err("%s, readahead error at page %lu of nid %llu\n",
-				       __func__, page->index,
-				       EROFS_V(mapping->host)->nid);
-
-				bio = NULL;
-			}
-		}
-
-		/* pages could still be locked */
-		put_page(page);
-	}
-	DBG_BUGON(!list_empty(pages));
-
-	/* the rare case (end in gaps) */
-	if (unlikely(bio))
-		__submit_bio(bio, REQ_OP_READ, 0);
-	return 0;
+	return iomap_readpages(mapping, pages, nr_pages, &erofs_iomap_ops);
 }
 
 /* for uncompressed (aligned) files and raw access for other files */
-- 
2.18.0.rc1
