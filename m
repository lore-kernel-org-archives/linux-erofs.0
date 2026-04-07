Return-Path: <linux-erofs+bounces-3220-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0889CFF5139
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Apr 2026 20:21:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fqyKK24qBz2ydq;
	Wed, 08 Apr 2026 06:21:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::42d" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775593317;
	cv=pass; b=iItnLC8G57CE0E+6tYuxxK0ZG6z/9KWwno7YU5ceaLZP7cmS7K5oYe5r7Fx9TyjLDaPWtyULm0x3buznnsIp14hmdS4TQ/sHdz1NVYXQ53ePx2k1ZHVR4P0yPscJE35tK9+CPzu5wyHgx0OSdjxrDmURpaHVQze5a/VchOB96nUJ+DjSYsDNcs5+YLzwsoYAJz7I4awbp3n5la45QNmdMKtrJtd1Rbyf37X553tP6vrEbFb5NLqRwfeLXCtxnFi+7B4K1XFJyTu5oAXmML05AJ4aWFvwW7aT4KswB7TJCh5XggFIX8H6zrUubaKAEFM7RMouMdWtzFb2KdKEufVOhw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775593317; c=relaxed/relaxed;
	bh=/8nRFvW3dvzP0f1HI4A52To34cw9HB6EK5c+K6burZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IdV0nXyBOK35HEgWlBcfO0j7BERd2JDp4w2d1JjexZHLOzee32UN4eBQ1Nx+mGtjmoy7d8lESxW2fZbgQwR5limuTqpIxpaDhyG09Kh2L8DWwpDR3CQFg3GYIYgmqSSUz97WRW81X5EHdeAfJpVnT+Qo1HBHBobWOKTcTR+aITdDHeQh171Gp7WPjBNMKi92I2D8cy6Dmlwj+686XlLNjO8yUeMbCmNLpTZzyvAFyWSIcjZH2d+mkeVEb/7a9jk9hG/qRH7ef/swgzxT//zhiHPfafzeZBMl9GX5J1ho6A4403X8/In/2pJmxeEIBd21GPk1KHdSEA28qbCzyn8MjQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; dkim=pass (2048-bit key; unprotected) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=BMaYFYi8; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42d; helo=mail-pf1-x42d.google.com; envelope-from=paul@paul-moore.com; receiver=lists.ozlabs.org) smtp.mailfrom=paul-moore.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=BMaYFYi8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=paul-moore.com (client-ip=2607:f8b0:4864:20::42d; helo=mail-pf1-x42d.google.com; envelope-from=paul@paul-moore.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fqyKJ0VRlz2ySC
	for <linux-erofs@lists.ozlabs.org>; Wed, 08 Apr 2026 06:21:54 +1000 (AEST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-82d0b68837aso2315828b3a.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 07 Apr 2026 13:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775593312; cv=none;
        d=google.com; s=arc-20240605;
        b=dX/7lX3hmfAw82UjDrprKwadPPlVdpT7WZ17pbd2ob+odd50HDGa1pMZ7gB6Tvcdni
         VmibzB4nMhyUPr4o4q2vpv7+4JvzbYPrW4YURnqmj0hdIF3QS5vHma4okHwJac6uV2T/
         zptn5hI1KPd57iw9yrZ4TkYWXD4TvkzR2t5LAO5G5qCHw5Dqequ7OgxJMH9IGuGwib6q
         LZavgMtpRf3n5U4YjaWeVwqP39txxm70wfJV03tvdOXg71jrl6Rh7MAOkLWDOuGa1n6J
         l/VEQYxkZSUN1+EgUkZgTVAvmsfgDzQlNXZe7SYF4GcTMoLizibwMV6aq1cKZMgx26lH
         OAZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/8nRFvW3dvzP0f1HI4A52To34cw9HB6EK5c+K6burZQ=;
        fh=kUkgyASDgd9deB566F2vWwrDgRNdfRlS8xmF0YVhke8=;
        b=JVfjU7ESuYQnaUa1d0TI70Yt6Dns1N3oYhaveN0NWSPVNHRO+OIvV7SPe593JqjyXD
         g5+ezDkn+AYJgqCtwpZicCahfcvoulef+L8P4bcej6RAI9cs/eZRVnZ9UL8dbQC5C1x0
         ptQHekJiLbEa+8lVynT/AmV1zZl/R9Tze9V8XI5026I8/DXBJ70NNnUYscnvwBMClD2C
         vTAWiJdEDoHe1ZBS5+4MJl8rslVPSaP5Dr7lO5QvVgRbK/qLXEM3IV1SCEL4DLJk6osr
         dENPuS8SGde2hObLlrPZ1UC21cZyY/kuhB2hqc7jfTPktr11Sy4Uur3AptpVDPHNSI/T
         WR+w==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1775593312; x=1776198112; darn=lists.ozlabs.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8nRFvW3dvzP0f1HI4A52To34cw9HB6EK5c+K6burZQ=;
        b=BMaYFYi8fZfNKQsjjn3V2FgrY/lHgEdLaT/9R1DLhIJo6tyL/Z3DfwuLdFASMkQMz2
         7btWoLOifQUCIPEQYyNJhkepzJd/FtQKbr4UrwYby11mbibLCXoWWzs3ro+7vJ8HPHQQ
         91X/eV3oAarrB2u4SKGMHWMgECh/xiruMZEFbwLGNt5PPgXxfgPlHdm8TurGWqhwH2Db
         Hu1ngybHaGqC4xP2X8bv2QVlJtlS4xyuz8u6Ws8t00teJuzpytAEJYn78b5biDCAZBr9
         dmr6FDi3en76zk68fHCZ9rRQucE/9/haT9xmwGqjTOy2oveUlbW/iBOT3ecPU0B5gxDY
         QK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775593312; x=1776198112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/8nRFvW3dvzP0f1HI4A52To34cw9HB6EK5c+K6burZQ=;
        b=JGHreIEkMh5bzzA1VYZcIYxBgxeUeFNxT/yFEsOvEnJt+5LGu9E89yGfwn3+nu+5j+
         mvMFfu7IX+Lzs0OLK2HGRmrefp1jQOeTj6CE1Vv0GR+gMjxpC/Nv7p1uS8/mL0mCCs6Q
         Aqv/WeJL/ovNq3R4RC8j17ZCXHcmSQ0R7XOLI6kMghYRuFjM7BL0ArNj5w0pU12Y692w
         iYJLcwV+OMu7vgwRhY2ttO9N/B+bYgkw6YTaG+kQVKyiaRFcU8QREL4jZ8n+JIY5kgWA
         0f3SYy+UnD9h2IzzQoABwkbsmIZhsoW1YaAU8Z7FPkoF4Mm48eJdQ5/GsRdLJC+cepKu
         kd3w==
X-Forwarded-Encrypted: i=1; AJvYcCWby8tn31J3iYo9CAPGs8yM/lb1TNU3IMdMmtZH0dfdhW+E30oZEu+PSfrdUJW5OtFboYrjOnYcjx6Uig==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yw0jcYBVSt3z83eKN4CGKQeSHEZdWnTGOzaF4sqchsLSbHh8B5g
	PEMhFekgc5Dzjbrzz8kiaYD7BqgPSplG3vdlDPH5pKbocQNtKFj5H4Ye1fsiPppSuA0e/BHcnFU
	lSmcVqOP0QH5tVSM+59S68Lw4oEN9TTYH8kZ5bWmb
X-Gm-Gg: AeBDieu//WAPSB2EC8Lua5TDtjRApuBDl56Y7gU9TtpgJ4e0s3y73EYhHQ6xC0UTMQ7
	FQR/JAtIdpZJKhtYg+gik3EPocYVfWjwNM+3rGzZfB5TvaBgMgHSKcSV1gaBfy1RU0G6L2oai8b
	ipRjZlbSWUTd6tWJdzUrylLKSFSMZ8ZOmJ+e1mJHmVOhOH6Alt25Q8l87Tn8Elf48ff2ow565VU
	mVL4A8oAKxZywG7xqQsv/+uKC1vdGSBanyIIxmpbrsZSjXhA/7DG4wj37L4ernV43ggqI8QEwS6
	Ae/FXsgD1DX5+sgQRQ==
X-Received: by 2002:a05:6a00:1a89:b0:81f:4a36:1c7c with SMTP id
 d2e1a72fcca58-82d0da74ce9mr18411507b3a.23.1775593312517; Tue, 07 Apr 2026
 13:21:52 -0700 (PDT)
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
References: <20260403030848.731867-5-paul@paul-moore.com> <20260403030848.731867-8-paul@paul-moore.com>
 <CAEjxPJ4nqeuPhve3Fe-tFuNW9R5grnWwfYJv7q2cRu+UPQ5c4A@mail.gmail.com>
 <CAHC9VhQnA38-9wDeVmOMxAFPHnd9y6x5LXtD3cSquGiL_MDDpA@mail.gmail.com> <CAEjxPJ62=0v9QYJ6s0DrwRp4WZna8f9wnuM_DUUNrcz2dd_kog@mail.gmail.com>
In-Reply-To: <CAEjxPJ62=0v9QYJ6s0DrwRp4WZna8f9wnuM_DUUNrcz2dd_kog@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 7 Apr 2026 16:21:40 -0400
X-Gm-Features: AQROBzC_mkg1V6Olu64dm2ucorBxgS86oz5XW-KOWVbdzobSFYHPihrj_73P3oU
Message-ID: <CAHC9VhQ5PH99EQBuYq4c7Jf82UXiDfC7qzM2kvnZuyH6yFPL_Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] selinux: fix overlayfs mmap() and mprotect()
 access checks
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <xiang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 3:20=E2=80=AFPM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Tue, Apr 7, 2026 at 10:35=E2=80=AFAM Paul Moore <paul@paul-moore.com> =
wrote:
> > On Tue, Apr 7, 2026 at 8:14=E2=80=AFAM Stephen Smalley
> > <stephen.smalley.work@gmail.com> wrote:
> > > On Thu, Apr 2, 2026 at 11:09=E2=80=AFPM Paul Moore <paul@paul-moore.c=
om> wrote:
> > > >
> > > > The existing SELinux security model for overlayfs is to allow acces=
s if
> > > > the current task is able to access the top level file (the "user" f=
ile)
> > > > and the mounter's credentials are sufficient to access the lower
> > > > level file (the "backing" file).  Unfortunately, the current code d=
oes
> > > > not properly enforce these access controls for both mmap() and mpro=
tect()
> > > > operations on overlayfs filesystems.
> > > >
> > > > This patch makes use of the newly created security_mmap_backing_fil=
e()
> > > > LSM hook to provide the missing backing file enforcement for mmap()
> > > > operations, and leverages the backing file API and new LSM blob to
> > > > provide the necessary information to properly enforce the mprotect(=
)
> > > > access controls.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > >
> > > Do you have tests for these changes showing the before and after (i.e=
.
> > > failing without your patches, passing with them)? I tried running an
> > > earlier set from Ondrej but they failed.
> >
> > A few months ago I sent you and Ondrej some feedback on those early
> > tests from Ondrej, but yes, I also had problems with Ondrej's tests.
> > I've been using a hacked up combination of the existing tests, some of
> > Ondrej's additions, and an additional debug/test patch to ensure the
> > labeling is correct.  It's far from ideal, but I didn't invest time in
> > test development as I assumed Ondrej would continue his efforts there
> > (unfortunately it doesn't appear that he has?), and I wanted to focus
> > on getting a solution as soon as possible for obvious reasons.
>
> Ok, I'm happy to look at even unpolished tests - just want something I
> can use to exercise the before and after states.

Hopefully Ondrej can provide an updated patch.

--=20
paul-moore.com

