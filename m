From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 28 Aug 2018 03:56:16 +0800
Subject: [PREVIEW] [PATCH v2] Revert "staging: erofs: disable compiling
 temporarile"
In-Reply-To: <1535399496-10278-1-git-send-email-hsiangkao@aol.com>
References: <1535399496-10278-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1535399776-10323-1-git-send-email-hsiangkao@aol.com>

This reverts commit 156c3df8d4db4e693c062978186f44079413d74d

Because of XArray and the new mount apis aren't merged in 4.19 merge
window, the BROKEN mark can be reverted directly without any problems.

Fixes: 156c3df8d4db ("staging: erofs: disable compiling temporarile")
Signed-off-by: Gao Xiang <hsiangkao at aol.com>
---
change log v2:
 - fix commit message

It should be merged into the 'staging-linus' branch in order to enable
EROFS in 4.19 linux kernel.

Thanks,
Gao Xiang

 drivers/staging/erofs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index 96f6149..663b755 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -2,7 +2,7 @@
 
 config EROFS_FS
 	tristate "EROFS filesystem support"
-	depends on BROKEN
+	depends on BLOCK
 	help
 	  EROFS(Enhanced Read-Only File System) is a lightweight
 	  read-only file system with modern designs (eg. page-sized
-- 
2.7.4
