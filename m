From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 19 Dec 2018 20:40:24 +0800
Subject: [PATCH 1/2] erofs-utils: erofs_io.c: clean up dev_open()
Message-ID: <20181219124025.17947-1-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 erofs_io.c  | 74 ++++++++++++++++++-------------------------------------------
 mkfs_main.c | 11 ++++-----
 2 files changed, 27 insertions(+), 58 deletions(-)

diff --git a/erofs_io.c b/erofs_io.c
index 57e283e..563ca3f 100644
--- a/erofs_io.c
+++ b/erofs_io.c
@@ -22,93 +22,61 @@
 #define pr_fmt(fmt) "DEVICE IO: " FUNC_LINE_FMT fmt "\n"
 #include "erofs_debug.h"
 
-static char *erofs_devname;
+static const char *erofs_devname;
 static int erofs_devfd = -1;
 static u64 erofs_devsz;
 
 void dev_close(void)
 {
 	close(erofs_devfd);
-	free(erofs_devname);
 	erofs_devname = NULL;
 	erofs_devfd   = -1;
 	erofs_devsz   = 0;
 }
 
-int dev_open(const char *devname)
+int dev_open(const char *dev)
 {
-	char *dev;
 	struct stat st;
-	int fd;
-	int ret;
-
-	dev = strdup(devname);
-	if (!dev)
-		return -ENOMEM;
-again:
-	fd = open(dev, O_RDWR);
-	if (fd < 0 && errno != ENOENT) {
-		erofs_err("Open device/file(%s) fail.", dev);
-		free(dev);
-		return -errno;
-	}
+	int fd, ret;
 
+	fd = open(dev, O_RDWR | O_CREAT, 0644);
 	if (fd < 0) {
-		fd = open(dev, O_RDWR | O_CREAT | O_NOCTTY,
-			  S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
-		if (fd < 0) {
-			if (errno != EEXIST) {
-				erofs_err("Create image file(%s) fail.", dev);
-				free(dev);
-				return -errno;
-			}
-
-			erofs_dbg("Image file(%s) existed, it might be created by the other users.",
-				  dev);
-			goto again;
-
-		}
+		erofs_err("failed to open(%s).", dev);
+		return -errno;
 	}
 
 	ret = fstat(fd, &st);
 	if (ret) {
-		erofs_err("Get stat of device/file(%s) fail.", dev);
+		erofs_err("failed to fstat(%s).", dev);
 		close(fd);
-		free(dev);
 		return -errno;
 	}
 
-	if (!S_ISBLK(st.st_mode) && !S_ISREG(st.st_mode)) {
-		erofs_err("File (%s) type is wrong.", dev);
-		close(fd);
-		free(dev);
-		return -EINVAL;
-	}
-
-	if (S_ISREG(st.st_mode)) {
+	switch(st.st_mode & S_IFMT) {
+	case S_IFBLK:
+		erofs_devsz = st.st_size;
+		break;
+	case S_IFREG:
 		ret = ftruncate(fd, 0);
 		if (ret) {
-			erofs_err("Truncate file(%s) fail.", dev);
+			erofs_err("failed to ftruncate(%s).", dev);
 			close(fd);
-			free(dev);
 			return -errno;
 		}
-	}
-
-	erofs_devname = dev;
-	erofs_devfd   = fd;
-
-	if (S_ISBLK(st.st_mode)) {
-		erofs_devsz = st.st_size;
-	} else {
 		/* INT64_MAX is the limit of kernel vfs */
 		erofs_devsz = INT64_MAX;
+		break;
+	default:
+		erofs_err("bad file type (%s, %o).", dev, st.st_mode);
+		close(fd);
+		return -EINVAL;
 	}
 
+	erofs_devname = dev;
+	erofs_devfd = fd;
 	erofs_devsz = round_down(erofs_devsz, EROFS_BLKSIZE);
 
-	erofs_info("Open device/file %s", erofs_devname);
-
+	erofs_info("successfully to open %s", dev);
 	return 0;
 }
 
diff --git a/mkfs_main.c b/mkfs_main.c
index 17611f4..30b0a22 100644
--- a/mkfs_main.c
+++ b/mkfs_main.c
@@ -107,11 +107,6 @@ static void mkfs_parse_options_cfg(int argc, char *argv[])
 	erofs_compress_alg_init(erofs_cfg.c_alg_name);
 
 	mkfs_dump_config();
-
-	if (dev_open(erofs_cfg.c_img_path) < 0) {
-		erofs_err("dev_open is failed!!!");
-		usage(argv[0]);
-	}
 }
 
 void mkfs_update_erofs_header(u64 root_addr)
@@ -156,6 +151,12 @@ int main(int argc, char **argv)
 	mkfs_init_configure();
 	mkfs_parse_options_cfg(argc, argv);
 
+	err = dev_open(erofs_cfg.c_img_path);
+	if (err) {
+		usage(argv[0]);
+		return -1;
+	}
+
 	proot_node = mkfs_prepare_root_inode(erofs_cfg.c_src_path);
 	if (!proot_node)
 		goto exit;
-- 
2.14.4
