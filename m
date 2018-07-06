From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 7 Jul 2018 00:50:50 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.6 05/10] erofs: globalize prepare_bio
 and __submit_bio
In-Reply-To: <1530895855-101838-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530895855-101838-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530895855-101838-6-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/data.c     | 41 +++++++++--------------------------------
 fs/erofs/internal.h | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index de99217..2efe69f 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -47,33 +47,6 @@ static inline void read_endio(struct bio *bio)
 	bio_put(bio);
 }
 
-static void __submit_bio(struct bio *bio, unsigned op, unsigned op_flags)
-{
-	bio_set_op_attrs(bio, op, op_flags);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 8, 0))
-	submit_bio(0, bio);
-#else
-	submit_bio(bio);
-#endif
-}
-
-static struct bio *prepare_bio(struct super_block *sb,
-	erofs_blk_t blkaddr, unsigned nr_pages)
-{
-	struct bio *bio = bio_alloc(GFP_NOIO | __GFP_NOFAIL, nr_pages);
-
-	BUG_ON(bio == NULL);
-
-	bio->bi_end_io = read_endio;
-	bio_set_dev(bio, sb->s_bdev);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 0))
-	bio->bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
-#else
-	bio->bi_iter.bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
-#endif
-	return bio;
-}
-
 /* prio -- true is used for dir */
 struct page *erofs_get_meta_page(struct super_block *sb,
 	erofs_blk_t blkaddr, bool prio)
@@ -96,7 +69,7 @@ struct page *erofs_get_meta_page(struct super_block *sb,
 		struct bio *bio;
 		int err;
 
-		bio = prepare_bio(sb, blkaddr, 1);
+		bio = prepare_bio(sb, blkaddr, 1, read_endio);
 		err = bio_add_page(bio, page, PAGE_SIZE, 0);
 		BUG_ON(err != PAGE_SIZE);
 
@@ -237,6 +210,8 @@ static inline struct bio *erofs_read_raw_page(
 		struct erofs_map_blocks map = {
 			.m_la = blknr_to_addr(current_block),
 		};
+		erofs_blk_t blknr;
+		unsigned blkoff;
 
 		err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
 		if (unlikely(err))
@@ -254,6 +229,9 @@ static inline struct bio *erofs_read_raw_page(
 		/* for RAW access mode, m_plen must be equal to m_llen */
 		BUG_ON(map.m_plen != map.m_llen);
 
+		blknr = erofs_blknr(map.m_pa);
+		blkoff = erofs_blkoff(map.m_pa);
+
 		/* deal with inline page */
 		if (map.m_flags & EROFS_MAP_META) {
 			void *vsrc, *vto;
@@ -261,8 +239,7 @@ static inline struct bio *erofs_read_raw_page(
 
 			BUG_ON(map.m_plen > PAGE_SIZE);
 
-			ipage = erofs_get_meta_page(inode->i_sb,
-				erofs_blknr(map.m_pa), 0);
+			ipage = erofs_get_meta_page(inode->i_sb, blknr, 0);
 
 			if (IS_ERR(ipage)) {
 				err = PTR_ERR(ipage);
@@ -271,7 +248,7 @@ static inline struct bio *erofs_read_raw_page(
 
 			vsrc = kmap_atomic(ipage);
 			vto = kmap_atomic(page);
-			memcpy(vto, vsrc + erofs_blkoff(map.m_pa), map.m_plen);
+			memcpy(vto, vsrc + blkoff, map.m_plen);
 			memset(vto + map.m_plen, 0, PAGE_SIZE - map.m_plen);
 			kunmap_atomic(vto);
 			kunmap_atomic(vsrc);
@@ -295,7 +272,7 @@ static inline struct bio *erofs_read_raw_page(
 		if (nblocks > BIO_MAX_PAGES)
 			nblocks = BIO_MAX_PAGES;
 
-		bio = prepare_bio(inode->i_sb, erofs_blknr(map.m_pa), nblocks);
+		bio = prepare_bio(inode->i_sb, blknr, nblocks, read_endio);
 	}
 
 	err = bio_add_page(bio, page, PAGE_SIZE, 0);
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 07bab28..e60f535 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -291,6 +291,47 @@ struct erofs_map_blocks {
 #define EROFS_GET_BLOCKS_RAW    0x0001
 
 /* data.c */
+static inline struct bio *prepare_bio(
+	struct super_block *sb,
+	erofs_blk_t blkaddr, unsigned nr_pages,
+	bio_end_io_t endio)
+{
+	gfp_t gfp = GFP_NOIO;
+	struct bio *bio = bio_alloc(gfp, nr_pages);
+
+	if (unlikely(bio == NULL) &&
+		(current->flags & PF_MEMALLOC)) {
+		do {
+			nr_pages /= 2;
+			if (unlikely(!nr_pages)) {
+				bio = bio_alloc(gfp | __GFP_NOFAIL, 1);
+				BUG_ON(bio == NULL);
+				break;
+			}
+			bio = bio_alloc(gfp, nr_pages);
+		} while (bio == NULL);
+	}
+
+	bio->bi_end_io = endio;
+	bio_set_dev(bio, sb->s_bdev);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 0))
+	bio->bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
+#else
+	bio->bi_iter.bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
+#endif
+	return bio;
+}
+
+static inline void __submit_bio(struct bio *bio, unsigned op, unsigned op_flags)
+{
+	bio_set_op_attrs(bio, op, op_flags);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 8, 0))
+	submit_bio(0, bio);
+#else
+	submit_bio(bio);
+#endif
+}
+
 extern struct page *erofs_get_meta_page(struct super_block *sb,
 	erofs_blk_t blkaddr, bool prio);
 extern int erofs_map_blocks(struct inode *, struct erofs_map_blocks *, int);
-- 
1.9.1
