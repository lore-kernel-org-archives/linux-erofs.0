From: hsiangkao@gmx.com (Gao Xiang)
Date: Mon, 19 Aug 2019 02:31:05 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <538856932.69442.1566151228866.JavaMail.zimbra@nod.at>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818090949.GA30276@kroah.com>
 <790210571.69061.1566120073465.JavaMail.zimbra@nod.at>
 <20190818151154.GA32157@mit.edu>
 <1897345637.69314.1566148000847.JavaMail.zimbra@nod.at>
 <20190818174621.GB12940@mit.edu>
 <538856932.69442.1566151228866.JavaMail.zimbra@nod.at>
Message-ID: <20190818183104.GB1617@hsiangkao-HP-ZHAN-66-Pro-G1>

Hi Richard,

On Sun, Aug 18, 2019@08:00:28PM +0200, Richard Weinberger wrote:
> ----- Urspr?ngliche Mail -----
> > Von: "tytso" <tytso at mit.edu>
> > An: "richard" <richard at nod.at>
> > CC: "Greg Kroah-Hartman" <gregkh at linuxfoundation.org>, "Gao Xiang" <hsiangkao at aol.com>, "Jan Kara" <jack at suse.cz>, "Chao
> > Yu" <yuchao0 at huawei.com>, "Dave Chinner" <david at fromorbit.com>, "David Sterba" <dsterba at suse.cz>, "Miao Xie"
> > <miaoxie at huawei.com>, "devel" <devel at driverdev.osuosl.org>, "Stephen Rothwell" <sfr at canb.auug.org.au>, "Darrick"
> > <darrick.wong at oracle.com>, "Christoph Hellwig" <hch at infradead.org>, "Amir Goldstein" <amir73il at gmail.com>,
> > "linux-erofs" <linux-erofs at lists.ozlabs.org>, "Al Viro" <viro at zeniv.linux.org.uk>, "Jaegeuk Kim" <jaegeuk at kernel.org>,
> > "linux-kernel" <linux-kernel at vger.kernel.org>, "Li Guifu" <bluce.liguifu at huawei.com>, "Fang Wei" <fangwei1 at huawei.com>,
> > "Pavel Machek" <pavel at denx.de>, "linux-fsdevel" <linux-fsdevel at vger.kernel.org>, "Andrew Morton"
> > <akpm at linux-foundation.org>, "torvalds" <torvalds at linux-foundation.org>
> > Gesendet: Sonntag, 18. August 2019 19:46:21
> > Betreff: Re: [PATCH] erofs: move erofs out of staging
>
> > On Sun, Aug 18, 2019@07:06:40PM +0200, Richard Weinberger wrote:
> >> > So holding a file system like EROFS to a higher standard than say,
> >> > ext4, xfs, or btrfs hardly seems fair.
> >>
> >> Nobody claimed that.
> >
> > Pointing out that erofs has issues in this area when Gao Xiang is
> > asking if erofs can be moved out of staging and join the "official
> > clubhouse" of file systems could certainly be reasonable interpreted
> > as such.  Reporting such vulnerablities are a good thing, and
> > hopefully all file system maintainers will welcome them.  Doing them
> > on a e-mail thread about promoting out of erofs is certainly going to
> > lead to inferences of a double standard.
>
> Well, this was not at all my intention.
> erofs raised my attention and instead of wasting a new thread
> I answered here and reported what I found while looking at it.
> That's all.

Thank you very much, EROFS finally has some real concern
after a quite long time. I will do that but I really want
to upstream for 5.4LTS and hope to get your further report.

Thanks,
Gao Xiang

>
> Thanks,
> //richard
