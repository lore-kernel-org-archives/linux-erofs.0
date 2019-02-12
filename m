From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 12 Feb 2019 12:32:52 +0800
Subject: [PATCH 2/2] staging: erofs: remove redundant unlikely annotation
 in unzip_vle.c
In-Reply-To: <20190212032423.14637-2-cgxu519@gmx.com>
References: <20190212032423.14637-1-cgxu519@gmx.com>
 <20190212032423.14637-2-cgxu519@gmx.com>
Message-ID: <7759182a-71ba-ab1b-da0b-297bd304e565@aol.com>


On 2019/2/12 11:24, Chengguang Xu wrote:
> unlikely has already included in IS_ERR(),
> so just remove it.
>
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>


Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>


Thanks,

Gao Xiang
