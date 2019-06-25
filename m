From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 25 Jun 2019 14:16:10 +0800
Subject: [PATCH] staging: erofs: remove unsupported ->datamode check in
 fill_inline_data()
In-Reply-To: <20190625060825.7912-1-zbestahu@gmail.com>
References: <20190625060825.7912-1-zbestahu@gmail.com>
Message-ID: <bad38600-c175-4626-3365-75bd5ed4611d@aol.com>



?? 2019/6/25 ????2:08, Yue Hu ????:
> From: Yue Hu <huyue2 at yulong.com>
> 
> Already check if ->datamode is supported in read_inode(), no need to check
> again in the next fill_inline_data() only called by fill_inode().
> 
> Signed-off-by: Yue Hu <huyue2 at yulong.com>

looks good to me,
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

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
