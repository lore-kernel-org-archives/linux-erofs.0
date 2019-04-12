From: hch@infradead.org (Christoph Hellwig)
Date: Fri, 12 Apr 2019 08:10:03 -0700
Subject: [PATCH] staging: erofs: fix unexpected out-of-bound data access
In-Reply-To: <20190412150633.GA20776@infradead.org>
References: <20190411105555.133551-1-gaoxiang25@huawei.com>
 <20190412150633.GA20776@infradead.org>
Message-ID: <20190412151003.GA6990@infradead.org>

On Fri, Apr 12, 2019@08:06:33AM -0700, Christoph Hellwig wrote:
> > +++ b/drivers/staging/erofs/data.c
> > @@ -304,7 +304,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
> >  	*last_block = current_block;
> >  
> >  	/* shift in advance in case of it followed by too many gaps */
> > -	if (unlikely(bio->bi_vcnt >= bio->bi_max_vecs)) {
> > +	if (bio->bi_iter.bi_size >= bio->bi_max_vecs * PAGE_SIZE) {
> 
> This is still a very odd check.  bi_max_vecs * PAGE_SIZE is rather
> arbitrary? and more importantly bi_max_vecs is not really a public
> field, in fact this is the only place every using it outside the
> core block layer.
> 
> I think the logic in this function should be reworked to what we
> do elsewhere in the kernel, that is just add to the bio until
> bio_add_page fails, in which case you submit the bio and start
> a new one.  Then once you are done with your operation just submit
> the bio.  Which unless I'm missing something is what the code does,
> except for the goto loop obsfucation that is trying to hide it.
> 
> So why not something like:

And looking at this a little more - I think you should drop the
erofs raw ops entirely.  The iomap-based readpage and readpages
from fs/iomap.c should serve your needs just fine without all that
duplication.  The only thing missing is the cleancache calls,
which could easily be added.
