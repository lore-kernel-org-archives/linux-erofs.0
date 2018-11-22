From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 22 Nov 2018 11:20:46 +0100
Subject: [PATCH 03/10] staging: erofs: atomic_cond_read_relaxed on
 ref-locked workgroup
In-Reply-To: <20181120143425.43637-4-gaoxiang25@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-4-gaoxiang25@huawei.com>
Message-ID: <20181122102046.GD3189@kroah.com>

On Tue, Nov 20, 2018@10:34:18PM +0800, Gao Xiang wrote:
> It's better to use atomic_cond_read_relaxed, which is implemented
> in hardware instructions to monitor a variable changes currently
> for ARM64, instead of open-coded busy waiting.
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/internal.h | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index 89dbd0888e53..eb80ba44d072 100644
> --- a/drivers/staging/erofs/internal.h
> +++ b/drivers/staging/erofs/internal.h
> @@ -221,23 +221,29 @@ static inline void erofs_workgroup_unfreeze(
>  	preempt_enable();
>  }
>  
> +#if defined(CONFIG_SMP)
> +static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
> +{
> +	return atomic_cond_read_relaxed(&grp->refcount,
> +					VAL != EROFS_LOCKED_MAGIC);
> +}
> +#else
> +static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
> +{
> +	int v = atomic_read(&grp->refcount);

Again, why not use the refcount api instead of doing this yourself?

thanks,

greg k-h
