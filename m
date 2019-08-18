From: hch@infradead.org (Christoph Hellwig)
Date: Sun, 18 Aug 2019 09:22:01 -0700
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190818161638.GE1118@sol.localdomain>
References: <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818090949.GA30276@kroah.com>
 <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>
 <20190818151154.GA32157@mit.edu>
 <20190818155812.GB13230@infradead.org>
 <20190818161638.GE1118@sol.localdomain>
Message-ID: <20190818162201.GA16269@infradead.org>

On Sun, Aug 18, 2019@09:16:38AM -0700, Eric Biggers wrote:
> Ted's observation was about maliciously-crafted filesystems, though, so
> integrity-only features such as metadata checksums are irrelevant.  Also the
> filesystem version is irrelevant; anything accepted by the kernel code (even if

I think allowing users to mount file systems (any of ours) without
privilege is a rather bad idea.  But that doesn't mean we should not be
as robust as we can.  Optionally disabling support for legacy formats
at compile and/or runtime is something we should actively look into as
well.

> it's legacy/deprecated) is open attack surface.
> 
> I personally consider it *mandatory* that we deal with this stuff.  But I can
> understand that we don't do a good job at it, so we shouldn't hold a new
> filesystem to an unfairly high standard relative to other filesystems...

I very much disagree.  We can't really force anyone to fix up old file
systems.  But we can very much hold new ones to (slightly) higher
standards.  Thats the only way to get the average quality up.  Some as
for things like code style - we can't magically fix up all old stuff,
but we can and usually do hold new code to higher standards.  (Often not
to standards as high as I'd personally prefer, btw).
