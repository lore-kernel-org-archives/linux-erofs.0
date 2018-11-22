From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 22 Nov 2018 11:22:31 +0100
Subject: [PATCH 05/10] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <20181120143425.43637-6-gaoxiang25@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-6-gaoxiang25@huawei.com>
Message-ID: <20181122102230.GF3189@kroah.com>

On Tue, Nov 20, 2018@10:34:20PM +0800, Gao Xiang wrote:
> Just like other generic locks, insert a full barrier
> in case of memory reorder.
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/internal.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index 2e0ef92c138b..f77653d33633 100644
> --- a/drivers/staging/erofs/internal.h
> +++ b/drivers/staging/erofs/internal.h
> @@ -209,6 +209,7 @@ static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
>  static inline void erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
>  					    int orig_val)
>  {
> +	smp_mb();

Please document this memory barrier.  It does not make much sense to
me...

thanks,

greg k-h
