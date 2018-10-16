From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 16 Oct 2018 19:10:15 +0800
Subject: [PATCH] staging: erofs: add the missing __init tags
In-Reply-To: <20181009134353.23409-1-gaoxiang25@huawei.com>
References: <20181009134353.23409-1-gaoxiang25@huawei.com>
Message-ID: <2bd18856-7c54-04ef-4e73-f401d3b02098@huawei.com>

On 2018/10/9 21:43, Gao Xiang wrote:
> Append __init to `erofs_init_inode_cache',
> `z_erofs_init_zip_subsystem' and move these
> declarations to internal.h.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
