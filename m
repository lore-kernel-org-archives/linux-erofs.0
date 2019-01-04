From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 4 Jan 2019 10:20:49 +0800
Subject: [PREVIEW] [PATCH v2 2/3] staging: erofs: remove unneeded
 inode_operations
In-Reply-To: <a6f82047-3cc8-1cac-8df2-271031c38e03@huawei.com>
References: <20181229140143.23352-1-gaoxiang25@huawei.com>
 <20181229140143.23352-2-gaoxiang25@huawei.com>
 <26bf416f-e9dc-656d-1d5c-371b09f3e761@huawei.com>
 <a6f82047-3cc8-1cac-8df2-271031c38e03@huawei.com>
Message-ID: <4e75416e-77ea-a2ea-e9ce-b3e1a8c9f065@huawei.com>

On 2019/1/4 10:11, Gao Xiang wrote:
> Hi Chao,
> 
> On 2019/1/4 9:24, Chao Yu wrote:
>> On 2018/12/29 22:01, Gao Xiang wrote:
>>> Currently, EROFS uses generic iops when xattr is off,
>>> it seems unnecessary and a lot of extra code is there.
>>> Let's follow what other filesystems do instead.
>>>
>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>>
>> Thanks,
>>
> 
> Thanks for kindly review. ;)
> (Some additional words... some idea of [PATCH v2 3/3] staging: erofs: move erofs_xattr_handlers to xattr.h?)

I've been interrupted by other thing...

Anyway, it looks good to me. :)

Thanks,

> 
> Thanks,
> Gao Xiang
> 
> .
> 
