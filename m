From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 12 Apr 2019 17:53:14 +0800
Subject: [PATCH v2] staging: erofs: fix unexpected out-of-bound data access
Message-ID: <20190412095314.224932-1-gaoxiang25@huawei.com>

Unexpected out-of-bound data will be read in erofs_read_raw_page
after commit 07173c3ec276 ("block: enable multipage bvecs") since
one iovec could have multiple pages.

Let's fix as what Ming's pointed out in the previous email [1].

[1] https://lore.kernel.org/lkml/20190411080953.GE421 at ming.t460p/

Suggested-by: Ming Lei <ming.lei at redhat.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v2:
 - fix commit message to link the discussion thread
   as pointed out by Chao;

* It should be fixed from linux-5.1-rc after enabling
  multi-page bvec feature.

Thanks,
Gao Xiang

 drivers/staging/erofs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 0714061ba888..c64ec76643d4 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -304,7 +304,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 	*last_block = current_block;
 
 	/* shift in advance in case of it followed by too many gaps */
-	if (unlikely(bio->bi_vcnt >= bio->bi_max_vecs)) {
+	if (bio->bi_iter.bi_size >= bio->bi_max_vecs * PAGE_SIZE) {
 		/* err should reassign to 0 after submitting */
 		err = 0;
 		goto submit_bio_out;
-- 
2.17.1
