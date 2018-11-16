From: osandov@osandov.com (Omar Sandoval)
Date: Thu, 15 Nov 2018 16:21:57 -0800
Subject: [PATCH V10 07/19] btrfs: use bvec_last_segment to get bio's last
 page
In-Reply-To: <20181115085306.9910-8-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-8-ming.lei@redhat.com>
Message-ID: <20181116002157.GB23828@vader>

On Thu, Nov 15, 2018@04:52:54PM +0800, Ming Lei wrote:
> Preparing for supporting multi-page bvec.
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
>  fs/btrfs/compression.c | 5 ++++-
>  fs/btrfs/extent_io.c   | 5 +++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 2955a4ea2fa8..161e14b8b180 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -400,8 +400,11 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
>  static u64 bio_end_offset(struct bio *bio)
>  {
>  	struct bio_vec *last = bio_last_bvec_all(bio);
> +	struct bio_vec bv;
>  
> -	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
> +	bvec_last_segment(last, &bv);
> +
> +	return page_offset(bv.bv_page) + bv.bv_len + bv.bv_offset;
>  }
>  
>  static noinline int add_ra_bio_pages(struct inode *inode,
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d228f706ff3e..5d5965297e7e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2720,11 +2720,12 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
>  {
>  	blk_status_t ret = 0;
>  	struct bio_vec *bvec = bio_last_bvec_all(bio);
> -	struct page *page = bvec->bv_page;
> +	struct bio_vec bv;
>  	struct extent_io_tree *tree = bio->bi_private;
>  	u64 start;
>  
> -	start = page_offset(page) + bvec->bv_offset;
> +	bvec_last_segment(bvec, &bv);
> +	start = page_offset(bv.bv_page) + bv.bv_offset;
>  
>  	bio->bi_private = NULL;
>  
> -- 
> 2.9.5
> 
