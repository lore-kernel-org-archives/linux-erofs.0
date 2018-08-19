From: chao@kernel.org (Chao Yu)
Date: Sun, 19 Aug 2018 21:51:59 +0800
Subject: [PREVIEW] [PATCH v3 08/10] staging: erofs: complete error handing
 of z_erofs_map_blocks_iter
In-Reply-To: <1533931838-47642-8-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
 <1533931838-47642-8-git-send-email-gaoxiang25@huawei.com>
Message-ID: <0e1db00d-5b37-43ad-ff5e-7f96bfd4d4c7@kernel.org>

On 2018/8/11 4:10, Gao Xiang wrote:
> This patch completes error handing of z_erofs_map_blocks_iter
> and vle_get_logical_extent_head, including no memory and
> io error cases.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
