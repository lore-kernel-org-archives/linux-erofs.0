From: chao@kernel.org (Chao Yu)
Date: Sun, 12 Aug 2018 22:01:43 +0800
Subject: [PATCH 1/8] staging: erofs: introduce erofs_grab_bio
In-Reply-To: <20180812140150.13397-1-chao@kernel.org>
References: <20180812140150.13397-1-chao@kernel.org>
Message-ID: <20180812140150.13397-2-chao@kernel.org>

From: Gao Xiang <gaoxiang25@huawei.com>

this patch renames prepare_bio to erofs_grab_bio, and
adds a nofail option in order to retry in the bio allocator
under memory pressure.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/data.c      | 12 +++++++++--
 drivers/staging/erofs/internal.h  | 36 +++++++++++++++----------------
 drivers/staging/erofs/unzip_vle.c |  4 ++--
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index ac263a180253..e0c046df6665 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -60,7 +60,8 @@ struct page *erofs_get_meta_page(struct super_block *sb,
 		struct bio *bio;
 		int err;
 
-		bio = prepare_bio(sb, blkaddr, 1, read_endio);
+		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, true);
+
 		err = bio_add_page(bio, page, PAGE_SIZE, 0);
 		BUG_ON(err != PAGE_SIZE);
 
@@ -278,7 +279,14 @@ static inline struct bio *erofs_read_raw_page(
 		if (nblocks > BIO_MAX_PAGES)
 			nblocks = BIO_MAX_PAGES;
 
-		bio = prepare_bio(inode->i_sb, blknr, nblocks, read_endio);
+		bio = erofs_grab_bio(inode->i_sb,
+			blknr, nblocks, read_endio, false);
+
+		if (IS_ERR(bio)) {
+			err = PTR_ERR(bio);
+			bio = NULL;
+			goto err_out;
+		}
 	}
 
 	err = bio_add_page(bio, page, PAGE_SIZE, 0);
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 367b39fe46e5..1353b3ff8401 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -420,26 +420,26 @@ struct erofs_map_blocks {
 #define EROFS_GET_BLOCKS_RAW    0x0001
 
 /* data.c */
-static inline struct bio *prepare_bio(
-	struct super_block *sb,
-	erofs_blk_t blkaddr, unsigned nr_pages,
-	bio_end_io_t endio)
+static inline struct bio *
+erofs_grab_bio(struct super_block *sb,
+	       erofs_blk_t blkaddr, unsigned int nr_pages,
+	       bio_end_io_t endio, bool nofail)
 {
-	gfp_t gfp = GFP_NOIO;
-	struct bio *bio = bio_alloc(gfp, nr_pages);
-
-	if (unlikely(bio == NULL) &&
-		(current->flags & PF_MEMALLOC)) {
-		do {
-			nr_pages /= 2;
-			if (unlikely(!nr_pages)) {
-				bio = bio_alloc(gfp | __GFP_NOFAIL, 1);
-				BUG_ON(bio == NULL);
-				break;
+	const gfp_t gfp = GFP_NOIO;
+	struct bio *bio;
+
+	do {
+		if (nr_pages == 1) {
+			bio = bio_alloc(gfp | (nofail ? __GFP_NOFAIL : 0), 1);
+			if (unlikely(bio == NULL)) {
+				DBG_BUGON(nofail);
+				return ERR_PTR(-ENOMEM);
 			}
-			bio = bio_alloc(gfp, nr_pages);
-		} while (bio == NULL);
-	}
+			break;
+		}
+		bio = bio_alloc(gfp, nr_pages);
+		nr_pages /= 2;
+	} while (unlikely(bio == NULL));
 
 	bio->bi_end_io = endio;
 	bio_set_dev(bio, sb->s_bdev);
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 8721f0a41d15..375c1711bb6b 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1213,8 +1213,8 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		}
 
 		if (bio == NULL) {
-			bio = prepare_bio(sb, first_index + i,
-				BIO_MAX_PAGES, z_erofs_vle_read_endio);
+			bio = erofs_grab_bio(sb, first_index + i,
+				BIO_MAX_PAGES, z_erofs_vle_read_endio, true);
 			bio->bi_private = tagptr_cast_ptr(bi_private);
 
 			++nr_bios;
-- 
2.18.0
