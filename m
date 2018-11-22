From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 21:01:31 +0800
Subject: [PATCH 07/10] staging: erofs: separate into init_once / always
In-Reply-To: <448b2d41-8156-3fe8-a037-29a31771721e@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-8-gaoxiang25@huawei.com>
 <20181122102339.GG3189@kroah.com>
 <66b90226-5d0e-7344-5220-908aa243b014@huawei.com>
 <20181122110500.GC5287@kroah.com>
 <ef49bf11-b937-46b4-1b9a-c068182aa7d9@huawei.com>
 <20181122112645.GA7527@kroah.com>
 <448b2d41-8156-3fe8-a037-29a31771721e@huawei.com>
Message-ID: <c6ec315b-6f80-911f-3abe-ee056e730fc9@huawei.com>

Hi Greg,

On 2018/11/22 20:00, Gao Xiang wrote:
> Hi Greg,
> 
> On 2018/11/22 19:26, Greg Kroah-Hartman wrote:
>> Don't make people rebuild your code with different options for
>> debugging.  That will never work in the 'real world' when people start
>> using the code.  You need to have things enabled for people all the
>> time, which is why we have dynamic debugging in the kernel now, and not
>> a zillion different "DRIVER_DEBUG" build options anymore.
> Actually, current erofs handle differently for beta users (in eng mode)
> and commercial users.
> 
> CONFIG_EROFS_FS_DEBUG is enable for all beta users, after an observed
> expression is false, we could get the whole memorydump as early as possible.
> But for commercial users, there are no such observing points to promise
> the kernel stability and performance.
> 
> It has helped us to find several bug, and I cannot find some alternative way
> to get the the first scene of the accident...

I'm about to send v2 of this patchset... I need to get your opinion...

I think for the current erofs development state, I tend to leave such a
developping switch because the code could be modified frequently,
many potential bugs could be avoid when this debugging mode is on and
it will be dropped after erofs becomes more stable...

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
