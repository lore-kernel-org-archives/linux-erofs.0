From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 30 Jan 2019 22:57:23 +0800
Subject: [PATCH] staging: erofs: keep corrupted fs from crashing kernel in
 erofs_namei()
In-Reply-To: <20190130144534.GB2010@kadam>
References: <20190129155540.17473-1-gaoxiang25@huawei.com>
 <20190130144534.GB2010@kadam>
Message-ID: <6cc229c4-5ddf-74d3-36a7-27edee8efb44@huawei.com>

Hi Dan,

Thanks for your kindly review.

On 2019/1/30 22:45, Dan Carpenter wrote:
> On Tue, Jan 29, 2019@11:55:40PM +0800, Gao Xiang wrote:
>> +static struct page *find_target_block_classic(struct inode *dir,
>> +					      struct erofs_qstr *name,
>> +					      int *_diff,
>> +					      int *_ndirents)
>>  {
>>  	unsigned int startprfx, endprfx;
>> -	unsigned int head, back;
>> +	int head, back;
>>  	struct address_space *const mapping = dir->i_mapping;
>>  	struct page *candidate = ERR_PTR(-ENOENT);
>>  
>> @@ -105,33 +108,34 @@ static struct page *find_target_block_classic(
>>  	back = inode_datablocks(dir) - 1;
>>  
>>  	while (head <= back) {
>> -		unsigned int mid = head + (back - head) / 2;
>> +		const int mid = head + (back - head) / 2;
>>  		struct page *page = read_mapping_page(mapping, mid, NULL);
>>  
>> -		if (IS_ERR(page)) {
>> -exact_out:
>> -			if (!IS_ERR(candidate)) /* valid candidate */
>> -				put_page(candidate);
>> -			return page;
>> -		} else {
>> -			int diff;
>> -			unsigned int ndirents, matched;
>> -			struct qstr dname;
>> +		if (!IS_ERR(page)) {
> 
> It's almost always better to do failure handling instead of success
> handing because it lets you pull everything in one indent level.  You'd
> need to move a bunch of the declarations around.

I just want to leave definition and the initial assignment in one line...
>>  			struct erofs_dirent *de = kmap_atomic(page);
>> -			unsigned int nameoff = le16_to_cpu(de->nameoff);
>> -
>> -			ndirents = nameoff / sizeof(*de);
>> +			const int nameoff = nameoff_from_disk(de->nameoff,
>> +							      EROFS_BLKSIZ);
>> +			const int ndirents = nameoff / sizeof(*de);

or I have to 
		unsigned int mid = head + (back - head) / 2;
		const int mid = head + (back - head) / 2;
  		struct page *page = read_mapping_page(mapping, mid, NULL);
     		struct erofs_dirent *de;
		...
		int ndirents;

		if (IS_ERR(page)) {
			...
		}

		de = kmap_atomic(page);
		...
		ndirents = nameoff / sizeof(*de);

which takes extra lines...

> 
> 	if (IS_ERR(page))
> 		goto out;
> 
> But really the out label is not part of the loop so you could move it
> to the bottom of the function...

It seems that the out label is the part of loop...


> 
>>  			struct erofs_dirent *de = kmap_atomic(page);
>> -			unsigned int nameoff = le16_to_cpu(de->nameoff);
>> -
>> -			ndirents = nameoff / sizeof(*de);
>> +			const int nameoff = nameoff_from_disk(de->nameoff,
>> +							      EROFS_BLKSIZ);
>> +			const int ndirents = nameoff / sizeof(*de);
>> +			int diff;
>> +			unsigned int matched;
>> +			struct erofs_qstr dname;
>>  
>> -			/* corrupted dir (should have one entry at least) */
>> -			BUG_ON(!ndirents || nameoff > PAGE_SIZE);
>> +			if (unlikely(!ndirents)) {
>> +				DBG_BUGON(1);
>> +				put_page(page);
>> +				page = ERR_PTR(-EIO);
>> +				goto out;
> 
> We need to kunmap_atomic(de) on this path.

Thanks, will fix in the next version...

> 
>> +			}
>>  
>>  			matched = min(startprfx, endprfx);
>>  
>>  			dname.name = (u8 *)de + nameoff;
>> -			dname.len = ndirents == 1 ?
>> -				/* since the rest of the last page is 0 */
>> -				EROFS_BLKSIZ - nameoff
>> -				: le16_to_cpu(de[1].nameoff) - nameoff;
>> +			if (ndirents == 1)
>> +				dname.end = (u8 *)de + EROFS_BLKSIZ;
>> +			else
>> +				dname.end = (u8 *)de +
>> +					nameoff_from_disk(de[1].nameoff,
>> +							  EROFS_BLKSIZ);
>>  
>>  			/* string comparison without already matched prefix */
>>  			diff = dirnamecmp(name, &dname, &matched);
>> @@ -139,7 +143,7 @@ static struct page *find_target_block_classic(
>>  
>>  			if (unlikely(!diff)) {
>>  				*_diff = 0;
>> -				goto exact_out;
>> +				goto out;
>>  			} else if (diff > 0) {
>>  				head = mid + 1;
>>  				startprfx = matched;
>> @@ -147,35 +151,42 @@ static struct page *find_target_block_classic(
>>  				if (likely(!IS_ERR(candidate)))
>                                     ^^^^^^
> Not related to the this patch, but I wonder how this works.  IS_ERR()
> already has an opposite unlikely() inside so I wonder which trumps the
> other?

Yes, you are right. That is a remaining issue in the original code.
I will set up a clean up patch to fix that.

Thanks,
Gao Xiang

> 
>>  					put_page(candidate);
>>  				candidate = page;
>> +				*_ndirents = ndirents;
> 
> regards,
> dan carpenter
> 
