From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 16:59:56 +0800
Subject: [PATCH 5/5] staging: erofs: drop the extern prefix for function
 definitions
In-Reply-To: <20190116085956.21004-1-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
Message-ID: <20190116085956.21004-5-gaoxiang25@huawei.com>

Fix all `CHECK: extern prototypes should be avoided in .h files'
reported by checkpatch.pl.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h  | 47 +++++++++++++++++----------------------
 drivers/staging/erofs/unzip_vle.h | 24 ++++++++++----------
 2 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 304c79d253ae..3a27c255950b 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -252,23 +252,20 @@ static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 }
 #endif
 
-extern int erofs_workgroup_put(struct erofs_workgroup *grp);
-extern struct erofs_workgroup *erofs_find_workgroup(
-	struct super_block *sb, pgoff_t index, bool *tag);
-
-extern int erofs_register_workgroup(struct super_block *sb,
-	struct erofs_workgroup *grp, bool tag);
-
-extern unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
-	unsigned long nr_shrink, bool cleanup);
-
-extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
+int erofs_workgroup_put(struct erofs_workgroup *grp);
+struct erofs_workgroup *erofs_find_workgroup(struct super_block *sb,
+					     pgoff_t index, bool *tag);
+int erofs_register_workgroup(struct super_block *sb,
+			     struct erofs_workgroup *grp, bool tag);
+unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
+				       unsigned long nr_shrink, bool cleanup);
+void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-extern int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
-	struct erofs_workgroup *egrp);
-extern int erofs_try_to_free_cached_page(struct address_space *mapping,
-	struct page *page);
+int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
+				       struct erofs_workgroup *egrp);
+int erofs_try_to_free_cached_page(struct address_space *mapping,
+				  struct page *page);
 
 #define MNGD_MAPPING(sbi)	((sbi)->managed_cache->i_mapping)
 #else
@@ -495,8 +492,8 @@ static inline void __submit_bio(struct bio *bio, unsigned op, unsigned op_flags)
 #define EROFS_IO_MAX_RETRIES_NOFAIL	CONFIG_EROFS_FS_IO_MAX_RETRIES
 #endif
 
-extern struct page *__erofs_get_meta_page(struct super_block *sb,
-	erofs_blk_t blkaddr, bool prio, bool nofail);
+struct page *__erofs_get_meta_page(struct super_block *sb, erofs_blk_t blkaddr,
+				   bool prio, bool nofail);
 
 static inline struct page *erofs_get_meta_page(struct super_block *sb,
 	erofs_blk_t blkaddr, bool prio)
@@ -510,7 +507,7 @@ static inline struct page *erofs_get_meta_page_nofail(struct super_block *sb,
 	return __erofs_get_meta_page(sb, blkaddr, prio, true);
 }
 
-extern int erofs_map_blocks(struct inode *, struct erofs_map_blocks *, int);
+int erofs_map_blocks(struct inode *, struct erofs_map_blocks *, int);
 
 static inline struct page *
 erofs_get_inline_page(struct inode *inode,
@@ -530,9 +527,6 @@ static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
 #endif
 }
 
-extern struct inode *erofs_iget(struct super_block *sb,
-	erofs_nid_t nid, bool dir);
-
 extern const struct inode_operations erofs_generic_iops;
 extern const struct inode_operations erofs_symlink_iops;
 extern const struct inode_operations erofs_fast_symlink_iops;
@@ -547,6 +541,8 @@ static inline bool is_inode_fast_symlink(struct inode *inode)
 	return inode->i_op == &erofs_fast_symlink_iops;
 }
 
+struct inode *erofs_iget(struct super_block *sb, erofs_nid_t nid, bool dir);
+
 /* namei.c */
 extern const struct inode_operations erofs_dir_iops;
 
@@ -584,13 +580,12 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 }
 
 /* utils.c */
-extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
-
-extern void erofs_register_super(struct super_block *sb);
-extern void erofs_unregister_super(struct super_block *sb);
-
 extern struct shrinker erofs_shrinker_info;
 
+struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
+void erofs_register_super(struct super_block *sb);
+void erofs_unregister_super(struct super_block *sb);
+
 #ifndef lru_to_page
 #define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
 #endif
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 5a4e1b62c0d1..9dafa8dc712c 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -212,18 +212,18 @@ static inline void z_erofs_onlinepage_endio(struct page *page)
 #define Z_EROFS_VLE_VMAP_GLOBAL_PAGES	2048
 
 /* unzip_vle_lz4.c */
-extern int z_erofs_vle_plain_copy(struct page **compressed_pages,
-	unsigned clusterpages, struct page **pages,
-	unsigned nr_pages, unsigned short pageofs);
-
-extern int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
-	unsigned clusterpages, struct page **pages,
-	unsigned outlen, unsigned short pageofs,
-	void (*endio)(struct page *));
-
-extern int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
-	unsigned clusterpages, void *vaddr, unsigned llen,
-	unsigned short pageofs, bool overlapped);
+int z_erofs_vle_plain_copy(struct page **compressed_pages,
+			   unsigned int clusterpages, struct page **pages,
+			   unsigned int nr_pages, unsigned short pageofs);
+int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
+				  unsigned int clusterpages,
+				  struct page **pages, unsigned int outlen,
+				  unsigned short pageofs,
+				  void (*endio)(struct page *));
+int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
+			   unsigned int clusterpages,
+			   void *vaddr, unsigned int llen,
+			   unsigned short pageofs, bool overlapped);
 
 #endif
 
-- 
2.14.4
