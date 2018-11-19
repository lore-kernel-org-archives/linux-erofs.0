From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 17:00:22 +0800
Subject: [PATCH V10 14/19] block: enable multipage bvecs
In-Reply-To: <20181116135308.GK3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-15-ming.lei@redhat.com>
 <20181116135308.GK3165@lst.de>
Message-ID: <20181119090021.GL16736@ming.t460p>

On Fri, Nov 16, 2018@02:53:08PM +0100, Christoph Hellwig wrote:
> > -
> > -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> > -			bv->bv_len += len;
> > -			bio->bi_iter.bi_size += len;
> > -			return true;
> > -		}
> > +		struct request_queue *q = NULL;
> > +
> > +		if (page == bv->bv_page && off == (bv->bv_offset + bv->bv_len)
> > +				&& (off + len) <= PAGE_SIZE)
> 
> How could the page struct be the same, but the range beyond PAGE_SIZE
> (at least with the existing callers)?
> 
> Also no need for the inner btraces, and the && always goes on the
> first line.

OK.

> 
> > +		if (bio->bi_disk)
> > +			q = bio->bi_disk->queue;
> > +
> > +		/* disable multi-page bvec too if cluster isn't enabled */
> > +		if (!q || !blk_queue_cluster(q) ||
> > +		    ((page_to_phys(bv->bv_page) + bv->bv_offset + bv->bv_len) !=
> > +		     (page_to_phys(page) + off)))
> > +			return false;
> > + merge:
> > +		bv->bv_len += len;
> > +		bio->bi_iter.bi_size += len;
> > +		return true;
> 
> Ok, this is scary, as it will give differen results depending on when
> bi_disk is assigned.

It is just merge or not, both can be handled well now.

> But then again we shouldn't really do the cluster
> check here, but rather when splitting the bio for the actual low-level
> driver.

Yeah, I thought of this way too, but it may cause tons of bio split for
no-clustering, and there are quite a few scsi devices which require
to disable clustering.

[linux]$ git grep -n DISABLE_CLUSTERING ./drivers/scsi/ | wc -l
     28

Or we may introduce bio_split_to_single_page_bvec() to allocate &
convert to single-page bvec table for non-clustering, will try this
approach in next version.

> 
> (and eventually we should kill this clustering setting off in favor
> of our normal segment limits).

Yeah, it has been in my post-multi-page todo list already, :-)

thanks,
Ming
