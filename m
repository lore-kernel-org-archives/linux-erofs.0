From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 16 Jul 2019 17:27:20 +0800
Subject: [PATCH] staging: erofs: avoid opened loop codes
In-Reply-To: <55609788-6615-72e1-78cc-9eadadce68a7@huawei.com>
References: <20190716085259.103481-1-yuchao0@huawei.com>
 <55609788-6615-72e1-78cc-9eadadce68a7@huawei.com>
Message-ID: <8f84339b-9300-df41-7d95-bfb344d9c4f3@huawei.com>

Hi Xiang,

On 2019/7/16 17:12, Gao Xiang wrote:
> Hi Chao,
> 
> On 2019/7/16 16:52, Chao Yu wrote:
>> Use __GFP_NOFAIL to avoid opened loop codes in z_erofs_vle_unzip().
>>
>> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
>> ---
>>  drivers/staging/erofs/unzip_vle.c | 17 ++++++++---------
>>  1 file changed, 8 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
>> index f0dab81ff816..3a0dbcb8cc9f 100644
>> --- a/drivers/staging/erofs/unzip_vle.c
>> +++ b/drivers/staging/erofs/unzip_vle.c
>> @@ -921,18 +921,17 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>>  		 mutex_trylock(&z_pagemap_global_lock))
>>  		pages = z_pagemap_global;
>>  	else {
>> -repeat:
>> -		pages = kvmalloc_array(nr_pages, sizeof(struct page *),
>> -				       GFP_KERNEL);
>> +		gfp_t flags = GFP_KERNEL;
>> +
>> +		if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
>> +			flags |= __GFP_NOFAIL;
>> +
>> +		pages = kvmalloc_array(nr_pages, sizeof(struct page *), flags);
> 
> How about omitting variable `flags' since it's only used once, or
> rename it since `flags' is too general?  some thoughts?

That's minor thing, if you do care about this, I guess 'gfp_flags' maybe?

> 
> BTW, This piece of code has been changed in
> "[PATCH v2 00/24] erofs: promote erofs from staging", I will sync the code
> after some guys takes a look at v2....

We have enough time to merge modified staging codes to generic fs one till next
merge window, so don't worry, you can do the merge in batch.

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>>  
>>  		/* fallback to global pagemap for the lowmem scenario */
>>  		if (unlikely(!pages)) {
>> -			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
>> -				goto repeat;
>> -			else {
>> -				mutex_lock(&z_pagemap_global_lock);
>> -				pages = z_pagemap_global;
>> -			}
>> +			mutex_lock(&z_pagemap_global_lock);
>> +			pages = z_pagemap_global;
>>  		}
>>  	}
>>  
>>
> .
> 
