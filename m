From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 30 Jul 2018 10:32:00 +0800
Subject: [PATCH 1/2] staging: erofs: fix compile error without built-in
 decompression support
In-Reply-To: <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>
References: <1532761832-6964-1-git-send-email-gaoxiang25@huawei.com>
 <20180729053459.34140-1-hsiangkao@aol.com>
 <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>
Message-ID: <614f3148-91ae-2a9a-f932-21e32e290717@huawei.com>

Hi Chao,

On 2018/7/30 10:07, Chao Yu wrote:
> On 2018/7/29 13:34, Gao Xiang via Linux-erofs wrote:
>> This patch fixes incorrect code snippets due to spilt code
>> into small patches by mistake.
>>
>> Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050747.html
>> Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050750.html
>> Reported-by: kbuild test robot <lkp at intel.com>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>>  I test several Kconfig option combinations and all these
>> combinations are successfully compiled.
>>
>> Hi Chao,
>>  Could you please review this two patches first before merging
>> into staging-next tree?
> Hi Xiang,
> 
> For this compiler issue, I think we only need to cover erofs_shrink_workstation
> with marco CONFIG_EROFS_FS_ZIP, other modification like symbol name change or
> relocate erofs_shrink_workstation are with other reason, so how about separate
> them into different patches?
> 
> Thanks,
> 

It seems that Greg merged this patch to staging-next yesterday, since it is a urgent fix
(otherwise erofs cannot be compiled properly without CONFIG_EROFS_FS_ZIP, that is my fault).

I wrote in a patch yesterday becuase all the modifications have the same root cause ----
    fix incorrect code snippets due to spilt code into small patches by mistake.

But you are right, it is more proper to spilt into two patches, let me resend these patches later
(I don't know whether Greg will apply them... :-( sorry... )

I think in order to reduce Greg's patchwork burden, we could quickly review patches internally in linux-erofs first,
tidy up in a patchset set and send to Greg in a series periodically (if patches are not urgent).

How do you think about it?

Thanks,
Gao Xiang
