Return-Path: <linux-erofs+bounces-4671-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD2CCA6002
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 16:32:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0JYc4nrrz30RN;
	Thu, 08 Oct 2026 03:32:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::c36" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791390724;
	cv=pass; b=Ug5VTZE9esR8KmNs3G16V6ecF5x81v6Dnu2Liur7E6N6Xbael2h3AUFRqwniTXJWMtR1VPxG6L/DAgeCBz2eHr9Ido1FgCGrPG+NJBh2QcvRrOp4kWd77rP9ih78F32t1FrmgGIuxhPG4OkHgqQjdsjFw54/9JpQqciV+kL7efmfygsX9ImFL1UpDxKo9UZgZvKcPBfs2n6+llTCVT8QyVGHTaKfRMxWyLvEI/l2PBYCfW9nySvOLBUUtG5z9kR98V1kiodGj24lz6vAo2QcBomECyywCJKvZX66LXSJUNfXSHaPDcsw10sEkoqNNi6z081KgVw1doTVF6wtS1In/g==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791390724; c=relaxed/relaxed;
	bh=nhv+xRURrAXF7296vMDHMdDZqkPPeXLEUteWfkR49JE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=koPAujeDPSSbq2qmRG+SloQPSXxQgOjE3yIAHA8Vcal2OTwKE/NGj1Q+xUn7+JKWX04gf/utLcng1lDRCJgvszm3y8HsXkJ9xWO9gWM3qxtbWo5cB6nkE0Dz/2wtvm4Ry1PYQZuIoVPaxjc++1iX+ac7GIuzS5ByThkLbihA4ykGe2gevc92Sh+rYG6qb+v2lWjmAH2d3vSIq7cXz5JvgbDdJOPunlGPIPYiHCKMcOagcmbnY592ETbmU5xHinF+KsMCbXpx/lwRW7RhF2m12ul8C88Wt8jGQTJ2Xmhc7Uhx7O7n8jBiHvGnqsCEvW6nP+qM4Ez8sVSB5p6tHqZ6MQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d9LTi4Qm; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::c36; helo=mail-oo1-xc36.google.com; envelope-from=peacherwu969@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d9LTi4Qm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::c36; helo=mail-oo1-xc36.google.com; envelope-from=peacherwu969@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0JYZ4rxSz30Cj
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 03:32:02 +1100 (AEDT)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-6b19e291cc6so1661807eaf.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 09:32:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791390719; cv=none;
        d=google.com; s=arc-20260327;
        b=jjngRSMbdp+iP5i10PEUnIBq2z7YHPHI4lJObbi0BDBYfd/SxfILFMk/j4xu+vim2L
         E5VjgAGVJCcySZ0oilUE15wsoL6NNLT0/uZifxVciG41O8drWFH5Qyy0g+Q7HTz0Y5qM
         jgtZrcmWEpt2GbjkR9kIPEEStoTgvCu5BdPTi3wunHLk+PxHZblkwNSGbmpWSepEJI0T
         HfLoavIw4E3ppYw0eQ2Rq5TXrh88wg6C7VVKzDSsp6XXz7Dm4mrg1EMe7GTNny4sh7ol
         Bvp2KFW2UKu4T/O55APtBZNSdqkzmBU+liKpD4bFBxeQ4lZC8lc3Qaqew+8hOFgd5JyG
         2wEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=nhv+xRURrAXF7296vMDHMdDZqkPPeXLEUteWfkR49JE=;
        fh=rMx/8CumOUc6uzOBqYM/EppaSDGuf7fT+RoWW0k+Z/A=;
        b=cK5PFA30ubPAd76PLITAhssNF8Vwb53mIGM0bFO4Z6eT/sCN+ZugxMP6POi7xYPWHO
         pJj07c7OF24d4mf6eYCRLX9EjbkOBh4SUJ6eXXsS685zErF57rPV9APggEiW7ThAyLjV
         VcDnXOTxh2WhNVYOljGxGcNywWs2Q3I4Y2rexXRC0tsFVcI4G9yQtraxbkFJW20OFhqM
         q1wDL2Urp7uIWvEI0cB0jJQU8eDerb7vz8M9VfAtmL0B/oZEUA4ko0qmsoD6zIdvYyGj
         N6IPhsszI9o2U7v4Ym5XQ9I3go2rpGekO/zo3BsFlHJcenWtd8Yxg6l1WEN/zBiFn8KB
         EiXw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791390719; x=1791995519; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nhv+xRURrAXF7296vMDHMdDZqkPPeXLEUteWfkR49JE=;
        b=d9LTi4QmTkDXPu79WfZsJjbLJ7IsC0dKqU16ForkgdpogwI8eOXYT9Txavf4/6CG8r
         pPyFkBOsvNPRZON0VSvImjzQXap4omSH1I1NLVYqmq99SbxHN8rE+hflDcJiNO0iPfG6
         GqMafx0vshbsXJ41i3zv+Gnm3MU/EjHrPw+wAvUQpJfmY1IH9ns/Y01BmGluPWUn/buo
         L2OBATsH40T+WNXablAY8hpKnagJyGsBj6ljYIumvS6c4CsCCORjqNtQz+97wyvjNyTb
         Fevl1E+/eDeZejFhCeZa7wol5NWcHsmgv1k2cjUNCfdfM4fyfmH9FS1SUTjHJe4cHDNt
         9gBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791390719; x=1791995519;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nhv+xRURrAXF7296vMDHMdDZqkPPeXLEUteWfkR49JE=;
        b=B4+3KzQUojMS7vtKkWioLb9gZJqrpmjnmRKVX7q2Ubza7mxqWEpjkhnDtQO1yfb9HT
         WBfN2OD/K5APz9ati6mxckhvcNAgfTBqCqXo0+kp+JTU2McCdDTeu/P6LxVlZfWU1ddz
         fzgex+0gEsCmqU/MWTWTjEwO2twgHaOiMude/BAqRnNGwj09o1DsTGQpQx5JF1NmNf0A
         kD337Qhx0VIoM4AWTzMfUJApEF2qsYTrBIBGTdJp4fcY4MoHsK9ogopvKIrDNulGsl8J
         SKvXLeV1bxvctXhmCueLuI198xuDRb2CFiyJvU3eqdX6FalRYaYKoZ8q3BmGvKULQP2S
         1Rug==
X-Forwarded-Encrypted: i=1; AKwUvBwrB15SK4oCdXInvot07A5w26V9PBud5sFeSC4jPsRmS2MTmGp23mEKKDTiQdwGqWMXTdTnRv9rcC24FQ==@lists.ozlabs.org
X-Gm-Message-State: AFuF++nvTDz3cKcB2WBjX2yXSu4Y1rewwOesRhiPMmXWJjRuDV2ZT0o/
	WC4+XGngX/5SRM0yv3bmu6ekxipHoFyAQr6yKnET4k09F1dv1OBEnj+9NuKcL6akQRjZkCfDTIh
	QNh5dNmKrCPfmAfrVOKHj5AsqbhauJoQ=
X-Gm-Gg: AYBFou1lPNMxCT5vy65DyQvfuZj71KaJ+AzVcNKeFKv1yYcgyzpUlqWsxU3R9OK+/U8
	jyST1m34uv0nTCxeznHhEe3RpyZPxNckELwix8uUJLjDlY+DmBejDC3s3hWhhPlIYakegYkuzIN
	/gLeVkDRAnAZ+5n8+SsJ6aDIFjGDmjC90f8bJdDR/uXgIFl/bqxS25LyThmT2qGY8rh+WnW+qm/
	TydTTUbMUEDTePDZuLUmHeuCLCV75Gv+Df0cU6VNOZZqFq8GXLSyZbFNYNDxENtUd55KRt0e30D
	BvWqMdIAJUBhSeRK0jnXMo6WXtz/Z5sT51zw9cRhLCpjQYcR2To+qFfbuFK71GZh1yveXw6jV6R
	4wA==
X-Received: by 2002:a05:6820:618:b0:6dc:e1c3:b2d7 with SMTP id
 006d021491bc7-6e7a912501emr2613105eaf.73.1791390718576; Wed, 07 Oct 2026
 09:31:58 -0700 (PDT)
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
 <asZkUv1TfTfWG0a8@MacBookPro>
In-Reply-To: <asZkUv1TfTfWG0a8@MacBookPro>
From: peacherwu <peacherwu969@gmail.com>
Date: Thu, 8 Oct 2026 00:31:48 +0800
X-Gm-Features: AclHuK-rXE5rZISvq__kkm_FQ9LqCI2uuB7HXXEARlFHTtAUt4cEjiL30PQ0l2o
Message-ID: <CAOisCUPYSeyRtxzRiDhMcRO9rFBTCfOmzszj0mtO4KufpmyBLA@mail.gmail.com>
Subject: Re: [RFC] AceDelta: OTA delta for EROFS images, 30-40% smaller than
 AOSP 17 delta_generator
To: peacherwu <peacherwu969@gmail.com>, linux-erofs@lists.ozlabs.org, 
	hsiangkao@linux.alibaba.com, chao@kernel.org, 
	Kelvin Zhang <zhangkelvin@google.com>
Content-Type: multipart/alternative; boundary="0000000000006f4fa3065d42a780"

--0000000000006f4fa3065d42a780
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gao Xiang, Kelvin,

Thanks. Understood on reproducibility; I'll keep improving the matcher
empirically.

Kelvin: most of the size gain comes from closer internal file pair
diff-ing, plus a solid LZMA stream, which is why the applier RSS is bounded
by a window (530 MB). If you'd like to reproduce on a specific pair, I can
point at the public OTA zips.

Thanks,
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

--0000000000006f4fa3065d42a780
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Gao Xiang, Kelvin,<br><br>Thanks. Understood on reprodu=
cibility; I&#39;ll keep improving the matcher empirically.<br><br>Kelvin: m=
ost of the size gain comes from closer internal file pair diff-ing, plus a =
solid LZMA stream, which is why the applier RSS is bounded by a window (530=
 MB). If you&#39;d like to reproduce on a specific pair, I can point at the=
 public OTA zips.<br><br>Thanks,<br>--Peacher</div><br><div class=3D"gmail_=
quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, =
Oct 7, 2026 at 11:25=E2=80=AFPM Gao Xiang &lt;<a href=3D"mailto:xiang@kerne=
l.org">xiang@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,=
204);padding-left:1ex">Hi,<br>
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

--0000000000006f4fa3065d42a780--

