From: tytso@mit.edu (Theodore Y. Ts'o)
Date: Sun, 18 Aug 2019 13:43:54 -0400
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190818155812.GB13230@infradead.org>
References: <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818090949.GA30276@kroah.com>
 <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>
 <20190818151154.GA32157@mit.edu>
 <20190818155812.GB13230@infradead.org>
Message-ID: <20190818174354.GA12940@mit.edu>

On Sun, Aug 18, 2019@08:58:12AM -0700, Christoph Hellwig wrote:
> On Sun, Aug 18, 2019@11:11:54AM -0400, Theodore Y. Ts'o wrote:
> > Note that of the mainstream file systems, ext4 and xfs don't guarantee
> > that it's safe to blindly take maliciously provided file systems, such
> > as those provided by a untrusted container, and mount it on a file
> > system without problems.  As I recall, one of the XFS developers
> > described file system fuzzing reports as a denial of service attack on
> > the developers.
> 
> I think this greatly misrepresents the general attitute of the XFS
> developers.  We take sanity checks for the modern v5 on disk format
> very series, and put a lot of effort into handling corrupted file
> systems as good as possible, although there are of course no guarantee?.
> 
> The quote that you've taken out of context is for the legacy v4 format
> that has no checksums and other integrity features.

Actually, what Prof. Kim's research group was doing was taking the
latest file system formats (for ext4 and xfs) and fixing up the
checksum after fuzzing the metadata blocks.  The goal was to find
potential security vulnerabilities, not to see if file systems would
crash if fed invalid input.  At least for ext4, at least one of
Prof. Kim's fuzzing results was one that that I believe could have
been leveraged into a stack overflow attack.  I can't speak to his
results with respect to XFS, since I didn't look at them.

Cheers,

					- Ted
