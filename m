From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 31 May 2019 08:50:42 +0800
Subject: [PATCH 08/13] erofs-utils: introduce generic compression framework
In-Reply-To: <20190531005047.22093-1-hsiangkao@aol.com>
References: <20190531005047.22093-1-hsiangkao@aol.com>
Message-ID: <20190531005047.22093-9-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

This patch adds a new flexable compression framework
to user-space utilities, which is designed in order
to integrate more compression algorithms easily.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 lib/Makefile.am  |  2 +-
 lib/compressor.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/compressor.h | 48 +++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 lib/compressor.c
 create mode 100644 lib/compressor.h

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 5257d71..64da708 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -2,6 +2,6 @@
 # Makefile.am
 
 noinst_LTLIBRARIES = liberofs.la
-liberofs_la_SOURCES = config.c io.c cache.c inode.c
+liberofs_la_SOURCES = config.c io.c cache.c inode.c compressor.c
 liberofs_la_CFLAGS = -Wall -Werror -I$(top_srcdir)/include
 
diff --git a/lib/compressor.c b/lib/compressor.c
new file mode 100644
index 0000000..cc97cfb
--- /dev/null
+++ b/lib/compressor.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs-utils/lib/compressor.c
+ *
+ * Copyright (C) 2018-2019 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ */
+#include "erofs/internal.h"
+#include "compressor.h"
+
+#define EROFS_CONFIG_COMPR_DEF_BOUNDARY		(128)
+
+int erofs_compress_destsize(struct erofs_compress *c,
+			    int compression_level,
+			    void *src,
+			    unsigned int *srcsize,
+			    void *dst,
+			    unsigned int dstsize)
+{
+	int ret;
+
+	DBG_BUGON(!c->alg);
+	if (!c->alg->compress_destsize)
+		return -ENOTSUP;
+
+	ret = c->alg->compress_destsize(c, compression_level,
+					src, srcsize, dst, dstsize);
+	if (ret)
+		return ret;
+
+	/* check if there is enough gains to compress */
+	if (*srcsize <= dstsize * c->compress_threshold / 100)
+		return -EAGAIN;
+	return 0;
+}
+
+int erofs_compressor_init(struct erofs_compress *c,
+			  char *alg_name)
+{
+	static struct erofs_compressor *compressors[] = {
+	};
+
+	int ret, i;
+
+	/* should be written in "minimum compression ratio * 100" */
+	c->compress_threshold = 100;
+
+	/* optimize for 4k size page */
+	c->destsize_alignsize = PAGE_SIZE;
+	c->destsize_redzone_begin = PAGE_SIZE - 16;
+	c->destsize_redzone_end = EROFS_CONFIG_COMPR_DEF_BOUNDARY;
+
+	ret = -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(compressors); ++i) {
+		ret = compressors[i]->init(c, alg_name);
+		if (!ret) {
+			DBG_BUGON(!c->alg);
+			return 0;
+		}
+	}
+	return ret;
+}
+
+int erofs_compressor_exit(struct erofs_compress *c)
+{
+	DBG_BUGON(!c->alg);
+
+	if (c->alg->exit)
+		return c->alg->exit(c);
+	return 0;
+}
+
diff --git a/lib/compressor.h b/lib/compressor.h
new file mode 100644
index 0000000..8ad9d11
--- /dev/null
+++ b/lib/compressor.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs-utils/lib/compressor.h
+ *
+ * Copyright (C) 2018-2019 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ */
+#ifndef __EROFS_LIB_COMPRESSOR_H
+#define __EROFS_LIB_COMPRESSOR_H
+
+#include "erofs/defs.h"
+
+struct erofs_compress;
+
+struct erofs_compressor {
+	int default_level;
+	int best_level;
+
+	int (*init)(struct erofs_compress *c, char *alg_name);
+	int (*exit)(struct erofs_compress *c);
+
+	int (*compress_destsize)(struct erofs_compress *c,
+				 int compress_level,
+				 void *src, unsigned int *srcsize,
+				 void *dst, unsigned int dstsize);
+};
+
+struct erofs_compress {
+	struct erofs_compressor *alg;
+
+	unsigned int compress_threshold;
+
+	/* *_destsize specific */
+	unsigned int destsize_alignsize;
+	unsigned int destsize_redzone_begin;
+	unsigned int destsize_redzone_end;
+};
+
+int erofs_compress_destsize(struct erofs_compress *c, int compression_level,
+			    void *src, unsigned int *srcsize,
+			    void *dst, unsigned int dstsize);
+
+int erofs_compressor_init(struct erofs_compress *c, char *alg_name);
+int erofs_compressor_exit(struct erofs_compress *c);
+
+#endif
+
-- 
2.17.1
