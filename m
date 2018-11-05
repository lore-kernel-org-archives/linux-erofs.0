From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 09:36:47 +0800
Subject: [PATCH chao/erofs-dev 1/2] staging: erofs: separate into
 init_once / always
In-Reply-To: <b6bfe03c-6381-5e40-9536-502fb9d546f7@huawei.com>
References: <20181019064138.36549-1-gaoxiang25@huawei.com>
 <50241fb0-28b0-f90c-2725-dce1a0327a2a@huawei.com>
 <ab8f0d8d-ac0e-0c70-d7f7-1001cec7abeb@huawei.com>
 <af3deccf-5c3e-82a6-b10a-074a822643ad@huawei.com>
 <60fefb10-283d-d032-a974-8ea0ca547545@huawei.com>
 <1adfe14f-f78e-656e-1558-3b80e768725e@aol.com>
 <ff2a929b-0593-0ffd-210a-64743668f1e5@kernel.org>
 <88736039-effe-dfbf-0f8b-6eb45c6bff51@aol.com>
 <6b4b3a55-c98a-a0de-b59f-b01d6adda2c0@kernel.org>
 <f5233847-dc5e-f04e-1402-352fc141b432@aol.com>
 <b6bfe03c-6381-5e40-9536-502fb9d546f7@huawei.com>
Message-ID: <80cddebb-44b8-5739-3818-484eedb8316e@huawei.com>

Hi Chao,

On 2018/11/5 9:30, Chao Yu wrote:
> Hi Xiang,
> 
> On 2018/11/4 23:52, Gao Xiang wrote:
>> Hi Chao,
>>
>> On 2018/11/4 23:35, Chao Yu wrote:
>>> Yes, it needs rebase below two patches to last erofs-dev branch.
>>>
>>> staging: erofs: separate into init_once / always
>>> staging: erofs: locked before registering for all new workgroups
>>>
>>> Thanks,
>> I think the erofs-dev branch is missing a upstreamed commit
>>
>> staging: erofs: add the missing __init tags
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/drivers/staging/erofs?id=0a0b7e62525fa0ad778439acc28bf2f53967453e
>>
>> Could you please update the erofs and erofs-dev branch on the linus tree?
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
>>
>> Since the commit
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/lib/lz4/lz4_decompress.c?id=2209fda323e2fd2a2d0885595fd5097717f8d2aa
>>
>> has been merged in the mainstream... I have to remove our hacked lz4 code...
>>
>> p.s. could you please drop the commit
>> "staging: erofs: managed pages could be locked at the time of decompression"?
>> I will rewrite the whole commit...
> Oh, I forgot to rebase on upstream, will update soon.

Yes, and it seems 4.20-rc1 just came out, therefore we could base on 4.20-rc1 to update erofs-master/erofs/erofs-dev....
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/log/?h=staging-testing

Thanks,
Gao Xiang

> 
> Thanks,
> 
