From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 13:27:46 +0800
Subject: [NOMERGE] [RFC PATCH v2 2/4] erofs-utils: add lz4hc algorithm support
In-Reply-To: <20190116052748.24709-1-gaoxiang25@huawei.com>
References: <20190116052748.24709-1-gaoxiang25@huawei.com>
Message-ID: <20190116052748.24709-2-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 configure.ac               |  9 ++++++-
 include/erofs/compressor.h | 11 +++++++++
 lib/Makefile.am            |  5 ++++
 lib/compressor-lz4hc.c     | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/compressor.c           |  3 +++
 5 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 lib/compressor-lz4hc.c

diff --git a/configure.ac b/configure.ac
index 5249810..0ed8a25 100644
--- a/configure.ac
+++ b/configure.ac
@@ -104,11 +104,18 @@ AC_CHECK_FUNCS([ftruncate getcwd gettimeofday memset realpath strdup strerror st
 
 # Configure lz4.
 have_lz4="1"
+LIB_LZ4="-Wl,-Bstatic,-llz4,-Bdynamic"
 AC_CHECK_HEADERS([lz4.h], , [have_lz4="0"])
-AC_CHECK_LIB(lz4, LZ4_versionNumber, [LIBS="-Wl,-Bstatic,-llz4,-Bdynamic $LIBS"] , [have_lz4="0"])
+AC_CHECK_LIB(lz4, LZ4_versionNumber,, [have_lz4="0" LIB_LZ4=''])
 if test "x${have_lz4}" = "x0" ; then
   AC_MSG_ERROR([Cannot build without lz4])
 fi
+AM_CONDITIONAL(HasLZ4, test "$have_lz4" = '1')
+AC_SUBST([LIB_LZ4])
+
+have_lz4hc="1"
+AC_CHECK_HEADERS([lz4hc.h], , [have_lz4hc="0"])
+AM_CONDITIONAL(HasLZ4HC, test "$have_lz4hc" = '1')
 
 AC_CONFIG_FILES([Makefile
 		 lib/Makefile
diff --git a/include/erofs/compressor.h b/include/erofs/compressor.h
index 2a9a701..8e219d8 100644
--- a/include/erofs/compressor.h
+++ b/include/erofs/compressor.h
@@ -39,8 +39,19 @@ struct erofs_compress {
 	unsigned int destsize_alignsize;
 	unsigned int destsize_redzone_begin;
 	unsigned int destsize_redzone_end;
+
+	union {
+#ifdef HAVE_LZ4HC_H
+		struct {
+			LZ4_streamHC_t *ctx;
+		} lz4hc;
+#endif
+	} u;
 };
 
+/* list of compression algorithms */
+extern struct erofs_compressor erofs_compressor_lz4hc;
+
 int erofs_compress_destsize(struct erofs_compress *c, int compression_level,
 			    void *src, unsigned int *srcsize,
 			    void *dst, unsigned int dstsize);
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 3093d6a..33438a3 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -2,5 +2,10 @@
 
 noinst_LIBRARIES = liberofs.a
 liberofs_a_SOURCES = compressor.c
+
+if HasLZ4HC
+liberofs_a_SOURCES += compressor-lz4hc.c
+endif
+
 liberofs_a_CPPFLAGS = -I$(top_srcdir)/include
 
diff --git a/lib/compressor-lz4hc.c b/lib/compressor-lz4hc.c
new file mode 100644
index 0000000..1609963
--- /dev/null
+++ b/lib/compressor-lz4hc.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs-utils/lib/compressor-lz4hc.c
+ *
+ * Copyright (C) 2018-2019 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ */
+#define LZ4_HC_STATIC_LINKING_ONLY (1)
+#include <lz4hc.h>
+
+#include "erofs/compressor.h"
+
+static int lz4hc_compress_destsize(struct erofs_compress *c,
+				   int compression_level,
+				   void *src,
+				   unsigned int *srcsize,
+				   void *dst,
+				   unsigned int dstsize)
+{
+	int rc;
+
+	rc = LZ4_compress_HC_destSize(c->u.lz4hc.ctx, src, dst,
+				      srcsize, dstsize, compression_level);
+	if (!rc)
+		return -EFAULT;
+	return 0;
+}
+
+static int compressor_lz4hc_exit(struct erofs_compress *c)
+{
+	if (!c->u.lz4hc.ctx)
+		return -EINVAL;
+
+	LZ4_freeStreamHC(c->u.lz4hc.ctx);
+	return 0;
+}
+
+static int compressor_lz4hc_init(struct erofs_compress *c,
+				 char *alg_name)
+{
+	if (alg_name && strcmp(alg_name, "lz4hc"))
+		return -EINVAL;
+
+	c->alg = &erofs_compressor_lz4hc;
+
+	c->u.lz4hc.ctx = LZ4_createStreamHC();
+	if (!c->u.lz4hc.ctx)
+		return -ENOMEM;
+	return 0;
+}
+
+struct erofs_compressor erofs_compressor_lz4hc = {
+	.default_level = LZ4HC_CLEVEL_DEFAULT,
+	.best_level = LZ4HC_CLEVEL_MAX,
+	.init = compressor_lz4hc_init,
+	.exit = compressor_lz4hc_exit,
+	.compress_destsize = lz4hc_compress_destsize,
+};
+
diff --git a/lib/compressor.c b/lib/compressor.c
index a282be1..508203c 100644
--- a/lib/compressor.c
+++ b/lib/compressor.c
@@ -36,6 +36,9 @@ int erofs_compressor_init(struct erofs_compress *c,
 			  char *alg_name)
 {
 	static struct erofs_compressor *compressors[] = {
+#ifdef HAVE_LZ4HC_H
+		&erofs_compressor_lz4hc,
+#endif
 	};
 
 	int ret, i;
-- 
2.14.4
