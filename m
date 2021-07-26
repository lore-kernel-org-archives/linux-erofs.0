Return-Path: <SRS0=Di2a=MS=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30C1C4338F
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Jul 2021 12:17:19 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E907260551
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Jul 2021 12:17:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E907260551
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GYJp53YK2z307g
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Jul 2021 22:17:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=lst.de
 (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de;
 receiver=<UNKNOWN>)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GYJny6zDpz3064
 for <linux-erofs@lists.ozlabs.org>; Mon, 26 Jul 2021 22:17:09 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
 id DA9AA67373; Mon, 26 Jul 2021 14:17:02 +0200 (CEST)
Date: Mon, 26 Jul 2021 14:17:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v7] iomap: make inline data support more flexible
Message-ID: <20210726121702.GA528@lst.de>
References: <CAHpGcMKZP8b3TbRv3D-pcrE_iDU5TKUFHst9emuQmRPntFSArA@mail.gmail.com>
 <CAHpGcMJBhWcwteLDSBU3hgwq1tk_+LqogM1ZM=Fv8U0VtY5hMg@mail.gmail.com>
 <20210723174131.180813-1-hsiangkao@linux.alibaba.com>
 <20210725221639.426565-1-agruenba@redhat.com>
 <YP4zUvnBCAb86Mny@B-P7TQMD6M-0146.local>
 <20210726110611.459173-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726110611.459173-1-agruenba@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

> Subject: iomap: Support tail packing

I can't say I like this "tail packing" language here when we have the
perfectly fine inline wording.  Same for various comments in the actual
code.

> +	/* inline and tail-packed data must start page aligned in the file */
> +	if (WARN_ON_ONCE(offset_in_page(iomap->offset)))
> +		return -EIO;
> +	if (WARN_ON_ONCE(size > PAGE_SIZE - offset_in_page(iomap->inline_data)))
> +		return -EIO;

Why can't we use iomap_inline_data_size_valid here? That is how can
size be different from iomap->legth?

Shouldn't the offset_in_page also go into iomap_inline_data_size_valid,
which should probably be called iomap_inline_data_valid then?

>  	if (iomap->type == IOMAP_INLINE) {
> +		int ret = iomap_read_inline_data(inode, page, iomap);
> +		return ret ?: PAGE_SIZE;

The ?: expression without the first leg is really confuing.  Especially
if a good old if is much more readable here.

		int ret = iomap_read_inline_data(inode, page, iomap);

		if (ret)
			return ret;
		return PAGE_SIZE;

> +		copied = copy_from_iter(iomap_inline_data(iomap, pos), length, iter);


> +		copied = copy_to_iter(iomap_inline_data(iomap, pos), length, iter);

Pleae avoid the overly long lines.
