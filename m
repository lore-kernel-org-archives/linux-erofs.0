From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 22 Nov 2018 11:24:31 +0100
Subject: [PATCH 08/10] staging: erofs: locked before registering for all
 new workgroups
In-Reply-To: <20181120143425.43637-9-gaoxiang25@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-9-gaoxiang25@huawei.com>
Message-ID: <20181122102431.GH3189@kroah.com>

On Tue, Nov 20, 2018@10:34:23PM +0800, Gao Xiang wrote:
> Let's make sure that the one registering a workgroup will also
> take the primary work lock at first for two reasons:
>   1) There's no need to introduce such a race window (and consequently
>      overhead) between registering and locking, other tasks could break
>      in by chance, and the race seems unnecessary (no benefit at all);
> 
>   2) It's better to take the primary work when a workgroup
>      is registered to apply the cache managed policy, for example,
>      if some other tasks break in, it could turn into the in-place
>      decompression rather than use as the cached decompression.
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/unzip_vle.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 4e5843e8ee35..a1376f3c6065 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -420,18 +420,22 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
>  	work = z_erofs_vle_grab_primary_work(grp);
>  	work->pageofs = f->pageofs;
>  
> +	/* lock all primary followed works before visible to others */
> +	if (unlikely(!mutex_trylock(&work->lock)))
> +		/* for a new workgroup, try_lock *never* fails */
> +		DBG_BUGON(1);

Again, drop this, if it never fails, then there's no need for this.  If
it can fail, then properly handle it.

And trylock can fail, so this needs to be fixed.

thanks,

greg k-h
