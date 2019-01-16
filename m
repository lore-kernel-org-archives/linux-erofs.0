From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 16 Jan 2019 17:28:08 +0800
Subject: [PATCH 4/5] staging: erofs: staticize erofs_shrink_count,
 erofs_shrink_scan
In-Reply-To: <20190116085956.21004-4-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
 <20190116085956.21004-4-gaoxiang25@huawei.com>
Message-ID: <54fe541e-ca81-7691-524d-abfda30d88a8@huawei.com>

On 2019/1/16 16:59, Gao Xiang wrote:
> Move erofs_shrinker_info to utils.c and therefore
> no need to globalize erofs_shrink_count and erofs_shrink_scan.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
