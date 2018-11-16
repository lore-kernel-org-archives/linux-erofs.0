From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:58:03 +0100
Subject: [PATCH V10 18/19] block: kill QUEUE_FLAG_NO_SG_MERGE
In-Reply-To: <20181115085306.9910-19-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-19-ming.lei@redhat.com>
Message-ID: <20181116135803.GN3165@lst.de>

On Thu, Nov 15, 2018@04:53:05PM +0800, Ming Lei wrote:
> Since bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting"),
> physical segment number is mainly figured out in blk_queue_split() for
> fast path, and the flag of BIO_SEG_VALID is set there too.
> 
> Now only blk_recount_segments() and blk_recalc_rq_segments() use this
> flag.
> 
> Basically blk_recount_segments() is bypassed in fast path given BIO_SEG_VALID
> is set in blk_queue_split().
> 
> For another user of blk_recalc_rq_segments():
> 
> - run in partial completion branch of blk_update_request, which is an unusual case
> 
> - run in blk_cloned_rq_check_limits(), still not a big problem if the flag is killed
> since dm-rq is the only user.
> 
> Multi-page bvec is enabled now, QUEUE_FLAG_NO_SG_MERGE doesn't make sense any more.
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
>  block/blk-merge.c      | 31 ++++++-------------------------
>  block/blk-mq-debugfs.c |  1 -
>  block/blk-mq.c         |  3 ---
>  drivers/md/dm-table.c  | 13 -------------
>  include/linux/blkdev.h |  1 -
>  5 files changed, 6 insertions(+), 43 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 153a659fde74..06be298be332 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -351,8 +351,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio)
>  EXPORT_SYMBOL(blk_queue_split);
>  
>  static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
> -					     struct bio *bio,
> -					     bool no_sg_merge)
> +					     struct bio *bio)
>  {
>  	struct bio_vec bv, bvprv = { NULL };
>  	int cluster, prev = 0;
> @@ -379,13 +378,6 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  	nr_phys_segs = 0;
>  	for_each_bio(bio) {
>  		bio_for_each_bvec(bv, bio, iter) {
> -			/*
> -			 * If SG merging is disabled, each bio vector is
> -			 * a segment
> -			 */
> -			if (no_sg_merge)
> -				goto new_segment;
> -
>  			if (prev && cluster) {
>  				if (seg_size + bv.bv_len
>  				    > queue_max_segment_size(q))
> @@ -420,27 +412,16 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  
>  void blk_recalc_rq_segments(struct request *rq)
>  {
> -	bool no_sg_merge = !!test_bit(QUEUE_FLAG_NO_SG_MERGE,
> -			&rq->q->queue_flags);
> -
> -	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio,
> -			no_sg_merge);
> +	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio);

Can we rename __blk_recalc_rq_segments to blk_recalc_rq_segments
can kill the old blk_recalc_rq_segments now?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch at lst.de>
