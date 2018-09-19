From: chao@kernel.org (Chao Yu)
Date: Wed, 19 Sep 2018 23:28:04 +0800
Subject: [PATCH 6/6] staging: erofs: simplify return value of
 `xattr_foreach'
In-Reply-To: <1537336150-90604-6-git-send-email-gaoxiang25@huawei.com>
References: <1537336150-90604-1-git-send-email-gaoxiang25@huawei.com>
 <1537336150-90604-6-git-send-email-gaoxiang25@huawei.com>
Message-ID: <fe0aa71b-a46a-8e04-f3bb-d21a75d04dd3@kernel.org>

On 2018/9/19 13:49, Gao Xiang wrote:
> As Dan Carpenter pointed out, there is no need to propagate positive
> return values back to its callers.
> 
> Suggested-by: Dan Carpenter <dan.carpenter at oracle.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
