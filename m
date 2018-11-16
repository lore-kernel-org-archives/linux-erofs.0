From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:38:45 +0100
Subject: [PATCH V10 08/19] btrfs: move bio_pages_all() to btrfs
In-Reply-To: <20181115085306.9910-9-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-9-ming.lei@redhat.com>
Message-ID: <20181116133845.GG3165@lst.de>

On Thu, Nov 15, 2018@04:52:55PM +0800, Ming Lei wrote:
> BTRFS is the only user of this helper, so move this helper into
> BTRFS, and implement it via bio_for_each_segment_all(), since
> bio->bi_vcnt may not equal to number of pages after multipage bvec
> is enabled.

btrfs only uses the value to check if it is larger than 1.  No amount
of multipage bio merging should ever make bi_vcnt go from 0 to 1 or
vice versa.
