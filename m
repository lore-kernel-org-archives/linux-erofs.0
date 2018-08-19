From: chao@kernel.org (Chao Yu)
Date: Sun, 19 Aug 2018 21:53:44 +0800
Subject: [PREVIEW] [PATCH 1/4] staging: erofs: avoid magic constants when
 initializing clusterbits
In-Reply-To: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>
References: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <74d2a2ac-1d82-4424-8a61-7dad9782c5a3@kernel.org>

On 2018/8/11 11:09, Gao Xiang wrote:
> Currently erofs only supports clustersize == blocksize.
> and clustersize == 2^n * blocksize will be supported in the future.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
