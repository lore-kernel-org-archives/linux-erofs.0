From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 17:17:46 +0800
Subject: [PATCH V10 18/19] block: kill QUEUE_FLAG_NO_SG_MERGE
In-Reply-To: <20181116021811.GM23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-19-ming.lei@redhat.com>
 <20181116021811.GM23828@vader>
Message-ID: <20181119091746.GO16736@ming.t460p>

On Thu, Nov 15, 2018@06:18:11PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018@04:53:05PM +0800, Ming Lei wrote:
> > Since bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting"),
> > physical segment number is mainly figured out in blk_queue_split() for
> > fast path, and the flag of BIO_SEG_VALID is set there too.
> > 
> > Now only blk_recount_segments() and blk_recalc_rq_segments() use this
> > flag.
> > 
> > Basically blk_recount_segments() is bypassed in fast path given BIO_SEG_VALID
> > is set in blk_queue_split().
> > 
> > For another user of blk_recalc_rq_segments():
> > 
> > - run in partial completion branch of blk_update_request, which is an unusual case
> > 
> > - run in blk_cloned_rq_check_limits(), still not a big problem if the flag is killed
> > since dm-rq is the only user.
> > 
> > Multi-page bvec is enabled now, QUEUE_FLAG_NO_SG_MERGE doesn't make sense any more.
> 
> This commit message wasn't very clear. Is it the case that
> QUEUE_FLAG_NO_SG_MERGE is no longer set by any drivers?

OK, I will add the explanation to commit log in next version.

05f1dd53152173 (block: add queue flag for disabling SG merging) introduces this
flag for NVMe performance purpose only, so that merging to segment can
be bypassed for NVMe.

Actually this optimization was bypassed by 54efd50bfd873e2d (block: make
generic_make_request handle arbitrarily sized bios) and bdced438acd83ad83a6c
("block: setup bi_phys_segments after splitting").

Now segment computation can be very quick, given most of times one bvec
can be thought as one segment, so we can remove the flag.

thanks, 
Ming
