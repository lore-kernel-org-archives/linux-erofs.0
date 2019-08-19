From: chao@kernel.org (Chao Yu)
Date: Mon, 19 Aug 2019 22:36:19 +0800
Subject: [PATCH 1/6] staging: erofs: some compressed cluster should be
 submitted for corrupted images
In-Reply-To: <20190819103426.87579-2-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-2-gaoxiang25@huawei.com>
Message-ID: <6fd4d968-86f3-71bd-41de-2e2d3b61b1dc@kernel.org>

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs_utils fuzzer, a logical page can belong
> to at most 2 compressed clusters, if one compressed cluster
> is corrupted, but the other has been ready in submitting chain.
> 
> The chain needs to submit anyway in order to keep the page
> working properly (page unlocked with PG_error set, PG_uptodate
> not set).
> 
> Let's fix it now.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
