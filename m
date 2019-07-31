From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 31 Jul 2019 17:23:57 +0800
Subject: [PATCH 18/22] staging: erofs: turn cache strategies into mount
 options
In-Reply-To: <20190729065159.62378-19-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-19-gaoxiang25@huawei.com>
Message-ID: <b5186ece-53c4-a1c9-98c1-f3b39d9bc607@huawei.com>

On 2019/7/29 14:51, Gao Xiang wrote:
> Kill all kconfig cache strategies and turn them into mount options
> "cache_strategy={disable|readahead|readaround}".
> 
> As the first step, cached pages can still be usable after cache
> is disabled by remounting, and these pages will be fallen out
> over time, which can be refined in the later version if some
> requirement is needed. Update related document as well.
> 
> Suggested-by: Theodore Ts'o <tytso at mit.edu>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
