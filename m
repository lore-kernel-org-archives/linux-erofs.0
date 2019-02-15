From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 15 Feb 2019 11:36:56 +0800
Subject: [PREVIEW] [PATCH] staging: erofs: fix race of initializing xattrs
 of a inode at the same time
In-Reply-To: <20190214153450.28221-1-gaoxiang25@huawei.com>
References: <20190214153450.28221-1-gaoxiang25@huawei.com>
Message-ID: <773e5c07-2ba2-9e58-7a89-7ff0144ba35f@huawei.com>

Hi Chao,

On 2019/2/14 23:34, Gao Xiang wrote:
> In real scenario, there could be several threads accessing xattrs
> of the same xattr-uninitialized inode, and init_inode_xattrs()
> almost at the same time.
> 
> That's actually an unexpected behavior, this patch closes the race.
> 
> Fixes: b17500a0fdba ("staging: erofs: introduce xattr & acl support")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

I'd like to submit this patch to linux-5.1 and our products,
could you take some time review this commit? (fix race between init_inode_xattrs
of the same inode, could cause memleak or unexpected behaviors...)

Thanks,
Gao Xiang
