From: gregkh@linuxfoundation.org (Greg KH)
Date: Fri, 21 Jun 2019 09:01:25 +0200
Subject: [PATCH] staging: erofs: remove needless CONFIG_EROFS_FS_SECURITY
In-Reply-To: <20190620083004.2488-1-zbestahu@gmail.com>
References: <20190620083004.2488-1-zbestahu@gmail.com>
Message-ID: <20190621070125.GB3029@kroah.com>

On Thu, Jun 20, 2019@04:30:04PM +0800, Yue Hu wrote:
> From: Yue Hu <huyue2 at yulong.com>
> 
> erofs_xattr_security_handler is already marked __maybe_unused, no need
> to add CONFIG_EROFS_FS_SECURITY condition.
> 
> Signed-off-by: Yue Hu <huyue2 at yulong.com>
> ---
>  drivers/staging/erofs/xattr.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
> index df40654..06024ac 100644
> --- a/drivers/staging/erofs/xattr.c
> +++ b/drivers/staging/erofs/xattr.c
> @@ -499,13 +499,11 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
>  	.get	= erofs_xattr_generic_get,
>  };
>  
> -#ifdef CONFIG_EROFS_FS_SECURITY
>  const struct xattr_handler __maybe_unused erofs_xattr_security_handler = {
>  	.prefix	= XATTR_SECURITY_PREFIX,
>  	.flags	= EROFS_XATTR_INDEX_SECURITY,
>  	.get	= erofs_xattr_generic_get,
>  };
> -#endif

It's nicer just to leave this as-is for now, the memory savings isn't
much at all.

thanks,

greg k-h
