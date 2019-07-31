From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 31 Jul 2019 14:44:49 +0800
Subject: [PATCH 03/22] staging: erofs: fix dummy functions erofs_{get,
 list}xattr
In-Reply-To: <20190729065159.62378-4-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-4-gaoxiang25@huawei.com>
Message-ID: <87729ec9-441b-673b-9821-212dc0c73cb1@huawei.com>

On 2019/7/29 14:51, Gao Xiang wrote:
> dummy functions erofs_{get,list}xattr should be inlined
> without xattr enabled.
> 
> Signed-off-by: Yue Hu <zbestahu at gmail.com>
> [ Gao Xiang : this patch was "staging: erofs: remove needless
>               dummy functions of erofs_{get,list}xattr. "]
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
