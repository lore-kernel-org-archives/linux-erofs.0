From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 28 Jan 2019 23:04:33 +0800
Subject: [PATCH v2 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190128142837.GJ1795@kadam>
References: <20190125161007.4447-1-gaoxiang25@huawei.com>
 <20190125161007.4447-2-gaoxiang25@huawei.com>
 <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
 <20190128133302.GI1795@kadam>
 <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>
 <20190128142837.GJ1795@kadam>
Message-ID: <3a304a58-2ba3-b452-53ba-8286b1707795@aol.com>



On 2019/1/28 22:28, Dan Carpenter wrote:
> The point is, that people shouldn't recreate core code that already
> exists.  At least try it out and have an explanation why the other code
> doesn't work.
> 
> In other projects, the default is to keep code around once it has been
> written but in staging the default choice is to delete the code unless
> there is an explanation.

That is why I need Chao's idea about the future of EROFS fault injection.

As far as I know, the fault injection of f2fs also introduces after
the general fault injection, and the original reason is to test separated
partitions with different fault injection rate/type simultaneously, as follows:

commit 1ecc0c5c50ce8834f7e35b63be7480bf1aaa4155
Author: Chao Yu <yuchao0 at huawei.com>
Date:   Fri Sep 23 21:30:09 2016 +0800

    f2fs: support configuring fault injection per superblock

    Previously, we only support global fault injection configuration, so that
    when we configure type/rate of fault injection through sysfs, mount
    option, it will influence all f2fs partition which is being used.

    It is not make sence, since it will be not convenient if developer want
    to test separated partitions with different fault injection rate/type
    simultaneously, also it's not possible to enable fault injection in one
    partition and disable fault injection in other one.

    >From now on, we move global configuration of fault injection in module
    into per-superblock, hence injection testing can be more flexible.

    Signed-off-by: Chao Yu <yuchao0 at huawei.com>
    Signed-off-by: Jaegeuk Kim <jaegeuk at kernel.org>

For this patch, I could resend v4 to change erofs_kmalloc->kmalloc
if you like, it isn't an important stuff for this patch. However,
I'd like to get more ideas about the fault injection.

Thanks,
Gao Xiang

> 
> regards,
> dan carpenter
> 
