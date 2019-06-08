From: hsiangkao@aol.com (Gao Xiang)
Date: Sat, 8 Jun 2019 20:06:08 +0800
Subject: [PATCH] staging: erofs: fix warning Comparison to bool
In-Reply-To: <20190608093937.GA10461@hari-Inspiron-1545>
References: <20190608093937.GA10461@hari-Inspiron-1545>
Message-ID: <8aa1fe39-27f3-e74b-5985-c67e04be2f31@aol.com>



On 2019/6/8 ??????5:39, Hariprasad Kelam wrote:
> fix below warnings reported by coccicheck
> 
> drivers/staging/erofs/unzip_vle.c:332:11-18: WARNING: Comparison to bool
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam at gmail.com>

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> ---
>  drivers/staging/erofs/unzip_vle.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 9ecaa87..f3d0d2c 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -329,7 +329,7 @@ try_to_claim_workgroup(struct z_erofs_vle_workgroup *grp,
>  		       z_erofs_vle_owned_workgrp_t *owned_head,
>  		       bool *hosted)
>  {
> -	DBG_BUGON(*hosted == true);
> +	DBG_BUGON(*hosted);
>  
>  	/* let's claim these following types of workgroup */
>  retry:
> 
