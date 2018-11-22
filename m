From: andrea.parri@amarulasolutions.com (Andrea Parri)
Date: Thu, 22 Nov 2018 19:50:58 +0100
Subject: [PATCH 05/10] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <1d1fd688-0cb5-cbac-9213-f56f7e356bca@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-6-gaoxiang25@huawei.com>
 <20181122102230.GF3189@kroah.com>
 <1d1fd688-0cb5-cbac-9213-f56f7e356bca@huawei.com>
Message-ID: <20181122185058.GA3466@andrea>

On Thu, Nov 22, 2018@06:56:32PM +0800, Gao Xiang wrote:
> Hi Greg,
> 
> On 2018/11/22 18:22, Greg Kroah-Hartman wrote:
> > Please document this memory barrier.  It does not make much sense to
> > me...
> 
> Because we need to make the other observers noticing the latest values modified
> in this locking period before unfreezing the whole workgroup, one way is to use
> a memory barrier and the other way is to use ACQUIRE and RELEASE. we selected
> the first one.
> 
> Hmmm...ok, I will add a simple message to explain this, but I think that is
> plain enough for a lock...

Sympathizing with Greg's request, let me add some specific suggestions:

  1. It wouldn't hurt to indicate a pair of memory accesses which are
     intended to be "ordered" by the memory barrier in question (yes,
     this pair might not be unique, but you should be able to provide
     an example).

  2. Memory barriers always come matched by other memory barriers, or
     dependencies (it really does not make sense to talk about a full
     barrier "in isolation"): please also indicate (an instance of) a
     matching barrier or the matching barriers.

  3. How do the hardware threads communicate?  In the acquire/release
     pattern you mentioned above, the load-acquire *reads from* a/the
     previous store-release, a memory access that follows the acquire
     somehow communicate with a memory access preceding the release...

  4. It is a good practice to include the above information within an
     (inline) comment accompanying the added memory barrier (in fact,
     IIRC, checkpatch.pl gives you a "memory barrier without comment"
     warning when you omit to do so); not just in the commit message.

Hope this helps.  Please let me know if something I wrote is unclear,

  Andrea


> 
> Thanks,
> Gao Xiang
> 
> > 
> > thanks,
> > 
> > greg k-h
