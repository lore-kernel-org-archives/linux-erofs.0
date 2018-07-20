From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 20 Jul 2018 10:52:39 +0800
Subject: [RFC PATCH v2 04/11] erofs: add erofs_allocpage
In-Reply-To: <1532055166-96837-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1532055166-96837-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532055166-96837-5-git-send-email-gaoxiang25@huawei.com>

This patch introduces an temporary _on-stack_ page
pool to reuse the freed page directly as much as
it can for better performance and release all pages
at a time, it also slightly reduces the possibility of
the potential memory allocation failure.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/Makefile   |  2 +-
 fs/erofs/internal.h |  3 +++
 fs/erofs/staging.h  |  4 ++++
 fs/erofs/utils.c    | 31 +++++++++++++++++++++++++++++++
 4 files changed, 39 insertions(+), 1 deletion(-)
 create mode 100644 fs/erofs/utils.c

diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
index 0b3db0a..d717775 100644
--- a/fs/erofs/Makefile
+++ b/fs/erofs/Makefile
@@ -3,7 +3,7 @@ EROFS_VERSION = "1.0"
 EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 
 obj-$(CONFIG_EROFS_FS) += erofs.o
-erofs-objs := super.o inode.o data.o namei.o dir.o
+erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
 erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index c8e5703..b19fd78 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -382,5 +382,8 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 #endif
 }
 
+/* utils.c */
+extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
+
 #endif
 
diff --git a/fs/erofs/staging.h b/fs/erofs/staging.h
index 7712a7b..a9bfd8c 100644
--- a/fs/erofs/staging.h
+++ b/fs/erofs/staging.h
@@ -81,3 +81,7 @@ static inline bool sb_rdonly(const struct super_block *sb) {
 
 #endif
 
+#ifndef lru_to_page
+#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
+#endif
+
diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
new file mode 100644
index 0000000..dce5177
--- /dev/null
+++ b/fs/erofs/utils.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/utils.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+
+#include "internal.h"
+
+struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
+{
+	struct page *page;
+
+	if (!list_empty(pool)) {
+		page = lru_to_page(pool);
+		list_del(&page->lru);
+	} else {
+		page = alloc_pages(gfp | __GFP_NOFAIL, 0);
+
+		BUG_ON(page == NULL);
+		BUG_ON(page->mapping != NULL);
+	}
+	return page;
+}
+
-- 
1.9.1
