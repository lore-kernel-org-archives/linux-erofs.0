From: chao@kernel.org (Chao Yu)
Date: Thu, 6 Dec 2018 23:31:27 +0800
Subject: [PATCH chao/erofs-dev 4/7] staging: erofs: revisit page
 submission flow
In-Reply-To: <20181201183211.27406-4-gaoxiang25@huawei.com>
References: <20181201183211.27406-1-gaoxiang25@huawei.com>
 <20181201183211.27406-4-gaoxiang25@huawei.com>
Message-ID: <49fa2861-bedb-46b2-008a-11d89306fa6d@kernel.org>

On 2018-12-2 2:32, Gao Xiang wrote:
> Previously, the submission flow works with cached compressed pages
> reclaim path in a tricky way, and it could be buggy if the reclaim
> path changes later without such tricky restrictions. For example,
> currently one PagePrivate(page) is evaluated without taking page
> lock (it only follows a wait_for_page_locked which closes such race)
> and no handling solves the potential page truncation case.
> 
> In addition, it's also full of #ifdefs in the function, which
> is hard to understand and maintain. this patch fixes them all.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
