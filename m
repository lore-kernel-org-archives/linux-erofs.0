From: rdunlap@infradead.org (Randy Dunlap)
Date: Fri, 9 Nov 2018 09:58:44 -0800
Subject: [PATCH] staging: erofs: select LZ4_DECOMPRESS to fix build error
Message-ID: <e2365d5f-aabb-a631-1338-1e32f8c9bea6@infradead.org>

From: Randy Dunlap <rdunlap@infradead.org>

EROFS Data Compression support uses LZ4 decompression, so it
should select LZ4_DECOMPRESS to prevent this build error:

drivers/staging/erofs/unzip_vle_lz4.o: In function `z_erofs_unzip_lz4':
drivers/staging/erofs/unzip_vle_lz4.c:18: undefined reference to `LZ4_decompress_safe_partial'

Signed-off-by: Randy Dunlap <rdunlap at infradead.org>
Reported-by: kbuild test robot <lkp at intel.com>
Cc: Gao Xiang <gaoxiang25 at huawei.com>
Cc: Chao Yu <yuchao0 at huawei.com>
Cc: linux-erofs at lists.ozlabs.org
---
 drivers/staging/erofs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20181109.orig/drivers/staging/erofs/Kconfig
+++ linux-next-20181109/drivers/staging/erofs/Kconfig
@@ -90,6 +90,7 @@ config EROFS_FS_IO_MAX_RETRIES
 config EROFS_FS_ZIP
 	bool "EROFS Data Compresssion Support"
 	depends on EROFS_FS
+	select LZ4_DECOMPRESS
 	help
 	  Currently we support VLE Compression only.
 	  Play at your own risk.
