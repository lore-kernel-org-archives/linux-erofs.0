From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 14:18:47 -0800
Subject: [PATCH V10 03/19] block: use bio_for_each_bvec() to compute
 multi-page bvec count
In-Reply-To: <20181115210510.GA24908@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-4-ming.lei@redhat.com>
 <20181115202028.GC9348@vader> <20181115210510.GA24908@redhat.com>
Message-ID: <20181115221847.GD9348@vader>

On Thu, Nov 15, 2018@04:05:10PM -0500, Mike Snitzer wrote:
> On Thu, Nov 15 2018 at  3:20pm -0500,
> Omar Sandoval <osandov@osandov.com> wrote:
> 
> > On Thu, Nov 15, 2018@04:52:50PM +0800, Ming Lei wrote:
> > > First it is more efficient to use bio_for_each_bvec() in both
> > > blk_bio_segment_split() and __blk_recalc_rq_segments() to compute how
> > > many multi-page bvecs there are in the bio.
> > > 
> > > Secondly once bio_for_each_bvec() is used, the bvec may need to be
> > > splitted because its length can be very longer than max segment size,
> > > so we have to split the big bvec into several segments.
> > > 
> > > Thirdly when splitting multi-page bvec into segments, the max segment
> > > limit may be reached, so the bio split need to be considered under
> > > this situation too.
> > > 
> > > Cc: Dave Chinner <dchinner at redhat.com>
> > > Cc: Kent Overstreet <kent.overstreet at gmail.com>
> > > Cc: Mike Snitzer <snitzer at redhat.com>
> > > Cc: dm-devel at redhat.com
> > > Cc: Alexander Viro <viro at zeniv.linux.org.uk>
> > > Cc: linux-fsdevel at vger.kernel.org
> > > Cc: Shaohua Li <shli at kernel.org>
> > > Cc: linux-raid at vger.kernel.org
> > > Cc: linux-erofs at lists.ozlabs.org
> > > Cc: David Sterba <dsterba at suse.com>
> > > Cc: linux-btrfs at vger.kernel.org
> > > Cc: Darrick J. Wong <darrick.wong at oracle.com>
> > > Cc: linux-xfs at vger.kernel.org
> > > Cc: Gao Xiang <gaoxiang25 at huawei.com>
> > > Cc: Christoph Hellwig <hch at lst.de>
> > > Cc: Theodore Ts'o <tytso at mit.edu>
> > > Cc: linux-ext4 at vger.kernel.org
> > > Cc: Coly Li <colyli at suse.de>
> > > Cc: linux-bcache at vger.kernel.org
> > > Cc: Boaz Harrosh <ooo at electrozaur.com>
> > > Cc: Bob Peterson <rpeterso at redhat.com>
> > > Cc: cluster-devel at redhat.com
> > > Signed-off-by: Ming Lei <ming.lei at redhat.com>
> > > ---
> > >  block/blk-merge.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++---------
> > >  1 file changed, 76 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > > index 91b2af332a84..6f7deb94a23f 100644
> > > --- a/block/blk-merge.c
> > > +++ b/block/blk-merge.c
> > > @@ -160,6 +160,62 @@ static inline unsigned get_max_io_size(struct request_queue *q,
> > >  	return sectors;
> > >  }
> > >  
> > > +/*
> > > + * Split the bvec @bv into segments, and update all kinds of
> > > + * variables.
> > > + */
> > > +static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
> > > +		unsigned *nsegs, unsigned *last_seg_size,
> > > +		unsigned *front_seg_size, unsigned *sectors)
> > > +{
> > > +	bool need_split = false;
> > > +	unsigned len = bv->bv_len;
> > > +	unsigned total_len = 0;
> > > +	unsigned new_nsegs = 0, seg_size = 0;
> > 
> > "unsigned int" here and everywhere else.
> 
> Curious why?  I've wondered what govens use of "unsigned" vs "unsigned
> int" recently and haven't found _the_ reason to pick one over the other.

My only reason to prefer unsigned int is consistency. unsigned int is
much more common in the kernel:

$ ag --cc -s 'unsigned\s+int' | wc -l
129632
$ ag --cc -s 'unsigned\s+(?!char|short|int|long)' | wc -l
22435

checkpatch also warns on plain unsigned.
