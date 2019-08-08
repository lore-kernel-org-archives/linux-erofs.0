From: shenmeng999@126.com (shenmeng999)
Date: Thu, 8 Aug 2019 10:50:24 +0800 (CST)
Subject: [PATCH v2] erofs-utils: get block device size correctly
In-Reply-To: <20190807182644.GA13848@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <1565188615-19591-1-git-send-email-shenmeng999@126.com>
 <20190807182644.GA13848@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <e551209.248f.16c6f227220.Coremail.shenmeng999@126.com>

Hi hsiangkao:
    I agree with your modification.It's getting better.Thanks!


At 2019-08-08 02:26:50, "Gao Xiang" <hsiangkao at aol.com>, said: 
>Hi shenmeng,
>
>On Wed, Aug 07, 2019@10:36:55PM +0800, shenmeng999@126.com wrote:
>> From: shenmeng996 <shenmeng999 at 126.com>
>> 
>> fstat return block device's size of zero.
>> use ioctl to get block device's size.
>> 
>> Signed-off-by: shenmeng996 <shenmeng999 at 126.com>
>
>
>Thanks for your patch v2 :)
>
>It looks good to me, and I update this patch so that
>autoconf can check these new header files.
>https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=experimental&id=0f225449962b4a9716985e7530a395a9500d0de6
>Do you agree with this modification? please share your thought about this.
>
>Thanks,
>Gao Xiang
>
>diff --git a/configure.ac b/configure.ac
>index 6f4eacc..fcdf30a 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -73,12 +73,14 @@ AC_CHECK_HEADERS(m4_flatten([
> 	fcntl.h
> 	inttypes.h
> 	linux/falloc.h
>+	linux/fs.h
> 	linux/types.h
> 	limits.h
> 	stddef.h
> 	stdint.h
> 	stdlib.h
> 	string.h
>+	sys/ioctl.h
> 	sys/stat.h
> 	sys/time.h
> 	unistd.h
>diff --git a/lib/io.c b/lib/io.c
>index 93328d3..15c5a35 100644
>--- a/lib/io.c
>+++ b/lib/io.c
>@@ -9,7 +9,11 @@
> #define _LARGEFILE64_SOURCE
> #define _GNU_SOURCE
> #include <sys/stat.h>
>+#include <sys/ioctl.h>
> #include "erofs/io.h"
>+#ifdef HAVE_LINUX_FS_H
>+#include <linux/fs.h>
>+#endif
> #ifdef HAVE_LINUX_FALLOC_H
> #include <linux/falloc.h>
> #endif
>@@ -21,6 +25,26 @@ static const char *erofs_devname;
> static int erofs_devfd = -1;
> static u64 erofs_devsz;
> 
>+int dev_get_blkdev_size(int fd, u64 *bytes)
>+{
>+	errno = ENOTSUP;
>+#ifdef BLKGETSIZE64
>+	if (ioctl(fd, BLKGETSIZE64, bytes) >= 0)
>+		return 0;
>+#endif
>+
>+#ifdef BLKGETSIZE
>+	{
>+		unsigned long size;
>+		if (ioctl(fd, BLKGETSIZE, &size) >= 0) {
>+			*bytes = ((u64)size << 9);
>+			return 0;
>+		}
>+	}
>+#endif
>+	return -errno;
>+}
>+
> void dev_close(void)
> {
> 	close(erofs_devfd);
>@@ -49,7 +73,12 @@ int dev_open(const char *dev)
> 
> 	switch (st.st_mode & S_IFMT) {
> 	case S_IFBLK:
>-		erofs_devsz = st.st_size;
>+		ret = dev_get_blkdev_size(fd, &erofs_devsz);
>+		if (ret) {
>+			erofs_err("failed to get block device size(%s).", dev);
>+			close(fd);
>+			return ret;
>+		}
> 		break;
> 	case S_IFREG:
> 		ret = ftruncate(fd, 0);
>-- 
>2.17.1
