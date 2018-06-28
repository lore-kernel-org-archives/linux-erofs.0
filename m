From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 28 Jun 2018 17:40:36 +0800
Subject: [RFC PATCH] <linux/taggedptr.h>: Introduce tagged pointer
In-Reply-To: <20180628092303.GD7646@bombadil.infradead.org>
References: <1530176789-107541-1-git-send-email-gaoxiang25@huawei.com>
 <20180628092303.GD7646@bombadil.infradead.org>
Message-ID: <bcf7bc51-1689-fec5-f167-14fb46409b76@huawei.com>

Hi Matthew,

On 2018/6/28 17:23, Matthew Wilcox wrote:
> On Thu, Jun 28, 2018@05:06:29PM +0800, Gao Xiang wrote:
>> Therefore, this patch introduces simple generic methods to fold
>> tags into a pointer integer. It currently reuses the last 2 bits
>> of the pointer for tags, which are safely for all modern platforms.
> 
> The m68k people will have your head.  alignof(unsigned long) == 2 on
> m68k.  Now, kmalloc always returns 8-byte aligned quantities, but
> if you have:
> 
> static unsigned long foo;
> 
> then ((unsigned long)&foo & 2) may be non-zero.
> 

Oh.. I missed it. How about covering dynamic allocation scenario only?
(since 1 bit is too limited to be used for generic purposes... :( )

Or generate different bit mask versions by using macro? --- I could try in the next patch.

Anyway, I think it is depended on specific use cases and corresponding architectures...

>> +/*
>> + * mark these special integers as another type
>> + * in order to highlight the tagged pointer usage.
>> + */
>> +typedef uintptr_t	taggedptr_t;
> 
> I find this a bit verbose.  How about tagptr_t ?
> 

Boths are ok for me :)

Thanks,
Gao Xiang
