From: chao@kernel.org (Chao Yu)
Date: Thu, 6 Dec 2018 22:08:09 +0800
Subject: [PATCH chao/erofs-dev 3/7] staging: erofs: localize
 UNALLOCATED_CACHED_PAGE placeholder
In-Reply-To: <20181201183211.27406-3-gaoxiang25@huawei.com>
References: <20181201183211.27406-1-gaoxiang25@huawei.com>
 <20181201183211.27406-3-gaoxiang25@huawei.com>
Message-ID: <d99b3f94-4680-da70-eb79-aab42f9a3630@kernel.org>

On 2018-12-2 2:32, Gao Xiang wrote:
> In practice, in order to avoid in-place decompression for cached
> decompression and reuse pages from page_pool instead of allocation
> as much as possible, an unallocated placeholder was introduce to
> mark all in compressed_pages[] and they will be replaced at the time
> of submission.
> 
> Previously EROFS_UNALLOCATED_CACHED_PAGE was included in internal.h,
> which is unnecessary since it's only internally used in decompression
> subsystem, move it to unzip_vle.c and rename it to PAGE_UNALLOCATED.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
