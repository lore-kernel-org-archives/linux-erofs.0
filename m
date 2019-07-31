From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 31 Jul 2019 14:46:06 +0800
Subject: [PATCH 04/22] staging: erofs: keep up erofs_fs.h with
 erofs-outofstaging patchset
In-Reply-To: <20190729065159.62378-5-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-5-gaoxiang25@huawei.com>
Message-ID: <f759fe7b-b89b-f76a-056f-68522892e550@huawei.com>

On 2019/7/29 14:51, Gao Xiang wrote:
> The main change is to reserve all checksums except for superblock,
> since it's more useful to do block-based verity for read-only fs.
> 
> Some comments change as well, which is minor.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
