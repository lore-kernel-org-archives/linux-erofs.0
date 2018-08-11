From: chao@kernel.org (Chao Yu)
Date: Sat, 11 Aug 2018 22:18:36 +0800
Subject: [PATCH v2 03/10] staging: erofs: fix
 vle_decompressed_index_clusterofs
In-Reply-To: <1533931838-47642-3-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
 <1533931838-47642-3-git-send-email-gaoxiang25@huawei.com>
Message-ID: <d950708c-0130-6285-316c-5858980ff0c7@kernel.org>

On 2018/8/11 4:10, Gao Xiang wrote:
> This patch adds error handing code, and fixes a missing
> endian conversion in vle_decompressed_index_clusterofs.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
