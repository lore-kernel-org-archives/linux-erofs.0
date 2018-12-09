From: hsiangkao@aol.com (=?UTF-8?B?6auY57+U?=)
Date: Sun, 9 Dec 2018 21:50:13 +0900
Subject: [PATCH] staging: erofs: Add braces to do-while statements
In-Reply-To: <20181208210738.29298-1-laumann.thomas@gmail.com>
References: <20181208210738.29298-1-laumann.thomas@gmail.com>
Message-ID: <5e9dec5b-a90d-3673-7eec-a4dcab974d01@aol.com>

Hi Thomas,

On 2018/12/9 6:07, Thomas Jespersen wrote:
> This fixes warning reported by sparse (with -Wsparse-all).
> 
> Signed-off-by: Thomas Jespersen <laumann.thomas at gmail.com>
> ---
>  drivers/staging/erofs/internal.h | 4 ++--
>  drivers/staging/erofs/utils.c    | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index 57575c7f56355424a..bf180a803446655d4 100644
> --- a/drivers/staging/erofs/internal.h
> +++ b/drivers/staging/erofs/internal.h
> @@ -232,9 +232,9 @@ static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
>  	/* spin if it is temporarily locked at the reclaim path */
>  	if (unlikely(o == locked)) {
>  #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
> -		do
> +		do {
>  			cpu_relax();
> -		while (atomic_read(&grp->refcount) == locked);
> +		} while (atomic_read(&grp->refcount) == locked);
>  #endif
>  		goto repeat;
>  	}


Could you check the latest source code at
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/tree/drivers/staging/erofs?h=staging-next
the above you sent doesn't seem the latest source code...

and send your patch to Greg and the staging mailing list as well? if you
want to upstream immediately.

To:
  Greg Kroah-Hartman         <gregkh at linuxfoundation.org>
  linux-staging mailing list <devel at driverdev.osuosl.org>

  linux-erofs mailing list   <linux-erofs at lists.ozlabs.org>
  Gao Xiang                  <gaoxiang25 at huawei.com>
  Chao Yu                    <yuchao0 at huawei.com>

Thanks,
Gao Xiang
