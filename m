From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 10 Aug 2018 11:05:40 +0800
Subject: [PREVIEW] [PATCH 3/4] staging: erofs: seperate erofs_get_meta_page
In-Reply-To: <1533103277-20856-3-git-send-email-gaoxiang25@huawei.com>
References: <1533103277-20856-1-git-send-email-gaoxiang25@huawei.com>
 <1533103277-20856-3-git-send-email-gaoxiang25@huawei.com>
Message-ID: <fbe65718-efdd-07bc-3006-6b4d603b7f36@huawei.com>

On 2018/8/1 14:01, Gao Xiang wrote:
> This patch seperates 'erofs_get_meta_page' into 'erofs_get_meta_page'
> and 'erofs_get_meta_page_nofail'. The second one ensures it should not
> fail due to memory pressure.
> 
> It also adds const variables in order to fulfill 80 character limit.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/data.c      | 45 +++++++++++++++++++++++----------------
>  drivers/staging/erofs/internal.h  | 24 ++++++++++++++++-----
>  drivers/staging/erofs/unzip_vle.c | 12 ++++++-----
>  drivers/staging/erofs/xattr.c     | 23 ++++++++++++--------
>  4 files changed, 67 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 2426eda..e8637d6 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -39,31 +39,42 @@ static inline void read_endio(struct bio *bio)
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
> +		}
>  
>  		err = bio_add_page(bio, page, PAGE_SIZE, 0);
> -		BUG_ON(err != PAGE_SIZE);
> +		if (unlikely(err != PAGE_SIZE)) {
> +			err = -EFAULT;
> +			goto err_out;
> +		}
>  
>  		__submit_bio(bio, REQ_OP_READ,
>  			REQ_META | (prio ? REQ_PRIO : 0));
> @@ -79,10 +90,8 @@ struct page *erofs_get_meta_page(struct super_block *sb,
>  
>  		/* more likely a read error */
>  		if (unlikely(!PageUptodate(page))) {
> -			unlock_page(page);
> -			put_page(page);
> -
> -			page = ERR_PTR(-EIO);

DBG_BUGON(nofail);

Thanks,

> +			err = -EIO;
> +			goto err_out;
>  		}
>  	}
>  	return page;
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index acce2d6..cc47b0c 100644
> --- a/drivers/staging/erofs/internal.h
> +++ b/drivers/staging/erofs/internal.h
> @@ -451,8 +451,21 @@ static inline void __submit_bio(struct bio *bio, unsigned op, unsigned op_flags)
>  	submit_bio(bio);
>  }
>  
> -extern struct page *erofs_get_meta_page(struct super_block *sb,
> -	erofs_blk_t blkaddr, bool prio);
> +extern struct page *__erofs_get_meta_page(struct super_block *sb,
> +	erofs_blk_t blkaddr, bool prio, bool nofail);
> +
> +static inline struct page *erofs_get_meta_page(struct super_block *sb,
> +	erofs_blk_t blkaddr, bool prio)
> +{
> +	return __erofs_get_meta_page(sb, blkaddr, prio, false);
> +}
> +
> +static inline struct page *erofs_get_meta_page_nofail(struct super_block *sb,
> +	erofs_blk_t blkaddr, bool prio)
> +{
> +	return __erofs_get_meta_page(sb, blkaddr, prio, true);
> +}
> +
>  extern int erofs_map_blocks(struct inode *, struct erofs_map_blocks *, int);
>  extern int erofs_map_blocks_iter(struct inode *, struct erofs_map_blocks *,
>  	struct page **, int);
> @@ -463,10 +476,11 @@ struct erofs_map_blocks_iter {
>  };
>  
>  
> -static inline struct page *erofs_get_inline_page(struct inode *inode,
> -	erofs_blk_t blkaddr)
> +static inline struct page *
> +erofs_get_inline_page_nofail(struct inode *inode,
> +			     erofs_blk_t blkaddr)
>  {
> -	return erofs_get_meta_page(inode->i_sb,
> +	return erofs_get_meta_page_nofail(inode->i_sb,
>  		blkaddr, S_ISDIR(inode->i_mode));
>  }
>  
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index be3929d..823ea2e 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -1487,7 +1487,8 @@ static erofs_off_t vle_get_logical_extent_head(
>  	erofs_blk_t blkaddr = vle_extent_blkaddr(inode, lcn);
>  	struct z_erofs_vle_decompressed_index *di;
>  	unsigned long long ofs;
> -	const unsigned int clusterbits = EROFS_SB(inode->i_sb)->clusterbits;
> +	struct super_block *const sb = inode->i_sb;
> +	const unsigned int clusterbits = EROFS_SB(sb)->clusterbits;
>  	const unsigned int clustersize = 1 << clusterbits;
>  
>  	if (page->index != blkaddr) {
> @@ -1495,8 +1496,8 @@ static erofs_off_t vle_get_logical_extent_head(
>  		unlock_page(page);
>  		put_page(page);
>  
> -		*page_iter = page = erofs_get_meta_page(inode->i_sb,
> -			blkaddr, false);
> +		page = erofs_get_meta_page_nofail(sb, blkaddr, false);
> +		*page_iter = page;
>  		*kaddr_iter = kmap_atomic(page);
>  	}
>  
> @@ -1537,7 +1538,8 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>  	struct page *mpage = *mpage_ret;
>  	void *kaddr;
>  	bool initial;
> -	const unsigned int clusterbits = EROFS_SB(inode->i_sb)->clusterbits;
> +	struct super_block *const sb = inode->i_sb;
> +	const unsigned int clusterbits = EROFS_SB(sb)->clusterbits;
>  	const unsigned int clustersize = 1 << clusterbits;
>  	int err = 0;
>  
> @@ -1568,7 +1570,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>  		if (mpage != NULL)
>  			put_page(mpage);
>  
> -		mpage = erofs_get_meta_page(inode->i_sb, e_blkaddr, false);
> +		mpage = erofs_get_meta_page_nofail(sb, e_blkaddr, false);
>  		*mpage_ret = mpage;
>  	} else {
>  		lock_page(mpage);
> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
> index 6b9685f..702434b 100644
> --- a/drivers/staging/erofs/xattr.c
> +++ b/drivers/staging/erofs/xattr.c
> @@ -38,6 +38,7 @@ static void init_inode_xattrs(struct inode *inode)
>  	struct xattr_iter it;
>  	unsigned i;
>  	struct erofs_xattr_ibody_header *ih;
> +	struct super_block *sb;
>  	struct erofs_sb_info *sbi;
>  	struct erofs_vnode *vi;
>  	bool atomic_map;
> @@ -48,11 +49,12 @@ static void init_inode_xattrs(struct inode *inode)
>  	vi = EROFS_V(inode);
>  	BUG_ON(!vi->xattr_isize);
>  
> -	sbi = EROFS_I_SB(inode);
> +	sb = inode->i_sb;
> +	sbi = EROFS_SB(sb);
>  	it.blkaddr = erofs_blknr(iloc(sbi, vi->nid) + vi->inode_isize);
>  	it.ofs = erofs_blkoff(iloc(sbi, vi->nid) + vi->inode_isize);
>  
> -	it.page = erofs_get_inline_page(inode, it.blkaddr);
> +	it.page = erofs_get_inline_page_nofail(inode, it.blkaddr);
>  	BUG_ON(IS_ERR(it.page));
>  
>  	/* read in shared xattr array (non-atomic, see kmalloc below) */
> @@ -75,7 +77,7 @@ static void init_inode_xattrs(struct inode *inode)
>  			BUG_ON(it.ofs != EROFS_BLKSIZ);
>  			xattr_iter_end(&it, atomic_map);
>  
> -			it.page = erofs_get_meta_page(inode->i_sb,
> +			it.page = erofs_get_meta_page_nofail(sb,
>  				++it.blkaddr, S_ISDIR(inode->i_mode));
>  			BUG_ON(IS_ERR(it.page));
>  
> @@ -105,7 +107,8 @@ static void xattr_iter_fixup(struct xattr_iter *it)
>  		xattr_iter_end(it, true);
>  
>  		it->blkaddr += erofs_blknr(it->ofs);
> -		it->page = erofs_get_meta_page(it->sb, it->blkaddr, false);
> +		it->page = erofs_get_meta_page_nofail(it->sb,
> +			it->blkaddr, false);
>  		BUG_ON(IS_ERR(it->page));
>  
>  		it->kaddr = kmap_atomic(it->page);
> @@ -131,7 +134,7 @@ static int inline_xattr_iter_begin(struct xattr_iter *it,
>  	it->blkaddr = erofs_blknr(iloc(sbi, vi->nid) + inline_xattr_ofs);
>  	it->ofs = erofs_blkoff(iloc(sbi, vi->nid) + inline_xattr_ofs);
>  
> -	it->page = erofs_get_inline_page(inode, it->blkaddr);
> +	it->page = erofs_get_inline_page_nofail(inode, it->blkaddr);
>  	BUG_ON(IS_ERR(it->page));
>  	it->kaddr = kmap_atomic(it->page);
>  
> @@ -300,7 +303,8 @@ static int inline_getxattr(struct inode *inode, struct getxattr_iter *it)
>  static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
>  {
>  	struct erofs_vnode *const vi = EROFS_V(inode);
> -	struct erofs_sb_info *const sbi = EROFS_SB(inode->i_sb);
> +	struct super_block *const sb = inode->i_sb;
> +	struct erofs_sb_info *const sbi = EROFS_SB(sb);
>  	unsigned i;
>  	int ret = -ENOATTR;
>  
> @@ -314,7 +318,7 @@ static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
>  			if (i)
>  				xattr_iter_end(&it->it, true);
>  
> -			it->it.page = erofs_get_meta_page(inode->i_sb,
> +			it->it.page = erofs_get_meta_page_nofail(sb,
>  				blkaddr, false);
>  			BUG_ON(IS_ERR(it->it.page));
>  			it->it.kaddr = kmap_atomic(it->it.page);
> @@ -524,7 +528,8 @@ static int shared_listxattr(struct listxattr_iter *it)
>  {
>  	struct inode *const inode = d_inode(it->dentry);
>  	struct erofs_vnode *const vi = EROFS_V(inode);
> -	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
> +	struct super_block *const sb = inode->i_sb;
> +	struct erofs_sb_info *const sbi = EROFS_SB(sb);
>  	unsigned i;
>  	int ret = 0;
>  
> @@ -537,7 +542,7 @@ static int shared_listxattr(struct listxattr_iter *it)
>  			if (i)
>  				xattr_iter_end(&it->it, true);
>  
> -			it->it.page = erofs_get_meta_page(inode->i_sb,
> +			it->it.page = erofs_get_meta_page_nofail(sb,
>  				blkaddr, false);
>  			BUG_ON(IS_ERR(it->it.page));
>  			it->it.kaddr = kmap_atomic(it->it.page);
> 
