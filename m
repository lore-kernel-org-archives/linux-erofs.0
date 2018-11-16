From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 18:18:11 -0800
Subject: [PATCH V10 18/19] block: kill QUEUE_FLAG_NO_SG_MERGE
In-Reply-To: <20181115085306.9910-19-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-19-ming.lei@redhat.com>
Message-ID: <20181116021811.GM23828@vader>

On Thu, Nov 15, 2018@04:53:05PM +0800, Ming Lei wrote:
> Since bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting"),
> physical segment number is mainly figured out in blk_queue_split() for
> fast path, and the flag of BIO_SEG_VALID is set there too.
> 
> Now only blk_recount_segments() and blk_recalc_rq_segments() use this
> flag.
> 
> Basically blk_recount_segments() is bypassed in fast path given BIO_SEG_VALID
> is set in blk_queue_split().
> 
> For another user of blk_recalc_rq_segments():
> 
> - run in partial completion branch of blk_update_request, which is an unusual case
> 
> - run in blk_cloned_rq_check_limits(), still not a big problem if the flag is killed
> since dm-rq is the only user.
> 
> Multi-page bvec is enabled now, QUEUE_FLAG_NO_SG_MERGE doesn't make sense any more.

This commit message wasn't very clear. Is it the case that
QUEUE_FLAG_NO_SG_MERGE is no longer set by any drivers?
