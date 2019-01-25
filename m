From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 25 Jan 2019 21:58:31 +0800
Subject: [PATCH 1/2] staging: erofs: use xattr_prefix to wrap up
In-Reply-To: <20190125132614.GB1795@kadam>
References: <20190125115103.47250-1-gaoxiang25@huawei.com>
 <20190125132614.GB1795@kadam>
Message-ID: <52def699-7f59-04d8-9045-6f85db11111a@huawei.com>

Hi Dan,

On 2019/1/25 21:26, Dan Carpenter wrote:
> On Fri, Jan 25, 2019@07:51:03PM +0800, Gao Xiang wrote:
>> Let's use xattr_prefix instead of open code.
>> No logic changes.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>>  drivers/staging/erofs/xattr.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
>> index 1c9498e38f0e..eca65df46133 100644
>> --- a/drivers/staging/erofs/xattr.c
>> +++ b/drivers/staging/erofs/xattr.c
>> @@ -521,7 +521,7 @@ static int xattr_entrylist(struct xattr_iter *_it,
>>  		return 1;
>>  
>>  	/* Note that at least one of 'prefix' and 'name' should be non-NULL */
> 
> The comment is sort of confusing now.

OK, I will remove this line.

And I think I will send the whole patchset instead of this cleanup patch
only after I test the ACL feature and confirm that it works.

Sorry again about the [PATCH 2/2]...

Thanks,
Gao Xiang

> 
>> -	prefix = h->prefix != NULL ? h->prefix : h->name;
>> +	prefix = xattr_prefix(h);
>>  	prefix_len = strlen(prefix);
> 
> regards,
> dan carpenter
> 
