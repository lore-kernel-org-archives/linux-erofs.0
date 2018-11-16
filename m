From: osandov@osandov.com (Omar Sandoval)
Date: Fri, 16 Nov 2018 08:40:51 -0800
Subject: [PATCH V10 19/19] block: kill BLK_MQ_F_SG_MERGE
In-Reply-To: <20181115085306.9910-20-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-20-ming.lei@redhat.com>
Message-ID: <20181116164051.GX23828@vader>

On Thu, Nov 15, 2018@04:53:06PM +0800, Ming Lei wrote:
> QUEUE_FLAG_NO_SG_MERGE has been killed, so kill BLK_MQ_F_SG_MERGE too.
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
>  block/blk-mq-debugfs.c       | 1 -
>  drivers/block/loop.c         | 2 +-
>  drivers/block/nbd.c          | 2 +-
>  drivers/block/rbd.c          | 2 +-
>  drivers/block/skd_main.c     | 1 -
>  drivers/block/xen-blkfront.c | 2 +-
>  drivers/md/dm-rq.c           | 2 +-
>  drivers/mmc/core/queue.c     | 3 +--
>  drivers/scsi/scsi_lib.c      | 2 +-
>  include/linux/blk-mq.h       | 1 -
>  10 files changed, 7 insertions(+), 11 deletions(-)

[snip]
