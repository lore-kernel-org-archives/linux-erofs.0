From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 10 Aug 2018 14:45:03 +0800
Subject: [WIP] [PATCH v2] staging: erofs: cleanup z_erofs_map_blocks_iter
In-Reply-To: <1533809114-69253-1-git-send-email-gaoxiang25@huawei.com>
References: <1533733270-11912-1-git-send-email-gaoxiang25@huawei.com>
 <1533809114-69253-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <ef01c07b-e887-a188-8f4a-8f66f376a9d5@huawei.com>

On 2018/8/9 18:05, Gao Xiang wrote:
> This patch cleanups z_erofs_map_blocks_iter and
> vle_get_logical_extent_head, including adding
> error handing code and missing endian conversions.

Mostly, we don't change logic for cleanup patch, so how about separating this
patch into three one as you described in commit message? It will be easier for
reviewer to check the patch which has clear goal, also, if one of them has bug,
we can just revert that problematic one instead of one big patch includes all
change.

Thanks,
