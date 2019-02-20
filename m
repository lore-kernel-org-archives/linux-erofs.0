From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 20 Feb 2019 09:26:47 +0800
Subject: [PATCH] staging: erofs: remove rcu_read_lock() in
 erofs_try_to_free_cached_page
In-Reply-To: <20190216084650.33841-1-gaoxiang25@huawei.com>
References: <20190216084650.33841-1-gaoxiang25@huawei.com>
Message-ID: <def4913f-85cd-b8d4-e5b5-3bca332da324@huawei.com>

On 2019/2/16 16:46, Gao Xiang wrote:
> page_private(page) cannot be changed if page lock is taken.
> 
> Besides, the corresponding workgroup won't be freed
> if the page is already protected by page lock, therefore
> no need to take rcu read lock.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
