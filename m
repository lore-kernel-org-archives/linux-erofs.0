From: tytso@mit.edu (Theodore Y. Ts'o)
Date: Sun, 18 Aug 2019 13:46:21 -0400
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <1897345637.69314.1566148000847.JavaMail.zimbra@nod.at>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818090949.GA30276@kroah.com>
 <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>
 <20190818151154.GA32157@mit.edu>
 <1897345637.69314.1566148000847.JavaMail.zimbra@nod.at>
Message-ID: <20190818174621.GB12940@mit.edu>

On Sun, Aug 18, 2019@07:06:40PM +0200, Richard Weinberger wrote:
> > So holding a file system like EROFS to a higher standard than say,
> > ext4, xfs, or btrfs hardly seems fair.
> 
> Nobody claimed that.

Pointing out that erofs has issues in this area when Gao Xiang is
asking if erofs can be moved out of staging and join the "official
clubhouse" of file systems could certainly be reasonable interpreted
as such.  Reporting such vulnerablities are a good thing, and
hopefully all file system maintainers will welcome them.  Doing them
on a e-mail thread about promoting out of erofs is certainly going to
lead to inferences of a double standard.

Cheers,

						- Ted
