From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 22 Aug 2018 10:34:29 +0800
Subject: [PREVIEW] [PATCH] [V2] staging: erofs: replace BUG_ON with
 DBG_BUGON
In-Reply-To: <1534904226-116550-1-git-send-email-gongchen4@huawei.com>
References: <1534904226-116550-1-git-send-email-gongchen4@huawei.com>
Message-ID: <566e2f1c-7dc3-df61-a301-faba56befcd2@huawei.com>

Hi Chen,

On 2018/8/22 10:17, Chen Gong wrote:
> This patch replace BUG_ON with DBG_BUGON, and add necessary error
> handler.
> 
> Signed-off-by: Chen Gong <gongchen4 at huawei.com>
> ---
>  drivers/staging/erofs/data.c | 31 ++++++++++++++++++++-----------
>  drivers/staging/erofs/dir.c  |  2 +-

I think it is better to spilt into two patches, the one for raw data access (data.c)
the other for directory operations (dir.c) .

Just as your first version, and the commit message of your first version should also
highlight its scope `to fix data.c'

>  2 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 0570af5..174feac 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -25,7 +25,7 @@ static inline void read_endio(struct bio *bio)
>  		struct page *page = bvec->bv_page;
>  
>  		/* page is already locked */
> -		BUG_ON(PageUptodate(page));
> +		DBG_BUGON(PageUptodate(page));
>  
>  		if (unlikely(err))
>  			SetPageError(page);
> @@ -108,12 +108,12 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
>  	struct erofs_map_blocks *map,
>  	int flags)
>  {
> +	int err = 0;
>  	erofs_blk_t nblocks, lastblk;
>  	u64 offset = map->m_la;
>  	struct erofs_vnode *vi = EROFS_V(inode);
>  
>  	trace_erofs_map_blocks_flatmode_enter(inode, map, flags);
> -	BUG_ON(is_inode_layout_compression(inode));
>  
>  	nblocks = DIV_ROUND_UP(inode->i_size, PAGE_SIZE);
>  	lastblk = nblocks - is_inode_layout_inline(inode);
> @@ -140,18 +140,27 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
>  		map->m_plen = inode->i_size - offset;
>  
>  		/* inline data should locate in one meta block */
> -		BUG_ON(erofs_blkoff(map->m_pa) + map->m_plen > PAGE_SIZE);
> +		if(erofs_blkoff(map->m_pa) + map->m_plen > PAGE_SIZE){
> +			DBG_BUGON(1);
> +			err = -EIO;
> +			goto err_out;
> +		}
> +
>  		map->m_flags |= EROFS_MAP_META;
>  	} else {
>  		errln("internal error @ nid: %llu (size %llu), m_la 0x%llx",
>  			vi->nid, inode->i_size, map->m_la);
> -		BUG();
> +		DBG_BUGON(1);
> +		err = -EIO;
> +		goto err_out;
>  	}
>  
>  out:
>  	map->m_llen = map->m_plen;
> +
> +err_out:
>  	trace_erofs_map_blocks_flatmode_exit(inode, map, flags, 0);
> -	return 0;
> +	return err;
>  }
>  
>  #ifdef CONFIG_EROFS_FS_ZIP
> @@ -207,7 +216,7 @@ static inline struct bio *erofs_read_raw_page(
>  	erofs_off_t current_block = (erofs_off_t)page->index;
>  	int err;
>  
> -	BUG_ON(!nblocks);
> +	DBG_BUGON(!nblocks);
>  
>  	if (PageUptodate(page)) {
>  		err = 0;
> @@ -250,7 +259,7 @@ static inline struct bio *erofs_read_raw_page(
>  		}
>  
>  		/* for RAW access mode, m_plen must be equal to m_llen */
> -		BUG_ON(map.m_plen != map.m_llen);
> +		DBG_BUGON(map.m_plen != map.m_llen);
>  
>  		blknr = erofs_blknr(map.m_pa);
>  		blkoff = erofs_blkoff(map.m_pa);
> @@ -260,7 +269,7 @@ static inline struct bio *erofs_read_raw_page(
>  			void *vsrc, *vto;
>  			struct page *ipage;
>  
> -			BUG_ON(map.m_plen > PAGE_SIZE);
> +			DBG_BUGON(map.m_plen > PAGE_SIZE);
>  
>  			ipage = erofs_get_meta_page(inode->i_sb, blknr, 0);
>  
> @@ -287,7 +296,7 @@ static inline struct bio *erofs_read_raw_page(
>  		}
>  
>  		/* pa must be block-aligned for raw reading */
> -		BUG_ON(erofs_blkoff(map.m_pa) != 0);
> +		DBG_BUGON(erofs_blkoff(map.m_pa));
>  
>  		/* max # of continuous pages */
>  		if (nblocks > DIV_ROUND_UP(map.m_plen, PAGE_SIZE))
> @@ -355,7 +364,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
>  	if (IS_ERR(bio))
>  		return PTR_ERR(bio);
>  
> -	BUG_ON(bio != NULL);	/* since we have only one bio -- must be NULL */
> +	DBG_BUGON(bio != NULL);	/* since we have only one bio -- must be NULL */
>  	return 0;
>  }
>  
> @@ -393,7 +402,7 @@ static int erofs_raw_access_readpages(struct file *filp,
>  		/* pages could still be locked */
>  		put_page(page);
>  	}
> -	BUG_ON(!list_empty(pages));
> +	DBG_BUGON(!list_empty(pages));
>  
>  	/* the rare case (end in gaps) */
>  	if (unlikely(bio != NULL))
> diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
> index be6ae3b..918b66e 100644
> --- a/drivers/staging/erofs/dir.c
> +++ b/drivers/staging/erofs/dir.c
> @@ -54,7 +54,7 @@ static int erofs_fill_dentries(struct dir_context *ctx,
>  			le16_to_cpu(de[1].nameoff) - nameoff;
>  
>  		/* the corrupted directory found */
> -		BUG_ON(de_namelen < 0);
> +		DBG_BUGON(de_namelen < 0);

At a glance, it shouldn't be fixed in this way.
Because de_namelen is an on-disk field, it could be corrupted, you should add more error handling and DBG_BUGON(1) to deal with it.

I will review your remaining fixes later. Thanks for your patch. :)

Thanks,
Gao Xiang

>  
>  #ifdef CONFIG_EROFS_FS_DEBUG
>  		dbg_namelen = min(EROFS_NAME_LEN - 1, de_namelen);
> -- 1.9.1
> 
