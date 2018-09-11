From: chao@kernel.org (Chao Yu)
Date: Wed, 12 Sep 2018 00:46:12 +0800
Subject: [PATCH v4] staging: erofs: use explicit unsigned int type
In-Reply-To: <20180910194114.13314-1-linux@weissschuh.net>
References: <23218dc6-8aba-a4e6-7c18-64380082f747@kernel.org>
 <20180910194114.13314-1-linux@weissschuh.net>
Message-ID: <1b6fcc86-5b0c-e5b3-15de-63938222213e@kernel.org>

On 2018/9/11 3:41, Thomas Wei?schuh wrote:
> Hi Chao,
> 
> On Mon, 2018-09-10T23:59+0800, Chao Yu wrote:
>> [...]
> 
>>>> I was not aware of this tree and worked off of staging / next.
>>>> A patch is attached to this message that adds the tree to the MAINTAINERS file.
>>>
>>> Hi Chao,
>>>
>>> I think this tree has some PREVIEW patches which preview in linux-erofs mailing list only and
>>> doesn't send to staging mailing list and LKML,
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git/log/?h=erofs
>>>
>>> so erofs tree is actually Greg's staging tree.
>>
>> Thomas,
>>
>> I confirmed that erofs git repository for linux upstream is Greg's staging tree.
>>
>> Let me explain, in order to avoid sending buggy or preview patch, Xiang and me
>> plan to review patches in erofs mailing list first, and then cache reviewed
>> patches in my git tree before sending them to Greg and staging mailing list.
>>
>> Based on that, I'm trying to serialize all erofs patches, expecting that can
>> help those patches sent to staging mailing list can be merged by Greg with
>> lesser conflict. But I made a mistake that my erofs branch has merged some
>> pending patches, result in failing to merge yours, that mislead me to ask you to
>> rebase the code, sorry about that.
> 
> Thank you for clearing this up! And I am sorry for causing you all this work
> for what is essentially a very small style cleanup.
> 
>> Now I can confirm that your v2 patch can apply on Greg's staging-next, so fixing
>> warning reported by checkpatch.pl on your v2 patch is enough. :)
> 
> The patch follows.
> 
> Thomas
> 
> 
> Changes since v1:
> 
> * Removed changes that conflicted with
>   [PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c
> * Added patch description
> 
> Changes since v2:
> 
> * Fixed conflicts with other patchsets
> * Don't introduce new style issues
> 
> Changes since v3:
> 
> * Fixed conflicts with other patchsets
> 
> Note: This patchset should be applied with the "git am --scissors", to
> remove the historic information and this note.
> 
> -- >8 --
> 
> Fix coding style issue "Prefer 'unsigned int' to bare use of 'unsigned'"
> detected by checkpatch.pl.
> 
> Signed-off-by: Thomas Wei?schuh <linux at weissschuh.net>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
