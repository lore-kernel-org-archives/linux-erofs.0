From: chao@kernel.org (Chao Yu)
Date: Sat, 11 Aug 2018 22:31:00 +0800
Subject: [PATCH v3 04/10] staging: erofs: fix a missing endian conversion
In-Reply-To: <1533931838-47642-4-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
 <1533931838-47642-4-git-send-email-gaoxiang25@huawei.com>
Message-ID: <fb551278-5e36-8a3c-e35b-6ffa2112cfd6@kernel.org>

On 2018/8/11 4:10, Gao Xiang wrote:
> This patch fixes a missing endian conversion in
> vle_get_logical_extent_head.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
