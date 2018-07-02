From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 2 Jul 2018 11:36:10 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.3 3/6] erofs: introduce
 erofs_map_blocks_iter
In-Reply-To: <002188bd-1332-5ba4-2327-3ff6377ef72e@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530371853-104412-1-git-send-email-gaoxiang25@huawei.com>
 <1530371853-104412-3-git-send-email-gaoxiang25@huawei.com>
 <23a280ec-f19d-3351-ca1c-a45009691da3@kernel.org>
 <0d2d3155-7455-c67a-25c9-080574fcabf7@aol.com>
 <999078e8-58ff-2c51-8437-75ce17056d82@aol.com>
 <55078067-41df-d385-cc6e-d3b802ef306e@huawei.com>
 <002188bd-1332-5ba4-2327-3ff6377ef72e@huawei.com>
Message-ID: <82cd5853-eddc-e812-3c40-a60763651dfb@huawei.com>

Hi Xiang,

On 2018/7/2 10:48, Gao Xiang wrote:
> Hi Chao,
> 
> On 2018/7/2 9:47, Chao Yu wrote:
>>> I left some words on the last patch of this patchset,
>>> [WIP] [NOMERGE] [RFC PATCH v0.3 6/6] erofs: introduce VLE decompression 
>>> subsystem:
>>>
>>> "The patchset is temporarily based on
>>> [RFC PATCH RESEND 11/12] erofs: introduce a customized LZ4 decompression
>>> The new unzip system is still _buggy_, not for _daily_ use!"
>>>
>>> which seems improper, sorry... I will take care and leave message at the 
>>> beginning from now on.
>> No problem, I think we can add revert patch for [PATCH 12/12] erofs: introduce a
>> customized LZ4 decompression, so that we can track erofs code change history
>> more clearly, and once you want to look into it or make code going back to the
>> old implementation, we can remove that revert patch later.
>>
>> The history will be only existed in current erofs dev branch, once the code is
>> pushed or merged by Linux or Android OS, it will invisible.
>>
>> Or you're sure about remove old implementation, let's do it...
>>
>> Thanks> 
> 
> I am also thinking about this yesterday, how about rebasing the following patches:
> 
> erofs: support tracepoint
> erofs: introduce error injection infrastructure
> erofs: introduce parse_options()
> erofs: support special inode
> erofs: remove unused EROFS_XATTR_INDEX_ADVISE
> erofs: fix to return correct value of alloc_inode
> erofs: fix to do endian conversion correctly
> erofs: fix missing endian conversion
> erofs: fix to avoid potential overflow
> erofs: fix compile error
> erofs: add the missing header <linux/prefetch.h>
> erofs: update SPDX-License-Identifier   <- Could we drop this patch temporarily?
>                                            Some files could be re-licensed in the future for mkfs,
>                                            especially the file "erofs_fs.h"

Okay,

> erofs: fix ifnullfree.cocci warnings
> 
> on "[RFC PATCH RESEND 11/12] erofs: introduce a customized LZ4 decompression temporarily"
> then apply [PATCH 12/12] and make the following patch on the top of [PATCH 12/12]
> erofs: fix to handle return value of erofs_init_page_bundle() correctly <-
> 
> "git am -k -3" could be a powerful way to get this done..

No problem.

> 
> In addition to that, we could have 2 choises to apply the new unzip subsystem:
> 1) We could revert [PATCH 12/12] and "erofs: fix to handle return value of erofs_init_page_bundle() correctly"
> and then apply the new patchset just as you said,
> or
> 2) Introduce a new 'dev-test' branch as Jaegeuk Kim's branch.

We can do both of them, let's treat erofs branch as master branch, and we can
split erofs-dev branch (dev-test will not be so obvious to indicate that branch
is belong to erofs, so let's use erofs-dev) from erofs branch for further
development.

So in erofs-dev, we can do anything temporarily change and testing, and once it
becomes stable, we can merge there-in patches back to erofs branch.

And for any old codes or implementation obsolescing in erofs branch, let's use
git-revert or remove codes in a separated patch instead of dropping a patch
directly. :)

How do you think?

Thanks,

> 
> Boths for me are ok. :)
> 
> Thanks,
> Gao Xiang
> 
> .
> 
