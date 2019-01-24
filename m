From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 24 Jan 2019 16:46:11 +0800
Subject: [PATCH] staging: erofs: fix potential double iput in
 erofs_read_super()
In-Reply-To: <20190123061225.19860-1-cgxu519@gmx.com>
References: <20190123061225.19860-1-cgxu519@gmx.com>
Message-ID: <5fe1db5b-d7ff-bc36-f485-4440e3c8ab9e@huawei.com>

On 2019/1/23 14:12, Chengguang Xu wrote:
> Some error cases like failing from d_make_root() will
> cause double iput because d_make_root() also does iput
> in its error path.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
