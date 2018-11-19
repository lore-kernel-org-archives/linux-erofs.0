From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 17:06:46 +0800
Subject: [PATCH V10 17/19] block: don't use bio->bi_vcnt to figure out
 segment number
In-Reply-To: <20181116021140.GL23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-18-ming.lei@redhat.com>
 <20181116021140.GL23828@vader>
Message-ID: <20181119090645.GN16736@ming.t460p>

On Thu, Nov 15, 2018@06:11:40PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018@04:53:04PM +0800, Ming Lei wrote:
> > It is wrong to use bio->bi_vcnt to figure out how many segments
> > there are in the bio even though CLONED flag isn't set on this bio,
> > because this bio may be splitted or advanced.
> > 
> > So always use bio_segments() in blk_recount_segments(), and it shouldn't
> > cause any performance loss now because the physical segment number is figured
> > out in blk_queue_split() and BIO_SEG_VALID is set meantime since
> > bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting").
> > 
> > Cc: Dave Chinner <dchinner at redhat.com>
> > Cc: Kent Overstreet <kent.overstreet at gmail.com>
> > Fixes: 7f60dcaaf91 ("block: blk-merge: fix blk_recount_segments()")
> 
> From what I can tell, the problem was originally introduced by
> 76d8137a3113 ("blk-merge: recaculate segment if it isn't less than max segments")
> 
> Is that right?

Indeed, will update it in next version.

Thanks,
Ming
