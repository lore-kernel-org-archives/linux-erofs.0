From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 28 May 2019 11:23:43 +0800
Subject: [PATCH v2 2/2] staging: erofs: fix i_blocks calculation
In-Reply-To: <fe0ff7bb-b576-f949-d57a-2892d116b22f@huawei.com>
References: <20190528023147.94117-2-gaoxiang25@huawei.com>
 <20190528023602.178923-1-gaoxiang25@huawei.com>
 <fe0ff7bb-b576-f949-d57a-2892d116b22f@huawei.com>
Message-ID: <c29b3979-03ea-22d7-642c-f54a680b349b@huawei.com>



On 2019/5/28 11:02, Chao Yu wrote:
> On 2019/5/28 10:36, Gao Xiang wrote:
>> For compressed files, i_blocks should not be calculated
>> by using i_size. i_u.compressed_blocks is used instead.
>>
>> In addition, i_blocks was miscalculated for non-compressed
>> files previously, fix it as well.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>> change log v2:
>>  - fix description in commit message
>>  - fix to 'inode->i_blocks = nblks << LOG_SECTORS_PER_BLOCK'
>>
>> Thanks,
>> Gao Xiang
>>
>>  drivers/staging/erofs/inode.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
>> index 8da144943ed6..6e67e018784e 100644
>> --- a/drivers/staging/erofs/inode.c
>> +++ b/drivers/staging/erofs/inode.c
>> @@ -20,6 +20,7 @@ static int read_inode(struct inode *inode, void *data)
>>  	struct erofs_vnode *vi = EROFS_V(inode);
>>  	struct erofs_inode_v1 *v1 = data;
>>  	const unsigned int advise = le16_to_cpu(v1->i_advise);
>> +	erofs_blk_t nblks = 0;
>>  
>>  	vi->data_mapping_mode = __inode_data_mapping(advise);
>>  
>> @@ -60,6 +61,10 @@ static int read_inode(struct inode *inode, void *data)
>>  			le32_to_cpu(v2->i_ctime_nsec);
>>  
>>  		inode->i_size = le64_to_cpu(v2->i_size);
>> +
>> +		/* total blocks for compressed files */
>> +		if (vi->data_mapping_mode == EROFS_INODE_LAYOUT_COMPRESSION)
>> +			nblks = v2->i_u.compressed_blocks;
> 
> Xiang,
> 
> It needs to use le32_to_cpu(). ;)

Already fixed in v3... Sorry about that...

Thanks,
Gao Xiang

> 
>>  	} else if (__inode_version(advise) == EROFS_INODE_LAYOUT_V1) {
>>  		struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
>>  
>> @@ -90,6 +95,8 @@ static int read_inode(struct inode *inode, void *data)
>>  			sbi->build_time_nsec;
>>  
>>  		inode->i_size = le32_to_cpu(v1->i_size);
>> +		if (vi->data_mapping_mode == EROFS_INODE_LAYOUT_COMPRESSION)
>> +			nblks = v1->i_u.compressed_blocks;
> 
> Ditto.
> 
> Thanks,
> 
>>  	} else {
>>  		errln("unsupported on-disk inode version %u of nid %llu",
>>  		      __inode_version(advise), vi->nid);
>> @@ -97,8 +104,11 @@ static int read_inode(struct inode *inode, void *data)
>>  		return -EIO;
>>  	}
>>  
>> -	/* measure inode.i_blocks as the generic filesystem */
>> -	inode->i_blocks = ((inode->i_size - 1) >> 9) + 1;
>> +	if (!nblks)
>> +		/* measure inode.i_blocks as generic filesystems */
>> +		inode->i_blocks = roundup(inode->i_size, EROFS_BLKSIZ) >> 9;
>> +	else
>> +		inode->i_blocks = nblks << LOG_SECTORS_PER_BLOCK;
>>  	return 0;
>>  }
>>  
>>
