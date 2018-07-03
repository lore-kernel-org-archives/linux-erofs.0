From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 4 Jul 2018 00:13:17 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH RESEND v0.4 6/7] erofs: add a generic
 z_erofs VLE decompressor
In-Reply-To: <1530634398-37351-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530634398-37351-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530634398-37351-7-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/Kconfig         |  14 +++++
 fs/erofs/Makefile        |   2 +-
 fs/erofs/internal.h      |   5 ++
 fs/erofs/unzip_vle.h     |  34 +++++++++++
 fs/erofs/unzip_vle_lz4.c | 145 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 199 insertions(+), 1 deletion(-)
 create mode 100644 fs/erofs/unzip_vle.h
 create mode 100644 fs/erofs/unzip_vle_lz4.c

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index ffbd5eb..00e811c 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -85,3 +85,17 @@ config EROFS_FS_ZIP
 
 	  If you don't want to use compression feature, say N.
 
+config EROFS_FS_CLUSTER_PAGE_LIMIT
+	int "EROFS Cluster Pages Hard Limit"
+	depends on EROFS_FS_ZIP
+	range 1 256
+	default "1"
+	help
+	  Indicates VLE compressed pages hard limit of a
+	  compressed cluster.
+
+	  For example, if files of a image are compressed
+	  into 8k-unit, the hard limit should not be less
+	  than 2. Otherwise, the image cannot be mounted
+	  correctly on this kernel.
+
diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
index d717775..fa9d179 100644
--- a/fs/erofs/Makefile
+++ b/fs/erofs/Makefile
@@ -5,5 +5,5 @@ EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 obj-$(CONFIG_EROFS_FS) += erofs.o
 erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
-erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o unzip_vle_lz4.o unzip_lz4.o
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index e60f535..038d77b 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -162,6 +162,11 @@ static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
 
 #define ROOT_NID(sb)		((sb)->root_nid)
 
+#ifdef CONFIG_EROFS_FS_ZIP
+/* hard limit of pages per compressed cluster */
+#define Z_EROFS_CLUSTER_MAX_PAGES       (CONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT)
+#endif
+
 typedef u64 erofs_off_t;
 
 /* data type for filesystem-wide blocks number */
diff --git a/fs/erofs/unzip_vle.h b/fs/erofs/unzip_vle.h
new file mode 100644
index 0000000..143b6c3
--- /dev/null
+++ b/fs/erofs/unzip_vle.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * linux/fs/erofs/unzip_vle.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#ifndef __EROFS_FS_UNZIP_VLE_H
+#define __EROFS_FS_UNZIP_VLE_H
+
+#include "internal.h"
+
+#define Z_EROFS_VLE_INLINE_PAGEVECS     3
+
+/* unzip_vle_lz4.c */
+extern int z_erofs_vle_plain_copy(struct page **compressed_pages,
+	unsigned clusterpages, struct page **pages,
+	unsigned nr_pages, unsigned short pageofs);
+
+extern int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
+	unsigned clusterpages, struct page **pages,
+	unsigned llen, unsigned short pageofs);
+
+extern int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
+	unsigned clusterpages, void *vaddr, unsigned llen,
+	unsigned short pageofs, bool overlapped);
+
+#endif
+
diff --git a/fs/erofs/unzip_vle_lz4.c b/fs/erofs/unzip_vle_lz4.c
new file mode 100644
index 0000000..bb5d830
--- /dev/null
+++ b/fs/erofs/unzip_vle_lz4.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/unzip_vle_lz4.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include "unzip_vle.h"
+
+#if Z_EROFS_CLUSTER_MAX_PAGES > Z_EROFS_VLE_INLINE_PAGEVECS
+#define EROFS_PERCPU_NR_PAGES   Z_EROFS_CLUSTER_MAX_PAGES
+#else
+#define EROFS_PERCPU_NR_PAGES   Z_EROFS_VLE_INLINE_PAGEVECS
+#endif
+
+static struct {
+	char data[PAGE_SIZE * EROFS_PERCPU_NR_PAGES];
+} erofs_pcpubuf[NR_CPUS];
+
+int z_erofs_vle_plain_copy(struct page **compressed_pages,
+			   unsigned clusterpages,
+			   struct page **pages,
+			   unsigned nr_pages,
+			   unsigned short pageofs)
+{
+	unsigned i, j;
+	void *src = NULL;
+	const unsigned righthalf = PAGE_SIZE - pageofs;
+	char *percpu_data;
+	bool backedup[Z_EROFS_CLUSTER_MAX_PAGES] = { 0 };
+
+	preempt_disable();
+	percpu_data = erofs_pcpubuf[smp_processor_id()].data;
+
+	for(i = 0; i < nr_pages; ++i) {
+		struct page *page = pages[i];
+		void *dst;
+
+		if (page == NULL) {
+			if (src != NULL && !backedup[i-1])
+				kunmap_atomic(src);
+
+			src = NULL;
+			continue;
+		}
+
+		dst = kmap_atomic(page);
+
+		for(j = 0; j < clusterpages; ++j) {
+			if (compressed_pages[j] != page)
+				continue;
+
+			BUG_ON(backedup[j]);
+			memcpy(percpu_data + j * PAGE_SIZE, dst, PAGE_SIZE);
+			backedup[j] = true;
+			break;
+		}
+
+		if (src == NULL && i) {
+			if (backedup[i-1])
+				src = percpu_data + i-1;
+			else
+				src = kmap_atomic(compressed_pages[i-1]);
+		}
+
+		memcpy(dst, src + righthalf, pageofs);
+
+		if (!backedup[i-1])
+			kunmap_atomic(src);
+
+		if (i >= clusterpages) {
+			kunmap_atomic(dst);
+			break;
+		}
+
+		if (backedup[i])
+			src = percpu_data + i;
+		else
+			src = kmap_atomic(compressed_pages[i]);
+		memcpy(dst + pageofs, src, righthalf);
+		kunmap_atomic(dst);
+	}
+	return 0;
+}
+
+int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
+				  unsigned clusterpages,
+				  struct page **pages,
+				  unsigned llen,
+				  unsigned short pageofs)
+{
+	return -ENOTSUPP;
+}
+
+extern int erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen);
+
+int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
+			   unsigned clusterpages,
+			   void *vout,
+			   unsigned llen,
+			   unsigned short pageofs,
+			   bool overlapped)
+{
+	void *vin;
+	unsigned i;
+	int ret;
+
+	if (overlapped) {
+		preempt_disable();
+		vin = erofs_pcpubuf[smp_processor_id()].data;
+
+		for(i = 0; i < clusterpages; ++i) {
+			void *t = kmap_atomic(compressed_pages[i]);
+
+			memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);
+			kunmap_atomic(t);
+		}
+	} else if (clusterpages == 1)
+		vin = kmap_atomic(compressed_pages[0]);
+	else {
+		vin = erofs_vmap(compressed_pages, clusterpages);
+	}
+
+	ret = erofs_unzip_lz4(vin, vout + pageofs,
+		clusterpages * PAGE_SIZE, llen);
+	if (ret > 0)
+		ret = 0;
+
+	if (!overlapped) {
+		if (clusterpages == 1)
+			kunmap_atomic(vin);
+		else {
+			erofs_vunmap(vin, clusterpages);
+		}
+	} else
+		preempt_enable();
+
+	return ret;
+}
+
-- 
1.9.1
