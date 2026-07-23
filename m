Return-Path: <linux-erofs+bounces-3993-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3ACEC531CF
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 13:53:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5XfD2gH7z2yhY;
	Thu, 23 Jul 2026 23:53:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::130" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784814836;
	cv=pass; b=OgIEMXkzpFYjxfb2uDpBjFffFBdxEfjugtI7wb0gs3KtcAV3GRRMrBdfVEoMoD1HWDL2MNoF/cc6WTda/Fe78XdEuIyvpQ9NbuGm0o8/aNZbHW2oc5hyZIH2+yC8Lwu6d5NrdRMyJPolsudqqknvezKS3HL3c5E0K0CWa3Hajh3U55k69Dd9R2M78dhuTQvY76enV31WiHlAgPJ8ke/6KzMDNmRssk4C4ojFb0ibmPckoOrggcP0crFRkDr3+fOeDwQPHMR8MJc3p4xJ4nwF1dk04amzxXVBKQQ+8eEdCn3mZugBJQ6aEpHg6sE3K4ZLFO/p2gGnVtCS6HT5+C+xVw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784814836; c=relaxed/relaxed;
	bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M0zFfqxeIO/ib1b2/t3BFLlifvSGpA7KdPRNE9dF5fLhVBY6jIzqEYBIjCDDqAiRtQ1VgFGV8jZtA9EeFsFp+zqIX/HcQtgEzPzUqjzIKbOaZnt8NbzRQDc0slkC1mGVYT569G9MBAXwqQUbbGKFW25J6FQA1k6975xPAkKLBxyZrYvplZbZLvzIKe4GvUTgNwCWa9Z4XCBMWRfutXu9OE6GE2ATWhyWnPxqP04AFqFB7YyHNIR/ha35COaQJOKIw1H1B09ETudBXAnq/kcm3fQjfGghutFjiMgbHXT2Qpp69n3eHF7jpbiRcHkBLoBz1mx3DkN9x9Y9irzHY6RRvQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amacapital.net; dkim=pass (2048-bit key; unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=q4gWkuVC; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::130; helo=mail-lf1-x130.google.com; envelope-from=luto@amacapital.net; receiver=lists.ozlabs.org) smtp.mailfrom=amacapital.net
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=q4gWkuVC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amacapital.net (client-ip=2a00:1450:4864:20::130; helo=mail-lf1-x130.google.com; envelope-from=luto@amacapital.net; receiver=lists.ozlabs.org)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5XfB48wXz2yFg
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 23:53:54 +1000 (AEST)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-5b013aa02b2so580354e87.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 06:53:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784814830; cv=none;
        d=google.com; s=arc-20260327;
        b=K1mVegE2DU5lnugrni75JWIrN2yi5A+Xean1Zymb5Uq3sJzt1pvGhihLlN4ZjSCZJh
         ARXa4q9ir7uk9Cf9qoufj5S2SenBWWFiDmHyXDtQW1t4Gz21X/MXncxhFL4Plj1m88MK
         p2ObbYfPnUbfx6XKO23hxF2Y8wM2JVW148sblZJetXuvYpGkflVbx5roqgLXDUnFi5zs
         S++0J9SGEUU51vr0tJpy7DAmBgKh44mFg2l933/pGzJB2VoKe/IxhHURhtcHpEe4/D5y
         9tN0cJvKYiAdxmlp83bXfv5X5UWXnEoRHPIX+JXq7eYGjEZYwIkirH9U03vxxBWmXTD1
         SPbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        fh=4EDp3gCwnokKuJWMg4FX8rDfzV7+7m4rPrOksD/TJVI=;
        b=k1pdNOUW6xXVbFvFkGuszzX0DYxnDx241z6LlsjoFKaBKwbYZBMoKZVYi/q1jJUoCj
         169gfhaD40I2R/Xb4nBTGS5Kk2Iqe8oX/yKE6cxJB3ovg8SKSsfZj1pBnecPgJUBKVjW
         3mlRwixetXQmPWrcnN9NxJDHZpWZLa2SXLREGQxZb1lZhYp1GNLU7oqKx9mzLzdeVo4A
         tvE8t1B0OWdkckHQEDPu+w+aZLM8kLnTlMLC4djzJBx522QUIQ0hiFdeG/VbqJAS4CZY
         xhREuegKkWJCfM05phLL1whZ2mCv7bwlTqDdwyj9OpkgXH8gLl29nUCy6YcnrQXcMcDd
         i6ug==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784814830; x=1785419630; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        b=q4gWkuVC0fxnzZJVV0AYTo9D0SgyphtsNS+5qE5H0b9m9emE6TgHNECLJ92RvRysUG
         KaAtFDSc3ykt+7bi6dSVfi4ZurJ4vwuRhAZ6K0DAv51EsSSeaO8zrOZIRRbbQJDVzBqe
         z0dOdY5CekWzcrkVisqqP8MQFNzeBC9tPUARvPfVctp2GaFlqYedGHSZM9lD7Ncz2oMX
         PnlkmZwfuh7dh+YV4PqJWO8F0P9inOZ2mn18CLuj3GKj/LRKZkRbHhTq7LHCYQSdWJde
         8vTt3OpbbaXefgUyJfRD8Yafgy10c/Q+6zsj7xru1q07Pk0JbnrZ/5DhZIFETdoU9pxN
         Yw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784814830; x=1785419630;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        b=rog0HAjyzqtIYWYSrb+iwlKfcdGr7Fh3X6HM29iDC1lzPqo4hmWFR/2OEGoGe4/oMO
         05BJ9tWPgewS6CTE2a4oEvGmADJLtAYPPUJ906EzAW5R7302hE1A5wtdIXg5wUvJRbaz
         k7uYBUNcSol4ybydmHpLObBKnAgaktESeRtNZpO9NgujCiEZlXedrt1p7iUNX+n3yPhs
         UXaW0o82Og2ZdZBBxbXSA7tbolWm3mo55hyg1Zie8wSUwktv/TbXnd0rLXfsTFqBVtrh
         OzoNgwBYQcX3P2UGQagOTmMMMLgJVKZIyBVXgwZgM3tcEfbeB3Jg4ROoDfJardUhxNL8
         o0DQ==
X-Forwarded-Encrypted: i=1; AHgh+RoxM0ss0FCvX6DX2DpoDmNbJKjQCEqxOUuZiWcbLI2Kb9IpFgi0lWKW1kchMDvd6q9gsjHYSVSbo7wNMg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yy1lhK+aLRJqlxbGRSNVjYb4lQpgDYFEAgtIPVDXlP7s2n87ffn
	x6B3sAh1cZ6zhna3eoxQOtxTvK2Pn4eK2iAbUG6reQnhFBfdKxrHXyltNM9YPD9MqbjmznDLnmY
	5D3FtAm+mw1tMwYG2FwKuSa3E7pjw2xVxuMpWuR3P
X-Gm-Gg: AR+sD121y86hhOGQfBu7xLCzYPCurWmVIB4TJpF5JjqTV1/hIFsJtZpuZYKZMgDJoM5
	9b/Ch9jmdPXjloQkf2KTM1MRHbzZknYMS9EV2eVmSvjF/0pOKx4Q11CGHFsw5FyjtI0s3cbRzOj
	g9oEFG3CbbA9VMV02zktaYyNoQJFDi8QiuzmpkWm6INgni+phPcNeSNubA+qJS930EuaIxw1AYX
	vWPGlpvWuioybohzlXSdv/7eBbDb5YwVIQtFHr77ufon7gSFXUY35085n56BA==
X-Received: by 2002:a05:6512:ba9:b0:5ae:a9ed:35a6 with SMTP id
 2adb3069b0e04-5b2b33cde5emr603977e87.31.1784814830282; Thu, 23 Jul 2026
 06:53:50 -0700 (PDT)
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
References: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
 <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net> <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
In-Reply-To: <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 23 Jul 2026 06:53:38 -0700
X-Gm-Features: AUfX_mwpGfNjVX76f8of_9AJftpdKTQtdZGp4l8jZIXndq3Duzeb778fccyzEFg
Message-ID: <CALCETrWCf67TTiRSikTjgBZ+jKc_HPptEp9BvO2G=1-C5D2F_w@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Xiang Gao <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 2:19=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 23 Jul 2026 at 11:01, Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> > - O_XYZ flags to open() are all kinds of awful, for historical reasons =
that are not fundamental to the concept.
>
> I'm fine with limiting this to openat2().
>
> > - symlinks. If we have a new API where opening /proc/something/magic/bl=
ah can access something that ought to be inaccessible when accessed intenti=
onally and with privilege, a symlink pointing at /proc/something/=E2=80=A6 =
can cause the API to be used inadvertently.  Admittedly we have this proble=
m with basically all symlinks, so this isn=E2=80=99t exactly unique.
> >
> > - our nasty fs permission model. We gave a sort of gnarly mix of a bit =
of fd-based permission and mostly mode/ACL-based permissions for path trave=
rsal and opening, and mapping this nicely only new APIs (as opposed to actu=
al files and directories) can have unpleasant results.
>
> Pseudo filesystems don't usually do mode/acl based permission checks.
>  I don't see any issue with that.
>
> > Of course, I=E2=80=99m busy arguing (slowly and without a concrete prop=
osal) that we should have proper capability-like fds, and maybe that=E2=80=
=99s kind of an answer to this:
> >
> > What if we had an API to get an fd to the =E2=80=9Ccontrol filesystem=
=E2=80=9D for a superblock, like your O_ALT but as a real syscall or maybe =
only accessible via one of the newer and less janky open variants?  And wha=
t if the resulting fd and the filesystem tree it represented had a few prop=
erties that made it very different from normal directory fds:
> >
> > - You cannot mount anything on it or its subdirectories, nor can you op=
en_tree or otherwise mount it anywhere.  But you can open_tree the very spe=
cific things in it that point outside of the special API (e.g. the overlayf=
s layers).
>
> This patch provides exeactly those properties.
>
> > - Privilege is fully captured by the original call that gets you the fd=
.  current->cred is not checked when *using* it except to the extent that y=
ou might need privileges over your own namespaces to do operations that mig=
ht affect them.
>
> This is trivial to add to metafs: just store a ref to current->cred
> besides the path.

We have f_cred that might be good enough, although I'm not sure it
propagates through path lookup.

>
> Not sure how this security model would work, though.

If I have CAP_SYS_ADMIN and I open the metafs and then drop privilege,
then I would still be able to do all the metafs operations as if I had
CAP_SYS_ADMIN so long as I use the fd I opened to do those operations.

>
> >
> > - You can=E2=80=99t fchdir or (hypothetically) fchroot into it.  (Not s=
ure how important this is.)
>
> Not sure if there are internal mounts that have directories?  If not,
> we can just add a check to fchdir/chroot against mnt_ns being NULL.
>
> > - Maybe you can=E2=80=99t follow /proc/pid/fd/N links into it either?  =
Or maybe that would break CRIU too badly.
> >
> > The basic idea here is to try to treat it like an API that happens to u=
se the open machinery but not as part of the filesystem hierarchy.
>
> I'm not opposed to limiting this in various ways, though I don't
> really see the advantage.

I'll sleep on it.  Maybe it's all fine.

