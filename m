From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 16:15:09 +0800
Subject: [PATCH V10 08/19] btrfs: move bio_pages_all() to btrfs
In-Reply-To: <20181116002356.GC23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-9-ming.lei@redhat.com>
 <20181116002356.GC23828@vader>
Message-ID: <20181119081507.GA16736@ming.t460p>

On Thu, Nov 15, 2018@04:23:56PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018@04:52:55PM +0800, Ming Lei wrote:
> > BTRFS is the only user of this helper, so move this helper into
> > BTRFS, and implement it via bio_for_each_segment_all(), since
> > bio->bi_vcnt may not equal to number of pages after multipage bvec
> > is enabled.
> 
> Shouldn't you also get rid of bio_pages_all() in this patch?

Good catch!

thanks,
Ming
