From: chao@kernel.org (Chao Yu)
Date: Mon, 19 Aug 2019 22:50:18 +0800
Subject: [PATCH 4/6] staging: erofs: avoid loop in submit chains
In-Reply-To: <20190819103426.87579-5-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-5-gaoxiang25@huawei.com>
Message-ID: <24eacd62-3da1-e6cf-8166-43049dbedcf2@kernel.org>

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, 2 conditions
> can happen in corrupted images, which can cause
> unexpected behaviors.
>  - access the same pcluster one more time;
>  - access the tail end pcluster again, e.g.
>             _ access again (will trigger tail merging)
>            |
>      1 2 3 1 2             ->   1 2 3 1
>      |_ tail end of the chain    \___/ (unexpected behavior)
> Let's detect and avoid them now.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
