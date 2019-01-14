From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 14 Jan 2019 17:08:22 +0800
Subject: [PATCH rebased 4/5] staging: erofs: move erofs_xattr_handlers to
 xattr.h
In-Reply-To: <20190114090823.46227-1-gaoxiang25@huawei.com>
References: <20190114090823.46227-1-gaoxiang25@huawei.com>
Message-ID: <20190114090823.46227-4-gaoxiang25@huawei.com>

Let's move independent xattr-related stuffs to xattr.h.
No logic changes.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 5 -----
 drivers/staging/erofs/super.c    | 1 +
 drivers/staging/erofs/xattr.h    | 2 ++
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index ae4f2555f497..99b50b981335 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -580,11 +580,6 @@ int erofs_namei(struct inode *dir, struct qstr *name,
 /* dir.c */
 extern const struct file_operations erofs_dir_fops;
 
-#ifdef CONFIG_EROFS_FS_XATTR
-/* xattr.c */
-extern const struct xattr_handler *erofs_xattr_handlers[];
-#endif
-
 static inline void *erofs_vmap(struct page **pages, unsigned int count)
 {
 #ifdef CONFIG_EROFS_FS_USE_VM_MAP_RAM
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1c2eb69682ef..45c7f6ddb9f5 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -16,6 +16,7 @@
 #include <linux/parser.h>
 #include <linux/seq_file.h>
 #include "internal.h"
+#include "xattr.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/erofs.h>
diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
index 810fc947701d..634dae9aaa0b 100644
--- a/drivers/staging/erofs/xattr.h
+++ b/drivers/staging/erofs/xattr.h
@@ -68,6 +68,8 @@ static const struct xattr_handler *xattr_handler_map[] = {
 }
 
 #ifdef CONFIG_EROFS_FS_XATTR
+extern const struct xattr_handler *erofs_xattr_handlers[];
+
 int erofs_getxattr(struct inode *, int, const char *, void *, size_t);
 ssize_t erofs_listxattr(struct dentry *, char *, size_t);
 #else
-- 
2.14.4
