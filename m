From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 26 Jun 2019 18:51:55 +0800
Subject: [PATCH RESEND] staging: erofs: remove unsupported ->datamode
 check in fill_inline_data()
In-Reply-To: <20190626103936.9064-1-zbestahu@gmail.com>
References: <20190626103936.9064-1-zbestahu@gmail.com>
Message-ID: <9c9c656e-2f29-d086-362e-76bf1760191a@huawei.com>

Hi Yue,

On 2019/6/26 18:39, Yue Hu wrote:
> From: Yue Hu <huyue2 at yulong.com>
> 
> Already check if ->datamode is supported in read_inode(), no need to check
> again in the next fill_inline_data() only called by fill_inode().
> 
> Signed-off-by: Yue Hu <huyue2 at yulong.com>
> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Bump the patch version in the title as Greg said...
Otherwise, it is hard to differ which patch is the latest patch...

Thanks,
Gao Xiang

> ---
>  drivers/staging/erofs/inode.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> index e51348f..d6e1e16 100644
> --- a/drivers/staging/erofs/inode.c
> +++ b/drivers/staging/erofs/inode.c
> @@ -129,8 +129,6 @@ static int fill_inline_data(struct inode *inode, void *data,
>  	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
>  	const int mode = vi->datamode;
>  
> -	DBG_BUGON(mode >= EROFS_INODE_LAYOUT_MAX);
> -
>  	/* should be inode inline C */
>  	if (mode != EROFS_INODE_LAYOUT_INLINE)
>  		return 0;
> 
