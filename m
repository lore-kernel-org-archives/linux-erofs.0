From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 21 Jun 2019 16:04:47 +0800
Subject: [PATCH v2 4/8] staging: erofs: move stagingpage operations to
 compress.h
In-Reply-To: <20190620160719.240682-5-gaoxiang25@huawei.com>
References: <20190620160719.240682-1-gaoxiang25@huawei.com>
 <20190620160719.240682-5-gaoxiang25@huawei.com>
Message-ID: <b1e06903-98de-42a8-8736-bd20293fce5a@huawei.com>

On 2019/6/21 0:07, Gao Xiang wrote:
> stagingpages are behaved as bounce pages for temporary use.
> Move to compress.h since the upcoming decompressor will
> allocate stagingpages as well.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
