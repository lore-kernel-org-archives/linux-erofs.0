Return-Path: <SRS0=vcGz=MZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8598EC4338F
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Aug 2021 21:58:49 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 153D260F9C
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Aug 2021 21:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 153D260F9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GdsMp5dcqz30Gs
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Aug 2021 07:58:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=AFRt+vw9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=djwong@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=AFRt+vw9; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GdsMg562Bz302X
 for <linux-erofs@lists.ozlabs.org>; Tue,  3 Aug 2021 07:58:39 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 733E060187;
 Mon,  2 Aug 2021 21:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627941516;
 bh=ye825ek9Rk2e9Kpzz3357+dFQOwXo4tWlZEWNqkhf4s=;
 h=Date:From:To:Subject:References:In-Reply-To:From;
 b=AFRt+vw9zLztnxMO0okmOkfiiXMyjvw9WQE0xxNvclPk6MQedy3Hou4oHA8AovSlu
 vQNr1B7Qh2/mR3LDhG74zoCnqH7Uaacugp1hUdJunrlZq1iB7FJG9D5TGmgtdmcCX+
 EtiZ+u7kq4qnYaOMcWyd9WXPNWem11sTSZt+mkvkQ+gPJo5JOO9UxitggNR5TMSZXP
 zP/SyfnnO0HaAUS7xO9X8sc5eAiOk3uwxpCcq3W2OxPHPOfZy7g5SMCRJC4Bkyfip3
 S4peeD/VqSeKQztPX5E3fK1bZwBwc1MnRsTssYs3z0sebPbJ19AlG87JSN78j8PC7Y
 M4ZSqN1iRX/5A==
Date: Mon, 2 Aug 2021 14:58:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Huang Jianan <huangjianan@oppo.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v9] iomap: Support file tail packing
Message-ID: <20210802215836.GB3601405@magnolia>
References: <20210727025956.80684-1-hsiangkao@linux.alibaba.com>
 <CAHc6FU5x3XOTyu8vooReSZ-hacfTdo3cu7wFJRcQrfTH8NkVeg@mail.gmail.com>
 <YQfh7V0lvLNx0QlR@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQfh7V0lvLNx0QlR@B-P7TQMD6M-0146.local>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Aug 02, 2021 at 08:15:41PM +0800, Gao Xiang wrote:
> Hi Andreas,
> 
> On Sun, Aug 01, 2021 at 02:03:33PM +0200, Andreas Gruenbacher wrote:
> > On Tue, Jul 27, 2021 at 5:00 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> 
> ...
> 
> > > +static int iomap_write_begin_inline(struct inode *inode,
> > > +               struct page *page, struct iomap *srcmap)
> > > +{
> > > +       /* needs more work for the tailpacking case, disable for now */
> > 
> > Nit: the comma should be a semicolon or period here.
> 
> Sorry for some delay (busy in other things...)
> 
> Yeah, that's fine to me, in English contexts it'd be better like that
> (there is some punctuation rule difference between languages.)
> 
> 
> Hi Darrick,
> Should I resend v10 for this punctuation change or could you kindly
> help revise this?
> 
> (btw, would you mind set up a for-next iomap branch so I could rebase
>  other EROFS patches on iomap for-next, thank you very much!)

Er... I'll send a group email shortly.  Assembling the branch hasn't
been as straightforward as it usually is...

--D

> Thanks,
> Gao Xiang
