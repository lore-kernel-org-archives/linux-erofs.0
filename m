From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 20 Feb 2019 17:18:52 +0800
Subject: [PATCH for-4.19 10/12] staging: erofs: {dir, inode,
 super}.c: rectify BUG_ONs
In-Reply-To: <20190220091854.19242-1-gaoxiang25@huawei.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
Message-ID: <20190220091854.19242-11-gaoxiang25@huawei.com>

commit 8b987bca2d09649683cbe496419a011df8c08493 upstream.

remove all redundant BUG_ONs, and turn the rest
useful usages to DBG_BUGONs.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>

Conflicts:
	drivers/staging/erofs/super.c

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/dir.c   |  7 +++++--
 drivers/staging/erofs/inode.c | 10 ++++++++--
 drivers/staging/erofs/super.c | 13 ++++++-------
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
index be6ae3b1bdbe..04b84ff31d03 100644
--- a/drivers/staging/erofs/dir.c
+++ b/drivers/staging/erofs/dir.c
@@ -53,8 +53,11 @@ static int erofs_fill_dentries(struct dir_context *ctx,
 			strnlen(de_name, maxsize - nameoff) :
 			le16_to_cpu(de[1].nameoff) - nameoff;
 
-		/* the corrupted directory found */
-		BUG_ON(de_namelen < 0);
+		/* a corrupted entry is found */
+		if (unlikely(de_namelen < 0)) {
+			DBG_BUGON(1);
+			return -EIO;
+		}
 
 #ifdef CONFIG_EROFS_FS_DEBUG
 		dbg_namelen = min(EROFS_NAME_LEN - 1, de_namelen);
diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index fbf6ff25cd1b..9e7815f55a17 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -132,7 +132,13 @@ static int fill_inline_data(struct inode *inode, void *data, unsigned m_pofs)
 			return -ENOMEM;
 
 		m_pofs += vi->inode_isize + vi->xattr_isize;
-		BUG_ON(m_pofs + inode->i_size > PAGE_SIZE);
+
+		/* inline symlink data shouldn't across page boundary as well */
+		if (unlikely(m_pofs + inode->i_size > PAGE_SIZE)) {
+			DBG_BUGON(1);
+			kfree(lnk);
+			return -EIO;
+		}
 
 		/* get in-page inline data */
 		memcpy(lnk, data + m_pofs, inode->i_size);
@@ -170,7 +176,7 @@ static int fill_inode(struct inode *inode, int isdir)
 		return PTR_ERR(page);
 	}
 
-	BUG_ON(!PageUptodate(page));
+	DBG_BUGON(!PageUptodate(page));
 	data = page_address(page);
 
 	err = read_inode(inode, data + ofs);
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 434616b3e76c..b0583cdb079a 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -40,7 +40,6 @@ static int erofs_init_inode_cache(void)
 
 static void erofs_exit_inode_cache(void)
 {
-	BUG_ON(erofs_inode_cachep == NULL);
 	kmem_cache_destroy(erofs_inode_cachep);
 }
 
@@ -265,8 +264,8 @@ static int managed_cache_releasepage(struct page *page, gfp_t gfp_mask)
 	int ret = 1;	/* 0 - busy */
 	struct address_space *const mapping = page->mapping;
 
-	BUG_ON(!PageLocked(page));
-	BUG_ON(mapping->a_ops != &managed_cache_aops);
+	DBG_BUGON(!PageLocked(page));
+	DBG_BUGON(mapping->a_ops != &managed_cache_aops);
 
 	if (PagePrivate(page))
 		ret = erofs_try_to_free_cached_page(mapping, page);
@@ -279,10 +278,10 @@ static void managed_cache_invalidatepage(struct page *page,
 {
 	const unsigned int stop = length + offset;
 
-	BUG_ON(!PageLocked(page));
+	DBG_BUGON(!PageLocked(page));
 
-	/* Check for overflow */
-	BUG_ON(stop > PAGE_SIZE || stop < length);
+	/* Check for potential overflow in debug mode */
+	DBG_BUGON(stop > PAGE_SIZE || stop < length);
 
 	if (offset == 0 && stop == PAGE_SIZE)
 		while (!managed_cache_releasepage(page, GFP_NOFS))
@@ -619,7 +618,7 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 
 static int erofs_remount(struct super_block *sb, int *flags, char *data)
 {
-	BUG_ON(!sb_rdonly(sb));
+	DBG_BUGON(!sb_rdonly(sb));
 
 	*flags |= SB_RDONLY;
 	return 0;
-- 
2.14.4
