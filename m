From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 27 Feb 2019 20:42:59 +0800
Subject: [PATCH 3/3] staging: erofs: fix mis-acted TAIL merging behavior
In-Reply-To: <20190227053332.38504-3-gaoxiang25@huawei.com>
References: <20190227053332.38504-1-gaoxiang25@huawei.com>
 <20190227053332.38504-3-gaoxiang25@huawei.com>
Message-ID: <1d8b2544-5be1-bf48-70f3-5bd703c37040@huawei.com>

On 2019/2/27 13:33, Gao Xiang wrote:
> EROFS has an optimized path called TAIL merging, which is designed
> to merge multiple reads and the corresponding decompressions into
> one if these requests read continuous pages almost at the same time.
> 
> In general, it behaves as follows:
>  ________________________________________________________________
>   ... |  TAIL  .  HEAD  |  PAGE  |  PAGE  |  TAIL    . HEAD | ...
>  _____|_combined page A_|________|________|_combined page B_|____
>         1  ]  ->  [  2                          ]  ->  [ 3
> If the above three reads are requested in the order 1-2-3, it will
> generate a large work chain rather than 3 individual work chains
> to reduce scheduling overhead and boost up sequential read.
> 
> However, if Read 2 is processed slightly earlier than Read 1,
> currently it still generates 2 individual work chains (chain 1, 2)
> but it does in-place decompression for combined page A, moreover,
> if chain 2 decompresses ahead of chain 1, it will be a race and
> lead to corrupted decompressed page. This patch fixes it.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
