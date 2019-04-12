From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Fri, 12 Apr 2019 16:51:45 +0300
Subject: [PATCH v2] staging: erofs: fix unexpected out-of-bound data access
In-Reply-To: <20190412095314.224932-1-gaoxiang25@huawei.com>
References: <20190412095314.224932-1-gaoxiang25@huawei.com>
Message-ID: <20190412135145.GK6095@kadam>

On Fri, Apr 12, 2019@05:53:14PM +0800, Gao Xiang wrote:
> Unexpected out-of-bound data will be read in erofs_read_raw_page
> after commit 07173c3ec276 ("block: enable multipage bvecs") since
> one iovec could have multiple pages.
> 
> Let's fix as what Ming's pointed out in the previous email [1].
> 
> [1] https://lore.kernel.org/lkml/20190411080953.GE421 at ming.t460p/
> 

Please also use the Fixes tag.

Fixes: 07173c3ec276 ("block: enable multipage bvecs")

> Suggested-by: Ming Lei <ming.lei at redhat.com>
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

regards,
dan carpenter
