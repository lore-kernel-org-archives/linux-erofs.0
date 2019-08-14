From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 14 Aug 2019 09:56:09 +0800
Subject: [PATCH] staging: erofs: removing an extra call to iloc() in
 fill_inode()
In-Reply-To: <20190814015944.GA11254@138>
References: <20190813203840.13782-1-pratikshinde320@gmail.com>
 <20190814015944.GA11254@138>
Message-ID: <418907b6-0b6b-3b08-c6fd-939a206f061f@huawei.com>

On 2019/8/14 9:59, Gao Xiang wrote:
> Hi Pratik,
> 
> On Wed, Aug 14, 2019@02:08:40AM +0530, Pratik Shinde wrote:
>> in fill_inode() we call iloc() twice.Avoiding the extra call by
>> storing the result.
>>
>> Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
> 
> I have no objection of this patch, but I'd like to
> hear Chao/Greg's idea about this...

It looks more clean. :)

Nitpick, maybe change 'inode_loc' to shorter 'iloc' will be better.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>> ---
>>  drivers/staging/erofs/inode.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
>> index 4c3d8bf..d82ba6c 100644
>> --- a/drivers/staging/erofs/inode.c
>> +++ b/drivers/staging/erofs/inode.c
>> @@ -167,11 +167,12 @@ static int fill_inode(struct inode *inode, int isdir)
>>  	int err;
>>  	erofs_blk_t blkaddr;
>>  	unsigned int ofs;
>> +	erofs_off_t inode_loc;
>>  
>>  	trace_erofs_fill_inode(inode, isdir);
>> -
>> -	blkaddr = erofs_blknr(iloc(sbi, vi->nid));
>> -	ofs = erofs_blkoff(iloc(sbi, vi->nid));
>> +	inode_loc = iloc(sbi, vi->nid);
>> +	blkaddr = erofs_blknr(inode_loc);
>> +	ofs = erofs_blkoff(inode_loc);
>>  
>>  	debugln("%s, reading inode nid %llu at %u of blkaddr %u",
>>  		__func__, vi->nid, ofs, blkaddr);
>> -- 
>> 2.9.3
>>
> .
> 
