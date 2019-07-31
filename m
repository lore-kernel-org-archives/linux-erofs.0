From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 31 Jul 2019 17:07:27 +0800
Subject: [PATCH 16/22] staging: erofs: tidy up decompression frontend
In-Reply-To: <20190729065159.62378-17-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-17-gaoxiang25@huawei.com>
Message-ID: <b0d5c746-2450-7ad6-5714-de7ec1f20ea0@huawei.com>

On 2019/7/29 14:51, Gao Xiang wrote:
> Although this patch has an amount of changes, it is hard to
> separate into smaller patches.
> 
> Most changes are due to structure renaming for better understand
> and straightforward,
>  z_erofs_vle_workgroup to z_erofs_pcluster
>              since it represents a physical cluster;
>  z_erofs_vle_work to z_erofs_collection
>              since it represents a collection of logical pages;
>  z_erofs_vle_work_builder to z_erofs_collector
>              since it's used to fill z_erofs_{pcluster,collection}.
> 
> struct z_erofs_vle_work_finder has no extra use compared with
> struct z_erofs_collector, delete it.
> 
> FULL_LENGTH bit is integrated into .length of pcluster so that it
> can be updated with the corresponding length change in atomic.
> 
> Minor, add comments for better description.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

I hope I don't miss anything, since this is so huge cleanup...

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
