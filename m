Return-Path: <linux-erofs+bounces-3987-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1F6C44524
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 08:00:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5NpV6YwTz2yhP;
	Thu, 23 Jul 2026 18:00:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::829" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784793634;
	cv=pass; b=Dx5P+1/72H1EyZuTq2f0LvcKaRkxf6SbQLvadvK9QRn/vOH4cYhUJhrKNvGNjgTH5SLgEzGkTI6yNZsUwFKIOju8RDijrlI8FgvyXMOzsm6gtl1EXop0jsg/ApnWqOlDXCatMl+oSaevjw8dS9yzQiH99DqCkwnj9LLcBJgenkigefO5ewX+PISTS23YRc+gPNGXODaFd/QO6TbPeCet7y22ZCml45EWR5rnc282XjMUcYSSoJ01OE1BydnaQIH7DF70d+ZG2YATlOI2MQx2rfH9cTW4PkOxK0IHzHwLQuTEtrx6nUrSrzen5xOVp2zKbVfDeXUMEeaGunAVHSzK0g==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784793634; c=relaxed/relaxed;
	bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EW/r75N2c7XuGDzN3mjn+mhhQvG4OoHjltdQunxVNpciXbJRHKTL9NdNNjW12ulULno8B+ZoHdeoFt/1CTP+roUbnaZVKO3SZPPTmny5mGmc0WJUXRE18fVdBljJzfbXfVqJjhtV4rULpteldOzgUY/dkYQm11OQGXVWuudyh2mDnSlyKli/MhOCTeQY8iKFpRbgMRG5Ccx5eQedDQ/MM0q62LfrEbXUfmD9kFUojqqALpKtTzJhOSV2+A0BdTQ2whe84j1RfAF7ahcoYp6HBtdtydK+O9wceBvztwx3rf2FJunWZLKXkDBjcE7+Tpnk2Gt2CNz9BsVpwnP1OvXKUg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=k+ghJDBK; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::829; helo=mail-qt1-x829.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org) smtp.mailfrom=szeredi.hu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=k+ghJDBK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=szeredi.hu (client-ip=2607:f8b0:4864:20::829; helo=mail-qt1-x829.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5NpR40PHz2ygp
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 18:00:29 +1000 (AEST)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-51bf2479349so3288201cf.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 01:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784793627; cv=none;
        d=google.com; s=arc-20260327;
        b=TIXkt6NNLtsuXdCoTzmRbFe8CfnFVKbE76I6C7J6f7vusnewuJbjR/0PfxTnRmNpuq
         25P5v1QMjFCTJJFlZyWEEgzqiwwJhRMLWNAFmMOA6mOuB9MMN7jXaywEqgWjjUzVPpmZ
         o1Y21/a0z6GezohAqP8MLgR/MCbUoitCV2YS8fwp1g6FybJWFCBvWNdVtFcAe3LyovCd
         kEIRbZKNYHcb5OMVuRSOChjJg858VD12cV6L78Gcwiq2lt/ELA5BX2YyyCd2r6BmKftW
         neVB/OFx2m5EzU5RtkA936C0/hnQpdQhftXuiAb0HP1fz3pTOYK9f5EkB74JWaJYPdPH
         gKrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        fh=jNO0/of1+jkyJSAg4kvUm+qlH9/9kLAGPVTTOLrM3H4=;
        b=OcfpHWDaQtmW/DzHq8Xt1JWLysIN+gzr5jkAaGy3WOwUalEwQ5Qs1unhnEG2FwhV6e
         qjwia/8NYp3yFdRFsA0C++mfHmfhPc6ID/rrONMblUjeRXWu0A4dGTnBX6L6g857Np12
         +mS6PojqAPy9tnuxJnCkiXpa97vq8L5wEaleIDqqTqv9liy0hS6fm0GTYUOm7DFpJmk2
         kTdaLptVrEiV2SXmimN69mtNEmMwAKaieTySTUdLlZVDNh6W5G/C/N/Ifv8Ro1xoUYiD
         ox6azbO41u/s9Rk8mZI/0JtWp/wsD/Pc2+CQTrHMd2RZkLDrJT9xgP1vDQUKWIUDYU2D
         /tdA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784793627; x=1785398427; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        b=k+ghJDBKk4g5kznReUtxkcPPYPNzcor95iukeMMK/vHSLQJ1jTs1zsFUw4Soe3fAmm
         GEwJIJ3lsT0pc4Ex+JldU+YUO7xO8PyYg55PBU8crIVJBOoQ7IyrTyqfPe3GPipbDsgl
         OvbOAwKXTkDPZ6Gyvu5SY/ZOXDerGsgXkEvvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793627; x=1785398427;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        b=EtN4PlnDIBlfGoLIAiSknDFb6aKltJSwItCzdNgimxw0wvRx7fRKP8uECZTblVDIYj
         q8dXu0dLk04Isfzfno32Htj0nh31NJhrwIZ7piVgxkiQ15hjqyGrvBkktrCtKs4ImKky
         NQqewNeR0giwfNZEDos4+ZtCAp3lONCb/DLdeoV9wYlgf1mLKFs0mubPYMaInri7S9Ti
         PB9xFdIPBRZIN6eGMRn90qtEMTmkFLvrCrw7GZGPfWGDztYxkg8P+HySVU3OoBnyp1uw
         LRbOe9a5nsKzccLcwd0dODJLJdt44+63/Xgh9bsH4mPj/Q13Qiqug0gUXlH73DqVJ+Su
         halw==
X-Forwarded-Encrypted: i=1; AHgh+RoawJbtrr7xEHc37n2zXSbjb5hWQ5BxL38s4bY1N6V5iaOAh2ZqNGe6P620dbqgmnkcSc8ftupOKCXRRA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwSaFp0po8xlK3FCzOgPrR81m0/Fb+kGbXKskU0Nl1TGRznEwbq
	/sBihpbYXhJ1TxGZoMiRY4Liqw+QirBGf5yHtVXpV/WnS4x7f8/RTuzl9SOfjYNMxEzJb69l3L5
	DlUPwaDJk6Fh1xNUE2oQj+93GuKamV5qqX7ZISJgQsA==
X-Gm-Gg: AR+sD11pGGjocDiNXout7fQpOUVztI+rlcxqDA5wMhmmWYgHQ6peMymPOSVctG6Oxtg
	h4/Aaj0lTAVNJySbLZ9ykLTlMrrFZyXs+zDM6AjHNbFQw2YqE1W4MDq/vcB/ZYvM7vpHvVJGllm
	3wYFi20mDx6KhseQqnmJ0zWab1fCcUacZZ1+kOc0aUZKlcFiA25Tvhw8CRQJqAsS9dLEe+PfQ43
	W06L73oiY9lVDa8Bw3VDyr4MD5LcnxXWr3E5EScUh87llB4rXWDNLFKC/5yFTcFYyvrLJMQphNf
	92ZTaixqR0R6UjZsOg==
X-Received: by 2002:a05:622a:a06:b0:528:3ae6:14b1 with SMTP id
 d75a77b69052e-5283ded5b58mr17799601cf.43.1784793626482; Thu, 23 Jul 2026
 01:00:26 -0700 (PDT)
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
In-Reply-To: <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 10:00:14 +0200
X-Gm-Features: AUfX_mxrAWDoGqE_Z2q7dsB9hEn4mw686sbiCfQ_kvnOWqvfJ8QAiTiMbX_EDHA
Message-ID: <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 18:06, Christian Brauner <brauner@kernel.org> wrote:

> We've added a primary set of apis to retrieve mount options. I really
> dislike the idea of introducing a completely orthogonal layer to do the
> same thing (or more) and also make it filesystem based while at it.

Fair enough.

> The other proposal of moving it into procfs doesn't lower the creepiness
> factor. It just paints it a different color. My objection is to the
> shape of this not where the entry point lives.

Also fair point.  The reason I like the proc entry point is that it
makes this accessible in the global namespace.

> Like, I'm fine having an api where we can use open_tree() to see through
> into underlying layers and given the right permission pull a mount out
> of it. That seems something we can potentially do.

That's exactly what I was proposing.  The "retrieve all mount options"
was a bad idea.  Will drop it.

> There's a few issues on top of that. O_ALT is silently ignored unless
> you spell the open as openat(dirfd, relative, ...). path_init() only
> looks at LOOKUP_ALT in the dirfd branch. open("/abs", O_ALT) and
> openat(AT_FDCWD, "rel", O_ALT) fall straight through and open the real
> file.

Good point.   It should either reject the non fd case (including plain
open(2) or use cwd as the base.  I'm leaning towards the former.

> The layer symlinks are an unchecked jump into internal, out-of-namespace
> mounts. Following mount/options/upperdir/0 ends in nd_jump_link(). That
> doesn't do permission checks and no mnt_ns check.

It should do the permission check, will fix.

It's jumping into an anonymous mount, why should it check mnt_ns?

> The overlay upper/lower layers are internal mounts with no mountpoint in
> any namespace. So any unprivileged process that can open the overlay
> root gets an O_PATH handle to a layer root it has no search-permission
> path to and on a mount outside its namespace and can then use it as a
> dirfd.

It's just missing the permission check in metafs_path_get_link().

> Pulling the mount out is gated by CAP_SYS_ADMIN, but the handle and the
> traversal are not. That's exactly Andy's "whose creds" question, it's
> inherent to the design, and the procfs variant has it too.

Maybe I'm not getting something.   Why would the metafs based design
be more limited in how it checks permission and with which creds than
any other interface?

>
> get_options() forks ->show_options() permanently. It's added
> alongside the existing method and mnt_show_options() now tries one then
> the other.
>
> That leaves the tree split forever or commits us to a flag-day
> conversion of everything. The new thig is also heavie and loses the
> seq_file overflow-retry. All so the 99% of filesystems that will never
> expose a path option can carry a more complicated interface.

This is something that would be useful anyway.  Would prevent the back
and forth escaping for statmount.  I can do a full conversion patch
either with coccinelle or claude in a couple hours.   And nothing is
lost, the layer above seq_file is just an abstract class, could make
it call exactly the same seq_file ops as before.

> mnt_devname to s_devname move is a behavioral change. alloc_super()
> records fc->source only on the sb-create path in sget_fc(). Sharing an
> existing sb path never updates it. For filesystems that share a
> superblock across mounts every mount now reports the first mounter's
> source in /proc/self/mountinfo and statmount().

Well, drat.  Doesn't really matter, though.

> And the smaller details really show how inelegant this model is and why
> Al and I have opposed it multiple times before. Scalar options are
> modeled as symlinks and non-path options are dangling links whose
> readlink still returns the value while for path options readlink returns
> the option string but following the link jumps somewhere else entirely.

Hey, this is was a prototype to show that this can do what Giuseppe
needs.  Not with nicely polished interfaces.

Completely agree with you, that's a shitty interface that I've done in
there.  Not proud of it.

But that's completely besides the point.  The point is that it would
allow a lot of things to be done more elegantly, without adding
special interfaces all over the place.

> But a generic metadata interface layered on top of yet another magic
> filesystem whether it's mounted or hidden behind procfs I feel very
> strongly about. I also have great difficulty seeing Al supporting it.

Me too, as you have obviously noted.

I'm going offline for two weeks starting this weekend, so no lengthy
and heated discussions for a while.

But I'll be back!  HA HA HA ha

Thanks,
Miklos

