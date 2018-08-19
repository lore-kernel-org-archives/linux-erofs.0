From: chao@kernel.org (Chao Yu)
Date: Sun, 19 Aug 2018 21:51:36 +0800
Subject: [PREVIEW] [PATCH v3 07/10] staging: erofs: clean up
 z_erofs_map_blocks_iter
In-Reply-To: <1533931838-47642-7-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
 <1533931838-47642-7-git-send-email-gaoxiang25@huawei.com>
Message-ID: <74e26a17-90c8-5630-f4f4-f9ef52888d63@kernel.org>

On 2018/8/11 4:10, Gao Xiang wrote:
> This patch mainly introduces `vle_map_blocks_iter_ctx' to clean up
> z_erofs_map_blocks_iter and vle_get_logical_extent_head.
> 
> It changes the return value of `vle_get_logical_extent_head' to int
> for the later error handing. In addition, it also renames `pcn' to
> `pblk' since only `pblk' exists in erofs compression ondisk format.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
