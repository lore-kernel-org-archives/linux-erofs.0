From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 23:57:38 +0800
Subject: [PATCH v2 08/22] staging: erofs: kill CONFIG_EROFS_FS_IO_MAX_RETRIES
In-Reply-To: <20190731155752.210602-1-gaoxiang25@huawei.com>
References: <20190731155752.210602-1-gaoxiang25@huawei.com>
Message-ID: <20190731155752.210602-9-gaoxiang25@huawei.com>

CONFIG_EROFS_FS_IO_MAX_RETRIES seems a runtime setting
and users have no idea about the change in behaviour.

Let's remove the setting currently and could turn it
into a module parameter if it's really needed.

Suggested-by: David Sterba <dsterba at suse.cz>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Kconfig    | 9 ---------
 drivers/staging/erofs/internal.h | 8 ++------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index 2577cbb46a5b..747e9eebfaa5 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -78,15 +78,6 @@ config EROFS_FAULT_INJECTION
 	  Test EROFS to inject faults such as ENOMEM, EIO, and so on.
 	  If unsure, say N.
 
-config EROFS_FS_IO_MAX_RETRIES
-	int "EROFS IO Maximum Retries"
-	depends on EROFS_FS
-	default "5"
-	help
-	  Maximum retry count of IO Errors.
-
-	  If unsure, leave the default value (5 retries, 6 IOs at most).
-
 config EROFS_FS_ZIP
 	bool "EROFS Data Compresssion Support"
 	depends on EROFS_FS
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 959bd0ae9d74..a3b9fcdd0c27 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -279,6 +279,8 @@ static inline void z_erofs_exit_zip_subsystem(void) {}
 #error erofs cannot be used in this platform
 #endif
 
+#define EROFS_IO_MAX_RETRIES_NOFAIL     5
+
 #define ROOT_NID(sb)		((sb)->root_nid)
 
 #define erofs_blknr(addr)       ((addr) / EROFS_BLKSIZ)
@@ -467,12 +469,6 @@ static inline void __submit_bio(struct bio *bio, unsigned int op,
 	submit_bio(bio);
 }
 
-#ifndef CONFIG_EROFS_FS_IO_MAX_RETRIES
-#define EROFS_IO_MAX_RETRIES_NOFAIL	0
-#else
-#define EROFS_IO_MAX_RETRIES_NOFAIL	CONFIG_EROFS_FS_IO_MAX_RETRIES
-#endif
-
 struct page *__erofs_get_meta_page(struct super_block *sb, erofs_blk_t blkaddr,
 				   bool prio, bool nofail);
 
-- 
2.17.1
