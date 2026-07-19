Return-Path: <linux-erofs+bounces-3938-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52579C4450A
	for <linux-erofs@archiver.kernel.org>; Sun, 19 Jul 2026 14:13:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h35G65H9zz2xyh;
	Mon, 20 Jul 2026 00:13:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::22a" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784470382;
	cv=pass; b=j3uIFm0FMPZ41rE/sptZfK7IplwHlBslflsZyu6wM0HGNrYR8Wp5StrYilne6GgU4djbkqNmeWIV9Sm/+ws7qfjBnITtyaYiufdouVI0r9jAV1YoJWGpIedNBCQEs+0uW75khkXxcTwXx+AQatSyyUB+cdXDgtwRp3xfhtmin30YiU+y29SywQScqSnBYS5weoKroeHW1FXcv6ZhVR/llSGYTCN7cxmFWEfFFsnOHf8VYlnDhxV5/99fdwiQAgPNdE131tHdKWWERwSxyKXROgLE/xLLtB6uqOW3x9Y3bM8jLUnUEQQzvV3jYfzQQzQElf7evhlOoiceRp9vkmOYew==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784470382; c=relaxed/relaxed;
	bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iwiXClzlRL/GE9N7vwm5kCv8Jr1EsqdWiVnrd5v7BeiquKmaqDLN+7FxxnxAKlv8Z/NNiBZA5m0Glyovt5b9i7Uq8/5y5/wGwqXWmJ7NEXpPJTrr0KCCnNAuakqV1jZsptS3oHhQXEOkiJytxzpkg0da9sEoK7GxfQp5GpQkt4SmHacXVbxqQ4+XkpVH19x6E5kYiQ9fcrb8EwGD4efLu71e2cd+oS1et8Yq0d/BX7uSaiei9r2KZTNKG8OKCRn6QSNuyvxaxDuzDbnpooUuxf3EoZTA0Sqp2h5M7FBHRMQkYsJ3uJFtjMLTtMIOwJvskrUWs8a7m6Ea1CMf9AvyjA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amacapital.net; dkim=pass (2048-bit key; unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=DnFomulV; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::22a; helo=mail-lj1-x22a.google.com; envelope-from=luto@amacapital.net; receiver=lists.ozlabs.org) smtp.mailfrom=amacapital.net
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=DnFomulV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amacapital.net (client-ip=2a00:1450:4864:20::22a; helo=mail-lj1-x22a.google.com; envelope-from=luto@amacapital.net; receiver=lists.ozlabs.org)
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h35G44GDTz2xd2
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Jul 2026 00:12:59 +1000 (AEST)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-39ca300db70so68553891fa.2
        for <linux-erofs@lists.ozlabs.org>; Sun, 19 Jul 2026 07:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784470375; cv=none;
        d=google.com; s=arc-20260327;
        b=RG7t4ahS3XJxFIJhLWoKf5BMFJJ4YPAV5PamR7ZDT5FSEGWIKn8Z5ko03Gfc/3FLuf
         Ox7Bt+InR7IhLFwO9Y6h0/l29FWBANzXD0O7fm+vj5ncD1o3dZVR+r4FMWVvM4VWApKN
         PYw4O2ovXVlHq06dlMn5oUUp58QHyutk0F7bXnqjUe9EKUIYz4LG0oeuRXwIOkQ7spTl
         JbIMqCh3vIEoM5EW9E9rBHfc/4Ul8k8jer0bs+8V8EOITNsvGsNvLPTu3IwNx4A/hfaW
         E61IlQ93fmBz8MeZykA5mbhtWlsWj46pUvO/AyAZ1m/Hem7l6igE1Ue65Nj2eHVA9Wqm
         dQ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        fh=A1kE6GlxEmTBOMfXBCVXpWqE6eASQeX9zW5iVVgGtcA=;
        b=KnlSeU6F15CeR2TzvzAu1JApHm47f3m9Pl30sIKUy9PVO8w0PpW0mkOGIyJ5mvLNNq
         p5IliR1636jDx761UXu2yVfPFZXIuqhevTyoFKHLZejlybrjF31k4wzqZoHF9V+W65UP
         CqxNMo84Cm966+nv17dzSJz7sDrt93qqoa8TNhkjzQY9GKlJ0NX2koxHHVHhjcUqmcMQ
         2Q6k06zJnOMqiDFm6+BAlcputvTBxnIl4FH+NhglAEVy9MGnv9ZjXI/Dje253oSKte5K
         jENXEz5G4nciwo4ojrGyySbiN4EmUzblPc3/lG5+gKwP8urycDKboNbTPNRGXY6iPV/K
         I4YQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784470375; x=1785075175; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        b=DnFomulVRs/gdPtuXHj+8M8rKbHfzyM3kGh4hAU5K8pZF0oaFE6zvVA0r0bFe4Rcdr
         UmcbVBvcQ9kHd9WVLdRgm5ANFNEcBndZGxtfgpjIPPaLgUu2LAw8tCgXuT3/458PUTUK
         P5W2+RCuWcdzAb2ObcrMGAxwJElXPRrThm4exQhSWnT4S1kcjNdIaz4Goa9J5LRN4asf
         64FTI9scMrrVmZ9gxZH/sRTDvb+mAyD0yLP33NtLL79cuUdHSFzhcBrkvVGtxe82CGJx
         rnNgUl9QKIhI9wRv9W8lQ11GC2mI2XqM2waHhtpWinxSrpzCvl68anmmKkW5b89snjwh
         evog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784470375; x=1785075175;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        b=FnLPjPm9WqeVau3BpjETAwyH7nF2b/C6XMhIZlxe33UbCbPj309iMNQKT+aE2pCfTg
         g0jsY1TT6rCX82yIb71mLCxAHkxkkrPQtjQF2nmXJ2stwWPqmxn4wLHrCZebBqCyRBN9
         ByeUxutTLDCcbzYqBr0W6DynnTauvqTCaQ8VAtgkmLoosu8zDTp+nxCdiuFo31g/f7uC
         I8CFKa5kzOT2F/m8ZnYd6+RoJftjHpreSqw9msySeDYsdL4GQw/EmnzBqsiiNfRxy01c
         2EIsFoGoLhKjITPKH8+QXpCa2ZsUYZX90boG6eG2bZ9n/FwcaqhzYUE92+waameqBNjK
         wo5A==
X-Forwarded-Encrypted: i=1; AHgh+RqBenNmCjF0uDgFYLga8msVeHhTwhLydLmE2v296zq53bMG8rFpP3E61wcbITUSyougQ9WXUH0QMhcf2Q==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YySuSm4ZLXA+YfjW5SucdPIHjXckU5PiIbnWJWQKgY5jFCCaCpb
	Q4JLvP6us6nw6OTrwj3YFiH0PulXLdCp1ZQKS7FElCOtfNl9mr0BKFOcz+1qWiQfHfEoWZxwtN7
	pVc1nzgNl4TLPMXYuTHFkEJPRgawn/CDoft3IJ5Ad
X-Gm-Gg: AfdE7clXoA26t0XznQpi+p0lb3c9Y1aNx7fYbPItQp3Hd5Co7TRjgsCQKcrxnMF4yPy
	YMsu3uAYnslYz8uA8CwTdObpE1C3GWv0pdbDQQv9OCCezvVYS7xSABUm01gwPQaUfo/wDJW0tke
	3A9RgyUTq5q54W4GO4oS5yzr0/vLms6zlRKmIYzImWaF1DvLdR6sxGzrpT5vYBIcd406GX61kH5
	f99CSARVpG//KlAQokMnWJ59dg4PJJiYH4RZEZFMyFv2eMz8dx0KJsy0Ck=
X-Received: by 2002:a05:6512:3d8f:b0:5b0:1879:1ba9 with SMTP id
 2adb3069b0e04-5b28f9a5720mr2256451e87.33.1784470374426; Sun, 19 Jul 2026
 07:12:54 -0700 (PDT)
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
References: <20260715101107.973997-1-mszeredi@redhat.com>
In-Reply-To: <20260715101107.973997-1-mszeredi@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Jul 2026 07:12:42 -0700
X-Gm-Features: AUfX_mx-VrWAtPNuDviKfVjbn51tqQht-nWAXr-HfoWBbjn3eDOh3hiCtUPefpg
Message-ID: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:17=E2=80=AFAM Miklos Szeredi <mszeredi@redhat.com=
> wrote:
>
> This is a prototype patch. Needs to be split up!
>
> 1) O_ALT / OPEN_TREE_ALT
>
>   These open an alternative namespace rooted at dfd - instead of resolvin=
g
>   the path in the real filesystem, it resolves it in a virtual tree that
>   exposes metadata about that file.
>
>   This is intended to provide an alternative to adding new ioctls:
>
>    - provides structured namespace
>    - allows accessing data through fs ops
>
>   Could call this O_META, but O_ALT seems more generic and there could be
>   uses beyond metadata (e.g. seekable, in-place decompression).

This gives me the willies a bit.  It's very cool, but it has some
potential security issues that I think we need to watch out for.  As
sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
supported files-as-directories.

Some questions that we would need to consider:

1. Can you open an fd referring to a "directory" within an O_ALT tree?
 What happens when an unsuspecting process gets such an fd?  Can you
fchdir to it?  chroot to it?  clone its tree and possibly bind-mount
it somewhere?

2. Can you bind-mount *onto* something inside O_ALT?

3. Whose creds are used for which operations?

4. Can you mmap the things in O_ALT?  Is this determined per object or
generically?

5. Would we ever allow FUSE to expose custom things inside O_ALT?
What contents of O_ALT can a program trust come from the kernel and
have the expected semantics?

--Andy

--=20
Andy Lutomirski
AMA Capital Management, LLC

