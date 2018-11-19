From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 15:57:21 +0800
Subject: [PATCH V10 05/19] block: introduce bvec_last_segment()
In-Reply-To: <20181115232356.GA23238@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-6-ming.lei@redhat.com>
 <20181115232356.GA23238@vader>
Message-ID: <20181119075720.GC16519@ming.t460p>

On Thu, Nov 15, 2018@03:23:56PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018@04:52:52PM +0800, Ming Lei wrote:
> > BTRFS and guard_bio_eod() need to get the last singlepage segment
> > from one multipage bvec, so introduce this helper to make them happy.
> > 
> > Cc: Dave Chinner <dchinner at redhat.com>
> > Cc: Kent Overstreet <kent.overstreet at gmail.com>
> > Cc: Mike Snitzer <snitzer at redhat.com>
> > Cc: dm-devel at redhat.com
> > Cc: Alexander Viro <viro at zeniv.linux.org.uk>
> > Cc: linux-fsdevel at vger.kernel.org
> > Cc: Shaohua Li <shli at kernel.org>
> > Cc: linux-raid at vger.kernel.org
> > Cc: linux-erofs at lists.ozlabs.org
> > Cc: David Sterba <dsterba at suse.com>
> > Cc: linux-btrfs at vger.kernel.org
> > Cc: Darrick J. Wong <darrick.wong at oracle.com>
> > Cc: linux-xfs at vger.kernel.org
> > Cc: Gao Xiang <gaoxiang25 at huawei.com>
> > Cc: Christoph Hellwig <hch at lst.de>
> > Cc: Theodore Ts'o <tytso at mit.edu>
> > Cc: linux-ext4 at vger.kernel.org
> > Cc: Coly Li <colyli at suse.de>
> > Cc: linux-bcache at vger.kernel.org
> > Cc: Boaz Harrosh <ooo at electrozaur.com>
> > Cc: Bob Peterson <rpeterso at redhat.com>
> > Cc: cluster-devel at redhat.com
> 
> Reviewed-by: Omar Sandoval <osandov at fb.com>
> 
> Minor comments below.
> 
> > Signed-off-by: Ming Lei <ming.lei at redhat.com>
> > ---
> >  include/linux/bvec.h | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> > index 3d61352cd8cf..01616a0b6220 100644
> > --- a/include/linux/bvec.h
> > +++ b/include/linux/bvec.h
> > @@ -216,4 +216,29 @@ static inline bool mp_bvec_iter_advance(const struct bio_vec *bv,
> >  	.bi_bvec_done	= 0,						\
> >  }
> >  
> > +/*
> > + * Get the last singlepage segment from the multipage bvec and store it
> > + * in @seg
> > + */
> > +static inline void bvec_last_segment(const struct bio_vec *bvec,
> > +		struct bio_vec *seg)
> 
> Indentation is all messed up here.

Will fix it.

> 
> > +{
> > +	unsigned total = bvec->bv_offset + bvec->bv_len;
> > +	unsigned last_page = total / PAGE_SIZE;
> > +
> > +	if (last_page * PAGE_SIZE == total)
> > +		last_page--;
> 
> I think this could just be
> 
> 	unsigned int last_page = (total - 1) / PAGE_SIZE;

This way is really elegant.

Thanks,
Ming
