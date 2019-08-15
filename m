From: pavel@denx.de (Pavel Machek)
Date: Thu, 15 Aug 2019 09:01:32 +0200
Subject: [PATCH v7 08/24] erofs: add namei functions
In-Reply-To: <20190813122332.GA17429@138>
References: <20190813091326.84652-1-gaoxiang25@huawei.com>
 <20190813091326.84652-9-gaoxiang25@huawei.com>
 <20190813114821.GB11559@amd> <20190813122332.GA17429@138>
Message-ID: <20190815070132.GB3669@amd>

Hi!

> > > +	/*
> > > +	 * on-disk error, let's only BUG_ON in the debugging mode.
> > > +	 * otherwise, it will return 1 to just skip the invalid name
> > > +	 * and go on (in consideration of the lookup performance).
> > > +	 */
> > > +	DBG_BUGON(qd->name > qd->end);
> > 
> > I believe you should check for errors in non-debug mode, too.
> 
> Thanks for your kindly reply!
> 
> The following is just my personal thought... If I am wrong, please
> kindly point out...
> 
> As you can see, this is a new prefixed string binary search algorithm
> which can provide similar performance with hashed approach (but no
> need to store hash value at all), so I really care about its lookup
> performance.
> 
> There is something needing to be concerned, is, whether namei() should
> report any potential on-disk issues or just return -ENOENT for these
> corrupted dirs, I think I tend to use the latter one.

-ENOENT is okay for corrupted directories, as long as corrupted
directories do not cause some kind of security bugs (memory
corruption, crashes, ...)


Best regards,
								Pavel
-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 181 bytes
Desc: Digital signature
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190815/64c28eb0/attachment.sig>
