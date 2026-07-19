Return-Path: <linux-erofs+bounces-3939-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA866C44512
	for <linux-erofs@archiver.kernel.org>; Sun, 19 Jul 2026 18:43:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h3CFn4Kksz2xC3;
	Mon, 20 Jul 2026 04:43:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::82c" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784486589;
	cv=pass; b=Tae4KisMJ20h2Kl5CKd7zni6R2vrmfFP84lNVB8L93O5Gp9PfDmbBh+gdI09Acyg80nrs4rvTo9JWS1e/Onjg656O3Bnh+sJuRnxoAoRUxnFmH/BDHUWj9epa4WhNu/tOrkzx0guDjdoYQZ/Hq5rd+k1i/9p/of+sPANaJtnWWH0pBlu/Tz7zKIFCcRivPM2NdpEh0RfQuf463ej2moRH+hAia7d6EZTEytAVvZwiclYYY9Noq0EDSup6WbBcJbS+AYvHz6FKeIvbCqbw2MIeaQ1uiswmzY0rnvdxjCdyQUMvCqV33SMpHbHzXz9xSkCDFHoUduZp6fU3cN8c2hPjw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784486589; c=relaxed/relaxed;
	bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TaP+RGe9jTS0YeUO0GkoMi6tfFymhrHbXH4ZLVtKYb+K+7gef/dSHTwUwqud2eioiUsZQ584oubPMkgnESsu/l2VQ2SApXV9cayq53bfol9E4D5lf8p+Lbge1hgMVocLfOsMjkY6bmV2akqROrVp39WVmHSm/DO9Ty+wybIEMJ/v5Rj0Vynsckb0/7Oun2RdpidviGskwTXWitfI1HJoeA859Lg3qXsAkIBrA7vQ9zXKWPhySe9GaLIG3H3UxhiNRTUHP0uuDB82FcWXqL/17ZBVahkJ3ROH6QQ2Gbx9wctYSwpWYgx5kkzkN7lvqGYEpY6KRp7UYiE4emae+qjBIg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=JQTRdreq; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::82c; helo=mail-qt1-x82c.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org) smtp.mailfrom=szeredi.hu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=JQTRdreq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=szeredi.hu (client-ip=2607:f8b0:4864:20::82c; helo=mail-qt1-x82c.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org)
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h3CFk2Dgtz2xBb
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Jul 2026 04:43:03 +1000 (AEST)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-51c149c5722so39138801cf.0
        for <linux-erofs@lists.ozlabs.org>; Sun, 19 Jul 2026 11:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784486581; cv=none;
        d=google.com; s=arc-20260327;
        b=PX233H9KNyckTRKvB0p0Isl7Q3JzNOyW1D20COI9FtkbrciKnU10v2R9fW195lJryo
         29hWfSAqVFcp/A9Q1AjEf/RSVlqj/z5MEvTe5rNeH4hxbprZiYpxTKQBFYl18YQTMMsK
         sR7RSwlLUPQkLaNyeb2b+0fyMtt5o0UYcW8GlKV4bGTAhfLAOHGD+dYJ60O3OsvztEJA
         qJ09QjDXQZwVvpmbx6shIoX+jV20ZuX7gRhQxrCm43sPmTRv5CskHRBdKTAECTYni6lX
         qZqDOn2/VppoXWK6CSYrWwfNjKiLCKyMIz23a5CYimml2s6mMau7y8Utm17ePWe7hc/V
         3NDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        fh=Hv0BfH3MQhbb/gIEbBy4ritgAPeH/3eRB9Q7rekqAzA=;
        b=hW4C7MoeqdGuGcocXWjGdO3So+Mxt+VVsUdlJZ8UACVwwa8xyNUMG2pCsL2iOC4inX
         7u8fP8N1fbit7jDu43vPmLI3xmgPxUiiB1mr5HIhzZ5aEaCOgkg0ntl9b4Nrr5J5yzci
         /bJrDtDcKGsPZ7ozzZVNCX+Z3Ac9Yv5kHpqkkqjpqMEputvGvQXgQ2VdRP1iuJ0P3dfb
         A3ohDa2q7ZcY0nLwrrwrU7xxG7q8gB05cxdPcLBgtXnlOacXiq+sWlstJ4XwArwm7JAK
         Gyd5DFyT46QQ8Fr6O0Vk1qpFCFtaXn8lSG7TnV/Nc47tkgINCOO3WM5fZITLZUUE5bPs
         /4pQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784486581; x=1785091381; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        b=JQTRdreqzvc5qWTNJ3yqhGYAAQ0l083kJX2iUsabqGIuQM05lzu5clGVU6DgqWWF5l
         F+JCZxUwYkZZudizuSaBCM/wR/EgalHwqR5FqQ0E32cyXtznXzgD+sUkx5aWnEF2SwlG
         jnH2X6rzQqv1AQyCITJLiyAGSw9S3rIhc3M9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784486581; x=1785091381;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        b=dFQ9JfL39et9XWzdBZXl3FjFMNU+RAFsFp23g7oitsuexpfYdnuhrn9kky5cHmUPt0
         pcC1Q5sFg33bwSUiDxuZKG2vMzuofzoi3p8nbKpq6upViNoBFH+G6X2hqCvsMd6gyIKc
         tebIsnL37h1Sx6ZEUvsBko8sn1Xpg+ScEdrWenhOtK0Y91a2JhKM4XGKkXGgT9jUAeHG
         WlyEQepj27GFKL0toP815fv0nz/CyaazDePpZ0hizNgePBOmh8SVZEpiBh7+g8Xe+4ri
         Aef6Mf/nua9HBBZSpIf760u9kKgd/3RAEkq7yQJIlWYF9g/tph7g1EpKP4BspjZlmHW3
         3SJA==
X-Forwarded-Encrypted: i=1; AHgh+RoEROKlPGEH9N9ulOIiONZe039Lt8Ogc2N3FJbicTARDqkrLnaHPyWRwigEsz0s7c7V6iuL/6FUWScDew==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yx5To+Kr+npnGaPOXlPDUj7FMVTSNDMSYEnoUbwOamfhHpLT2+x
	yofufH2XLl+VFmdTrPTWfmMCdNaT697u23H+VbRXz9Wl76afKmHOvpBBrBbqtderbLkpCE8hw+d
	Q5rJtTvG3rjNfyz/AihXR58+FGVIbWGIkYW7nTjLCvQ==
X-Gm-Gg: AfdE7ckf3fgh6urcBdcsOLPjBfLzAm9ASCCg99DEzVq5OJt7ZjY8+rJ/akmheLL8bD5
	haQlDmB9Tt/cMFSOeXuxX6U7N1XasvZEpRakhyQFmv+XfRJ8j9Dl55a3SCfB3ODoIht5E8ecTlC
	Tv/UytgOGgVV42VNHWp5zY7dG5VZJ/6WWyjIWOTTfCLNDf+XT3hYdkTEaI27GkZntF9A47yBu93
	bDtPIpprqSiLFLojJ9zzCq3Ed+YLzv7Xc8/PH1wRJEn9y1UjeQmhrMhVcLzAepHokOMxlqQVUQl
	7hBo/MXag9p1Jfg9Vg==
X-Received: by 2002:a05:622a:1388:b0:51c:7aa7:e0ea with SMTP id
 d75a77b69052e-5212c20f0c9mr108504931cf.39.1784486580491; Sun, 19 Jul 2026
 11:43:00 -0700 (PDT)
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
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
In-Reply-To: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 19 Jul 2026 20:42:49 +0200
X-Gm-Features: AUfX_mxZAmDgP1C2hJYyCV36TzCfzCkpkn9ppyiNeH1CkViYcwVDmhXZWL-qKS8
Message-ID: <CAJfpegsS=aZABvwx56tfMtWzSsKWtR-N78q3YQ6JZ-nvQLUrGA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 Jul 2026 at 16:13, Andy Lutomirski <luto@amacapital.net> wrote:

> This gives me the willies a bit.  It's very cool, but it has some
> potential security issues that I think we need to watch out for.  As
> sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
> supported files-as-directories.
>
> Some questions that we would need to consider:
>
> 1. Can you open an fd referring to a "directory" within an O_ALT tree?

Yes.

>  What happens when an unsuspecting process gets such an fd?  Can you
> fchdir to it?  chroot to it?

Yes.   However you cannot escape from that particular base file's O_ALT tree.

>  clone its tree and possibly bind-mount
> it somewhere?

No, it's an "internal" mount, so no cloning.

> 2. Can you bind-mount *onto* something inside O_ALT?

Again, no, because it's an internal mount, not in any mount namespace.

> 3. Whose creds are used for which operations?

The creds of the process doing the operation.

> 4. Can you mmap the things in O_ALT?  Is this determined per object or
> generically?

Per object.

> 5. Would we ever allow FUSE to expose custom things inside O_ALT?
> What contents of O_ALT can a program trust come from the kernel and
> have the expected semantics?

I think adding such a plugin would be similar to adding a mount.  So
I'd suggest allowing it with the same privs (CAP_SYS_ADMIN) and
constraints (limited to the current mount namespace).

Thanks,
Miklos

