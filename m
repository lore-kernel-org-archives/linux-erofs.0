From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 16:26:25 -0800
Subject: [PATCH V10 09/19] block: introduce bio_bvecs()
In-Reply-To: <20181115085306.9910-10-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com>
Message-ID: <20181116002625.GD23828@vader>

On Thu, Nov 15, 2018@04:52:56PM +0800, Ming Lei wrote:
> There are still cases in which we need to use bio_bvecs() for get the
> number of multi-page segment, so introduce it.
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
>  include/linux/bio.h | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 1f0dcf109841..3496c816946e 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -196,7 +196,6 @@ static inline unsigned bio_segments(struct bio *bio)
>  	 * We special case discard/write same/write zeroes, because they
>  	 * interpret bi_size differently:
>  	 */
> -
>  	switch (bio_op(bio)) {
>  	case REQ_OP_DISCARD:
>  	case REQ_OP_SECURE_ERASE:
> @@ -205,13 +204,34 @@ static inline unsigned bio_segments(struct bio *bio)
>  	case REQ_OP_WRITE_SAME:
>  		return 1;
>  	default:
> -		break;
> +		bio_for_each_segment(bv, bio, iter)
> +			segs++;
> +		return segs;
>  	}
> +}
>  
> -	bio_for_each_segment(bv, bio, iter)
> -		segs++;
> +static inline unsigned bio_bvecs(struct bio *bio)
> +{
> +	unsigned bvecs = 0;
> +	struct bio_vec bv;
> +	struct bvec_iter iter;
>  
> -	return segs;
> +	/*
> +	 * We special case discard/write same/write zeroes, because they
> +	 * interpret bi_size differently:
> +	 */
> +	switch (bio_op(bio)) {
> +	case REQ_OP_DISCARD:
> +	case REQ_OP_SECURE_ERASE:
> +	case REQ_OP_WRITE_ZEROES:
> +		return 0;
> +	case REQ_OP_WRITE_SAME:
> +		return 1;
> +	default:
> +		bio_for_each_bvec(bv, bio, iter)
> +			bvecs++;
> +		return bvecs;
> +	}
>  }
>  
>  /*
> -- 
> 2.9.5
> 
