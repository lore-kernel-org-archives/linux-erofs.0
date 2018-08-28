From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 28 Aug 2018 21:10:55 +0800
Subject: [PATCH] Revert "staging: erofs: disable compiling temporarile"
In-Reply-To: <20180828130559.GA5427@kroah.com>
References: <1535427588-69630-1-git-send-email-gaoxiang25@huawei.com>
 <20180828054444.GA4453@kroah.com>
 <0c701b3c-5553-cf4c-c0b3-ad151b84662c@huawei.com>
 <f12ae5df-3130-f293-5863-3d9ff0802e92@huawei.com>
 <20180828130559.GA5427@kroah.com>
Message-ID: <12034d69-befb-7981-0ebb-97a3015c01da@aol.com>

Hi Greg,

On 2018/8/28 21:05, Greg Kroah-Hartman wrote:
> On Tue, Aug 28, 2018@04:56:43PM +0800, Chao Yu wrote:
>> Hi Greg,
>>
>> On 2018/8/28 14:28, Gao Xiang wrote:
>>> Hi Greg,
>>>
>>> On 2018/8/28 13:44, Greg Kroah-Hartman wrote:
>>>> On Tue, Aug 28, 2018@11:39:48AM +0800, Gao Xiang wrote:
>>>>> This reverts commit 156c3df8d4db4e693c062978186f44079413d74d.
>>>>>
>>>>> Since XArray and the new mount apis aren't merged in 4.19-rc1
>>>>> merge window, the BROKEN mark can be reverted directly without
>>>>> any problems.
>>>>>
>>>>> Fixes: 156c3df8d4db ("staging: erofs: disable compiling temporarile")
>>>>> Cc: Matthew Wilcox <willy at infradead.org>
>>>>> Cc: David Howells <dhowells at redhat.com>
>>>>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>>>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>>>> ---
>>>>>
>>>>> Hi Greg,
>>>>>
>>>>>  Could you please apply this patch to enable EROFS from 4.19-rc2, thanks...
>>>>>
>>>>>  p.s. We would like to provide a more stable EROFS when linux-4.19 is out,
>>>>>       and there are also two patchsets (the one is already sent out by Chao
>>>>>       and me, the other is previewing in linux-erofs mailing list and it will
>>>>>       be sent out after gathering enough testdata and feedback from community
>>>>>       and carefully reviewed), could you also please consider applying these
>>>>>       two patchsets in the later 4.19-rc (both >2, or the first patchset
>>>>>       could be in rc2 in advance) if it is convenient to do so, or the next
>>>>>       4.20 is also ok...
>>>>>
>>>>>  LINK: https://lore.kernel.org/lkml/20180821144937.20555-1-chao at kernel.org/
>>>>>        https://lore.kernel.org/lkml/1535076160-99466-1-git-send-email-gaoxiang25 at huawei.com/
>>>>
>>>> I applied those patch sets to my -next branch already, right?  So those
>>>
>>> Yes, Thank you for applying those patches. :)
>>>
>>>> would be going into 4.20-rc1, it is time now for "bugfixes only" for
>>>> 4.19-final.
>>>>
>>>> So perhaps we should just leave it as "BROKEN" for now for 4.19 and add
>>>> this to my tree now and let people work on it for the next few months in
>>
>> I'm worry about that once we plan to reenable erofs in next x.xx-rc1, in the
>> merge window, if there are any other features change common api or structure in
>> vfs/mm/block, but related patch didn't cover erofs, that would make conflict
>> with erofs.
>>
>> So if that happens, we can just reminder them to cover erofs? or we should
>> handle this by just delay removing 'BROKEN' state?
>>
>> Thanks,
>>
>>>> linux-next so that 4.20 has a solid base to start with?
>>>>
>>>
>>> EROFS is be marked as "BROKEN" just because of conflict with
>>> XArray and the new mount apis, as Stephen Rothwell suggested in
>>>
>>> https://lore.kernel.org/lkml/20180802010705.24a72730 at canb.auug.org.au/
>>>
>>>> It might be easiest for Greg to add the disabling CONFIG_EROFS_FS patch
>>>> to the staging tree itself for his first pull request during the merge
>>>> window and then send a second pull request (after the vfs and maybe the
>>>> Xarray stuff has been merged by Linus) with these patches followed by a
>>>> revert of the disabling patch.
>>>
>>> But these two features was still discussing in the mailing list even at the
>>> last time of 4.19-rc1 merge window. I cannot decide whether they were eventually
>>> get merged in 4.19 or not. But it seems that it is regretful that linux-4.19
>>> is out without XArray and the new mount apis.
>>>
>>> Therefore, I think EROFS should work for linux-4.19 without any modification
>>> if just revert the BROKEN mark.
> 
> Ok, you are right, I'll go apply this.

I am so happy to see that, thanks for understanding :)

> 
>>> EROFS works fine with the 4.19-rc1 code except that it has some __GFP_NOFAIL
>>> and BUG_ONs on error handling paths and very rarely race between memory
>>> reclaiming and decompression... :( I personally think it is complete enough
>>> for people to test since it is an independent and staging filesystem driver (no
>>> other influence...) Anyway, removing EROFS BROKEN mark at 4.20 is also ok of course...
>>>
>>> On the other head, if XArray and the new mount apis is still pending for 4.20,
>>> should EROFS uses the same policy as Stephen suggested? I have no idea how to do next...
> 
> As the code is now part of the common tree that everyone works off of,
> any filesystem changes that happen will normally cover erofs as well.
> So this shouldn't be an issue anymore.
> 
That is so helpful for us... :)

Thanks,
Gao Xiang

> thanks,
> 
> greg k-h
> 
