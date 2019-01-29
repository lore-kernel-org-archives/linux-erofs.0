From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 29 Jan 2019 16:03:34 +0800
Subject: [PATCH v2 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190128183053.GK1795@kadam>
References: <20190125161007.4447-1-gaoxiang25@huawei.com>
 <20190125161007.4447-2-gaoxiang25@huawei.com>
 <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
 <20190128133302.GI1795@kadam>
 <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>
 <1eed1e6b-f95e-aa8e-c3e7-e9870401ee23@kernel.org>
 <20190128183053.GK1795@kadam>
Message-ID: <8dbd81b4-48c2-4e0c-85c7-c3bfb12785ba@huawei.com>

Hi,

On 2019/1/29 2:30, Dan Carpenter wrote:
> Are you serious?  The standard fault injection doesn't do that???
> 
> Please fix it instead of creating a duplicate better implementation
> which only your filesystem can use.  I would have thought that obviously
> any fault injection framework could at least be configured to test
> specific code...
> 
> regards,
> dan carpenter

Since Chao is now on the short business trip, I will resend v4 and change
erofs_kmalloc into kmalloc temporarily to make sure ACL is usable first
in the staging tree.

As for the EROFS fault injection, let's wait Chao's reply...

Thanks,
Gao Xiang
