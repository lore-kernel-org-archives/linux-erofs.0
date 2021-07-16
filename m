Return-Path: <SRS0=SOra=MI=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B61C636CA
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Jul 2021 14:40:13 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1766D613F5
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Jul 2021 14:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1766D613F5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GRDRZ57HCz305t
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Jul 2021 00:40:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=IoTC5Vo7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=infradead.org
 (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org;
 envelope-from=willy@infradead.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256
 header.s=casper.20170209 header.b=IoTC5Vo7; 
 dkim-atps=neutral
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GRDRP1R5Vz2yPC
 for <linux-erofs@lists.ozlabs.org>; Sat, 17 Jul 2021 00:40:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=c8jX0REmjBZCchTqC4Xq5jjNHuYwCeErWhz0NbpdxAQ=; b=IoTC5Vo7aYRhVIRxdXh9bDggvG
 uQv3v9/1bJ8qce7fpEFGYLbRY13+9i7X1E8MO1HR7NMIjuKTkJNBRBRkSl5r/Rgt3xZij1dhnfYy8
 NYSNl9tU5PNC1zu7HwmE8enU8Z8NU00CEyy4xsM5gOjwDklTmjsfE1IseZ7ku8LCXvH146iS5M6oG
 v0U/sEirveG4T3gQVcMM0y1e5UmBwn/xfcmB2J0R4Q1RMcpcgt0Rc5qDQfWSQGkTn53ReObNTG4Uq
 rDDgqMuFaoWhUQaAcrEN2NsHJ5SG+Sj3Gn1Chq49e7zf5SZbIw5azCABXgn1Wyq6lDQgIQemFy3UW
 BXwGfbMw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1m4OzI-004YJs-T4; Fri, 16 Jul 2021 14:39:02 +0000
Date: Fri, 16 Jul 2021 15:38:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] iomap: support tail packing inline read
Message-ID: <YPGZ+GE/Bb0zNhzD@casper.infradead.org>
References: <20210716050724.225041-1-hsiangkao@linux.alibaba.com>
 <20210716050724.225041-2-hsiangkao@linux.alibaba.com>
 <YPFPDS5ktWJEUKTo@infradead.org>
 <YPGN97vWokqkWSZn@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPGN97vWokqkWSZn@casper.infradead.org>
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
 "Darrick J. Wong" <djwong@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Liu Bo <bo.liu@linux.alibaba.com>,
 linux-fsdevel@vger.kernel.org, Gao Xiang <hsiangkao@linux.alibaba.com>,
 Liu Jiang <gerry@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Jul 16, 2021 at 02:47:35PM +0100, Matthew Wilcox wrote:
> I think it looks something like this ...
> 
> @@ -211,23 +211,18 @@ struct iomap_readpage_ctx {
>  };
> 
>  static void iomap_read_inline_data(struct inode *inode, struct folio *folio,
> -               struct iomap *iomap)
> +               struct iomap *iomap, loff_t pos, size_t size)
>  {
> -       size_t size = i_size_read(inode);
>         void *addr;
> +       size_t offset = offset_in_folio(folio, pos);
> 
> -       if (folio_test_uptodate(folio))
> -               return;
> +       BUG_ON(size != i_size_read(inode) - pos);
> 
> -       BUG_ON(folio->index);
> -       BUG_ON(folio_multi(folio));
> -       BUG_ON(size > PAGE_SIZE - offset_in_page(iomap->inline_data));
> -
> -       addr = kmap_local_folio(folio, 0);
> +       addr = kmap_local_folio(folio, offset);
>         memcpy(addr, iomap->inline_data, size);
>         memset(addr + size, 0, PAGE_SIZE - size);
>         kunmap_local(addr);
> -       folio_mark_uptodate(folio);
> +       iomap_set_range_uptodate(folio, to_iomap_page(folio), pos, size);

That should be s/size/PAGE_SIZE - offset/
(because this has just zeroed all the bytes in the page after end-of-file)
