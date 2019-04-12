From: hch@infradead.org (Christoph Hellwig)
Date: Fri, 12 Apr 2019 08:06:33 -0700
Subject: [PATCH] staging: erofs: fix unexpected out-of-bound data access
In-Reply-To: <20190411105555.133551-1-gaoxiang25@huawei.com>
References: <20190411105555.133551-1-gaoxiang25@huawei.com>
Message-ID: <20190412150633.GA20776@infradead.org>

> +++ b/drivers/staging/erofs/data.c
> @@ -304,7 +304,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
>  	*last_block = current_block;
>  
>  	/* shift in advance in case of it followed by too many gaps */
> -	if (unlikely(bio->bi_vcnt >= bio->bi_max_vecs)) {
> +	if (bio->bi_iter.bi_size >= bio->bi_max_vecs * PAGE_SIZE) {

This is still a very odd check.  bi_max_vecs * PAGE_SIZE is rather
arbitrary? and more importantly bi_max_vecs is not really a public
field, in fact this is the only place every using it outside the
core block layer.

I think the logic in this function should be reworked to what we
do elsewhere in the kernel, that is just add to the bio until
bio_add_page fails, in which case you submit the bio and start
a new one.  Then once you are done with your operation just submit
the bio.  Which unless I'm missing something is what the code does,
except for the goto loop obsfucation that is trying to hide it.

So why not something like:


diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 0714061ba888..122714e19079 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -296,20 +296,9 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 		}
 	}
 
-	err = bio_add_page(bio, page, PAGE_SIZE, 0);
-	/* out of the extent or bio is full */
-	if (err < PAGE_SIZE)
+	if (bio_add_page(bio, page, PAGE_SIZE, 0) != PAGE_SIZE)
 		goto submit_bio_retry;
-
 	*last_block = current_block;
-
-	/* shift in advance in case of it followed by too many gaps */
-	if (unlikely(bio->bi_vcnt >= bio->bi_max_vecs)) {
-		/* err should reassign to 0 after submitting */
-		err = 0;
-		goto submit_bio_out;
-	}
-
 	return bio;
 
 err_out:
@@ -323,9 +312,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 
 	/* if updated manually, continuous pages has a gap */
 	if (bio)
-submit_bio_out:
 		__submit_bio(bio, REQ_OP_READ, 0);
-
 	return unlikely(err) ? ERR_PTR(err) : NULL;
 }
 
@@ -387,8 +374,7 @@ static int erofs_raw_access_readpages(struct file *filp,
 	}
 	DBG_BUGON(!list_empty(pages));
 
-	/* the rare case (end in gaps) */
-	if (unlikely(bio))
+	if (bio)
 		__submit_bio(bio, REQ_OP_READ, 0);
 	return 0;
 }

>  		/* err should reassign to 0 after submitting */
>  		err = 0;
>  		goto submit_bio_out;
> -- 
> 2.17.1
> 
---end quoted text---
