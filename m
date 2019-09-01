Return-Path: <SRS0=Lz2Y=W4=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A40BC3A5A7
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 09:39:46 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A86CD2190F
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 09:39:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="Dcp6HLsR";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="MfPXUqTO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A86CD2190F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46Lp8b6n6hzDqlm
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 19:39:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1567330783;
	bh=gNSvDjSgtvxodXDIOL9OPoosEhK6OgJxjBHTlLXhv6U=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=Dcp6HLsR/xuPsg53EopdEcncoxFTx6fHIiEFXzI36bctBlO0kdkH9citPNrcBPcFX
	 hf5whVEwOuQAr5mSpdLjkIbIQs/PUg+LVQ6BgRSiQeTAo7QrHtwTLF8RgLEk4eBTrr
	 M9VKu2coTYR0FDNtkKTrwJt4mnvXnwu1A68kg4ubPTnp3nWdVbm8AlmEJR1hMnUacD
	 rw39VsKEKTF82riAzeQiQHo6ACf+99S+kClGc+Jt70vN3xrgsdRltNh7o4sm2mqvrX
	 Sy5hR1bFvqswC6E5lqFHbFS9GeAe1bqMYA4qg2uVdU6cnUG6BsQZacbRR396+3qcfd
	 kCQ0TVbMkQ/vA==
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=aol.com
 (client-ip=98.137.64.147; helo=sonic301-21.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="MfPXUqTO"; 
 dkim-atps=neutral
Received: from sonic301-21.consmr.mail.gq1.yahoo.com
 (sonic301-21.consmr.mail.gq1.yahoo.com [98.137.64.147])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46Lp8S0L4NzDqgX
 for <linux-erofs@lists.ozlabs.org>; Sun,  1 Sep 2019 19:39:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1567330771; bh=cHlH9WiAvjL21Ab1gMYZyJ5FOMKVRsvNZyUnXUBAmGo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
 b=MfPXUqTOfnneZL37s56uLRiVNXb/M4DXFFztSTMa06uZCQZkBANnS/h23XQpTSBDtq4fX3ZbBa+MLYGk7VEX3qZlVauR8E30nfpxh+lJ7EaSQMU8fyDTStFsS2EiCGTe6Xbc/haS5SM4+JEeF4ctnKcyc5F3crKT+wZCLfYdsIKxyBRwwJkiuv4GDfOiM8Js6o14Z7hwHJcswVwU0/xmO1XjyHBGoOUt8gem91Sdpdn0KKMkAjzGqVMXpIgnH8e5TyDqm+fpxeRljp6+MdHyN26uGARwyWc3y1F9azzgMMmJPzOtQNqStk3CunWFaf3+RU1Yd+JrdRs2ce/j16AveQ==
X-YMail-OSG: tSsyId0VM1l6cGeulFe5p.tIwPmQXn8GOW_0lfxtbeyd1dMhHMVsQe_1t5dK3Lt
 ko3BaUa_o4XZSFIu.kaZeAiY63TfQZm9KmR8YiQmo1IHijjm3GWJqgn_QFnfkzQ0r.CIBkS63ZsH
 IOgB_98F3LollxWzIK3aLQf_CpGhoV0YT2mXc4NGiqFYBPa3m4HsA4cGwX9DRrpxXy3wtUR1sfuu
 34ahEtxknsFvV.X4PFRBA3RZzofOLZmI9sfsun9kzDkBBLg5cb0dbrDBkRuu6za_HsdajtIR6Zd9
 krkQ0uXsy3sbEAFQYIL9tZaO2f0M9r_hIa0oeiHdAWlAYitb_9Ko2SkDs7bab7ynbp79EIoBeSP5
 eLk2PTuXclDo4PZqM1K1q4wujCp91nRVwGep9MomW3mSpXH9CVWqY0SRt7FfitdtjGi0EjRv6f1G
 2bda9S.Sy7DQhpvqr0_vsGVIltWxF_7eA5rmbFr3.Lr0EDkf.wnelI5YEjM0eK.294dmbF7aCz_j
 BdMITfDdCI6uZjZI1zuqH_dQiCtpiOei9WMJtjidNhPtPTUBgCM11GIGUZ_VefFblu0vWK9FJKOk
 HKsx7DPe7N4KKrBbJf7JoOwvOKZyM_uFcS73dQDLCuS5gIOW_lHA4aPK4G7uoH6MaIXYkbYY1HbP
 K4FPwbWLefVj1ykMhTADONRuR6XrKC6djnY5jXIvnK4dQIXT_UXzPZntALaCRK1yom0lnIYtlNzs
 .2tXMLetoh7OV6FgGEMKA4W6y1_mmtOKTcLKKwA0KnDdJJ9HygI6rsgmXB_e141l68v.Oy_z4FQx
 MS32vW3.2QpkntNrxZDVgIT067.WKaWjrKDYK2efCKOISecfqjE10HGJBkXwSgdjIx93DBN0MiuB
 A8kfCSEMN1dhfjhx0WACWuiHe9D_LuKFovc2YV.ibQememms0F42dk5IYD5XdEUl3Zpxi3ZrJlul
 vXXu9qrpbiuA0rcmV8m1NKLVVySAuLr67znzTgltqT0TLRi5iIWqSWK7YiVJxg8u2c8eWvgNQMou
 k1U6aA9hBup7vFmS0OWDlUxlCZ0X.l7QYtVzH9nwmvlfgYGXB13PsHUWNCcOjGMX9EN0lIlp4G_d
 QWxEpmjJRQYS6xGzDM2EcDJ1bQa2iPmXFR57PLwnPk4tPBSrq7G54eAJZ4ECX6APRNu5vq1UqZHj
 HUJ.86x2dwrX50ZrF.x9nFhSQg8yRXxI4FXU4vfVFqLOQ06LMyrLVbfzECR4JNYvp4ZWtvS1Ln.N
 j8URE72BAnOj8gsGP4BF.0W6ZAdJAtAf5J7m9ZKsoW3tQddU1VB0uTa5poSs14fXke9TKNxOu6ti
 wGSD2i7hN41nw
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic301.consmr.mail.gq1.yahoo.com with HTTP; Sun, 1 Sep 2019 09:39:31 +0000
Received: by smtp401.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 682a89ffe636f493a8dcfa91a6749f63; 
 Sun, 01 Sep 2019 09:39:26 +0000 (UTC)
Date: Sun, 1 Sep 2019 17:39:13 +0800
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 06/24] erofs: support special inode
Message-ID: <20190901093912.GB6267@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
 <20190802125347.166018-7-gaoxiang25@huawei.com>
 <20190829102503.GF20598@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829102503.GF20598@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Mailer: WebService/1.1.14303 hermes Apache-HttpAsyncClient/4.1.4
 (Java/1.8.0_181)
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Cc: devel@driverdev.osuosl.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 linux-erofs@lists.ozlabs.org, Jan Kara <jack@suse.cz>,
 "Darrick J . Wong" <darrick.wong@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>,
 LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 Pavel Machek <pavel@denx.de>, David Sterba <dsterba@suse.cz>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Christoph,

On Thu, Aug 29, 2019 at 03:25:03AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 02, 2019 at 08:53:29PM +0800, Gao Xiang wrote:
> > This patch adds to support special inode, such as
> > block dev, char, socket, pipe inode.
> > 
> > Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
> > ---
> >  fs/erofs/inode.c | 27 +++++++++++++++++++++++++--
> >  1 file changed, 25 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> > index b6ea997bc4ae..637bf6e4de44 100644
> > --- a/fs/erofs/inode.c
> > +++ b/fs/erofs/inode.c
> > @@ -34,7 +34,16 @@ static int read_inode(struct inode *inode, void *data)
> >  		vi->xattr_isize = ondisk_xattr_ibody_size(v2->i_xattr_icount);
> >  
> >  		inode->i_mode = le16_to_cpu(v2->i_mode);
> > -		vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
> > +		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> > +		    S_ISLNK(inode->i_mode))
> > +			vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
> > +		else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
> > +			inode->i_rdev =
> > +				new_decode_dev(le32_to_cpu(v2->i_u.rdev));
> > +		else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode))
> > +			inode->i_rdev = 0;
> > +		else
> > +			return -EIO;
> 
> Please use a switch statement when dealing with the file modes to
> make everything easier to read.

Fixed in
https://lore.kernel.org/linux-fsdevel/20190901055130.30572-18-hsiangkao@aol.com/

Thanks,
Gao Xiang

