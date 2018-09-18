From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 19 Sep 2018 00:39:26 +0800
Subject: [PATCH v3 3/4] staging: erofs: code cleanup for
 erofs_show_options()
In-Reply-To: <20180918151058.25041-4-cgxu519@gmx.com>
References: <20180918151058.25041-1-cgxu519@gmx.com>
 <20180918151058.25041-4-cgxu519@gmx.com>
Message-ID: <10bd7ade-1615-25b1-ee2d-9de29495f18c@aol.com>



On 2018/9/18 23:10, Chengguang Xu wrote:
> Add new helper erofs_get_fault_rate() to get fault rate instead of
> directly getting it from sbi, so we can remove the macro check
> surrounding it.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang
