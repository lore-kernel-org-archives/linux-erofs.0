From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 16 Jul 2019 15:37:58 +0800
Subject: [PATCH] staging: erofs: support bmap
In-Reply-To: <67b812f6-618d-d390-66f0-7f5eaf2cb6ed@huawei.com>
References: <20190716070543.88863-1-yuchao0@huawei.com>
 <ed011d9f-6fdc-a8ee-8a18-c94875bbfa53@huawei.com>
 <67b812f6-618d-d390-66f0-7f5eaf2cb6ed@huawei.com>
Message-ID: <b744f9aa-782a-1f29-22da-8bce6ed566d5@huawei.com>



On 2019/7/16 15:35, Chao Yu wrote:
> Hi Xiang,
> 
> On 2019/7/16 15:19, Gao Xiang wrote:
>> Hi Chao,
>>
>> On 2019/7/16 15:05, Chao Yu wrote:
>>> Add erofs_bmap() to support FIBMAP ioctl on flatmode inode.
>>>
>>> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
>>> ---
>>>  drivers/staging/erofs/data.c | 29 +++++++++++++++++++++++++++++
>>>  1 file changed, 29 insertions(+)
>>>
>>> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
>>> index fbce71403d87..03da57f04347 100644
>>> --- a/drivers/staging/erofs/data.c
>>> +++ b/drivers/staging/erofs/data.c
>>> @@ -308,9 +308,38 @@ static int erofs_raw_access_readpages(struct file *filp,
>>>  	return iomap_readpages(mapping, pages, nr_pages, &erofs_iomap_ops);
>>>  }
>>>  
>>> +static int erofs_get_block(struct inode *inode, sector_t iblock,
>>> +			   struct buffer_head *bh, int create)
>>> +{
>>> +	struct erofs_map_blocks map = {
>>> +		.m_la = iblock << 9,
>>> +	};
>>> +	int err;
>>> +
>>> +	err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	if (map.m_flags & EROFS_MAP_MAPPED)
>>> +		bh->b_blocknr = erofs_blknr(map.m_pa);
>>> +
>>> +	return err;
>>> +}
>>> +
>>> +static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
>>> +{
>>> +	struct inode *inode = mapping->host;
>>> +
>>> +	if (is_inode_flat_inline(inode))
>>> +		return 0;
>>
>> could we support flat_inline as well? some difficulty on this?
> 
> I think we can support partial of this on inline inode, e.g.:
> 
> [0, 4k] mapped
> [4k, 5k] inline
> 
> We can find and return the physical block address for first block, but for last
> block locating in metadata, we should just return 0 (0 indicate bmap has failed
> to get mapped block address).

I think that is fine (in the long term, FIEMAP is preferred of course.)

Thanks,
Gao Xiang
