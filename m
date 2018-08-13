From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 13 Aug 2018 20:17:27 +0800
Subject: [PATCH 3/8] staging: erofs: add error handling for xattr submodule
In-Reply-To: <20180813114725.kgoupvppcwsw2vyj@mwanda>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-4-chao@kernel.org>
 <20180813114725.kgoupvppcwsw2vyj@mwanda>
Message-ID: <c14184af-6378-fd96-3b9b-52c9a7da8463@huawei.com>

Hi Dan,

On 2018/8/13 19:47, Dan Carpenter wrote:
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
> 
> This is returning PTR_ERR(NULL) which is success.  There is a smatch
> test for this and maybe other static checkers as well so it would have
> been caught very quickly.
> 

I am sorry about this. It has already fixed in patch v2.

>>  	}
>> +
>> +	it->kaddr = kmap_atomic(it->page);
>> +	it->ofs = erofs_blkoff(it->ofs);
>> +	return 0;
>>  }
>>  
>>  static int inline_xattr_iter_begin(struct xattr_iter *it,
>> @@ -134,22 +154,25 @@ static int inline_xattr_iter_begin(struct xattr_iter *it,
>>  	it->blkaddr = erofs_blknr(iloc(sbi, vi->nid) + inline_xattr_ofs);
>>  	it->ofs = erofs_blkoff(iloc(sbi, vi->nid) + inline_xattr_ofs);
>>  
>> -	it->page = erofs_get_inline_page_nofail(inode, it->blkaddr);
>> -	BUG_ON(IS_ERR(it->page));
>> -	it->kaddr = kmap_atomic(it->page);
>> +	it->page = erofs_get_inline_page(inode, it->blkaddr);
>> +	if (IS_ERR(it->page))
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
>>  		ret = xattr_foreach(&it->it, &find_xattr_handlers, &remaining);
>>  		if (ret >= 0)
>>  			break;
>> +
>> +		if (unlikely(ret != -ENOATTR))	/* -ENOMEM, -EIO, etc. */
> 
> I have held off commenting on all the likely/unlikely annotations we
> are adding because I don't know what the fast paths are in this code.
> However, this is clearly an error path here, not on a fast path.
> 
> Generally the rule on likely/unlikely is that they hurt readability so
> we should only add them if it makes a difference in benchmarking.
> 

In my opinion, return values other than 0 and ENOATTR(ENODATA) rarely happens,
it should be in the slow path...

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
>> +			if (IS_ERR(it->it.page))
>> +				return PTR_ERR(it->it.page);
>> +
>>  			it->it.kaddr = kmap_atomic(it->it.page);
>>  			it->it.blkaddr = blkaddr;
>>  		}
>> @@ -328,9 +360,12 @@ static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
>>  		ret = xattr_foreach(&it->it, &find_xattr_handlers, NULL);
>>  		if (ret >= 0)
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
> 
> Not related to your patch but what does "return 1;" mean here?  It's
> weird to me that xattr_skipvalue() doesn't use value_sz at all.  I can't
> decide if the function always succeeds or always fails.
> 

There are two implementations of .alloc_buffer, the one is
xattr_skipvalue (used for listxattr, always succeeds in order to skip
processing its xattr values), and another is xattr_checkbuffer (used for getxattr).

> The xattr_skipvalue/alloc_buffer function is called like this:
> 
> 	err = op->alloc_buffer(it, value_sz);
> 	if (err) {
> 		it->ofs += value_sz;
> 		goto out;
> 	}
> 
> It looks like if we hit an error, we increase it->ofs.  All the other
> error paths in this function take a negative error and increase it->ofs
> so this looks like an error path.  The goto out look like this:

Let me try to explain the design idea... If we are about to processing the xattr value,

for getxattr, we need to check the xattr buffer is enough to contain the upcoming xattr value,
return 0 to process(copy) its value to xattr buffer, return < 0 if some error (eg. buffer size is not enough) occurred.

for listxattr, we need to skip this round to handle the next xattr item rather than continue to processing
its upcoming xattr value, so 1 (>0) is returned.

P.S. Whether `foreach' succeed or not, it should point to the next xattr item rather than the arbitary position,
so that we can handle the next xattr properly (if the current xattr is not the needed xattr).

> 
> 	/* we assume that ofs is aligned with 4 bytes */
> 	it->ofs = EROFS_XATTR_ALIGN(it->ofs);
> 	return err;
> 
> So we return 1 here and the callers all treat it at success...  There
> needs to be some documentation for what positive returns mean.
OK, let me add more comments to show that.

Thanks,
Gao Xiang

> 
> regards,
> dan carpenter
> 
