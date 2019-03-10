From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 10 Mar 2019 15:52:49 +0800
Subject: [PATCH] staging: erofs: inode.c fix checkpatch issues
In-Reply-To: <20190310024644.8568-1-julianmr97@gmail.com>
References: <20190310024644.8568-1-julianmr97@gmail.com>
Message-ID: <89598251-e017-2ff7-1032-c04b067bf641@aol.com>

Hi Julian,

On 2019/3/10 10:46, Julian Merida wrote:
> This patch solves various checkpatch check issues
>
> Correct indentation on some functions, fix multiple assignments
> on a single line and brace-placement on a non-single condition statement.
>
> Signed-off-by: Julian Merida <julianmr97 at gmail.com>

One patch for one type of checkpatch issues? and could you please
check the other erofs source files as well?

Thanks,
Gao Xiang

> ---
>  drivers/staging/erofs/inode.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> index 924b8dfc7a8f..be9bfd04df41 100644
> --- a/drivers/staging/erofs/inode.c
> +++ b/drivers/staging/erofs/inode.c
> @@ -25,7 +25,7 @@ static int read_inode(struct inode *inode, void *data)
>  
>  	if (unlikely(vi->data_mapping_mode >= EROFS_INODE_LAYOUT_MAX)) {
>  		errln("unknown data mapping mode %u of nid %llu",
> -			vi->data_mapping_mode, vi->nid);
> +		      vi->data_mapping_mode, vi->nid);
>  		DBG_BUGON(1);
>  		return -EIO;
>  	}
> @@ -38,7 +38,7 @@ static int read_inode(struct inode *inode, void *data)
>  
>  		inode->i_mode = le16_to_cpu(v2->i_mode);
>  		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> -						S_ISLNK(inode->i_mode)) {
> +		    S_ISLNK(inode->i_mode)) {
>  			vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
>  		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
>  			inode->i_rdev =
> @@ -54,10 +54,10 @@ static int read_inode(struct inode *inode, void *data)
>  		set_nlink(inode, le32_to_cpu(v2->i_nlink));
>  
>  		/* ns timestamp */
> -		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
> -			le64_to_cpu(v2->i_ctime);
> -		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
> -			le32_to_cpu(v2->i_ctime_nsec);
> +		inode->i_mtime.tv_sec = le64_to_cpu(v2->i_ctime);
> +		inode->i_ctime.tv_sec = inode->i_mtime.tv_sec;
> +		inode->i_mtime.tv_nsec = le32_to_cpu(v2->i_ctime_nsec);
> +		inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec;
>  
>  		inode->i_size = le64_to_cpu(v2->i_size);
>  	} else if (__inode_version(advise) == EROFS_INODE_LAYOUT_V1) {
> @@ -68,7 +68,7 @@ static int read_inode(struct inode *inode, void *data)
>  
>  		inode->i_mode = le16_to_cpu(v1->i_mode);
>  		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> -						S_ISLNK(inode->i_mode)) {
> +		    S_ISLNK(inode->i_mode)) {
>  			vi->raw_blkaddr = le32_to_cpu(v1->i_u.raw_blkaddr);
>  		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
>  			inode->i_rdev =
> @@ -84,15 +84,15 @@ static int read_inode(struct inode *inode, void *data)
>  		set_nlink(inode, le16_to_cpu(v1->i_nlink));
>  
>  		/* use build time to derive all file time */
> -		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
> -			sbi->build_time;
> -		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
> -			sbi->build_time_nsec;
> +		inode->i_mtime.tv_sec = sbi->build_time;
> +		inode->i_ctime.tv_sec =	inode->i_mtime.tv_sec;
> +		inode->i_mtime.tv_nsec = sbi->build_time_nsec;
> +		inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec;
>  
>  		inode->i_size = le32_to_cpu(v1->i_size);
>  	} else {
>  		errln("unsupported on-disk inode version %u of nid %llu",
> -			__inode_version(advise), vi->nid);
> +		      __inode_version(advise), vi->nid);
>  		DBG_BUGON(1);
>  		return -EIO;
>  	}
> @@ -173,7 +173,7 @@ static int fill_inode(struct inode *inode, int isdir)
>  
>  	if (IS_ERR(page)) {
>  		errln("failed to get inode (nid: %llu) page, err %ld",
> -			vi->nid, PTR_ERR(page));
> +		      vi->nid, PTR_ERR(page));
>  		return PTR_ERR(page);
>  	}
>  
> @@ -260,7 +260,7 @@ static inline struct inode *erofs_iget_locked(struct super_block *sb,
>  }
>  
>  struct inode *erofs_iget(struct super_block *sb,
> -	erofs_nid_t nid, bool isdir)
> +			 erofs_nid_t nid, bool isdir)
>  {
>  	struct inode *inode = erofs_iget_locked(sb, nid);
>  
> @@ -270,12 +270,13 @@ struct inode *erofs_iget(struct super_block *sb,
>  	if (inode->i_state & I_NEW) {
>  		int err;
>  		struct erofs_vnode *vi = EROFS_V(inode);
> +
>  		vi->nid = nid;
>  
>  		err = fill_inode(inode, isdir);
> -		if (likely(!err))
> +		if (likely(!err)) {
>  			unlock_new_inode(inode);
> -		else {
> +		} else {
>  			iget_failed(inode);
>  			inode = ERR_PTR(err);
>  		}
