Return-Path: <SRS0=RNpQ=ML=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA30AC07E9B
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 16:12:18 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5DA3361469
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 16:12:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DA3361469
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GT6LR0fPyz30Gt
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Jul 2021 02:12:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130;
 helo=out30-130.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-130.freemail.mail.aliyun.com
 (out30-130.freemail.mail.aliyun.com [115.124.30.130])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GT6LH6ctmz3076
 for <linux-erofs@lists.ozlabs.org>; Tue, 20 Jul 2021 02:12:06 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=7; SR=0; TI=SMTPD_---0UgI6h02_1626711109; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UgI6h02_1626711109) by smtp.aliyun-inc.com(127.0.0.1);
 Tue, 20 Jul 2021 00:11:51 +0800
Date: Tue, 20 Jul 2021 00:11:49 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] iomap: support tail packing inline read
Message-ID: <YPWkRRzy5reIMu8u@B-P7TQMD6M-0146.local>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
 Matthew Wilcox <willy@infradead.org>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>,
 Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
References: <20210719144747.189634-1-hsiangkao@linux.alibaba.com>
 <YPWUBhxhoaEp8Frn@casper.infradead.org>
 <20210719151310.GA22355@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210719151310.GA22355@lst.de>
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
Cc: "Darrick J . Wong" <djwong@kernel.org>,
 Andreas Gruenbacher <andreas.gruenbacher@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Jul 19, 2021 at 05:13:10PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 19, 2021 at 04:02:30PM +0100, Matthew Wilcox wrote:
> > > +	if (iomap->type == IOMAP_INLINE) {
> > > +		iomap_read_inline_data(inode, page, iomap, pos);
> > > +		plen = PAGE_SIZE - poff;
> > > +		goto done;
> > > +	}
> > 
> > This is going to break Andreas' case that he just patched to work.
> > GFS2 needs for there to _not_ be an iop for inline data.  That's
> > why I said we need to sort out when to create an iop before moving
> > the IOMAP_INLINE case below the creation of the iop.
> > 
> > If we're not going to do that first, then I recommend leaving the
> > IOMAP_INLINE case where it is and changing it to ...
> > 
> > 	if (iomap->type == IOMAP_INLINE)
> > 		return iomap_read_inline_data(inode, page, iomap, pos);
> > 
> > ... and have iomap_read_inline_data() return the number of bytes that
> > it copied + zeroed (ie PAGE_SIZE - poff).
> 
> Returning the bytes is much cleaner anyway.  But we still need to deal
> with the sub-page uptodate status in one form or another.

There is another iomap_read_inline_data() caller as in:
+static int iomap_write_begin_inline(struct inode *inode, loff_t pos,
+		struct page *page, struct iomap *srcmap)
+{
+	/* needs more work for the tailpacking case, disable for now */
+	if (WARN_ON_ONCE(pos != 0))
+		return -EIO;
+	if (PageUptodate(page))
+		return 0;
+	iomap_read_inline_data(inode, page, srcmap, pos);
+	return 0;
+}

I'd like to avoid it as (void)iomap_read_inline_data(...). That's why it
left as void return type.

Anyway, let's check if it works correctly first. I think it's a high
priority stuff, and EROFS uncompressed cases can be entirely cleaned
up with iomap then.

Thanks,
Gao Xiang
