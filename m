From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Fri, 25 Jan 2019 16:30:44 +0300
Subject: [PATCH 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190125120104.15604-1-gaoxiang25@huawei.com>
References: <20190125115103.47250-1-gaoxiang25@huawei.com>
 <20190125120104.15604-1-gaoxiang25@huawei.com>
Message-ID: <20190125133044.GC1795@kadam>

On Fri, Jan 25, 2019@08:01:04PM +0800, Gao Xiang wrote:
> Let's add .get_acl() to read the file's acl
> from its xattrs to make POSIX ACL usable.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  This [PATCH 2/2] currently hasn't tested, please ignore temporarily...
>  I will test it asap...

This is an awkward thing.

Just don't send it until after you test it.  We also ignore RFC patches
so if you mark it as RFC that will be ignored if you want.

regards,
dan carpenter
