From: jack@suse.cz (Jan Kara)
Date: Wed, 14 Aug 2019 13:00:22 +0200
Subject: [PATCH v2] Add flags option to get xattr method paired to
 __vfs_getxattr
In-Reply-To: <20190813145527.26289-1-salyzyn@android.com>
References: <20190813145527.26289-1-salyzyn@android.com>
Message-ID: <20190814110022.GB26273@quack2.suse.cz>

On Tue 13-08-19 07:55:06, Mark Salyzyn wrote:
...
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 90dd78f0eb27..71f887518d6f 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
...
>  ssize_t
>  __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
> -	       void *value, size_t size)
> +	       void *value, size_t size, int flags)
>  {
>  	const struct xattr_handler *handler;
> -
> -	handler = xattr_resolve_name(inode, &name);
> -	if (IS_ERR(handler))
> -		return PTR_ERR(handler);
> -	if (!handler->get)
> -		return -EOPNOTSUPP;
> -	return handler->get(handler, dentry, inode, name, value, size);
> -}
> -EXPORT_SYMBOL(__vfs_getxattr);
> -
> -ssize_t
> -vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
> -{
> -	struct inode *inode = dentry->d_inode;
>  	int error;
>  
> +	if (flags & XATTR_NOSECURITY)
> +		goto nolsm;

Hum, is it OK for XATTR_NOSECURITY to skip even the xattr_permission()
check? I understand that for reads of security xattrs it actually does not
matter in practice but conceptually that seems wrong to me as
XATTR_NOSECURITY is supposed to skip just security-module checks to avoid
recursion AFAIU.

> diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
> index c1395b5bd432..1216d777d210 100644
> --- a/include/uapi/linux/xattr.h
> +++ b/include/uapi/linux/xattr.h
> @@ -17,8 +17,9 @@
>  #if __UAPI_DEF_XATTR
>  #define __USE_KERNEL_XATTR_DEFS
>  
> -#define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
> -#define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
> +#define XATTR_CREATE	 0x1	/* set value, fail if attr already exists */
> +#define XATTR_REPLACE	 0x2	/* set value, fail if attr does not exist */
> +#define XATTR_NOSECURITY 0x4	/* get value, do not involve security check */
>  #endif

It seems confusing to export XATTR_NOSECURITY definition to userspace when
that is kernel-internal flag. I'd just define it in include/linux/xattr.h
somewhere from the top of flags space (like 0x40000000).

Otherwise the patch looks OK to me (cannot really comment on the security
module aspect of this whole thing though).

								Honza
-- 
Jan Kara <jack at suse.com>
SUSE Labs, CR
