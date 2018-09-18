From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 18 Sep 2018 18:53:36 +0800
Subject: [PATCH v2 3/6] staging: erofs: introduce a new helper
 __erofs_build_fault_attr()
In-Reply-To: <20180917153426.16880-4-cgxu519@gmx.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
 <20180917153426.16880-4-cgxu519@gmx.com>
Message-ID: <36a5b601-70c2-9931-8369-5ead63981d01@huawei.com>

On 2018/9/17 23:34, Chengguang Xu wrote:
> Introduce a new helper __erofs_build_fault_attr() to handle set/clear
> erofs_fault_info, we need this funciton for internal use case.
> for example, reset fault_injection option in remount.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

Since this patch is related to your [PATCH 6/6], so I think they can be
merge to one, so the purpose of patch can be more clear. Anyway, it's not a
big deal. you can add:

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
