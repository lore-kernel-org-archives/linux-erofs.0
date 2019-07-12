From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 12 Jul 2019 17:36:45 +0800
Subject: [PATCH] staging: erofs: Remove function erofs_kill_sb()
In-Reply-To: <20190712071247.2357-1-nishkadg.linux@gmail.com>
References: <20190712071247.2357-1-nishkadg.linux@gmail.com>
Message-ID: <d465e5e6-ad87-c7ca-2fcb-e3b22dae9f86@huawei.com>

On 2019/7/12 15:12, Nishka Dasgupta wrote:
> Remove function erofs_kill_sb as all it does is call kill_block_super.
> Modify references to the former to point to the latter.
> Issue found with Coccinelle.
> 
> Signed-off-by: Nishka Dasgupta <nishkadg.linux at gmail.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
