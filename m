From: chao@kernel.org (Chao Yu)
Date: Wed, 19 Sep 2018 23:07:02 +0800
Subject: [PATCH 1/6] staging: erofs: remove redundant
 CONFIG_EROFS_FS_XATTRs
In-Reply-To: <1537336150-90604-1-git-send-email-gaoxiang25@huawei.com>
References: <1537336150-90604-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <6f03b241-489e-e15b-cc51-1d72147ecf36@kernel.org>

On 2018/9/19 13:49, Gao Xiang wrote:
> some CONFIG_EROFS_FS_XATTR conditions were added because of
> the historial Linux kernel compatibility, which are unneeded now.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
