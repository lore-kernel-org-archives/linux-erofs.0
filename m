From: richard@nod.at (Richard Weinberger)
Date: Sat, 17 Aug 2019 23:19:50 +0200 (CEST)
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190817082313.21040-1-hsiangkao@aol.com>
References: <20190817082313.21040-1-hsiangkao@aol.com>
Message-ID: <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>

----- Urspr?ngliche Mail -----
> Von: "Gao Xiang" <hsiangkao at aol.com>
> An: "Greg Kroah-Hartman" <gregkh at linuxfoundation.org>, "Al Viro" <viro at zeniv.linux.org.uk>, "linux-fsdevel"
> <linux-fsdevel at vger.kernel.org>, devel at driverdev.osuosl.org, linux-erofs at lists.ozlabs.org, "linux-kernel"
> <linux-kernel at vger.kernel.org>
> CC: "Andrew Morton" <akpm at linux-foundation.org>, "Stephen Rothwell" <sfr at canb.auug.org.au>, "tytso" <tytso at mit.edu>,
> "Pavel Machek" <pavel at denx.de>, "David Sterba" <dsterba at suse.cz>, "Amir Goldstein" <amir73il at gmail.com>, "Christoph
> Hellwig" <hch at infradead.org>, "Darrick J . Wong" <darrick.wong at oracle.com>, "Dave Chinner" <david at fromorbit.com>,
> "Jaegeuk Kim" <jaegeuk at kernel.org>, "Jan Kara" <jack at suse.cz>, "richard" <richard at nod.at>, "torvalds"
> <torvalds at linux-foundation.org>, "Chao Yu" <yuchao0 at huawei.com>, "Miao Xie" <miaoxie at huawei.com>, "Li Guifu"
> <bluce.liguifu at huawei.com>, "Fang Wei" <fangwei1 at huawei.com>, "Gao Xiang" <gaoxiang25 at huawei.com>
> Gesendet: Samstag, 17. August 2019 10:23:13
> Betreff: [PATCH] erofs: move erofs out of staging

> EROFS filesystem has been merged into linux-staging for a year.
> 
> EROFS is designed to be a better solution of saving extra storage
> space with guaranteed end-to-end performance for read-only files
> with the help of reduced metadata, fixed-sized output compression
> and decompression inplace technologies.
 
How does erofs compare to squashfs?
IIUC it is designed to be faster. Do you have numbers?
Feel free to point me older mails if you already showed numbers,
I have to admit I didn't follow the development very closely.

Thanks,
//richard
