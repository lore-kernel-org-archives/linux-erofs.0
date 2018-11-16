From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 15:03:14 +0100
Subject: [PATCH V10 00/19] block: support multi-page bvec
In-Reply-To: <20181115085306.9910-1-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
Message-ID: <20181116140314.GA7735@lst.de>

It seems like bi_phys_segments is still around of this series.
Shouldn't it be superflous now?
