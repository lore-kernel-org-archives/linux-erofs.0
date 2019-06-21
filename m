From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 21 Jun 2019 13:08:39 +0800
Subject: [PATCH] staging: erofs: remove needless dummy functions of
 erofs_{get,list}xattr
In-Reply-To: <20190621040808.3708-1-zbestahu@gmail.com>
References: <20190621040808.3708-1-zbestahu@gmail.com>
Message-ID: <f6b2ced7-79ea-9cc6-5e88-43552b5947a9@huawei.com>

Hi Yue,

On 2019/6/21 12:08, Yue Hu wrote:
> From: Yue Hu <huyue2 at yulong.com>
> 
> The two dummy functions of erofs_getxattr()/erofs_listxattr() will never
> be used if disable CONFIG_EROFS_FS_XATTR.
> 
> Signed-off-by: Yue Hu <huyue2 at yulong.com>
> ---
>  drivers/staging/erofs/xattr.h | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
> index 35ba5ac..2c1e46f 100644
> --- a/drivers/staging/erofs/xattr.h
> +++ b/drivers/staging/erofs/xattr.h
> @@ -72,19 +72,6 @@ static inline const struct xattr_handler *erofs_xattr_handler(unsigned index)
>  
>  int erofs_getxattr(struct inode *, int, const char *, void *, size_t);
>  ssize_t erofs_listxattr(struct dentry *, char *, size_t);
> -#else
> -static int __maybe_unused erofs_getxattr(struct inode *inode, int index,
> -	const char *name,
> -	void *buffer, size_t buffer_size)
> -{
> -	return -ENOTSUPP;
> -}
> -
> -static ssize_t __maybe_unused erofs_listxattr(struct dentry *dentry,
> -	char *buffer, size_t buffer_size)
> -{
> -	return -ENOTSUPP;
> -}
>  #endif

It's mainly used for erofs to directly call erofs_getxattr / erofs_listxattr (even 
xattr feature is off) to get a xattr in erofs itself, just follow what other
filesystems (e.g. f2fs) did, although these apis have not been used internally
yet but used as callbacks in inode_operations only.

I have no positive or negative tendency since the patch is minor and the only
benefit of this patch is that it removes some code which seems redundant currently.
However, if erofs_getxattr is needed later, it should be added back of course.
Therefore I think it could depend on Greg whether accept this patch or not.

Thanks,
Gao Xiang

>  
>  #ifdef CONFIG_EROFS_FS_POSIX_ACL
> 
