From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 21:52:51 +0800
Subject: [PATCH v5 12/24] erofs: introduce tagged pointer
In-Reply-To: <204b7fcc-a54b-ebd6-ff4c-2d5e2e6d4a8c@huawei.com>
References: <20190730071413.11871-1-gaoxiang25@huawei.com>
 <20190730071413.11871-13-gaoxiang25@huawei.com>
 <20190731130148.GE15806@quack2.suse.cz>
 <204b7fcc-a54b-ebd6-ff4c-2d5e2e6d4a8c@huawei.com>
Message-ID: <e2f2c550-8d1f-39f5-3bd9-b6de996da9ad@huawei.com>



On 2019/7/31 21:20, Gao Xiang wrote:
>    struct b *ptr = tagptr_unfold_tags(tptr);
> vs
>    struct b *ptr = (struct b *)((unsigned long)tptr & ~2);

Sorry ... a too stupid typo issue, I mean....

struct b *ptr = tagptr_unfold_ptr(tptr);
vs
struct b *ptr = (struct b *)((unsigned long)tptr & ~3);

Thanks,
Gao Xiang
