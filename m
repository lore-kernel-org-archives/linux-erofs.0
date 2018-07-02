From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 2 Jul 2018 18:48:26 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.3 3/6] erofs: introduce
 erofs_map_blocks_iter
In-Reply-To: <0fede491-893f-4595-bc56-97237e78a71e@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530371853-104412-1-git-send-email-gaoxiang25@huawei.com>
 <1530371853-104412-3-git-send-email-gaoxiang25@huawei.com>
 <23a280ec-f19d-3351-ca1c-a45009691da3@kernel.org>
 <0d2d3155-7455-c67a-25c9-080574fcabf7@aol.com>
 <999078e8-58ff-2c51-8437-75ce17056d82@aol.com>
 <55078067-41df-d385-cc6e-d3b802ef306e@huawei.com>
 <002188bd-1332-5ba4-2327-3ff6377ef72e@huawei.com>
 <82cd5853-eddc-e812-3c40-a60763651dfb@huawei.com>
 <0fede491-893f-4595-bc56-97237e78a71e@huawei.com>
Message-ID: <d1f7befb-8041-b697-cb60-8acc5e5a136f@huawei.com>

Hi Xiang,

On 2018/7/2 11:47, Gao Xiang wrote:
> Hi Chao,
> 
> On 2018/7/2 11:36, Chao Yu wrote:
>> We can do both of them, let's treat erofs branch as master branch, and we can
>> split erofs-dev branch (dev-test will not be so obvious to indicate that branch
>> is belong to erofs, so let's use erofs-dev) from erofs branch for further
>> development.
>>
>> So in erofs-dev, we can do anything temporarily change and testing, and once it
>> becomes stable, we can merge there-in patches back to erofs branch.
>>
>> And for any old codes or implementation obsolescing in erofs branch, let's use
>> git-revert or remove codes in a separated patch instead of dropping a patch
>> directly. :)
>>
>> How do you think?
> 
> *nod* *nod* *nod*, this policy is fine with me :)
> 
> and for these backport branches, I try to stablize the new unzip subsystem this week...

Alright,

> 
> and then we could start to begin backport and the whole fs bugfix work,
> eg. starting from seperate and discard these confusing LINUX_VERSION marcos...

Forgot to compile old version kernels, let me start to prepare them from this week.

Thanks,

> 
> Thanks,
> 
>>
>> Thanks,
> 
> .
> 
