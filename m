From: gregkh@linuxfoundation.org (Greg KH)
Date: Sun, 9 Dec 2018 17:20:07 +0100
Subject: [PATCH] staging: erofs: Add braces to do-while statements
In-Reply-To: <20181209155900.10164-1-laumann.thomas@gmail.com>
References: <20181209155900.10164-1-laumann.thomas@gmail.com>
Message-ID: <20181209162007.GA22432@kroah.com>

On Sun, Dec 09, 2018@04:59:00PM +0100, Thomas Jespersen wrote:
> This fixes warning reported by sparse (with -Wsparse-all).

Why is sparse warning about this?

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

That looks like valid code to me, why change this?

greg k-h
