From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 18:29:34 +0800
Subject: [PATCH 04/10] staging: erofs: fix
 `erofs_workgroup_{try_to_freeze, unfreeze}'
In-Reply-To: <20181122102155.GE3189@kroah.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-5-gaoxiang25@huawei.com>
 <20181122102155.GE3189@kroah.com>
Message-ID: <ee829ce6-e59e-3ed6-b9a4-16c29c9eb59f@huawei.com>

Hi Greg,

On 2018/11/22 18:21, Greg Kroah-Hartman wrote:
> On Tue, Nov 20, 2018@10:34:19PM +0800, Gao Xiang wrote:
>> There are two minor issues in the current freeze interface:
>>
>>    1) Freeze interfaces have not related with CONFIG_DEBUG_SPINLOCK,
>>       therefore fix the incorrect conditions;
>>
>>    2) For SMP platforms, it should also disable preemption before
>>       doing atomic_cmpxchg in case that some high priority tasks
>>       preempt between atomic_cmpxchg and disable_preempt, then spin
>>       on the locked refcount later.
> 
> spinning on a refcount implies that you are trying to do your own type
> of locking.  Why not use the in-kernel locking api instead?  It will
> always do better than trying to do your own logic as the developers
> there know locking across all types of cpus better than filesystem
> developers :)

It is because refcount also plays a role as a spinlock on a specific value
(== EROFS_LOCKED_MAGIC), no need to introduce such a value since the spin
window is small.

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 
