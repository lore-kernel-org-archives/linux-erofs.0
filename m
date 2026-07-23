Return-Path: <linux-erofs+bounces-3991-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BF85C531CB
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 09:21:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5QbW6YJJz2yVZ;
	Thu, 23 Jul 2026 19:21:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::532" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784798471;
	cv=pass; b=atZ/6wqWVd5xXhE1wZ6sezaiUv9f9nK45RZK2n9ArVU1vvB1kr2Rqu6lPxnPfwIlOmA/+wJmbEsgJmX6H5Y+5PjtGJF9oMQCXk6bGvFp0chxt4JFm1ItsJ9oZOl9MEWO8pj8P3d5qThuq5WCWxdnvVSbBsOzGBzHsik22zzTPzcZIZFbpfkZiXPQjFVNdVEbpTU08xr0qKohM9pYXnSeyQJ1d2luodFd5uYkIJPs6TTu686W8GROE5GF5ckBc1sS/ubFBQ4/lL07zk/JJW7bWJwgBCpu0ivMkK9GVUyQOzS4/ZA+30OciVvWdAwQr5IjGaE+iyv8yTzUYCfWTanh2w==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784798471; c=relaxed/relaxed;
	bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nhhWJHTAtUX+NQGTfRP3hhW1Md1dLvt8fifvzm9Il6irrS12rrPA4+xYqN7KdWyT5lO0rO95xNYopJxAgWSbOjDwCr/fQcUKIiMIr3xWJdYl8IE9xX9Bl3X72FK2C9Xm6YPXgze0+AQYndpZ4dzNuEuVWAHlnI/BHaf6oHhkDXePjkDnVukyQ9Pz6rUGe0vhU5dv3j8U0eebvC46M1FGjzTjfiKr0Z9ZeuRH40Qogpc23njdR3ladjZDSi3AvQTwUMRK+LaugKsr6qNe+CdnJlVnTYSvMO4qC30mH444JCrHKXDN7jMgTtwuaG8RhHKkBVgGKHyVS9jwGaqjeti+nA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ns1ffVUA; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::532; helo=mail-ed1-x532.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ns1ffVUA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::532; helo=mail-ed1-x532.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5QbV1BmYz2yMn
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 19:21:09 +1000 (AEST)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-698e5859a3cso609170a12.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 02:21:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784798465; cv=none;
        d=google.com; s=arc-20260327;
        b=Lia4BBMYTCWXNQYl0ItzJKvQAZkmBZr3M1ObSyj4uyHpThBScavtwLm9He6qwP771r
         fgmRM7G/BivKhBwbL2ypGWQmXl2XdjNQq6d773FcCAmPWG4kCMO+G4+swqKZGa9vNTdf
         5taUuCBX0svsmJta2c1ThcBk41tyqQSRYPxX5gpds9B9U0CkM5LfRzr2BMlLGMh5mqrO
         wdGrY2ANRtWv1ytB3gjTv129n354XzojLWnJD6wjGCKPjFPOeiKsO+xeHj4JVW3Szy/a
         PqIzSyGm4eEHaeTrW0Tiha8QOVTHJy4P8uybde+LBNIdn2g56Ied3jFAr7JwYtZPn6G0
         Y+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        fh=XnCNzVrQ+YIPrANDzKGOA+PvZCur/oz3VlgahwVi2Zw=;
        b=lEs69Xe2aMLrUoE/fWie69npkLTp5IVzyrw+FB3zTvMJrZycK7BMtXW5h6r3mEXnZE
         uRaAPKtdPqXgD2zk8HXRVECGYQxhKGxI8YDakPN4dpZgQeReiWhoNp6+IvpKym2Gh9bx
         wRZtE02ram/JBkEgAXJZQ9Gx3NL8xaunnfJkv30OHJy0wy8n4x6z+RqlFyRDQL0WPDyL
         AkXF2gorV3HGe6+gTsPTyvnIXowRhEfGYwgBwHWn+Pkg85RaRBW07cixun6rQlKhhUU8
         AQSVVt/dXmKR+87Y92ktgj0+8y+2j8QAri5rNDKCqmTRJzseM9rpi2/EPQh/yjLpIhXu
         cjEQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784798465; x=1785403265; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        b=Ns1ffVUAuRrK++tJRqEFS6MILIvZB6iFiBteODR4xPbQz8aArZFJmQwOmlrNCGMoQn
         FidRZbSSV8XEqmsekURpQPktJpdFIR/KGaP5Vrvg0ZsLjSwGrvj2HWH8KgOP6MJP76OV
         EJzzI2fcjEZ92lOeXuVPDULWc20P19+gU+dGzuF6IuyPnlKyqa+OSc5mfyToPjpesa4r
         NgLBGYYiT5GNEgMJCcy9qPxmLyJPL7um83ZZwe68BhF/NB3Ylpl8gtZOFDXAbAJgAdlU
         u2vDrFWHZSDAKlsj4wKc+tDwl1/iIdcurzJpNdT/m0DQKqNxY1tI9oJFwOjiNr0tjjY2
         JIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798465; x=1785403265;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        b=fv5OVTS6DRSBSSsA7y0M5ktM2F8GkcWHZo9Mq7hd75HxwOW02UmSNTp+ESn5eMm3T1
         K20YFRbCvFVyC3e0t+PZNZbI4ZJXx/mgFzGXjQz5jdIVRmcu8uldRmVrI0ALY+sp1sLW
         CGv0h6babQKu8WNVak0Ev8O+xWQb7Naoyej5UeinoaEsV1x/N5ThiD33js0Abgd0vXjv
         YmOzvcldROzF3hHu++Mz+G6h2Kyko9Zk9I2Z92REKImouo1fx4DLGAMrn3le+NvWW7I0
         YOzAl8En1GbkMkEpkbDIa+LPblgfXAwWGTth+gusZp+/UPi1Uakvi9aLwVt5ONUF3rsh
         8lew==
X-Forwarded-Encrypted: i=1; AHgh+Ro3qHqsvBhqUYi1vjwAtQ61zq1TYi1p5Vki4TU00/vW6bfDczPTTbhrlynh0qMOmreVzmSgknvJgaZCVw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yy7MxPGaNwUeWm0JoZnJ+oOmZEaI4px/xWVGmisc3R0R2f8428W
	nE75Xa+V+KEyXcGe9Vzd8IYH4/n/LbkBnbETMNyKuGUnqK6ZjEWbFzffXdYl8pm0/F2x1Wye1Qv
	fCMIkPGxdwmrAAK8OHU5A92UVMKtXWtP8FJudDGnDhQ==
X-Gm-Gg: AR+sD10QO/pCQfyTsLH40n7ZIcsa1kW6t4I8qZsvpIGqp8ogFq7CMRmAjjJfmuL6Kgv
	TUTWmIRvo1TQOolbrztS5FvFDtivu8ni2phU0L0Gt+fsgV1tJHP3ektArojPHBFgYWez4/YLN/4
	KTOxu87C+ARUr2r5OmZAEpuLpcrCI4pJDMwqWpWPM8Hy4u/ND3++s3dA43hb14hkbuBsMkgz+Wo
	lgVkabVZ6Uu1XhHvvcea/fpzyXD1hUfQJXXdLMzMWYq0DdbtXqOaszmPPQsebY=
X-Received: by 2002:a05:6402:2c5:b0:698:a9fe:2eb3 with SMTP id
 4fb4d7f45d1cf-69f7473bb1emr481810a12.9.1784798464605; Thu, 23 Jul 2026
 02:21:04 -0700 (PDT)
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
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
 <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
In-Reply-To: <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Jul 2026 11:20:51 +0200
X-Gm-Features: AUfX_mzGhC5ulgDl4H2_S8AB0-LW8RqyX4r61JB4nfZ8oT5YdWhv684RFp1OggQ
Message-ID: <CAOQ4uxhqmh47w46x0zhOzqJ54iiL0KDpuuAqr2oPyjm4AOgDYQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

> > And the smaller details really show how inelegant this model is and why
> > Al and I have opposed it multiple times before. Scalar options are
> > modeled as symlinks and non-path options are dangling links whose
> > readlink still returns the value while for path options readlink returns
> > the option string but following the link jumps somewhere else entirely.
>
> Hey, this is was a prototype to show that this can do what Giuseppe
> needs.  Not with nicely polished interfaces.
>

I want to do a sidebar regarding "what Giuseppe needs".

As I wrote I am all for introspection of overlayfs layers, but I was never
fully convinced that getting an open fd was the correct API.

The starting point of the use case is a userspace daemon that wants
to reuse mounted erofs images, which are used as lower layers.

When considering a single daemon (e.g. composefs) this reuse
would be better done completely in userspace without kernel involvement.

The reason for a need for kernel UAPI for introspection of layers was
to allow cross daemon optimizations, so that containerd could reuse
erofs images mounted by composefs.

This optimization works under the assumption that the image file
or the image file hash is a unique identifier of the desired lower layer.

But what if composefs mounted the image with idmapping or some other
property?

And how many container runtimes are there out there?
Is it really worth the elaborate effort to provide introspection
to this level?

My intuition is that introspection should provide static information
like uuid/fsid/fhandle rather than an open fd.

I am willing to be convinced otherwise with the proper arguments.

Thanks,
Amir.

