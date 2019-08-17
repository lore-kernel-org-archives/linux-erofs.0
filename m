From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 18 Aug 2019 06:07:07 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>
Message-ID: <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>

Hi Richard,

On Sat, Aug 17, 2019@11:19:50PM +0200, Richard Weinberger wrote:
> ----- Urspr?ngliche Mail -----
> > Von: "Gao Xiang" <hsiangkao at aol.com>
> > An: "Greg Kroah-Hartman" <gregkh at linuxfoundation.org>, "Al Viro" <viro at zeniv.linux.org.uk>, "linux-fsdevel"
> > <linux-fsdevel at vger.kernel.org>, devel at driverdev.osuosl.org, linux-erofs at lists.ozlabs.org, "linux-kernel"
> > <linux-kernel at vger.kernel.org>
> > CC: "Andrew Morton" <akpm at linux-foundation.org>, "Stephen Rothwell" <sfr at canb.auug.org.au>, "tytso" <tytso at mit.edu>,
> > "Pavel Machek" <pavel at denx.de>, "David Sterba" <dsterba at suse.cz>, "Amir Goldstein" <amir73il at gmail.com>, "Christoph
> > Hellwig" <hch at infradead.org>, "Darrick J . Wong" <darrick.wong at oracle.com>, "Dave Chinner" <david at fromorbit.com>,
> > "Jaegeuk Kim" <jaegeuk at kernel.org>, "Jan Kara" <jack at suse.cz>, "richard" <richard at nod.at>, "torvalds"
> > <torvalds at linux-foundation.org>, "Chao Yu" <yuchao0 at huawei.com>, "Miao Xie" <miaoxie at huawei.com>, "Li Guifu"
> > <bluce.liguifu at huawei.com>, "Fang Wei" <fangwei1 at huawei.com>, "Gao Xiang" <gaoxiang25 at huawei.com>
> > Gesendet: Samstag, 17. August 2019 10:23:13
> > Betreff: [PATCH] erofs: move erofs out of staging
> 
> > EROFS filesystem has been merged into linux-staging for a year.
> > 
> > EROFS is designed to be a better solution of saving extra storage
> > space with guaranteed end-to-end performance for read-only files
> > with the help of reduced metadata, fixed-sized output compression
> > and decompression inplace technologies.
>  
> How does erofs compare to squashfs?
> IIUC it is designed to be faster. Do you have numbers?
> Feel free to point me older mails if you already showed numbers,
> I have to admit I didn't follow the development very closely.

You can see the following related material which has microbenchmark
tested on my laptop:
https://static.sched.com/hosted_files/kccncosschn19eng/19/EROFS%20file%20system_OSS2019_Final.pdf

which was mentioned in the related topic as well:
https://lore.kernel.org/r/20190815044155.88483-1-gaoxiang25 at huawei.com/

Thanks,
Gao Xiang

> 
> Thanks,
> //richard
