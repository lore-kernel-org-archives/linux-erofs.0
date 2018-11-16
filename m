From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:55:12 +0100
Subject: [PATCH V10 17/19] block: don't use bio->bi_vcnt to figure out
 segment number
In-Reply-To: <20181115085306.9910-18-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-18-ming.lei@redhat.com>
Message-ID: <20181116135512.GM3165@lst.de>

On Thu, Nov 15, 2018@04:53:04PM +0800, Ming Lei wrote:
> It is wrong to use bio->bi_vcnt to figure out how many segments
> there are in the bio even though CLONED flag isn't set on this bio,
> because this bio may be splitted or advanced.
> 
> So always use bio_segments() in blk_recount_segments(), and it shouldn't
> cause any performance loss now because the physical segment number is figured
> out in blk_queue_split() and BIO_SEG_VALID is set meantime since
> bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting").

Looks good, but shouldn't this go to the beginning of the series?

Reviewed-by: Christoph Hellwig <hch at lst.de>
