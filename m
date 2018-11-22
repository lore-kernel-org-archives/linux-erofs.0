From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 22 Nov 2018 11:17:11 +0100
Subject: [PATCH 02/10] staging: erofs: fix race when the managed cache is
 enabled
In-Reply-To: <20181120143425.43637-3-gaoxiang25@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-3-gaoxiang25@huawei.com>
Message-ID: <20181122101711.GA3189@kroah.com>

On Tue, Nov 20, 2018@10:34:17PM +0800, Gao Xiang wrote:
> When the managed cache is enabled, the last reference count
> of a workgroup must be used for its workstation.
> 
> Otherwise, it could lead to incorrect (un)freezes in
> the reclaim path, and it would be harmful.
> 
> A typical race as follows:
> 
> Thread 1 (In the reclaim path)  Thread 2
> workgroup_freeze(grp, 1)                                refcnt = 1
> ...
> workgroup_unfreeze(grp, 1)                              refcnt = 1
>                                 workgroup_get(grp)      refcnt = 2 (x)
> workgroup_put(grp)                                      refcnt = 1 (x)
>                                 ...unexpected behaviors
> 
> * grp is detached but still used, which violates cache-managed
>   freeze constraint.
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/internal.h |   1 +
>  drivers/staging/erofs/utils.c    | 131 +++++++++++++++++++++++++++------------
>  2 files changed, 93 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index 57575c7f5635..89dbd0888e53 100644
> --- a/drivers/staging/erofs/internal.h
> +++ b/drivers/staging/erofs/internal.h
> @@ -250,6 +250,7 @@ static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
>  }
>  
>  #define __erofs_workgroup_get(grp)	atomic_inc(&(grp)->refcount)
> +#define __erofs_workgroup_put(grp)	atomic_dec(&(grp)->refcount)

Any specific reason why you are not using the refcount.h api instead of
"doing it yourself" with atomic_inc/dec()?

I'm not rejecting this, just curious.

thanks,

greg k-h
