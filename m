From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 19:43:50 +0800
Subject: [PATCH 02/10] staging: erofs: fix race when the managed cache is
 enabled
In-Reply-To: <20181122110642.GE5287@kroah.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-3-gaoxiang25@huawei.com>
 <20181122101711.GA3189@kroah.com>
 <55aed87f-196e-9048-6aae-db09bc497664@huawei.com>
 <20181122110642.GE5287@kroah.com>
Message-ID: <78f8bed5-5f7f-8ca6-5d7a-3a94a2062425@huawei.com>

Hi Greg,

On 2018/11/22 19:06, Greg Kroah-Hartman wrote:
> On Thu, Nov 22, 2018@06:42:52PM +0800, Gao Xiang wrote:
>> Hi Greg,
>>
>> On 2018/11/22 18:17, Greg Kroah-Hartman wrote:
>>> Any specific reason why you are not using the refcount.h api instead of
>>> "doing it yourself" with atomic_inc/dec()?
>>>
>>> I'm not rejecting this, just curious.
>> As I explained in the previous email,
>> Re: [PATCH 04/10] staging: erofs: fix `erofs_workgroup_{try_to_freeze, unfreeze}'
>>
>> we need such a function when the value is >= 0, it plays as a refcount,
>> but when the refcount == EROFS_LOCKED_MAGIC (<0, but not 0 as refcount.h),
>> and actually there is no need to introduce a seperate spinlock_t because
>> we don't actually care about its performance (rarely locked). and
>> the corresponding struct is too large for now, we need to decrease its size.
> Why do you need to decrease the size?  How many of these structures are
> created?

As I said in the previous email, every compressed page will have a managed structure
called erofs_workgroup, and it is heavily allocated like page/inode/dentry in the erofs.

> 
> And you will care about the performance when a lock is being held, as is
> evident by your logic to try to fix those issues in this patch series.
> Using a "real" lock will solve all of that and keep you from having to
> implement it all "by hand".

The function is much like lockref (aligned_u64 lock_count;) with the exception as my previous email
explained.

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
