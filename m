From: joe@perches.com (Joe Perches)
Date: Sun, 18 Aug 2019 22:47:17 -0700
Subject: [PATCH] erofs: Use common kernel logging style
In-Reply-To: <20190819055243.GB30459@138>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>
 <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
 <20190818092839.GA18975@hsiangkao-HP-ZHAN-66-Pro-G1>
 <52e4e3a7f160f5d2825bec04a3bc4eb4b0d1165a.camel@perches.com>
 <20190819055243.GB30459@138>
Message-ID: <31cb3e54fe532630b45bb74ba4fc688eb86eab1f.camel@perches.com>

On Mon, 2019-08-19@13:52 +0800, Gao Xiang wrote:
> Hi Joe,

Hello.

> On Sun, Aug 18, 2019@10:28:41PM -0700, Joe Perches wrote:
> > Rename errln, infoln, and debugln to the typical pr_<level> uses
> > to the typical kernel styles of pr_<level>
> 
> How about using erofs_err / ... to instead that?

<shrug>  I've no opinion.
It seems most fs/*/* filesystems actually do use pr_<level>
sed works well if you want that.

>  - I can hardly see directly use pr_<level> for those filesystems in fs/...

just fyi:

There was this one existing pr_<level> use in erofs

drivers/staging/erofs/data.c:366:                               pr_err("%s, readahead error at page %lu of nid %llu\n",
drivers/staging/erofs/data.c-367-                                      __func__, page->index,
drivers/staging/erofs/data.c-368-                                      EROFS_V(mapping->host)->nid);
