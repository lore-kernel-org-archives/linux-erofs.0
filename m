From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Mon, 13 Aug 2018 14:04:06 +0300
Subject: [PATCH 2/8] staging: erofs: separate erofs_get_meta_page
In-Reply-To: <20180812140150.13397-3-chao@kernel.org>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-3-chao@kernel.org>
Message-ID: <20180813110405.3qoburir3ds5ux33@mwanda>

On Sun, Aug 12, 2018@10:01:44PM +0800, Chao Yu wrote:
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -39,31 +39,44 @@ static inline void read_endio(struct bio *bio)
>  }
>  
>  /* prio -- true is used for dir */
> -struct page *erofs_get_meta_page(struct super_block *sb,
> -	erofs_blk_t blkaddr, bool prio)
> +struct page *__erofs_get_meta_page(struct super_block *sb,
> +	erofs_blk_t blkaddr, bool prio, bool nofail)
>  {
> -	struct inode *bd_inode = sb->s_bdev->bd_inode;
> -	struct address_space *mapping = bd_inode->i_mapping;
> +	struct inode *const bd_inode = sb->s_bdev->bd_inode;
> +	struct address_space *const mapping = bd_inode->i_mapping;
> +	/* prefer retrying in the allocator to blindly looping below */
> +	const gfp_t gfp = mapping_gfp_constraint(mapping, ~__GFP_FS) |
> +		(nofail ? __GFP_NOFAIL : 0);
> +	unsigned int io_retries = nofail ? EROFS_IO_MAX_RETRIES_NOFAIL : 0;
>  	struct page *page;
>  
>  repeat:
> -	page = find_or_create_page(mapping, blkaddr,
> -	/*
> -	 * Prefer looping in the allocator rather than here,
> -	 * at least that code knows what it's doing.
> -	 */
> -		mapping_gfp_constraint(mapping, ~__GFP_FS) | __GFP_NOFAIL);
> -
> -	BUG_ON(!page || !PageLocked(page));
> +	page = find_or_create_page(mapping, blkaddr, gfp);
> +	if (unlikely(page == NULL)) {
> +		DBG_BUGON(nofail);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	DBG_BUGON(!PageLocked(page));
>  
>  	if (!PageUptodate(page)) {
>  		struct bio *bio;
>  		int err;
>  
> -		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, true);
> +		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, nofail);
> +		if (unlikely(bio == NULL)) {
> +			DBG_BUGON(nofail);
> +			err = -ENOMEM;
> +err_out:
> +			unlock_page(page);
> +			put_page(page);
> +			return ERR_PTR(err);


Put this err_out stuff at the bottom of the function so that we don't
have to do backward hops to get to it.

> +		}
>  
>  		err = bio_add_page(bio, page, PAGE_SIZE, 0);
> -		BUG_ON(err != PAGE_SIZE);
> +		if (unlikely(err != PAGE_SIZE)) {
> +			err = -EFAULT;
> +			goto err_out;
                        ^^^^^^^^^^^^
Like this.  Generally avoid backwards hops if you can.

> +		}
>  
>  		__submit_bio(bio, REQ_OP_READ,
>  			REQ_META | (prio ? REQ_PRIO : 0));
> @@ -72,6 +85,7 @@ struct page *erofs_get_meta_page(struct super_block *sb,
>  
>  		/* the page has been truncated by others? */
>  		if (unlikely(page->mapping != mapping)) {
> +unlock_repeat:

The question mark in the "truncated by others?" is a little concerning.
It's slightly weird that we don't check "io_retries" on this path.

>  			unlock_page(page);
>  			put_page(page);
>  			goto repeat;
> @@ -79,10 +93,12 @@ struct page *erofs_get_meta_page(struct super_block *sb,
>  
>  		/* more likely a read error */
>  		if (unlikely(!PageUptodate(page))) {
> -			unlock_page(page);
> -			put_page(page);
> -
> -			page = ERR_PTR(-EIO);
> +			if (io_retries) {
> +				--io_retries;
> +				goto unlock_repeat;
> +			}
> +			err = -EIO;
> +			goto err_out;

regards,
dan carpenter
