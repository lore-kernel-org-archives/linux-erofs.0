From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 24 Jul 2019 15:06:45 +0800
Subject: [PATCH v2] erofs-utils: Add missing error code handling.
In-Reply-To: <20190724045519.8498-1-pratikshinde320@gmail.com>
References: <20190724045519.8498-1-pratikshinde320@gmail.com>
Message-ID: <485b94a5-969b-a90c-ad87-e7e871196ee8@huawei.com>

Hi Pratik,

On 2019/7/24 12:55, Pratik Shinde wrote:
> Handling error conditions that are missed in few scenarios.
> also, mkfs command should return 1 on failure and 0 on success.
> 
> Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
> ---
>  lib/inode.c | 10 ++++++++--
>  mkfs/main.c |  8 +++++++-
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/inode.c b/lib/inode.c
> index 179aa26..08d38c0 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -752,8 +752,14 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
>  	}
>  	closedir(_dir);
>  
> -	erofs_prepare_dir_file(dir);
> -	erofs_prepare_inode_buffer(dir);
> +	ret = erofs_prepare_dir_file(dir);
> +	if(!ret)
> +		goto err_closedir;

Maybe it should be "if (ret)"? Have you use this patch to generate some images?

if(!ret)
  ^   --- no space here

> +
> +	ret = erofs_prepare_inode_buffer(dir);
> +	if(!ret)
> +		goto err_closedir;

ditto.

> +
>  	if (IS_ROOT(dir))
>  		erofs_fixup_meta_blkaddr(dir);
>  
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 1348587..f73eb10 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -212,6 +212,12 @@ int main(int argc, char **argv)
>  	erofs_show_config();
>  
>  	sb_bh = erofs_buffer_init();
> +	if(IS_ERR(sb_bh)) {
> +		err = PTR_ERR(sb_bh);
> +		erofs_err("Failed to initialize super block buffer head : %s",

erofs_err("Failed to initialize buffers: %s",

Thanks,
Gao Xiang

> +			  erofs_strerror(err));
> +		goto exit;
> +	}
>  	err = erofs_bh_balloon(sb_bh, EROFS_SUPER_END);
>  	if (err < 0) {
>  		erofs_err("Failed to balloon erofs_super_block: %s",
> @@ -254,5 +260,5 @@ exit:
>  			  erofs_strerror(err));
>  		return 1;
>  	}
> -	return err;
> +	return 0;
>  }
> 
