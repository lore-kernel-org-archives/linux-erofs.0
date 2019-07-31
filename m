From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 31 Jul 2019 15:03:34 +0800
Subject: [PATCH 07/22] staging: erofs: remove redundant #include
 "internal.h"
In-Reply-To: <20190729065159.62378-8-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-8-gaoxiang25@huawei.com>
Message-ID: <bae5fc5b-b2e1-0d74-6374-b1ae5835cbb9@huawei.com>

On 2019/7/29 14:51, Gao Xiang wrote:
> Because #include "internal.h" is included in xattr.h

I think it would be better to remove "internal.h" in xattr.h, and include them
both in .c file in where we need xattr definition.

Thanks,
