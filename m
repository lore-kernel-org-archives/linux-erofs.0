Return-Path: <linux-erofs+bounces-4275-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACCE2C5DF85
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 14:21:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQlwm4vK2z2xT6;
	Fri, 21 Aug 2026 00:21:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.217.43
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787235672;
	cv=none; b=TJirmBlvhvHO3TRvwIlD4SS2rqJYrBwpelm37GZMAVYe0LcKSr48J3R3ZRCjxhRxdRd3+duUqLW8ivzQuXE6/txnrIRTUnUW9yvo5rqMADWfSBscDlC1t0XnFaxIhD2yXnVGiy/NnA+rfc+zogqjItVkiFtvLifMvG/n+ZClau/wTv1TqmkixXO/TRvC0dL8fXKdjsBlC6a5hJCjzLxVTs7gvtuNAbktlsYC9rzzGmwJlS+Vtqyc/Ou7UtKnUdsfVJHzVaQDkoPhlbLMk7ynKk93PR7/DtG/U+RrHIi4bDn5SRLmlqqZbiVStZdGOWUNuyugaFek8/Vt2wmH3WCECw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787235672; c=relaxed/relaxed;
	bh=P2duwJcV2Ism5EzisEQNZk+Mn/j0i0G/d2So6hG/ZcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qj2EvGBoETaDULT1/qbMkaA83T5kLHUhJ1yYlS6W3e2YLQaNKN/dMd6jb9RqURI3IbKGlVCrCKhTeRX3fNzEd+ht0Y8417OtwodN8SUXTLHAHwJho5dRjXmaJTlNTl7uS2IvaqsZFpRUi2WCugMdVk7hbI0AqFXQiQWg6It5/2evylH4zor3jpW78qcpOw9gQPVF6z5qAA74DHobzGjBrIHQHug4IASaqdWL4AZY2BDs4Ibs9EVJeWL/yZQjVtca/lZ2xl+whqd1VuCOEGFmRR0rJmoCMSfBMSkU1szd91pBpxRhs0uBMSQhg/D37RLujJ1nY9S/iOF5EXFBGJmqvQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.217.43; helo=mail-vs1-f43.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.217.43; helo=mail-vs1-f43.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQlwk6cHTz2xRw
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 00:21:09 +1000 (AEST)
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-754ac74c495so922377137.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 07:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787235667; x=1787840467;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P2duwJcV2Ism5EzisEQNZk+Mn/j0i0G/d2So6hG/ZcM=;
        b=RBqeD7j/9Qhpy9Vj4JZGRrJhQxtg4lqPf2oZMQq9SUgTGf00gQezspdZFp7hnwU8aR
         02l5o9Sx0F5fAu2mAESqbJDE7Siih89HWtFP/pBKjVnjQKmrMeWjcURjCwF1T+MFEShz
         +AWY1igxllL/ly+5PymyosMgVPZ3VQx4gsWxSYDoiZrSTaGdLXnPzFOFpnpKvGKwuREQ
         FgGEZ3cLE7ZqGeV45rzIIn6fUpghjxDC6jGe/obWq7/bDQ1PbADXNQze+1AhujcU2w/z
         jf0yHNoA9+0KUTxSOxCwUsSU4jnHwOFhDLlKYlKgMCxoB6LjFTsQrRjZnS1Nj3CK8d1P
         QLpg==
X-Forwarded-Encrypted: i=1; AHgh+RoH1iKp/MU3ZC99ZvjIfb5+doNypMhko8Na/U0bwDeggNti0fw+axCa60GNLKngzA/bQlw94VXd1Vl8hw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyaUdVJe+Lg3zlRXXa2LJypKvIiFZ/jFUKJPQuXZa9/en9GphH6
	jpucwZ1XW41SJlvOuMxpovkTQuXYxNIuxqrzhpBD7UwgBUF6Xjl167kKJOFnwRv3
X-Gm-Gg: AR+sD13aTPPp8DiEt7d9hmwx9zz3WZ9G7XuU5Sl2clDVnIkyvh0XeVFXFDJj/edtuRn
	J02tHTB5dT6kTxoll6hGhBo/kFCQber2+gKoKnAV2BTdl8Ie2llGjjorXIQnnLHodo1ACnuvXLu
	t3byOJP9LM6thpWmBAOgOSQiSvCmOLw3uEJqCUkua2VKTahs/4O51FxoDuOASdbS57IcYX/5tEz
	IxFVQ+OEBgL7eYoBjdoOQ0nrTGRbgq6zP3rviwBbDrM+RhwHyJJfSXVOGgwtAW50jL0JAMaHGeB
	WeufP3I2zhGToxQqkbfuyNJupY7/sqBw9sQF1tVPmi5nXOh9J/MaVz0X4x3Z/b39D4GXTGAz3o2
	gLqD1ydZCYN/oojzxmhPvWOgLNoYaq5bWT9u9NkncTr2D1ZRMgtRYDQJiMMBKniBJ4GlJR6stIt
	w1nc7YvXcH8msIDM7CXcYvCdMGGWK6Io7CP6bjPIHdEE+zhnNkeSOUaD6DwsMAA8sPxaJ815igd
	8ni0PaFMrWwYrsQjNZbKYvZKsqwcFdivaLv
X-Received: by 2002:a05:6102:580e:b0:76f:eaa2:6fa7 with SMTP id ada2fe7eead31-777f8568d68mr3785589137.2.1787235666423;
        Thu, 20 Aug 2026 07:21:06 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97c4e5b2043sm5909491241.0.2026.08.20.07.21.03
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 07:21:04 -0700 (PDT)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-74aa416ebb1so784758137.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 07:21:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqdUmLxuRaaMkeLNV0qO5kOAk4QyfcKlctFf4DS1+SjnKpGiyI5p4y/+oAm7937407s4z/jLLDrrZ7HSQ==@lists.ozlabs.org
X-Received: by 2002:a05:6102:5547:b0:74a:be82:73a6 with SMTP id
 ada2fe7eead31-777f947587dmr4062181137.8.1787235663175; Thu, 20 Aug 2026
 07:21:03 -0700 (PDT)
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
 <aob5h3hi8W0CKxXr@XiangdeMacBook-Pro.local>
In-Reply-To: <aob5h3hi8W0CKxXr@XiangdeMacBook-Pro.local>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 20 Aug 2026 16:20:51 +0200
X-Gmail-Original-Message-ID: <CAMuHMdURAXQ9KWpgnSvmODxsCzkUHUvzZMRwUpCFy9u1vZ0u8g@mail.gmail.com>
X-Gm-Features: AcwNN1XKREyvmd_Ub1hHfuO1mE81v8Yth4eEDLoppCvYaf9so8m5sqinHs46ozg
Message-ID: <CAMuHMdURAXQ9KWpgnSvmODxsCzkUHUvzZMRwUpCFy9u1vZ0u8g@mail.gmail.com>
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
To: Gao Xiang <xiang@kernel.org>
Cc: Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Michael Bommarito <michael.bommarito@gmail.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

On Thu, 20 Aug 2026 at 14:56, Gao Xiang <xiang@kernel.org> wrote:
> On Thu, Aug 20, 2026 at 12:00:23PM +0200, Geert Uytterhoeven wrote:
> > When NR_CPUS is less than 16, or when SMP is disabled, the default value
> > of 16 is invalid.
> >
> > While actual configuration picks up a sensible and valid default
> > (NR_CPUS or 1), "make savedefconfig" will still write a line like
> >
> >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> >
> > to the defconfig file, even if that matches the sensible default.
> >
> > Avoid needlessly enlarging the defconfig files, and reduce churn for
> > updating them, by specifying valid defaults depending on SMP and
> > NR_CPUS.
> >
> > While at it, make the prompt depend on SMP, as there is no point in
> > asking the user about the maximum number of decompression streams if
> > there is only one valid answer.
> >
> > Fixes: c9b47e6b23114e93 ("erofs: cap LZMA stream pool size")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  fs/erofs/Kconfig | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> > index 2dfc313588d283a0..37495e95a78d9bf6 100644
> > --- a/fs/erofs/Kconfig
> > +++ b/fs/erofs/Kconfig
> > @@ -132,11 +132,13 @@ config EROFS_FS_ZIP_LZMA
> >         Say N if you want to disable LZMA compression support.
> >
> >  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > -     int "EROFS LZMA default maximum decompression streams"
> > +     int "EROFS LZMA default maximum decompression streams" if SMP
>
> As I said, if NR_CPUS is meaningful for both SMP or !SMP, there should
> not be SMP involved in this Kconfig.
>
> In other words, if SMP below is just a workaround since some arches
> leave NR_CPUS = 0 if !SMP.  If NR_CPUS is valid unconditionally, I don't
> think SMP is at all useful here.

Ideally, this should be "if NR_CPUS > 1".  But we can't do that until
all (i.e. most) architectures that do not define NR_CPUS if SMP=n
are fixed.

> Could you just drop if SMP and leave this configuration unconditionally
> shown for users? It's easy for all users to get how this Kconfig works.

I cannot. There are +20000 configuration symbols. No one wants to see
questions that are irrelevant.

I can change it to "if SMP && NR_CPUS > 1", though ;-)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

