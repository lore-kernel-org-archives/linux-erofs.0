From: ming.lei@redhat.com (Ming Lei)
Date: Thu, 15 Nov 2018 16:53:01 +0800
Subject: [PATCH V10 14/19] block: enable multipage bvecs
In-Reply-To: <20181115085306.9910-1-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
Message-ID: <20181115085306.9910-15-ming.lei@redhat.com>

This patch pulls the trigger for multi-page bvecs.

Now any request queue which supports queue cluster will see multi-page
bvecs.

Cc: Dave Chinner <dchinner at redhat.com>
Cc: Kent Overstreet <kent.overstreet at gmail.com>
Cc: Mike Snitzer <snitzer at redhat.com>
Cc: dm-devel at redhat.com
Cc: Alexander Viro <viro at zeniv.linux.org.uk>
Cc: linux-fsdevel at vger.kernel.org
Cc: Shaohua Li <shli at kernel.org>
Cc: linux-raid at vger.kernel.org
Cc: linux-erofs at lists.ozlabs.org
Cc: David Sterba <dsterba at suse.com>
Cc: linux-btrfs at vger.kernel.org
Cc: Darrick J. Wong <darrick.wong at oracle.com>
Cc: linux-xfs at vger.kernel.org
Cc: Gao Xiang <gaoxiang25 at huawei.com>
Cc: Christoph Hellwig <hch at lst.de>
Cc: Theodore Ts'o <tytso at mit.edu>
Cc: linux-ext4 at vger.kernel.org
Cc: Coly Li <colyli at suse.de>
Cc: linux-bcache at vger.kernel.org
Cc: Boaz Harrosh <ooo at electrozaur.com>
Cc: Bob Peterson <rpeterso at redhat.com>
Cc: cluster-devel at redhat.com
Signed-off-by: Ming Lei <ming.lei at redhat.com>
---
 block/bio.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 6486722d4d4b..ed6df6f8e63d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -767,12 +767,24 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
-
-		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
-			bv->bv_len += len;
-			bio->bi_iter.bi_size += len;
-			return true;
-		}
+		struct request_queue *q = NULL;
+
+		if (page == bv->bv_page && off == (bv->bv_offset + bv->bv_len)
+				&& (off + len) <= PAGE_SIZE)
+			goto merge;
+
+		if (bio->bi_disk)
+			q = bio->bi_disk->queue;
+
+		/* disable multi-page bvec too if cluster isn't enabled */
+		if (!q || !blk_queue_cluster(q) ||
+		    ((page_to_phys(bv->bv_page) + bv->bv_offset + bv->bv_len) !=
+		     (page_to_phys(page) + off)))
+			return false;
+ merge:
+		bv->bv_len += len;
+		bio->bi_iter.bi_size += len;
+		return true;
 	}
 	return false;
 }
-- 
2.9.5
