From: richard@nod.at (Richard Weinberger)
Date: Sun, 18 Aug 2019 10:33:33 +0200 (CEST)
Subject: [PATCH v3 RESEND] staging: erofs: fix an error handling in
 erofs_readdir()
In-Reply-To: <20190818032111.9862-1-hsiangkao@aol.com>
References: <20190818030109.GA8225@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818032111.9862-1-hsiangkao@aol.com>
Message-ID: <35138595.69023.1566117213033.JavaMail.zimbra@nod.at>

----- Urspr?ngliche Mail -----
> changelog from v2:
> - transform EIO to EFSCORRUPTED as suggested by Matthew;

erofs does not define EFSCORRUPTED, so the build fails.
At least on Linus' tree as of today.

Thanks,
//richard
