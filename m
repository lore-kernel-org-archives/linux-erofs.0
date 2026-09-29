Return-Path: <linux-erofs+bounces-4631-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89137CA5FA5
	for <linux-erofs@archiver.kernel.org>; Tue, 29 Sep 2026 18:20:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvRKp5XRTz30W9;
	Wed, 30 Sep 2026 04:19:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:34::c" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790705998;
	cv=pass; b=evcV0XjvK300cnLK+gHrsKA31Af0o60dcl5gwGb7HQRIdcysqnXp4urTvFuqZuk4qufrVgETGyIulPWZLbEyT77IiI97hG4WeUZjHOIvmrRVB14YXywP2QHm0Vvq/w3MwNeOuenXBp49rOZVUz5pyWQR8K5l87IPL9v546rbeHXrmAp+T5kFbfcvgcYAb68fdV0oRHyQBOpJ/T7Hdhp9keYR3W8GBGvC/N+F7mEip3JS8tFLcUx9qW5HgRvSUQsHerpnJwtVpwU+3vTQwendQrcsGi1WJbP5/0Jpfz2lAm8aBdNzIzaMrUQ1AR0XQ7kj3ywSO+me2O6LPOqF2MGW4A==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790705998; c=relaxed/relaxed;
	bh=x3wem9nqccewK142oYO2K5XOMZpE6GeyF4bYVcJ1KOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ZEylnUCP5GxXuFyb0hmhbeAIdlCZ/ueyAi/fME/5QUC+uXlTZHlZwkviGNyRbzcRuBO9rAnc6h+6fEq96GT2fEYDXgRWRN8JUxNsDZU3mtY0BQAJuOqe8nyNrwp5TWFP48MaDyG165AL0Ix5+zBZhe0kI4+Q2E9W9woUEuMGsznekkp52u6C3i0SVUWktM+URanone5uH0y2+fGVZeqEpEuD7Qa/koAzKOaiMBJgyk0/2/iPpJCC28Mffhr9VxFpa7ub8cC14kDaETtGUJloKqeVBJGcCEu3ybK5q0fex/V4sWCJcu0xb8FI7lLDCQmx8Q0jIx9tBaFxnNCaEgFfgg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JOwzU/nD; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:34::c; helo=mail-qk2-x0c.google.com; envelope-from=garvkumar1502@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JOwzU/nD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:34::c; helo=mail-qk2-x0c.google.com; envelope-from=garvkumar1502@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-qk2-x0c.google.com (mail-qk2-x0c.google.com [IPv6:2607:f8b0:4864:34::c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvRKn5Vjnz30Vs
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 04:19:57 +1000 (AEST)
Received: by mail-qk2-x0c.google.com with SMTP id d75a77b69052e-5332a80a731so37590571cf.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 11:19:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790705995; cv=none;
        d=google.com; s=arc-20260327;
        b=ZUpTUvhKfWXNPrHM7q7KygKQ+q02h1+dF5MfQokuWP9diAdVQ84MK3MaJZAfWHeOCR
         4qY2dQRN65tbUb8p9/DfJ2jBa5MLh90s3A1TXECJi7hbxPN7d0xuFtry3zbFB0UUfPEl
         7EMuOr+YbBdqxNVy5LvWEOTN1Sl/zSJ/0bW1RAy3NZnqwospdoI0bngsE2KgdACJLstV
         qIR/qPKhiMXS6L2nRKFQPH5Rx0DLivxgefomNvksV5BioCZL6tI7/CdWKWGvFR99NLzL
         iKogL3DS+2BrCEg0isQYP1ieJSb9GY28F6phuJvWAgSa5TwqCw4wLth+cuxLgHthd7kt
         TrpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=x3wem9nqccewK142oYO2K5XOMZpE6GeyF4bYVcJ1KOA=;
        fh=xt26YkgZnyJHX3aZNhpt1oizGoJ7oBGjA5260Xbfth4=;
        b=bcoIEZvIjEpH/QjZy9U2paFIILyDm8TjsndVRMgaMY0nN7tXUG8HOUl/SL3Q37cdLt
         gBBQEJbarf7MCjuAJAqWby5Zd5H6VBp30wvCMb7MvHqT+tbb9gmkCxVRcUbBFBeGfuCf
         iuIv3yMjCVm0o2AroFzr4Whso8aciEB9Y6OoEcd84dotNB6tSU4EJ8f3b2LKARZwO5Yd
         nPrWxdegxa6OtHnmU+/OgU/MqJhTRD/uD08CGZaWIH+JlT0AHu4Fmcd9f+Q8G61Nlmpl
         fh/mTEivJudEgX/RzoEXmqLcQtK5R2EleVWE8ix+abzoYuhSo8uiJhh43zyJ9yXHM1Xd
         b6IQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790705995; x=1791310795; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x3wem9nqccewK142oYO2K5XOMZpE6GeyF4bYVcJ1KOA=;
        b=JOwzU/nDp0kNNTwNmKzg/ouQAZje7QVMJAt1kh4n7Zn1mpYb9BvHeArjeHN1Zx5EO+
         kR9Q+oS5Wwf+QtmnV4yV9wIkAy3QkTMitd73L+meOkQxfpYFj1zFZVEV7T5ZAk3RHm5b
         thlg2/0bgqjDLomhXyofCSXM1D59ooPwnFGMFb9YOf7emHfsipi7FXvIVYwXd2+irQpo
         IJfuVLvId2789EGhMNxEz3Hu6o8Oc+J/HBRIkVXUbKrrc/jhGyavBP7W3yhXFmKHVgH2
         lb7VNwKpJ3B+6GeW8z1WPU86e4DlIxRqqTo4UHT25W850vvPOac7g9e7qtElAkh/5GeG
         //OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790705995; x=1791310795;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x3wem9nqccewK142oYO2K5XOMZpE6GeyF4bYVcJ1KOA=;
        b=zbIMV4/Aprbm7wp7wC7Xmy6PuvecdosoOsDg7L6kqxaz3yy4oogtx5DnV1yI+iflzv
         SIobV3/KOK+MMnZjnGnVSUWv7Sn+S8QiPbWKuzo+G3oI9r/vE/HhXEkoH92Y7qEU8gv9
         xLqMXa09yjdwWZTeD84iIYjfP9KicuK8yb3ky8xpukhHEmU5/Js1JkiC4f63vGc9SkZz
         N8/pLSefJ4i59It+qlwvLIVR1mWVIZR93+wLQY5lkGtz96wLlXUvuydlqA7lqaRjwr9r
         8Qd+jPuJTfoiu8BPBNp7gYf4obflpssxuxIQ4KgZxrmKOQq1eMRT0h4zTbjS/53NOT1t
         GtQA==
X-Forwarded-Encrypted: i=1; AKwUvBzVnsV/+tKtngokw+tPky+UQjbdR7UAuzfADGTiXiYTCpBkexQgmYNCgr84bSyEVOpguMxNU1bYHdy34Q==@lists.ozlabs.org
X-Gm-Message-State: AFuF++kW1f7JPp3PLAyuLgyPW1N1Nb5osj7riTv3+ZIChSJYfsZgFjO6
	i91pSCb+s8x7Xx6FNZc8N/6dyPqyku6idlFud1CMDwEEf9X2koGvW+H4zjcBPXK94TXq7RxJK4S
	5W8AnkCv8xbcjQJqV6AB0TbKpk9R4qTU=
X-Gm-Gg: AYBFou0+sliVvB+WgK9ZbD4HG2vUqxZlE5cUo/FVoRlFAgX8gWhpoQ/O7IxvxtRORxw
	+hARxD0xdbd9calgox0CQ8gv4QaJ2NTe8phmUJCHU1XeYOggdohMVjV4QLzwFMAYC8xzwW66LGX
	H9kDX1gnJh95faOLh2vDZrPkJB7TjEPyyLcjXJFI47LZx9I7VJwYfcD2ArVkGau6a3OTrz4CASb
	PxbmzQ+NIk24EJ7KVH2b2EMl52wrICkaGRBmCv5shRNb0tWPiFOfsEi13uhYPjY5jPBHgHk86Gq
	q348w2GbOzGVoML9mUzUd3Y4EPJjUUyVEPyQ3t1shInVGQT0OY5h5wVsBg==
X-Received: by 2002:a05:622a:5793:b0:533:2262:f710 with SMTP id
 d75a77b69052e-5336a33c6a3mr1505291cf.11.1790705994734; Tue, 29 Sep 2026
 11:19:54 -0700 (PDT)
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
Date: Tue, 29 Sep 2026 23:49:43 +0530
X-Gm-Features: AclHuK-4x4j52tBss8h_Mpl0KRodCG3bEKISa74MrCj955DLTYNpcRnWJt1DQCg
Message-ID: <CANpLH_GhuiTL01qYyVvwTOqd+PyTzTDGgU9JpH77adKi_Bk15g@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: zero directory writer buffer
To: Garv <garvkumar1502@gmail.com>, linux-erofs@lists.ozlabs.org
Content-Type: multipart/alternative; boundary="000000000000b6a50a065ca33a7f"

--000000000000b6a50a065ca33a7f
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

--000000000000b6a50a065ca33a7f
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

--000000000000b6a50a065ca33a7f--

