From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 19 Aug 2019 14:08:58 +0800
Subject: [PATCH] erofs: Use common kernel logging style
In-Reply-To: <31cb3e54fe532630b45bb74ba4fc688eb86eab1f.camel@perches.com>
References: <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818092839.GA18975@hsiangkao-HP-ZHAN-66-Pro-G1>
 <52e4e3a7f160f5d2825bec04a3bc4eb4b0d1165a.camel@perches.com>
 <20190819055243.GB30459@138>
 <31cb3e54fe532630b45bb74ba4fc688eb86eab1f.camel@perches.com>
Message-ID: <20190819060858.GC30459@138>

Hi Joe,

On Sun, Aug 18, 2019@10:47:17PM -0700, Joe Perches wrote:
> On Mon, 2019-08-19@13:52 +0800, Gao Xiang wrote:
> > Hi Joe,
> 
> Hello.
> 
> > On Sun, Aug 18, 2019@10:28:41PM -0700, Joe Perches wrote:
> > > Rename errln, infoln, and debugln to the typical pr_<level> uses
> > > to the typical kernel styles of pr_<level>
> > 
> > How about using erofs_err / ... to instead that?
> 
> <shrug>  I've no opinion.
> It seems most fs/*/* filesystems actually do use pr_<level>
> sed works well if you want that.

Sorry, I mainly refer to ext4, ext2, xfs and f2fs...
I didn't notice the other filesystems, you are right.

Okay, I have no opinion as well (maybe we could turn back later to
introduce sb parameter...)

> 
> >  - I can hardly see directly use pr_<level> for those filesystems in fs/...
> 
> just fyi:
> 
> There was this one existing pr_<level> use in erofs

That is just because the following piece of code was taken from fs/mpage.c,
I tend to replace it with iomap in the later version after tail-end packing inline is done.

Thanks,
Gao Xiang

> 
> drivers/staging/erofs/data.c:366:                               pr_err("%s, readahead error at page %lu of nid %llu\n",
> drivers/staging/erofs/data.c-367-                                      __func__, page->index,
> drivers/staging/erofs/data.c-368-                                      EROFS_V(mapping->host)->nid);
> 
> 
> 
