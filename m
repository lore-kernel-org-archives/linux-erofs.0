From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 15:51:55 +0800
Subject: [PATCH V10 04/19] block: use bio_for_each_bvec() to map sg
In-Reply-To: <20181116133314.GC3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-5-ming.lei@redhat.com>
 <20181116133314.GC3165@lst.de>
Message-ID: <20181119075154.GB16519@ming.t460p>

On Fri, Nov 16, 2018@02:33:14PM +0100, Christoph Hellwig wrote:
> > +	if (!*sg)
> > +		return sglist;
> > +	else {
> 
> No need for an else after an early return.

OK, good catch!

Thanks,
Ming
