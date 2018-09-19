From: chao@kernel.org (Chao Yu)
Date: Wed, 19 Sep 2018 23:45:43 +0800
Subject: [PATCH 4/6] staging: erofs: cleanup
 `z_erofs_vle_normalaccess_readpages'
In-Reply-To: <fc0f977f-b1c3-41a9-a058-bca4261bf9ea@aol.com>
References: <1537336150-90604-1-git-send-email-gaoxiang25@huawei.com>
 <1537336150-90604-4-git-send-email-gaoxiang25@huawei.com>
 <1b38cbfe-70e0-1e6d-fa50-89b1fddeeb43@kernel.org>
 <fc0f977f-b1c3-41a9-a058-bca4261bf9ea@aol.com>
Message-ID: <37b566ea-273b-8d81-7428-06bd35d60092@kernel.org>

Hi Xiang,

On 2018/9/19 23:32, Gao Xiang wrote:
> Hi Chao,
> 
> On 2018/9/19 23:26, Chao Yu wrote:
>> Hi Xiang,
>>
>> On 2018/9/19 13:49, Gao Xiang wrote:
>>> This patch introduces `__should_decompress_synchronously' to
>>> cleanup `z_erofs_vle_normalaccess_readpages'.
>>>
>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>> ---
>>>  drivers/staging/erofs/internal.h  | 11 +++++++++++
>>>  drivers/staging/erofs/super.c     |  5 +++++
>>>  drivers/staging/erofs/unzip_vle.c | 20 ++++++--------------
>>>  3 files changed, 22 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
>>> index cfcc6db..c84eb97 100644
>>> --- a/drivers/staging/erofs/internal.h
>>> +++ b/drivers/staging/erofs/internal.h
>>> @@ -95,6 +95,9 @@ struct erofs_sb_info {
>>>  	/* the dedicated workstation for compression */
>>>  	struct radix_tree_root workstn_tree;
>>>  
>>> +	/* threshold for decompression synchronously */
>>> +	unsigned int max_sync_decompress_pages;
>>> +
>>>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
>>>  	struct inode *managed_cache;
>>>  #endif
>>> @@ -273,6 +276,14 @@ extern int erofs_try_to_free_cached_page(struct address_space *mapping,
>>>  	struct page *page);
>>>  #endif
>>>  
>>> +#define DEFAULT_MAX_SYNC_DECOMPRESS_PAGES	4
>>> +
>>> +static inline bool __should_decompress_synchronously(struct erofs_sb_info *sbi,
>>> +						     unsigned int nr)
>>> +{
>>> +	return nr <= sbi->max_sync_decompress_pages;
>> -		nr_pages < 4 /* sync */);
>>
>> There is a little bit changed except cleanup, IIUC, would it be any difference
>> of performance around boundary of four pages?
> 
> No.. Once synchronous decompression is applied for 1,2,3 pages for no special reasons.
> But I think it could be better to adjust it to the power of two --- 1,2,3,4 is preferred.
> Since I have no idea to measure which is better or what value is best for all platform or use cases...
> 
> Therefore I tune it in this patch since I don't like the number
> DEFAULT_MAX_SYNC_DECOMPRESS_PAGES == 3 ...

Yeah, how about adding one more patch to tune this magic number first? as that
change would not be part of cleanup thing. I guess later maybe we could export a
sysfs node to provider tuning ability on that threshold.

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>>
>> Thanks,
>>
