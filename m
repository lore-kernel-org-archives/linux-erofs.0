From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 13 Feb 2019 14:36:33 +0800
Subject: [PATCH 2/2] staging: erofs: remove redundant unlikely annotation
 in unzip_vle.c
In-Reply-To: <20190212032423.14637-2-cgxu519@gmx.com>
References: <20190212032423.14637-1-cgxu519@gmx.com>
 <20190212032423.14637-2-cgxu519@gmx.com>
Message-ID: <333a15d7-3b8e-412b-34f6-a30010d36f4f@huawei.com>

On 2019/2/12 11:24, Chengguang Xu wrote:
> unlikely has already included in IS_ERR(),
> so just remove it.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

It looks like we don't need to send two patch to fix two similar
issues, if you can merge them, it will be better.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
