From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 12:20:28 -0800
Subject: [PATCH V10 03/19] block: use bio_for_each_bvec() to compute
 multi-page bvec count
In-Reply-To: <20181115085306.9910-4-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-4-ming.lei@redhat.com>
Message-ID: <20181115202028.GC9348@vader>

On Thu, Nov 15, 2018@04:52:50PM +0800, Ming Lei wrote:
> First it is more efficient to use bio_for_each_bvec() in both
> blk_bio_segment_split() and __blk_recalc_rq_segments() to compute how
> many multi-page bvecs there are in the bio.
> 
> Secondly once bio_for_each_bvec() is used, the bvec may need to be
> splitted because its length can be very longer than max segment size,
> so we have to split the big bvec into several segments.
> 
> Thirdly when splitting multi-page bvec into segments, the max segment
> limit may be reached, so the bio split need to be considered under
> this situation too.
> 
> Cc: Dave Chinner <dchinner at redhat.com>
> Cc: Kent Overstreet <kent.overstreet at gmail.com>
> Cc: Mike Snitzer <snitzer at redhat.com>
> Cc: dm-devel at redhat.com
> Cc: Alexander Viro <viro at zeniv.linux.org.uk>
> Cc: linux-fsdevel at vger.kernel.org
> Cc: Shaohua Li <shli at kernel.org>
> Cc: linux-raid at vger.kernel.org
> Cc: linux-erofs at lists.ozlabs.org
> Cc: David Sterba <dsterba at suse.com>
> Cc: linux-btrfs at vger.kernel.org
> Cc: Darrick J. Wong <darrick.wong at oracle.com>
> Cc: linux-xfs at vger.kernel.org
> Cc: Gao Xiang <gaoxiang25 at huawei.com>
> Cc: Christoph Hellwig <hch at lst.de>
> Cc: Theodore Ts'o <tytso at mit.edu>
> Cc: linux-ext4 at vger.kernel.org
> Cc: Coly Li <colyli at suse.de>
> Cc: linux-bcache at vger.kernel.org
> Cc: Boaz Harrosh <ooo at electrozaur.com>
> Cc: Bob Peterson <rpeterso at redhat.com>
> Cc: cluster-devel at redhat.com
> Signed-off-by: Ming Lei <ming.lei at redhat.com>
> ---
>  block/blk-merge.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 76 insertions(+), 14 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 91b2af332a84..6f7deb94a23f 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -160,6 +160,62 @@ static inline unsigned get_max_io_size(struct request_queue *q,
>  	return sectors;
>  }
>  
> +/*
> + * Split the bvec @bv into segments, and update all kinds of
> + * variables.
> + */
> +static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
> +		unsigned *nsegs, unsigned *last_seg_size,
> +		unsigned *front_seg_size, unsigned *sectors)
> +{
> +	bool need_split = false;
> +	unsigned len = bv->bv_len;
> +	unsigned total_len = 0;
> +	unsigned new_nsegs = 0, seg_size = 0;

"unsigned int" here and everywhere else.

> +	if ((*nsegs >= queue_max_segments(q)) || !len)
> +		return need_split;
> +
> +	/*
> +	 * Multipage bvec may be too big to hold in one segment,
> +	 * so the current bvec has to be splitted as multiple
> +	 * segments.
> +	 */
> +	while (new_nsegs + *nsegs < queue_max_segments(q)) {
> +		seg_size = min(queue_max_segment_size(q), len);
> +
> +		new_nsegs++;
> +		total_len += seg_size;
> +		len -= seg_size;
> +
> +		if ((queue_virt_boundary(q) && ((bv->bv_offset +
> +		    total_len) & queue_virt_boundary(q))) || !len)
> +			break;

Checking queue_virt_boundary(q) != 0 is superfluous, and the len check
could just control the loop, i.e.,

	while (len && new_nsegs + *nsegs < queue_max_segments(q)) {
		seg_size = min(queue_max_segment_size(q), len);

		new_nsegs++;
		total_len += seg_size;
		len -= seg_size;

		if ((bv->bv_offset + total_len) & queue_virt_boundary(q))
			break;
	}

And if you rewrite it this way, I _think_ you can get rid of this
special case:

	if ((*nsegs >= queue_max_segments(q)) || !len)
		return need_split;

above.

> +	}
> +
> +	/* split in the middle of the bvec */
> +	if (len)
> +		need_split = true;

need_split is unnecessary, just return len != 0.

> +
> +	/* update front segment size */
> +	if (!*nsegs) {
> +		unsigned first_seg_size = seg_size;
> +
> +		if (new_nsegs > 1)
> +			first_seg_size = queue_max_segment_size(q);
> +		if (*front_seg_size < first_seg_size)
> +			*front_seg_size = first_seg_size;
> +	}
> +
> +	/* update other varibles */
> +	*last_seg_size = seg_size;
> +	*nsegs += new_nsegs;
> +	if (sectors)
> +		*sectors += total_len >> 9;
> +
> +	return need_split;
> +}
> +
>  static struct bio *blk_bio_segment_split(struct request_queue *q,
>  					 struct bio *bio,
>  					 struct bio_set *bs,
> @@ -173,7 +229,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  	struct bio *new = NULL;
>  	const unsigned max_sectors = get_max_io_size(q, bio);
>  
> -	bio_for_each_segment(bv, bio, iter) {
> +	bio_for_each_bvec(bv, bio, iter) {
>  		/*
>  		 * If the queue doesn't support SG gaps and adding this
>  		 * offset would create a gap, disallow it.
> @@ -188,8 +244,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  			 */
>  			if (nsegs < queue_max_segments(q) &&
>  			    sectors < max_sectors) {
> -				nsegs++;
> -				sectors = max_sectors;
> +				/* split in the middle of bvec */
> +				bv.bv_len = (max_sectors - sectors) << 9;
> +				bvec_split_segs(q, &bv, &nsegs,
> +						&seg_size,
> +						&front_seg_size,
> +						&sectors);
>  			}
>  			goto split;
>  		}
> @@ -214,11 +274,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  		if (nsegs == 1 && seg_size > front_seg_size)
>  			front_seg_size = seg_size;

Hm, do we still need to check this here now that we're updating
front_seg_size inside of bvec_split_segs()?

>  
> -		nsegs++;
>  		bvprv = bv;
>  		bvprvp = &bvprv;
> -		seg_size = bv.bv_len;
> -		sectors += bv.bv_len >> 9;
> +
> +		if (bvec_split_segs(q, &bv, &nsegs, &seg_size,
> +					&front_seg_size, &sectors))

What happened to the indent alignment here?

> +			goto split;
>  
>  	}
>  
> @@ -296,6 +357,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  	struct bio_vec bv, bvprv = { NULL };
>  	int cluster, prev = 0;
>  	unsigned int seg_size, nr_phys_segs;
> +	unsigned front_seg_size = bio->bi_seg_front_size;
>  	struct bio *fbio, *bbio;
>  	struct bvec_iter iter;
>  
> @@ -316,7 +378,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  	seg_size = 0;
>  	nr_phys_segs = 0;
>  	for_each_bio(bio) {
> -		bio_for_each_segment(bv, bio, iter) {
> +		bio_for_each_bvec(bv, bio, iter) {
>  			/*
>  			 * If SG merging is disabled, each bio vector is
>  			 * a segment
> @@ -336,20 +398,20 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  				continue;
>  			}
>  new_segment:
> -			if (nr_phys_segs == 1 && seg_size >
> -			    fbio->bi_seg_front_size)
> -				fbio->bi_seg_front_size = seg_size;
> +			if (nr_phys_segs == 1 && seg_size > front_seg_size)
> +				front_seg_size = seg_size;

Same comment as in blk_bio_segment_split(), do we still need to check
this if we're updating front_seg_size in bvec_split_segs()?

>  
> -			nr_phys_segs++;
>  			bvprv = bv;
>  			prev = 1;
> -			seg_size = bv.bv_len;
> +			bvec_split_segs(q, &bv, &nr_phys_segs, &seg_size,
> +					&front_seg_size, NULL);
>  		}
>  		bbio = bio;
>  	}
>  
> -	if (nr_phys_segs == 1 && seg_size > fbio->bi_seg_front_size)
> -		fbio->bi_seg_front_size = seg_size;
> +	if (nr_phys_segs == 1 && seg_size > front_seg_size)
> +		front_seg_size = seg_size;
> +	fbio->bi_seg_front_size = front_seg_size;
>  	if (seg_size > bbio->bi_seg_back_size)
>  		bbio->bi_seg_back_size = seg_size;
>  
> -- 
> 2.9.5
> 
