From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:59:37 +0100
Subject: [PATCH V10 19/19] block: kill BLK_MQ_F_SG_MERGE
In-Reply-To: <20181115085306.9910-20-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-20-ming.lei@redhat.com>
Message-ID: <20181116135937.GP3165@lst.de>

On Thu, Nov 15, 2018@04:53:06PM +0800, Ming Lei wrote:
> QUEUE_FLAG_NO_SG_MERGE has been killed, so kill BLK_MQ_F_SG_MERGE too.

Looks fine,

Reviewed-by: Christoph Hellwig <hch at lst.de>
