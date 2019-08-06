From: shenmeng999@126.com (shenmeng999@126.com)
Date: Tue,  6 Aug 2019 23:23:25 +0800
Subject: [PATCH] erofs-utils: get block device size correctly
Message-ID: <1565105005-21709-1-git-send-email-shenmeng999@126.com>

From: shenmeng996 <shenmeng999@126.com>

fstat return block device's size of zero.
use ioctl to get block device's size.

Signed-off-by: shenmeng996 <shenmeng999 at 126.com>
---
 lib/io.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/io.c b/lib/io.c
index 93328d3..ae3ac37 100644
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
@@ -49,7 +51,12 @@ int dev_open(const char *dev)
 
 	switch (st.st_mode & S_IFMT) {
 	case S_IFBLK:
-		erofs_devsz = st.st_size;
+		ret = ioctl(fd, BLKGETSIZE64, &erofs_devsz);
+		if (ret) {
+			erofs_err("failed to ioctl(%s).", dev);
+			close(fd);
+			return -errno;	
+		}
 		break;
 	case S_IFREG:
 		ret = ftruncate(fd, 0);
-- 
1.8.3.1
