From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 17:04:16 +0800
Subject: [PATCH V10 15/19] block: always define BIO_MAX_PAGES as 256
In-Reply-To: <20181116015936.GJ23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-16-ming.lei@redhat.com>
 <20181116015936.GJ23828@vader>
Message-ID: <20181119090415.GM16736@ming.t460p>

On Thu, Nov 15, 2018@05:59:36PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018@04:53:02PM +0800, Ming Lei wrote:
> > Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
> > increase BIO_MAX_PAGES for it.
> 
> You mentioned to it in the cover letter, but this needs more explanation
> in the commit message. Why did CONFIG_THP_SWAP require > 256? Why does
> multipage bvecs remove that requirement?

CONFIG_THP_SWAP needs to split one TH page into normal pages and adds
them all to one bio. With multipage-bvec, it just takes one bvec to
hold them all.

thanks,
Ming
