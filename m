From: ming.lei@redhat.com (Ming Lei)
Date: Mon, 19 Nov 2018 16:39:22 +0800
Subject: [PATCH V10 13/19] iomap & xfs: only account for new added page
In-Reply-To: <20181116134936.GJ3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-14-ming.lei@redhat.com>
 <20181116134936.GJ3165@lst.de>
Message-ID: <20181119083921.GJ16736@ming.t460p>

On Fri, Nov 16, 2018@02:49:36PM +0100, Christoph Hellwig wrote:
> I'd much rather have __bio_try_merge_page only do merges in
> the same page, and have a new __bio_try_merge_segment that does
> multi-page merges.  This will keep the accounting a lot simpler.

Looks this way is clever, will do it in next version.

Thanks,
Ming
