From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 28 May 2019 11:28:37 +0800
Subject: [PATCH v3 2/2] staging: erofs: fix i_blocks calculation
In-Reply-To: <20190528031943.239665-2-gaoxiang25@huawei.com>
References: <20190528023147.94117-2-gaoxiang25@huawei.com>
 <20190528031943.239665-1-gaoxiang25@huawei.com>
 <20190528031943.239665-2-gaoxiang25@huawei.com>
Message-ID: <acaed8f7-1449-6509-d7c3-a9e106305224@huawei.com>

On 2019/5/28 11:19, Gao Xiang wrote:
> For compressed files, i_blocks should not be calculated
> by using i_size. use i_u.compressed_blocks instead.
> 
> In addition, i_blocks was miscalculated for non-compressed
> files previously, fix it as well.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
