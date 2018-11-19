From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 16:27:23 +0800
Subject: [PATCH V10 11/19] bcache: avoid to use
 bio_for_each_segment_all() in bch_bio_alloc_pages()
In-Reply-To: <20181116004402.GF23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-12-ming.lei@redhat.com>
 <20181116004402.GF23828@vader>
Message-ID: <20181119082722.GE16736@ming.t460p>

On Thu, Nov 15, 2018@04:44:02PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018@04:52:58PM +0800, Ming Lei wrote:
> > bch_bio_alloc_pages() is always called on one new bio, so it is safe
> > to access the bvec table directly. Given it is the only kind of this
> > case, open code the bvec table access since bio_for_each_segment_all()
> > will be changed to support for iterating over multipage bvec.
> > 
> > Cc: Dave Chinner <dchinner at redhat.com>
> > Cc: Kent Overstreet <kent.overstreet at gmail.com>
> > Acked-by: Coly Li <colyli at suse.de>
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
> > Signed-off-by: Ming Lei <ming.lei at redhat.com>
> > ---
> >  drivers/md/bcache/util.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> > index 20eddeac1531..8517aebcda2d 100644
> > --- a/drivers/md/bcache/util.c
> > +++ b/drivers/md/bcache/util.c
> > @@ -270,7 +270,7 @@ int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
> >  	int i;
> >  	struct bio_vec *bv;
> >  
> > -	bio_for_each_segment_all(bv, bio, i) {
> > +	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++) {
> 
> This is missing an i++.

Good catch, will fix it in next version.

thanks,
Ming
