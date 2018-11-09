From: hsiangkao@aol.com (Gao Xiang)
Date: Sat, 10 Nov 2018 00:07:50 +0800
Subject: [PATCH] staging: erofs: fix undefined LZ4_decompress_safe_partial()
Message-ID: <1541779670-13832-1-git-send-email-hsiangkao@aol.com>

It needs an explicit LZ4 library dependency
if lz4 compression is enabled, found by kbuild randconfig.

Reported-by: kbuild test robot <lkp at intel.com>
Fixes: 05f9d4a0c8c4 ("staging: erofs: use the new LZ4_decompress_safe_partial()")
Signed-off-by: Gao Xiang <hsiangkao at aol.com>
---
 drivers/staging/erofs/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index c8521d7..d04b798 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -90,8 +90,9 @@ config EROFS_FS_IO_MAX_RETRIES
 config EROFS_FS_ZIP
 	bool "EROFS Data Compresssion Support"
 	depends on EROFS_FS
+	select LZ4_DECOMPRESS
 	help
-	  Currently we support VLE Compression only.
+	  Currently we support LZ4 VLE Compression only.
 	  Play at your own risk.
 
 	  If you don't want to use compression feature, say N.
-- 
2.7.4
