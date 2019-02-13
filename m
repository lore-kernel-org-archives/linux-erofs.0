From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 13 Feb 2019 14:33:34 +0800
Subject: [PATCH 1/2] staging: erofs: remove redundant likely/unlikely
 annotation in namei.c
In-Reply-To: <20190212032423.14637-1-cgxu519@gmx.com>
References: <20190212032423.14637-1-cgxu519@gmx.com>
Message-ID: <171e24e3-972f-d6aa-5bde-6230b4d83094@huawei.com>

On 2019/2/12 11:24, Chengguang Xu wrote:
> unlikely has already included in IS_ERR(),
> so just remove redundant likely/unlikely
> annotation.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
