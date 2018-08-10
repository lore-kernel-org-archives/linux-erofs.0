From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 10 Aug 2018 14:02:51 +0800
Subject: [PREVIEW] [PATCH 3/4] staging: erofs: seperate erofs_get_meta_page
In-Reply-To: <7ce60f37-5084-8762-b99b-eb3d8c1e3a5a@huawei.com>
References: <1533103277-20856-1-git-send-email-gaoxiang25@huawei.com>
 <1533103277-20856-3-git-send-email-gaoxiang25@huawei.com>
 <fbe65718-efdd-07bc-3006-6b4d603b7f36@huawei.com>
 <7ce60f37-5084-8762-b99b-eb3d8c1e3a5a@huawei.com>
Message-ID: <173e0b85-0553-1660-c7bf-14be69d487a8@huawei.com>

Hi Xiang,

On 2018/8/10 11:28, Gao Xiang wrote:
> Hi Chao,
> 
> On 2018/8/10 11:05, Chao Yu wrote:
>> On 2018/8/1 14:01, Gao Xiang wrote:
>>> This patch seperates 'erofs_get_meta_page' into 'erofs_get_meta_page'
>>> and 'erofs_get_meta_page_nofail'. The second one ensures it should not
>>> fail due to memory pressure.
>>>
>>> It also adds const variables in order to fulfill 80 character limit.
>>>
>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>> ---
>>>  drivers/staging/erofs/data.c      | 45 +++++++++++++++++++++++----------------
>>>  drivers/staging/erofs/internal.h  | 24 ++++++++++++++++-----
>>>  drivers/staging/erofs/unzip_vle.c | 12 ++++++-----
>>>  drivers/staging/erofs/xattr.c     | 23 ++++++++++++--------
>>>  4 files changed, 67 insertions(+), 37 deletions(-)
>>>
>>> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
>>> index 2426eda..e8637d6 100644
>>> --- a/drivers/staging/erofs/data.c
>>> +++ b/drivers/staging/erofs/data.c
>>> @@ -39,31 +39,42 @@ static inline void read_endio(struct bio *bio)
>>>  }
>>>  
>>>  /* prio -- true is used for dir */
>>> -struct page *erofs_get_meta_page(struct super_block *sb,
>>> -	erofs_blk_t blkaddr, bool prio)
>>> +struct page *__erofs_get_meta_page(struct super_block *sb,
>>> +	erofs_blk_t blkaddr, bool prio, bool nofail)
>>>  {
>>> -	struct inode *bd_inode = sb->s_bdev->bd_inode;
>>> -	struct address_space *mapping = bd_inode->i_mapping;
>>> +	struct inode *const bd_inode = sb->s_bdev->bd_inode;
>>> +	struct address_space *const mapping = bd_inode->i_mapping;
>>> +	/* prefer retrying in the allocator to blindly looping below */
>>> +	const gfp_t gfp = mapping_gfp_constraint(mapping, ~__GFP_FS) |
>>> +		(nofail ? __GFP_NOFAIL : 0);
>>>  	struct page *page;
>>>  
>>>  repeat:
>>> -	page = find_or_create_page(mapping, blkaddr,
>>> -	/*
>>> -	 * Prefer looping in the allocator rather than here,
>>> -	 * at least that code knows what it's doing.
>>> -	 */
>>> -		mapping_gfp_constraint(mapping, ~__GFP_FS) | __GFP_NOFAIL);
>>> -
>>> -	BUG_ON(!page || !PageLocked(page));
>>> +	page = find_or_create_page(mapping, blkaddr, gfp);
>>> +	if (unlikely(page == NULL)) {
>>> +		DBG_BUGON(nofail);
>>> +		return ERR_PTR(-ENOMEM);
>>> +	}
>>>  
>>>  	if (!PageUptodate(page)) {
>>>  		struct bio *bio;
>>>  		int err;
>>>  
>>> -		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, true);
>>> +		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, nofail);
>>> +		if (unlikely(bio == NULL)) {
>>> +			DBG_BUGON(nofail);
>>> +			err = -ENOMEM;
>>> +err_out:
>>> +			unlock_page(page);
>>> +			put_page(page);
>>> +			return ERR_PTR(err);
>>> +		}
>>>  
>>>  		err = bio_add_page(bio, page, PAGE_SIZE, 0);
>>> -		BUG_ON(err != PAGE_SIZE);
>>> +		if (unlikely(err != PAGE_SIZE)) {
>>> +			err = -EFAULT;
>>> +			goto err_out;
>>> +		}
>>>  
>>>  		__submit_bio(bio, REQ_OP_READ,
>>>  			REQ_META | (prio ? REQ_PRIO : 0));
>>> @@ -79,10 +90,8 @@ struct page *erofs_get_meta_page(struct super_block *sb,
>>>  
>>>  		/* more likely a read error */
>>>  		if (unlikely(!PageUptodate(page))) {
>>> -			unlock_page(page);
>>> -			put_page(page);
>>> -
>>> -			page = ERR_PTR(-EIO);
>> DBG_BUGON(nofail);
>>
>> Thanks,
>>
> 
> nofail in erofs means "no fail under memory pressure", if !PageUptodate(page) after endio,

Yup, that matches your commit log.

> it means "a IO read error occurred", so I think it could happen on disk error and
> it is not suitable to guarantee disk error nofail (...may be cause EIO again and again...).......

IMO, the purpose of introducing 'nofail' function is to make caller simplifying
its error handling, since callee can handle any error insidely, if callee still
can fail due to other reason like -EIO, we still need another handling in caller.

So here, if we encounter -EIO, how about retrying several time in
erofs_get_meta_page_nofail like f2fs did now?

Thanks,

> 
> Thanks,
> Gao Xiang
> 
> 
> .
> 
