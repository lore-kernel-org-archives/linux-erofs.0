From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 1 Aug 2019 09:39:17 +0800
Subject: [PATCH v2 12/22] staging: erofs: drop __GFP_NOFAIL for managed
 inode
In-Reply-To: <20190731155752.210602-13-gaoxiang25@huawei.com>
References: <20190731155752.210602-1-gaoxiang25@huawei.com>
 <20190731155752.210602-13-gaoxiang25@huawei.com>
Message-ID: <b8d6b408-55c5-14c7-06d5-7b735100389c@huawei.com>

On 2019/7/31 23:57, Gao Xiang wrote:
> For historical reasons, __GFP_NOFAIL was set for managed inode.
> It's no need using that since EROFS can handle it properly.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
