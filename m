From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 28 Jan 2019 21:48:03 +0800
Subject: [PATCH v2 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190128133302.GI1795@kadam>
References: <20190125161007.4447-1-gaoxiang25@huawei.com>
 <20190125161007.4447-2-gaoxiang25@huawei.com>
 <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
 <20190128133302.GI1795@kadam>
Message-ID: <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>

Hi Dan,

On 2019/1/28 21:33, Dan Carpenter wrote:
> Hopefully, regular kmalloc() is enough.
> 
> Do really need the erofs_kmalloc() function?  Regular kmalloc() has
> fault injection already.  Have you tried to use it?

The fault injection subsystem was introduced in the initial upstreamed
EROFS version, which is taken from f2fs by Chao Yu.

Fault injection is important to test fs.. However, I have no more idea
about the future plan of this feature...Follow f2fs or use the general
fault injection...

There already exists erofs_kmalloc, thus I think it's both ok to use
erofs_kmalloc or kmalloc for this patch at least.

Chao, any idea about this?

Thanks,
Gao Xiang
