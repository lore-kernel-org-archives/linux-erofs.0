From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:54 +0800
Subject: [PATCH 17/22] staging: erofs: remove clusterbits in sbi
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-18-gaoxiang25@huawei.com>

clustersize can now be set on per-file basis
rather than per-filesystem basis.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 5 -----
 drivers/staging/erofs/super.c    | 9 ---------
 drivers/staging/erofs/zmap.c     | 3 +--
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index e35c7d8f75d2..be856c9facd1 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -77,8 +77,6 @@ struct erofs_sb_info {
 	struct list_head list;
 	struct mutex umount_mutex;
 
-	/* cluster size in bit shift */
-	unsigned char clusterbits;
 	/* the dedicated workstation for compression */
 	struct radix_tree_root workstn_tree;
 
@@ -267,9 +265,6 @@ static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 /* hard limit of pages per compressed cluster */
 #define Z_EROFS_CLUSTER_MAX_PAGES       (CONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT)
 
-/* page count of a compressed cluster */
-#define erofs_clusterpages(sbi)         ((1 << (sbi)->clusterbits) / PAGE_SIZE)
-
 #define EROFS_PCPUBUF_NR_PAGES          Z_EROFS_CLUSTER_MAX_PAGES
 #else
 #define EROFS_PCPUBUF_NR_PAGES          0
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index af5d87793e4d..dad5a3137988 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -124,15 +124,6 @@ static int superblock_read(struct super_block *sb)
 	sbi->xattr_blkaddr = le32_to_cpu(layout->xattr_blkaddr);
 #endif
 	sbi->islotbits = ffs(sizeof(struct erofs_inode_v1)) - 1;
-#ifdef CONFIG_EROFS_FS_ZIP
-	/* TODO: clusterbits should be related to inode */
-	sbi->clusterbits = blkszbits;
-
-	if (1 << (sbi->clusterbits - PAGE_SHIFT) > Z_EROFS_CLUSTER_MAX_PAGES)
-		errln("clusterbits %u is not supported on this kernel",
-		      sbi->clusterbits);
-#endif
-
 	sbi->root_nid = le16_to_cpu(layout->root_nid);
 	sbi->inos = le64_to_cpu(layout->inos);
 
diff --git a/drivers/staging/erofs/zmap.c b/drivers/staging/erofs/zmap.c
index 205e884ca4e0..aeed5c674d9e 100644
--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -13,13 +13,12 @@
 int z_erofs_fill_inode(struct inode *inode)
 {
 	struct erofs_vnode *const vi = EROFS_V(inode);
-	struct super_block *const sb = inode->i_sb;
 
 	if (vi->datamode == EROFS_INODE_FLAT_COMPRESSION_LEGACY) {
 		vi->z_advise = 0;
 		vi->z_algorithmtype[0] = 0;
 		vi->z_algorithmtype[1] = 0;
-		vi->z_logical_clusterbits = EROFS_SB(sb)->clusterbits;
+		vi->z_logical_clusterbits = LOG_BLOCK_SIZE;
 		vi->z_physical_clusterbits[0] = vi->z_logical_clusterbits;
 		vi->z_physical_clusterbits[1] = vi->z_logical_clusterbits;
 		set_bit(EROFS_V_Z_INITED_BIT, &vi->flags);
-- 
2.17.1
