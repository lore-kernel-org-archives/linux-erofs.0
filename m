From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 18:11:40 -0800
Subject: [PATCH V10 17/19] block: don't use bio->bi_vcnt to figure out
 segment number
In-Reply-To: <20181115085306.9910-18-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-18-ming.lei@redhat.com>
Message-ID: <20181116021140.GL23828@vader>

On Thu, Nov 15, 2018@04:53:04PM +0800, Ming Lei wrote:
> It is wrong to use bio->bi_vcnt to figure out how many segments
> there are in the bio even though CLONED flag isn't set on this bio,
> because this bio may be splitted or advanced.
> 
> So always use bio_segments() in blk_recount_segments(), and it shouldn't
> cause any performance loss now because the physical segment number is figured
> out in blk_queue_split() and BIO_SEG_VALID is set meantime since
> bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting").
> 
> Cc: Dave Chinner <dchinner at redhat.com>
> Cc: Kent Overstreet <kent.overstreet at gmail.com>
> Fixes: 7f60dcaaf91 ("block: blk-merge: fix blk_recount_segments()")

>From what I can tell, the problem was originally introduced by
76d8137a3113 ("blk-merge: recaculate segment if it isn't less than max segments")

Is that right?

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
>  block/blk-merge.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index cb9f49bcfd36..153a659fde74 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -429,13 +429,7 @@ void blk_recalc_rq_segments(struct request *rq)
>  
>  void blk_recount_segments(struct request_queue *q, struct bio *bio)
>  {
> -	unsigned short seg_cnt;
> -
> -	/* estimate segment number by bi_vcnt for non-cloned bio */
> -	if (bio_flagged(bio, BIO_CLONED))
> -		seg_cnt = bio_segments(bio);
> -	else
> -		seg_cnt = bio->bi_vcnt;
> +	unsigned short seg_cnt = bio_segments(bio);
>  
>  	if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags) &&
>  			(seg_cnt < queue_max_segments(q)))
> -- 
> 2.9.5
> 
