From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 1 Oct 2018 19:37:44 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 2/3] staging: erofs: fix race
 when the managed cache is enabled
In-Reply-To: <b4ec415e-2d3e-a9bc-bfa4-6b38cc5228b5@kernel.org>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
 <1537501415-70936-2-git-send-email-gaoxiang25@huawei.com>
 <b4ec415e-2d3e-a9bc-bfa4-6b38cc5228b5@kernel.org>
Message-ID: <90a1160d-3b46-ec62-b9fc-e44a33f7e684@aol.com>

Hi Chao,

On 2018/10/1 17:49, Chao Yu wrote:
> On 2018-9-21 11:43, Gao Xiang wrote:
>> When the managed cache is enabled, the last reference count
>> of a workgroup must be used for its workstation.
>>
>> Otherwise, it could lead to incorrect (un)freezes in
>> the reclaim path, and it would be harmful.
> Could you add related race condition stack to demonstrate this problem more clearly?
> 

I remembered that the original related stack isn't directly related to code fixing in this patch.
I reviewed the reclaim path then and found a issue, so the patch it is.

The incorrect reclaim will do harm to other code, but I think I can try to give
a rough race condition (some stack) in the next patch.

That is because when the managed cache is enabled, the reclaim path will work for
every decompression workgroup with refcount == 1.

Just like the page cache (and pages are not truncated) refcount idea, the last refcount
should be reserved for its tree rather than other uses for all cases by design.

Thanks,
Gao Xiang

> Thanks,
> 
