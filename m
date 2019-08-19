From: chao@kernel.org (Chao Yu)
Date: Mon, 19 Aug 2019 22:58:04 +0800
Subject: [PATCH 6/6] staging: erofs: avoid endless loop of invalid
 lookback distance 0
In-Reply-To: <20190819103426.87579-7-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-7-gaoxiang25@huawei.com>
Message-ID: <a8454de9-dbee-c69c-5763-1648df730211@kernel.org>

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, Lookback distance should
> be a positive number, so it should be actually looked back
> rather than spinning.
> 
> Fixes: 02827e1796b3 ("staging: erofs: add erofs_map_blocks_iter")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
