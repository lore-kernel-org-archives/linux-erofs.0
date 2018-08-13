From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 13 Aug 2018 19:23:23 +0800
Subject: [PATCH 2/8] staging: erofs: separate erofs_get_meta_page
In-Reply-To: <20180813110405.3qoburir3ds5ux33@mwanda>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-3-chao@kernel.org>
 <20180813110405.3qoburir3ds5ux33@mwanda>
Message-ID: <3e77ae86-d417-6632-4894-d257fdb17a21@huawei.com>

Hi Dan,

On 2018/8/13 19:04, Dan Carpenter wrote:
> On Sun, Aug 12, 2018@10:01:44PM +0800, Chao Yu wrote:
>> --- a/drivers/staging/erofs/data.c
>> +++ b/drivers/staging/erofs/data.c
>> @@ -39,31 +39,44 @@ static inline void read_endio(struct bio *bio)
>>  }
>>  
>>  /* prio -- true is used for dir */
>> -struct page *erofs_get_meta_page(struct super_block *sb,
>> -	erofs_blk_t blkaddr, bool prio)
>> +struct page *__erofs_get_meta_page(struct super_block *sb,
>> +	erofs_blk_t blkaddr, bool prio, bool nofail)
>>  {
>> -	struct inode *bd_inode = sb->s_bdev->bd_inode;
>> -	struct address_space *mapping = bd_inode->i_mapping;
>> +	struct inode *const bd_inode = sb->s_bdev->bd_inode;
>> +	struct address_space *const mapping = bd_inode->i_mapping;
>> +	/* prefer retrying in the allocator to blindly looping below */
>> +	const gfp_t gfp = mapping_gfp_constraint(mapping, ~__GFP_FS) |
>> +		(nofail ? __GFP_NOFAIL : 0);
>> +	unsigned int io_retries = nofail ? EROFS_IO_MAX_RETRIES_NOFAIL : 0;
>>  	struct page *page;
>>  
>>  repeat:
>> -	page = find_or_create_page(mapping, blkaddr,
>> -	/*
>> -	 * Prefer looping in the allocator rather than here,
>> -	 * at least that code knows what it's doing.
>> -	 */
>> -		mapping_gfp_constraint(mapping, ~__GFP_FS) | __GFP_NOFAIL);
>> -
>> -	BUG_ON(!page || !PageLocked(page));
>> +	page = find_or_create_page(mapping, blkaddr, gfp);
>> +	if (unlikely(page == NULL)) {
>> +		DBG_BUGON(nofail);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +	DBG_BUGON(!PageLocked(page));
>>  
>>  	if (!PageUptodate(page)) {
>>  		struct bio *bio;
>>  		int err;
>>  
>> -		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, true);
>> +		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, nofail);
>> +		if (unlikely(bio == NULL)) {
>> +			DBG_BUGON(nofail);
>> +			err = -ENOMEM;
>> +err_out:
>> +			unlock_page(page);
>> +			put_page(page);
>> +			return ERR_PTR(err);
> 
> Put this err_out stuff at the bottom of the function so that we don't
> have to do backward hops to get to it.
> 
>> +		}
>>  
>>  		err = bio_add_page(bio, page, PAGE_SIZE, 0);
>> -		BUG_ON(err != PAGE_SIZE);
>> +		if (unlikely(err != PAGE_SIZE)) {
>> +			err = -EFAULT;
>> +			goto err_out;
>                         ^^^^^^^^^^^^
> Like this.  Generally avoid backwards hops if you can.
> 
>> +		}
>>  
>>  		__submit_bio(bio, REQ_OP_READ,
>>  			REQ_META | (prio ? REQ_PRIO : 0));
>> @@ -72,6 +85,7 @@ struct page *erofs_get_meta_page(struct super_block *sb,
>>  
>>  		/* the page has been truncated by others? */
>>  		if (unlikely(page->mapping != mapping)) {
>> +unlock_repeat:
> The question mark in the "truncated by others?" is a little concerning.
> It's slightly weird that we don't check "io_retries" on this path.
>
Thanks for your reply.

erofs use the shared block device bd_inode->mapping for its meta use, which is visible
to other code rather than erofs internally only, so I think it needs to get rid of
potentially truncating by others, and such comments can also be found at

- pagecache_get_page
1557                 /* Has the page been truncated? */
1558                 if (unlikely(page->mapping != mapping)) {
1559                         unlock_page(page);
1560                         put_page(page);
1561                         goto repeat;
1562                 }

- filemap_fault
2535         /* Did it get truncated? */
2536         if (unlikely(page->mapping != mapping)) {
2537                 unlock_page(page);
2538                 put_page(page);
2539                 goto retry_find;
2540         }

I think it is somewhat necessary, and some suggestion about this? thanks in advance.

"It's slightly weird that we don't check "io_retries" on this path"
I think you are right, let me rethink about it and send the next patch...

Thanks,
Gao Xiang
