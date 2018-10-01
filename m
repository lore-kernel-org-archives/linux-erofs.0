From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 1 Oct 2018 10:08:47 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 1/3] staging: erofs: harden inode
 lookup for 32-bit platforms
In-Reply-To: <8398183e-61b3-33d6-0731-3da54c191813@kernel.org>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
 <a3d758de-cf1a-faf9-6df7-fc0f50bb0ae5@aol.com>
 <8398183e-61b3-33d6-0731-3da54c191813@kernel.org>
Message-ID: <fdfb248d-59ef-10fd-7203-94ade0096e1f@aol.com>

Hi Chao,

On 2018/10/1 8:37, Chao Yu wrote:
> Hi Xiang,
> 
> Sorry for late response to those patches.

That doesn't matter I know you are now busy with f2fs stuffs. ;)

I have to deal with internal reported issues which could impact our products
and do more cleanup apart from stability fixes.

It seems that Linux-4.20 will be out weeks later, and we also need
to prepare more for it.


And I tend to make progress in moving into fs tree before the next LTS version,
we need to do more...

Source code of previewed mkfs will be released this month and it also seems much work to clean up it.

> 
> On 2018-10-1 0:22, Gao Xiang wrote:
>> Hi Chao,
>>
>> Could you help merge these patches into erofs-dev (rebased on the latest erofs-master)?
>> I need to fix several issues reported these days formally.
> 
> No problem.
> 
>>
>> If you have time, could you also take some time review these patches?
> 
> Okay, will review them soon. :)

Thanks Chao :)

Thanks,
Gao Xiang

> 
> Thanks,
> 
>>
>> Thanks,
>> Gao Xiang
>>
>> On 2018/9/21 11:43, Gao Xiang wrote:
>>> This patch introduces inode hash function, test and set callbacks,
>>> and iget5_locked to find the right inode for 32-bit platforms.
>>>
>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
