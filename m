From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 20 Feb 2019 10:38:53 +0800
Subject: [PATCH] staging: erofs: remove rcu_read_lock() in
 erofs_try_to_free_cached_page
In-Reply-To: <20190216084650.33841-1-gaoxiang25@huawei.com>
References: <20190216084650.33841-1-gaoxiang25@huawei.com>
Message-ID: <fc058e45-a645-c680-2ce0-19de83fffc2e@huawei.com>

Hi Greg,

Could you consider take some time on these two patches for linux-5.1-rc1?
 1) staging: erofs: fix race of initializing xattrs of a inode at the same time
 2) staging: erofs: remove rcu_read_lock() in erofs_try_to_free_cached_page

It will be of great help, especially patch 1 (it could cause potential memleak
in the race condition without it).

If something (eg, resend these patches in a new patchset) is needed, I'm happy
to do that. :)

Thanks,
Gao Xiang

On 2019/2/16 16:46, Gao Xiang wrote:
> page_private(page) cannot be changed if page lock is taken.
> 
> Besides, the corresponding workgroup won't be freed
> if the page is already protected by page lock, therefore
> no need to take rcu read lock.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/unzip_vle.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 2b5951f233db..a127d8db76d8 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -238,14 +238,9 @@ int erofs_try_to_free_cached_page(struct address_space *mapping,
>  {
>  	struct erofs_sb_info *const sbi = EROFS_SB(mapping->host->i_sb);
>  	const unsigned int clusterpages = erofs_clusterpages(sbi);
> -
> -	struct z_erofs_vle_workgroup *grp;
> +	struct z_erofs_vle_workgroup *const grp = (void *)page_private(page);
>  	int ret = 0;	/* 0 - busy */
>  
> -	/* prevent the workgroup from being freed */
> -	rcu_read_lock();
> -	grp = (void *)page_private(page);
> -
>  	if (erofs_workgroup_try_to_freeze(&grp->obj, 1)) {
>  		unsigned int i;
>  
> @@ -257,12 +252,11 @@ int erofs_try_to_free_cached_page(struct address_space *mapping,
>  			}
>  		}
>  		erofs_workgroup_unfreeze(&grp->obj, 1);
> -	}
> -	rcu_read_unlock();
>  
> -	if (ret) {
> -		ClearPagePrivate(page);
> -		put_page(page);
> +		if (ret) {
> +			ClearPagePrivate(page);
> +			put_page(page);
> +		}
>  	}
>  	return ret;
>  }
> 
