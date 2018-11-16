From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:33:14 +0100
Subject: [PATCH V10 04/19] block: use bio_for_each_bvec() to map sg
In-Reply-To: <20181115085306.9910-5-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-5-ming.lei@redhat.com>
Message-ID: <20181116133314.GC3165@lst.de>

> +	if (!*sg)
> +		return sglist;
> +	else {

No need for an else after an early return.
