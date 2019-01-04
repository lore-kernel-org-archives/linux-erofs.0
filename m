From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 4 Jan 2019 09:24:59 +0800
Subject: [PREVIEW] [PATCH v2 2/3] staging: erofs: remove unneeded
 inode_operations
In-Reply-To: <20181229140143.23352-2-gaoxiang25@huawei.com>
References: <20181229140143.23352-1-gaoxiang25@huawei.com>
 <20181229140143.23352-2-gaoxiang25@huawei.com>
Message-ID: <26bf416f-e9dc-656d-1d5c-371b09f3e761@huawei.com>

On 2018/12/29 22:01, Gao Xiang wrote:
> Currently, EROFS uses generic iops when xattr is off,
> it seems unnecessary and a lot of extra code is there.
> Let's follow what other filesystems do instead.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
