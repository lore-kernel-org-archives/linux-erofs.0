Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FB5606A321
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2026 07:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UH0BsPU6
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jbQZ210Smz2yLF;
	Fri, 27 Nov 2026 18:50:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::330" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795765818;
	cv=pass; b=DUgphG2+dEdhMsmdOTgmacPMwtPL1G3nuGRUNHx3/yO1Ig7WqzP5GCMQFkpcRCJkGCXZc33GF8F6T1s5RFBKdZjfLE8IAEcB9i8zzjBWusbMLVYz1AS8Rh7XNC5XSphupbletpHQMpcLTJuP9Y0p/1GetCcd5SgjmkcyKcAF+Pw7xLkTEhBuYyoNt1HitIgsW1P0tihQA3CYCCHfQfnibKjij1Y3wA33UmyjyeZbazx8h6oz9zKW5LF0albi0KKaLH5FUADAwx6RRtcQ+d6gty9XvFgr2LVUZvLz+Za/cZbBOhcz8S9v3IdCwJSDzPrZ68F9iUypL1y5/EZYat6+Iw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795765818; c=relaxed/relaxed;
	bh=m60gQnwzDwAv9U5sGgkvhY+QG9J6Mt+3Dots+0vBMy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=aeJHpng1YpmPXp8qLLy49wV1w1ENnnqECXLnY+FRGcvEM4t+Bw6yogaALpPPyzYU+o7tu8ItPBJYSP+BLfXPFqtcZB9M+rxeDvlbWZ6OAqY9kFQfFJkHUY5JznQ2ZyIIH2L8ZiqoTszileWrWPK/zhZv5VeDVlLGT/AEk/1HBmUXzxxDiOSJHn9s31zPZ7TVprYkeLRB4gJEgdl3hJ///SmXqiwF/xQ32Qfs4LqNffxwpN3ezUoWbAqy84vH3ahyq7x8UCKi2t134VbOrDXghOdKuG/gZGjyAPQYKtrBNrCKobfOabqoO/lx/MgnvvXk7FkC8rp3+6oEB+iKyph5PQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UH0BsPU6; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::330; helo=mail-wm1-x330.google.com; envelope-from=niuzhiguo84@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UH0BsPU6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::330; helo=mail-wm1-x330.google.com; envelope-from=niuzhiguo84@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jbQZ01BZvz2yGT
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2026 18:50:15 +1100 (AEDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-4a56e05568aso17745385e9.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:50:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795765812; cv=none;
        d=google.com; s=arc-20260327;
        b=P5LtCgnwQiqtYMtPzyIh5bMaIgGmskQrfl4i7c/RVrc1rkHlt9m9Lf+E9xjgZpEY2P
         7t/pL2pn4FzRimC3SkNiwUqsvViNsOSTYZ967XV3Xxel+RKfs5Im272W+tU/eMnCHQE4
         8nNib0FVEVEVXn1Tu8qn4/6ix1NtKqlPrO8pJe0BxH98VIV0PfKWMbrTS/iBjVVRynXy
         jCwMQWkhqD4t4EgWntp1Lse0aEZCwmbqsP0kbMfc2yyzIaYJD8Raaf7OwLmi2kGSH20y
         OtFr6g03VN/xz2M/agD5eVwFvGYpgrp09N61iqpyrQpOqUcP1lnCJIedzeQ/4bhKk9df
         FDCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m60gQnwzDwAv9U5sGgkvhY+QG9J6Mt+3Dots+0vBMy0=;
        fh=nBbiH6iYgtApsaeOYqxcE/Q/xRSMU3ZLhVAUO+nG/70=;
        b=SBEqciM3IptZ+w90/OkqfdUi7V7Gwr4rML2FPJV5360zyGK9inYLcGOCzH9vEdwhdd
         XRcvBUHGziYCdm6+ojVMbsdWXxSaavQ6AsX0xbKxcAO3Cr44ruZY5Zl9H+XWhbXwv6CL
         2LTOQN/VYsJcl/ySNqev7ZN1F48APHCpISSPLsleljLT/WcPwmLAns+c2o2b3XLbVM7l
         LR9X8K/2qlVvGm/xC1myV9fjWbvudBbP25joV+6GAQeL5teeUpM7ey7giIfenlFMPzhH
         kv5k7jVRu+Y2DCuzwcC01sJu2pkrJT+94RDb/JWK7HN2G25pcjR02qlX381wKMPe4B5W
         slaA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795765812; x=1796370612; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m60gQnwzDwAv9U5sGgkvhY+QG9J6Mt+3Dots+0vBMy0=;
        b=UH0BsPU63YqN92zMJD0WtEzzYsdA62YW6tVZf4Ro1mYHp/B8Kzzk9FyVz2Kbz7L2+S
         ow/y+DLL0cmmwsAs0ogpBzYJs14p/UTn5uB4VFKB0lUGWARJNMuGJRG1QUmAjDlvg9Zi
         Oiu0R7E02PdKEK/Dfh8I1e3u7ex50jrup8JrUzjf6UDp2vFmEJHnXkdvKRgBhzMq0K3b
         e2MMHLmq7U9tyh/gEN2fiQguGMcbc+zlwGvddWZmDlVMqLOyHmidHlD95EYc+RzADxBG
         sBVZMvg+wWMBJoydV0VvuHjs8mK5vQKsHJYK+CgV+En3WJW/HkJQk0TV5nyo/GvOiaLj
         ZbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795765812; x=1796370612;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m60gQnwzDwAv9U5sGgkvhY+QG9J6Mt+3Dots+0vBMy0=;
        b=V6mU2Aqs1gM+vKiyGljSvOWunT5mi9nlM0cLad4GZjU5EdgY5LpclsFCXCj/+T+ICx
         dP2kOn0obGCcpvobIosmmEN/hxwSE9G7z5Pal8gS6s7bzQ5Eod1QfOaYSS3BDZRUJg5U
         WVPiDgTIua/c4lWLEEiYPsPgsNwrhEftyoO6gTnLsyR1PpJUhat7KDbzq65nQwHkvEVr
         ABWiVOSM3775QpxG6GlweP7Ys+53J1fcjnTjbsZw4oV6J6XyRiWpeG7pH/Huin8GKfJV
         AhF3fOJZIow1DiTyCfPCjeXn8ltEoVi4Ncntr5vtT1KAR0TJ4vGAmCJgDcoyngf1GnNU
         Uhcg==
X-Forwarded-Encrypted: i=1; AL+hErH2FuuHsr0QHV/KKA6T5JYgDIjVJY+DUgizlRid7qJ0gfwztSl2qEiTIPqtb2gAjfZ2d4GDIIRo4/WAGg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+TkyJEihkAw1CY969qjFcZFpXBvhfyWzTJUFP0ggilmdeQfo1+
	noeU0ALcoWoqE8K5SJAvKf15zYfSGd+99wZTkdx1aCHRvccg82Lpnhi/iYZjIFh7nvm7QR3nZd5
	aRBZtGyyls2ilUtKFxDoVd4bln1gC6Rg=
X-Gm-Gg: AZFdTZe3PUkvQPSsYxQ+GkM+9a+9f68Bb10kmpw6/epBGi9sBxTaR5I+a1lVPl/A6Cy
	tWa4rLGFh5uDbgrkYjkhYbgjS64ok4gjlhkpS3YtKionOaAC5mDEUfOyw0PAAUXHZzALaJJenFx
	z4UML7GYaak9Ri5UAi+Lr4M4wYaZc//9PGgSjU3sI65fzl+sqrq1HoOXach7oxpWGYFdt5oJwS4
	CvZZBJ/ucsddMCfC5JHxhOEf88mGnpFfDgYp/2CfoQ3BGiL35wLqHhksK9B93Gt3xls0YZw3Aas
	KWyuYHwyPBKtbWU6ybHq1lBumK4f68FTur7nG5tee84PGmVuucj6RPATMwwa9CyAkxPGo5wTWcH
	06EA/M1t6x/tndqTCPyYCdvlpIs2Tl2WNfnP8Eg==
X-Received: by 2002:a05:6000:4a15:b0:4a6:9f2f:4151 with SMTP id
 ffacd0b85a97d-4aba57e9972mr41905035f8f.0.1795765811972; Thu, 26 Nov 2026
 23:50:11 -0800 (PST)
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
References: <20261127025636.1333457-1-zhiguo.niu@unisoc.com> <awkCSfgINQ3M3Cj-@MacBookPro.fritz.box>
In-Reply-To: <awkCSfgINQ3M3Cj-@MacBookPro.fritz.box>
From: Zhiguo Niu <niuzhiguo84@gmail.com>
Date: Fri, 27 Nov 2026 15:49:35 +0800
X-Gm-Features: Aa3M54o_AP9myrLicojv_5pyz6LwgOWfRMGCoNv9Y7NqFVZ0f6jzHqDGpFDtJfQ
Message-ID: <CAHJ8P3K68GCRDX8PcEP+z0U4xYQZTwRD-kGXT0NRLUEBrZTz9w@mail.gmail.com>
Subject: Re: [PATCH] erofs: print error code in erofs_err() of erofs_readdir
To: Zhiguo Niu <zhiguo.niu@unisoc.com>, xiang@kernel.org, chao@kernel.org, 
	niuzhiguo84@gmail.com, ke.wang@unisoc.com, zbestahu@gmail.com, 
	jefflexu@163.com, dhavale@google.com, hongbohbli@tencent.com, 
	guochunhai@vivo.com, linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Xiang

Gao Xiang <xiang@kernel.org> =E4=BA=8E2026=E5=B9=B411=E6=9C=8827=E6=97=A5=
=E5=91=A8=E4=BA=94 12:08=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Zhiguo,
>
> On Fri, Nov 27, 2026 at 10:56:36AM +0800, Zhiguo Niu wrote:
> > Under system stress tests, the following log frequently shows up:
> > erofs: (device dm-8): erofs_readdir: failed to readdir of logical
> > block 0 of nid 124
> >
> > Without the err value, it is hard to tell whether the failure was
> > caused by an interrupted read (e.g. -EINTR) or a real I/O problem.
> > Print the error code so that we can get more clues to the problem.
> >
> > Also fix the similar codes in other erofs_err() call sites where a
> > real error code is available but not printed:
> > - erofs_read_superblock: "cannot read erofs superblock"
> > - z_erofs_init_pcpu_workers: per-cpu workers allocation and CPU
> >   hotplug init
> > - z_erofs_readahead: "readahead error at folio ... @ nid ..."
> >
> > Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
> > ---
> >  fs/erofs/dir.c   | 4 ++--
> >  fs/erofs/super.c | 2 +-
> >  fs/erofs/zdata.c | 8 ++++----
> >  3 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
> > index 4aa52a5f204a..69aea8a7c3dc 100644
> > --- a/fs/erofs/dir.c
> > +++ b/fs/erofs/dir.c
> > @@ -83,9 +83,9 @@ static int erofs_readdir(struct file *f, struct dir_c=
ontext *ctx)
> >
> >               de =3D erofs_bread(&buf, dbstart, true);
> >               if (IS_ERR(de)) {
>
> I guess the correct way is that we shouldn't error out -EINTR.
ok.
>
> > -                     erofs_err(sb, "failed to readdir of logical block=
 %llu of nid %llu",
> > -                               erofs_blknr(sb, dbstart), EROFS_I(dir)-=
>nid);
> >                       err =3D PTR_ERR(de);
> > +                     erofs_err(sb, "failed to readdir of logical block=
 %llu of nid %llu: %d",
> > +                               erofs_blknr(sb, dbstart), EROFS_I(dir)-=
>nid, err);
>
> you should just use %pe here directly.
but for this point:  and considering the earlier suggestion to "avoid
returning -EINTR"=E2=80=94
this would be somewhat redundant; it might look something like this:
if (IS_ERR(de)) {
            if (de !=3D ERR_PTR(-EINTR))  //EINTR err also need break
while loop=EF=BC=8C it cannot be placed side-by-side within the first-level
`if` statement.
                      erofs_err(sb, "failed to readdir of logical
block %llu of nid %llu: %pe" ,
                                erofs_blknr(sb, dbstart),
EROFS_I(dir)->nid, de);   use %pe for de pointer
            err =3D PTR_ERR(de); //here we also get err(%d), so we get
use it directly
           break ;
    }
I think this might be a bit better?
 if (IS_ERR(de)) {
           err =3D PTR_ERR(de);
            if (err !=3D ERR_PTR(-EINTR))
                          erofs_err(sb, "failed to readdir of logical
block %llu of nid %llu: %d" ,
                                    erofs_blknr(sb, dbstart),
EROFS_I(dir)->nid, err);
           break ;
    }
Any suggestions for these?
Thanks!
>
> >                       break;
> >               }
> >
> > diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> > index e92a7fa90ae3..39f195e6d10b 100644
> > --- a/fs/erofs/super.c
> > +++ b/fs/erofs/super.c
> > @@ -273,7 +273,7 @@ static int erofs_read_superblock(struct super_block=
 *sb)
> >
> >       data =3D erofs_read_metabuf(&buf, sb, 0, false);
> >       if (IS_ERR(data)) {
> > -             erofs_err(sb, "cannot read erofs superblock");
> > +             erofs_err(sb, "cannot read erofs superblock: %ld", PTR_ER=
R(data));
>
> same here.
>
> Thanks,
> Gao Xiang

