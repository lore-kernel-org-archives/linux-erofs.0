Return-Path: <SRS0=eft8=MV=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200E0C432BE
	for <linux-erofs@archiver.kernel.org>; Thu, 29 Jul 2021 17:34:19 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3CF5760E9B
	for <linux-erofs@archiver.kernel.org>; Thu, 29 Jul 2021 17:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3CF5760E9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GbHhS6SJ1z3bmn
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Jul 2021 03:34:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=47.88.44.36;
 helo=out4436.biz.mail.alibaba.com; envelope-from=hsiangkao@linux.alibaba.com;
 receiver=<UNKNOWN>)
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
 [47.88.44.36])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GbHhN1YhGz2xMw
 for <linux-erofs@lists.ozlabs.org>; Fri, 30 Jul 2021 03:34:11 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=7; SR=0; TI=SMTPD_---0UhMdJRn_1627579569; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UhMdJRn_1627579569) by smtp.aliyun-inc.com(127.0.0.1);
 Fri, 30 Jul 2021 01:26:10 +0800
Date: Fri, 30 Jul 2021 01:26:08 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] iomap: Support inline data with block size < page size
Message-ID: <YQLksEHixW+4RYqJ@B-P7TQMD6M-0146.local>
Mail-Followup-To: Matthew Wilcox <willy@infradead.org>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 linux-erofs@lists.ozlabs.org,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20210729032344.3975412-1-willy@infradead.org>
 <CAHc6FU5E9AdiH7SnfADteOVdttNFGO1EN0PoiYYVyaftCJ1Mqw@mail.gmail.com>
 <YQKiekbn8wbKklzU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YQKiekbn8wbKklzU@casper.infradead.org>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Matthew,

On Thu, Jul 29, 2021 at 01:43:38PM +0100, Matthew Wilcox wrote:
> On Thu, Jul 29, 2021 at 05:54:56AM +0200, Andreas Gruenbacher wrote:
> > > -       /* inline data must start page aligned in the file */
> > > -       if (WARN_ON_ONCE(offset_in_page(iomap->offset)))
> > > -               return -EIO;
> > 
> > Maybe add a WARN_ON_ONCE(size > PAGE_SIZE - poff) here?
> 
> Sure!
> 
> > >         if (WARN_ON_ONCE(size > PAGE_SIZE -
> > >                          offset_in_page(iomap->inline_data)))
> > >                 return -EIO;
> > >         if (WARN_ON_ONCE(size > iomap->length))
> > >                 return -EIO;
> > > -       if (WARN_ON_ONCE(page_has_private(page)))
> > > -               return -EIO;
> > > +       if (poff > 0)
> > > +               iomap_page_create(inode, page);
> > >
> > > -       addr = kmap_atomic(page);
> > > +       addr = kmap_atomic(page) + poff;
> > 
> > Maybe kmap_local_page?
> 
> Heh, I do that later when I convert to folios (there is no
> kmap_atomic_folio(), only kmap_local_folio()).  But I can throw that
> in here too.

I don't find any critical point with this patch (and agree with Andreas'
suggestion), maybe some followup folio work could get more input about
this. I'll evaluate them all together later.

Thanks,
Gao Xiang
