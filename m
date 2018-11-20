From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 20 Nov 2018 11:24:40 +0800
Subject: [PATCH chao/erofs-dev rebased v2 05/12] staging: erofs: fix race
 when the managed cache is enabled
In-Reply-To: <20181114152548.37921-5-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152548.37921-5-gaoxiang25@huawei.com>
Message-ID: <278d9ed6-ad51-b50e-3135-6c1049eae44f@huawei.com>

On 2018/11/14 23:25, Gao Xiang wrote:
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
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/utils.c | 131 +++++++++++++++++++++++++++++-------------
>  1 file changed, 92 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
> index ea8a962e5c95..d9b437dd6818 100644
> --- a/drivers/staging/erofs/utils.c
> +++ b/drivers/staging/erofs/utils.c
> @@ -83,12 +83,21 @@ int erofs_register_workgroup(struct super_block *sb,
>  
>  	grp = xa_tag_pointer(grp, tag);
>  
> -	err = radix_tree_insert(&sbi->workstn_tree,
> -		grp->index, grp);
> +	/*
> +	 * Bump up reference count before making this workgroup
> +	 * visible to other users in order to avoid potential UAF
> +	 * without serialized by erofs_workstn_lock.
> +	 */
> +	__erofs_workgroup_get(grp);
>  
> -	if (!err) {
> -		__erofs_workgroup_get(grp);
> -	}
> +	err = radix_tree_insert(&sbi->workstn_tree,
> +				grp->index, grp);
> +	if (unlikely(err))
> +		/*
> +		 * it's safe to decrease since the workgroup isn't visible
> +		 * and refcount >= 2 (cannot be freezed).
> +		 */
> +		atomic_dec(&grp->refcount);

How about:

#define __erofs_workgroup_put(grp)	atomic_dec(&grp->refcount);

Otherwise, it looks good to me.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,

>  
>  	erofs_workstn_unlock(sbi);
>  	radix_tree_preload_end();
> @@ -97,19 +106,91 @@ int erofs_register_workgroup(struct super_block *sb,
>  
>  extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
>  
> +static void  __erofs_workgroup_free(struct erofs_workgroup *grp)
> +{
> +	atomic_long_dec(&erofs_global_shrink_cnt);
> +	erofs_workgroup_free_rcu(grp);
> +}
> +
>  int erofs_workgroup_put(struct erofs_workgroup *grp)
>  {
>  	int count = atomic_dec_return(&grp->refcount);
>  
>  	if (count == 1)
>  		atomic_long_inc(&erofs_global_shrink_cnt);
> -	else if (!count) {
> -		atomic_long_dec(&erofs_global_shrink_cnt);
> -		erofs_workgroup_free_rcu(grp);
> -	}
> +	else if (!count)
> +		__erofs_workgroup_free(grp);
>  	return count;
>  }
>  
> +#ifdef EROFS_FS_HAS_MANAGED_CACHE
> +/* for cache-managed case, customized reclaim paths exist */
> +static void erofs_workgroup_unfreeze_final(struct erofs_workgroup *grp)
> +{
> +	erofs_workgroup_unfreeze(grp, 0);
> +	__erofs_workgroup_free(grp);
> +}
> +
> +bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
> +				    struct erofs_workgroup *grp,
> +				    bool cleanup)
> +{
> +	/*
> +	 * for managed cache enabled, the refcount of workgroups
> +	 * themselves could be < 0 (freezed). So there is no guarantee
> +	 * that all refcount > 0 if managed cache is enabled.
> +	 */
> +	if (!erofs_workgroup_try_to_freeze(grp, 1))
> +		return false;
> +
> +	/*
> +	 * note that all cached pages should be unlinked
> +	 * before delete it from the radix tree.
> +	 * Otherwise some cached pages of an orphan old workgroup
> +	 * could be still linked after the new one is available.
> +	 */
> +	if (erofs_try_to_free_all_cached_pages(sbi, grp)) {
> +		erofs_workgroup_unfreeze(grp, 1);
> +		return false;
> +	}
> +
> +	/* it is impossible to fail after we freeze the workgroup */
> +	BUG_ON(xa_untag_pointer(radix_tree_delete(&sbi->workstn_tree,
> +						  grp->index)) != grp);
> +
> +	/*
> +	 * if managed cache is enable, the last refcount
> +	 * should indicate the related workstation.
> +	 */
> +	erofs_workgroup_unfreeze_final(grp);
> +	return true;
> +}
> +
> +#else
> +/* for nocache case, no customized reclaim path at all */
> +bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
> +				    struct erofs_workgroup *grp,
> +				    bool cleanup)
> +{
> +	int cnt = atomic_read(&grp->refcount);
> +
> +	DBG_BUGON(cnt <= 0);
> +	DBG_BUGON(cleanup && cnt != 1);
> +
> +	if (cnt > 1)
> +		return false;
> +
> +	if (xa_untag_pointer(radix_tree_delete(&sbi->workstn_tree,
> +					       grp->index)) != grp)
> +		return false;
> +
> +	/* (rarely) could be grabbed again when freeing */
> +	erofs_workgroup_put(grp);
> +	return true;
> +}
> +
> +#endif
> +
>  unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
>  				       unsigned long nr_shrink,
>  				       bool cleanup)
> @@ -126,41 +207,13 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
>  		batch, first_index, PAGEVEC_SIZE);
>  
>  	for (i = 0; i < found; ++i) {
> -		int cnt;
>  		struct erofs_workgroup *grp = xa_untag_pointer(batch[i]);
>  
>  		first_index = grp->index + 1;
>  
> -		cnt = atomic_read(&grp->refcount);
> -		BUG_ON(cnt <= 0);
> -
> -		if (cleanup)
> -			BUG_ON(cnt != 1);
> -
> -#ifndef EROFS_FS_HAS_MANAGED_CACHE
> -		else if (cnt > 1)
> -#else
> -		if (!erofs_workgroup_try_to_freeze(grp, 1))
> -#endif
> -			continue;
> -
> -		if (xa_untag_pointer(radix_tree_delete(&sbi->workstn_tree,
> -			grp->index)) != grp) {
> -#ifdef EROFS_FS_HAS_MANAGED_CACHE
> -skip:
> -			erofs_workgroup_unfreeze(grp, 1);
> -#endif
> +		/* try to shrink each valid workgroup */
> +		if (!erofs_try_to_release_workgroup(sbi, grp, cleanup))
>  			continue;
> -		}
> -
> -#ifdef EROFS_FS_HAS_MANAGED_CACHE
> -		if (erofs_try_to_free_all_cached_pages(sbi, grp))
> -			goto skip;
> -
> -		erofs_workgroup_unfreeze(grp, 1);
> -#endif
> -		/* (rarely) grabbed again when freeing */
> -		erofs_workgroup_put(grp);
>  
>  		++freed;
>  		if (unlikely(!--nr_shrink))
> 
