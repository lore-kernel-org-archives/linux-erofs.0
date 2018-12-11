From: aaron.strahlberger@posteo.de (Aaron Strahlberger)
Date: Tue, 11 Dec 2018 10:06:27 +0100
Subject: [PATCH] drivers: staging: erofs: Fix styling issues
Message-ID: <20181211090627.2194-1-aaron.strahlberger@posteo.de>

Fixed following checkpatch.pl styling issues:

- 17x CHECK: Alignment should match open parenthesis
-  7x CHECK: Comparison to NULL could be written ...
-  1x CHECK: Lines should not end with a '('
-  1x CHECK: Please use a blank line after ...

Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
Signed-off-by: Dominik Huber <domi250 at gmx.de>
---
 drivers/staging/erofs/data.c     | 65 ++++++++++++++++----------------
 drivers/staging/erofs/dir.c      | 12 +++---
 drivers/staging/erofs/erofs_fs.h |  5 ++-
 3 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 6384f73e5418..5a55f0bfdfbb 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -40,7 +40,7 @@ static inline void read_endio(struct bio *bio)
 
 /* prio -- true is used for dir */
 struct page *__erofs_get_meta_page(struct super_block *sb,
-	erofs_blk_t blkaddr, bool prio, bool nofail)
+				   erofs_blk_t blkaddr, bool prio, bool nofail)
 {
 	struct inode *const bd_inode = sb->s_bdev->bd_inode;
 	struct address_space *const mapping = bd_inode->i_mapping;
@@ -53,7 +53,7 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
 
 repeat:
 	page = find_or_create_page(mapping, blkaddr, gfp);
-	if (unlikely(page == NULL)) {
+	if (unlikely(!page)) {
 		DBG_BUGON(nofail);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -76,7 +76,7 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
 		}
 
 		__submit_bio(bio, REQ_OP_READ,
-			REQ_META | (prio ? REQ_PRIO : 0));
+			     REQ_META | (prio ? REQ_PRIO : 0));
 
 		lock_page(page);
 
@@ -107,8 +107,8 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
 }
 
 static int erofs_map_blocks_flatmode(struct inode *inode,
-	struct erofs_map_blocks *map,
-	int flags)
+				     struct erofs_map_blocks *map,
+				     int flags)
 {
 	int err = 0;
 	erofs_blk_t nblocks, lastblk;
@@ -151,7 +151,7 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 		map->m_flags |= EROFS_MAP_META;
 	} else {
 		errln("internal error @ nid: %llu (size %llu), m_la 0x%llx",
-			vi->nid, inode->i_size, map->m_la);
+		      vi->nid, inode->i_size, map->m_la);
 		DBG_BUGON(1);
 		err = -EIO;
 		goto err_out;
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
 
@@ -192,27 +193,26 @@ int erofs_map_blocks_iter(struct inode *inode,
 }
 
 int erofs_map_blocks(struct inode *inode,
-	struct erofs_map_blocks *map, int flags)
+		     struct erofs_map_blocks *map, int flags)
 {
 	if (unlikely(is_inode_layout_compression(inode))) {
 		struct page *mpage = NULL;
 		int err;
 
 		err = erofs_map_blocks_iter(inode, map, &mpage, flags);
-		if (mpage != NULL)
+		if (mpage)
 			put_page(mpage);
 		return err;
 	}
 	return erofs_map_blocks_flatmode(inode, map, flags);
 }
 
-static inline struct bio *erofs_read_raw_page(
-	struct bio *bio,
-	struct address_space *mapping,
-	struct page *page,
-	erofs_off_t *last_block,
-	unsigned int nblocks,
-	bool ra)
+static inline struct bio *erofs_read_raw_page(struct bio *bio,
+					      struct address_space *mapping,
+					      struct page *page,
+					      erofs_off_t *last_block,
+					      unsigned int nblocks,
+					      bool ra)
 {
 	struct inode *inode = mapping->host;
 	erofs_off_t current_block = (erofs_off_t)page->index;
@@ -232,15 +232,15 @@ static inline struct bio *erofs_read_raw_page(
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
@@ -307,7 +307,7 @@ static inline struct bio *erofs_read_raw_page(
 			nblocks = BIO_MAX_PAGES;
 
 		bio = erofs_grab_bio(inode->i_sb,
-			blknr, nblocks, read_endio, false);
+				     blknr, nblocks, read_endio, false);
 
 		if (IS_ERR(bio)) {
 			err = PTR_ERR(bio);
@@ -342,7 +342,7 @@ static inline struct bio *erofs_read_raw_page(
 	unlock_page(page);
 
 	/* if updated manually, continuous pages has a gap */
-	if (bio != NULL)
+	if (bio)
 submit_bio_out:
 		__submit_bio(bio, REQ_OP_READ, 0);
 
@@ -361,7 +361,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 	trace_erofs_readpage(page, true);
 
 	bio = erofs_read_raw_page(NULL, page->mapping,
-		page, &last_block, 1, false);
+				  page, &last_block, 1, false);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
@@ -371,8 +371,9 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 }
 
 static int erofs_raw_access_readpages(struct file *filp,
-	struct address_space *mapping,
-	struct list_head *pages, unsigned int nr_pages)
+				      struct address_space *mapping,
+				      struct list_head *pages,
+				      unsigned int nr_pages)
 {
 	erofs_off_t last_block;
 	struct bio *bio = NULL;
@@ -389,13 +390,13 @@ static int erofs_raw_access_readpages(struct file *filp,
 
 		if (!add_to_page_cache_lru(page, mapping, page->index, gfp)) {
 			bio = erofs_read_raw_page(bio, mapping, page,
-				&last_block, nr_pages, true);
+						  &last_block, nr_pages, true);
 
 			/* all the page errors are ignored when readahead */
 			if (IS_ERR(bio)) {
 				pr_err("%s, readahead error at page %lu of nid %llu\n",
-					__func__, page->index,
-					EROFS_V(mapping->host)->nid);
+				       __func__, page->index,
+				       EROFS_V(mapping->host)->nid);
 
 				bio = NULL;
 			}
@@ -407,7 +408,7 @@ static int erofs_raw_access_readpages(struct file *filp,
 	DBG_BUGON(!list_empty(pages));
 
 	/* the rare case (end in gaps) */
-	if (unlikely(bio != NULL))
+	if (unlikely(bio))
 		__submit_bio(bio, REQ_OP_READ, 0);
 	return 0;
 }
diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
index d1cb0d78ab84..e83475260106 100644
--- a/drivers/staging/erofs/dir.c
+++ b/drivers/staging/erofs/dir.c
@@ -24,8 +24,8 @@ static const unsigned char erofs_filetype_table[EROFS_FT_MAX] = {
 };
 
 static int erofs_fill_dentries(struct dir_context *ctx,
-	void *dentry_blk, unsigned int *ofs,
-	unsigned int nameoff, unsigned int maxsize)
+			       void *dentry_blk, unsigned int *ofs,
+			       unsigned int nameoff, unsigned int maxsize)
 {
 	struct erofs_dirent *de = dentry_blk;
 	const struct erofs_dirent *end = dentry_blk + nameoff;
@@ -66,8 +66,8 @@ static int erofs_fill_dentries(struct dir_context *ctx,
 #endif
 
 		if (!dir_emit(ctx, de_name, de_namelen,
-					le64_to_cpu(de->nid), d_type))
-			/* stoped by some reason */
+			      le64_to_cpu(de->nid), d_type))
+			/* stopped by some reason */
 			return 1;
 		++de;
 		*ofs += sizeof(struct erofs_dirent);
@@ -101,9 +101,9 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 		nameoff = le16_to_cpu(de->nameoff);
 
 		if (unlikely(nameoff < sizeof(struct erofs_dirent) ||
-			nameoff >= PAGE_SIZE)) {
+			     nameoff >= PAGE_SIZE)) {
 			errln("%s, invalid de[0].nameoff %u",
-				__func__, nameoff);
+			      __func__, nameoff);
 
 			err = -EIO;
 			goto skip_this;
diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index d4bffa2852b3..6a8c51d6ad61 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -38,9 +38,9 @@ struct erofs_super_block {
 /* 80 */__u8 reserved2[48];     /* 128 bytes */
 } __packed;
 
-#define __EROFS_BIT(_prefix, _cur, _pre)	enum {	\
+#define __EROFS_BIT(_prefix, _cur, _pre)	(enum { \
 	_prefix ## _cur ## _BIT = _prefix ## _pre ## _BIT + \
-		_prefix ## _pre ## _BITS }
+	_prefix ## _pre ## _BITS })
 
 /*
  * erofs inode data mapping:
@@ -58,6 +58,7 @@ enum {
 	EROFS_INODE_LAYOUT_INLINE,
 	EROFS_INODE_LAYOUT_MAX
 };
+
 #define EROFS_I_VERSION_BITS            1
 #define EROFS_I_DATA_MAPPING_BITS       3
 
-- 
2.19.2
