From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 14:33:58 -0800
Subject: [PATCH V10 04/19] block: use bio_for_each_bvec() to map sg
In-Reply-To: <20181115085306.9910-5-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-5-ming.lei@redhat.com>
Message-ID: <20181115223358.GE9348@vader>

On Thu, Nov 15, 2018@04:52:51PM +0800, Ming Lei wrote:
> It is more efficient to use bio_for_each_bvec() to map sg, meantime
> we have to consider splitting multipage bvec as done in blk_bio_segment_split().
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

Reviewed-by: Omar Sandoval <osandov at fb.com>

> Signed-off-by: Ming Lei <ming.lei at redhat.com>
> ---
>  block/blk-merge.c | 72 +++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 52 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 6f7deb94a23f..cb9f49bcfd36 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -473,6 +473,56 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
>  	return biovec_phys_mergeable(q, &end_bv, &nxt_bv);
>  }
>  
> +static struct scatterlist *blk_next_sg(struct scatterlist **sg,
> +		struct scatterlist *sglist)
> +{
> +	if (!*sg)
> +		return sglist;
> +	else {
> +		/*
> +		 * If the driver previously mapped a shorter
> +		 * list, we could see a termination bit
> +		 * prematurely unless it fully inits the sg
> +		 * table on each mapping. We KNOW that there
> +		 * must be more entries here or the driver
> +		 * would be buggy, so force clear the
> +		 * termination bit to avoid doing a full
> +		 * sg_init_table() in drivers for each command.
> +		 */
> +		sg_unmark_end(*sg);
> +		return sg_next(*sg);
> +	}
> +}
> +
> +static unsigned blk_bvec_map_sg(struct request_queue *q,
> +		struct bio_vec *bvec, struct scatterlist *sglist,
> +		struct scatterlist **sg)
> +{
> +	unsigned nbytes = bvec->bv_len;
> +	unsigned nsegs = 0, total = 0;
> +
> +	while (nbytes > 0) {
> +		unsigned seg_size;
> +		struct page *pg;
> +		unsigned offset, idx;
> +
> +		*sg = blk_next_sg(sg, sglist);
> +
> +		seg_size = min(nbytes, queue_max_segment_size(q));
> +		offset = (total + bvec->bv_offset) % PAGE_SIZE;
> +		idx = (total + bvec->bv_offset) / PAGE_SIZE;
> +		pg = nth_page(bvec->bv_page, idx);
> +
> +		sg_set_page(*sg, pg, seg_size, offset);
> +
> +		total += seg_size;
> +		nbytes -= seg_size;
> +		nsegs++;
> +	}
> +
> +	return nsegs;
> +}
> +
>  static inline void
>  __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
>  		     struct scatterlist *sglist, struct bio_vec *bvprv,
> @@ -490,25 +540,7 @@ __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
>  		(*sg)->length += nbytes;
>  	} else {
>  new_segment:
> -		if (!*sg)
> -			*sg = sglist;
> -		else {
> -			/*
> -			 * If the driver previously mapped a shorter
> -			 * list, we could see a termination bit
> -			 * prematurely unless it fully inits the sg
> -			 * table on each mapping. We KNOW that there
> -			 * must be more entries here or the driver
> -			 * would be buggy, so force clear the
> -			 * termination bit to avoid doing a full
> -			 * sg_init_table() in drivers for each command.
> -			 */
> -			sg_unmark_end(*sg);
> -			*sg = sg_next(*sg);
> -		}
> -
> -		sg_set_page(*sg, bvec->bv_page, nbytes, bvec->bv_offset);
> -		(*nsegs)++;
> +		(*nsegs) += blk_bvec_map_sg(q, bvec, sglist, sg);
>  	}
>  	*bvprv = *bvec;
>  }
> @@ -530,7 +562,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
>  	int cluster = blk_queue_cluster(q), nsegs = 0;
>  
>  	for_each_bio(bio)
> -		bio_for_each_segment(bvec, bio, iter)
> +		bio_for_each_bvec(bvec, bio, iter)
>  			__blk_segment_map_sg(q, &bvec, sglist, &bvprv, sg,
>  					     &nsegs, &cluster);
>  
> -- 
> 2.9.5
> 
