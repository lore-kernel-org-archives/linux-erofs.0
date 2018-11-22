From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 22 Nov 2018 12:03:50 +0100
Subject: [PATCH 04/10] staging: erofs: fix
 `erofs_workgroup_{try_to_freeze, unfreeze}'
In-Reply-To: <ee829ce6-e59e-3ed6-b9a4-16c29c9eb59f@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-5-gaoxiang25@huawei.com>
 <20181122102155.GE3189@kroah.com>
 <ee829ce6-e59e-3ed6-b9a4-16c29c9eb59f@huawei.com>
Message-ID: <20181122110350.GB5287@kroah.com>

On Thu, Nov 22, 2018@06:29:34PM +0800, Gao Xiang wrote:
> Hi Greg,
> 
> On 2018/11/22 18:21, Greg Kroah-Hartman wrote:
> > On Tue, Nov 20, 2018@10:34:19PM +0800, Gao Xiang wrote:
> >> There are two minor issues in the current freeze interface:
> >>
> >>    1) Freeze interfaces have not related with CONFIG_DEBUG_SPINLOCK,
> >>       therefore fix the incorrect conditions;
> >>
> >>    2) For SMP platforms, it should also disable preemption before
> >>       doing atomic_cmpxchg in case that some high priority tasks
> >>       preempt between atomic_cmpxchg and disable_preempt, then spin
> >>       on the locked refcount later.
> > 
> > spinning on a refcount implies that you are trying to do your own type
> > of locking.  Why not use the in-kernel locking api instead?  It will
> > always do better than trying to do your own logic as the developers
> > there know locking across all types of cpus better than filesystem
> > developers :)
> 
> It is because refcount also plays a role as a spinlock on a specific value
> (== EROFS_LOCKED_MAGIC), no need to introduce such a value since the spin
> window is small.

Do not try to overload a reference count as a spinlock, you will run
into problems and in the end have to implement everything that the core
locking code has done.

Your use of this is highly suspect, what happens when you use a "real"
spinlock and a "real" reference count instead?  Those are two different
things from a logical point of view and you are mixing them together
which is odd.

thanks,

greg k-h
