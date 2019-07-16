From: karen.palacio.1994@gmail.com (Karen Palacio)
Date: Tue, 16 Jul 2019 13:47:43 -0300
Subject: [PATCH] staging: erofs: fix typo
Message-ID: <1563295663-312-1-git-send-email-karen.palacio.1994@gmail.com>

Signed-off-by: Karen Palacio <karen.palacio.1994 at gmail.com>
---
 drivers/staging/erofs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index d04b798..0dcefac 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -88,7 +88,7 @@ config EROFS_FS_IO_MAX_RETRIES
 	  If unsure, leave the default value (5 retries, 6 IOs at most).
 
 config EROFS_FS_ZIP
-	bool "EROFS Data Compresssion Support"
+	bool "EROFS Data Compression Support"
 	depends on EROFS_FS
 	select LZ4_DECOMPRESS
 	help
-- 
2.7.4
