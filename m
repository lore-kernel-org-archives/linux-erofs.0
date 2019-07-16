From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 16 Jul 2019 17:23:10 +0800
Subject: [PATCH v2] staging: erofs: support bmap
In-Reply-To: <470cdf8c-b20c-5c38-59e5-977a2359af9d@huawei.com>
References: <20190716084625.102366-1-yuchao0@huawei.com>
 <470cdf8c-b20c-5c38-59e5-977a2359af9d@huawei.com>
Message-ID: <229d481a-1f4c-d39d-6dd3-f9a1f077d8a3@huawei.com>

Hi Xiang,

On 2019/7/16 17:01, Gao Xiang wrote:
> Hi Chao,
> 
> Cc lkml mailing list?

Oh, no problem, let me update my default cc list.

> 
> On 2019/7/16 16:46, Chao Yu wrote:
>> Add erofs_bmap() to support FIBMAP ioctl on flatmode inode.
>>
>> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
>> ---
>> v2:
>> - support mapping normal blocks for inline inode suggested by Xiang
>> - rebase to linux-next
>>  drivers/staging/erofs/data.c | 33 +++++++++++++++++++++++++++++++++
>>  1 file changed, 33 insertions(+)
>>
>> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
>> index cc31c3e5984c..5c7e3b9cff6a 100644
>> --- a/drivers/staging/erofs/data.c
>> +++ b/drivers/staging/erofs/data.c
>> @@ -392,9 +392,42 @@ static int erofs_raw_access_readpages(struct file *filp,
>>  	return 0;
>>  }
>>  
>> +static int erofs_get_block(struct inode *inode, sector_t iblock,
>> +			   struct buffer_head *bh, int create)
>> +{
>> +	struct erofs_map_blocks map = {
>> +		.m_la = iblock << 9,
>> +	};
>> +	int err;
>> +
>> +	err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
>> +	if (err)
>> +		return err;
>> +
>> +	if (map.m_flags & EROFS_MAP_MAPPED)
>> +		bh->b_blocknr = erofs_blknr(map.m_pa);
>> +
>> +	return err;
>> +}
>> +
>> +static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
>> +{
>> +	struct inode *inode = mapping->host;
>> +
>> +	if (is_inode_flat_inline(inode)) {
>> +		unsigned int blks = i_size_read(inode) >> LOG_BLOCK_SIZE;
> 
> maybe we could use erofs_blk_t ?

Okay,

> 
>> +
>> +		if (!blks || block >> LOG_SECTORS_PER_BLOCK >= blks)
> 
> Could the above line be simplified to block >> LOG_SECTORS_PER_BLOCK >= blks?

That's right, original one was trying to consider readability and avoid
calculation of following statement when blks equals to zero.

Anyway, either is okay to me.

> 
> Other parts looks good to me,
> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> 
> However, I think resend a new patch is better.

Yeah, let me send v3.

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>> +			return 0;
>> +	}
>> +
>> +	return generic_block_bmap(mapping, block, erofs_get_block);
>> +}
>> +
>>  /* for uncompressed (aligned) files and raw access for other files */
>>  const struct address_space_operations erofs_raw_access_aops = {
>>  	.readpage = erofs_raw_access_readpage,
>>  	.readpages = erofs_raw_access_readpages,
>> +	.bmap = erofs_bmap,
>>  };
>>  
>>
> .
> 
