From: chao@kernel.org (Chao Yu)
Date: Sun, 19 Aug 2018 21:52:14 +0800
Subject: [PREVIEW] [PATCH v2 09/10] staging: erofs: fix a bug when appling
 cache strategy
In-Reply-To: <1533931838-47642-9-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
 <1533931838-47642-9-git-send-email-gaoxiang25@huawei.com>
Message-ID: <331c2b16-bde9-2f18-5edc-bdc24a0a4933@kernel.org>

On 2018/8/11 4:10, Gao Xiang wrote:
> As described in Kconfig, the last compressed pack should be cached
> for further reading for either `EROFS_FS_ZIP_CACHE_UNIPOLAR' or
> `EROFS_FS_ZIP_CACHE_BIPOLAR' by design.
> 
> However, there is a bug in z_erofs_do_read_page, it will
> switch `initial' to `false' at the very beginning before it decides
> to cache the last compressed pack.
> 
> caching strategy should work properly after appling this patch.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
