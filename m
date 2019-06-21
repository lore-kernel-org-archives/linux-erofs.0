From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 21 Jun 2019 15:53:07 +0800
Subject: [PATCH v2 2/8] staging: erofs: add compacted compression indexes
 support
In-Reply-To: <20190620160719.240682-3-gaoxiang25@huawei.com>
References: <20190620160719.240682-1-gaoxiang25@huawei.com>
 <20190620160719.240682-3-gaoxiang25@huawei.com>
Message-ID: <4274208b-63bc-6dfd-a2c8-a94d2fa5c8d7@huawei.com>

On 2019/6/21 0:07, Gao Xiang wrote:
> This patch aims at compacted compression indexes:
>  1) cleanup z_erofs_map_blocks_iter and move into zmap.c;
>  2) add compacted 4/2B decoding support.
> 
> On kirin980 platform, sequential read is increased about
> 6% (725MiB/s -> 770MiB/s) on enwik9 dataset if compacted 2B
> feature is enabled.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

> +static int vle_legacy_load_cluster_from_disk(struct z_erofs_maprecorder *m,
> +					     unsigned long lcn)
> +{
> +	struct inode *const inode = m->inode;
> +	struct erofs_vnode *const vi = EROFS_V(inode);
> +	const erofs_off_t ibase = iloc(EROFS_I_SB(inode), vi->nid);
> +	const erofs_off_t pos = Z_EROFS_VLE_EXTENT_ALIGN(ibase +
> +							 vi->inode_isize +
> +							 vi->xattr_isize) +
> +		16 + lcn * sizeof(struct z_erofs_vle_decompressed_index);

use macro instead of raw number?

Thanks,
