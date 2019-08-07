From: shenmeng999@126.com (shenmeng999@126.com)
Date: Wed,  7 Aug 2019 22:36:55 +0800
Subject: [PATCH v2] erofs-utils: get block device size correctly
Message-ID: <1565188615-19591-1-git-send-email-shenmeng999@126.com>

From: shenmeng996 <shenmeng999@126.com>

fstat return block device's size of zero.
use ioctl to get block device's size.

Signed-off-by: shenmeng996 <shenmeng999 at 126.com>
---
 lib/io.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 lib/io.c

diff --git a/lib/io.c b/lib/io.c
old mode 100644
new mode 100755
index 93328d3..a93c509
--- a/lib/io.c
+++ b/lib/io.c
@@ -9,6 +9,8 @@
 #define _LARGEFILE64_SOURCE
 #define _GNU_SOURCE
 #include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
 #include "erofs/io.h"
 #ifdef HAVE_LINUX_FALLOC_H
 #include <linux/falloc.h>
@@ -21,6 +23,23 @@ static const char *erofs_devname;
 static int erofs_devfd = -1;
 static u64 erofs_devsz;
 
+int dev_get_blkdev_size(int fd, u64 *bytes)
+{
+	unsigned long size;
+
+#ifdef BLKGETSIZE64
+	if (ioctl(fd, BLKGETSIZE64, bytes) >= 0)
+		return 0;
+#endif
+
+	if (ioctl(fd, BLKGETSIZE, &size) >= 0) {
+		*bytes = ((u64)size << 9);
+		return 0;
+	}
+
+	return -errno;
+}
+
 void dev_close(void)
 {
 	close(erofs_devfd);
@@ -49,7 +68,12 @@ int dev_open(const char *dev)
 
 	switch (st.st_mode & S_IFMT) {
 	case S_IFBLK:
-		erofs_devsz = st.st_size;
+		ret = dev_get_blkdev_size(fd, &erofs_devsz);
+		if (ret) {
+			erofs_err("failed to get block device size(%s).", dev);
+			close(fd);
+			return ret;	
+		}
 		break;
 	case S_IFREG:
 		ret = ftruncate(fd, 0);
-- 
1.8.3.1
