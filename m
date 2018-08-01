From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 1 Aug 2018 14:04:19 +0800
Subject: [PREVIEW] [PATCH RESEND 2/4] staging: erofs: introduce erofs_grab_bio
In-Reply-To: <1533103277-20856-2-git-send-email-gaoxiang25@huawei.com>
References: <1533103277-20856-2-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533103459-21338-1-git-send-email-gaoxiang25@huawei.com>

this patch renames prepare_bio to erofs_grab_bio, and
adds a nofail option in order to retry in the bio allocator.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/data.c      | 12 ++++++++++--
 drivers/staging/erofs/internal.h  | 35 +++++++++++++++++------------------
 drivers/staging/erofs/unzip_vle.c |  4 ++--
 3 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index ac263a1..2426eda 100644
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
+		if (unlikely(IS_ERR(bio))) {
+			err = PTR_ERR(bio);
+			bio = NULL;
+			goto err_out;
+		}
 	}
 
 	err = bio_add_page(bio, page, PAGE_SIZE, 0);
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 4518729..acce2d6 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -419,26 +419,25 @@ struct erofs_map_blocks {
 #define EROFS_GET_BLOCKS_RAW    0x0001
 
 /* data.c */
-static inline struct bio *prepare_bio(
-	struct super_block *sb,
-	erofs_blk_t blkaddr, unsigned nr_pages,
-	bio_end_io_t endio)
+static inline struct bio *
+erofs_grab_bio(struct super_block *sb,
+	       erofs_blk_t blkaddr, unsigned nr_pages,
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
+		}
+		bio = bio_alloc(gfp, nr_pages);
+		nr_pages /= 2;
+	} while (unlikely(bio == NULL));
 
 	bio->bi_end_io = endio;
 	bio_set_dev(bio, sb->s_bdev);
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 6d3ab31..be3929d 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1212,8 +1212,8 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		}
 
 		if (bio == NULL) {
-			bio = prepare_bio(sb, first_index + i,
-				BIO_MAX_PAGES, z_erofs_vle_read_endio);
+			bio = erofs_grab_bio(sb, first_index + i,
+				BIO_MAX_PAGES, z_erofs_vle_read_endio, true);
 			bio->bi_private = tagptr_cast_ptr(bi_private);
 
 			++nr_bios;
-- 
1.9.1
