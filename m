From: chao@kernel.org (Chao Yu)
Date: Wed, 19 Sep 2018 23:20:39 +0800
Subject: [PATCH 3/6] staging: erofs: drop multiref support temporarily
In-Reply-To: <1537336150-90604-3-git-send-email-gaoxiang25@huawei.com>
References: <1537336150-90604-1-git-send-email-gaoxiang25@huawei.com>
 <1537336150-90604-3-git-send-email-gaoxiang25@huawei.com>
Message-ID: <2c838085-2883-829d-08cd-1426721aa7bb@kernel.org>

On 2018/9/19 13:49, Gao Xiang wrote:
> Multiref support means that a compressed page could have
> more than one reference, which is designed for on-disk data
> deduplication. However, mkfs doesn't support this mode
> at this moment, and the kernel implementation is also broken.
> 
> Let's drop multiref support. If it is fully implemented
> in the future, it can be reverted later.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
