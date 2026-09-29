Return-Path: <linux-erofs+bounces-4630-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0003BCA5FA7
	for <linux-erofs@archiver.kernel.org>; Tue, 29 Sep 2026 18:19:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvRKS12Pyz30Vv;
	Wed, 30 Sep 2026 04:19:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:34::c" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790705980;
	cv=pass; b=TuAzAx9cWEdjDWv/4RMZAGPcdnLcjobjgthQ8DbocBUIbP4CoWA9CGemqWegVUKVgNmWT+ZP0W3+w7WHUBlxhG1NKpa3wNxuHB3GV0m47vap1z1B11WxLOrvKYBQtqbTWeBYDrTFDOAAz3qyGrfmLJC+RwafqTXwMmjwFNm8iPILU8VxAsle+Re9xLF0GlxH6VJL6mOnbmKYRhZra012oyS2Z8F3L0BZNNBfFWCCHfsQ5n0mXEoXkveBvgfzY09PnefBgPo/jjamVCw5qOBL881mXrooas/gysYfX1EIqTkuyFOh8bLHn9+tzcqN745WUMQ5HeGFKQRXFTPNprqYLA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790705980; c=relaxed/relaxed;
	bh=uY6LkE4bznrOOrcsgKAsc3fx1lL80WDrjEKmnz+iVJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=jgWWt5KCsJG6G3OIHMnM0FfRlKn/b5M8/8NS/eJ0jtk8EHRUn2QATR37RJi7ZKR9bhzbJwqiVpZxtQehPZL02zelS5dTkU1xnmft9CgbThBxqW/SXXHZs7koJVBiGaGaBuhUwO0cTJBg+txm0QK6MncjuW+FSzzobRbMUdbnwA1GgGQiqOPaB92UXW/860Bqszr7E02ZYx2b9353rD7NUJF2Wl1CibnKiNcVKTxkQhdYVW9Psb7lVxdqKzWALDBdQ9TXkiUPb76y2VEWDN09BAY3e6ZTtnasqYS6eTDclp/lQIs6mXZd4Y9pbLP+Du5a7odYqgqz4fThEYUQErTRfQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xgmy86kY; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:34::c; helo=mail-qk2-x0c.google.com; envelope-from=garvkumar1502@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xgmy86kY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:34::c; helo=mail-qk2-x0c.google.com; envelope-from=garvkumar1502@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-qk2-x0c.google.com (mail-qk2-x0c.google.com [IPv6:2607:f8b0:4864:34::c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvRKP4pRgz30Vs
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 04:19:36 +1000 (AEST)
Received: by mail-qk2-x0c.google.com with SMTP id d75a77b69052e-533289b43ebso40128641cf.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 11:19:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790705972; cv=none;
        d=google.com; s=arc-20260327;
        b=f4NMPAB7gp9zD2IYOUpxpO9l6fGzinyYq7pUD7oBlH6jVbzu38OuyVHvYgruwKrirT
         sxXJJWVi5zqET+ZhGGZVCX1C5brPrG7g1nr/XI4fYo7X6RpAz2MUKMUaAWYjpzvSsnME
         CWGv0DaoUlhcftBoRvVjn4L464cG9YzaXpnIhhFVFUoEDzrfKTmcJg25IqQ2ACDrQps7
         Z2rhnI+YK298LvHwBRKklQksWMWuKilskFAT0d2w0oHmcfCR3HyX9rY9eu5fBv9pVV+b
         TvghhWcm+41UF5RzesQSmdWpEYiG/lyjUe2EDyI26s90nv/Ghanm/FGtn0DqBqBgR4nh
         temw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=uY6LkE4bznrOOrcsgKAsc3fx1lL80WDrjEKmnz+iVJc=;
        fh=US1LeSTB+xFTlzpeP+1RSVdGtfvtVWt3tdv4mWF8yKE=;
        b=mjxwOwZwG10YKbNTKEj+oPlVjdAvtGsg3Sq6MYeibPDVstN4ld8PjNV0Uvkn03KwsF
         Fpn9rI423ICAFjQbsErRUhmUf0kFhfJsurj/AbzJ0FNfJ0PkBw7Yj1oizZd2KMUUlfx3
         /wBcx16hFaAL6lPjXSw5ERNYk6EpO+/cT2pFK2J9WKsHqQEw8/eIhSuGXphPZvrqWYTP
         5kjMhyyQC0Jz8HKslICVpt2OpwJ85hm30HDrOsKC9TBaoik16kQaNVfRFS1Pp3lMlyLD
         z6WALIqtYUrKa3RFNO/XVrwLb1HUEiwepOoSZiScjvdiJABI3BvpJOKxYJACSA7z40+h
         iT2w==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790705972; x=1791310772; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uY6LkE4bznrOOrcsgKAsc3fx1lL80WDrjEKmnz+iVJc=;
        b=Xgmy86kY0VBpSfUcQagxqdWqWKeWmteyKLdCFDOuh+F2+5z1ZGdv/EkuPp+XFSpLVz
         KhY+kWKivjB6WZjQLd94HPffPyegUFmP6vHEeI6T8uYijTAssH7TL2hT56SEK+LyEnSZ
         MinWPsWzNYdCSdoyYb1Pvgmm7hFPE2V8jkQBjHkEgFyZ1WkypMxudVeXTFtx/DSZ0bfv
         ktpWpCbcLfTdkx/eKca5vS/cnRmfTjO96FPMglzI+gIVo7ZMNTbMlH7w+3cjYwL5vchv
         0YxZ6W9MiZoXe4kwqV7+uq8BeRDcNG7dkXc8jBYjGpZbCJ3E4Codv85a/EKdmafjp3bQ
         q88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790705972; x=1791310772;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uY6LkE4bznrOOrcsgKAsc3fx1lL80WDrjEKmnz+iVJc=;
        b=pCqEkUqnOaemGNBVOIaDiT1BZQHsgvjXiZ/hCni+rr16qFDwN6JABNeizwv8x+lPNa
         chJZ+3m/xd2fRNHj7kOXKN09oJcYrlJTSJFwIyU8UooSIIWJqwyhF1xftngUxBq3ESjI
         6q/pGB6CZmypJCY7tTNQDAzOwCxWUePu/LVwfPb6Valvy4Sb6KTZSRwjrCmB+rFDRs3p
         T/8t/LNbyqvBinci3xi/WRgCQV0ZZEcTGx9JDFW+DDKlmQQWEiWchBdOHKiPKoPT6yka
         Yk9w4gGbj/ne6OKKAfWWgAhJOWoENaMp+jbRjRmiPQPpQKdNLqaoPo0l0MRGQ3dl9kPH
         FIGw==
X-Forwarded-Encrypted: i=1; AKwUvBwkWwO1ucUOc1ZnPZyN5qBx5yq+jx24D+cFluzyTXfOjn+F8EQfaVJfN8jVktNfgsNj9brEwuL0WAlmzw==@lists.ozlabs.org
X-Gm-Message-State: AFuF++kmfgk4NSAK45f9Hn8YlEX5SlFkHLAOqaGdXEA8PyCA0n30j4IN
	InYQEs443MkjogcoWpMSXFe8zI4x+YE0B0vaEDaDGX/+bQle1w2be0u+3srqjy//72zIdNFsyS2
	c2euzoi3B7CEx1C6oldN/F980HHEmWEWoqXcKzDQPaQ==
X-Gm-Gg: AYBFou3eycK3DgmETIbERjn2B93q7jHjM0iTH5+tLO8FwZ7v6kQoszpXqMRC46pAmqs
	0JrvVblGO1WViXKuazonRTzGGc1i1tQeRye60ZXe1yBqVRSmhn2VUL/mfThV2CR487+fxXiJC8U
	AIHnYw6CQwKqXqKMgFkNNKLg7ml/ib+J0qAa+AdCh64o5vLv792z0NEruGpYrmWZ+vTOTdD6exG
	Vkt0XvOX415cx5LfSbbxLmXup4sMwHFOjcnB9kPzcOCFDhHUvepuGY8dGk4ZlApuKQllS2MsgPf
	pQH81OwflciE9PwxVdGTzsgQoLxklrlWZzlaEmrp2OrpK4SHEy7dUvHX
X-Received: by 2002:a05:6214:469b:b0:917:9504:374d with SMTP id
 6a1803df08f44-91795045b2bmr25611466d6.36.1790705972315; Tue, 29 Sep 2026
 11:19:32 -0700 (PDT)
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
References: <20260929133917.14100-1-garvkumar1502@gmail.com> <arvAQh9Uz9cDG2KN@XiangdeMacBook-Pro.local>
In-Reply-To: <arvAQh9Uz9cDG2KN@XiangdeMacBook-Pro.local>
From: Garv Kumar <garvkumar1502@gmail.com>
Date: Tue, 29 Sep 2026 23:49:20 +0530
X-Gm-Features: AclHuK_rSTSPwyUGrF0rrrCs15LSnaebc30BghJzJ0TNogiRRMODfG2dJVnVGho
Message-ID: <CANpLH_GEWvyAZj+nJjFjgu=Lgs_023wt+U=C+72ePb1spXGkxw@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: zero directory writer buffer
To: Garv <garvkumar1502@gmail.com>, linux-erofs@lists.ozlabs.org
Content-Type: multipart/alternative; boundary="0000000000006089bb065ca339ca"

--0000000000006089bb065ca339ca
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gao,

Thanks for asking. I traced the directory writer path again, and I agree
that my original explanation was incomplete. fill_dirblock() already clears
the unused portion of the generated directory block, so I shouldn=E2=80=99t=
 have
described the change simply as fixing uninitialized directory-block spare
space.

The reproducer I used preserves non-zero contents in the output file by
bypassing the normal truncation path, and the calloc() change makes the
generated image deterministic in that test. However, I have not yet
established that dwv->dirdata is the source of those stale bytes, so I
don=E2=80=99t want to claim that this is the correct fix without further
verification.

I=E2=80=99ll investigate the exact data path and send a revised patch if ne=
cessary.

Thanks,
Garv

On Tue, 29 Sept 2026 at 19:12, Gao Xiang <xiang@kernel.org> wrote:

> On Tue, Sep 29, 2026 at 07:09:17PM +0530, Garv wrote:
> > Signed-off-by: Garv <garvkumar1502@gmail.com>
>
> Can you explain a bit more why we need that?
>
> Thanks,
> Gao Xiang
>
> > ---
> >  lib/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/lib/inode.c b/lib/inode.c
> > index ec96556..e7d07e0 100644
> > --- a/lib/inode.c
> > +++ b/lib/inode.c
> > @@ -597,7 +597,7 @@ static struct erofs_vfile
> *erofs_dirwriter_open(struct erofs_inode *dir)
> >  {
> >       struct erofs_dirwriter_vf *dwv;
> >
> > -     dwv =3D malloc(sizeof(*dwv) + erofs_blksiz(dir->sbi));
> > +     dwv =3D calloc(1, sizeof(*dwv) + erofs_blksiz(dir->sbi));
> >       if (!dwv)
> >               return ERR_PTR(-ENOMEM);
> >       dwv->vf.ops =3D &erofs_dirwriter_vfops;
> > --
> > 2.53.0
> >
> >
>

--0000000000006089bb065ca339ca
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p class=3D"gmail-p1" style=3D"color:rgb(0,0,0);font-size:=
medium">Hi Gao,</p><p class=3D"gmail-p1" style=3D"color:rgb(0,0,0);font-siz=
e:medium">Thanks for asking. I traced the directory writer path again, and =
I agree that my original explanation was incomplete.<span class=3D"gmail-Ap=
ple-converted-space">=C2=A0</span><code>fill_dirblock()</code><span class=
=3D"gmail-Apple-converted-space">=C2=A0</span>already clears the unused por=
tion of the generated directory block, so I shouldn=E2=80=99t have describe=
d the change simply as fixing uninitialized directory-block spare space.</p=
><p class=3D"gmail-p1" style=3D"color:rgb(0,0,0);font-size:medium">The repr=
oducer I used preserves non-zero contents in the output file by bypassing t=
he normal truncation path, and the<span class=3D"gmail-Apple-converted-spac=
e">=C2=A0</span><code>calloc()</code><span class=3D"gmail-Apple-converted-s=
pace">=C2=A0</span>change makes the generated image deterministic in that t=
est. However, I have not yet established that<span class=3D"gmail-Apple-con=
verted-space">=C2=A0</span><code>dwv-&gt;dirdata</code><span class=3D"gmail=
-Apple-converted-space">=C2=A0</span>is the source of those stale bytes, so=
 I don=E2=80=99t want to claim that this is the correct fix without further=
 verification.</p><p class=3D"gmail-p1" style=3D"color:rgb(0,0,0);font-size=
:medium">I=E2=80=99ll investigate the exact data path and send a revised pa=
tch if necessary.</p><p class=3D"gmail-p2" style=3D"color:rgb(0,0,0);font-s=
ize:medium">Thanks,<br>Garv</p></div><br><div class=3D"gmail_quote gmail_qu=
ote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, 29 Sept 2026 a=
t 19:12, Gao Xiang &lt;<a href=3D"mailto:xiang@kernel.org">xiang@kernel.org=
</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:=
0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">=
On Tue, Sep 29, 2026 at 07:09:17PM +0530, Garv wrote:<br>
&gt; Signed-off-by: Garv &lt;<a href=3D"mailto:garvkumar1502@gmail.com" tar=
get=3D"_blank">garvkumar1502@gmail.com</a>&gt;<br>
<br>
Can you explain a bit more why we need that?<br>
<br>
Thanks,<br>
Gao Xiang<br>
<br>
&gt; ---<br>
&gt;=C2=A0 lib/inode.c | 2 +-<br>
&gt;=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/lib/inode.c b/lib/inode.c<br>
&gt; index ec96556..e7d07e0 100644<br>
&gt; --- a/lib/inode.c<br>
&gt; +++ b/lib/inode.c<br>
&gt; @@ -597,7 +597,7 @@ static struct erofs_vfile *erofs_dirwriter_open(st=
ruct erofs_inode *dir)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct erofs_dirwriter_vf *dwv;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0dwv =3D malloc(sizeof(*dwv) + erofs_blksiz(dir-&g=
t;sbi));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0dwv =3D calloc(1, sizeof(*dwv) + erofs_blksiz(dir=
-&gt;sbi));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dwv)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ERR_PTR(-=
ENOMEM);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dwv-&gt;vf.ops =3D &amp;erofs_dirwriter_vfop=
s;<br>
&gt; -- <br>
&gt; 2.53.0<br>
&gt; <br>
&gt; <br>
</blockquote></div>

--0000000000006089bb065ca339ca--

