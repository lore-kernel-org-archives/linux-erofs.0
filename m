From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:53:08 +0100
Subject: [PATCH V10 14/19] block: enable multipage bvecs
In-Reply-To: <20181115085306.9910-15-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-15-ming.lei@redhat.com>
Message-ID: <20181116135308.GK3165@lst.de>

> -
> -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> -			bv->bv_len += len;
> -			bio->bi_iter.bi_size += len;
> -			return true;
> -		}
> +		struct request_queue *q = NULL;
> +
> +		if (page == bv->bv_page && off == (bv->bv_offset + bv->bv_len)
> +				&& (off + len) <= PAGE_SIZE)

How could the page struct be the same, but the range beyond PAGE_SIZE
(at least with the existing callers)?

Also no need for the inner btraces, and the && always goes on the
first line.

> +		if (bio->bi_disk)
> +			q = bio->bi_disk->queue;
> +
> +		/* disable multi-page bvec too if cluster isn't enabled */
> +		if (!q || !blk_queue_cluster(q) ||
> +		    ((page_to_phys(bv->bv_page) + bv->bv_offset + bv->bv_len) !=
> +		     (page_to_phys(page) + off)))
> +			return false;
> + merge:
> +		bv->bv_len += len;
> +		bio->bi_iter.bi_size += len;
> +		return true;

Ok, this is scary, as it will give differen results depending on when
bi_disk is assigned.  But then again we shouldn't really do the cluster
check here, but rather when splitting the bio for the actual low-level
driver.

(and eventually we should kill this clustering setting off in favor
of our normal segment limits).
