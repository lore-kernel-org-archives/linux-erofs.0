From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:49:36 +0100
Subject: [PATCH V10 13/19] iomap & xfs: only account for new added page
In-Reply-To: <20181115085306.9910-14-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-14-ming.lei@redhat.com>
Message-ID: <20181116134936.GJ3165@lst.de>

I'd much rather have __bio_try_merge_page only do merges in
the same page, and have a new __bio_try_merge_segment that does
multi-page merges.  This will keep the accounting a lot simpler.
