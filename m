From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 1 Aug 2018 14:10:04 +0800
Subject: [PREVIEW] [PATCH 1/4] staging: erofs: remove the unneeded marco
 in xattr submodule
In-Reply-To: <1533103277-20856-1-git-send-email-gaoxiang25@huawei.com>
References: <1533103277-20856-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <5af70e75-c6ab-fb8c-0680-d1e9b75fc211@huawei.com>

On 2018/8/1 14:01, Gao Xiang wrote:
> There is no need to '#if CONFIG_EROFS_FS_XATTR' in xattr.c,
> let's remove it.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
