Return-Path: <linux-erofs+bounces-3990-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED07DC531C7
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 09:19:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5QYf0nzYz2yFg;
	Thu, 23 Jul 2026 19:19:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::82b" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784798374;
	cv=pass; b=X6WarXtb5g4Fl823Xvy3CE/bX6OezDk3WkRqJnxxyINdzHMvrAPK/ulGmBLeD7Oq8XmmUdTQF7EO5IN12v9bZwQfOcluiHN6OalrL0FqLmftyrIxpAJzEnB3brGnWlLy52MPsA+n6/EU/Rj7fYHFCzRH4gAac4l45nA9ngm/qirvjt4b0Z3z9cCUYnKbvaVkkkW9j3xwXu2YQ0PYCoik/OisfNJuVIE+jMHJVKwa4V2AxToOfg8WqfETw6+PJFBFUgLH9542DsgF9Q1RdbYeITcR/UftdjLOEALcOLhOvQAffRs9tj8pE7dzUuY1IObzdCNN6t0+SmR+vTlMW03ghA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784798374; c=relaxed/relaxed;
	bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BC/x3LMjQir3dhp/cD2H064MZ8eF+ynESx1WR/AlnHInBqNS9nC23VJVi50lAgwXtTY04UbxH2xTJ2MhrzGvbhClRVAwNKaWPLgppQCeMvJMBwvICUT8i29223y8k8gWikrHw51h47DDVJofvhNfE71bOtC0V1XDYIivvhyjtvYGL8wmvxZeVR+UTlcu4nsTUAx151n4qnnfUdPowYLYv+iMOuCI0aojzoUugXV28mZDtYEOa27iO/L/dYcwD+IjfRx3de6NO4a5FFtknBgnW5J8dAoy9EW0vg9PEqXrRzes6x4vEEAzX6V8XU+Pl1V9jtaUdRWwIIWITOpGFah8Tw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=JMaPC1i2; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::82b; helo=mail-qt1-x82b.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org) smtp.mailfrom=szeredi.hu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=JMaPC1i2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=szeredi.hu (client-ip=2607:f8b0:4864:20::82b; helo=mail-qt1-x82b.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5QYc3Zkyz2xs1
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 19:19:31 +1000 (AEST)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-51c2cce930cso3966871cf.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 02:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784798368; cv=none;
        d=google.com; s=arc-20260327;
        b=fVldCSBDoNOgpu7GJ92T9ecY7Enu7/ul2vybsaM7iKU+yB+HZ0rVyMGVipVRm2xpdZ
         U2v8sikYE4Nn6t+Hh8cfEx1fLU86EZX4QK669A/7VMWAm+QXiF9jD3xka4EQhRxmG+Jr
         FHRWiRCkjuqWv9Tbh+0JU8YdRiFof3DE6j5maTk+v3alu7rAmBvwYlID5ZButCDMfpaa
         Jc6Qph/ik7GUMetTPZLijPMUCYW1Bm87gcaBLEKRe3ZLg7Hr8ylQUvBv6yu4pDfOgKOn
         FvQLb513R023mYahIRZqA3AwJ/hBOqv2C3WlfgFE+yvhN5asAC+jWBGrhor3m+6IcDrQ
         AB5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        fh=NzU7tSi9v817HfMDxSMwNzavdiAqWGmEoaCgHeazMMo=;
        b=b0DMyhfO1xw3rlKoTmdHf+OllyXZGO7ER1e7hpVB7Ca+FPD3toaFHik76p6MUh9iEs
         ZLZ99cm6dGNeR2wdKOv11Z4IACX4ZQl34W6LN7Yq2whLDl/cClbQ45bR6XhomQnIcRDG
         0V1DIdh3FlTYB2lQBI8s7YFaLfHsObTcfy1W9BHIZrwC9qy6VFYNkgkXIbNhsqCpDbv9
         71ldJ/SdOxzZc3o4XsvUKP923rbS7dKKiUMwqqGJlKrwpQhxT95rB5kCZHLTFanQIdGl
         gLDCijkQHbqcZ631k6R4WRkOLuRgr+4YiQEW8PPUswJJqh1IPQQX3XDDOyJnKHfa8Epj
         SYlw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784798368; x=1785403168; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        b=JMaPC1i2uZwfhZURym6urNnWntKT5wz5afWtc7V/pWNYWwEvFv7GZ4x2q0YPo6Jnni
         8plQZ8tyjpywyZ1aoZvO4xgISU5f7ANhnZiDCDrVnfpOk7dI0GyyWgGk70pjOwOeyLW+
         BB21uS3RfHCL0nCOsx15vg0y+m0Vh/ulCRLn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798368; x=1785403168;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        b=KrnatdlXBJ6ePJZ2Mb2bREkLJUkNbfMDPDXucTPGzU8rfFIYBJnkC5Q62TBZOM0oFO
         XkpNpfhVBedoB1Ti9iW2zSh9Cs2EnxFukhTe5RyrHbiTbH3sjZ2Vnw2yrsdO0apWTYq9
         2wKnri/FbR+bkeI1iO62oQUGvIa+4L+wa/FZ/ac9cLDoz7gK46hEJb6PXLC+pMpSAMGa
         yPT/++6bh3L2sTP+vgUN1D1NF1XOnuIpiuhlEaOcKrPCQQJfMvk42x52JzwpV2dMd2xQ
         aO6/vrux379fX9mlO2efx9HloL5t/qqSIvu+yc7gKBhM2ewOoq2oVCqvWUm2WConNrtm
         97FQ==
X-Forwarded-Encrypted: i=1; AHgh+RpeODXCtFTBl7eVJCtnlHl6M2esYhgwaLVTqJn1vaVLGTu7IWyNrmhp3sDFPubA49XTimiIBksE0yvVVQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzKj4WYnXVhx+x6B3Ebg/8hzdC/hhUEWM8UdgAZsAkBYj4FAOW+
	7dqRffQX1Kj+FQiHMBtit+2UCnBuqhMqgp2v3F4ut5cL9ps+S2aWOtzMOX9vQkfiTDsjjCgPbqL
	WYLytRc+MnbiGRlHbDJLcxfaB7Pf0Krosk3mluNVw7g==
X-Gm-Gg: AR+sD12uVPZ3H/VmHWU2KSfEjMGWrxR3iWRDys2L4LuO4K35dOxJr5jvXHWYbdSv6yV
	r0M0F/50cCy+4Pk16GOWSkFm7ewrQrYPi+znaUxDsrafubaie+kgzek5GS5LcmQd8yxlezh9xyV
	KlebemZsZFyTMCegIAuiGP4OzkK/OvIOb8OS05u2thh4zi2hDpBnSbKAaz+0pRdC24e/N4hFbjc
	s33Y4+e/j5oICGWGmBw/cLqTjpCbYNHOXSH9JLcCNWLPWKDbIGyqJ3pfySWEmjTUbD8xEp7170W
	7YVs4YaC7n1KUjWhBT1/DMlQb+8k
X-Received: by 2002:a05:622a:1829:b0:51c:8439:14d1 with SMTP id
 d75a77b69052e-5283dfcded8mr20528451cf.63.1784798368136; Thu, 23 Jul 2026
 02:19:28 -0700 (PDT)
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
 <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net>
In-Reply-To: <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 11:19:16 +0200
X-Gm-Features: AUfX_mwYbGEjI6yeBtsXmiyva2-bOQkj3_zJ1N3_FyC9B2rBmuR5k88F1rTJxak
Message-ID: <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Xiang Gao <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jul 2026 at 11:01, Andy Lutomirski <luto@amacapital.net> wrote:

> - O_XYZ flags to open() are all kinds of awful, for historical reasons th=
at are not fundamental to the concept.

I'm fine with limiting this to openat2().

> - symlinks. If we have a new API where opening /proc/something/magic/blah=
 can access something that ought to be inaccessible when accessed intention=
ally and with privilege, a symlink pointing at /proc/something/=E2=80=A6 ca=
n cause the API to be used inadvertently.  Admittedly we have this problem =
with basically all symlinks, so this isn=E2=80=99t exactly unique.
>
> - our nasty fs permission model. We gave a sort of gnarly mix of a bit of=
 fd-based permission and mostly mode/ACL-based permissions for path travers=
al and opening, and mapping this nicely only new APIs (as opposed to actual=
 files and directories) can have unpleasant results.

Pseudo filesystems don't usually do mode/acl based permission checks.
 I don't see any issue with that.

> Of course, I=E2=80=99m busy arguing (slowly and without a concrete propos=
al) that we should have proper capability-like fds, and maybe that=E2=80=99=
s kind of an answer to this:
>
> What if we had an API to get an fd to the =E2=80=9Ccontrol filesystem=E2=
=80=9D for a superblock, like your O_ALT but as a real syscall or maybe onl=
y accessible via one of the newer and less janky open variants?  And what i=
f the resulting fd and the filesystem tree it represented had a few propert=
ies that made it very different from normal directory fds:
>
> - You cannot mount anything on it or its subdirectories, nor can you open=
_tree or otherwise mount it anywhere.  But you can open_tree the very speci=
fic things in it that point outside of the special API (e.g. the overlayfs =
layers).

This patch provides exeactly those properties.

> - Privilege is fully captured by the original call that gets you the fd. =
 current->cred is not checked when *using* it except to the extent that you=
 might need privileges over your own namespaces to do operations that might=
 affect them.

This is trivial to add to metafs: just store a ref to current->cred
besides the path.

Not sure how this security model would work, though.

>
> - You can=E2=80=99t fchdir or (hypothetically) fchroot into it.  (Not sur=
e how important this is.)

Not sure if there are internal mounts that have directories?  If not,
we can just add a check to fchdir/chroot against mnt_ns being NULL.

> - Maybe you can=E2=80=99t follow /proc/pid/fd/N links into it either?  Or=
 maybe that would break CRIU too badly.
>
> The basic idea here is to try to treat it like an API that happens to use=
 the open machinery but not as part of the filesystem hierarchy.

I'm not opposed to limiting this in various ways, though I don't
really see the advantage.

One thing I hate vehemently is directory lseek to a non-zero offset.
I'd happily error out on that one.

Thanks,
Miklos

