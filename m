From: richard@nod.at (Richard Weinberger)
Date: Sun, 18 Aug 2019 11:21:13 +0200 (CEST)
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190818090949.GA30276@kroah.com>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818090949.GA30276@kroah.com>
Message-ID: <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>

----- Urspr?ngliche Mail -----
> You have looked at reiserfs lately, right?  :)

Don't remind me of that. ;-)
 
> Not to say that erofs shouldn't be worked on to fix these kinds of
> issues, just that it's not an unheard of thing to trust the disk image.
> Especially for the normal usage model of erofs, where the whole disk
> image is verfied before it is allowed to be mounted as part of the boot
> process.

For normal use I see no problem at all.
I fear distros that try to mount anything you plug into your USB.

At least SUSE already blacklists erofs:
https://github.com/openSUSE/suse-module-tools/blob/master/suse-module-tools.spec#L24

Thanks,
//richard
