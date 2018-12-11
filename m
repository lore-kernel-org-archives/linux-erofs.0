From: aaron.strahlberger@posteo.de (Aaron Strahlberger)
Date: Tue, 11 Dec 2018 11:54:40 +0100
Subject: [PATCH 2/5] drivers: staging: erofs: Fix comparison to NULL issues.
In-Reply-To: <20181211105443.21826-1-aaron.strahlberger@posteo.de>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181211105443.21826-1-aaron.strahlberger@posteo.de>
Message-ID: <20181211105443.21826-3-aaron.strahlberger@posteo.de>

Fix of 7 `CHECK: Comparison to NULL could be written ...` issues.

Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
Signed-off-by: Dominik Huber <domi250 at gmx.de>
---
 drivers/staging/erofs/data.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index d1c0a7be6eb8..5a55f0bfdfbb 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -53,7 +53,7 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
 
 repeat:
 	page = find_or_create_page(mapping, blkaddr, gfp);
-	if (unlikely(page == NULL)) {
+	if (unlikely(!page)) {
 		DBG_BUGON(nofail);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -167,16 +167,17 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 
 #ifdef CONFIG_EROFS_FS_ZIP
 extern int z_erofs_map_blocks_iter(struct inode *,
-	struct erofs_map_blocks *, struct page **, int);
+				   struct erofs_map_blocks *,
+				   struct page **, int);
 #endif
 
 int erofs_map_blocks_iter(struct inode *inode,
-	struct erofs_map_blocks *map,
-	struct page **mpage_ret, int flags)
+			  struct erofs_map_blocks *map,
+			  struct page **mpage_ret, int flags)
 {
 	/* by default, reading raw data never use erofs_map_blocks_iter */
 	if (unlikely(!is_inode_layout_compression(inode))) {
-		if (*mpage_ret != NULL)
+		if (*mpage_ret)
 			put_page(*mpage_ret);
 		*mpage_ret = NULL;
 
@@ -231,15 +232,15 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 	}
 
 	/* note that for readpage case, bio also equals to NULL */
-	if (bio != NULL &&
-		/* not continuous */
-		*last_block + 1 != current_block) {
+	if (bio &&
+	    /* not continuous */
+	    *last_block + 1 != current_block) {
 submit_bio_retry:
 		__submit_bio(bio, REQ_OP_READ, 0);
 		bio = NULL;
 	}
 
-	if (bio == NULL) {
+	if (!bio) {
 		struct erofs_map_blocks map = {
 			.m_la = blknr_to_addr(current_block),
 		};
@@ -341,7 +342,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 	unlock_page(page);
 
 	/* if updated manually, continuous pages has a gap */
-	if (bio != NULL)
+	if (bio)
 submit_bio_out:
 		__submit_bio(bio, REQ_OP_READ, 0);
 
@@ -407,7 +408,7 @@ static int erofs_raw_access_readpages(struct file *filp,
 	DBG_BUGON(!list_empty(pages));
 
 	/* the rare case (end in gaps) */
-	if (unlikely(bio != NULL))
+	if (unlikely(bio))
 		__submit_bio(bio, REQ_OP_READ, 0);
 	return 0;
 }
-- 
2.19.2
