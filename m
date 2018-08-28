From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 28 Aug 2018 09:18:35 +0800
Subject: [PREVIEW] [PATCH v2] Revert "staging: erofs: disable compiling
 temporarile"
In-Reply-To: <1535399776-10323-1-git-send-email-hsiangkao@aol.com>
References: <1535399496-10278-1-git-send-email-hsiangkao@aol.com>
 <1535399776-10323-1-git-send-email-hsiangkao@aol.com>
Message-ID: <427ddf7a-9c60-56c0-7889-275cea127ae5@huawei.com>

On 2018/8/28 3:56, Gao Xiang wrote:
> This reverts commit 156c3df8d4db4e693c062978186f44079413d74d
> 
> Because of XArray and the new mount apis aren't merged in 4.19 merge
> window, the BROKEN mark can be reverted directly without any problems.
> 
> Fixes: 156c3df8d4db ("staging: erofs: disable compiling temporarile")
> Signed-off-by: Gao Xiang <hsiangkao at aol.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
