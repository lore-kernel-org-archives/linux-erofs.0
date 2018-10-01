From: chao@kernel.org (Chao Yu)
Date: Mon, 1 Oct 2018 08:37:25 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 1/3] staging: erofs: harden inode
 lookup for 32-bit platforms
In-Reply-To: <a3d758de-cf1a-faf9-6df7-fc0f50bb0ae5@aol.com>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
 <a3d758de-cf1a-faf9-6df7-fc0f50bb0ae5@aol.com>
Message-ID: <8398183e-61b3-33d6-0731-3da54c191813@kernel.org>

Hi Xiang,

Sorry for late response to those patches.

On 2018-10-1 0:22, Gao Xiang wrote:
> Hi Chao,
> 
> Could you help merge these patches into erofs-dev (rebased on the latest erofs-master)?
> I need to fix several issues reported these days formally.

No problem.

> 
> If you have time, could you also take some time review these patches?

Okay, will review them soon. :)

Thanks,

> 
> Thanks,
> Gao Xiang
> 
> On 2018/9/21 11:43, Gao Xiang wrote:
>> This patch introduces inode hash function, test and set callbacks,
>> and iget5_locked to find the right inode for 32-bit platforms.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
