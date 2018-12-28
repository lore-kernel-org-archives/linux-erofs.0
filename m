From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 28 Dec 2018 09:57:03 +0800
Subject: [PREVIEW] [PATCH 1/3] staging: erofs: fix fast symlink w/o xattr
 if xattr is enabled
In-Reply-To: <20181226093113.8942-1-gaoxiang25@huawei.com>
References: <20181226093113.8942-1-gaoxiang25@huawei.com>
Message-ID: <b00d2f13-e24b-83d1-1efe-caaeaac27515@huawei.com>

On 2018/12/26 17:31, Gao Xiang wrote:
> Currently, this will hit a BUG_ON for these symlinks as follows:
> 
> - kernel message
> ------------[ cut here ]------------
> kernel BUG at drivers/staging/erofs/xattr.c:59!
> SMP PTI
> CPU: 1 PID: 1170 Comm: getllxattr Not tainted 4.20.0-rc6+ #92
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
> RIP: 0010:init_inode_xattrs+0x22b/0x270
> Code: 48 0f 45 ea f0 ff 4d 34 74 0d 41 83 4c 24 e0 01 31 c0 e9 00 fe ff ff 48 89 ef e8 e0 31 9e ff eb e9 89 e8 e9 ef fd ff ff 0f 0$
>  <0f> 0b 48 89 ef e8 fb f6 9c ff 48 8b 45 08 a8 01 75 24 f0 ff 4d 34
> RSP: 0018:ffffa03ac026bdf8 EFLAGS: 00010246
> ------------[ cut here ]------------
> ...
> Call Trace:
>  erofs_listxattr+0x30/0x2c0
>  ? selinux_inode_listxattr+0x5a/0x80
>  ? kmem_cache_alloc+0x33/0x170
>  ? security_inode_listxattr+0x27/0x40
>  listxattr+0xaf/0xc0
>  path_listxattr+0x5a/0xa0
>  do_syscall_64+0x43/0xf0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ...
> ---[ end trace 3c24b49408dc0c72 ]---
> 
> Fix it by checking ->xattr_isize in init_inode_xattrs(),
> and it also fixes improper return value -ENOTSUPP
> (it should be -ENODATA if xattr is enabled) for those inodes.
> 
> Fixes: b17500a0fdba ("staging: erofs: introduce xattr & acl support")
> Reported-by: Li Guifu <bluce.liguifu at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/inode.c |  8 ++++----
>  drivers/staging/erofs/xattr.c | 17 ++++++++++++-----
>  2 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> index d7fbf5f4600f..f99954dbfdb5 100644
> --- a/drivers/staging/erofs/inode.c
> +++ b/drivers/staging/erofs/inode.c
> @@ -185,16 +185,16 @@ static int fill_inode(struct inode *inode, int isdir)
>  		/* setup the new inode */
>  		if (S_ISREG(inode->i_mode)) {
>  #ifdef CONFIG_EROFS_FS_XATTR
> -			if (vi->xattr_isize)
> -				inode->i_op = &erofs_generic_xattr_iops;
> +			inode->i_op = &erofs_generic_xattr_iops;
>  #endif
>  			inode->i_fop = &generic_ro_fops;
>  		} else if (S_ISDIR(inode->i_mode)) {
>  			inode->i_op =
>  #ifdef CONFIG_EROFS_FS_XATTR
> -				vi->xattr_isize ? &erofs_dir_xattr_iops :
> -#endif
> +				&erofs_dir_xattr_iops;
> +#else
>  				&erofs_dir_iops;
> +#endif
>  			inode->i_fop = &erofs_dir_fops;
>  		} else if (S_ISLNK(inode->i_mode)) {
>  			/* by default, page_get_link is used for symlink */
> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
> index 80dca6a4adbe..c15f33637ba8 100644
> --- a/drivers/staging/erofs/xattr.c
> +++ b/drivers/staging/erofs/xattr.c
> @@ -56,7 +56,18 @@ static int init_inode_xattrs(struct inode *inode)
>  		return 0;
>  
>  	vi = EROFS_V(inode);
> -	BUG_ON(!vi->xattr_isize);
> +
> +	/*
> +	 * bypass all xattr operations if vi->xattr_isize is not enough to
> +	 * contain erofs_xattr_ibody_header (and it should only be 0).
> +	 */
> +	if (vi->xattr_isize < sizeof(struct erofs_xattr_ibody_header)) {

vi->xattr_isize <= sizeof(struct erofs_xattr_ibody_header)?

Thanks,

> +		if (unlikely(vi->xattr_isize)) {
> +			DBG_BUGON(1);
> +			return -EIO;	/* xattr ondisk layout error */
> +		}
> +		return -ENOATTR;
> +	}
>  
>  	sb = inode->i_sb;
>  	sbi = EROFS_SB(sb);
> @@ -422,7 +433,6 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
>  		struct dentry *unused, struct inode *inode,
>  		const char *name, void *buffer, size_t size)
>  {
> -	struct erofs_vnode *const vi = EROFS_V(inode);
>  	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
>  
>  	switch (handler->flags) {
> @@ -440,9 +450,6 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
>  		return -EINVAL;
>  	}
>  
> -	if (!vi->xattr_isize)
> -		return -ENOATTR;
> -
>  	return erofs_getxattr(inode, handler->flags, name, buffer, size);
>  }
>  
> 
