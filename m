From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 12 Dec 2018 19:47:41 +0800
Subject: [PATCH] staging: erofs: remove __EROFS_BIT
In-Reply-To: <5aba500d-3bbb-f5a5-b77c-c2bf91d886e8@kernel.org>
References: <20181211175730.3931-1-hsiangkao@aol.com>
 <5aba500d-3bbb-f5a5-b77c-c2bf91d886e8@kernel.org>
Message-ID: <c3998105-7c46-78bb-486e-0bc275a312c3@huawei.com>

Hi Chao,

On 2018/12/12 19:22, Chao Yu wrote:
> On 2018-12-12 1:57, Gao Xiang wrote:
>> It's better to use pre-calculated values to make
>> on-disk definition more straight-forward and human-readable.
>>
>> Since there is the only one user, let's remove
>> __EROFS_BIT entirely.
>>
>> Suggested-by: Joe Perches <joe at perches.com>
>> Signed-off-by: Gao Xiang <hsiangkao at aol.com>
> It looks this patch has been merged, anyway
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> 
> Thanks,

Thanks for kindly review :)
Yesterday Joe Perches made a suggestion and then I sent a patch to fix that...

Thanks,
Gao Xiang
