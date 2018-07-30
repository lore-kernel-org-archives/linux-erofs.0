From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 30 Jul 2018 11:55:43 +0800
Subject: [PATCH 1/2] staging: erofs: fix compile error without built-in
 decompression support
In-Reply-To: <d5e4f0a5-c184-c4ac-d5dc-451488d6fd2d@huawei.com>
References: <1532761832-6964-1-git-send-email-gaoxiang25@huawei.com>
 <20180729053459.34140-1-hsiangkao@aol.com>
 <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>
 <614f3148-91ae-2a9a-f932-21e32e290717@huawei.com>
 <d5e4f0a5-c184-c4ac-d5dc-451488d6fd2d@huawei.com>
Message-ID: <db2def51-79ea-3368-fdb7-d901a93a8271@huawei.com>


On 2018/7/30 11:07, Chao Yu wrote:
>> It seems that Greg merged this patch to staging-next yesterday, since it is a urgent fix
>> (otherwise erofs cannot be compiled properly without CONFIG_EROFS_FS_ZIP, that is my fault).
>>
>> I wrote in a patch yesterday becuase all the modifications have the same root cause ----
>>     fix incorrect code snippets due to spilt code into small patches by mistake.
>>
>> But you are right, it is more proper to spilt into two patches, let me resend these patches later
>> (I don't know whether Greg will apply them... :-( sorry... )
>>
>> I think in order to reduce Greg's patchwork burden, we could quickly review patches internally in linux-erofs first,
>> tidy up in a patchset set and send to Greg in a series periodically (if patches are not urgent).
>>
>> How do you think about it?
> I agree with you, as we discussed offline, let's send patch to erofs mailing
> list for review first, and keep all developing patches in erofs-dev branch as
> long as possible, then periodically, submitting patches to Greg in batch, it can
> reduce unneeded modification in staging-next tree. For urgent fix, we can speed
> up the progress. :)
> 
> Thanks,
> 

Hi Greg,
Sorry about patch annoying... We will send patches in batch periodically after
"[PATCH] staging: erofs: use the wrapped PTR_ERR_OR_ZERO instead of open code".

Before that, We will review these patches in the linux-erofs mailing list first...


Hi Chao,
OK, I just send new patches as your suggestion, could you please review again?
(But I think it could not be re-merged by Greg's again... since no code changes,
but the following patches will be upstreamed as we disscussed this morning...)


And could you review '[PATCH] staging: erofs: use the wrapped PTR_ERR_OR_ZERO instead of open code'
I just sent in the morning?


Thanks,
Gao Xiang
