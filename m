From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 26 Jul 2018 20:22:02 +0800
Subject: [PATCH 19/25] staging: erofs: add a generic z_erofs VLE decompressor
In-Reply-To: <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
References: <1527764767-22190-1-git-send-email-gaoxiang25@huawei.com>
 <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532607728-103372-20-git-send-email-gaoxiang25@huawei.com>

Currently, this patch only simply implements LZ4
decompressor due to its development priority.

In the future, erofs will support more compression
algorithm and format other than LZ4, thus a generic
decompressor interface will be needed.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Kconfig         |  14 +++
 drivers/staging/erofs/Makefile        |   2 +-
 drivers/staging/erofs/internal.h      |   5 +
 drivers/staging/erofs/unzip_vle.h     |  35 ++++++
 drivers/staging/erofs/unzip_vle_lz4.c | 209 ++++++++++++++++++++++++++++++++++
 5 files changed, 264 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/erofs/unzip_vle.h
 create mode 100644 drivers/staging/erofs/unzip_vle_lz4.c

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index 63bec70..b55ce1c 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -87,3 +87,17 @@ config EROFS_FS_ZIP
 
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
diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index e409637..9a766eb 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_EROFS_FS) += erofs.o
 ccflags-y += -I$(src)/include
 erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
-erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o unzip_lz4.o
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o unzip_lz4.o unzip_vle_lz4.o
 
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 6a0f045..e61d417 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -161,6 +161,11 @@ static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
 
 #define ROOT_NID(sb)		((sb)->root_nid)
 
+#ifdef CONFIG_EROFS_FS_ZIP
+/* hard limit of pages per compressed cluster */
+#define Z_EROFS_CLUSTER_MAX_PAGES       (CONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT)
+#endif
+
 typedef u64 erofs_off_t;
 
 /* data type for filesystem-wide blocks number */
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
new file mode 100644
index 0000000..b34f5bc
--- /dev/null
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * linux/drivers/staging/erofs/unzip_vle.h
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
+	unsigned outlen, unsigned short pageofs,
+	void (*endio)(struct page *));
+
+extern int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
+	unsigned clusterpages, void *vaddr, unsigned llen,
+	unsigned short pageofs, bool overlapped);
+
+#endif
+
diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
new file mode 100644
index 0000000..f5b665f
--- /dev/null
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/drivers/staging/erofs/unzip_vle_lz4.c
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
+	bool mirrored[Z_EROFS_CLUSTER_MAX_PAGES] = { 0 };
+
+	preempt_disable();
+	percpu_data = erofs_pcpubuf[smp_processor_id()].data;
+
+	j = 0;
+	for (i = 0; i < nr_pages; j = i++) {
+		struct page *page = pages[i];
+		void *dst;
+
+		if (page == NULL) {
+			if (src != NULL) {
+				if (!mirrored[j])
+					kunmap_atomic(src);
+				src = NULL;
+			}
+			continue;
+		}
+
+		dst = kmap_atomic(page);
+
+		for (; j < clusterpages; ++j) {
+			if (compressed_pages[j] != page)
+				continue;
+
+			BUG_ON(mirrored[j]);
+			memcpy(percpu_data + j * PAGE_SIZE, dst, PAGE_SIZE);
+			mirrored[j] = true;
+			break;
+		}
+
+		if (i) {
+			if (src == NULL)
+				src = mirrored[i-1] ?
+					percpu_data + (i-1) * PAGE_SIZE :
+					kmap_atomic(compressed_pages[i-1]);
+
+			memcpy(dst, src + righthalf, pageofs);
+
+			if (!mirrored[i-1])
+				kunmap_atomic(src);
+
+			if (unlikely(i >= clusterpages)) {
+				kunmap_atomic(dst);
+				break;
+			}
+		}
+
+		if (!righthalf)
+			src = NULL;
+		else {
+			src = mirrored[i] ? percpu_data + i * PAGE_SIZE :
+				kmap_atomic(compressed_pages[i]);
+
+			memcpy(dst + pageofs, src, righthalf);
+		}
+
+		kunmap_atomic(dst);
+	}
+
+	if (src != NULL && !mirrored[j])
+		kunmap_atomic(src);
+
+	preempt_enable();
+	return 0;
+}
+
+extern int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen);
+
+int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
+				  unsigned clusterpages,
+				  struct page **pages,
+				  unsigned outlen,
+				  unsigned short pageofs,
+				  void (*endio)(struct page *))
+{
+	void *vin, *vout;
+	unsigned nr_pages, i, j;
+	int ret;
+
+	if (outlen + pageofs > EROFS_PERCPU_NR_PAGES * PAGE_SIZE)
+		return -ENOTSUPP;
+
+	nr_pages = DIV_ROUND_UP(outlen + pageofs, PAGE_SIZE);
+
+	if (clusterpages == 1)
+		vin = kmap_atomic(compressed_pages[0]);
+	else
+		vin = erofs_vmap(compressed_pages, clusterpages);
+
+	preempt_disable();
+	vout = erofs_pcpubuf[smp_processor_id()].data;
+
+	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
+		clusterpages * PAGE_SIZE, outlen);
+
+	if (ret >= 0) {
+		outlen = ret;
+		ret = 0;
+	}
+
+	for (i = 0; i < nr_pages; ++i) {
+		j = min((unsigned)PAGE_SIZE - pageofs, outlen);
+
+		if (pages[i] != NULL) {
+			if (ret < 0)
+				SetPageError(pages[i]);
+			else if (clusterpages == 1 && pages[i] == compressed_pages[0])
+				memcpy(vin + pageofs, vout + pageofs, j);
+			else {
+				void *dst = kmap_atomic(pages[i]);
+
+				memcpy(dst + pageofs, vout + pageofs, j);
+				kunmap_atomic(dst);
+			}
+			endio(pages[i]);
+		}
+		vout += PAGE_SIZE;
+		outlen -= j;
+		pageofs = 0;
+	}
+	preempt_enable();
+
+	if (clusterpages == 1)
+		kunmap_atomic(vin);
+	else
+		erofs_vunmap(vin, clusterpages);
+
+	return ret;
+}
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
+		for (i = 0; i < clusterpages; ++i) {
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
+	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
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
