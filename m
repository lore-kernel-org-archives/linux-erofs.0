From: richard@nod.at (Richard Weinberger)
Date: Mon, 19 Aug 2019 09:35:43 +0200 (CEST)
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190818201405.GA27398@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818155812.GB13230@infradead.org>
 <20190818161638.GE1118@sol.localdomain>
 <20190818162201.GA16269@infradead.org>
 <20190818172938.GA14413@sol.localdomain>
 <20190818174702.GA17633@infradead.org>
 <20190818181654.GA1617@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818201405.GA27398@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <1559833874.69649.1566200143457.JavaMail.zimbra@nod.at>

----- Urspr?ngliche Mail -----
> I have made a simple fuzzer to inject messy in inode metadata,
> dir data, compressed indexes and super block,
> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=experimental-fuzzer
> 
> I am testing with some given dirs and the following script.
> Does it look reasonable?

I think that's a very good start. :-)

Thanks,
//richard
