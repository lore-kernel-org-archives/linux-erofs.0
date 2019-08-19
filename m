From: chao@kernel.org (Chao Yu)
Date: Mon, 19 Aug 2019 22:40:51 +0800
Subject: [PATCH 3/6] staging: erofs: add two missing erofs_workgroup_put
 for corrupted images
In-Reply-To: <20190819103426.87579-4-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-4-gaoxiang25@huawei.com>
Message-ID: <0d2a443b-3d06-014f-aa0b-7ca261a2437f@kernel.org>

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, these error handling
> path will be entered to handle corrupted images.
> 
> Lack of erofs_workgroup_puts will cause unmounting
> unsuccessfully.
> 
> Fix these return values to EFSCORRUPTED as well.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
