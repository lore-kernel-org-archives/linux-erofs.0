From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 16 Jul 2019 15:19:45 +0800
Subject: [PATCH] staging: erofs: support bmap
In-Reply-To: <20190716070543.88863-1-yuchao0@huawei.com>
References: <20190716070543.88863-1-yuchao0@huawei.com>
Message-ID: <ed011d9f-6fdc-a8ee-8a18-c94875bbfa53@huawei.com>

Hi Chao,

On 2019/7/16 15:05, Chao Yu wrote:
> Add erofs_bmap() to support FIBMAP ioctl on flatmode inode.
> 
> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
> ---
>  drivers/staging/erofs/data.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index fbce71403d87..03da57f04347 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -308,9 +308,38 @@ static int erofs_raw_access_readpages(struct file *filp,
>  	return iomap_readpages(mapping, pages, nr_pages, &erofs_iomap_ops);
>  }
>  
> +static int erofs_get_block(struct inode *inode, sector_t iblock,
> +			   struct buffer_head *bh, int create)
> +{
> +	struct erofs_map_blocks map = {
> +		.m_la = iblock << 9,
> +	};
> +	int err;
> +
> +	err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
> +	if (err)
> +		return err;
> +
> +	if (map.m_flags & EROFS_MAP_MAPPED)
> +		bh->b_blocknr = erofs_blknr(map.m_pa);
> +
> +	return err;
> +}
> +
> +static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
> +{
> +	struct inode *inode = mapping->host;
> +
> +	if (is_inode_flat_inline(inode))
> +		return 0;

could we support flat_inline as well? some difficulty on this?
(I have no idea return 0 is suitable for us since we have tail-end packing...)

Thanks,
Gao Xiang

> +
> +	return generic_block_bmap(mapping, block, erofs_get_block);
> +}
> +
>  /* for uncompressed (aligned) files and raw access for other files */
>  const struct address_space_operations erofs_raw_access_aops = {
>  	.readpage = erofs_raw_access_readpage,
>  	.readpages = erofs_raw_access_readpages,
> +	.bmap = erofs_bmap,
>  };
>  
> 
