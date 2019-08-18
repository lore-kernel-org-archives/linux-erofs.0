From: chao@kernel.org (Chao Yu)
Date: Sun, 18 Aug 2019 18:12:57 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818090949.GA30276@kroah.com>
 <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>
Message-ID: <8319896b-22c1-0550-f464-f4419a70202e@kernel.org>

Hi Richard,

On 2019-8-18 17:21, Richard Weinberger wrote:
> For normal use I see no problem at all.
> I fear distros that try to mount anything you plug into your USB.
> 
> At least SUSE already blacklists erofs:
> https://github.com/openSUSE/suse-module-tools/blob/master/suse-module-tools.spec#L24

Thanks for letting us know current status of erofs in SUSE distro.

Currently erofs cares more about the requirement of Android, in there, we are
safe on fuzzed image case as dm-verity can keep all partition data being
verified before mount.

For other scenarios, like distro, erofs should improve itself step by step as
many mainline filesystems in many aspects to fit the there-in requirement. :)

Thanks,

> 
> Thanks,
> //richard
> 
