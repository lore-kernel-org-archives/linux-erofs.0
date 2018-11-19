From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 16:09:00 +0800
Subject: [PATCH V10 07/19] btrfs: use bvec_last_segment to get bio's last
 page
In-Reply-To: <20181116133710.GF3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-8-ming.lei@redhat.com>
 <20181116133710.GF3165@lst.de>
Message-ID: <20181119080854.GD16519@ming.t460p>

On Fri, Nov 16, 2018@02:37:10PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018@04:52:54PM +0800, Ming Lei wrote:
> > index 2955a4ea2fa8..161e14b8b180 100644
> > --- a/fs/btrfs/compression.c
> > +++ b/fs/btrfs/compression.c
> > @@ -400,8 +400,11 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
> >  static u64 bio_end_offset(struct bio *bio)
> >  {
> >  	struct bio_vec *last = bio_last_bvec_all(bio);
> > +	struct bio_vec bv;
> >  
> > -	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
> > +	bvec_last_segment(last, &bv);
> > +
> > +	return page_offset(bv.bv_page) + bv.bv_len + bv.bv_offset;
> 
> I don't think we need this.  If last is a multi-page bvec bv_offset
> will already contain the correct offset from the first page.

Yeah, it is true for this specific case, looks we can drop this patch.


thanks,
Ming
