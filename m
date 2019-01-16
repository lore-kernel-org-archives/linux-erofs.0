From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 13:27:47 +0800
Subject: [NOMERGE] [RFC PATCH v2 3/4] erofs-utils: add zlib algorithm support
In-Reply-To: <20190116052748.24709-1-gaoxiang25@huawei.com>
References: <20190116052748.24709-1-gaoxiang25@huawei.com>
Message-ID: <20190116052748.24709-3-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 configure.ac               |  12 ++
 include/erofs/compressor.h |   8 ++
 lib/Makefile.am            |   4 +
 lib/compressor-zlib.c      | 286 +++++++++++++++++++++++++++++++++++++++++++++
 lib/compressor.c           |   1 +
 5 files changed, 311 insertions(+)
 create mode 100644 lib/compressor-zlib.c

diff --git a/configure.ac b/configure.ac
index 0ed8a25..c82b900 100644
--- a/configure.ac
+++ b/configure.ac
@@ -117,6 +117,18 @@ have_lz4hc="1"
 AC_CHECK_HEADERS([lz4hc.h], , [have_lz4hc="0"])
 AM_CONDITIONAL(HasLZ4HC, test "$have_lz4hc" = '1')
 
+# Configure zlib
+have_zlib="1"
+LIB_ZLIB=''
+AC_CHECK_HEADER(zlib.h, , [have_zlib='0'])
+AC_CHECK_LIB(z, deflate,, [have_zlib='0'])
+if test "x${have_lz4}" = "x1" ; then
+  AC_DEFINE(HAVE_ZLIB, 1, [Define to 1 if zlib is enabled])
+  LIB_ZLIB='-lz'
+fi
+AM_CONDITIONAL(HasZLIB, test "x$have_zlib" = 'x1')
+AC_SUBST([LIB_ZLIB])
+
 AC_CONFIG_FILES([Makefile
 		 lib/Makefile
 		 mkfs/Makefile])
diff --git a/include/erofs/compressor.h b/include/erofs/compressor.h
index 8e219d8..0355e18 100644
--- a/include/erofs/compressor.h
+++ b/include/erofs/compressor.h
@@ -41,6 +41,13 @@ struct erofs_compress {
 	unsigned int destsize_redzone_end;
 
 	union {
+#ifdef HAVE_ZLIB
+		struct {
+			unsigned int destsize_excess;
+			unsigned int destsize_margin;
+		} zlib;
+#endif
+
 #ifdef HAVE_LZ4HC_H
 		struct {
 			LZ4_streamHC_t *ctx;
@@ -51,6 +58,7 @@ struct erofs_compress {
 
 /* list of compression algorithms */
 extern struct erofs_compressor erofs_compressor_lz4hc;
+extern struct erofs_compressor erofs_compressor_zlib;
 
 int erofs_compress_destsize(struct erofs_compress *c, int compression_level,
 			    void *src, unsigned int *srcsize,
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 33438a3..f2de0e3 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -7,5 +7,9 @@ if HasLZ4HC
 liberofs_a_SOURCES += compressor-lz4hc.c
 endif
 
+if HasZLIB
+liberofs_a_SOURCES += compressor-zlib.c
+endif
+
 liberofs_a_CPPFLAGS = -I$(top_srcdir)/include
 
diff --git a/lib/compressor-zlib.c b/lib/compressor-zlib.c
new file mode 100644
index 0000000..e63d86a
--- /dev/null
+++ b/lib/compressor-zlib.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs-utils/lib/compressor-zlib.c
+ *
+ * Copyright (C) 2018-2019 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ * [ Code partially taken from zlib/examples/fitblk.c ]
+ */
+#include <zlib.h>
+#include "erofs/compressor.h"
+
+/* intermediate uncompressed buffer size */
+#define RAWLEN	4096U
+
+static int partcompress(z_streamp def,
+			char *src, unsigned int srcsize)
+{
+	int ret, flush;
+	unsigned int p;
+	unsigned char raw[RAWLEN];
+
+	p = 0;
+	flush = Z_NO_FLUSH;
+	do {
+		def->avail_in = min(RAWLEN, srcsize);
+		def->next_in = src + p;
+
+		p += def->avail_in;
+		srcsize -= def->avail_in;
+
+		if (!srcsize)
+			flush = Z_FINISH;
+
+		ret = deflate(def, flush);
+		DBG_BUGON(ret == Z_STREAM_ERROR);
+	} while (def->avail_out && flush == Z_NO_FLUSH);
+	return ret;
+}
+
+static int decompress_and_verify(z_streamp inf,
+				 char *src, unsigned srcsize)
+{
+	unsigned char raw[RAWLEN];
+	int ret, p, flush;
+
+	p = 0;
+	flush = Z_NO_FLUSH;
+	do {
+		unsigned int have;
+
+		inf->avail_out = RAWLEN;
+		inf->next_out = raw;
+		ret = inflate(inf, flush);
+
+		DBG_BUGON(ret == Z_STREAM_ERROR);
+		DBG_BUGON(ret == Z_DATA_ERROR);
+		DBG_BUGON(ret == Z_NEED_DICT);
+
+		if (ret == Z_MEM_ERROR)
+			return -ENOMEM;
+
+		have = RAWLEN - inf->avail_out;
+
+		/* verify the data */
+		if (memcmp(src + p, raw, have))
+			return -EFAULT;
+
+		p += have;
+		if (inf->avail_out && flush != Z_SYNC_FLUSH) {
+			flush = Z_SYNC_FLUSH;
+			continue;
+		}
+
+		if (ret == Z_BUF_ERROR) {
+			DBG_BUGON(inf->avail_in);
+			/* equivalent to "Z_STREAM_END" */
+			break;
+		}
+	} while (ret !=  Z_STREAM_END);
+	return p;
+}
+
+static int recompress(z_streamp inf, z_streamp def)
+{
+	int ret, flush;
+	unsigned char raw[RAWLEN];
+
+	flush = Z_NO_FLUSH;
+	do {
+		/* decompress */
+		inf->avail_out = RAWLEN;
+		inf->next_out = raw;
+		ret = inflate(inf, Z_NO_FLUSH);
+		DBG_BUGON(ret == Z_STREAM_ERROR);
+		DBG_BUGON(ret == Z_DATA_ERROR);
+		DBG_BUGON(ret == Z_NEED_DICT);
+
+		if (ret == Z_MEM_ERROR)
+			return -ENOMEM;
+
+		/* compress what was decompresed until done or no room */
+		def->avail_in = RAWLEN - inf->avail_out;
+		def->next_in = raw;
+		if (inf->avail_out != 0)
+			flush = Z_FINISH;
+		ret = deflate(def, flush);
+		DBG_BUGON(ret == Z_STREAM_ERROR);
+	} while (ret != Z_STREAM_END && def->avail_out != 0);
+	return ret;
+}
+
+static int zlib_compress_destsize(struct erofs_compress *c,
+				  int compression_level,
+				  void *src,
+				  unsigned int *srcsize,
+				  void *dst,
+				  unsigned int dstsize)
+{
+	const unsigned int alignsize = c->destsize_alignsize;
+	const unsigned int redzone_begin = c->destsize_redzone_begin;
+	const unsigned int redzone_end = c->destsize_redzone_end;
+
+	const unsigned int excess = c->u.zlib.destsize_excess;
+	const unsigned int margin = c->u.zlib.destsize_margin;
+	int tmpsize, aligned, remaining;
+	z_stream def, inf;
+	void *blk, *blk2;
+	int ret, rc;
+
+	blk = malloc(dstsize + excess);
+	if (!blk)
+		return -ENOMEM;
+
+	def.zalloc = Z_NULL;
+	def.zfree = Z_NULL;
+	def.opaque = Z_NULL;
+	ret = deflateInit(&def, compression_level);
+	if (ret != Z_OK) {
+		ret = -EFAULT;
+		goto mem_err;
+	}
+
+	def.avail_out = dstsize + excess;
+	def.next_out  = blk;
+	ret = partcompress(&def, src, *srcsize);
+
+	/* if it all fit, then size was undersubscribed -- done! */
+	if (ret == Z_STREAM_END && def.avail_out >= excess) {
+		const unsigned int unused = excess - def.avail_out;
+
+		memcpy(dst, blk, dstsize - unused);
+		ret = 0;
+		goto def_out;
+	}
+
+	/* it didn't all fit -- set up for recompression */
+	inf.zalloc = Z_NULL;
+	inf.zfree = Z_NULL;
+	inf.opaque = Z_NULL;
+	inf.avail_in = 0;
+	inf.next_in = Z_NULL;
+	ret = inflateInit(&inf);
+
+	if (ret != Z_OK) {
+		ret = -EFAULT;
+		goto def_out;
+	}
+
+	inf.avail_in = dstsize;
+	inf.next_in = blk;
+	ret = decompress_and_verify(&inf, src, *srcsize);
+	if (ret < 0)
+		goto inf_out;
+	tmpsize = ret;
+
+	rc = inflateReset(&inf);
+	DBG_BUGON(rc == Z_STREAM_ERROR);
+	rc = deflateReset(&def);
+	DBG_BUGON(rc == Z_STREAM_ERROR);
+
+	remaining = tmpsize % alignsize;
+	if (remaining) {
+		if (remaining > redzone_begin) {
+			aligned = roundup(tmpsize, alignsize);
+
+			ret = deflateParams(&def, Z_BEST_COMPRESSION,
+					    Z_DEFAULT_STRATEGY);
+			if (ret != Z_OK) {
+				ret = -EFAULT;
+				goto inf_out;
+			}
+
+			/* let's try to use best compression to achieve that! */
+			def.avail_out = dstsize + excess;
+			def.next_out = blk;
+			ret = partcompress(&def, src, aligned);
+
+			/* if it is all fit -- well done! */
+			if (ret == Z_STREAM_END && def.avail_out >= excess) {
+				const unsigned int unused =
+					excess - def.avail_out;
+
+				memcpy(dst, blk, dstsize - unused);
+				*srcsize = aligned;
+				goto inf_out;
+			}
+
+			ret = deflateParams(&def, compression_level,
+					    Z_DEFAULT_STRATEGY);
+			if (ret != Z_OK) {
+				ret = -EFAULT;
+				goto inf_out;
+			}
+		} else if (remaining < redzone_end)
+			tmpsize = rounddown(tmpsize, alignsize);
+	}
+
+	rc = deflateReset(&def);
+	DBG_BUGON(rc == Z_STREAM_ERROR);
+
+	/* do first recompression close to the right amount */
+	def.avail_out = dstsize + excess;
+	def.next_out = blk;
+	ret = partcompress(&def, src, tmpsize);
+
+	if (ret == Z_STREAM_END && def.avail_out >= excess) {
+		const unsigned int unused = excess - def.avail_out;
+
+		memcpy(dst, blk, dstsize - unused);
+		*srcsize = tmpsize;
+		goto inf_out;
+	}
+
+	rc = deflateReset(&def);
+	DBG_BUGON(rc == Z_STREAM_ERROR);
+
+	/* do second and final recompression */
+	inf.avail_in = dstsize - margin;
+	inf.next_in = blk;
+	def.avail_out = dstsize;
+	def.next_out = dst;
+	ret = recompress(&inf, &def);
+
+	if (ret == Z_MEM_ERROR) {
+		ret = -ENOMEM;
+		goto inf_out;
+	}
+
+	DBG_BUGON(ret != Z_STREAM_END);	/* otherwise MARGIN too small */
+
+	*srcsize = def.total_in;
+	ret = 0;
+inf_out:
+	rc = inflateEnd(&inf);
+	DBG_BUGON(rc == Z_STREAM_ERROR);
+def_out:
+	rc = deflateEnd(&def);
+	DBG_BUGON(rc == Z_STREAM_ERROR);
+mem_err:
+	free(blk);
+	return ret;
+}
+
+static int compressor_zlib_init(struct erofs_compress *c,
+				char *alg_name)
+{
+	if (alg_name && strcmp(alg_name, "zlib"))
+		return -EINVAL;
+
+	c->alg = &erofs_compressor_zlib;
+
+	/* empirically determined stream overage */
+	c->u.zlib.destsize_excess = 512;
+	/* amount to back off for completion */
+	c->u.zlib.destsize_margin = 8;
+	return 0;
+}
+
+struct erofs_compressor erofs_compressor_zlib = {
+	.default_level = Z_DEFAULT_COMPRESSION,
+	.best_level = Z_BEST_COMPRESSION,
+	.init = compressor_zlib_init,
+	.compress_destsize = zlib_compress_destsize,
+};
+
diff --git a/lib/compressor.c b/lib/compressor.c
index 508203c..ed948f3 100644
--- a/lib/compressor.c
+++ b/lib/compressor.c
@@ -39,6 +39,7 @@ int erofs_compressor_init(struct erofs_compress *c,
 #ifdef HAVE_LZ4HC_H
 		&erofs_compressor_lz4hc,
 #endif
+		&erofs_compressor_zlib,
 	};
 
 	int ret, i;
-- 
2.14.4
