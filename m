From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 11:35:14 +0800
Subject: [PATCH V10 01/19] block: introduce multi-page page bvec helpers
In-Reply-To: <83fb4102-bffe-41f1-c8d0-3bdf61fe0ba8@kernel.dk>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-2-ming.lei@redhat.com>
 <20181116131305.GA3165@lst.de> <20181119022327.GC10838@ming.t460p>
 <83fb4102-bffe-41f1-c8d0-3bdf61fe0ba8@kernel.dk>
Message-ID: <20181119033513.GF10838@ming.t460p>

On Sun, Nov 18, 2018@08:10:14PM -0700, Jens Axboe wrote:
> On 11/18/18 7:23 PM, Ming Lei wrote:
> > On Fri, Nov 16, 2018@02:13:05PM +0100, Christoph Hellwig wrote:
> >>> -#define bvec_iter_page(bvec, iter)				\
> >>> +#define mp_bvec_iter_page(bvec, iter)				\
> >>>  	(__bvec_iter_bvec((bvec), (iter))->bv_page)
> >>>  
> >>> -#define bvec_iter_len(bvec, iter)				\
> >>> +#define mp_bvec_iter_len(bvec, iter)				\
> >>
> >> I'd much prefer if we would stick to the segment naming that
> >> we also use in the higher level helper.
> >>
> >> So segment_iter_page, segment_iter_len, etc.
> > 
> > We discussed the naming problem before, one big problem is that the 'segment'
> > in bio_for_each_segment*() means one single page segment actually.
> > 
> > If we use segment_iter_page() here for multi-page segment, it may
> > confuse people.
> > 
> > Of course, I prefer to the naming of segment/page, 
> > 
> > And Jens didn't agree to rename bio_for_each_segment*() before.
> 
> I didn't like frivolous renaming (and I still don't), but mp_
> is horrible imho. Don't name these after the fact that they
> are done in conjunction with supporting multipage bvecs. That
> very fact will be irrelevant very soon

OK, so what is your suggestion for the naming issue?

Are you fine to use segment_iter_page() here? Then the term of 'segment'
may be interpreted as multi-page segment here, but as single-page in
bio_for_each_segment*().

thanks
Ming
