From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 31 Jul 2018 15:14:38 +0800
Subject: [FOR INTERNAL REVIEW] [PATCH 3/4] staging: erofs: remove
 RADIX_TREE_EXCEPTIONAL_{ENTRY,SHIFT}
In-Reply-To: <1532942311-33785-3-git-send-email-gaoxiang25@huawei.com>
References: <1532942311-33785-1-git-send-email-gaoxiang25@huawei.com>
 <1532942311-33785-3-git-send-email-gaoxiang25@huawei.com>
Message-ID: <4ecb4e78-ae94-1aba-5fe2-27a76623da2d@huawei.com>

On 2018/7/30 17:18, Gao Xiang wrote:
> After commit 49520d317715 ("xarray: Replace exceptional entries"),
> there are no RADIX_TREE_EXCEPTIONAL_{ENTRY,SHIFT} at all, remove them
> as a workaround but erofs actually needs an extra bit for each entry.
> 
> In the future, it should be converted to XArray of course.
> 
> Cc: Matthew Wilcox <willy at infradead.org>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
