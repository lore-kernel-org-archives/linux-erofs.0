From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 16 Jan 2019 17:27:26 +0800
Subject: [PATCH 3/5] staging: erofs: decrease the shrink count in
 erofs_workgroup_get
In-Reply-To: <20190116085956.21004-3-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
 <20190116085956.21004-3-gaoxiang25@huawei.com>
Message-ID: <d0f27173-b68f-a055-009f-2de4ab7817f4@huawei.com>

On 2019/1/16 16:59, Gao Xiang wrote:
> It is more suitable to update in erofs_workgroup_get since
> it's actually the one matched with erofs_workgroup_put.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
