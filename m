From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 23 Aug 2018 19:22:24 +0800
Subject: [WIP] [PREVIEW] [RFC PATCH 1/3] staging: erofs: serialize access
 to works strictly
In-Reply-To: <1534936164-112151-1-git-send-email-gaoxiang25@huawei.com>
References: <1534936164-112151-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <39e4cf1d-7928-faba-a30d-29a10142027b@huawei.com>



On 2018/8/22 19:09, Gao Xiang wrote:
> Make sure other accesses to primary works are serialized
> after the primary followed work ends.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> Hi,
> 
> This patch series are testing under pressure now, and could be changed later.
> 
> Thanks,
> Gao Xiang

Please ignore this version patchset (It has compilation error in nocache mode),
I will send the next version to fix compilation error later.

Thanks,
Gao Xiang

> 
>  drivers/staging/erofs/unzip_vle.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 6c5739a..eae9be1 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -395,18 +395,21 @@ struct z_erofs_vle_work_finder {
>  
>  	mutex_init(&work->lock);
>  
> +	/* lock all primary followed works before visible to others */
> +	if (unlikely(!mutex_trylock(&work->lock)))
> +		BUG();
> +
>  	if (gnew) {
>  		int err = erofs_register_workgroup(f->sb, &grp->obj, 0);
>  
>  		if (err) {
> +			mutex_unlock(&work->lock);
>  			kmem_cache_free(z_erofs_workgroup_cachep, grp);
>  			return ERR_PTR(-EAGAIN);
>  		}
>  	}
>  
>  	*f->owned_head = *f->grp_ret = grp;
> -
> -	mutex_lock(&work->lock);
>  	return work;
>  }
>  
> 
