From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 16:40:22 -0800
Subject: [PATCH V10 10/19] block: loop: pass multi-page bvec to iov_iter
In-Reply-To: <20181115085306.9910-11-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-11-ming.lei@redhat.com>
Message-ID: <20181116004022.GE23828@vader>

On Thu, Nov 15, 2018@04:52:57PM +0800, Ming Lei wrote:
> iov_iter is implemented with bvec itererator, so it is safe to pass
> multipage bvec to it, and this way is much more efficient than
> passing one page in each bvec.
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

Comments below.

> Signed-off-by: Ming Lei <ming.lei at redhat.com>
> ---
>  drivers/block/loop.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index bf6bc35aaf88..a3fd418ec637 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -515,16 +515,16 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  	struct bio *bio = rq->bio;
>  	struct file *file = lo->lo_backing_file;
>  	unsigned int offset;
> -	int segments = 0;
> +	int nr_bvec = 0;
>  	int ret;
>  
>  	if (rq->bio != rq->biotail) {
> -		struct req_iterator iter;
> +		struct bvec_iter iter;
>  		struct bio_vec tmp;
>  
>  		__rq_for_each_bio(bio, rq)
> -			segments += bio_segments(bio);
> -		bvec = kmalloc_array(segments, sizeof(struct bio_vec),
> +			nr_bvec += bio_bvecs(bio);
> +		bvec = kmalloc_array(nr_bvec, sizeof(struct bio_vec),
>  				     GFP_NOIO);
>  		if (!bvec)
>  			return -EIO;
> @@ -533,13 +533,14 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  		/*
>  		 * The bios of the request may be started from the middle of
>  		 * the 'bvec' because of bio splitting, so we can't directly
> -		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_segment
> +		 * copy bio->bi_iov_vec to new bvec. The bio_for_each_bvec
>  		 * API will take care of all details for us.
>  		 */
> -		rq_for_each_segment(tmp, rq, iter) {
> -			*bvec = tmp;
> -			bvec++;
> -		}
> +		__rq_for_each_bio(bio, rq)
> +			bio_for_each_bvec(tmp, bio, iter) {
> +				*bvec = tmp;
> +				bvec++;
> +			}

Even if they're not strictly necessary, could you please include the
curly braces for __rq_for_each_bio() here?

>  		bvec = cmd->bvec;
>  		offset = 0;
>  	} else {
> @@ -550,11 +551,11 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  		 */
>  		offset = bio->bi_iter.bi_bvec_done;
>  		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> -		segments = bio_segments(bio);
> +		nr_bvec = bio_bvecs(bio);

This scared me for a second, but it's fine to do here because we haven't
actually enabled multipage bvecs yet, right?

>  	}
>  	atomic_set(&cmd->ref, 2);
>  
> -	iov_iter_bvec(&iter, rw, bvec, segments, blk_rq_bytes(rq));
> +	iov_iter_bvec(&iter, rw, bvec, nr_bvec, blk_rq_bytes(rq));
>  	iter.iov_offset = offset;
>  
>  	cmd->iocb.ki_pos = pos;
> -- 
> 2.9.5
> 
