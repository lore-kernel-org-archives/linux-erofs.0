From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 19 Aug 2019 16:02:18 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <1559833874.69649.1566200143457.JavaMail.zimbra@nod.at>
References: <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818155812.GB13230@infradead.org>
 <20190818161638.GE1118@sol.localdomain>
 <20190818162201.GA16269@infradead.org>
 <20190818172938.GA14413@sol.localdomain>
 <20190818174702.GA17633@infradead.org>
 <20190818181654.GA1617@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818201405.GA27398@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1559833874.69649.1566200143457.JavaMail.zimbra@nod.at>
Message-ID: <20190819080218.GA42231@138>

Hi Richard,

On Mon, Aug 19, 2019@09:35:43AM +0200, Richard Weinberger wrote:
> ----- Urspr?ngliche Mail -----
> > I have made a simple fuzzer to inject messy in inode metadata,
> > dir data, compressed indexes and super block,
> > https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=experimental-fuzzer
> > 
> > I am testing with some given dirs and the following script.
> > Does it look reasonable?
> 
> I think that's a very good start. :-)

I have been testing with this tools for hours, it seems strong
against corrupted images without compression.

I'm now struggling with corrupted images with compression,
hopefully most of them can be fixed trivially... I will send
the bunch of fixes later... Let me dig into it more...

Thanks for your reply :-)

Thanks,
Gao Xiang

> 
> Thanks,
> //richard
