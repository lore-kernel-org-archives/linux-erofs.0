From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 6 Oct 2018 09:00:34 +0800
Subject: [PATCH] staging: erofs: fix indenting to conform to kernel coding
 style
In-Reply-To: <20181005172359.GA9326@kvasir.local>
References: <20181005172359.GA9326@kvasir.local>
Message-ID: <40af8139-343f-848b-8b74-435270a033c3@huawei.com>

Hi Ioannis,

Thanks for your patch.

Could you please resend this patch to the staging-devel/erofs-devel mailing list?

Since we are in the China National Day holiday and I can only send email in
the corporation by the HUAWEI mailbox, I cannot reply emails in time...

It could be better to Cc patches to the proper mailing lists...

On 2018/10/6 1:23, Ioannis Valasakis wrote:
> Cleanup all inconsistent indenting to conform to kernel coding style.
> Reported by checkpatch.

It should be fixed, but out of curiousity, could you fix all
the indentings of erofs in this patch?

> 
> Signed-off-by: Ioannis Valasakis <code at wizofe.uk>
> ---
>  drivers/staging/erofs/data.c | 56 ++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 6384f73e5418..ffd392e74803 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -40,7 +40,7 @@ static inline void read_endio(struct bio *bio)
>  
>  /* prio -- true is used for dir */
>  struct page *__erofs_get_meta_page(struct super_block *sb,
> -	erofs_blk_t blkaddr, bool prio, bool nofail)
> +				   erofs_blk_t blkaddr, bool prio, bool nofail)
>  {
>  	struct inode *const bd_inode = sb->s_bdev->bd_inode;
>  	struct address_space *const mapping = bd_inode->i_mapping;
> @@ -53,7 +53,7 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
>  
>  repeat:
>  	page = find_or_create_page(mapping, blkaddr, gfp);
> -	if (unlikely(page == NULL)) {
> +	if (unlikely(!page)) {

Here should be fixed too, but it is another case.
Could you make another patch to fix the NULL pointer checks?

Thanks,
Gao Xiang

>  		DBG_BUGON(nofail);
>  		return ERR_PTR(-ENOMEM);
>  	}
> @@ -76,7 +76,7 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
>  		}
>  
>  		__submit_bio(bio, REQ_OP_READ,
> -			REQ_META | (prio ? REQ_PRIO : 0));
> +			     REQ_META | (prio ? REQ_PRIO : 0));
>  
>  		lock_page(page);
>  
> @@ -107,7 +107,7 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
>  }
>  
>  static int erofs_map_blocks_flatmode(struct inode *inode,
> -	struct erofs_map_blocks *map,
> +				     struct erofs_map_blocks *map,
>  	int flags)
>  {
>  	int err = 0;
> @@ -151,7 +151,7 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
>  		map->m_flags |= EROFS_MAP_META;
>  	} else {
>  		errln("internal error @ nid: %llu (size %llu), m_la 0x%llx",
> -			vi->nid, inode->i_size, map->m_la);
> +		      vi->nid, inode->i_size, map->m_la);
>  		DBG_BUGON(1);
>  		err = -EIO;
>  		goto err_out;
> @@ -167,16 +167,17 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
>  
>  #ifdef CONFIG_EROFS_FS_ZIP
>  extern int z_erofs_map_blocks_iter(struct inode *,
> -	struct erofs_map_blocks *, struct page **, int);
> +				   struct erofs_map_blocks *,
> +				   struct page **, int);
>  #endif
>  
>  int erofs_map_blocks_iter(struct inode *inode,
> -	struct erofs_map_blocks *map,
> +			  struct erofs_map_blocks *map,
>  	struct page **mpage_ret, int flags)
>  {
>  	/* by default, reading raw data never use erofs_map_blocks_iter */
>  	if (unlikely(!is_inode_layout_compression(inode))) {
> -		if (*mpage_ret != NULL)
> +		if (*mpage_ret)
>  			put_page(*mpage_ret);
>  		*mpage_ret = NULL;
>  
> @@ -192,27 +193,27 @@ int erofs_map_blocks_iter(struct inode *inode,
>  }
>  
>  int erofs_map_blocks(struct inode *inode,
> -	struct erofs_map_blocks *map, int flags)
> +		     struct erofs_map_blocks *map, int flags)
>  {
>  	if (unlikely(is_inode_layout_compression(inode))) {
>  		struct page *mpage = NULL;
>  		int err;
>  
>  		err = erofs_map_blocks_iter(inode, map, &mpage, flags);
> -		if (mpage != NULL)
> +		if (mpage)
>  			put_page(mpage);
>  		return err;
>  	}
>  	return erofs_map_blocks_flatmode(inode, map, flags);
>  }
>  
> -static inline struct bio *erofs_read_raw_page(
> -	struct bio *bio,
> -	struct address_space *mapping,
> -	struct page *page,
> -	erofs_off_t *last_block,
> -	unsigned int nblocks,
> -	bool ra)
> +static inline struct bio *erofs_read_raw_page
> +	(struct bio *bio,
> +	 struct address_space *mapping,
> +	 struct page *page,
> +	 erofs_off_t *last_block,
> +	 unsigned int nblocks,
> +	 bool ra)
>  {
>  	struct inode *inode = mapping->host;
>  	erofs_off_t current_block = (erofs_off_t)page->index;
> @@ -232,15 +233,15 @@ static inline struct bio *erofs_read_raw_page(
>  	}
>  
>  	/* note that for readpage case, bio also equals to NULL */
> -	if (bio != NULL &&
> -		/* not continuous */
> +	if (bio &&
> +	    /* not continuous */
>  		*last_block + 1 != current_block) {
>  submit_bio_retry:
>  		__submit_bio(bio, REQ_OP_READ, 0);
>  		bio = NULL;
>  	}
>  
> -	if (bio == NULL) {
> +	if (!bio) {
>  		struct erofs_map_blocks map = {
>  			.m_la = blknr_to_addr(current_block),
>  		};
> @@ -307,7 +308,7 @@ static inline struct bio *erofs_read_raw_page(
>  			nblocks = BIO_MAX_PAGES;
>  
>  		bio = erofs_grab_bio(inode->i_sb,
> -			blknr, nblocks, read_endio, false);
> +				     blknr, nblocks, read_endio, false);
>  
>  		if (IS_ERR(bio)) {
>  			err = PTR_ERR(bio);
> @@ -342,7 +343,7 @@ static inline struct bio *erofs_read_raw_page(
>  	unlock_page(page);
>  
>  	/* if updated manually, continuous pages has a gap */
> -	if (bio != NULL)
> +	if (bio)
>  submit_bio_out:
>  		__submit_bio(bio, REQ_OP_READ, 0);
>  
> @@ -361,7 +362,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
>  	trace_erofs_readpage(page, true);
>  
>  	bio = erofs_read_raw_page(NULL, page->mapping,
> -		page, &last_block, 1, false);
> +				  page, &last_block, 1, false);
>  
>  	if (IS_ERR(bio))
>  		return PTR_ERR(bio);
> @@ -371,7 +372,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
>  }
>  
>  static int erofs_raw_access_readpages(struct file *filp,
> -	struct address_space *mapping,
> +				      struct address_space *mapping,
>  	struct list_head *pages, unsigned int nr_pages)
>  {
>  	erofs_off_t last_block;
> @@ -389,12 +390,12 @@ static int erofs_raw_access_readpages(struct file *filp,
>  
>  		if (!add_to_page_cache_lru(page, mapping, page->index, gfp)) {
>  			bio = erofs_read_raw_page(bio, mapping, page,
> -				&last_block, nr_pages, true);
> +						  &last_block, nr_pages, true);
>  
>  			/* all the page errors are ignored when readahead */
>  			if (IS_ERR(bio)) {
>  				pr_err("%s, readahead error at page %lu of nid %llu\n",
> -					__func__, page->index,
> +				       __func__, page->index,
>  					EROFS_V(mapping->host)->nid);
>  
>  				bio = NULL;
> @@ -407,7 +408,7 @@ static int erofs_raw_access_readpages(struct file *filp,
>  	DBG_BUGON(!list_empty(pages));
>  
>  	/* the rare case (end in gaps) */
> -	if (unlikely(bio != NULL))
> +	if (unlikely(bio))
>  		__submit_bio(bio, REQ_OP_READ, 0);
>  	return 0;
>  }
> @@ -417,4 +418,3 @@ const struct address_space_operations erofs_raw_access_aops = {
>  	.readpage = erofs_raw_access_readpage,
>  	.readpages = erofs_raw_access_readpages,
>  };
> -
> 
