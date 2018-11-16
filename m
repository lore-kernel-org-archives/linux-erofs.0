From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:13:05 +0100
Subject: [PATCH V10 01/19] block: introduce multi-page page bvec helpers
In-Reply-To: <20181115085306.9910-2-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-2-ming.lei@redhat.com>
Message-ID: <20181116131305.GA3165@lst.de>

> -#define bvec_iter_page(bvec, iter)				\
> +#define mp_bvec_iter_page(bvec, iter)				\
>  	(__bvec_iter_bvec((bvec), (iter))->bv_page)
>  
> -#define bvec_iter_len(bvec, iter)				\
> +#define mp_bvec_iter_len(bvec, iter)				\

I'd much prefer if we would stick to the segment naming that
we also use in the higher level helper.

So segment_iter_page, segment_iter_len, etc.

> + * This helpers are for building sp bvec in flight.

Please spell out single page, sp is not easy understandable.
