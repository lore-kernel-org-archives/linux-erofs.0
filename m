From: linux@weissschuh.net (=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=)
Date: Thu, 20 Sep 2018 20:58:56 +0200
Subject: [PATCH] staging: erofs: fix undeclared symbols
Message-ID: <20180920185856.14322-1-linux@weissschuh.net>

Move all internal symbols to the internal header file and add a missing
"static" declaration.
This fixes the sparse warnings like the following:

drivers/staging/erofs/unzip_lz4.c:230:5: warning: symbol 'z_erofs_unzip_lz4' was not declared. Should it be static?

Signed-off-by: Thomas Wei?schuh <linux at weissschuh.net>
---
 drivers/staging/erofs/data.c          |  5 -----
 drivers/staging/erofs/internal.h      | 14 ++++++++++++++
 drivers/staging/erofs/super.c         |  5 -----
 drivers/staging/erofs/unzip_vle.c     |  2 +-
 drivers/staging/erofs/unzip_vle_lz4.c |  2 --
 drivers/staging/erofs/utils.c         |  2 --
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index ac263a180253..9bfcc549bbf0 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -137,11 +137,6 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 	return 0;
 }
 
-#ifdef CONFIG_EROFS_FS_ZIP
-extern int z_erofs_map_blocks_iter(struct inode *,
-	struct erofs_map_blocks *, struct page **, int);
-#endif
-
 int erofs_map_blocks_iter(struct inode *inode,
 	struct erofs_map_blocks *map,
 	struct page **mpage_ret, int flags)
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 367b39fe46e5..d4c4c87bcd35 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -547,6 +547,20 @@ extern unsigned long erofs_shrink_count(struct shrinker *shrink,
 	struct shrink_control *sc);
 extern unsigned long erofs_shrink_scan(struct shrinker *shrink,
 	struct shrink_control *sc);
+extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
+
+#ifdef CONFIG_EROFS_FS_ZIP
+/* super.c */
+extern int z_erofs_init_zip_subsystem(void);
+extern void z_erofs_exit_zip_subsystem(void);
+
+/* unzip_vle.c */
+extern int z_erofs_map_blocks_iter(struct inode *,
+	struct erofs_map_blocks *, struct page **, int);
+
+/* unzip_lz4.c */
+extern int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen);
+#endif
 
 #ifndef lru_to_page
 #define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 2df9768edac9..c41d92e0cb3c 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -521,11 +521,6 @@ static struct file_system_type erofs_fs_type = {
 };
 MODULE_ALIAS_FS("erofs");
 
-#ifdef CONFIG_EROFS_FS_ZIP
-extern int z_erofs_init_zip_subsystem(void);
-extern void z_erofs_exit_zip_subsystem(void);
-#endif
-
 static int __init erofs_module_init(void)
 {
 	int err;
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 8721f0a41d15..a0d6c620051f 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -517,7 +517,7 @@ static void __z_erofs_vle_work_release(struct z_erofs_vle_workgroup *grp,
 	erofs_workgroup_put(&grp->obj);
 }
 
-void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
+static void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
 {
 	struct z_erofs_vle_workgroup *grp =
 		z_erofs_vle_work_workgroup(work, true);
diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index f5b665f15be5..e30e6e2ef05b 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -99,8 +99,6 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 	return 0;
 }
 
-extern int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen);
-
 int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 				  unsigned clusterpages,
 				  struct page **pages,
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 595cf90af9bb..26b9f97f258a 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -99,8 +99,6 @@ int erofs_register_workgroup(struct super_block *sb,
 	return err;
 }
 
-extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
-
 int erofs_workgroup_put(struct erofs_workgroup *grp)
 {
 	int count = atomic_dec_return(&grp->refcount);
-- 
2.19.0
