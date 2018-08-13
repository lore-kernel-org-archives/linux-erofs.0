From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Mon, 13 Aug 2018 16:05:41 +0300
Subject: [PATCH 4/8] staging: erofs: cleanup z_erofs_vle_work_{lookup,
 register}
In-Reply-To: <f162748e-cc02-8578-2a0b-af16d982e0b3@huawei.com>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-5-chao@kernel.org>
 <20180813120057.6grkpue6h7dtmpt2@mwanda>
 <f162748e-cc02-8578-2a0b-af16d982e0b3@huawei.com>
Message-ID: <20180813130541.hzjgb6wznkxcnajg@mwanda>

Yeah.  You'd have to remove the const.

Anyway, on looking at it more, I guess this patch is fine for now.  We
will probably end up changing z_erofs_vle_work_lookup() and
z_erofs_vle_work_register() some more in the future.

regards,
dan carpenter
