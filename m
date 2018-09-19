From: chao@kernel.org (Chao Yu)
Date: Wed, 19 Sep 2018 23:14:09 +0800
Subject: [PATCH 2/6] staging: erofs: fold in `__update_workgrp_llen'
In-Reply-To: <1537336150-90604-2-git-send-email-gaoxiang25@huawei.com>
References: <1537336150-90604-1-git-send-email-gaoxiang25@huawei.com>
 <1537336150-90604-2-git-send-email-gaoxiang25@huawei.com>
Message-ID: <3c48456d-4770-eba2-9b54-c8a153dc1ad2@kernel.org>

On 2018/9/19 13:49, Gao Xiang wrote:
> There is the only one user to use `__update_workgrp_llen'.
> Fold it in `z_erofs_vle_work_iter_begin' and cleanup related code.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
