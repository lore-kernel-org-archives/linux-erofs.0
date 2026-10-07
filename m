Return-Path: <linux-erofs+bounces-4672-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00C93CA5FFC
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 16:57:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0K6r5wk7z30TP;
	Thu, 08 Oct 2026 03:57:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::112b" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791392244;
	cv=pass; b=NJr7MWR9lMldd+FCBipNcbfTny42I2uy/zL/CAJMsU9g9ZmQjee2eEo2VW31qYtSLcoZl8qzATojAcz11kVVwrDVjcNGGGdHIj60G8NQI7lW7ZUUo+sPF7qD/tpMbzII7y1TIAaZqSeoiUNjJDyrF2EdJG10A+YFAptMHX9GxLrQnqPL3Hu4Im2+YAIM8xMWy4wSdC1z2BoHrRITbIzo3PWKzCvBjlpsIWAL63ZaPyraBRRs4MqKcbyHbw0d0LNlI0sodZkaPc1ZdYJLNgj98C0WcPhqNl50vE2+Av/DEFsSH26I7KStR7Kedof/YmfeuqqoeC6zv58oKOfG6Kl9TA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791392244; c=relaxed/relaxed;
	bh=WjQh6R+qeIUlDjQ1j0vYJC1VeanLFpk21vQKGK+jy0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xa7N/R1REMi8ye9Tf1eFsFBy98wHONv2Qp7nPAokvvAc9AZxKHaKpDebh6AyeXT+qD/4B44CNmZqD23/O0GZ+/ASdaW/xllpBmXUw3ieZYtH0ZlB9BHqkhAdqqSw4MbpRbxQhD5jS+VrVG3E2uZujFuXcbROlJrsLtuCxZDP6z+9IHcptTG4KFv314MCHFViXqy/BJUEmLtMtfRCXzj2ewS66ptVTCiVYqeNjLrRkm4RkTtE0e8sXyGqgKB/lUAxSwP/XxSK8iveqYM0qLpC3Gr67KrC44OCL3wAP54V/1EZUCg/XCdmmkddvgxAWyZzaXBAp1bB9ipot7FUF85Vug==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com; dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=YtejFyNI; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::112b; helo=mail-yw1-x112b.google.com; envelope-from=zhangkelvin@google.com; receiver=lists.ozlabs.org) smtp.mailfrom=google.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=YtejFyNI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2607:f8b0:4864:20::112b; helo=mail-yw1-x112b.google.com; envelope-from=zhangkelvin@google.com; receiver=lists.ozlabs.org)
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0K6p4Ychz30Cj
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 03:57:21 +1100 (AEDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-8abd68b3937so42635927b3.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 09:57:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791392239; cv=none;
        d=google.com; s=arc-20260327;
        b=pCfY3ZyJWD+JohJpNsXXKimBw6Rd96nFHALukm4yQCikH+eZntEh54utMfrTXiG9Or
         jMkcXt2smEEjBcbkMjX9tVow88PpWV6qhC6NyWjgUHe9oyhO72OWUfkbgsviDQAJ9E2G
         +cMJg4cfwli9N087aARTFlk3JXQVj5fnwEMZcT3b/clKzG1RqP47sZao43rmw3sSJUf3
         lwRcujUK12uN/pT3k63bqoMhSwVFJukl2KPbfnc7eHt+VrxVo6XT1hK95kHm+YeB9F4P
         rtx/oa+qYK1dWnzALGA9ti0TiQ5HZmVvg9BJsaHQAwxXZoVVPMc43koOXVdN6xkMBO63
         +y3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WjQh6R+qeIUlDjQ1j0vYJC1VeanLFpk21vQKGK+jy0A=;
        fh=uq8nXMibVENnj0oYFfwvVBVD9ZYHU7s4PQLwUVSVx1U=;
        b=qQzpcouUiZ+OLSNxfoEoD/NGhf0DPtChWIQLbU4Nr22pIYaTWOqONTlwOuifevG2yL
         fniA3+SmiutSLSrNe+8FBdINhoaEKsn/LR+uInUG9bM+phGzDK7JfDdTR6YFYquw8cYd
         txdWBYkZDaI5uS1yzl8uObbkpwsxCq5o49J064lU1twx66lEklKBQ4JYPN0KzgM1Ms7D
         f4TmfSK3E9EpWGDvfkjwLyTfouVLKZS/6LCvJyY+IlBxrlYSDKFLudu8Q0NFsOkW3v7f
         csC3ZjrFqzEamxCZOCqfRU2zHIFrjnCdSUCZ2frVPDh+F1ycorTjvAz7CWHAwGf0WJYT
         JfdA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791392239; x=1791997039; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WjQh6R+qeIUlDjQ1j0vYJC1VeanLFpk21vQKGK+jy0A=;
        b=YtejFyNIbNa3OBaj1SWRmzjXsnEAJKao81drxUQqb8p/HRMaIkCq3IjslFqfpWUbbk
         /GF9/IpRFJvJjDaRV16fHU/v2WlTp6q2PaC55bFU9inBY7LgLOyVQeUAEZpUkYSBpE91
         78HUnCGyaRB9m1cCihgVca8g4QMaWs9hOCMb84jWc0cquepaOf4vsq5xzXR/syEzNU7/
         ltWwJXIHMla02VSydLY7QACOG6X4p67SLXBKohZJvi/kugAt8alCIrBIaZeQfW6dUpk4
         5MrxXc5vmEG4hyaGbabFlDdF4OgASw9lUGnD1QXJXVbTOm8/eEiHnBLONki3dpinEAfe
         cvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791392239; x=1791997039;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WjQh6R+qeIUlDjQ1j0vYJC1VeanLFpk21vQKGK+jy0A=;
        b=qKvFngjbLHD5pAR+XTdz0p1g/tszthgsPbztXysc+AeaP5C0e+3Ep1l6OAdHy+To1j
         05HwyzkdXvdwieHnh5/joiei3Jbkvv7qMFmcPfI9RnMPTx3INhgu5dqJ6JEAQpBZrlHk
         lfwg7c3PN/raaL7Q/irqPIRq6UloNU3j5xUCesNvSIqWBvc4EZdLeWccIaD71SCRYrMW
         1f1C9JCUiWy2qws0CB9jTyqRT5CDN42J3Z3bZb2LQewBadznaxwP61hvNlaAtFugIzOq
         XivVVTQuBaIYUaTVr0ob2pgDa6Rotpt3jC4ydH03kAFYG9DglqHj3CUIaoH4/58mlApM
         4CRg==
X-Gm-Message-State: AFq9FYI5etMI9k/xxhTIM5yWfFKi8gqNEqP2/0IYz6rf99Bgac/aQyLR
	cOrh80EEMBnZGFwCtP/0vWPnGBStvksdQpe5HjjDz48fmf3VEWYces4kZOlef/oampiUDUoVELT
	a6j+r3FXxns/B1gn5VDJ+ZfBwT7PIJbxeZPneYGHn
X-Gm-Gg: AYBFou3N2x5sQU5ZaO9qBywWcndtnJ0eQIuUWP1yeAZRRg/YG6Sna1jHU6ByYOcMTag
	dwkpZc/lk8CjX7XOkIZlHUse1uLefzkOzyqHDV2+Qs95ZRkHox4RPPHFqO47B7nyDNFjNP3U67b
	/ciRoZDd543leVnGc0kT35T6MX5WuHTKrLOajsOcy2hL1H0LvEvcRogdiQExeUEMd6qA5Yz1zoy
	LW7bPEc1/zQ9cp1dLbnZ1F5FXL9AP35CRTyW2ZqZjnEcr5JNUlKdzu/Mz5dIRWR20esERJ+gN1R
	SlzA2I9wOcZvX8ScZ5Q+4M7cilTOhGkTJhBKY2CXz4OERdhs4+Yp3PoUvFsQAb08M/WAZkpb09z
	R8IaxUJ20
X-Received: by 2002:a05:690e:1347:b0:677:c075:a599 with SMTP id
 956f58d0204a3-6790a3bc9fbmr1521976d50.31.1791392238239; Wed, 07 Oct 2026
 09:57:18 -0700 (PDT)
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
In-Reply-To: <CAOisCUPYSeyRtxzRiDhMcRO9rFBTCfOmzszj0mtO4KufpmyBLA@mail.gmail.com>
From: Kelvin Zhang <zhangkelvin@google.com>
Date: Wed, 7 Oct 2026 09:57:05 -0700
X-Gm-Features: AclHuK-zl_lPjBEgWdf7Nc1qFsdJ82p8aWvGk_kPmdAdHdUO9E6a0CY4l0Qw-q4
Message-ID: <CAOSmRzjAi4ZV_Sgz6om8t06faX5Q5b2LbuhkEMCdJbq84ErY9g@mail.gmail.com>
Subject: Re: [RFC] AceDelta: OTA delta for EROFS images, 30-40% smaller than
 AOSP 17 delta_generator
To: peacherwu <peacherwu969@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com, chao@kernel.org
Content-Type: multipart/alternative; boundary="000000000000055f68065d4302bc"

--000000000000055f68065d4302bc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
    Thanks for raising this to us. We would love to deploy this in AOSP OTA
stack, but in order for AOSP to use AceDiff, we AceDiff must be open source
as we need to put it in AOSP eventually. Is this something you are willing
to do?

On Wed, Oct 7, 2026 at 9:31=E2=80=AFAM peacherwu <peacherwu969@gmail.com> w=
rote:

> Hi Gao Xiang, Kelvin,
>
> Thanks. Understood on reproducibility; I'll keep improving the matcher
> empirically.
>
> Kelvin: most of the size gain comes from closer internal file pair
> diff-ing, plus a solid LZMA stream, which is why the applier RSS is bound=
ed
> by a window (530 MB). If you'd like to reproduce on a specific pair, I ca=
n
> point at the public OTA zips.
>
> Thanks,
> --Peacher
>
> On Wed, Oct 7, 2026 at 11:25=E2=80=AFPM Gao Xiang <xiang@kernel.org> wrot=
e:
>
>> Hi,
>>
>> (+cc Kelvin on this topic)
>>
>> On Wed, Oct 07, 2026 at 10:58:10PM +0800, peacherwu wrote:
>> > Hi,
>> >
>> > I'd like to share results of an alternative OTA delta generator/applie=
r
>> > for EROFS partition images.
>> >
>> > AceDelta diffs whole EROFS partitions (system, vendor, odm, my_* etc.)
>> at
>> > file level, recompressing lz4 clusters on apply. Compared with AOSP 17
>> > delta_generator (minor_version 10, -enable_lz4diff)
>> > on seven real consecutive-build pairs from five phones:
>> >
>> >   Device / builds                    AOSP MB  AceDelta MB  Reduction
>> >   OnePlus 15      A.22 -> A.27        1152.6      683.7      40.7%
>> >   OPPO Find X8 Pro C.76 -> C.79       1059.1      733.1      30.8%
>> >   Xiaomi 15 Pro   2.0.105 -> 2.0.214  1038.6      655.6      36.9%
>> >   Xiaomi 15 Pro   3.0.3 -> 3.0.7       833.4      490.4      41.2%
>> >   Xiaomi 15 Pro   2.0.214 -> 3.0.3    2657.9     1685.8      36.6%
>> >   Nubia Z80 Ultra 16.0.12 -> 16.0.16   767.9      514.7      33.0%
>> >   Realme GT8 Pro  A.68 -> A.71        1268.9      878.1      30.8%
>> >
>> > Generation is ~2.5x faster than delta_generator; apply time (on PC) is
>> > about the same (single-thread 8% slower, multi-thread 20% faster using
>> more
>> > RAM). Hash tree and FEC are
>> > regenerated at apply time by my own implementations. Detailed info, pl=
us
>> > Linux evaluation binaries:
>> >
>> >   https://github.com/peacherwu969/acedelta
>>
>> That is a great effort. If you're interested, you could seek
>> Google Android staffs and see if they are interested.
>>
>> >
>> > A question for EROFS people. Both AOSP (lz4diff) and AceDelta must
>> > reproduce the lz4 compression exactly; mismatches are patched with sma=
ll
>> > fixups. Although AceDelta is doing better than AOSP in fixup sizes
>> through
>> > lots of experiments, it's still like shooting in the dark. Is there a
>> more
>> > systematic way that ensures exactness?
>>
>> I'm not sure if it has a better approach since it relies on a strict
>> compressed data reproducibility of the compressor.)
>>
>> >
>> > Is there an EROFS WeChat group I could join?
>>
>> I will message you my own WeChat number privately since I tend to
>> avoid leaking my contact info publicly.
>>
>> Thanks,
>> Gao Xiang
>>
>> >
>> > Thanks,
>> > --Peacher
>>
>

--=20
Sincerely,

Kelvin Zhang

--000000000000055f68065d4302bc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div>=C2=A0 =C2=A0 Thanks for raising this to us. We wo=
uld love to deploy this in AOSP OTA stack, but in order for AOSP to use Ace=
Diff, we AceDiff must be open source as we need to put it in AOSP eventuall=
y. Is this something you are willing to do?</div></div><br><div class=3D"gm=
ail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On W=
ed, Oct 7, 2026 at 9:31=E2=80=AFAM peacherwu &lt;<a href=3D"mailto:peacherw=
u969@gmail.com">peacherwu969@gmail.com</a>&gt; wrote:<br></div><blockquote =
class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px sol=
id rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr">Hi Gao Xiang, Kelvin=
,<br><br>Thanks. Understood on reproducibility; I&#39;ll keep improving the=
 matcher empirically.<br><br>Kelvin: most of the size gain comes from close=
r internal file pair diff-ing, plus a solid LZMA stream, which is why the a=
pplier RSS is bounded by a window (530 MB). If you&#39;d like to reproduce =
on a specific pair, I can point at the public OTA zips.<br><br>Thanks,<br>-=
-Peacher</div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmai=
l_attr">On Wed, Oct 7, 2026 at 11:25=E2=80=AFPM Gao Xiang &lt;<a href=3D"ma=
ilto:xiang@kernel.org" target=3D"_blank">xiang@kernel.org</a>&gt; wrote:<br=
></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;=
border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi,<br>
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

--000000000000055f68065d4302bc--

