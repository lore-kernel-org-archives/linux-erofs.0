Return-Path: <linux-erofs+bounces-4208-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2ABBC5B572
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 14:13:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKr7h56yCz2yv8;
	Thu, 13 Aug 2026 00:13:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786544016;
	cv=none; b=Ypb2v46uM6noiI1Z6O3pXToXl1so7pR6Nw/WPqQ9Tp/IVtPgB2usebQaqQa5uPiDtwSGGf+A7JsxXPVZ8o8ElGmYobLFh2Klo3bbPR2GmVfjlJ5se/PI0jBibTcu4WXjAwqSi+pf4bZ2KVKtGwEExinsknki1dLdWeP7JCsEJeFL0sd+IXfl+82F7jU3D4bcXUh+6m8n8cozn/b0q4PQuVZlfQvfiXx3OSmywbLjbX8npGupPGWZW8+Qulx6wWPWT65ODQNzPOst/hCRB+8CpntYcMu+5MeLjWlnIqQyvxKc0lLqbXDSMRRlLol7kX5OC/cs1OQnqgll7G0rG2xa/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786544016; c=relaxed/relaxed;
	bh=S4MtQJyf6vxe1tj+uu4KyqLyWiap9ANUV+nmt4DryVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVkC4fzJBdc43Gm+wE2NQF3OvvFTraHrLefTwzv7eiYojk+r8dPld0tnvsTExImxwaqqkWnag7kvmtkI29M6nond+BSR7K0k8TC83nMGU3jK1iIzdKP0zfn6LlzmgJa59IluOb6F3OYWsqBovipSZMRT3p+we4HVsZqkNwzdH98RhaUxlaweky2Csns7cQGWQs85sodA60voT+k0D+i15QDl9+lJfgJ+WEL0DtoyuHOuoXtqyG5s/uOl7/C0rtRwFjgeK7yy7/cVVi8xd6xdV82dj4LiiOSEFChkXthbZT/j+GtuZAiSc25hw4fHzY75fckBnDyLiae2WL3UtW4TMQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DBIOqa+F; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DBIOqa+F;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKr7f1CQFz2ytv
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 00:13:32 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1A7741897;
	Wed, 12 Aug 2026 14:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB2A1F000E9;
	Wed, 12 Aug 2026 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786544004;
	bh=S4MtQJyf6vxe1tj+uu4KyqLyWiap9ANUV+nmt4DryVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DBIOqa+Fp8d+VPNyunya13/Z6aaMGm8OKA6TokkV79wrEc2wVtPuaYcrXFLoINZaD
	 2FKrm2a8ZvGTwv0G0WLF+z/cBFvgjpmqR0xqhAhIepnzNd588PWyB1G5V3foWWN8es
	 y0mb3U6h479rZmD0A6+2v4sZ9h3aRTQMfoOiBv/vOM1DTSKc3OdCsoAL8+iFibgQMd
	 /pMpLJ2DNA9mDA+0vZHS//Y+Ra2s3QaMmyH9qJM9pQ6ZOSO7i1kOU39VJS65mWYEIl
	 obgy0D0h4/0kfj0mM1Gb6f3aGbGUAQ6irKf4F+tCTHFWFRRXJx5x+IuTliVyZNT7Zr
	 +xX30vIipG23Q==
Date: Wed, 12 Aug 2026 22:13:14 +0800
From: Gao Xiang <xiang@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	SJ Park <sj@kernel.org>, Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
Message-ID: <anx_esHIs06W3tKk@XiangdeMacBook-Pro.local>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Gao Xiang <xiang@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	SJ Park <sj@kernel.org>, Guenter Roeck <groeck7@gmail.com>
References: <CAMuHMdUO8_BY514PhSXeEPABCoeaJcEk1TimzxvtwPz6zFA5nw@mail.gmail.com>
 <20260812131144.30802-1-xiang@kernel.org>
 <CAMuHMdVgjeRLGKwiWsFWfmh=1cStyh2PmLdw1xzyO=ighGRbTA@mail.gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdVgjeRLGKwiWsFWfmh=1cStyh2PmLdw1xzyO=ighGRbTA@mail.gmail.com>

Hi Geert,

On Wed, Aug 12, 2026 at 03:34:58PM +0200, Geert Uytterhoeven wrote:
> Hi Gao,
> 
> Thanks for your patch!
> 
> On Wed, 12 Aug 2026 at 15:12, Gao Xiang <xiang@kernel.org> wrote:
> > CONFIG_NR_CPUS doesn't define on some UP platforms (e.g. arm), so this
> > can cause make oldconfig to loop indefinitely when CONFIG_SMP=n:
> >
> >  $ make ARCH=arm allmodconfig
> >  $ sed -i "/CONFIG_SMP=y/d" .config
> >  $ sed -i "/CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS.*/d" .config
> >
> > EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
> > EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
> > ...
> 
> This also fixes EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS silently becoming
> zero (and thus breaking decompression completely?) for "automatic"
> configs like "make allmodconfig" or "make olddefconfig" on architectures
> where NR_CPUS depends on SMP (which is most of them).

Yeah, unfortunately..

> 
> >

...

> >
> > Reported-by: SJ Park <sj@kernel.org>
> > Closes: https://lore.kernel.org/r/20260728065447.91511-1-sj@kernel.org
> > Reported-by: Guenter Roeck <groeck7@gmail.com>
> > Closes: https://lore.kernel.org/r/87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net
> > Fixes: c9b47e6b2311 ("erofs: cap LZMA stream pool size")
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Gao Xiang <xiang@kernel.org>
> 
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks!

Thanks,
Gao Xiang

> 
> > --- a/fs/erofs/Kconfig
> > +++ b/fs/erofs/Kconfig
> > @@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
> >  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> >         int "EROFS LZMA default maximum decompression streams"
> >         depends on EROFS_FS_ZIP_LZMA
> > -       range 1 NR_CPUS
> > +       range 1 NR_CPUS if SMP
> > +       range 1 1 if !SMP
> >         default 16
> >         help
> >           By default EROFS allocates one LZMA decompression stream per CPU.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

