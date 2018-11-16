From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:34:22 +0100
Subject: [PATCH V10 05/19] block: introduce bvec_last_segment()
In-Reply-To: <20181115085306.9910-6-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-6-ming.lei@redhat.com>
Message-ID: <20181116133422.GD3165@lst.de>

> +	unsigned last_page = total / PAGE_SIZE;
> +
> +	if (last_page * PAGE_SIZE == total)

Not sure it matters much with modern compilers, but generally
we shit by PAGE_SHIFT instead of multiplying with or dividing
by PAGE_SIZE.
