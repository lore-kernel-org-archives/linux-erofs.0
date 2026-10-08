Return-Path: <linux-erofs+bounces-4678-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37233CA6007
	for <linux-erofs@archiver.kernel.org>; Thu,  8 Oct 2026 13:12:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0r4R26htz308H;
	Fri, 09 Oct 2026 00:12:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2001:4860:4864:20::33" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791465127;
	cv=pass; b=k8SNkmnxiV1BIaEyYYXUdAQhrScrsI+TjElNRSwyewmCn0wwwtgedkm/jirwpluXnzJ0FOuvKP6P5CgjBE2XCd/7VB7DI01JD1gfBrfQMH4wZdF2tOp7ypnO1Vh/978/gUv2Ra3UxzI09HV0wVzJ9jxgQsFnxZzjsVrhRMtIBDf2+Cy86dtthCSu7pf5mAQEYazioQskoHo4RDg83eGRv9hzMK8W2vaoqwQZh7dI1fpSi20mNCTn+PHM6T7nP/RaBjnnwgk2+ZToGYFUmynkBD91Eg2v7pS08gPtieUwoMKWMejjydpCHSvHWrbCch1AI46fkp7xp08SQhdwE17fqg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791465127; c=relaxed/relaxed;
	bh=iKvCvNLW3/FKX0CTeYOFJ3eO60+sN0ydEfJGJYANz80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJL22kSEDwV6f3HDYKLUx/M7TOcKqxFVaGQG+sL9hVdQckWkbVLyhmsdI+g+rB1hbsCi452qr/kRU83gR3XLsiOxQ5zffj1zTq83XSnj1tkNFnga37baItBh2U1VSqQJRagHbJRFio05qpwSkWw37Lho3JAoLsQ0TpCPqIy510CMdMN8OVAk9Aa6w+/saTmdRm+8RLTagW/1WiBJ4UTbRnd+ofmBg2EmEKtxY4eV8mJCquW5hvezHDta0CelRLdyFUKdp0hgoaekucuk7H/udo/W3JQYCoPhzVw7k/bXea4bCY5JYCG/psHGWlGWcgphBlPjzwTXiFAsZGdUROHUkg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=p9AJRzu6; dkim-atps=neutral; spf=pass (client-ip=2001:4860:4864:20::33; helo=mail-oa1-x33.google.com; envelope-from=peacherwu969@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=p9AJRzu6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2001:4860:4864:20::33; helo=mail-oa1-x33.google.com; envelope-from=peacherwu969@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0r4P0nDHz2yYK
	for <linux-erofs@lists.ozlabs.org>; Fri, 09 Oct 2026 00:12:03 +1100 (AEDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-49e20441e45so468266fac.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 06:12:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791465121; cv=none;
        d=google.com; s=arc-20260327;
        b=WLL6g43MOZArzbDctj95s36GgOwElZnrqFdlQRxQlJp+GK6fh9UFP9SqXQ7O9x22VB
         kFDgGeSaeKlQCExrVFtIlTT4/1J+i0IWSiWQUc/zX+T1dYmWVsSut0pVyrdHZ0/3L7xP
         Lpy4/xdP9Ot6c9iVnRMCsbuVGWyg7fsSKH0kZff4iqrSPSMECzmweY4SE7yar0a5qjOM
         Hg1/LbAbXsCWiE98T+wE+b0D8dGqqM4NhqkoVMyiplxDRP4UG2/2QeeFb280NpcXw0MO
         RtglWHBY1mDThlAGvBSLk4vvOGOYRRILFAaUh8ayWDrDJapSYOlizLtXMHWZXaGpoepA
         wX7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iKvCvNLW3/FKX0CTeYOFJ3eO60+sN0ydEfJGJYANz80=;
        fh=YGYO73auV7LYsNQb4pS+eEkcpAjXmOZdt3j0wXA8kgg=;
        b=TBH0Ao4JrUgpN7GiIZq4+0TJDFTG6+CPbwY/8CdaqAfDJyRxV9fTniwhzxIfe5orLH
         8pI4DSho02GWLN03qPqhY9WQSCIYOy78FKqWXrNwU8Mc1oyLH4C3YYLV9ocxJVqvr0M0
         u9C70350nEbwcFDKRACC/W/IH3z4YSYyLJwekKWbhOdBF3pUs13ilYyXVUg9s7vCUys+
         oxPquwjFzXm20kVjkB0hb2tqchOnkJ7eF/KrbLyQZiqWjo3ZsvYXMzb5ry9wlKWqr5Z9
         hybi0oGurRs50qPJkdpierOoTcePKlSsI/qvYNrRa9okI2D6ToQClJ/bnzcle01TP+8W
         0WEA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791465121; x=1792069921; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iKvCvNLW3/FKX0CTeYOFJ3eO60+sN0ydEfJGJYANz80=;
        b=p9AJRzu62kyHJd41SIpwp6rJLks92Q5C4PZtHMlP5DCOM3Uc3uCxYFv88M7S0DeZCZ
         MtlGVNsRsaFf6uesEUqE+cFQYKfMpA2vR2QYXvOMtbIM3kBG8UjB3U3DAvc22MOufeWF
         mcE35uD4ghi2IpT95ecj4k51NLU/sHmbVmAlWr1NwmFjGNQK/PDZ0aWUSExOH4mR8Rmq
         ZR8bE6WvPBO3ObeUtQifqoLNa5I+t6eSnW71GmeVFixvNEw1NKUD7sQZ7yXLnhUuap1Z
         4/4MdDUSfIMonmnDYOigfubuZP3cJgy1C3TdFh0EDB9pr9ibuP1xecUO7X+P+BlaOti4
         9cBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791465121; x=1792069921;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iKvCvNLW3/FKX0CTeYOFJ3eO60+sN0ydEfJGJYANz80=;
        b=cnPVmGDYg0P+fCQNs2eb2zpQNQ7TP0hhWdEtPunBAUNuTmNelKjziiDqQGtrz3Fnvs
         Gz4M5gr0IyHZg1GtOfSBR/fhYLRMAK5rXnAxAU63/LeZGddayXzVP1L+x+tYcViklKwR
         zNlFV2sfytyofv5kTx9MyACL/5+Qe+zElHQ57cByuRKsaHN0Zp0zvjF5RcQ76zhLjGPH
         8WRaa/pb4jgUlLdxM3AqmQ4OdAsU5OgLlBpvZJNMN09bLP1Bsi76fGyyU1zfROydoCsC
         lOOwT6P9Rl7QkoWR3I8LWykMLzqnlP73/6gou+LOwbvnxFzW0+kDCZKvtIiSAs12g7J0
         SnEQ==
X-Gm-Message-State: AFuF++nNbQhXUBK1HIGDf803HBosRJqpYW7JkrFEimY8pG4c+Xj7wjM0
	MK00J1ni9Gsgq7om9xabEeIPR/UhrYaCusuhSYINa7MlmicsdpOizXdF7vhP0d41XTtQ/lUrf+L
	MsEmYWaYXcZ0dR7CkymdkzYzwH79Uses=
X-Gm-Gg: AYBFou2oYXf6pJr+krGZYT/218nkKCXRwIZ3p0Dzbv2kiT3+wKyvv2vBy3D6+Gx3zNv
	yUENgL4LXoCGj7jI9t/GnwXjB5H2ZI0CCvdBvokoz7QarfCKTe0vD+esL7l95gfi9iNcGYlbBjk
	ocuA/SEdC201v0VdeQPPmpNiLeyohxoGREUQydoDXdNzMo29MrqbjbZPwe0/jaf9VFd43sIhfhw
	dMN9Tw1UVQ6PN85m2SqBK2tb+u6DOMXxbRbIREQhGRzI7U3nK3c/Sb2WY24QteD+87QHhdwRr3o
	8oEgYyDL71OurtQYJAChtlubeW7isnZZUCLSMBeOfHNO5OXFaQOi5NYOMEzgXONTfhqZsbMBtFh
	Yqd0xv0fayvXhr0LXcsI=
X-Received: by 2002:a05:6870:51ca:b0:47b:e30b:893c with SMTP id
 586e51a60fabf-4a28047e1cfmr1361419fac.6.1791465120602; Thu, 08 Oct 2026
 06:12:00 -0700 (PDT)
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
References: <CAOisCUPoZyE7TBoEW_O=06cJSCrMZSzBEzLaKMRKtvffB3pqdw@mail.gmail.com>
 <asZkUv1TfTfWG0a8@MacBookPro> <CAOisCUPYSeyRtxzRiDhMcRO9rFBTCfOmzszj0mtO4KufpmyBLA@mail.gmail.com>
 <CAOSmRzjAi4ZV_Sgz6om8t06faX5Q5b2LbuhkEMCdJbq84ErY9g@mail.gmail.com>
In-Reply-To: <CAOSmRzjAi4ZV_Sgz6om8t06faX5Q5b2LbuhkEMCdJbq84ErY9g@mail.gmail.com>
From: peacherwu <peacherwu969@gmail.com>
Date: Thu, 8 Oct 2026 21:11:48 +0800
X-Gm-Features: AclHuK_h-mnuGxKVorcsMA3a5JBpQF6f5gpRaHazoHIJJEZ3qNna-M5e4o-gr78
Message-ID: <CAOisCUMZXvC+CG-yfkm06RhCLfC_ED7gzNJCqNUaG=S_3tzR+A@mail.gmail.com>
Subject: Re: [RFC] AceDelta: OTA delta for EROFS images, 30-40% smaller than
 AOSP 17 delta_generator
To: Kelvin Zhang <zhangkelvin@google.com>
Cc: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com, chao@kernel.org
Content-Type: multipart/alternative; boundary="000000000000242022065d53fa0c"

--000000000000242022065d53fa0c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Honestly, I don't have a plan to open source the code yet. Is there a way I
can help? I have removed the `sudo` requirement of the eval binaries...

Thanks,
--Peacher
On Thu, Oct 8, 2026 at 12:57=E2=80=AFAM Kelvin Zhang <zhangkelvin@google.co=
m> wrote:

> Hi,
>     Thanks for raising this to us. We would love to deploy this in AOSP
> OTA stack, but in order for AOSP to use AceDiff, we AceDiff must be open
> source as we need to put it in AOSP eventually. Is this something you are
> willing to do?
>
> On Wed, Oct 7, 2026 at 9:31=E2=80=AFAM peacherwu <peacherwu969@gmail.com>=
 wrote:
>
>> Hi Gao Xiang, Kelvin,
>>
>> Thanks. Understood on reproducibility; I'll keep improving the matcher
>> empirically.
>>
>> Kelvin: most of the size gain comes from closer internal file pair
>> diff-ing, plus a solid LZMA stream, which is why the applier RSS is boun=
ded
>> by a window (530 MB). If you'd like to reproduce on a specific pair, I c=
an
>> point at the public OTA zips.
>>
>> Thanks,
>> --Peacher
>>
>> On Wed, Oct 7, 2026 at 11:25=E2=80=AFPM Gao Xiang <xiang@kernel.org> wro=
te:
>>
>>> Hi,
>>>
>>> (+cc Kelvin on this topic)
>>>
>>> On Wed, Oct 07, 2026 at 10:58:10PM +0800, peacherwu wrote:
>>> > Hi,
>>> >
>>> > I'd like to share results of an alternative OTA delta generator/appli=
er
>>> > for EROFS partition images.
>>> >
>>> > AceDelta diffs whole EROFS partitions (system, vendor, odm, my_* etc.=
)
>>> at
>>> > file level, recompressing lz4 clusters on apply. Compared with AOSP 1=
7
>>> > delta_generator (minor_version 10, -enable_lz4diff)
>>> > on seven real consecutive-build pairs from five phones:
>>> >
>>> >   Device / builds                    AOSP MB  AceDelta MB  Reduction
>>> >   OnePlus 15      A.22 -> A.27        1152.6      683.7      40.7%
>>> >   OPPO Find X8 Pro C.76 -> C.79       1059.1      733.1      30.8%
>>> >   Xiaomi 15 Pro   2.0.105 -> 2.0.214  1038.6      655.6      36.9%
>>> >   Xiaomi 15 Pro   3.0.3 -> 3.0.7       833.4      490.4      41.2%
>>> >   Xiaomi 15 Pro   2.0.214 -> 3.0.3    2657.9     1685.8      36.6%
>>> >   Nubia Z80 Ultra 16.0.12 -> 16.0.16   767.9      514.7      33.0%
>>> >   Realme GT8 Pro  A.68 -> A.71        1268.9      878.1      30.8%
>>> >
>>> > Generation is ~2.5x faster than delta_generator; apply time (on PC) i=
s
>>> > about the same (single-thread 8% slower, multi-thread 20% faster usin=
g
>>> more
>>> > RAM). Hash tree and FEC are
>>> > regenerated at apply time by my own implementations. Detailed info,
>>> plus
>>> > Linux evaluation binaries:
>>> >
>>> >   https://github.com/peacherwu969/acedelta
>>>
>>> That is a great effort. If you're interested, you could seek
>>> Google Android staffs and see if they are interested.
>>>
>>> >
>>> > A question for EROFS people. Both AOSP (lz4diff) and AceDelta must
>>> > reproduce the lz4 compression exactly; mismatches are patched with
>>> small
>>> > fixups. Although AceDelta is doing better than AOSP in fixup sizes
>>> through
>>> > lots of experiments, it's still like shooting in the dark. Is there a
>>> more
>>> > systematic way that ensures exactness?
>>>
>>> I'm not sure if it has a better approach since it relies on a strict
>>> compressed data reproducibility of the compressor.)
>>>
>>> >
>>> > Is there an EROFS WeChat group I could join?
>>>
>>> I will message you my own WeChat number privately since I tend to
>>> avoid leaking my contact info publicly.
>>>
>>> Thanks,
>>> Gao Xiang
>>>
>>> >
>>> > Thanks,
>>> > --Peacher
>>>
>>
>
> --
> Sincerely,
>
> Kelvin Zhang
>

--000000000000242022065d53fa0c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Honestly, I don&#39;t have a plan to open=
 source the code yet. Is there a way I can help? I have removed the `sudo` =
requirement of the eval binaries...</div><div><br></div>Thanks,<div>--Peach=
er<br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" cla=
ss=3D"gmail_attr">On Thu, Oct 8, 2026 at 12:57=E2=80=AFAM Kelvin Zhang &lt;=
<a href=3D"mailto:zhangkelvin@google.com">zhangkelvin@google.com</a>&gt; wr=
ote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D=
"ltr">Hi,<div>=C2=A0 =C2=A0 Thanks for raising this to us. We would love to=
 deploy this in AOSP OTA stack, but in order for AOSP to use AceDiff, we Ac=
eDiff must be open source as we need to put it in AOSP eventually. Is this =
something you are willing to do?</div></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Wed, Oct 7, 2026 at 9:31=E2=80=AFA=
M peacherwu &lt;<a href=3D"mailto:peacherwu969@gmail.com" target=3D"_blank"=
>peacherwu969@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,=
204);padding-left:1ex"><div dir=3D"ltr">Hi Gao Xiang, Kelvin,<br><br>Thanks=
. Understood on reproducibility; I&#39;ll keep improving the matcher empiri=
cally.<br><br>Kelvin: most of the size gain comes from closer internal file=
 pair diff-ing, plus a solid LZMA stream, which is why the applier RSS is b=
ounded by a window (530 MB). If you&#39;d like to reproduce on a specific p=
air, I can point at the public OTA zips.<br><br>Thanks,<br>--Peacher</div><=
br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Wed,=
 Oct 7, 2026 at 11:25=E2=80=AFPM Gao Xiang &lt;<a href=3D"mailto:xiang@kern=
el.org" target=3D"_blank">xiang@kernel.org</a>&gt; wrote:<br></div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">Hi,<br>
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
</blockquote></div><div><br clear=3D"all"></div><div><br></div><span class=
=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_s=
ignature"><div dir=3D"ltr">Sincerely,<div><br></div><div>Kelvin Zhang</div>=
</div></div>
</blockquote></div></div></div>

--000000000000242022065d53fa0c--

