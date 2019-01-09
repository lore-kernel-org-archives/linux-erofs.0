From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 9 Jan 2019 19:54:25 +0800
Subject: [PATCH] staging: erofs: clean up erofs_map_blocks_iter
In-Reply-To: <20190109094654.39285-1-yuchao0@huawei.com>
References: <20190109094654.39285-1-yuchao0@huawei.com>
Message-ID: <30dd9369-268d-2faf-1b44-dddec2c480b1@huawei.com>

Hi Chao,

On 2019/1/9 17:46, Chao Yu wrote:
> This patch cleans up erofs_map_blocks* function and structure family,
> just simply the code, no logic change.
> 
> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
> ---
>  drivers/staging/erofs/data.c      | 40 +++++++------------------------
>  drivers/staging/erofs/internal.h  | 16 ++++++-------
>  drivers/staging/erofs/unzip_vle.c | 30 +++++++++++------------
>  3 files changed, 31 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 5a55f0bfdfbb..1baa59cf11b5 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -165,43 +165,19 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
>  	return err;
>  }
>  
> -#ifdef CONFIG_EROFS_FS_ZIP
> -extern int z_erofs_map_blocks_iter(struct inode *,
> -				   struct erofs_map_blocks *,
> -				   struct page **, int);
> -#endif
> -
> -int erofs_map_blocks_iter(struct inode *inode,
> -			  struct erofs_map_blocks *map,
> -			  struct page **mpage_ret, int flags)
> -{
> -	/* by default, reading raw data never use erofs_map_blocks_iter */
> -	if (unlikely(!is_inode_layout_compression(inode))) {
> -		if (*mpage_ret)
> -			put_page(*mpage_ret);
> -		*mpage_ret = NULL;
> -
> -		return erofs_map_blocks(inode, map, flags);
> -	}
> -
> -#ifdef CONFIG_EROFS_FS_ZIP
> -	return z_erofs_map_blocks_iter(inode, map, mpage_ret, flags);
> -#else
> -	/* data compression is not available */
> -	return -ENOTSUPP;
> -#endif
> -}
> -
>  int erofs_map_blocks(struct inode *inode,
>  		     struct erofs_map_blocks *map, int flags)
>  {
>  	if (unlikely(is_inode_layout_compression(inode))) {
> -		struct page *mpage = NULL;
> -		int err;
> +		int err = -ENOTSUPP;
>  
> -		err = erofs_map_blocks_iter(inode, map, &mpage, flags);
> -		if (mpage)
> -			put_page(mpage);
> +#ifdef CONFIG_EROFS_FS_ZIP
> +		map->mpage = NULL;

remove this line? since z_erofs_map_blocks_iter will do put_page internally
if mpage != NULL.

> +
> +		err = z_erofs_map_blocks_iter(inode, map, flags);
> +#endif
> +		if (map->mpage)
> +			put_page(map->mpage);


		if (map->mpage) {
			put_page(map->mpage);
                        map->mpage = NULL;
		}


>  		return err;
>  	}
>  	return erofs_map_blocks_flatmode(inode, map, flags);
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index e049d00c087a..740961fc565f 100644
> --- a/drivers/staging/erofs/internal.h
> +++ b/drivers/staging/erofs/internal.h
> @@ -461,8 +461,16 @@ struct erofs_map_blocks {
>  	u64 m_plen, m_llen;
>  
>  	unsigned int m_flags;
> +
> +	struct page *mpage;
>  };
>  
> +#ifdef CONFIG_EROFS_FS_ZIP
> +extern int z_erofs_map_blocks_iter(struct inode *,
> +				   struct erofs_map_blocks *,
> +				   int);

#else

static inline z_erofs_map_blocks_iter(struct inode *, ...) { return -ENOTSUPP;}

 --- therefore redundant CONFIG_EROFS_FS_ZIPs could be removed.

#endif

> +#endif
> +
>  /* Flags used by erofs_map_blocks() */
>  #define EROFS_GET_BLOCKS_RAW    0x0001
>  
> @@ -522,14 +530,6 @@ static inline struct page *erofs_get_meta_page_nofail(struct super_block *sb,
>  }
>  
>  extern int erofs_map_blocks(struct inode *, struct erofs_map_blocks *, int);
> -extern int erofs_map_blocks_iter(struct inode *, struct erofs_map_blocks *,
> -	struct page **, int);
> -
> -struct erofs_map_blocks_iter {
> -	struct erofs_map_blocks map;
> -	struct page *mpage;
> -};
> -
>  
>  static inline struct page *
>  erofs_get_inline_page(struct inode *inode,
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 4ac1099a39c6..30340afaa504 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -636,7 +636,7 @@ struct z_erofs_vle_frontend {
>  	struct inode *const inode;
>  
>  	struct z_erofs_vle_work_builder builder;
> -	struct erofs_map_blocks_iter m_iter;
> +	struct erofs_map_blocks map;
>  
>  	z_erofs_vle_owned_workgrp_t owned_head;
>  
> @@ -647,8 +647,9 @@ struct z_erofs_vle_frontend {
>  
>  #define VLE_FRONTEND_INIT(__i) { \
>  	.inode = __i, \
> -	.m_iter = { \
> -		{ .m_llen = 0, .m_plen = 0 }, \
> +	.map = { \
> +		.m_llen = 0, \
> +		.m_plen = 0, \
>  		.mpage = NULL \
>  	}, \
>  	.builder = VLE_WORK_BUILDER_INIT(), \
> @@ -681,8 +682,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
>  {
>  	struct super_block *const sb = fe->inode->i_sb;
>  	struct erofs_sb_info *const sbi __maybe_unused = EROFS_SB(sb);
> -	struct erofs_map_blocks_iter *const m = &fe->m_iter;
> -	struct erofs_map_blocks *const map = &m->map;
> +	struct erofs_map_blocks *const map = &fe->map;
>  	struct z_erofs_vle_work_builder *const builder = &fe->builder;
>  	const loff_t offset = page_offset(page);
>  
> @@ -715,7 +715,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
>  
>  	map->m_la = offset + cur;
>  	map->m_llen = 0;
> -	err = erofs_map_blocks_iter(fe->inode, map, &m->mpage, 0);
> +	err = erofs_map_blocks(fe->inode, map, 0);

should use z_erofs_map_blocks_iter then rather than erofs_map_blocks

Thanks,
Gao Xiang

>  	if (unlikely(err))
>  		goto err_out;
>  
> @@ -1484,8 +1484,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
>  
>  	z_erofs_submit_and_unzip(&f, &pagepool, true);
>  out:
> -	if (f.m_iter.mpage)
> -		put_page(f.m_iter.mpage);
> +	if (f.map.mpage)
> +		put_page(f.map.mpage);
>  
>  	/* clean up the remaining free pages */
>  	put_pages_list(&pagepool);
> @@ -1555,8 +1555,8 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
>  
>  	z_erofs_submit_and_unzip(&f, &pagepool, sync);
>  
> -	if (f.m_iter.mpage)
> -		put_page(f.m_iter.mpage);
> +	if (f.map.mpage)
> +		put_page(f.map.mpage);
>  
>  	/* clean up the remaining free pages */
>  	put_pages_list(&pagepool);
> @@ -1701,14 +1701,14 @@ vle_get_logical_extent_head(const struct vle_map_blocks_iter_ctx *ctx,
>  
>  int z_erofs_map_blocks_iter(struct inode *inode,
>  	struct erofs_map_blocks *map,
> -	struct page **mpage_ret, int flags)
> +	int flags)
>  {
>  	void *kaddr;
>  	const struct vle_map_blocks_iter_ctx ctx = {
>  		.inode = inode,
>  		.sb = inode->i_sb,
>  		.clusterbits = EROFS_I_SB(inode)->clusterbits,
> -		.mpage_ret = mpage_ret,
> +		.mpage_ret = &map->mpage,
>  		.kaddr_ret = &kaddr
>  	};
>  	const unsigned int clustersize = 1 << ctx.clusterbits;
> @@ -1722,7 +1722,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>  
>  	/* initialize `pblk' to keep gcc from printing foolish warnings */
>  	erofs_blk_t mblk, pblk = 0;
> -	struct page *mpage = *mpage_ret;
> +	struct page *mpage = map->mpage;
>  	struct z_erofs_vle_decompressed_index *di;
>  	unsigned int cluster_type, logical_cluster_ofs;
>  	int err = 0;
> @@ -1758,7 +1758,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>  			err = PTR_ERR(mpage);
>  			goto out;
>  		}
> -		*mpage_ret = mpage;
> +		map->mpage = mpage;
>  	} else {
>  		lock_page(mpage);
>  		DBG_BUGON(!PageUptodate(mpage));
> @@ -1818,7 +1818,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>  		/* get the correspoinding first chunk */
>  		err = vle_get_logical_extent_head(&ctx, lcn, &ofs,
>  						  &pblk, &map->m_flags);
> -		mpage = *mpage_ret;
> +		mpage = map->mpage;
>  
>  		if (unlikely(err)) {
>  			if (mpage)
> 
