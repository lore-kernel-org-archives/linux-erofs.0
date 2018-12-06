From: chao@kernel.org (Chao Yu)
Date: Thu, 6 Dec 2018 23:36:23 +0800
Subject: [PATCH chao/erofs-dev 5/7] staging: erofs: refine compressed
 pages preloading flow
In-Reply-To: <20181201183211.27406-5-gaoxiang25@huawei.com>
References: <20181201183211.27406-1-gaoxiang25@huawei.com>
 <20181201183211.27406-5-gaoxiang25@huawei.com>
Message-ID: <c918c23f-5b12-eb6a-574c-735030bd3d06@kernel.org>

On 2018-12-2 2:32, Gao Xiang wrote:
> Currently, there are two kinds of compressed pages in erofs:
>   1) file pages for the in-place decompression and
>   2) managed pages for cached decompression.
> Both are all stored in grp->compressed_page[].
> 
> For managed pages, they could already exist or could be preloaded
> in this round, including the following cases in detail:
>   1) Already valid (loaded in some previous round);
>   2) PAGE_UNALLOCATED, should be allocated at the time of submission;
>   3) Just found in the managed cache, and with an extra page ref.
> Currently, 1) and 3) can be distinguishable by lock_page and
> checking its PG_private, which is guaranteed by the reclaim path,
> but it's better to make a double check by using an extra tag.
> 
> This patch reworks the preloading flow by introducing such a tag
> by using tagged pointer, too many #ifdefs are removed as well.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
