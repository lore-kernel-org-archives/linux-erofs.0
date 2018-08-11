From: chao@kernel.org (Chao Yu)
Date: Sat, 11 Aug 2018 22:32:37 +0800
Subject: [PREVIEW] [PATCH v3 05/10] staging: erofs: fix integer overflow
 on 32-bit platform
In-Reply-To: <1533931838-47642-5-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
 <1533931838-47642-5-git-send-email-gaoxiang25@huawei.com>
Message-ID: <adc75c51-5c3e-2910-efd0-8fe97710dcdb@kernel.org>

On 2018/8/11 4:10, Gao Xiang wrote:
> This patch fixes integer overflow on multiplication
> of 32-bit lcn in z_erofs_map_blocks_iter.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
