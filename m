From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 23 Jan 2019 21:46:08 +0800
Subject: [PATCH] staging: erofs: fix potential double iput in
 erofs_read_super()
In-Reply-To: <20190123061225.19860-1-cgxu519@gmx.com>
References: <20190123061225.19860-1-cgxu519@gmx.com>
Message-ID: <bcb14361-0cf4-7324-1cd3-3aee854d7c47@huawei.com>



On 2019/1/23 14:12, Chengguang Xu wrote:
> Some error cases like failing from d_make_root() will
> cause double iput because d_make_root() also does iput
> in its error path.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

Looks good to me :) I did some basic test as well,
and it seems fine.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang
