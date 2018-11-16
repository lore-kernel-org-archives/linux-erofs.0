From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 16:23:56 -0800
Subject: [PATCH V10 08/19] btrfs: move bio_pages_all() to btrfs
In-Reply-To: <20181115085306.9910-9-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-9-ming.lei@redhat.com>
Message-ID: <20181116002356.GC23828@vader>

On Thu, Nov 15, 2018@04:52:55PM +0800, Ming Lei wrote:
> BTRFS is the only user of this helper, so move this helper into
> BTRFS, and implement it via bio_for_each_segment_all(), since
> bio->bi_vcnt may not equal to number of pages after multipage bvec
> is enabled.

Shouldn't you also get rid of bio_pages_all() in this patch?

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
>  fs/btrfs/extent_io.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5d5965297e7e..874bb9aeebdc 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2348,6 +2348,18 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
>  	return bio;
>  }
>  
> +static unsigned btrfs_bio_pages_all(struct bio *bio)
> +{
> +	unsigned i;
> +	struct bio_vec *bv;
> +
> +	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
> +
> +	bio_for_each_segment_all(bv, bio, i)
> +		;
> +	return i;
> +}
> +
>  /*
>   * this is a generic handler for readpage errors (default
>   * readpage_io_failed_hook). if other copies exist, read those and write back
> @@ -2368,7 +2380,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
>  	int read_mode = 0;
>  	blk_status_t status;
>  	int ret;
> -	unsigned failed_bio_pages = bio_pages_all(failed_bio);
> +	unsigned failed_bio_pages = btrfs_bio_pages_all(failed_bio);
>  
>  	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
>  
> -- 
> 2.9.5
> 
