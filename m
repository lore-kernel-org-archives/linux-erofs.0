From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:50 +0800
Subject: [PATCH 13/22] staging: erofs: kill CONFIG_EROFS_FS_USE_VM_MAP_RAM
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-14-gaoxiang25@huawei.com>

Turn into a module parameter ("use_vmap") as it
can be set at runtime.

Suggested-by: David Sterba <dsterba at suse.cz>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Kconfig        |  8 ------
 drivers/staging/erofs/decompressor.c | 37 +++++++++++++++-------------
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index 747e9eebfaa5..788beebf3f7d 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -63,14 +63,6 @@ config EROFS_FS_SECURITY
 
 	  If you are not using a security module, say N.
 
-config EROFS_FS_USE_VM_MAP_RAM
-	bool "EROFS VM_MAP_RAM Support"
-	depends on EROFS_FS
-	help
-	  use vm_map_ram/vm_unmap_ram instead of vmap/vunmap.
-
-	  If you don't know what these are, say N.
-
 config EROFS_FAULT_INJECTION
 	bool "EROFS fault injection facility"
 	depends on EROFS_FS
diff --git a/drivers/staging/erofs/decompressor.c b/drivers/staging/erofs/decompressor.c
index 744c43a456e9..5352a50981cb 100644
--- a/drivers/staging/erofs/decompressor.c
+++ b/drivers/staging/erofs/decompressor.c
@@ -7,6 +7,7 @@
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
  */
 #include "compress.h"
+#include <linux/module.h>
 #include <linux/lz4.h>
 
 #ifndef LZ4_DISTANCE_MAX	/* history window size */
@@ -29,6 +30,10 @@ struct z_erofs_decompressor {
 	char *name;
 };
 
+static bool use_vmap;
+module_param(use_vmap, bool, 0444);
+MODULE_PARM_DESC(use_vmap, "Use vmap() instead of vm_map_ram() (default 0)");
+
 static int lz4_prepare_destpages(struct z_erofs_decompress_req *rq,
 				 struct list_head *pagepool)
 {
@@ -219,29 +224,27 @@ static void copy_from_pcpubuf(struct page **out, const char *dst,
 
 static void *erofs_vmap(struct page **pages, unsigned int count)
 {
-#ifdef CONFIG_EROFS_FS_USE_VM_MAP_RAM
-	int i = 0;
-
-	while (1) {
-		void *addr = vm_map_ram(pages, count, -1, PAGE_KERNEL);
-		/* retry two more times (totally 3 times) */
-		if (addr || ++i >= 3)
-			return addr;
-		vm_unmap_aliases();
+	if (!use_vmap) {
+		int i = 0;
+
+		while (1) {
+			void *addr = vm_map_ram(pages, count, -1, PAGE_KERNEL);
+			/* retry two more times (totally 3 times) */
+			if (addr || ++i >= 3)
+				return addr;
+			vm_unmap_aliases();
+		}
+		return NULL;
 	}
-	return NULL;
-#else
 	return vmap(pages, count, VM_MAP, PAGE_KERNEL);
-#endif
 }
 
 static void erofs_vunmap(const void *mem, unsigned int count)
 {
-#ifdef CONFIG_EROFS_FS_USE_VM_MAP_RAM
-	vm_unmap_ram(mem, count);
-#else
-	vunmap(mem);
-#endif
+	if (!use_vmap)
+		vm_unmap_ram(mem, count);
+	else
+		vunmap(mem);
 }
 
 static int decompress_generic(struct z_erofs_decompress_req *rq,
-- 
2.17.1
