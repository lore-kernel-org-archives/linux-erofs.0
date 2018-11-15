From: ming.lei@redhat.com (Ming Lei)
Date: Thu, 15 Nov 2018 16:52:58 +0800
Subject: [PATCH V10 11/19] bcache: avoid to use bio_for_each_segment_all() in
 bch_bio_alloc_pages()
In-Reply-To: <20181115085306.9910-1-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
Message-ID: <20181115085306.9910-12-ming.lei@redhat.com>

bch_bio_alloc_pages() is always called on one new bio, so it is safe
to access the bvec table directly. Given it is the only kind of this
case, open code the bvec table access since bio_for_each_segment_all()
will be changed to support for iterating over multipage bvec.

Cc: Dave Chinner <dchinner at redhat.com>
Cc: Kent Overstreet <kent.overstreet at gmail.com>
Acked-by: Coly Li <colyli at suse.de>
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
 drivers/md/bcache/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 20eddeac1531..8517aebcda2d 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -270,7 +270,7 @@ int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
 	int i;
 	struct bio_vec *bv;
 
-	bio_for_each_segment_all(bv, bio, i) {
+	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++) {
 		bv->bv_page = alloc_page(gfp_mask);
 		if (!bv->bv_page) {
 			while (--bv >= bio->bi_io_vec)
-- 
2.9.5
