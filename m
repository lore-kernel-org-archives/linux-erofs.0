From: andrea.parri@amarulasolutions.com (Andrea Parri)
Date: Fri, 23 Nov 2018 10:51:28 +0100
Subject: [PATCH 05/10] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <b2f367c5-a54c-9edf-42ad-d256bc725cf7@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-6-gaoxiang25@huawei.com>
 <20181122102230.GF3189@kroah.com>
 <1d1fd688-0cb5-cbac-9213-f56f7e356bca@huawei.com>
 <20181122185058.GA3466@andrea>
 <b2f367c5-a54c-9edf-42ad-d256bc725cf7@huawei.com>
Message-ID: <20181123094739.GA3487@andrea>

On Fri, Nov 23, 2018@10:51:33AM +0800, Gao Xiang wrote:
> Hi Andrea,
> 
> On 2018/11/23 2:50, Andrea Parri wrote:
> > On Thu, Nov 22, 2018@06:56:32PM +0800, Gao Xiang wrote:
> >> Hi Greg,
> >>
> >> On 2018/11/22 18:22, Greg Kroah-Hartman wrote:
> >>> Please document this memory barrier.  It does not make much sense to
> >>> me...
> >>
> >> Because we need to make the other observers noticing the latest values modified
> >> in this locking period before unfreezing the whole workgroup, one way is to use
> >> a memory barrier and the other way is to use ACQUIRE and RELEASE. we selected
> >> the first one.
> >>
> >> Hmmm...ok, I will add a simple message to explain this, but I think that is
> >> plain enough for a lock...
> > 
> > Sympathizing with Greg's request, let me add some specific suggestions:
> > 
> >   1. It wouldn't hurt to indicate a pair of memory accesses which are
> >      intended to be "ordered" by the memory barrier in question (yes,
> >      this pair might not be unique, but you should be able to provide
> >      an example).
> > 
> >   2. Memory barriers always come matched by other memory barriers, or
> >      dependencies (it really does not make sense to talk about a full
> >      barrier "in isolation"): please also indicate (an instance of) a
> >      matching barrier or the matching barriers.
> > 
> >   3. How do the hardware threads communicate?  In the acquire/release
> >      pattern you mentioned above, the load-acquire *reads from* a/the
> >      previous store-release, a memory access that follows the acquire
> >      somehow communicate with a memory access preceding the release...
> > 
> >   4. It is a good practice to include the above information within an
> >      (inline) comment accompanying the added memory barrier (in fact,
> >      IIRC, checkpatch.pl gives you a "memory barrier without comment"
> >      warning when you omit to do so); not just in the commit message.
> > 
> > Hope this helps.  Please let me know if something I wrote is unclear,
> 
> Thanks for taking time on the detailed explanation. I think it is helpful for me. :)
> And you are right, barriers should be in pairs, and I think I need to explain more:
> 
> 255 static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
> 256 {
> 257         int o;
> 258
> 259 repeat:
> 260         o = erofs_wait_on_workgroup_freezed(grp);
> 261
> 262         if (unlikely(o <= 0))
> 263                 return -1;
> 264
> 265         if (unlikely(atomic_cmpxchg(&grp->refcount, o, o + 1) != o)) <- *
> 266                 goto repeat;
>             imply a memory barrier here
> 267
> 268         *ocnt = o;
> 269         return 0;
> 270 }
> 
> I think atomic_cmpxchg implies a memory barrier semantics when the value comparison (*) succeeds...

Correct.  This is informally documented in Documentation/atomic_t.txt
and formalized within tools/memory-model/.


> 
> I don't know whether my understanding is correct, If I am wrong..please correct me, or
> I need to add more detailed code comments to explain in the code?

Yes, please; please review the above points (including 1. and 3.) and
try to address them with inline comments.  Maybe (if that matches the
*behavior*/guarantee you have in mind...) something like:

[in erofs_workgroup_unfreeze()]

	/*
	 * Orders the store/load to/from [???] and the store to
	 * ->refcount performed by the atomic_set() below.
	 *
	 * Matches the atomic_cmpxchg() in erofs_workgroup_get().
	 *
	 * Guarantees that if a successful atomic_cmpxchg() reads
	 * the value stored by the atomic_set() then [???].
	 */
	smp_mb();
	atomic_set(&grp->refcount, v);


[in erofs_workgroup_get()]

	/*
	 * Orders the load from ->refcount performed by the
	 * atomic_cmpxchg() below and the store/load [???].
	 *
	 * See the comment for the smp_mb() in
	 * erofs_workgroup_unfreeze().
	 */
	if (unlikely(atomic_cmpxchg(&grp->refcount, o, o + 1) != o))
		goto repeat;

Thanks,
  Andrea


> 
> Thanks,
> Gao Xiang
> 
> 
> > 
> >   Andrea
> > 
> > 
> >>
> >> Thanks,
> >> Gao Xiang
> >>
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
