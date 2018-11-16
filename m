From: osandov@osandov.com (Omar Sandoval)
Date: Fri, 16 Nov 2018 08:40:28 -0800
Subject: [PATCH V10 18/19] block: kill QUEUE_FLAG_NO_SG_MERGE
In-Reply-To: <20181116135922.GO3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-19-ming.lei@redhat.com>
 <20181116021811.GM23828@vader> <20181116135922.GO3165@lst.de>
Message-ID: <20181116164028.GW23828@vader>

On Fri, Nov 16, 2018@02:59:22PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018@06:18:11PM -0800, Omar Sandoval wrote:
> > This commit message wasn't very clear. Is it the case that
> > QUEUE_FLAG_NO_SG_MERGE is no longer set by any drivers?
> 
> I think he wants to say that not doing S/G merging is rather pointless
> with the current setup of the I/O path, as it isn't going to save
> you a significant amount of cycles.

Okay, that makes sense. Ming, you can add

Reviewed-by: Omar Sandoval <osandov at fb.com>
