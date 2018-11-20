From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 22:14:40 +0800
Subject: [PATCH v3 chao/erofs-dev 06/14] staging: erofs: fix the definition of
 DBG_BUGON
In-Reply-To: <20181120141448.29483-1-gaoxiang25@huawei.com>
References: <20181120141448.29483-1-gaoxiang25@huawei.com>
Message-ID: <20181120141448.29483-6-gaoxiang25@huawei.com>

It's better not to positively BUG_ON the kernel, however developers
need a way to locate issues as soon as possible.

DBG_BUGON is introduced and it could only crash when EROFS_FS_DEBUG
(EROFS developping feature) is on. It is helpful for developers
to find and solve bugs quickly.

Previously, DBG_BUGON is defined as ((void)0) if EROFS_FS_DEBUG is off,
but some unused variable warnings as follows could occur:

drivers/staging/erofs/unzip_vle.c: In function ?init_always?:
drivers/staging/erofs/unzip_vle.c:61:33: warning: unused variable ?work? [-Wunused-variable]
  struct z_erofs_vle_work *const work =
                                 ^~~~

Fix it to #define DBG_BUGON(x) ((void)(x)).

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index f77653d33633..0aa2a41b9885 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -39,7 +39,7 @@
 #define debugln(x, ...)         ((void)0)
 
 #define dbg_might_sleep()       ((void)0)
-#define DBG_BUGON(...)          ((void)0)
+#define DBG_BUGON(x)            ((void)(x))
 #endif
 
 enum {
-- 
2.14.4
