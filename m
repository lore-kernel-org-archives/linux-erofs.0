From: chao@kernel.org (Chao Yu)
Date: Thu, 6 Dec 2018 23:36:35 +0800
Subject: [PATCH chao/erofs-dev 6/7] staging: erofs: redefine where
 `owned_workgrp_t' points
In-Reply-To: <20181201183211.27406-6-gaoxiang25@huawei.com>
References: <20181201183211.27406-1-gaoxiang25@huawei.com>
 <20181201183211.27406-6-gaoxiang25@huawei.com>
Message-ID: <5b55ae34-d4b2-0b90-a202-3aae179aabee@kernel.org>

On 2018-12-2 2:32, Gao Xiang wrote:
> By design, workgroups are queued in the form of linked lists.
> 
> Previously, it points to the next `z_erofs_vle_workgroup', which
> isn't flexible enough to simplify `z_erofs_vle_submit_all' logic.
> 
> Let's fix it pointing to the next `owned_workgrp_t' and use
> container_of to get its coresponding `z_erofs_vle_workgroup'.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
