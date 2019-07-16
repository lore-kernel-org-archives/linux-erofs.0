From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 16 Jul 2019 17:35:16 +0800
Subject: [PATCH] staging: erofs: avoid opened loop codes
In-Reply-To: <8f84339b-9300-df41-7d95-bfb344d9c4f3@huawei.com>
References: <20190716085259.103481-1-yuchao0@huawei.com>
 <55609788-6615-72e1-78cc-9eadadce68a7@huawei.com>
 <8f84339b-9300-df41-7d95-bfb344d9c4f3@huawei.com>
Message-ID: <6a5175b2-5e25-4942-8030-b229cd33a89b@huawei.com>



On 2019/7/16 17:27, Chao Yu wrote:
> Hi Xiang,
> 
> On 2019/7/16 17:12, Gao Xiang wrote:
>> Hi Chao,
>>
>> On 2019/7/16 16:52, Chao Yu wrote:
>>> Use __GFP_NOFAIL to avoid opened loop codes in z_erofs_vle_unzip().
>>>
>>> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
>>> ---
>>>  drivers/staging/erofs/unzip_vle.c | 17 ++++++++---------
>>>  1 file changed, 8 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
>>> index f0dab81ff816..3a0dbcb8cc9f 100644
>>> --- a/drivers/staging/erofs/unzip_vle.c
>>> +++ b/drivers/staging/erofs/unzip_vle.c
>>> @@ -921,18 +921,17 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>>>  		 mutex_trylock(&z_pagemap_global_lock))
>>>  		pages = z_pagemap_global;
>>>  	else {
>>> -repeat:
>>> -		pages = kvmalloc_array(nr_pages, sizeof(struct page *),
>>> -				       GFP_KERNEL);
>>> +		gfp_t flags = GFP_KERNEL;
>>> +
>>> +		if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
>>> +			flags |= __GFP_NOFAIL;
>>> +
>>> +		pages = kvmalloc_array(nr_pages, sizeof(struct page *), flags);
>>
>> How about omitting variable `flags' since it's only used once, or
>> rename it since `flags' is too general?  some thoughts?
> 
> That's minor thing, if you do care about this, I guess 'gfp_flags' maybe?

Be better, I prefer to omitting this variable, gfp_flags looks good as well.

> 
>>
>> BTW, This piece of code has been changed in
>> "[PATCH v2 00/24] erofs: promote erofs from staging", I will sync the code
>> after some guys takes a look at v2....
> 
> We have enough time to merge modified staging codes to generic fs one till next
> merge window, so don't worry, you can do the merge in batch.

Yes, you are right. Actually I am not too worry about the staging merges but
how to catch Viro's eye (sigh...)...

Thanks,
Gao Xiang

> 
> Thanks,
> 
>>
>> Thanks,
>> Gao Xiang
>>
>>>  
>>>  		/* fallback to global pagemap for the lowmem scenario */
>>>  		if (unlikely(!pages)) {
>>> -			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
>>> -				goto repeat;
>>> -			else {
>>> -				mutex_lock(&z_pagemap_global_lock);
>>> -				pages = z_pagemap_global;
>>> -			}
>>> +			mutex_lock(&z_pagemap_global_lock);
>>> +			pages = z_pagemap_global;
>>>  		}
>>>  	}
>>>  
>>>
>> .
>>
