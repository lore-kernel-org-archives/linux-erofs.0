From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 23:37:39 +0800
Subject: [PATCH v3 1/2] staging: erofs: Modify coding style alignments
In-Reply-To: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
References: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
Message-ID: <289933f0-ff7b-674c-eed3-25f3aa8d64cb@huawei.com>

Hi Bhagyashri,

On 2018/11/5 22:49, Bhagyashri P. Dighole wrote:
> Fix coding style alignment issues detected by checkpatch.pl
> Matched alignments with parenthesis.
> 
> Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>

This patch looks good to me. I think you could add, could be better to hear others idea...
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> ---
> Changes in v3:
> - Split patch in two patches. Each patch have similar 
>   kind of changes. One patch for all alignment fixes and 
>   second patch for all conditional check fixes.
> 
> Changes in v2:
> - Fix for one alignment issue and one conditional check issue.
> 
> Changes in v1:
> - Fix for all issues in data.c
> 
>  drivers/staging/erofs/data.c | 51 ++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 6384f73e5418..b66191ad44aa 100644
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
> @@ -76,7 +76,7 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
>  		}
>  
>  		__submit_bio(bio, REQ_OP_READ,
> -			REQ_META | (prio ? REQ_PRIO : 0));
> +			     REQ_META | (prio ? REQ_PRIO : 0));
>  
>  		lock_page(page);
>  
> @@ -107,8 +107,8 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
>  }
>  
>  static int erofs_map_blocks_flatmode(struct inode *inode,
> -	struct erofs_map_blocks *map,
> -	int flags)
> +				     struct erofs_map_blocks *map,
> +				     int flags)
>  {
>  	int err = 0;
>  	erofs_blk_t nblocks, lastblk;
> @@ -151,7 +151,7 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
>  		map->m_flags |= EROFS_MAP_META;
>  	} else {
>  		errln("internal error @ nid: %llu (size %llu), m_la 0x%llx",
> -			vi->nid, inode->i_size, map->m_la);
> +		      vi->nid, inode->i_size, map->m_la);
>  		DBG_BUGON(1);
>  		err = -EIO;
>  		goto err_out;
> @@ -167,12 +167,13 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
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
> -	struct page **mpage_ret, int flags)
> +			  struct erofs_map_blocks *map,
> +			  struct page **mpage_ret, int flags)
>  {
>  	/* by default, reading raw data never use erofs_map_blocks_iter */
>  	if (unlikely(!is_inode_layout_compression(inode))) {
> @@ -192,7 +193,7 @@ int erofs_map_blocks_iter(struct inode *inode,
>  }
>  
>  int erofs_map_blocks(struct inode *inode,
> -	struct erofs_map_blocks *map, int flags)
> +		     struct erofs_map_blocks *map, int flags)
>  {
>  	if (unlikely(is_inode_layout_compression(inode))) {
>  		struct page *mpage = NULL;
> @@ -206,13 +207,12 @@ int erofs_map_blocks(struct inode *inode,
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
> +static inline struct bio *erofs_read_raw_page(struct bio *bio,
> +					      struct address_space *mapping,
> +					      struct page *page,
> +					      erofs_off_t *last_block,
> +					      unsigned int nblocks,
> +					      bool ra)
>  {
>  	struct inode *inode = mapping->host;
>  	erofs_off_t current_block = (erofs_off_t)page->index;
> @@ -233,8 +233,8 @@ static inline struct bio *erofs_read_raw_page(
>  
>  	/* note that for readpage case, bio also equals to NULL */
>  	if (bio != NULL &&
> -		/* not continuous */
> -		*last_block + 1 != current_block) {
> +	    /* not continuous */
> +	    *last_block + 1 != current_block) {
>  submit_bio_retry:
>  		__submit_bio(bio, REQ_OP_READ, 0);
>  		bio = NULL;
> @@ -307,7 +307,7 @@ static inline struct bio *erofs_read_raw_page(
>  			nblocks = BIO_MAX_PAGES;
>  
>  		bio = erofs_grab_bio(inode->i_sb,
> -			blknr, nblocks, read_endio, false);
> +				     blknr, nblocks, read_endio, false);
>  
>  		if (IS_ERR(bio)) {
>  			err = PTR_ERR(bio);
> @@ -361,7 +361,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
>  	trace_erofs_readpage(page, true);
>  
>  	bio = erofs_read_raw_page(NULL, page->mapping,
> -		page, &last_block, 1, false);
> +				  page, &last_block, 1, false);
>  
>  	if (IS_ERR(bio))
>  		return PTR_ERR(bio);
> @@ -371,8 +371,9 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
>  }
>  
>  static int erofs_raw_access_readpages(struct file *filp,
> -	struct address_space *mapping,
> -	struct list_head *pages, unsigned int nr_pages)
> +				      struct address_space *mapping,
> +				      struct list_head *pages,
> +				      unsigned int nr_pages)
>  {
>  	erofs_off_t last_block;
>  	struct bio *bio = NULL;
> @@ -389,13 +390,13 @@ static int erofs_raw_access_readpages(struct file *filp,
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
> -					EROFS_V(mapping->host)->nid);
> +				       __func__, page->index,
> +				       EROFS_V(mapping->host)->nid);
>  
>  				bio = NULL;
>  			}
> 
