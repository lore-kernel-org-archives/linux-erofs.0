From: bluce.liguifu@huawei.com (Li Guifu)
Date: Thu, 20 Dec 2018 14:49:25 +0800
Subject: [PATCH v2 2/5] erofs-utils: let erofs-utils use shared libraries
 if it can
In-Reply-To: <20181219043844.43451-2-gaoxiang25@huawei.com>
References: <20181219040516.21113-1-gaoxiang25@huawei.com>
 <20181219043844.43451-1-gaoxiang25@huawei.com>
 <20181219043844.43451-2-gaoxiang25@huawei.com>
Message-ID: <3380ebcb-d546-06a4-05db-93314781583e@huawei.com>

On 2018/12/19 12:38, Gao Xiang wrote:
> As an option, add LDFLAGS=--static LIBS=-Wl,--static
> in front of ./configure to force static compilation
> as before.
>  ex, (force static compilation)
>  $ LDFLAGS=--static LIBS=-Wl,--static ./configure
>  $ make
>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  Makefile.am | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index cef847d..4381d3d 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -25,7 +25,6 @@ noinst_HEADERS = erofs_config.h  \
>  				 mkfs_file.h
>  
>  mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\"
> -mkfs_erofs_LDFLAGS  = --static
>  ACLOCAL_AMFLAGS = -I m4
>  
>  if SUPPORT_LARG_FILE_AT_BIT32

Reviewed-by: Li Guifu <bluce.liguifu at huawei.com>

Thanks,
