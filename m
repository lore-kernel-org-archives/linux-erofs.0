From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 16:28:20 +0800
Subject: [PATCH V10 11/19] bcache: avoid to use
 bio_for_each_segment_all() in bch_bio_alloc_pages()
In-Reply-To: <20181116134645.GI3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-12-ming.lei@redhat.com>
 <20181116134645.GI3165@lst.de>
Message-ID: <20181119082818.GF16736@ming.t460p>

On Fri, Nov 16, 2018@02:46:45PM +0100, Christoph Hellwig wrote:
> > -	bio_for_each_segment_all(bv, bio, i) {
> > +	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++) {
> 
> This really needs a comment.  Otherwise it looks fine to me.

OK, will do it in next version.

Thanks,
Ming
