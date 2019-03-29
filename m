From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 29 Mar 2019 14:28:31 +0800
Subject: [PATCH] staging: erofs: keep corrupted fs from crashing kernel in
 erofs_readdir()
In-Reply-To: <20190328201458.30629-1-hsiangkao@aol.com>
References: <20190328201458.30629-1-hsiangkao@aol.com>
Message-ID: <3f371610-71bb-03c1-ac7d-37832e475e94@huawei.com>

On 2019/3/29 4:14, Gao Xiang wrote:
> From: Gao Xiang <gaoxiang25 at huawei.com>
> 
> After commit 419d6efc50e9, kernel cannot be crashed in the namei
> path. However, corrupted nameoff can do harm in the process of
> readdir for scenerios without dm-verity as well. Fix it now.
> 
> Fixes: 3aa8ec716e52 ("staging: erofs: add directory operations")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
