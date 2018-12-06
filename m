From: chao@kernel.org (Chao Yu)
Date: Thu, 6 Dec 2018 21:59:54 +0800
Subject: [PATCH chao/erofs-dev 2/7] staging: erofs: introduce MNGD_MAPPING
 helper
In-Reply-To: <20181201183211.27406-2-gaoxiang25@huawei.com>
References: <20181201183211.27406-1-gaoxiang25@huawei.com>
 <20181201183211.27406-2-gaoxiang25@huawei.com>
Message-ID: <18ceedb1-a97d-80e9-6eda-9533fe8d8434@kernel.org>

On 2018-12-2 2:32, Gao Xiang wrote:
> This patch introduces MNGD_MAPPING to wrap up
> sbi->managed_cache->i_mapping, which will be used
> to solve too many #ifdef in a single function.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
