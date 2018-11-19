From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 10:23:28 +0800
Subject: [PATCH V10 01/19] block: introduce multi-page page bvec helpers
In-Reply-To: <20181116131305.GA3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-2-ming.lei@redhat.com>
 <20181116131305.GA3165@lst.de>
Message-ID: <20181119022327.GC10838@ming.t460p>

On Fri, Nov 16, 2018@02:13:05PM +0100, Christoph Hellwig wrote:
> > -#define bvec_iter_page(bvec, iter)				\
> > +#define mp_bvec_iter_page(bvec, iter)				\
> >  	(__bvec_iter_bvec((bvec), (iter))->bv_page)
> >  
> > -#define bvec_iter_len(bvec, iter)				\
> > +#define mp_bvec_iter_len(bvec, iter)				\
> 
> I'd much prefer if we would stick to the segment naming that
> we also use in the higher level helper.
> 
> So segment_iter_page, segment_iter_len, etc.

We discussed the naming problem before, one big problem is that the 'segment'
in bio_for_each_segment*() means one single page segment actually.

If we use segment_iter_page() here for multi-page segment, it may
confuse people.

Of course, I prefer to the naming of segment/page, 

And Jens didn't agree to rename bio_for_each_segment*() before.

So what is the solution we should take for moving on?

> 
> > + * This helpers are for building sp bvec in flight.
> 
> Please spell out single page, sp is not easy understandable.

OK.

Thanks,
Ming
