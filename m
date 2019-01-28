From: chao@kernel.org (Chao Yu)
Date: Tue, 29 Jan 2019 00:41:55 +0800
Subject: [PATCH v2 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>
References: <20190125161007.4447-1-gaoxiang25@huawei.com>
 <20190125161007.4447-2-gaoxiang25@huawei.com>
 <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
 <20190128133302.GI1795@kadam>
 <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>
Message-ID: <1eed1e6b-f95e-aa8e-c3e7-e9870401ee23@kernel.org>

Hi Dan and Xiang,

On 2019-1-28 21:48, Gao Xiang wrote:
> Hi Dan,
> 
> On 2019/1/28 21:33, Dan Carpenter wrote:
>> Hopefully, regular kmalloc() is enough.
>>
>> Do really need the erofs_kmalloc() function?  Regular kmalloc() has
>> fault injection already.  Have you tried to use it?

Yes, I think we'd better to use erofs_kmalloc(). :)

Actually, fault injection in erofs_kmalloc only affect erofs module, we can
expect that the range of fault can be limited in erofs code, rather than whole
kernel, so the test point can be aimed at more accurately.

> 
> The fault injection subsystem was introduced in the initial upstreamed
> EROFS version, which is taken from f2fs by Chao Yu.
> 
> Fault injection is important to test fs.. However, I have no more idea
> about the future plan of this feature...Follow f2fs or use the general
> fault injection...

I guess following f2fs is not bad.

Thanks,

> 
> There already exists erofs_kmalloc, thus I think it's both ok to use
> erofs_kmalloc or kmalloc for this patch at least.
> 
> Chao, any idea about this?
> 
> Thanks,
> Gao Xiang
> 
