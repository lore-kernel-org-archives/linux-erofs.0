Return-Path: <SRS0=vcGz=MZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855D5C4338F
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Aug 2021 12:16:09 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA19360F11
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Aug 2021 12:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BA19360F11
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GdcRW3j3lz30B7
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Aug 2021 22:16:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133;
 helo=out30-133.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-133.freemail.mail.aliyun.com
 (out30-133.freemail.mail.aliyun.com [115.124.30.133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GdcRM5c0Xz305v
 for <linux-erofs@lists.ozlabs.org>; Mon,  2 Aug 2021 22:15:58 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R571e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=9; SR=0; TI=SMTPD_---0UhmnTvb_1627906541; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UhmnTvb_1627906541) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 02 Aug 2021 20:15:42 +0800
Date: Mon, 2 Aug 2021 20:15:41 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Andreas Gruenbacher <agruenba@redhat.com>,
 "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v9] iomap: Support file tail packing
Message-ID: <YQfh7V0lvLNx0QlR@B-P7TQMD6M-0146.local>
Mail-Followup-To: Andreas Gruenbacher <agruenba@redhat.com>,
 "Darrick J . Wong" <djwong@kernel.org>,
 linux-erofs@lists.ozlabs.org,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Huang Jianan <huangjianan@oppo.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 Christoph Hellwig <hch@lst.de>,
 Matthew Wilcox <willy@infradead.org>
References: <20210727025956.80684-1-hsiangkao@linux.alibaba.com>
 <CAHc6FU5x3XOTyu8vooReSZ-hacfTdo3cu7wFJRcQrfTH8NkVeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHc6FU5x3XOTyu8vooReSZ-hacfTdo3cu7wFJRcQrfTH8NkVeg@mail.gmail.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Andreas,

On Sun, Aug 01, 2021 at 02:03:33PM +0200, Andreas Gruenbacher wrote:
> On Tue, Jul 27, 2021 at 5:00 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:

...

> > +static int iomap_write_begin_inline(struct inode *inode,
> > +               struct page *page, struct iomap *srcmap)
> > +{
> > +       /* needs more work for the tailpacking case, disable for now */
> 
> Nit: the comma should be a semicolon or period here.

Sorry for some delay (busy in other things...)

Yeah, that's fine to me, in English contexts it'd be better like that
(there is some punctuation rule difference between languages.)


Hi Darrick,
Should I resend v10 for this punctuation change or could you kindly
help revise this?

(btw, would you mind set up a for-next iomap branch so I could rebase
 other EROFS patches on iomap for-next, thank you very much!)

Thanks,
Gao Xiang
