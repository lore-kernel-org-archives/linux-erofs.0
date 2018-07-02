From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 2 Jul 2018 09:47:24 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.3 3/6] erofs: introduce
 erofs_map_blocks_iter
In-Reply-To: <999078e8-58ff-2c51-8437-75ce17056d82@aol.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530371853-104412-1-git-send-email-gaoxiang25@huawei.com>
 <1530371853-104412-3-git-send-email-gaoxiang25@huawei.com>
 <23a280ec-f19d-3351-ca1c-a45009691da3@kernel.org>
 <0d2d3155-7455-c67a-25c9-080574fcabf7@aol.com>
 <999078e8-58ff-2c51-8437-75ce17056d82@aol.com>
Message-ID: <55078067-41df-d385-cc6e-d3b802ef306e@huawei.com>

Hi Xiang,

On 2018/7/1 12:26, Gao Xiang via Linux-erofs wrote:
> Hi Chao,
> 
> 
> On 2018/7/1 12:17, Gao Xiang wrote:
>>
>> , I permanently dropped the last patch of EROFS v1 locally
>>
>> ?[RFC PATCH RESEND 12/12] erofs: introduce VLE decompression support 
>> (experimental)
>>
>> Sorry for the confusion :'(
> 
> I left some words on the last patch of this patchset,
> [WIP] [NOMERGE] [RFC PATCH v0.3 6/6] erofs: introduce VLE decompression 
> subsystem:
> 
> "The patchset is temporarily based on
> [RFC PATCH RESEND 11/12] erofs: introduce a customized LZ4 decompression
> The new unzip system is still _buggy_, not for _daily_ use!"
> 
> which seems improper, sorry... I will take care and leave message at the 
> beginning from now on.

No problem, I think we can add revert patch for [PATCH 12/12] erofs: introduce a
customized LZ4 decompression, so that we can track erofs code change history
more clearly, and once you want to look into it or make code going back to the
old implementation, we can remove that revert patch later.

The history will be only existed in current erofs dev branch, once the code is
pushed or merged by Linux or Android OS, it will invisible.

Or you're sure about remove old implementation, let's do it...

Thanks,

> 
> Thanks,
> Gao Xiang
> 
> 
> 
