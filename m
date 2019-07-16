From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 16 Jul 2019 15:04:15 +0800
Subject: [PATCH v2 13/17] erofs-utils: introduce dev_fillzero
In-Reply-To: <20190716070419.30203-1-gaoxiang25@huawei.com>
References: <20190716070419.30203-1-gaoxiang25@huawei.com>
Message-ID: <20190716070419.30203-14-gaoxiang25@huawei.com>

add dev_fillzero() to fill zero within a range.
FALLOC_FL_PUNCH_HOLE is perferred if supported.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 configure.ac       |  3 ++-
 include/erofs/io.h |  1 +
 lib/cache.c        |  5 ++---
 lib/io.c           | 27 +++++++++++++++++++++++++++
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6cc0c60..6f4eacc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -72,6 +72,7 @@ AC_CHECK_HEADERS(m4_flatten([
 	dirent.h
 	fcntl.h
 	inttypes.h
+	linux/falloc.h
 	linux/types.h
 	limits.h
 	stddef.h
@@ -115,7 +116,7 @@ AC_CHECK_DECL(lseek64,[AC_DEFINE(HAVE_LSEEK64_PROTOTYPE, 1,
    #include <unistd.h>])
 
 # Checks for library functions.
-AC_CHECK_FUNCS([gettimeofday memset realpath strdup strerror strrchr strtoull])
+AC_CHECK_FUNCS([fallocate gettimeofday memset realpath strdup strerror strrchr strtoull])
 
 # Configure lz4
 test -z $LZ4_LIBS && LZ4_LIBS='-llz4'
diff --git a/include/erofs/io.h b/include/erofs/io.h
index 9471388..aafb1e7 100644
--- a/include/erofs/io.h
+++ b/include/erofs/io.h
@@ -19,6 +19,7 @@
 int dev_open(const char *devname);
 void dev_close(void);
 int dev_write(const void *buf, u64 offset, size_t len);
+int dev_fillzero(u64 offset, size_t len);
 int dev_fsync(void);
 u64 dev_length(void);
 
diff --git a/lib/cache.c b/lib/cache.c
index 967b543..76e6d78 100644
--- a/lib/cache.c
+++ b/lib/cache.c
@@ -274,7 +274,6 @@ erofs_blk_t erofs_mapbh(struct erofs_buffer_block *bb, bool end)
 
 bool erofs_bflush(struct erofs_buffer_block *bb)
 {
-	static const char zero[EROFS_BLKSIZ] = {0};
 	struct erofs_buffer_block *p, *n;
 	erofs_blk_t blkaddr;
 
@@ -304,8 +303,8 @@ bool erofs_bflush(struct erofs_buffer_block *bb)
 
 		padding = EROFS_BLKSIZ - p->buffers.off % EROFS_BLKSIZ;
 		if (padding != EROFS_BLKSIZ)
-			dev_write(zero, blknr_to_addr(blkaddr) - padding,
-				  padding);
+			dev_fillzero(blknr_to_addr(blkaddr) - padding,
+				     padding);
 
 		DBG_BUGON(!list_empty(&p->buffers.list));
 
diff --git a/lib/io.c b/lib/io.c
index f624535..d39661c 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -7,8 +7,12 @@
  * Created by Li Guifu <bluce.liguifu at huawei.com>
  */
 #define _LARGEFILE64_SOURCE
+#define _GNU_SOURCE
 #include <sys/stat.h>
 #include "erofs/io.h"
+#ifdef HAVE_LINUX_FALLOC_H
+#include <linux/falloc.h>
+#endif
 
 #define pr_fmt(fmt) "EROFS IO: " FUNC_LINE_FMT fmt "\n"
 #include "erofs/print.h"
@@ -110,6 +114,29 @@ int dev_write(const void *buf, u64 offset, size_t len)
 	return 0;
 }
 
+int dev_fillzero(u64 offset, size_t len)
+{
+	static const char zero[EROFS_BLKSIZ] = {0};
+	int ret;
+
+	if (cfg.c_dry_run)
+		return 0;
+
+#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE)
+	if (fallocate(erofs_devfd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+		      offset, len) >= 0)
+		return 0;
+#endif
+	while (len > EROFS_BLKSIZ) {
+		ret = dev_write(zero, offset, EROFS_BLKSIZ);
+		if (ret)
+			return ret;
+		len -= EROFS_BLKSIZ;
+		offset += EROFS_BLKSIZ;
+	}
+	return dev_write(zero, offset, len);
+}
+
 int dev_fsync(void)
 {
 	int ret;
-- 
2.17.1
