Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3B9606A31A
	for <linux-erofs@archiver.kernel.org>; Sun, 25 Oct 2026 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LcxwpNfL
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jCMWq2h3tz2xKQ;
	Mon, 26 Oct 2026 03:23:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2001:4860:4864:20::29" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792945431;
	cv=pass; b=NQCD4X4iU7b2808I5U/+NFBPeVDh90SAFa/C5UBHDw3+26sYeYcD/GT4KnKnJdMJTBAbADnrgTSnkyMN0JoMS2vM9tG60bzobN2vu41MaU9pBPk02AaOrDMfG10Lo49tEYmYEmQ1rYCaR5XSg6Wwwdg940L4GLBjUcfB4lG6vAzqLe925sJs7cz4pwnRCpgaIP6xfFB64rGUcU4iSLIzxMH9c4lC53RvfAjTsDcs3oXPs70ixhc84qRvKbNJxiqXS44ORjALItB7iAU9ErFcjuzBFjtKteAQuVax/hq44mESoacG5fx8uSojSSE9jRJZQToLs33Eq6FIESjdx/rU1w==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792945431; c=relaxed/relaxed;
	bh=czH0ttVUl8z31I00DH0m3mzJub/EtACzYcE8yvelnW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=QOvNbHO7v/zSc8abLLBWwqJ6akTxPDzsIpsvcAHkqJjHbLzSZSbiWwy7vScN6Tx7ln/l241aETwACQLei40ZRk6gYyf3jp48LEK2j+E6i7+vBIOyyp1F8LHjNSqq/1jao47Xkr8uNX0s4ldHjq05m+BrvfwwJS/uKKGfgoUoYl1+CQLq4t4lrN68EA4UxL4sSrzif5XheQuV+XlQUlcypBGBkevFXVS9jammD5UMimAnJ4FuaiP/uxNgUzMWN21bZY0VMan4gSGYiWIc3J21LA17i/5fM7ju5IirXGuTLi0HKDpCNxjsboq+vEIOPMFJYSqaQeWYonYUkmX1HRcEEQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LcxwpNfL; dkim-atps=neutral; spf=pass (client-ip=2001:4860:4864:20::29; helo=mail-oa1-x29.google.com; envelope-from=peacherwu969@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LcxwpNfL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2001:4860:4864:20::29; helo=mail-oa1-x29.google.com; envelope-from=peacherwu969@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jCMWn3TtGz2xJT
	for <linux-erofs@lists.ozlabs.org>; Mon, 26 Oct 2026 03:23:48 +1100 (AEDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-483c607ccb4so1235891fac.0
        for <linux-erofs@lists.ozlabs.org>; Sun, 25 Oct 2026 09:23:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792945420; cv=none;
        d=google.com; s=arc-20260327;
        b=f8/LG06F6vBk2WB6ECq8hH/n2o+Yw3R/a3ATeaKaIFn9gTkjuZsRccOry5F3EngjIU
         tvmogDRMTKcRrcdD8YbV0VxRt1tHTt202HzwI95ydfVHA8afjXPy5LbXUAOggzIpBbu3
         fCmksZuqTMCN2S+V4nJhMjtZLhJHOmtYpBYkI1fose1rHf+FAWl+Ww4MmoJH+Rn7Jo7Q
         Sr++8DadAOa3YSpPi26znfG3V4u1TdZ7Vfh9HP0lTY7rFzjkMjlyyzqMhJwqjxB5kkTe
         jeqMTjVNyER+ArayYX48U13hTph3RBUWwbwuMvXZKtP3XeywAnXhjvnpcA8noE6syG9k
         2f6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=czH0ttVUl8z31I00DH0m3mzJub/EtACzYcE8yvelnW0=;
        fh=atFUt/cx2bhR3GvvZJ5W4X9Q2/hOoMn1s9iBvU0zpXY=;
        b=RCSxg0fu680+kosC2HuNuEgw8rau1PpHosQKjacsxdzAm23QNzmIxDebI2CO1uszwQ
         rljDE/zeNVUMmfsKMIUEJrkrvF9OGltP7nyaQ7XH5pDTbU4jBlTCwi4k3s2wM2ibN2D+
         gX9oQmeW/vfW+t/OeHhGERvcXFfRHGwFh+k7N7GDsvkSRECHpR+RCCnYrRK87PsOk/gR
         B1231HwWNijNci9kgtxk9yAuMNzL/Jh99lB1MmH6eIBN+VA94PDBBaaA9Qe10wCvZQKl
         Di1nmT8oqyE976nyVHW38elCT3BcBOfm+8YHa7PSYPqUigCJLMpHw+JcuyLHnLdcGlhc
         QS+Q==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792945420; x=1793550220; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=czH0ttVUl8z31I00DH0m3mzJub/EtACzYcE8yvelnW0=;
        b=LcxwpNfL75BHKfCQLii02viCJWM48VGAtX5sqVX7RSwYNaJkHu4SgoSmUPnyY8pS+2
         cpyznPdXiHijkU7ZMeZJF+E4oeo6p3QNg4Xo6jlWYQQryyiUzTvHhLdY6DBL/j4dm9V3
         4F8GrrnhmjZp2wiOiOj+r/u596r+q4YYR+ka0Zdh72EI9PZ6pFGsc0TDMOrzv8EL5zuj
         MUVB1pXOJ2uNzRCu1opmCdNprRXXZtnFnmQv94m45YPQjIlHMMJ3hUtMWtfTdPKaEogG
         AiRjQrj4O7pQG2wIn7JnXAzS+vSZo7aF85JxKsnX9eY/MxPGMIP+mUY9LaGlOSdG8ZwZ
         lqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792945420; x=1793550220;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=czH0ttVUl8z31I00DH0m3mzJub/EtACzYcE8yvelnW0=;
        b=dseLBUAl84W7dh6chTodD+nOKFUHl/q6EPp6+AsOeKPxwiKRm4GO8yDjF6HR8uT+kp
         C15hM6VhgQ5++ss4Mo0lu+dFI9F7w0DEjoTxoPIHsRgUWDcZvsHtG8Ne8FfQBGFFiwAa
         UZSRGqCpQybbKqr2EwYlArt9S0X0U2IFUXBCAgBZr/E2KWJgQvF/JEa7QXVBgaC0ey5h
         pNmAoSvbVfo/BashTK8GBK2ZJiCy0rEIZIR24pPQzz0LJ4rambq7rWBAhGqqTdtcdlqW
         8SMSK0HRDBJEhTarpXtBJ6E0j10dffbaIdG1amWs++WeKkwt7AQVKpJX8s7iVzkaVtfg
         srDg==
X-Forwarded-Encrypted: i=1; AKwUvBxhvRIKMVadm+n6s67RcLErRx1UDyInDc3310VwuYWZ1Nd0etirPA+tCDdhsGGP5nJ3kpsLIPlPSJDFNQ==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIV/S/KuN9cxae3tdudPaWC36p9aOrLr0n8Z+Fq+djOEDfe3w1t
	sleCcKOYNr5Ax52U6XWXUv+u8qnqwk5JWEJkl9BOdY9LB2X3TvYipATRjzWM6mT1CCV8yO1TcnS
	///XUtmG0uDYYMEjXZNpmZaXOISY1HAI=
X-Gm-Gg: AYBFou2mfjwdAH4SxGoVX1x24SGJmWVtddu+FTGOJw8xQl4DtfDz/Ng0L6Sw/CN6DvD
	ceUEfyGERFrykZwT35NmQj1bb8KI5ST/nndmM1aZc0VFTKhPTgi9EALjeeMkYOLTn1uVqGv8bbw
	uOgcsv3Q6qFstdjKXlnl0AKy+YSzKLiKF6mFnm/2IO6cTQZgSPaR0P/9wk7KjRDdwyqXZNkhft2
	tpca9Og/S9GcXGaBxKueGLWomGjtIQSFTB1mgLM25z1Mn7a8kxZfNnv+p9Cn6MaofueAwt3Mwfq
	8u5BUNIfSjhkvK8gbbUGlVQg8vDCVBfCLrlrC8Zwn4tFrBfR6IujLPrzxYwJtssinGD+RyldebZ
	nQCD5+zwqWkk0lrgiec9/djo/Dgi8k7jYASLD8iqK1GXF0a8GF/l4Ow1dVSaMKtjSWwNoIFTh5y
	ZY8XAQ+RS0kA==
X-Received: by 2002:a05:6871:4087:b0:4a2:4c5c:ff22 with SMTP id
 586e51a60fabf-4a83f633c48mr2961322fac.56.1792945420522; Sun, 25 Oct 2026
 09:23:40 -0700 (PDT)
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAOisCUPoZyE7TBoEW_O=06cJSCrMZSzBEzLaKMRKtvffB3pqdw@mail.gmail.com>
 <asZkUv1TfTfWG0a8@MacBookPro>
In-Reply-To: <asZkUv1TfTfWG0a8@MacBookPro>
From: peacherwu <peacherwu969@gmail.com>
Date: Mon, 26 Oct 2026 00:23:29 +0800
X-Gm-Features: AclHuK9LfwZjAeTzBH8Myr18vT1ZuZ6icVqs2pvwjzQwMT3kpZ9b2z15s8C677U
Message-ID: <CAOisCUPX4=nOgGkRE8ErU67vaTpk6WawmuWyHAQqisjunHi5gg@mail.gmail.com>
Subject: Re: [RFC] AceDelta: OTA delta for EROFS images, 30-40% smaller than
 AOSP 17 delta_generator
To: peacherwu <peacherwu969@gmail.com>, linux-erofs@lists.ozlabs.org, 
	hsiangkao@linux.alibaba.com, chao@kernel.org, 
	Kelvin Zhang <zhangkelvin@google.com>
Content-Type: multipart/alternative; boundary="000000000000e459ac065eaca2c2"
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000e459ac065eaca2c2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

After learning EROFS src code, I was able to replicate LZ4 compression
exactly, no fixups needed. At least on all my test data. Repo updated:
https://github.com/peacherwu969/acedelta  Thank you, Gao Xiang!

Best regards,
--Peacher

On Wed, Oct 7, 2026 at 11:25=E2=80=AFPM Gao Xiang <xiang@kernel.org> wrote:

> Hi,
>
> (+cc Kelvin on this topic)
>
> On Wed, Oct 07, 2026 at 10:58:10PM +0800, peacherwu wrote:
> > Hi,
> >
> > I'd like to share results of an alternative OTA delta generator/applier
> > for EROFS partition images.
> >
> > AceDelta diffs whole EROFS partitions (system, vendor, odm, my_* etc.) =
at
> > file level, recompressing lz4 clusters on apply. Compared with AOSP 17
> > delta_generator (minor_version 10, -enable_lz4diff)
> > on seven real consecutive-build pairs from five phones:
> >
> >   Device / builds                    AOSP MB  AceDelta MB  Reduction
> >   OnePlus 15      A.22 -> A.27        1152.6      683.7      40.7%
> >   OPPO Find X8 Pro C.76 -> C.79       1059.1      733.1      30.8%
> >   Xiaomi 15 Pro   2.0.105 -> 2.0.214  1038.6      655.6      36.9%
> >   Xiaomi 15 Pro   3.0.3 -> 3.0.7       833.4      490.4      41.2%
> >   Xiaomi 15 Pro   2.0.214 -> 3.0.3    2657.9     1685.8      36.6%
> >   Nubia Z80 Ultra 16.0.12 -> 16.0.16   767.9      514.7      33.0%
> >   Realme GT8 Pro  A.68 -> A.71        1268.9      878.1      30.8%
> >
> > Generation is ~2.5x faster than delta_generator; apply time (on PC) is
> > about the same (single-thread 8% slower, multi-thread 20% faster using
> more
> > RAM). Hash tree and FEC are
> > regenerated at apply time by my own implementations. Detailed info, plu=
s
> > Linux evaluation binaries:
> >
> >   https://github.com/peacherwu969/acedelta
>
> That is a great effort. If you're interested, you could seek
> Google Android staffs and see if they are interested.
>
> >
> > A question for EROFS people. Both AOSP (lz4diff) and AceDelta must
> > reproduce the lz4 compression exactly; mismatches are patched with smal=
l
> > fixups. Although AceDelta is doing better than AOSP in fixup sizes
> through
> > lots of experiments, it's still like shooting in the dark. Is there a
> more
> > systematic way that ensures exactness?
>
> I'm not sure if it has a better approach since it relies on a strict
> compressed data reproducibility of the compressor.)
>
> >
> > Is there an EROFS WeChat group I could join?
>
> I will message you my own WeChat number privately since I tend to
> avoid leaking my contact info publicly.
>
> Thanks,
> Gao Xiang
>
> >
> > Thanks,
> > --Peacher
>

--000000000000e459ac065eaca2c2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">After learning EROFS src code, I was able to replicate LZ4=
 compression exactly, no fixups needed. At least on all my test data. Repo =
updated:=C2=A0<a href=3D"https://github.com/peacherwu969/acedelta" rel=3D"n=
oreferrer" target=3D"_blank">https://github.com/peacherwu969/acedelta</a>=
=C2=A0 Thank you, Gao Xiang!<div><br></div><div>Best regards,</div><div>--P=
eacher</div></div><br><div class=3D"gmail_quote gmail_quote_container"><div=
 dir=3D"ltr" class=3D"gmail_attr">On Wed, Oct 7, 2026 at 11:25=E2=80=AFPM G=
ao Xiang &lt;<a href=3D"mailto:xiang@kernel.org">xiang@kernel.org</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi,<br>
<br>
(+cc Kelvin on this topic)<br>
<br>
On Wed, Oct 07, 2026 at 10:58:10PM +0800, peacherwu wrote:<br>
&gt; Hi,<br>
&gt; <br>
&gt; I&#39;d like to share results of an alternative OTA delta generator/ap=
plier<br>
&gt; for EROFS partition images.<br>
&gt; <br>
&gt; AceDelta diffs whole EROFS partitions (system, vendor, odm, my_* etc.)=
 at<br>
&gt; file level, recompressing lz4 clusters on apply. Compared with AOSP 17=
<br>
&gt; delta_generator (minor_version 10, -enable_lz4diff)<br>
&gt; on seven real consecutive-build pairs from five phones:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0Device / builds=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 AOSP MB=C2=A0 AceDelta MB=C2=A0 Reduction<br>
&gt;=C2=A0 =C2=A0OnePlus 15=C2=A0 =C2=A0 =C2=A0 A.22 -&gt; A.27=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 1152.6=C2=A0 =C2=A0 =C2=A0 683.7=C2=A0 =C2=A0 =C2=A0 40.7=
%<br>
&gt;=C2=A0 =C2=A0OPPO Find X8 Pro C.76 -&gt; C.79=C2=A0 =C2=A0 =C2=A0 =C2=
=A01059.1=C2=A0 =C2=A0 =C2=A0 733.1=C2=A0 =C2=A0 =C2=A0 30.8%<br>
&gt;=C2=A0 =C2=A0Xiaomi 15 Pro=C2=A0 =C2=A02.0.105 -&gt; 2.0.214=C2=A0 1038=
.6=C2=A0 =C2=A0 =C2=A0 655.6=C2=A0 =C2=A0 =C2=A0 36.9%<br>
&gt;=C2=A0 =C2=A0Xiaomi 15 Pro=C2=A0 =C2=A03.0.3 -&gt; 3.0.7=C2=A0 =C2=A0 =
=C2=A0 =C2=A0833.4=C2=A0 =C2=A0 =C2=A0 490.4=C2=A0 =C2=A0 =C2=A0 41.2%<br>
&gt;=C2=A0 =C2=A0Xiaomi 15 Pro=C2=A0 =C2=A02.0.214 -&gt; 3.0.3=C2=A0 =C2=A0=
 2657.9=C2=A0 =C2=A0 =C2=A01685.8=C2=A0 =C2=A0 =C2=A0 36.6%<br>
&gt;=C2=A0 =C2=A0Nubia Z80 Ultra 16.0.12 -&gt; 16.0.16=C2=A0 =C2=A0767.9=C2=
=A0 =C2=A0 =C2=A0 514.7=C2=A0 =C2=A0 =C2=A0 33.0%<br>
&gt;=C2=A0 =C2=A0Realme GT8 Pro=C2=A0 A.68 -&gt; A.71=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 1268.9=C2=A0 =C2=A0 =C2=A0 878.1=C2=A0 =C2=A0 =C2=A0 30.8%<br>
&gt; <br>
&gt; Generation is ~2.5x faster than delta_generator; apply time (on PC) is=
<br>
&gt; about the same (single-thread 8% slower, multi-thread 20% faster using=
 more<br>
&gt; RAM). Hash tree and FEC are<br>
&gt; regenerated at apply time by my own implementations. Detailed info, pl=
us<br>
&gt; Linux evaluation binaries:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0<a href=3D"https://github.com/peacherwu969/acedelta" rel=
=3D"noreferrer" target=3D"_blank">https://github.com/peacherwu969/acedelta<=
/a><br>
<br>
That is a great effort. If you&#39;re interested, you could seek<br>
Google Android staffs and see if they are interested.<br>
<br>
&gt; <br>
&gt; A question for EROFS people. Both AOSP (lz4diff) and AceDelta must<br>
&gt; reproduce the lz4 compression exactly; mismatches are patched with sma=
ll<br>
&gt; fixups. Although AceDelta is doing better than AOSP in fixup sizes thr=
ough<br>
&gt; lots of experiments, it&#39;s still like shooting in the dark. Is ther=
e a more<br>
&gt; systematic way that ensures exactness?<br>
<br>
I&#39;m not sure if it has a better approach since it relies on a strict<br=
>
compressed data reproducibility of the compressor.)<br>
<br>
&gt; <br>
&gt; Is there an EROFS WeChat group I could join?<br>
<br>
I will message you my own WeChat number privately since I tend to<br>
avoid leaking my contact info publicly.<br>
<br>
Thanks,<br>
Gao Xiang<br>
<br>
&gt; <br>
&gt; Thanks,<br>
&gt; --Peacher<br>
</blockquote></div>

--000000000000e459ac065eaca2c2--

