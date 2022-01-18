Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE56C433EF
	for <linux-erofs@archiver.kernel.org>; Tue, 18 Jan 2022 23:46:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JdlmF5CF7z30QR
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Jan 2022 10:46:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1642549597;
	bh=E1yaJmKDZBKDxr/7f9VsXCs4zFtPT2RtOBwMaQvJz0o=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=Az+A4aXy3DR583gYKWhPqWfBdY6X/opLGuVgiQ1s9+aakJyq55RZUktRYIqTdzg7V
	 c3uf2r6XFu+YUoD6/xJQCtLFskyj9xyUzA9hwlRtbA6m8+tqScJTxg6KT2i+0HrkMU
	 N7YgzTfC2mRcPqbyp+rP8PnHLDLMiXpyRzekDHreiqIwvbZhO3W327eMRH0VfdAe+J
	 oUpWpAxR4EmgUjYz4v1Vo2335SYxHyWq4992GWRe5bg7bOGO2QZi5Ii0iCceYAB15e
	 FM9/LlmJ6D2GcnhETER84de4/r2wk7xU04COVkqkS8eulkPzBDDUgzD2LW9NQGBFDf
	 vuaHaME7W/olQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=google.com (client-ip=2607:f8b0:4864:20::734;
 helo=mail-qk1-x734.google.com; envelope-from=zhangkelvin@google.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256
 header.s=20210112 header.b=Bl/rXmGl; dkim-atps=neutral
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com
 [IPv6:2607:f8b0:4864:20::734])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Jdlm83qfXz30LQ
 for <linux-erofs@lists.ozlabs.org>; Wed, 19 Jan 2022 10:46:30 +1100 (AEDT)
Received: by mail-qk1-x734.google.com with SMTP id c190so943114qkg.9
 for <linux-erofs@lists.ozlabs.org>; Tue, 18 Jan 2022 15:46:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=E1yaJmKDZBKDxr/7f9VsXCs4zFtPT2RtOBwMaQvJz0o=;
 b=XBI1NQ9cmURj9eEXtrvyU+CTF7ywNS3h4iGAe0wpJ1d6KxPfJ/Xq+xuFhhkREfYDSv
 ADEFFCasYBsupwCDxD9Q8/8Fp04KFKHvfkJs8iZjHp3c8EfqCc63fjD4PjkWmDtb5xIy
 HbY9Or4FhS0vaeA7C6LreVNfDMQfGPqyd1Gb4bywrzlAdrJA9sqWBmsm+KOdoBeYdpn+
 mE2aLTV9jgwljr0aNq1aiGAafDE1rwtYgWbdajZBumj5gprlKAcLsRXTybNjvYMgYvcn
 O2ex/V009dIi6VB8/JzSIGLLNdxq7Br9ZBfl1L+QYf9U50dnb8Sxg2ZnMYspZROqUZ0n
 lV2A==
X-Gm-Message-State: AOAM5301Ulu+YDDZ8fkiN9dtiP/+sE5LKXWwM9D0Z1NTybgJrmjTyXlB
 3RycPMcOO6YKjo24qr+4VcPDfQMLl2KKlykrqgAM0w==
X-Google-Smtp-Source: ABdhPJxEBhvhPQRmgAqotOhhI5Bdq9c5Do/uStQ6eZOv+zTOGwSq/qUxIRNmqkjyiA+tf7EpzWpggPoUFeG+HJ6Dn44=
X-Received: by 2002:a05:620a:1395:: with SMTP id
 k21mr5475771qki.160.1642549585143; 
 Tue, 18 Jan 2022 15:46:25 -0800 (PST)
MIME-Version: 1.0
References: <20211222020307.273150-1-zhangkelvin@google.com>
 <YcKZqAwRVMZ7+c5J@B-P7TQMD6M-0146.local>
In-Reply-To: <YcKZqAwRVMZ7+c5J@B-P7TQMD6M-0146.local>
Date: Tue, 18 Jan 2022 15:46:14 -0800
Message-ID: <CAOSmRzgfWg1BB-cW2dDGTgPhKAne0tB3g3C+nLZ1t+8fh7N=ew@mail.gmail.com>
Subject: Re: [PATCH v1] erofs-utils: lib: Fix 8MB bug on uncompressed extent
 size
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
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
From: Kelvin Zhang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Kelvin Zhang <zhangkelvin@google.com>
Cc: Miao Xie <miaoxie@huawei.com>,
 linux-erofs mailing list <linux-erofs@lists.ozlabs.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

friendly ping : )

On Tue, Dec 21, 2021 at 7:21 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>
> On Tue, Dec 21, 2021 at 06:03:07PM -0800, Kelvin Zhang wrote:
> > Previously, uncompressed extent can be at most 8MB before mkfs.erofs
> > crashes on some error condition. This is due to a minor bug in how
> > compressed indices are encoded. This patch fixes the issue.
> >
> > Signed-off-by: Kelvin Zhang <zhangkelvin@google.com>
>
> I have to hold this for a while and look into (evaluate) that when I
> get a full free time... (maybe a week later.) I understand it's not
> quite urgent for all of us currently..
>
> I still stuck into ztailpacking inline feature for now...
>
> Thanks,
> Gao Xiang
>
> > ---
> >  include/erofs_fs.h |  2 +-
> >  lib/compress.c     | 21 ++++++++++++++++++++-
> >  2 files changed, 21 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/erofs_fs.h b/include/erofs_fs.h
> > index 9a91877..13eaf24 100644
> > --- a/include/erofs_fs.h
> > +++ b/include/erofs_fs.h
> > @@ -353,7 +353,7 @@ enum {
> >   * compressed block count of a compressed extent (in logical clusters, aka.
> >   * block count of a pcluster).
> >   */
> > -#define Z_EROFS_VLE_DI_D0_CBLKCNT            (1 << 11)
> > +#define Z_EROFS_VLE_DI_D0_CBLKCNT            (1U << 11)
> >
> >  struct z_erofs_vle_decompressed_index {
> >       __le16 di_advise;
> > diff --git a/lib/compress.c b/lib/compress.c
> > index 98be7a2..23e571c 100644
> > --- a/lib/compress.c
> > +++ b/lib/compress.c
> > @@ -97,7 +97,26 @@ static void vle_write_indexes(struct z_erofs_vle_compress_ctx *ctx,
> >               } else if (d0) {
> >                       type = Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD;
> >
> > -                     di.di_u.delta[0] = cpu_to_le16(d0);
> > +                     /* If the |Z_EROFS_VLE_DI_D0_CBLKCNT| bit is set, parser
> > +                      * will interpret |delta[0]| as size of pcluster, rather
> > +                      * than distance to last head cluster. Normally this
> > +                      * isn't a problem, because uncompressed extent size are
> > +                      * below Z_EROFS_VLE_DI_D0_CBLKCNT * BLOCK_SIZE = 8MB.
> > +                      * But with large pcluster it's possible to go over this
> > +                      * number, resulting in corrupted compressed indices.
> > +                      * To solve this, we use Z_EROFS_VLE_DI_D0_CBLKCNT-1 if
> > +                      * the uncompressed extent size goes above 8MB. This is
> > +                      * OK because if kernel sees another non-head cluster
> > +                      * after going back by |delta[0]| blocks, kernel will
> > +                      * just keep looking back.
> > +                      */
> > +                     if (d0 & Z_EROFS_VLE_DI_D0_CBLKCNT) {
> > +                             di.di_u.delta[0] = max(
> > +                                     d0 & (~Z_EROFS_VLE_DI_D0_CBLKCNT),
> > +                                     Z_EROFS_VLE_DI_D0_CBLKCNT-1);
> > +                     } else {
> > +                             di.di_u.delta[0] = cpu_to_le16(d0);
> > +                     }
> >                       di.di_u.delta[1] = cpu_to_le16(d1);
> >               } else {
> >                       type = raw ? Z_EROFS_VLE_CLUSTER_TYPE_PLAIN :
> > --
> > 2.34.1.448.ga2b2bfdf31-goog



-- 
Sincerely,

Kelvin Zhang
