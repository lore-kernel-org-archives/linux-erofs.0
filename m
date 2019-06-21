From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 21 Jun 2019 17:51:31 +0800
Subject: [PATCH v2 7/8] staging: erofs: switch to new decompression backend
In-Reply-To: <20190620160719.240682-8-gaoxiang25@huawei.com>
References: <20190620160719.240682-1-gaoxiang25@huawei.com>
 <20190620160719.240682-8-gaoxiang25@huawei.com>
Message-ID: <3ec4299a-5b3b-501c-2130-ef082852e8b2@huawei.com>

On 2019/6/21 0:07, Gao Xiang wrote:
> This patch integrates new decompression framework to
> erofs decompression path, and remove the old
> decompression implementation as well.
> 
> On kirin980 platform, sequential read is slightly
> improved to 778MiB/s after the new decompression
> backend is used.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
