From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 25 Jul 2018 10:26:29 +0800
Subject: [RFC PATCH v2 16/25] staging: erofs: add erofs_allocpage
In-Reply-To: <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
 <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532485598-63393-17-git-send-email-gaoxiang25@huawei.com>

This patch introduces an temporary _on-stack_ page
pool to reuse the freed page directly as much as
it can for better performance and release all pages
at a time, it also slightly reduces the possibility of
the potential memory allocation failure.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Makefile   |  2 +-
 drivers/staging/erofs/internal.h |  7 +++++++
 drivers/staging/erofs/utils.c    | 31 +++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/erofs/utils.c

diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index 8558c76..490fa6c 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -7,7 +7,7 @@ ccflags-y += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 obj-$(CONFIG_EROFS_FS) += erofs.o
 # staging requirement: to be self-contained in its own directory
 ccflags-y += -I$(src)/include
-erofs-objs := super.o inode.o data.o namei.o dir.o
+erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
 erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o
 
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index bea5ec4..210ab6c 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -369,5 +369,12 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 #endif
 }
 
+/* utils.c */
+extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
+
+#ifndef lru_to_page
+#define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
+#endif
+
 #endif
 
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
new file mode 100644
index 0000000..3dec4f8
--- /dev/null
+++ b/drivers/staging/erofs/utils.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/drivers/staging/erofs/utils.c
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
