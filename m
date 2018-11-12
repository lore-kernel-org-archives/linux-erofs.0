From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Mon, 12 Nov 2018 14:46:36 -0800
Subject: [PATCH 1/3] staging: erofs: unzip_vle.c: Replace comparison to
 NULL.
In-Reply-To: <1542055439-24444-2-git-send-email-sicilia.cristian@gmail.com>
References: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>
 <1542055439-24444-2-git-send-email-sicilia.cristian@gmail.com>
Message-ID: <20181112224636.GA12671@kroah.com>

On Mon, Nov 12, 2018@09:43:57PM +0100, Cristian Sicilia wrote:
> Replace equal to NULL with logic unary operator,
> and removing not equal to NULL comparison.
> 
> Signed-off-by: Cristian Sicilia <sicilia.cristian at gmail.com>
> ---
>  drivers/staging/erofs/unzip_vle.c | 86 +++++++++++++++++++--------------------
>  1 file changed, 43 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 79d3ba6..1ffeeaa 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -20,8 +20,8 @@ static struct kmem_cache *z_erofs_workgroup_cachep __read_mostly;
>  
>  void z_erofs_exit_zip_subsystem(void)
>  {
> -	BUG_ON(z_erofs_workqueue == NULL);
> -	BUG_ON(z_erofs_workgroup_cachep == NULL);
> +	BUG_ON(!z_erofs_workqueue);
> +	BUG_ON(!z_erofs_workgroup_cachep);

Long-term, all of these BUG_ON need to be removed as they imply that the
developer has no idea what went wrong and can not recover.  For
something like this, we "know" these will be fine and odds are they can
just be removed entirely.

>  
>  	destroy_workqueue(z_erofs_workqueue);
>  	kmem_cache_destroy(z_erofs_workgroup_cachep);
> @@ -39,7 +39,7 @@ static inline int init_unzip_workqueue(void)
>  		WQ_UNBOUND | WQ_HIGHPRI | WQ_CPU_INTENSIVE,
>  		onlinecpus + onlinecpus / 4);
>  
> -	return z_erofs_workqueue != NULL ? 0 : -ENOMEM;
> +	return z_erofs_workqueue ? 0 : -ENOMEM;

I hate ?: notation that is not in a function parameter, any way you can
just change this to:
	if (z_erofs_workqueue)
		return 0;
	return -ENOMEM;

Christian, this isn't your fault at all, I'm not rejecting this patch,
just providing hints on what else you can do here :)

thanks,

greg k-h
