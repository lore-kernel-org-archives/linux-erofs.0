Return-Path: <SRS0=nPPS=MJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8FFC636CA
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Jul 2021 15:16:25 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4FC03610CB
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Jul 2021 15:16:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FC03610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GRsBt6pfRz3002
	for <linux-erofs@archiver.kernel.org>; Sun, 18 Jul 2021 01:16:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133;
 helo=out30-133.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-133.freemail.mail.aliyun.com
 (out30-133.freemail.mail.aliyun.com [115.124.30.133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GRsBp1xKgz2yNy
 for <linux-erofs@lists.ozlabs.org>; Sun, 18 Jul 2021 01:16:15 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=11; SR=0; TI=SMTPD_---0Ug3MJx6_1626534958; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Ug3MJx6_1626534958) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 17 Jul 2021 23:16:00 +0800
Date: Sat, 17 Jul 2021 23:15:58 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/2] iomap: support tail packing inline read
Message-ID: <YPL0LqHzEbUY4zY/@B-P7TQMD6M-0146.local>
Mail-Followup-To: Matthew Wilcox <willy@infradead.org>,
 Andreas =?utf-8?Q?Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, linux-erofs@lists.ozlabs.org,
 Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Chao Yu <chao@kernel.org>,
 Liu Bo <bo.liu@linux.alibaba.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 Liu Jiang <gerry@linux.alibaba.com>
References: <20210716050724.225041-1-hsiangkao@linux.alibaba.com>
 <20210716050724.225041-2-hsiangkao@linux.alibaba.com>
 <YPGDZYT9OxdgNYf2@casper.infradead.org>
 <YPGQB3zT4Wp4Q38X@B-P7TQMD6M-0146.local>
 <YPGbNCdCNXIpNdqd@casper.infradead.org>
 <YPGfqLcSiH3/z2RT@B-P7TQMD6M-0146.local>
 <CAHpGcMJzEiJUbD=7ZOdH7NF+gq9MuEi8=ym34ay7QAm5_91s7g@mail.gmail.com>
 <YPLdSja/4FBsjss/@B-P7TQMD6M-0146.local>
 <YPLw0uc1jVKI8uKo@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YPLw0uc1jVKI8uKo@casper.infradead.org>
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
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 Andreas =?utf-8?Q?Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Liu Bo <bo.liu@linux.alibaba.com>,
 Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
 Liu Jiang <gerry@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Matthew,

On Sat, Jul 17, 2021 at 04:01:38PM +0100, Matthew Wilcox wrote:
> On Sat, Jul 17, 2021 at 09:38:18PM +0800, Gao Xiang wrote:
> > Sorry about some late. I've revised a version based on Christoph's
> > version and Matthew's thought above. I've preliminary checked with
> > EROFS, if it does make sense, please kindly help check on the gfs2
> > side as well..
> 
> I don't understand how this bit works:

This part inherited from the Christoph version without change.
The following thoughts are just my own understanding...

> 
> >  	struct page *page = ctx->cur_page;
> > -	struct iomap_page *iop;
> > +	struct iomap_page *iop = NULL;
> >  	bool same_page = false, is_contig = false;
> >  	loff_t orig_pos = pos;
> >  	unsigned poff, plen;
> >  	sector_t sector;
> >  
> > -	if (iomap->type == IOMAP_INLINE) {
> > -		WARN_ON_ONCE(pos);
> > -		iomap_read_inline_data(inode, page, iomap);
> > -		return PAGE_SIZE;
> > -	}
> > +	if (iomap->type == IOMAP_INLINE && !pos)
> > +		WARN_ON_ONCE(to_iomap_page(page) != NULL);
> > +	else
> > +		iop = iomap_page_create(inode, page);
> 
> Imagine you have a file with bytes 0-2047 in an extent which is !INLINE
> and bytes 2048-2051 in the INLINE extent.  When you read the page, first
> you create an iop for the !INLINE extent.  Then this function is called

Yes, it first created an iop for the !INLINE extent.

> again for the INLINE extent and you'll hit the WARN_ON_ONCE.  No?

If it is called again with another INLINE extent, pos will be non-0?
so (!pos) == false. Am I missing something?

Thanks,
Gao Xiang

> 
