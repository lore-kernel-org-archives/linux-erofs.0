From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 10 Aug 2018 11:08:44 +0800
Subject: [PREVIEW] [PATCH RESEND 2/4] staging: erofs: introduce
 erofs_grab_bio
In-Reply-To: <b7502dde-7792-e33e-c84a-7254be511a52@huawei.com>
References: <1533103277-20856-2-git-send-email-gaoxiang25@huawei.com>
 <1533103459-21338-1-git-send-email-gaoxiang25@huawei.com>
 <f031cf2b-35c1-581b-e764-4f241c3114c9@huawei.com>
 <b7502dde-7792-e33e-c84a-7254be511a52@huawei.com>
Message-ID: <9162b8da-a914-689a-c20d-2b8d9530d4b7@huawei.com>

Hi Xiang,

On 2018/8/10 11:01, Gao Xiang wrote:
> Hi Chao,
> 
> On 2018/8/10 10:46, Chao Yu wrote:
>> On 2018/8/1 14:04, Gao Xiang wrote:
>>> this patch renames prepare_bio to erofs_grab_bio, and
>>> adds a nofail option in order to retry in the bio allocator.
>>>
>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>> ---
>>>  drivers/staging/erofs/data.c      | 12 ++++++++++--
>>>  drivers/staging/erofs/internal.h  | 35 +++++++++++++++++------------------
>>>  drivers/staging/erofs/unzip_vle.c |  4 ++--
>>>  3 files changed, 29 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
>>> index ac263a1..2426eda 100644
>>> --- a/drivers/staging/erofs/data.c
>>> +++ b/drivers/staging/erofs/data.c
>>> @@ -60,7 +60,8 @@ struct page *erofs_get_meta_page(struct super_block *sb,
>>>  		struct bio *bio;
>>>  		int err;
>>>  
>>> -		bio = prepare_bio(sb, blkaddr, 1, read_endio);
>>> +		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, true);
>>> +
>>>  		err = bio_add_page(bio, page, PAGE_SIZE, 0);
>>>  		BUG_ON(err != PAGE_SIZE);
>>>  
>>> @@ -278,7 +279,14 @@ static inline struct bio *erofs_read_raw_page(
>>>  		if (nblocks > BIO_MAX_PAGES)
>>>  			nblocks = BIO_MAX_PAGES;
>>>  
>>> -		bio = prepare_bio(inode->i_sb, blknr, nblocks, read_endio);
>>> +		bio = erofs_grab_bio(inode->i_sb,
>>> +			blknr, nblocks, read_endio, false);
>>> +
>>> +		if (unlikely(IS_ERR(bio))) {
>>> +			err = PTR_ERR(bio);
>>> +			bio = NULL;
>>> +			goto err_out;
>>> +		}
>>>  	}
>>>  
>>>  	err = bio_add_page(bio, page, PAGE_SIZE, 0);
>>> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
>>> index 4518729..acce2d6 100644
>>> --- a/drivers/staging/erofs/internal.h
>>> +++ b/drivers/staging/erofs/internal.h
>>> @@ -419,26 +419,25 @@ struct erofs_map_blocks {
>>>  #define EROFS_GET_BLOCKS_RAW    0x0001
>>>  
>>>  /* data.c */
>>> -static inline struct bio *prepare_bio(
>>> -	struct super_block *sb,
>>> -	erofs_blk_t blkaddr, unsigned nr_pages,
>>> -	bio_end_io_t endio)
>>> +static inline struct bio *
>>> +erofs_grab_bio(struct super_block *sb,
>>> +	       erofs_blk_t blkaddr, unsigned nr_pages,
>>> +	       bio_end_io_t endio, bool nofail)
>>>  {
>>> -	gfp_t gfp = GFP_NOIO;
>>> -	struct bio *bio = bio_alloc(gfp, nr_pages);
>>> -
>>> -	if (unlikely(bio == NULL) &&
>>> -		(current->flags & PF_MEMALLOC)) {
>>> -		do {
>>> -			nr_pages /= 2;
>>> -			if (unlikely(!nr_pages)) {
>>> -				bio = bio_alloc(gfp | __GFP_NOFAIL, 1);
>>> -				BUG_ON(bio == NULL);
>>> -				break;
>>> +	const gfp_t gfp = GFP_NOIO;
>>> +	struct bio *bio;
>>> +
>>> +	do {
>>> +		if (nr_pages == 1) {
>>> +			bio = bio_alloc(gfp | (nofail ? __GFP_NOFAIL : 0), 1);
>>> +			if (unlikely(bio == NULL)) {
>>> +				DBG_BUGON(nofail);
>>> +				return ERR_PTR(-ENOMEM);
>>>  			}
>>> -			bio = bio_alloc(gfp, nr_pages);
>>> -		} while (bio == NULL);
>>> -	}
>>> +		}
>>> +		bio = bio_alloc(gfp, nr_pages);
>>
>> Need to cover this bio_alloc, so should initialize gfp as:
>>
>> gfp_t gfp = GFP_NOIO | (nofail ? __GFP_NOFAIL : 0);
>>
>> Thanks,
> This patch means if bio = bio_alloc(gfp, nr_pages); fails, try to bio_alloc with nr_pages/2, nr_page/4... until 1...
> and tag __GFP_NOFAIL with 1...

Correct, it's okay to me, thanks for explanation. ;)

Thanks,

> 
> As you said offline, there is another bug :-(, let me send the next patch...
> 
> Thanks,
> Gao Xiang
> 
> .
> 
