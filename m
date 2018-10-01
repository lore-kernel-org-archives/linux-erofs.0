From: chao@kernel.org (Chao Yu)
Date: Mon, 1 Oct 2018 18:03:23 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 3/3] staging: erofs: managed
 pages could be locked at the time of decompression
In-Reply-To: <1537501415-70936-3-git-send-email-gaoxiang25@huawei.com>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
 <1537501415-70936-3-git-send-email-gaoxiang25@huawei.com>
Message-ID: <b61b3219-7de6-d26b-4139-544e2bb40235@kernel.org>

On 2018-9-21 11:43, Gao Xiang wrote:
> Managed compressed pages should be unlocked when IO ends by design.
> Therefore, these pages will be up-to-date and unlocked at the time
> of decompression in general.
> 
> However managed pages could be re-locked in some other paths, such as
> the reclaim path. Let's remove the related assertion in decompression.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
