From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 20 Nov 2018 14:43:25 +0800
Subject: [PATCH chao/erofs-dev rebased v2 08/12] staging: erofs: add a
 full barrier in erofs_workgroup_unfreeze
In-Reply-To: <20181114152548.37921-8-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152548.37921-8-gaoxiang25@huawei.com>
Message-ID: <82bc2b5b-27ca-dbbc-e26e-1bd0f136e8dd@huawei.com>

On 2018/11/14 23:25, Gao Xiang wrote:
> Just like other generic locks, insert a full barrier
> in case of memory reorder.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
