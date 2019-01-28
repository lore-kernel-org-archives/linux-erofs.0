From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Mon, 28 Jan 2019 21:30:53 +0300
Subject: [PATCH v2 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <1eed1e6b-f95e-aa8e-c3e7-e9870401ee23@kernel.org>
References: <20190125161007.4447-1-gaoxiang25@huawei.com>
 <20190125161007.4447-2-gaoxiang25@huawei.com>
 <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
 <20190128133302.GI1795@kadam>
 <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>
 <1eed1e6b-f95e-aa8e-c3e7-e9870401ee23@kernel.org>
Message-ID: <20190128183053.GK1795@kadam>

On Tue, Jan 29, 2019@12:41:55AM +0800, Chao Yu wrote:
> Hi Dan and Xiang,
> 
> On 2019-1-28 21:48, Gao Xiang wrote:
> > Hi Dan,
> > 
> > On 2019/1/28 21:33, Dan Carpenter wrote:
> >> Hopefully, regular kmalloc() is enough.
> >>
> >> Do really need the erofs_kmalloc() function?  Regular kmalloc() has
> >> fault injection already.  Have you tried to use it?
> 
> Yes, I think we'd better to use erofs_kmalloc(). :)
> 
> Actually, fault injection in erofs_kmalloc only affect erofs module, we can
> expect that the range of fault can be limited in erofs code, rather than whole
> kernel, so the test point can be aimed at more accurately.
> 

Are you serious?  The standard fault injection doesn't do that???

Please fix it instead of creating a duplicate better implementation
which only your filesystem can use.  I would have thought that obviously
any fault injection framework could at least be configured to test
specific code...

regards,
dan carpenter
