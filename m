From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 21 Jun 2019 17:51:47 +0800
Subject: [PATCH v2 8/8] staging: erofs: integrate decompression inplace
In-Reply-To: <20190620160719.240682-9-gaoxiang25@huawei.com>
References: <20190620160719.240682-1-gaoxiang25@huawei.com>
 <20190620160719.240682-9-gaoxiang25@huawei.com>
Message-ID: <6ee41579-dcfd-02f5-dfb4-0c7a9173f370@huawei.com>

On 2019/6/21 0:07, Gao Xiang wrote:
> Decompressor needs to know whether it's a partial
> or full decompression since only full decompression
> can be decompressed in-place.
> 
> On kirin980 platform, sequential read is finally
> increased to 812MiB/s after decompression inplace
> is enabled.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
