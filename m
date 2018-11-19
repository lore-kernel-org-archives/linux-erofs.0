From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 16:29:32 +0800
Subject: [PATCH V10 12/19] block: allow bio_for_each_segment_all() to
 iterate over multi-page bvec
In-Reply-To: <20181115124252.GP24115@twin.jikos.cz>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-13-ming.lei@redhat.com>
 <20181115124252.GP24115@twin.jikos.cz>
Message-ID: <20181119082931.GG16736@ming.t460p>

On Thu, Nov 15, 2018@01:42:52PM +0100, David Sterba wrote:
> On Thu, Nov 15, 2018@04:52:59PM +0800, Ming Lei wrote:
> > diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> > index 13ba2011a306..789b09ae402a 100644
> > --- a/block/blk-zoned.c
> > +++ b/block/blk-zoned.c
> > @@ -123,6 +123,7 @@ static int blk_report_zones(struct gendisk *disk, sector_t sector,
> >  	unsigned int z = 0, n, nrz = *nr_zones;
> >  	sector_t capacity = get_capacity(disk);
> >  	int ret;
> > +	struct bvec_iter_all iter_all;
> >  
> >  	while (z < nrz && sector < capacity) {
> >  		n = nrz - z;
> 
> iter_all is added but not used and I don't see any
> bio_for_each_segment_all for conversion in this function.

Good catch, will fix it in next version.

Thanks,
Ming
