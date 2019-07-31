From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 31 Jul 2019 15:41:18 +0800
Subject: [PATCH 09/22] staging: erofs: clean up shrinker stuffs
In-Reply-To: <20190729065159.62378-10-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-10-gaoxiang25@huawei.com>
Message-ID: <633ea8ac-c502-68dd-e0b0-b618e9195a43@huawei.com>

On 2019/7/29 14:51, Gao Xiang wrote:
> - rename erofs_register_super / erofs_unregister_super
>   to erofs_shrinker_register / erofs_shrinker_unregister;
> - fold the only erofs_shrink_workstation external call
>   to erofs_shrinker_unregister;
> - localize erofs_shrink_workstation;
> - localize erofs_shrinker_info by introducing
>   erofs_init_shrinker and erofs_exit_shrinker.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
