From: hsiangkao@gmx.com (Gao Xiang)
Date: Mon, 10 Dec 2018 05:37:27 +0800
Subject: [PATCH] staging: erofs: Add braces to do-while statements
In-Reply-To: <20181209155900.10164-1-laumann.thomas@gmail.com>
References: <20181209155900.10164-1-laumann.thomas@gmail.com>
Message-ID: <5db45ff8-ea1a-10f3-fc63-f1918818c9ce@gmx.com>

[oops... I found Thomas sent the exactly the same email again.]

On 2018/12/9 23:59, Thomas Jespersen wrote:
> This fixes warning reported by sparse (with -Wsparse-all).
>
> Signed-off-by: Thomas Jespersen <laumann.thomas at gmail.com>
> ---
>  drivers/staging/erofs/internal.h | 4 ++--
>  drivers/staging/erofs/utils.c    | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index 57575c7f5635..bf180a803446 100644
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

Could you please check the latest source code? I cannot find the above code...

So I think this patch cannot be applied directly :(

https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/tree/drivers/staging/erofs/internal.h?h=staging-next#n260


... and why you send this patch without modification...

https://lists.ozlabs.org/pipermail/linux-erofs/2018-December/001099.html

https://lists.ozlabs.org/pipermail/linux-erofs/2018-December/001100.html


Thanks,

Gao Xiang
