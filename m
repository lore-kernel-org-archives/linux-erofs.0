From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 12 Jul 2019 15:52:46 +0800
Subject: [PATCH] staging: erofs: Remove function erofs_kill_sb()
In-Reply-To: <20190712071247.2357-1-nishkadg.linux@gmail.com>
References: <20190712071247.2357-1-nishkadg.linux@gmail.com>
Message-ID: <b2d4d126-a39a-68a0-0c8d-e21b3fe5d805@huawei.com>



On 2019/7/12 15:12, Nishka Dasgupta wrote:
> Remove function erofs_kill_sb as all it does is call kill_block_super.
> Modify references to the former to point to the latter.
> Issue found with Coccinelle.
> 
> Signed-off-by: Nishka Dasgupta <nishkadg.linux at gmail.com>

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang
