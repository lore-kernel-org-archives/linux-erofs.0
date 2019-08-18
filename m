From: hch@infradead.org (Christoph Hellwig)
Date: Sun, 18 Aug 2019 10:47:02 -0700
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190818172938.GA14413@sol.localdomain>
References: <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818090949.GA30276@kroah.com>
 <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>
 <20190818151154.GA32157@mit.edu>
 <20190818155812.GB13230@infradead.org>
 <20190818161638.GE1118@sol.localdomain>
 <20190818162201.GA16269@infradead.org>
 <20190818172938.GA14413@sol.localdomain>
Message-ID: <20190818174702.GA17633@infradead.org>

On Sun, Aug 18, 2019@10:29:38AM -0700, Eric Biggers wrote:
> Not sure what you're even disagreeing with, as I *do* expect new filesystems to
> be held to a high standard, and to be written with the assumption that the
> on-disk data may be corrupted or malicious.  We just can't expect the bar to be
> so high (e.g. no bugs) that it's never been attained by *any* filesystem even
> after years/decades of active development.  If the developers were careful, the
> code generally looks robust, and they are willing to address such bugs as they
> are found, realistically that's as good as we can expect to get...

Well, the impression I got from Richards quick look and the reply to it is
that there is very little attempt to validate the ondisk data structure
and there is absolutely no priority to do so.  Which is very different
from there is a bug or two here and there.
