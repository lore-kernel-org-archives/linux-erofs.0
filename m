From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 21:30:04 +0800
Subject: [PATCH v5 12/24] erofs: introduce tagged pointer
In-Reply-To: <204b7fcc-a54b-ebd6-ff4c-2d5e2e6d4a8c@huawei.com>
References: <20190730071413.11871-1-gaoxiang25@huawei.com>
 <20190730071413.11871-13-gaoxiang25@huawei.com>
 <20190731130148.GE15806@quack2.suse.cz>
 <204b7fcc-a54b-ebd6-ff4c-2d5e2e6d4a8c@huawei.com>
Message-ID: <560f56f4-fb6d-6c78-6080-fe32df9ac4bf@huawei.com>



On 2019/7/31 21:20, Gao Xiang wrote:
> Yes, I think that is about coding style, but the legacy way we have to do
> type cast as well, I think...
> 
>    struct b *ptr = tagptr_unfold_tags(tptr);
> vs
>    struct b *ptr = (struct b *)((unsigned long)tptr & ~2);

and we could do "typedef tagptr1_t tptrb;" and then use tptrb for tagged
pointer rather than barely use tagptr1_t tagptr2_t ... as I mentioned in:
https://lore.kernel.org/lkml/0c2cdd4f-8fe7-6084-9c2d-c2e475e6806e at aol.com/

I think "tptrb" is enough for developers to know the original pointer type
when they coding...

OTOH, I think it could be better not to directly use "struct b *" to
represent the whole tagged pointer since it seems unsafe to do dereference
directly.. It could introduce some potential bugs...

All in all, this approach is only used for EROFS for now... If there are
some better implementation, I can switch to it in the later version :)

Thanks,
Gao Xiang
