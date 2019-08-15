From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 15 Aug 2019 09:31:02 +0800
Subject: [PATCH v2 3/3] staging: erofs: correct all misused ENOTSUPP
In-Reply-To: <20190814103705.60698-3-gaoxiang25@huawei.com>
References: <20190814103705.60698-1-gaoxiang25@huawei.com>
 <20190814103705.60698-3-gaoxiang25@huawei.com>
Message-ID: <f242f6a6-245d-281e-64dd-55cf0ba607d6@huawei.com>

On 2019/8/14 18:37, Gao Xiang wrote:
> As Chao pointed out [1], ENOTSUPP is used for NFS
> protocol only, we should use EOPNOTSUPP instead...
> 
> [1] https://lore.kernel.org/lkml/108ee2f9-75dd-b8ab-8da7-b81c17bafbf6 at huawei.com/
> 
> Reported-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
