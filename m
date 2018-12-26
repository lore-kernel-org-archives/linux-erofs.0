From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 26 Dec 2018 15:06:01 +0800
Subject: [PATCH] staging: erofs: fix return type of erofs_workgroup_get
In-Reply-To: <20181226033411.13568-1-gaoxiang25@huawei.com>
References: <20181226033411.13568-1-gaoxiang25@huawei.com>
Message-ID: <0af8999d-086b-99c5-7f48-9ee68f73f581@huawei.com>

On 2018/12/26 11:34, Gao Xiang wrote:
> There exists a return type misuse (`int'->`bool') since all
> users assume it fails if only return value != 0, let's fix
> the return type to `int' instead of confusing `bool'.
> 
> No logic changes.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
