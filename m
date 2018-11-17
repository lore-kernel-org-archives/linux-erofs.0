From: ming.lei@redhat.com (Ming Lei)
Date: Sat, 17 Nov 2018 10:42:11 +0800
Subject: [PATCH V10 00/19] block: support multi-page bvec
In-Reply-To: <20181116140314.GA7735@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181116140314.GA7735@lst.de>
Message-ID: <20181117024209.GD8872@ming.t460p>

On Fri, Nov 16, 2018@03:03:14PM +0100, Christoph Hellwig wrote:
> It seems like bi_phys_segments is still around of this series.
> Shouldn't it be superflous now?

Even though multi-page bvec is supported, the segment number doesn't
equal to the actual bvec count yet, for example, one bvec may be too
bigger to be held in one single segment.


Thanks,
Ming
