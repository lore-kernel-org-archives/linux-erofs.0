From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 12 Feb 2019 12:31:53 +0800
Subject: [PATCH 1/2] staging: erofs: remove redundant likely/unlikely
 annotation in namei.c
In-Reply-To: <20190212032423.14637-1-cgxu519@gmx.com>
References: <20190212032423.14637-1-cgxu519@gmx.com>
Message-ID: <627cbe81-12b2-9f81-b989-76b82f393b41@aol.com>


On 2019/2/12 11:24, Chengguang Xu wrote:
> unlikely has already included in IS_ERR(),
> so just remove redundant likely/unlikely
> annotation.
>
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

Thanks for the correction, and happy new lunar year :)

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>


Thanks,

Gao Xiang
