From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 15 Feb 2019 17:31:13 +0800
Subject: [PATCH v2 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190215073644.GD2326@kadam>
References: <20190125161007.4447-1-gaoxiang25@huawei.com>
 <20190125161007.4447-2-gaoxiang25@huawei.com>
 <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
 <20190128133302.GI1795@kadam>
 <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>
 <1eed1e6b-f95e-aa8e-c3e7-e9870401ee23@kernel.org>
 <20190128183053.GK1795@kadam>
 <16373e83-2496-3bf5-7b16-72f3454d294d@huawei.com>
 <f08c49d2-c3c1-4b80-f61c-004f911086d8@huawei.com>
 <20190215073644.GD2326@kadam>
Message-ID: <388add9e-8643-b08f-2eec-9742c5411cc0@huawei.com>

On 2019/2/15 15:36, Dan Carpenter wrote:
> On Fri, Feb 15, 2019@10:10:34AM +0800, Chao Yu wrote:
>> Hi Dan,
>>
>> Any suggestion?
>>
> 
> I won't NAK whatever you decide.  But my opinion is that you should
> just use normal kernel memory allocators even though it means you have
> to use two different fault injection frameworks.

Thanks for the suggestion.

There is only one injection type in erofs injection framework, I don't want
to remove all framework codes with kmalloc type, so I think we can do this
step by step:
a. use erofs_kamloc to keep all codes consistent.
b. add at least one erofs private injection type.
c. remove erofs_kmalloc and related type.

> 
> Over time it would be good to improve and expand the standard kernel
> error injection frameworks to cover more types.

Agreed.

Thanks,

> 
> regards,
> dan carpenter
> 
> 
> 
