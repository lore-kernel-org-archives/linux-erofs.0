From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 12 Dec 2018 20:29:47 +0800
Subject: [PATCH v2] staging:erofs: Fix alignment issues
In-Reply-To: <16a019d6-ccf0-b7a8-8d28-e2af9d0a76ef@huawei.com>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181212120053.16002-1-aaron.strahlberger@posteo.de>
 <16a019d6-ccf0-b7a8-8d28-e2af9d0a76ef@huawei.com>
Message-ID: <0213a94b-a0a4-e25d-434a-0f728d02ff20@huawei.com>


On 2018/12/12 20:11, Gao Xiang wrote:
> Hi Aaron,
> 
> On 2018/12/12 20:00, Aaron Strahlberger wrote:
>> Fix of `CHECK: Alignment should match open parenthesis` issues, reported by
>> checkpatch.pl
>>
>> Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
>> Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
>> Signed-off-by: Dominik Huber <domi250 at gmx.de>
>> ---
>>  drivers/staging/erofs/dir.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
>> index e44ca93dcdc6..e1955703ab8f 100644
>> --- a/drivers/staging/erofs/dir.c
>> +++ b/drivers/staging/erofs/dir.c
>> @@ -24,8 +24,8 @@ static const unsigned char erofs_filetype_table[EROFS_FT_MAX] = {
>>  };
>>  
>>  static int erofs_fill_dentries(struct dir_context *ctx,
>> -	void *dentry_blk, unsigned int *ofs,
>> -	unsigned int nameoff, unsigned int maxsize)
>> +			       void *dentry_blk, unsigned int *ofs,
>> +			       unsigned int nameoff, unsigned int maxsize)
>>  {
>>  	struct erofs_dirent *de = dentry_blk;
>>  	const struct erofs_dirent *end = dentry_blk + nameoff;
>> @@ -69,8 +69,8 @@ static int erofs_fill_dentries(struct dir_context *ctx,
>>  #endif
>>  
>>  		if (!dir_emit(ctx, de_name, de_namelen,
>> -					le64_to_cpu(de->nid), d_type))
>> -			/* stoped by some reason */
>> +			      le64_to_cpu(de->nid), d_type))
>> +			/* stopped by some reason */
> It seems Greg has merged part of your previous patch,
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/drivers/staging/erofs?h=staging-testing&id=019ec6c14fbdfaeb361c84f68158fb9097f41004
> 
> Anyway, I can locally apply it by 3-way merge, and it looks good to me apart from that
> 
> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> 

By the way, the subject line could be better as "staging: erofs: Fix alignment issues" rather than "staging:erofs: Fix alignment issues"

Thanks,
Gao Xiang

> Thanks,
> Gao Xiang
> 
