From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 20 Nov 2018 15:06:53 +0800
Subject: [PATCH chao/erofs-dev rebased v2 12/12] staging: erofs:
 decompress asynchronously if PG_readahead page at first
In-Reply-To: <20181114152919.38560-3-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152919.38560-1-gaoxiang25@huawei.com>
 <20181114152919.38560-3-gaoxiang25@huawei.com>
Message-ID: <e8513878-c466-9e06-5b18-e88a0f6575da@huawei.com>

On 2018/11/14 23:29, Gao Xiang wrote:
> For the case of nr_to_read == lookahead_size, it is better to
> decompress asynchronously as well since no page will be needed immediately.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
