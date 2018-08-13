From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 13 Aug 2018 20:37:09 +0800
Subject: [PATCH 4/8] staging: erofs: cleanup z_erofs_vle_work_{lookup,
 register}
In-Reply-To: <20180813120057.6grkpue6h7dtmpt2@mwanda>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-5-chao@kernel.org>
 <20180813120057.6grkpue6h7dtmpt2@mwanda>
Message-ID: <f162748e-cc02-8578-2a0b-af16d982e0b3@huawei.com>

Hi Dan,

On 2018/8/13 20:00, Dan Carpenter wrote:
> On Sun, Aug 12, 2018@10:01:46PM +0800, Chao Yu wrote:
>> From: Gao Xiang <gaoxiang25 at huawei.com>
>>
>> This patch introduces 'struct z_erofs_vle_work_finder' to clean up
>> arguments of z_erofs_vle_work_lookup and z_erofs_vle_work_register.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
>> ---
>>  drivers/staging/erofs/unzip_vle.c | 89 ++++++++++++++++---------------
>>  1 file changed, 47 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
>> index b2e05e2b4116..5032b3b05de1 100644
>> --- a/drivers/staging/erofs/unzip_vle.c
>> +++ b/drivers/staging/erofs/unzip_vle.c
>> @@ -271,36 +271,42 @@ static inline bool try_to_claim_workgroup(
>>  	return true;	/* lucky, I am the followee :) */
>>  }
>>  
>> +struct z_erofs_vle_work_finder {
>> +	struct super_block *sb;
>> +	pgoff_t idx;
>> +	unsigned pageofs;
>> +
>> +	struct z_erofs_vle_workgroup **grp_ret;
>> +	enum z_erofs_vle_work_role *role;
>> +	z_erofs_vle_owned_workgrp_t *owned_head;
>> +	bool *hosted;
>> +};
>> +
>>  static struct z_erofs_vle_work *
>> -z_erofs_vle_work_lookup(struct super_block *sb,
>> -			pgoff_t idx, unsigned pageofs,
>> -			struct z_erofs_vle_workgroup **grp_ret,
>> -			enum z_erofs_vle_work_role *role,
>> -			z_erofs_vle_owned_workgrp_t *owned_head,
>> -			bool *hosted)
>> +z_erofs_vle_work_lookup(const struct z_erofs_vle_work_finder *f)
>>  {
>>  	bool tag, primary;
>>  	struct erofs_workgroup *egrp;
>>  	struct z_erofs_vle_workgroup *grp;
>>  	struct z_erofs_vle_work *work;
>>  
>> -	egrp = erofs_find_workgroup(sb, idx, &tag);
>> +	egrp = erofs_find_workgroup(f->sb, f->idx, &tag);
>>  	if (egrp == NULL) {
>> -		*grp_ret = NULL;
>> +		*f->grp_ret = NULL;
> 
> All these pointers to pointer seem a bit messy.  Just do this:
> 
> 	struct z_erofs_vle_workgroup *grp;
> 
> Then replace "grp" in z_erofs_vle_work_iter_begin() with finder.grp;
> 

I wrote this because I am not sure of all compiler behaviors.

Notice that the struct `struct z_erofs_vle_work_finder' has been all marked as const.

If I use `struct z_erofs_vle_workgroup *grp;' and drop the `const' decorator,
compilers could do some re-read operations bacause its value could potentially change by its caller at the same time.

Thanks,
Gao Xiang

> regards,
> dan carpenter
> 
