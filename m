From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 16 Jan 2019 17:20:01 +0800
Subject: [PATCH 2/5] staging: erofs: localize erofs_workgroup_get
In-Reply-To: <20190116085956.21004-2-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
 <20190116085956.21004-2-gaoxiang25@huawei.com>
Message-ID: <8dfe2593-270f-e8e6-e14b-bbc1291ab7dd@huawei.com>

On 2019/1/16 16:59, Gao Xiang wrote:
> Staticize erofs_workgroup_get since no external user
> out of utils.c directly calls erofs_workgroup_get.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
