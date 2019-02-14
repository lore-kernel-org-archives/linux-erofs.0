From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 14 Feb 2019 09:53:49 +0800
Subject: [PATCH] erofs: fix memleak of node's shared xattr array
In-Reply-To: <20190214093754.14339-1-shengyong1@huawei.com>
References: <20190214093754.14339-1-shengyong1@huawei.com>
Message-ID: <23bb86d7-817f-5447-eb2c-5e384d3a462b@huawei.com>

Hi Sheng,

On 2019/2/14 17:37, Sheng Yong wrote:
> If it fails to read a shared xattr page, the node's shared xattr array

node -> inode since erofs doesn't have 'node' concept like f2fs...

> is not freed. The next time the node's xattr is accessed, the previously
> allocated array is leaked.
> 

Good catch! I think it's a valid object memory leak.
the subject should be fixed as [PATCH] staging: erofs: fix memleak of inode's shared xattr array
                                              ^

Thanks,
Gao Xiang

> Signed-off-by: Sheng Yong <shengyong1 at huawei.com>
> ---
>  drivers/staging/erofs/xattr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
> index 80dca6a4adbe..e3f8b904a680 100644
> --- a/drivers/staging/erofs/xattr.c
> +++ b/drivers/staging/erofs/xattr.c
> @@ -92,8 +92,11 @@ static int init_inode_xattrs(struct inode *inode)
>  
>  			it.page = erofs_get_meta_page(sb,
>  				++it.blkaddr, S_ISDIR(inode->i_mode));
> -			if (IS_ERR(it.page))
> +			if (IS_ERR(it.page)) {
> +				kfree(vi->xattr_shared_xattrs);
> +				vi->xattr_shared_xattrs = NULL;
>  				return PTR_ERR(it.page);
> +			}
>  
>  			it.kaddr = kmap_atomic(it.page);
>  			atomic_map = true;
> 
