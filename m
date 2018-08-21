From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 21 Aug 2018 14:50:56 +0800
Subject: [PREVIEW] [PATCH 1/3] staging: erofs: cleanup
 z_erofs_vle_normalaccess_readpages
Message-ID: <1534834258-36401-1-git-send-email-gaoxiang25@huawei.com>

This patch introduces __should_decompress_synchronously to
cleanup z_erofs_vle_normalaccess_readpages.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

Hi,

These patches are based on commit
staging: erofs: add trace points for reading zipped data

several cleanups for the upcoming bugfixes.

Thanks,
Gao Xiang

 drivers/staging/erofs/internal.h  | 11 +++++++++++
 drivers/staging/erofs/super.c     |  5 +++++
 drivers/staging/erofs/unzip_vle.c | 20 ++++++--------------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 8951e01..bd2987a 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -95,6 +95,9 @@ struct erofs_sb_info {
 	/* the dedicated workstation for compression */
 	struct radix_tree_root workstn_tree;
 
+	/* threshold for decompression synchronously */
+	unsigned int min_async_decompress_pages;
+
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 	struct inode *managed_cache;
 #endif
@@ -266,6 +269,14 @@ extern int erofs_try_to_free_cached_page(struct address_space *mapping,
 	struct page *page);
 #endif
 
+#define DEFAULT_MIN_ASYNC_DECOMPRESS_PAGES	5
+
+static inline bool __should_decompress_synchronously(struct erofs_sb_info *sbi,
+						     unsigned int nr)
+{
+	return nr < sbi->min_async_decompress_pages;
+}
+
 #endif
 
 /* we strictly follow PAGE_SIZE and no buffer head yet */
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 93548b9..708211d 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -162,6 +162,11 @@ static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
 
 static void default_options(struct erofs_sb_info *sbi)
 {
+	/* set up some FS parameters */
+#ifdef CONFIG_EROFS_FS_ZIP
+	sbi->min_async_decompress_pages = DEFAULT_MIN_ASYNC_DECOMPRESS_PAGES;
+#endif
+
 #ifdef CONFIG_EROFS_FS_XATTR
 	set_opt(sbi, XATTR_USER);
 #endif
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 3cd0c10..391277f 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1340,12 +1340,14 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	return 0;
 }
 
-static inline int __z_erofs_vle_normalaccess_readpages(
-	struct file *filp,
-	struct address_space *mapping,
-	struct list_head *pages, unsigned nr_pages, bool sync)
+static int z_erofs_vle_normalaccess_readpages(struct file *filp,
+					      struct address_space *mapping,
+					      struct list_head *pages,
+					      unsigned int nr_pages)
 {
 	struct inode *const inode = mapping->host;
+	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
+	const bool sync = __should_decompress_synchronously(sbi, nr_pages);
 
 	struct z_erofs_vle_frontend f = VLE_FRONTEND_INIT(inode);
 	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
@@ -1403,16 +1405,6 @@ static inline int __z_erofs_vle_normalaccess_readpages(
 	return 0;
 }
 
-static int z_erofs_vle_normalaccess_readpages(
-	struct file *filp,
-	struct address_space *mapping,
-	struct list_head *pages, unsigned nr_pages)
-{
-	return __z_erofs_vle_normalaccess_readpages(filp,
-		mapping, pages, nr_pages,
-		nr_pages < 4 /* sync */);
-}
-
 const struct address_space_operations z_erofs_vle_normalaccess_aops = {
 	.readpage = z_erofs_vle_normalaccess_readpage,
 	.readpages = z_erofs_vle_normalaccess_readpages,
-- 
1.9.1
