From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 25 Mar 2019 11:43:46 +0800
Subject: [PATCH v2 3/3] staging: erofs: support IO read error injection
In-Reply-To: <20190325034009.38611-3-gaoxiang25@huawei.com>
References: <20190325034009.38611-1-gaoxiang25@huawei.com>
 <20190325034009.38611-3-gaoxiang25@huawei.com>
Message-ID: <2719c5f6-b6db-65bf-6c7e-3fa25dbcbf6f@huawei.com>

On 2019/3/25 11:40, Gao Xiang wrote:
> Used to simulate disk IO read error for testing fatal
> error tolerance.
> 
> Here are the details,
> 1) use bio->bi_private to indicate super_block
>    for non-compressed bios since some (mainly meta)
>    pages can be of the corresponding bdev inode;
> 2) get super_block dynamically for compressed bios,
>    therefore it could not inject bios full of staging
>    pages, yet it doesn't affect the normal usage.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
