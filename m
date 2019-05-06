From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 6 May 2019 20:13:33 +0800
Subject: [PATCH] staging: erofs: set sb->s_root to NULL when failing from
 __getname()
In-Reply-To: <1557140462-22578-1-git-send-email-cgxu519@gmail.com>
References: <1557140462-22578-1-git-send-email-cgxu519@gmail.com>
Message-ID: <e8252540-53db-f327-199f-1e1c67027515@aol.com>

Hi Chengguang,

On 2019/5/6 ??????7:01, Chengguang Xu wrote:
> Set sb->s_root to NULL when failing from __getname(),
> so that we can avoid double dput and unnecessary operations
> in generic_shutdown_super().
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmail.com>

Thanks for catching this issue and it makes sense.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> ---
>  drivers/staging/erofs/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 15c784fba879..c8981662a49b 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -459,6 +459,7 @@ static int erofs_read_super(struct super_block *sb,
>  	 */
>  err_devname:
>  	dput(sb->s_root);
> +	sb->s_root = NULL;
>  err_iget:
>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
>  	iput(sbi->managed_cache);
> 
