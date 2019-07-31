From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 31 Jul 2019 20:07:01 +0800
Subject: [PATCH 07/22] staging: erofs: remove redundant #include
 "internal.h"
In-Reply-To: <52072867-a9ae-5730-0ce4-47dd8dcb2d8c@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-8-gaoxiang25@huawei.com>
 <bae5fc5b-b2e1-0d74-6374-b1ae5835cbb9@huawei.com>
 <52072867-a9ae-5730-0ce4-47dd8dcb2d8c@huawei.com>
Message-ID: <b261d2bf-bdc0-a418-1cac-dc142c7dc467@huawei.com>

Hi Xiang,

On 2019/7/31 15:08, Gao Xiang wrote:
> Hi Chao,
> 
> On 2019/7/31 15:03, Chao Yu wrote:
>> On 2019/7/29 14:51, Gao Xiang wrote:
>>> Because #include "internal.h" is included in xattr.h
>>
>> I think it would be better to remove "internal.h" in xattr.h, and include them
>> both in .c file in where we need xattr definition.
> 
> It seems that all xattr related source files needing internal.h,
> and we need "EROFS_V(inode)", "struct erofs_sb_info", ... stuffs in xattr.h,
> which is defined in internal.h...

Since I checked f2fs', it looks it's okay to don't include internal.h for
xattr.h, if .c needs xattr.h, we can just include interanl.h and xattr.h in the
head of it, it's safe.

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>>
>> Thanks,
>>
> .
> 
