From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 10:01:22 +0800
Subject: [PATCH 02/11] erofs: fix to avoid potential overflow
In-Reply-To: <20180622020131.65525-1-yuchao0@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
Message-ID: <20180622020131.65525-2-yuchao0@huawei.com>

Previsouly, we use 32bit unsigned variable to store 64bits page->index's
value, it will cause potential overflow, fix it.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/data.c     | 8 ++++----
 fs/erofs/internal.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 432581d4ed0c..e76de71c85ff 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -200,12 +200,12 @@ static inline struct bio *erofs_read_raw_page(
 	struct bio *bio,
 	struct address_space *mapping,
 	struct page *page,
-	unsigned *last_block,
+	erofs_off_t *last_block,
 	unsigned nblocks,
 	bool ra)
 {
 	struct inode *inode = mapping->host;
-	unsigned current_block = page->index;
+	erofs_off_t current_block = (erofs_off_t)page->index;
 	int err;
 
 	BUG_ON(!nblocks);
@@ -334,7 +334,7 @@ static inline struct bio *erofs_read_raw_page(
  */
 static int erofs_raw_access_readpage(struct file *file, struct page *page)
 {
-	unsigned last_block;
+	erofs_off_t last_block;
 	struct bio *bio;
 
 	bio = erofs_read_raw_page(NULL, page->mapping,
@@ -351,7 +351,7 @@ static int erofs_raw_access_readpages(struct file *filp,
 	struct address_space *mapping,
 	struct list_head *pages, unsigned nr_pages)
 {
-	unsigned last_block;
+	erofs_off_t last_block;
 	struct bio *bio = NULL;
 	gfp_t gfp = readahead_gfp_mask(mapping);
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 0606a50a0067..7670c2ed53d2 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -127,7 +127,7 @@ static inline erofs_off_t iloc(struct erofs_sb_info *sbi, erofs_nid_t nid)
 
 #define erofs_blknr(addr)       ((addr) / EROFS_BLKSIZ)
 #define erofs_blkoff(addr)      ((addr) % EROFS_BLKSIZ)
-#define blknr_to_addr(nr)       ((nr) * EROFS_BLKSIZ)
+#define blknr_to_addr(nr)       ((erofs_off_t)(nr) * EROFS_BLKSIZ)
 
 #define inode_set_inited_xattr(inode)   (EROFS_V(inode)->flags |= 1)
 #define inode_has_inited_xattr(inode)   (EROFS_V(inode)->flags & 1)
-- 
2.18.0.rc1
