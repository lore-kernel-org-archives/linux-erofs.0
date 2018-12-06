From: chao@kernel.org (Chao Yu)
Date: Thu, 6 Dec 2018 23:39:17 +0800
Subject: [PATCH chao/erofs-dev 7/7] staging: erofs: simplify
 `z_erofs_vle_submit_all'
In-Reply-To: <20181201183211.27406-7-gaoxiang25@huawei.com>
References: <20181201183211.27406-1-gaoxiang25@huawei.com>
 <20181201183211.27406-7-gaoxiang25@huawei.com>
Message-ID: <006929bd-b8f5-d49e-783d-081531c03237@kernel.org>

On 2018-12-2 2:32, Gao Xiang wrote:
> Previously, there are too many hacked stuffs such as `__FSIO_1',
> `lstgrp_noio', `lstgrp_io' out there in `z_erofs_vle_submit_all'.
> 
> Revisit the whole process by properly introducing jobqueue to
> represent each type of queued workgroups, furthermore hide all of
> crazyness behind independent seperated functions. After this patch,
> 2 independent jobqueues exist if managed cache is enabled, or 1
> jobqueue if disabled.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
