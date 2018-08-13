From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 13 Aug 2018 10:36:39 +0800
Subject: [PATCH 3/8] staging: erofs: add error handling for xattr submodule
In-Reply-To: <11a5b8c0-c3fa-0da9-a41b-a6b33ddcc9bb@huawei.com>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-4-chao@kernel.org>
 <11a5b8c0-c3fa-0da9-a41b-a6b33ddcc9bb@huawei.com>
Message-ID: <3d6e8cd9-0263-2196-7b45-b60245f0ba7c@huawei.com>

Hi Chao,

On 2018/8/13 10:00, Chao Yu wrote:
> On 2018/8/12 22:01, Chao Yu wrote:
>> From: Gao Xiang <gaoxiang25 at huawei.com>
>>
>> This patch enhances the missing error handling code for
>> xattr submodule, which improves the stability for the rare cases.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
>> ---
>>  drivers/staging/erofs/internal.h |   6 +-
>>  drivers/staging/erofs/xattr.c    | 120 ++++++++++++++++++++-----------
>>  2 files changed, 83 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
>> index a756abeff7e9..8951e01216e3 100644
>> --- a/drivers/staging/erofs/internal.h
>> +++ b/drivers/staging/erofs/internal.h
>> @@ -485,10 +485,10 @@ struct erofs_map_blocks_iter {
>>  
>>  
>>  static inline struct page *
>> -erofs_get_inline_page_nofail(struct inode *inode,
>> -			     erofs_blk_t blkaddr)
>> +erofs_get_inline_page(struct inode *inode,
>> +		      erofs_blk_t blkaddr)
>>  {
>> -	return erofs_get_meta_page_nofail(inode->i_sb,
>> +	return erofs_get_meta_page(inode->i_sb,
>>  		blkaddr, S_ISDIR(inode->i_mode));
>>  }
>>  
>> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
>> index 2593c856b079..1b5815fc70db 100644
>> --- a/drivers/staging/erofs/xattr.c
>> +++ b/drivers/staging/erofs/xattr.c
>> @@ -24,16 +24,25 @@ struct xattr_iter {
>>  
>>  static inline void xattr_iter_end(struct xattr_iter *it, bool atomic)
>>  {
>> -	/* only init_inode_xattrs use non-atomic once */
>> +	/* the only user of kunmap() is 'init_inode_xattrs' */
>>  	if (unlikely(!atomic))
>>  		kunmap(it->page);
>>  	else
>>  		kunmap_atomic(it->kaddr);
>> +
>>  	unlock_page(it->page);
>>  	put_page(it->page);
>>  }
>>  
>> -static void init_inode_xattrs(struct inode *inode)
>> +static inline void xattr_iter_end_final(struct xattr_iter *it)
>> +{
>> +	if (unlikely(it->page == NULL))
>> +		return;
>> +
>> +	xattr_iter_end(it, true);
>> +}
>> +
>> +static int init_inode_xattrs(struct inode *inode)
>>  {
>>  	struct xattr_iter it;
>>  	unsigned i;
>> @@ -44,7 +53,7 @@ static void init_inode_xattrs(struct inode *inode)
>>  	bool atomic_map;
>>  
>>  	if (likely(inode_has_inited_xattr(inode)))
>> -		return;
>> +		return 0;
>>  
>>  	vi = EROFS_V(inode);
>>  	BUG_ON(!vi->xattr_isize);
>> @@ -54,8 +63,9 @@ static void init_inode_xattrs(struct inode *inode)
>>  	it.blkaddr = erofs_blknr(iloc(sbi, vi->nid) + vi->inode_isize);
>>  	it.ofs = erofs_blkoff(iloc(sbi, vi->nid) + vi->inode_isize);
>>  
>> -	it.page = erofs_get_inline_page_nofail(inode, it.blkaddr);
>> -	BUG_ON(IS_ERR(it.page));
>> +	it.page = erofs_get_inline_page(inode, it.blkaddr);
>> +	if (IS_ERR(it.page))
>> +		return PTR_ERR(it.page);
>>  
>>  	/* read in shared xattr array (non-atomic, see kmalloc below) */
>>  	it.kaddr = kmap(it.page);
>> @@ -64,9 +74,12 @@ static void init_inode_xattrs(struct inode *inode)
>>  	ih = (struct erofs_xattr_ibody_header *)(it.kaddr + it.ofs);
>>  
>>  	vi->xattr_shared_count = ih->h_shared_count;
>> -	vi->xattr_shared_xattrs = (unsigned *)kmalloc_array(
>> -		vi->xattr_shared_count, sizeof(unsigned),
>> -		GFP_KERNEL | __GFP_NOFAIL);
>> +	vi->xattr_shared_xattrs = kmalloc_array(vi->xattr_shared_count,
>> +						sizeof(unsigned), GFP_KERNEL);
>> +	if (unlikely(vi->xattr_shared_xattrs == NULL)) {
>> +		xattr_iter_end(&it, atomic_map);
>> +		return -ENOMEM;
>> +	}
>>  
>>  	/* let's skip ibody header */
>>  	it.ofs += sizeof(struct erofs_xattr_ibody_header);
>> @@ -77,9 +90,10 @@ static void init_inode_xattrs(struct inode *inode)
>>  			BUG_ON(it.ofs != EROFS_BLKSIZ);
>>  			xattr_iter_end(&it, atomic_map);
>>  
>> -			it.page = erofs_get_meta_page_nofail(sb,
>> +			it.page = erofs_get_meta_page(sb,
>>  				++it.blkaddr, S_ISDIR(inode->i_mode));
>> -			BUG_ON(IS_ERR(it.page));
>> +			if (IS_ERR(it.page))
>> +				return PTR_ERR(it.page);
>>  
>>  			it.kaddr = kmap_atomic(it.page);
>>  			atomic_map = true;
>> @@ -92,6 +106,7 @@ static void init_inode_xattrs(struct inode *inode)
>>  	xattr_iter_end(&it, atomic_map);
>>  
>>  	inode_set_inited_xattr(inode);
>> +	return 0;
>>  }
>>  
>>  struct xattr_iter_handlers {
>> @@ -101,19 +116,24 @@ struct xattr_iter_handlers {
>>  	void (*value)(struct xattr_iter *, unsigned, char *, unsigned);
>>  };
>>  
>> -static void xattr_iter_fixup(struct xattr_iter *it)
>> +static inline int xattr_iter_fixup(struct xattr_iter *it)
>>  {
>> -	if (unlikely(it->ofs >= EROFS_BLKSIZ)) {
>> -		xattr_iter_end(it, true);
>> +	if (likely(it->ofs < EROFS_BLKSIZ))
>> +		return 0;
>>  
>> -		it->blkaddr += erofs_blknr(it->ofs);
>> -		it->page = erofs_get_meta_page_nofail(it->sb,
>> -			it->blkaddr, false);
>> -		BUG_ON(IS_ERR(it->page));
>> +	xattr_iter_end(it, true);
>>  
>> -		it->kaddr = kmap_atomic(it->page);
>> -		it->ofs = erofs_blkoff(it->ofs);
>> +	it->blkaddr += erofs_blknr(it->ofs);
>> +
>> +	it->page = erofs_get_meta_page(it->sb, it->blkaddr, false);
>> +	if (IS_ERR(it->page)) {
>> +		it->page = NULL;
>> +		return PTR_ERR(it->page);
> As LKP reported, we need to fix this as below:
> 
> err = PTR_ERR(it->page);
> it->page = NULL;
> return err;
> 
> Thanks,
>

I have seen this at
https://lists.01.org/pipermail/kbuild-all/2018-August/051187.html

I will fix it soon. Thanks for report.

Thanks,
Gao Xiang
