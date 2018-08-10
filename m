From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 10 Aug 2018 16:59:31 +0800
Subject: [WIP] [PATCH] staging: erofs: cleanup z_erofs_do_read_page
In-Reply-To: <95b74480-f015-9cb6-e730-0d59d6bfd1da@huawei.com>
References: <1533809340-69863-1-git-send-email-gaoxiang25@huawei.com>
 <04b2cf16-eb36-337a-0625-05b90859d355@huawei.com>
 <95b74480-f015-9cb6-e730-0d59d6bfd1da@huawei.com>
Message-ID: <240a3191-1046-5439-50d3-ab61304b8ca2@huawei.com>

Hi Xiang,

On 2018/8/10 14:59, Gao Xiang wrote:
> Hi Chao,
> 
> On 2018/8/10 14:53, Chao Yu wrote:
>> On 2018/8/9 18:09, Gao Xiang wrote:
>>> This patch adds error handing code, and fixes a
>>> bug when appling caching policy, which can cause
>>> the ending compressed pack of a request uncached.
>> Aslo including too many kind of change in one patch, how about splitting this patch?
>>
>> Thanks,
>>
> 
> I will post the whole patchset later and separate them properly.
> 
> Thanks for your kindly review ;) 

You're welcome, it's our job, right? ;)

> 
> BTW, for other code if you need explaination of some code snippets,
> please also kindly point out, I will explain the design ideas in detail in the mailing list. :)

Will ask if I have. :)

Thanks,

> 
> Thanks,
> Gao Xiang
> 
> .
> 
