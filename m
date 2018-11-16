From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:46:45 +0100
Subject: [PATCH V10 11/19] bcache: avoid to use
 bio_for_each_segment_all() in bch_bio_alloc_pages()
In-Reply-To: <20181115085306.9910-12-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-12-ming.lei@redhat.com>
Message-ID: <20181116134645.GI3165@lst.de>

> -	bio_for_each_segment_all(bv, bio, i) {
> +	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++) {

This really needs a comment.  Otherwise it looks fine to me.
