From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 30 Jul 2018 10:07:12 +0800
Subject: [PATCH 1/2] staging: erofs: fix compile error without built-in
 decompression support
In-Reply-To: <20180729053459.34140-1-hsiangkao@aol.com>
References: <1532761832-6964-1-git-send-email-gaoxiang25@huawei.com>
 <20180729053459.34140-1-hsiangkao@aol.com>
Message-ID: <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>

On 2018/7/29 13:34, Gao Xiang via Linux-erofs wrote:
> This patch fixes incorrect code snippets due to spilt code
> into small patches by mistake.
> 
> Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050747.html
> Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050750.html
> Reported-by: kbuild test robot <lkp at intel.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  I test several Kconfig option combinations and all these
> combinations are successfully compiled.
> 
> Hi Chao,
>  Could you please review this two patches first before merging
> into staging-next tree?

Hi Xiang,

For this compiler issue, I think we only need to cover erofs_shrink_workstation
with marco CONFIG_EROFS_FS_ZIP, other modification like symbol name change or
relocate erofs_shrink_workstation are with other reason, so how about separate
them into different patches?

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>  drivers/staging/erofs/internal.h  | 4 ++--
>  drivers/staging/erofs/super.c     | 2 +-
>  drivers/staging/erofs/unzip_vle.c | 7 ++++---
>  drivers/staging/erofs/utils.c     | 7 ++++---
>  4 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index 669f93ae6920..367b39fe46e5 100644
> --- a/drivers/staging/erofs/internal.h
> +++ b/drivers/staging/erofs/internal.h
> @@ -260,9 +260,9 @@ static inline void erofs_workstation_cleanup_all(struct super_block *sb)
>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
>  #define EROFS_UNALLOCATED_CACHED_PAGE	((void *)0x5F0EF00D)
>  
> -extern int try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
> +extern int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
>  	struct erofs_workgroup *egrp);
> -extern int try_to_free_cached_page(struct address_space *mapping,
> +extern int erofs_try_to_free_cached_page(struct address_space *mapping,
>  	struct page *page);
>  #endif
>  
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 97da5c8a8ef3..1aec509c805f 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -269,7 +269,7 @@ static int managed_cache_releasepage(struct page *page, gfp_t gfp_mask)
>  	BUG_ON(mapping->a_ops != &managed_cache_aops);
>  
>  	if (PagePrivate(page))
> -		ret = try_to_free_cached_page(mapping, page);
> +		ret = erofs_try_to_free_cached_page(mapping, page);
>  
>  	return ret;
>  }
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 7671fe8194ce..0e410a228cd4 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -131,8 +131,8 @@ static bool grab_managed_cache_pages(struct address_space *mapping,
>  }
>  
>  /* called by erofs_shrinker to get rid of all compressed_pages */
> -int try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
> -				 struct erofs_workgroup *egrp)
> +int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
> +				       struct erofs_workgroup *egrp)
>  {
>  	struct z_erofs_vle_workgroup *const grp =
>  		container_of(egrp, struct z_erofs_vle_workgroup, obj);
> @@ -166,7 +166,8 @@ int try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
>  	return 0;
>  }
>  
> -int try_to_free_cached_page(struct address_space *mapping, struct page *page)
> +int erofs_try_to_free_cached_page(struct address_space *mapping,
> +				  struct page *page)
>  {
>  	struct erofs_sb_info *const sbi = EROFS_SB(mapping->host->i_sb);
>  	const unsigned int clusterpages = erofs_clusterpages(sbi);
> diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
> index ee70bb9e1636..595cf90af9bb 100644
> --- a/drivers/staging/erofs/utils.c
> +++ b/drivers/staging/erofs/utils.c
> @@ -160,7 +160,7 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
>  		}
>  
>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
> -		if (try_to_free_all_cached_pages(sbi, grp))
> +		if (erofs_try_to_free_all_cached_pages(sbi, grp))
>  			goto skip;
>  
>  		erofs_workgroup_unfreeze(grp, 1);
> @@ -247,7 +247,9 @@ unsigned long erofs_shrink_scan(struct shrinker *shrink,
>  		spin_unlock(&erofs_sb_list_lock);
>  		sbi->shrinker_run_no = run_no;
>  
> -		/* add scan handlers here */
> +#ifdef CONFIG_EROFS_FS_ZIP
> +		freed += erofs_shrink_workstation(sbi, nr, false);
> +#endif
>  
>  		spin_lock(&erofs_sb_list_lock);
>  		/* Get the next list element before we move this one */
> @@ -260,7 +262,6 @@ unsigned long erofs_shrink_scan(struct shrinker *shrink,
>  		list_move_tail(&sbi->list, &erofs_sb_list);
>  		mutex_unlock(&sbi->umount_mutex);
>  
> -		freed += erofs_shrink_workstation(sbi, nr, false);
>  		if (freed >= nr)
>  			break;
>  	}
> 
