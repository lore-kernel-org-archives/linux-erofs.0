From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 18 Aug 2019 17:18:05 +0800
Subject: [PATCH v3 RESEND] staging: erofs: fix an error handling in
 erofs_readdir()y
In-Reply-To: <20190818091037.GB17909@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190818030109.GA8225@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818032111.9862-1-hsiangkao@aol.com>
 <35138595.69023.1566117213033.JavaMail.zimbra@nod.at>
 <20190818091037.GB17909@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <20190818091804.GA18675@hsiangkao-HP-ZHAN-66-Pro-G1>

On Sun, Aug 18, 2019@05:10:38PM +0800, Gao Xiang via Linux-erofs wrote:
> Hi Richard,
> 
> On Sun, Aug 18, 2019@10:33:33AM +0200, Richard Weinberger wrote:
> > ----- Urspr?ngliche Mail -----
> > > changelog from v2:
> > > - transform EIO to EFSCORRUPTED as suggested by Matthew;
> > 
> > erofs does not define EFSCORRUPTED, so the build fails.
> > At least on Linus' tree as of today.
> 
> Thanks for your reply :)
> 
> I write all patches based on staging tree and do more cleanups further
> than Linus' tree, EFSCORRUPTED was already introduced by Pavel days before...

Sorry, I mean "introduced which was suggested by Paval"...

> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-testing&id=a6b9b1d5eae61a68085030e50d56265dec5baa94
> 
> which can be fetched from
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git -b staging-next
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Thanks,
> > //richard
