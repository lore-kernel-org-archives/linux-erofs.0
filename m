From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 1 Aug 2018 14:38:31 +0800
Subject: [PATCH 2/2] staging: erofs: remove a redundant marco in xattr
In-Reply-To: <1533105511-26197-1-git-send-email-gaoxiang25@huawei.com>
References: <1532915461-2512-1-git-send-email-gaoxiang25@huawei.com>
 <1533105511-26197-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533105511-26197-2-git-send-email-gaoxiang25@huawei.com>

There is no need to '#if CONFIG_EROFS_FS_XATTR' in xattr.c,
let's remove it.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/xattr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index b74b314..6b9685f 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -420,7 +420,6 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
 };
 #endif
 
-#ifdef CONFIG_EROFS_FS_XATTR
 const struct xattr_handler *erofs_xattr_handlers[] = {
 	&erofs_xattr_user_handler,
 #ifdef CONFIG_EROFS_FS_POSIX_ACL
@@ -433,7 +432,6 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
 #endif
 	NULL,
 };
-#endif
 
 struct listxattr_iter {
 	struct xattr_iter it;
-- 
1.9.1
