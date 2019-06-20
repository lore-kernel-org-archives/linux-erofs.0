From: zbestahu@gmail.com (Yue Hu)
Date: Thu, 20 Jun 2019 16:30:04 +0800
Subject: [PATCH] staging: erofs: remove needless CONFIG_EROFS_FS_SECURITY
Message-ID: <20190620083004.2488-1-zbestahu@gmail.com>

From: Yue Hu <huyue2@yulong.com>

erofs_xattr_security_handler is already marked __maybe_unused, no need
to add CONFIG_EROFS_FS_SECURITY condition.

Signed-off-by: Yue Hu <huyue2 at yulong.com>
---
 drivers/staging/erofs/xattr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index df40654..06024ac 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -499,13 +499,11 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
 	.get	= erofs_xattr_generic_get,
 };
 
-#ifdef CONFIG_EROFS_FS_SECURITY
 const struct xattr_handler __maybe_unused erofs_xattr_security_handler = {
 	.prefix	= XATTR_SECURITY_PREFIX,
 	.flags	= EROFS_XATTR_INDEX_SECURITY,
 	.get	= erofs_xattr_generic_get,
 };
-#endif
 
 const struct xattr_handler *erofs_xattr_handlers[] = {
 	&erofs_xattr_user_handler,
-- 
1.9.1
