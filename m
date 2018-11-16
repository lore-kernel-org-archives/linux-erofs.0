From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:45:41 +0100
Subject: [PATCH V10 09/19] block: introduce bio_bvecs()
In-Reply-To: <20181115085306.9910-10-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com>
Message-ID: <20181116134541.GH3165@lst.de>

On Thu, Nov 15, 2018@04:52:56PM +0800, Ming Lei wrote:
> There are still cases in which we need to use bio_bvecs() for get the
> number of multi-page segment, so introduce it.

The only user in your final tree seems to be the loop driver, and
even that one only uses the helper for read/write bios.

I think something like this would be much simpler in the end:

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d509902a8046..712511815ac6 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -514,16 +514,18 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
 	struct bio *bio = rq->bio;
 	struct file *file = lo->lo_backing_file;
+	struct bvec_iter bvec_iter;
+	struct bio_vec tmp;
 	unsigned int offset;
 	int nr_bvec = 0;
 	int ret;
 
+	__rq_for_each_bio(bio, rq)
+		bio_for_each_bvec(tmp, bio, bvec_iter)
+			nr_bvec++;
+
 	if (rq->bio != rq->biotail) {
-		struct bvec_iter iter;
-		struct bio_vec tmp;
 
-		__rq_for_each_bio(bio, rq)
-			nr_bvec += bio_bvecs(bio);
 		bvec = kmalloc_array(nr_bvec, sizeof(struct bio_vec),
 				     GFP_NOIO);
 		if (!bvec)
@@ -537,7 +539,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		 * API will take care of all details for us.
 		 */
 		__rq_for_each_bio(bio, rq)
-			bio_for_each_bvec(tmp, bio, iter) {
+			bio_for_each_bvec(tmp, bio, bvec_iter) {
 				*bvec = tmp;
 				bvec++;
 			}
@@ -551,7 +553,6 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		 */
 		offset = bio->bi_iter.bi_bvec_done;
 		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
-		nr_bvec = bio_bvecs(bio);
 	}
 	atomic_set(&cmd->ref, 2);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index dcad0b69f57a..379440d1ced0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -200,30 +200,6 @@ static inline unsigned bio_segments(struct bio *bio)
 	}
 }
 
-static inline unsigned bio_bvecs(struct bio *bio)
-{
-	unsigned bvecs = 0;
-	struct bio_vec bv;
-	struct bvec_iter iter;
-
-	/*
-	 * We special case discard/write same/write zeroes, because they
-	 * interpret bi_size differently:
-	 */
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		return 0;
-	case REQ_OP_WRITE_SAME:
-		return 1;
-	default:
-		bio_for_each_bvec(bv, bio, iter)
-			bvecs++;
-		return bvecs;
-	}
-}
-
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
  * something like:
