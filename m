From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 13 Aug 2019 11:08:47 +0800
Subject: [PATCH 1/3] staging: erofs: inline
 erofs_inode_is_data_compressed()
In-Reply-To: <20190813023054.73126-1-gaoxiang25@huawei.com>
References: <20190813023054.73126-1-gaoxiang25@huawei.com>
Message-ID: <ac07164e-1ba8-65c0-98a6-347eca4bd52d@huawei.com>

On 2019/8/13 10:30, Gao Xiang wrote:
> As a helper in erofs_fs.h, erofs_inode_is_data_compressed()
> should be inlined.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
