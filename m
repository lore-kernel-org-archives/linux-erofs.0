From: pavel@denx.de (Pavel Machek)
Date: Mon, 15 Jul 2019 09:56:41 +0200
Subject: [PATCH v2 00/24] erofs: promote erofs from staging
In-Reply-To: <63b9eaca-5d4b-0fe2-c861-7531977a5b48@aol.com>
References: <20190711145755.33908-1-gaoxiang25@huawei.com>
 <20190714104940.GA1282@xo-6d-61-c0.localdomain>
 <63b9eaca-5d4b-0fe2-c861-7531977a5b48@aol.com>
Message-ID: <20190715075641.GA7695@amd>

Hi!

> >> Changelog from v1:
> >>  o resend the whole filesystem into a patchset suggested by Greg;
> >>  o code is more cleaner, especially for decompression frontend.
> >>
> >> --8<----------
> >>
> >> Hi,
> >>
> >> EROFS file system has been in Linux-staging for about a year.
> >> It has been proved to be stable enough to move out of staging
> >> by 10+ millions of HUAWEI Android mobile phones on the market
> >> from EMUI 9.0.1, and it was promoted as one of the key features
> >> of EMUI 9.1 [1], including P30(pro).
> > 
> > Ok, maybe it is ready to be moved to kernel proper, but as git can
> > do moves, would it be better to do it as one commit?
> > 
> > Separate patches are still better for review, I guess.
> 
> Thanks for you reply. Either form is OK for me... The first step could
> be that I hope someone could kindly take some time to look into these
> patches... :)
> 
> The patch v2 is slightly different for the current code in the staging
> tree since I did some code cleanup these days (mainly renaming / moving,
> including rename unzip_vle.{c,h} to zdata.{c,h} and some confusing
> structure names and clean up internal.h...). No functional chance and I
> can submit cleanup patches to staging as well if doing moves by git...

I believe you should get those committed to staging/, yes. Then you
ask Al Viro to do pull the git move, I guess, and you follow his
instructions at that point...

FILESYSTEMS (VFS and infrastructure)
M:      Alexander Viro <viro at zeniv.linux.org.uk>
L:      linux-fsdevel at vger.kernel.org

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 181 bytes
Desc: Digital signature
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190715/99e68035/attachment.sig>
