From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 15 Jan 2019 22:23:12 +0800
Subject: [NOMERGE] [RFC PATCH 1/4] erofs-utils: add a new basic compression
 framework
Message-ID: <20190115142315.28570-1-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 .gitignore                 |  2 +-
 Makefile.am                |  2 +-
 configure.ac               |  2 ++
 include/erofs/compressor.h | 52 +++++++++++++++++++++++++++++++++++
 include/erofs/config.h     | 12 ++++++++
 include/erofs/defs.h       | 42 ++++++++++++++++++++++++++++
 lib/Makefile.am            |  6 ++++
 lib/compressor.c           | 68 ++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/erofs_config.h        |  6 ++--
 9 files changed, 188 insertions(+), 4 deletions(-)
 create mode 100644 include/erofs/compressor.h
 create mode 100644 include/erofs/config.h
 create mode 100644 lib/Makefile.am
 create mode 100644 lib/compressor.c

diff --git a/.gitignore b/.gitignore
index 3cebe03..6dca2b0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,7 +28,7 @@ TAGS
 .deps/
 Makefile.in
 aclocal.m4
-config.h
+/config.h
 config.h.in
 configure
 libtool
diff --git a/Makefile.am b/Makefile.am
index 0eb37d6..d624708 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,4 +2,4 @@
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS=mkfs
+SUBDIRS=lib mkfs
diff --git a/configure.ac b/configure.ac
index 74ad0c0..5249810 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,6 +10,7 @@ AC_CONFIG_SRCDIR([mkfs/mkfs_main.c])
 AC_CONFIG_HEADERS([config.h])
 
 # Checks for programs.
+AM_PROG_AR
 AC_PROG_CC
 AC_PROG_INSTALL
 AC_PROG_LIBTOOL
@@ -110,5 +111,6 @@ if test "x${have_lz4}" = "x0" ; then
 fi
 
 AC_CONFIG_FILES([Makefile
+		 lib/Makefile
 		 mkfs/Makefile])
 AC_OUTPUT
diff --git a/include/erofs/compressor.h b/include/erofs/compressor.h
new file mode 100644
index 0000000..2a9a701
--- /dev/null
+++ b/include/erofs/compressor.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs-utils/include/erofs/compressor.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ */
+#ifndef __EROFS_COMPRESSOR_H
+#define __EROFS_COMPRESSOR_H
+
+#include "defs.h"
+
+#ifdef HAVE_LZ4HC_H
+#include <lz4hc.h>
+#endif
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
diff --git a/include/erofs/config.h b/include/erofs/config.h
new file mode 100644
index 0000000..adaf964
--- /dev/null
+++ b/include/erofs/config.h
@@ -0,0 +1,12 @@
+#ifndef __EROFS_CONFIG_H
+#define __EROFS_CONFIG_H
+
+#ifndef PAGE_SIZE
+#define PAGE_SIZE	4096
+#endif
+
+#define EROFS_CONFIG_COMPR_DEF_BOUNDARY     (128)
+#define EROFS_CONFIG_COMPR_RATIO_MAX_LIMIT  (100)
+
+#endif
+
diff --git a/include/erofs/defs.h b/include/erofs/defs.h
index 885ba13..f79347c 100644
--- a/include/erofs/defs.h
+++ b/include/erofs/defs.h
@@ -14,6 +14,9 @@
 #include <stdint.h>
 #include <assert.h>
 #include <inttypes.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
 
 #ifdef HAVE_CONFIG_H
 #include <config.h>
@@ -96,5 +99,44 @@ typedef int64_t         s64;
 #define BITS_PER_BYTE       8
 #define BITS_TO_LONGS(nr)   DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+/* The `const' in roundup() prevents gcc-3.3 from calling __divdi3 */
+#define roundup(x, y) (					\
+{							\
+	const typeof(y) __y = y;			\
+	(((x) + (__y - 1)) / __y) * __y;		\
+}							\
+)
+#define rounddown(x, y) (				\
+{							\
+	typeof(x) __x = (x);				\
+	__x - (__x % (y));				\
+}							\
+)
+
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+
+#define max(x, y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+
+
+#define BUG_ON(condition)	assert(!(condition))
+
+#ifdef DEBUG
+#define DBG_BUGON(condition)	BUG_ON(condition)
+#else
+#define DBG_BUGON(condition)	((void)(condition))
+#endif
+
+#include "erofs/config.h"
+
 #endif
 
diff --git a/lib/Makefile.am b/lib/Makefile.am
new file mode 100644
index 0000000..3093d6a
--- /dev/null
+++ b/lib/Makefile.am
@@ -0,0 +1,6 @@
+## Makefile.am
+
+noinst_LIBRARIES = liberofs.a
+liberofs_a_SOURCES = compressor.c
+liberofs_a_CPPFLAGS = -I$(top_srcdir)/include
+
diff --git a/lib/compressor.c b/lib/compressor.c
new file mode 100644
index 0000000..a282be1
--- /dev/null
+++ b/lib/compressor.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs-utils/lib/compressor.c
+ *
+ * Copyright (C) 2018-2019 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ */
+#include "erofs/compressor.h"
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
+	if (dstsize >= *srcsize * c->compress_threshold / 100)
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
+	c->compress_threshold = EROFS_CONFIG_COMPR_RATIO_MAX_LIMIT;
+
+	/* optimize for 4k size page */
+	c->destsize_alignsize = PAGE_SIZE;
+	c->destsize_redzone_begin = PAGE_SIZE - 16;
+	c->destsize_redzone_end = EROFS_CONFIG_COMPR_DEF_BOUNDARY;
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
diff --git a/mkfs/erofs_config.h b/mkfs/erofs_config.h
index 7e38f87..cac2d72 100644
--- a/mkfs/erofs_config.h
+++ b/mkfs/erofs_config.h
@@ -9,12 +9,14 @@
 #ifndef __EROFS_MKFS_CONFIG_H
 #define __EROFS_MKFS_CONFIG_H
 
+/* this file(mkfs_config.h) will be deprecated later */
+
+#include "erofs/config.h"
+
 /* workaround of a lz4 native compression issue, which can crash the program */
 /* #define EROFS_CONFIG_COMPR_MAX_SZ        (1024 * 1024) */
 #define EROFS_CONFIG_COMPR_MAX_SZ           (900  * 1024)
 #define EROFS_CONFIG_COMPR_MIN_SZ           (32   * 1024)
-#define EROFS_CONFIG_COMPR_DEF_BOUNDARY     (128)
-#define EROFS_CONFIG_COMPR_RATIO_MAX_LIMIT  (100)
 
 struct erofs_compr_alg;
 
-- 
2.14.4
