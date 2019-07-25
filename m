From: gregkh@linuxfoundation.org (Greg KH)
Date: Thu, 25 Jul 2019 09:45:08 +0200
Subject: [PATCH] v3: staging: erofs: fix typo
In-Reply-To: <1563394279-6719-1-git-send-email-karen.palacio.1994@gmail.com>
References: <1563394279-6719-1-git-send-email-karen.palacio.1994@gmail.com>
Message-ID: <20190725074508.GA15090@kroah.com>

On Wed, Jul 17, 2019@05:11:19PM -0300, Karen Palacio wrote:
> Fix typo in Kconfig
> 
> Signed-off-by: Karen Palacio <karen.palacio.1994 at gmail.com>
> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> 
> diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
> index d04b798..0dcefac 100644
> --- a/drivers/staging/erofs/Kconfig
> +++ b/drivers/staging/erofs/Kconfig
> @@ -88,7 +88,7 @@ config EROFS_FS_IO_MAX_RETRIES
>           If unsure, leave the default value (5 retries, 6 IOs at most).
> 
>  config EROFS_FS_ZIP
> -       bool "EROFS Data Compresssion Support"
> +       bool "EROFS Data Compression Support"
>         depends on EROFS_FS
>         select LZ4_DECOMPRESS
>         help
> ---
>  drivers/staging/erofs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
> index d04b798..0dcefac 100644
> --- a/drivers/staging/erofs/Kconfig
> +++ b/drivers/staging/erofs/Kconfig
> @@ -88,7 +88,7 @@ config EROFS_FS_IO_MAX_RETRIES
>  	  If unsure, leave the default value (5 retries, 6 IOs at most).
>  
>  config EROFS_FS_ZIP
> -	bool "EROFS Data Compresssion Support"
> +	bool "EROFS Data Compression Support"
>  	depends on EROFS_FS
>  	select LZ4_DECOMPRESS
>  	help

Patch is corrupted and can not be applied.

There are also 2 copies of it here :(

Please fix up and resend.

thanks,

greg k-h
