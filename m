From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 15:08:50 +0800
Subject: [PATCH 07/22] staging: erofs: remove redundant #include
 "internal.h"
In-Reply-To: <bae5fc5b-b2e1-0d74-6374-b1ae5835cbb9@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-8-gaoxiang25@huawei.com>
 <bae5fc5b-b2e1-0d74-6374-b1ae5835cbb9@huawei.com>
Message-ID: <52072867-a9ae-5730-0ce4-47dd8dcb2d8c@huawei.com>

Hi Chao,

On 2019/7/31 15:03, Chao Yu wrote:
> On 2019/7/29 14:51, Gao Xiang wrote:
>> Because #include "internal.h" is included in xattr.h
> 
> I think it would be better to remove "internal.h" in xattr.h, and include them
> both in .c file in where we need xattr definition.

It seems that all xattr related source files needing internal.h,
and we need "EROFS_V(inode)", "struct erofs_sb_info", ... stuffs in xattr.h,
which is defined in internal.h...

Thanks,
Gao Xiang

> 
> Thanks,
> 
