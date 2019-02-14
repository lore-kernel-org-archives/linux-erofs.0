From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 14 Feb 2019 15:10:04 +0800
Subject: [PATCH v2] staging: erofs: fix memleak of inode's shared xattr
 array
In-Reply-To: <20190214064636.30039-1-shengyong1@huawei.com>
References: <20190214064636.30039-1-shengyong1@huawei.com>
Message-ID: <d9aefb6b-e3a9-29c4-c230-391aeec19d97@huawei.com>



On 2019/2/14 14:46, Sheng Yong wrote:
> If it fails to read a shared xattr page, the inode's shared xattr array
> is not freed. The next time the inode's xattr is accessed, the previously
> allocated array is leaked.
> 
> Signed-off-by: Sheng Yong <shengyong1 at huawei.com>

LGTM,

Fixes: b17500a0fdba ("staging: erofs: introduce xattr & acl support")
Cc: <stable at vger.kernel.org> # 4.19+
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

[and there is also another race condition in it, but different root cause.
let me fix it later independently...]

Thanks,
Gao Xiang
