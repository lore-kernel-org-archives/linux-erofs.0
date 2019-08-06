From: hsiangkao@gmx.com (Gao Xiang)
Date: Wed, 7 Aug 2019 00:29:48 +0800
Subject: [PATCH] erofs-utils: get block device size correctly
In-Reply-To: <1565105005-21709-1-git-send-email-shenmeng999@126.com>
References: <1565105005-21709-1-git-send-email-shenmeng999@126.com>
Message-ID: <20190806162947.GA28162@hsiangkao-HP-ZHAN-66-Pro-G1>

Hi shenmeng,

On Tue, Aug 06, 2019@11:23:25PM +0800, shenmeng999@126.com wrote:
> From: shenmeng996 <shenmeng999 at 126.com>
>
> fstat return block device's size of zero.
> use ioctl to get block device's size.
>
> Signed-off-by: shenmeng996 <shenmeng999 at 126.com>
> ---
>  lib/io.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/lib/io.c b/lib/io.c
> index 93328d3..ae3ac37 100644
> --- a/lib/io.c
> +++ b/lib/io.c
> @@ -9,6 +9,8 @@
>  #define _LARGEFILE64_SOURCE
>  #define _GNU_SOURCE
>  #include <sys/stat.h>
> +#include <sys/ioctl.h>
> +#include <linux/fs.h>
>  #include "erofs/io.h"
>  #ifdef HAVE_LINUX_FALLOC_H
>  #include <linux/falloc.h>
> @@ -49,7 +51,12 @@ int dev_open(const char *dev)
>
>  	switch (st.st_mode & S_IFMT) {
>  	case S_IFBLK:
> -		erofs_devsz = st.st_size;
> +		ret = ioctl(fd, BLKGETSIZE64, &erofs_devsz);

Thanks for your patch :)

I got some reports of this issue months ago, but I'm afraid
that we should support the legacy BLKGETSIZE approach as well
as what other filesystem userspace tools do...

Could you kindly take some time to make a full patch of it? :)

BTW, from the point of view of use, it's better to generate
a image file indirectly and `dd' to the real device rather than
directly use block device as the output since erofs-utils
will do unaligned read/write even overwrite, which isn't
very friendly to flash-based devices...

Thanks,
Gao Xiang

> +		if (ret) {
> +			erofs_err("failed to ioctl(%s).", dev);
> +			close(fd);
> +			return -errno;
> +		}
>  		break;
>  	case S_IFREG:
>  		ret = ftruncate(fd, 0);
> --
> 1.8.3.1
>
