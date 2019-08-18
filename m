From: hsiangkao@gmx.com (Gao Xiang)
Date: Mon, 19 Aug 2019 02:16:55 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190818174702.GA17633@infradead.org>
References: <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818090949.GA30276@kroah.com>
 <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>
 <20190818151154.GA32157@mit.edu>
 <20190818155812.GB13230@infradead.org>
 <20190818161638.GE1118@sol.localdomain>
 <20190818162201.GA16269@infradead.org>
 <20190818172938.GA14413@sol.localdomain>
 <20190818174702.GA17633@infradead.org>
Message-ID: <20190818181654.GA1617@hsiangkao-HP-ZHAN-66-Pro-G1>

Hi Hch,

On Sun, Aug 18, 2019@10:47:02AM -0700, Christoph Hellwig wrote:
> On Sun, Aug 18, 2019@10:29:38AM -0700, Eric Biggers wrote:
> > Not sure what you're even disagreeing with, as I *do* expect new filesystems to
> > be held to a high standard, and to be written with the assumption that the
> > on-disk data may be corrupted or malicious.  We just can't expect the bar to be
> > so high (e.g. no bugs) that it's never been attained by *any* filesystem even
> > after years/decades of active development.  If the developers were careful, the
> > code generally looks robust, and they are willing to address such bugs as they
> > are found, realistically that's as good as we can expect to get...
>
> Well, the impression I got from Richards quick look and the reply to it is
> that there is very little attempt to validate the ondisk data structure
> and there is absolutely no priority to do so.  Which is very different
> from there is a bug or two here and there.

As my second reply to Richard, I didn't fuzz all the on-disk fields for EROFS.
and as my reply to Richard / Greg, current EROFS is used on the top of dm-verity.

I cannot say how well EROFS will be performed on malformed images (and you can
also find the bug richard pointed out is a miswritten break->continue by myself).

I posted the upstream EROFS post on July 4, 2019 and a month and a half later,
no one can tell me (yes, thanks for kind people reply me about their suggestion)
what we should do next (you can see these emails, I sent many times) to meet
the minimal upstream requirements and rare people can even dip into my code.

That is all I want to say. I will work on autofuzz these days, and I want to
know how to meet your requirements on this (you can tell us your standard,
how well should we do).

OK, you don't reply to my post once, I have no idea how to get your first reply.

Thanks,
Gao Xiang
