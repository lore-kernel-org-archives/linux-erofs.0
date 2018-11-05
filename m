From: digholebhagyashri@gmail.com (Bhagyashri P. Dighole)
Date: Mon, 5 Nov 2018 14:50:35 +0000
Subject: [PATCH v3 2/2] staging: erofs: Modify conditional checks
In-Reply-To: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
References: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
Message-ID:
 <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20181105145035.sgEqj8z-ejBKFmSdC5j_obQozs7BpFfpSvVpq3yY_-w@z>

Fix coding style alignment issues detected by checkpatch.pl
Use ! for NULL test rather than explicitly comparing to NULL.

Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
---
Changes in v3:
- Split patch in two patches. Each patch have similar       
  kind of changes. One patch for all alignment fixes and 
    second patch for all conditional check fixes.

Changes in v2:
- Fix for one alignment issue and one conditional check issue.

Changes in v1:
- Fix for all issues in data.c

 drivers/staging/erofs/data.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index b66191ad44aa..5a55f0bfdfbb 100644
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
@@ -177,7 +177,7 @@ int erofs_map_blocks_iter(struct inode *inode,
 {
 	/* by default, reading raw data never use erofs_map_blocks_iter */
 	if (unlikely(!is_inode_layout_compression(inode))) {
-		if (*mpage_ret != NULL)
+		if (*mpage_ret)
 			put_page(*mpage_ret);
 		*mpage_ret = NULL;
 
@@ -200,7 +200,7 @@ int erofs_map_blocks(struct inode *inode,
 		int err;
 
 		err = erofs_map_blocks_iter(inode, map, &mpage, flags);
-		if (mpage != NULL)
+		if (mpage)
 			put_page(mpage);
 		return err;
 	}
@@ -232,7 +232,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 	}
 
 	/* note that for readpage case, bio also equals to NULL */
-	if (bio != NULL &&
+	if (bio &&
 	    /* not continuous */
 	    *last_block + 1 != current_block) {
 submit_bio_retry:
@@ -240,7 +240,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 		bio = NULL;
 	}
 
-	if (bio == NULL) {
+	if (!bio) {
 		struct erofs_map_blocks map = {
 			.m_la = blknr_to_addr(current_block),
 		};
@@ -342,7 +342,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 	unlock_page(page);
 
 	/* if updated manually, continuous pages has a gap */
-	if (bio != NULL)
+	if (bio)
 submit_bio_out:
 		__submit_bio(bio, REQ_OP_READ, 0);
 
@@ -408,7 +408,7 @@ static int erofs_raw_access_readpages(struct file *filp,
 	DBG_BUGON(!list_empty(pages));
 
 	/* the rare case (end in gaps) */
-	if (unlikely(bio != NULL))
+	if (unlikely(bio))
 		__submit_bio(bio, REQ_OP_READ, 0);
 	return 0;
 }
-- 
2.19.1
