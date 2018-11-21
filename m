From: sagi@grimberg.me (Sagi Grimberg)
Date: Tue, 20 Nov 2018 19:20:45 -0800
Subject: [PATCH V10 09/19] block: introduce bio_bvecs()
In-Reply-To: <20181121005902.GA31748@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com> <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
 <20181121005902.GA31748@ming.t460p>
Message-ID: <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>


> Not sure I understand the 'blocking' problem in this case.
> 
> We can build a bvec table from this req, and send them all
> in send(),

I would like to avoid growing bvec tables and keep everything
preallocated. Plus, a bvec_iter operates on a bvec which means
we'll need a table there as well... Not liking it so far...

> can this way avoid your blocking issue? You may see this
> example in branch 'rq->bio != rq->biotail' of lo_rw_aio().

This is exactly an example of not ignoring the bios...

> If this way is what you need, I think you are right, even we may
> introduce the following helpers:
> 
> 	rq_for_each_bvec()
> 	rq_bvecs()

I'm not sure how this helps me either. Unless we can set a bvec_iter to
span bvecs or have an abstract bio crossing when we re-initialize the
bvec_iter I don't see how I can ignore bios completely...

> So looks nvme-tcp host driver might be the 2nd driver which benefits
> from multi-page bvec directly.
> 
> The multi-page bvec V11 has passed my tests and addressed almost
> all the comments during review on V10. I removed bio_vecs() in V11,
> but it won't be big deal, we can introduce them anytime when there
> is the requirement.

multipage-bvecs and nvme-tcp are going to conflict, so it would be good
to coordinate on this. I think that nvme-tcp host needs some adjustments
as setting a bvec_iter. I'm under the impression that the change is 
rather small and self-contained, but I'm not sure I have the full
picture here.
