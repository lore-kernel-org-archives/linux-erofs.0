From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:59:22 +0100
Subject: [PATCH V10 18/19] block: kill QUEUE_FLAG_NO_SG_MERGE
In-Reply-To: <20181116021811.GM23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-19-ming.lei@redhat.com> <20181116021811.GM23828@vader>
Message-ID: <20181116135922.GO3165@lst.de>

On Thu, Nov 15, 2018@06:18:11PM -0800, Omar Sandoval wrote:
> This commit message wasn't very clear. Is it the case that
> QUEUE_FLAG_NO_SG_MERGE is no longer set by any drivers?

I think he wants to say that not doing S/G merging is rather pointless
with the current setup of the I/O path, as it isn't going to save
you a significant amount of cycles.
