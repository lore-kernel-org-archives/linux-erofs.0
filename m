From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 30 Jun 2018 23:17:31 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.3 4/6] erofs: add erofs_allocpage
In-Reply-To: <1530371853-104412-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530371853-104412-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530371853-104412-4-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/internal.h |  3 +++
 fs/erofs/utils.c    | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)
 create mode 100644 fs/erofs/utils.c

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index d327de2..6d9a927 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -320,5 +320,8 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 #endif
 }
 
+/* utils.c */
+extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
+
 #endif
 
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
