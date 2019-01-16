From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 16 Jan 2019 17:19:25 +0800
Subject: [PATCH 1/5] staging: erofs: sunset erofs_workstation_cleanup_all
In-Reply-To: <20190116085956.21004-1-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
Message-ID: <e18bcdbd-6768-dd8c-5be0-bf7f0387408e@huawei.com>

On 2019/1/16 16:59, Gao Xiang wrote:
> There is only one user calling erofs_workstation_cleanup_all,
> and it is no likely that more users will use in that way
> in the future.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
