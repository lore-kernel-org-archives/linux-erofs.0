From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 10 Aug 2018 11:47:33 +0800
Subject: [PREVIEW] [PATCH 4/4] staging: erofs: add error handling for
 xattr submodule
In-Reply-To: <26f27530-9b3c-8f78-22e2-04a2ec6c6e2d@huawei.com>
References: <1533103277-20856-1-git-send-email-gaoxiang25@huawei.com>
 <1533103277-20856-4-git-send-email-gaoxiang25@huawei.com>
 <26f27530-9b3c-8f78-22e2-04a2ec6c6e2d@huawei.com>
Message-ID: <08596437-a69f-b809-157b-dca5865d4c1b@huawei.com>

Hi Chao,

On 2018/8/10 11:40, Chao Yu wrote:
> On 2018/8/1 14:01, Gao Xiang wrote:
>> This patch enhances the missing error handling code for
>> xattr submodule, which improves the stability for the rare cases.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>>  drivers/staging/erofs/xattr.c | 114 ++++++++++++++++++++++++++++--------------
>>  1 file changed, 77 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
>> index 702434b..bd911bb 100644
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
>> @@ -55,7 +64,8 @@ static void init_inode_xattrs(struct inode *inode)
>>  	it.ofs = erofs_blkoff(iloc(sbi, vi->nid) + vi->inode_isize);
>>  
>>  	it.page = erofs_get_inline_page_nofail(inode, it.blkaddr);
> 
> Need to introduce and use erofs_get_inline_page()?
> 
>> -	BUG_ON(IS_ERR(it.page));
>> +	if (unlikely(IS_ERR(it.page)))
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
>> @@ -79,7 +92,8 @@ static void init_inode_xattrs(struct inode *inode)
>>  
>>  			it.page = erofs_get_meta_page_nofail(sb,
>>  				++it.blkaddr, S_ISDIR(inode->i_mode));
> 
> Need to use erofs_get_meta_page() instead?
> 
> Thanks,

My consideration is for example,

init_inode_xattrs itself can be seen as a part of inode initialization (other fs does it in
inode initialization, but erofs does it in the first xattr request), if it fail, the only way
is to retry again...but with more overhead to retry...

How do you think about it? ...

> 
>> -			BUG_ON(IS_ERR(it.page));
>> +			if (unlikely(IS_ERR(it.page)))
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
>> +	if (unlikely(IS_ERR(it->page))) {
>> +		it->page = NULL;
>> +		return PTR_ERR(it->page);
>>  	}
>> +
>> +	it->kaddr = kmap_atomic(it->page);
>> +	it->ofs = erofs_blkoff(it->ofs);
>> +	return 0;
>>  }
>>  
>>  static int inline_xattr_iter_begin(struct xattr_iter *it,
>> @@ -135,21 +155,24 @@ static int inline_xattr_iter_begin(struct xattr_iter *it,
>>  	it->ofs = erofs_blkoff(iloc(sbi, vi->nid) + inline_xattr_ofs);
>>  
>>  	it->page = erofs_get_inline_page_nofail(inode, it->blkaddr);
> 
> Ditto,
> 
This should be converted into erofs_get_inline_page actually... I'm lazy about that, sorry...
Let me send another patch..

Thanks,
Gao Xiang

>> -	BUG_ON(IS_ERR(it->page));
>> -	it->kaddr = kmap_atomic(it->page);
>> +	if (unlikely(IS_ERR(it->page)))
>> +		return PTR_ERR(it->page);
>>  
>> +	it->kaddr = kmap_atomic(it->page);
>>  	return vi->xattr_isize - xattr_header_sz;
>>  }
>>  
>>  static int xattr_foreach(struct xattr_iter *it,
>> -	struct xattr_iter_handlers *op, unsigned *tlimit)
>> +	const struct xattr_iter_handlers *op, unsigned *tlimit)
>>  {
>>  	struct erofs_xattr_entry entry;
>>  	unsigned value_sz, processed, slice;
>>  	int err;
>>  
>>  	/* 0. fixup blkaddr, ofs, ipage */
>> -	xattr_iter_fixup(it);
>> +	err = xattr_iter_fixup(it);
>> +	if (unlikely(err))
>> +		return err;
>>  
>>  	/*
>>  	 * 1. read xattr entry to the memory,
>> @@ -181,7 +204,9 @@ static int xattr_foreach(struct xattr_iter *it,
>>  		if (it->ofs >= EROFS_BLKSIZ) {
>>  			BUG_ON(it->ofs > EROFS_BLKSIZ);
>>  
>> -			xattr_iter_fixup(it);
>> +			err = xattr_iter_fixup(it);
>> +			if (unlikely(err))
>> +				goto out;
>>  			it->ofs = 0;
>>  		}
>>  
>> @@ -213,7 +238,10 @@ static int xattr_foreach(struct xattr_iter *it,
>>  	while (processed < value_sz) {
>>  		if (it->ofs >= EROFS_BLKSIZ) {
>>  			BUG_ON(it->ofs > EROFS_BLKSIZ);
>> -			xattr_iter_fixup(it);
>> +
>> +			err = xattr_iter_fixup(it);
>> +			if (unlikely(err))
>> +				goto out;
>>  			it->ofs = 0;
>>  		}
>>  
>> @@ -273,7 +301,7 @@ static void xattr_copyvalue(struct xattr_iter *_it,
>>  	memcpy(it->buffer + processed, buf, len);
>>  }
>>  
>> -static struct xattr_iter_handlers find_xattr_handlers = {
>> +static const struct xattr_iter_handlers find_xattr_handlers = {
>>  	.entry = xattr_entrymatch,
>>  	.name = xattr_namematch,
>>  	.alloc_buffer = xattr_checkbuffer,
>> @@ -294,8 +322,11 @@ static int inline_getxattr(struct inode *inode, struct getxattr_iter *it)
>>  		if ((ret = xattr_foreach(&it->it,
>>  			&find_xattr_handlers, &remaining)) >= 0)
>>  			break;
>> +
>> +		if (unlikely(ret != -ENOATTR))	/* -ENOMEM, -EIO, etc. */
>> +			break;
>>  	}
>> -	xattr_iter_end(&it->it, true);
>> +	xattr_iter_end_final(&it->it);
>>  
>>  	return ret < 0 ? ret : it->buffer_size;
>>  }
>> @@ -318,9 +349,10 @@ static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
>>  			if (i)
>>  				xattr_iter_end(&it->it, true);
>>  
>> -			it->it.page = erofs_get_meta_page_nofail(sb,
>> -				blkaddr, false);
>> -			BUG_ON(IS_ERR(it->it.page));
>> +			it->it.page = erofs_get_meta_page(sb, blkaddr, false);
>> +			if (unlikely(IS_ERR(it->it.page)))
>> +				return PTR_ERR(it->it.page);
>> +
>>  			it->it.kaddr = kmap_atomic(it->it.page);
>>  			it->it.blkaddr = blkaddr;
>>  		}
>> @@ -328,9 +360,12 @@ static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
>>  		if ((ret = xattr_foreach(&it->it,
>>  			&find_xattr_handlers, NULL)) >= 0)
>>  			break;
>> +
>> +		if (unlikely(ret != -ENOATTR))	/* -ENOMEM, -EIO, etc. */
>> +			break;
>>  	}
>>  	if (vi->xattr_shared_count)
>> -		xattr_iter_end(&it->it, true);
>> +		xattr_iter_end_final(&it->it);
>>  
>>  	return ret < 0 ? ret : it->buffer_size;
>>  }
>> @@ -355,7 +390,9 @@ int erofs_getxattr(struct inode *inode, int index,
>>  	if (unlikely(name == NULL))
>>  		return -EINVAL;
>>  
>> -	init_inode_xattrs(inode);
>> +	ret = init_inode_xattrs(inode);
>> +	if (unlikely(ret < 0))
>> +		return ret;
>>  
>>  	it.index = index;
>>  
>> @@ -498,7 +535,7 @@ static int xattr_skipvalue(struct xattr_iter *_it,
>>  	return 1;
>>  }
>>  
>> -static struct xattr_iter_handlers list_xattr_handlers = {
>> +static const struct xattr_iter_handlers list_xattr_handlers = {
>>  	.entry = xattr_entrylist,
>>  	.name = xattr_namelist,
>>  	.alloc_buffer = xattr_skipvalue,
>> @@ -520,7 +557,7 @@ static int inline_listxattr(struct listxattr_iter *it)
>>  			&list_xattr_handlers, &remaining)) < 0)
>>  			break;
>>  	}
>> -	xattr_iter_end(&it->it, true);
>> +	xattr_iter_end_final(&it->it);
>>  	return ret < 0 ? ret : it->buffer_ofs;
>>  }
>>  
>> @@ -542,9 +579,10 @@ static int shared_listxattr(struct listxattr_iter *it)
>>  			if (i)
>>  				xattr_iter_end(&it->it, true);
>>  
>> -			it->it.page = erofs_get_meta_page_nofail(sb,
>> -				blkaddr, false);
>> -			BUG_ON(IS_ERR(it->it.page));
>> +			it->it.page = erofs_get_meta_page(sb, blkaddr, false);
>> +			if (unlikely(IS_ERR(it->it.page)))
>> +				return PTR_ERR(it->it.page);
>> +
>>  			it->it.kaddr = kmap_atomic(it->it.page);
>>  			it->it.blkaddr = blkaddr;
>>  		}
>> @@ -554,7 +592,7 @@ static int shared_listxattr(struct listxattr_iter *it)
>>  			break;
>>  	}
>>  	if (vi->xattr_shared_count)
>> -		xattr_iter_end(&it->it, true);
>> +		xattr_iter_end_final(&it->it);
>>  
>>  	return ret < 0 ? ret : it->buffer_ofs;
>>  }
>> @@ -565,7 +603,9 @@ ssize_t erofs_listxattr(struct dentry *dentry,
>>  	int ret;
>>  	struct listxattr_iter it;
>>  
>> -	init_inode_xattrs(d_inode(dentry));
>> +	ret = init_inode_xattrs(d_inode(dentry));
>> +	if (unlikely(ret < 0))
>> +		return ret;
>>  
>>  	it.dentry = dentry;
>>  	it.buffer = buffer;
>>
> 
