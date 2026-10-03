Return-Path: <linux-erofs+bounces-4651-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD66CA5FE3
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Oct 2026 10:30:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hxhk42zLWz2xr2;
	Sat, 03 Oct 2026 20:30:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::1236" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791023420;
	cv=pass; b=GXVPFFvGFnI5J7aB/CgYpi5fekyBF+hupd3DN6O5vslDxh9164hGKtqU5CJJ3j8vcVCKlZVYrLL7PQV6Qx2TmWOHdQNzJ2+h8nOsQCXWvLpUYQPgTnttcA0KDKEq/5Y7mUDxuWY5UakRpNjJRurtxFY0bWiwRUBjDZFWPNM84HYm7jhyvtDCng42A5A0TAJNTmS0aEyGC4EphRk7Q9fV7YWaCe6s9QQdpcEPnBVEa1tyDH0oVKimMzlMNkQ3ZYjSUU0jhxYuA/TsOn8a5yxwhmGs0kiVYSRRKLJ/gbl2SOWDCQFf1Uk9HfxRPnUfVpgOkHzjj/UfGiFH+ctBEbVbyw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791023420; c=relaxed/relaxed;
	bh=fZx9lUdvWiwCkwZGkDZExytCPtdO6wfT6mLSmqlL+Go=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=E31Bi7O4zD2NSLbJpwUZb6sE+wSEZGwcMGFu2jjsiiRhbCVf98JHp+A4JSPjr+Gwb50i2uFt0ZDCKnRjXdbhxOernc04hwWQLqgsMlpXBnHDO85QLfDp9y5dcHbu+sJugtfAYyU7ErZudAjQuTNWK7vlwviycu3s4QKzbf5InEfds9TQpzywXieZbLzNry7fmOhwg2QFTVlUtVsBi/Iluambxpk5RxrdFe+x4tbNoAq6WMMTDECpp21gJtXqEu0N9+7puuNHKFNIrKPIeKSHCTgvIi7+F+8u1Umu9F5qCBceF7Zs17F9LDd2tzXikBqcG+AiilRQkKFmq2dgp45R+g==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Rk6RaWhE; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1236; helo=mail-dl1-x1236.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Rk6RaWhE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1236; helo=mail-dl1-x1236.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dl1-x1236.google.com (mail-dl1-x1236.google.com [IPv6:2607:f8b0:4864:20::1236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hxhk33nmCz2xlw
	for <linux-erofs@lists.ozlabs.org>; Sat, 03 Oct 2026 20:30:19 +1000 (AEST)
Received: by mail-dl1-x1236.google.com with SMTP id a92af1059eb24-1419d3416ceso739189c88.0
        for <linux-erofs@lists.ozlabs.org>; Sat, 03 Oct 2026 03:30:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791023417; cv=none;
        d=google.com; s=arc-20260327;
        b=c9AuHE//TuXB/k2P2DVIp/QZZO/7ZRpa4gcg6AZa7hFdOBszFA/yltRQaoa85Q8aPP
         zhB4LonBl0V+HaMjIYj/0VJfnkJ/gkSDK/LbXr6cAmKQq0wpfOLQFOWIcEQIlmRGKYC6
         CYDkRXkNwOx6cq0nYIAZjRENlA9RqjJzFxZB6PRKaBTQkbdruLkgpReDP1KWSZ34KNCn
         CbFAavcQezAszAxDvnEOefZWbF5KbZYTcTnj4HZGeWF6mqBK2MVfz/YCP6rTDw22Rp8v
         G+G+OBFYeM6f1FsH8SNB36Art7Xdx0mJuuvGRQcl3bt8oKWqXoBWbmKNuqVt+jhTjeZu
         pQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fZx9lUdvWiwCkwZGkDZExytCPtdO6wfT6mLSmqlL+Go=;
        fh=HhiHY+hYAbWtNyZEry1wiUckwkhQAlXU46DrJ2xIPMo=;
        b=SIdtybm8Nnn0X9w1t8JF5zFlOI3cdg3ZTIGp5Z66Gkea83L43BagkqQsZAGa11urgU
         G/9lUPtKHcSQ3+ZbuGj8883SFkSX/si04uKPB2/rLpfsp/gQ9BARpzR9zS3fv7Qm37sL
         fpp6N72TWetghfvwY5MtOLGzYkGTAo2wOprZJ6K6RjuNpFOSeP3VTgkONOe73oHaAm0N
         wqO6cmPASgGYKuqF4OwECWyYa28vzWKlrQJ+wimU35LNpWEJI8VNK1pUbfEesE4codl2
         ctPkqbyc+NuR7RJWgTokJHM9XlVssMbrYjcFtEJrualVpB1x0DSse3GSVC1lh6U8NqB4
         cxmg==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791023417; x=1791628217; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fZx9lUdvWiwCkwZGkDZExytCPtdO6wfT6mLSmqlL+Go=;
        b=Rk6RaWhEjgYtGjZB32fLLkxwDTR5j3isFMI2rglWMi66844qSQrufd5JoE0NrSWv8b
         2FWO8YlDaHI5tfYR0Iv0T86YMR3WTtaao/3He0rjaJ4ZW627uvnJ/WAG7nWCB8EK+1KR
         Xr0QuIIvugflsLFhsORz6WZzZO4/AJ4yPxRpgldHxLJD5W0dU8o6d+BURjwCeqESmnI0
         VcMTAWwGr2d68de5Xm6X1CLbeXvKKDidkrVXA9FLPRy/NqfhT61X6Xh1CL+K8kK+nkUD
         kHFqa/MWY+hHfU+lYotQAHZ3+ZxtUU5RjrRUTiwLbcWfxRKKJMEro5arNi0qTVjPWIIV
         lj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791023417; x=1791628217;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fZx9lUdvWiwCkwZGkDZExytCPtdO6wfT6mLSmqlL+Go=;
        b=rz/bK1aKJ1TYrG+KzfJRlw8xez6pt9z6mPh4tBC5OBauVbs+c+EK/NHkD8iHK9HZOO
         QCmXnrgXPdMbXaKxToOAAKJ5eG4V/81OHiSJ5Rni1G+Sg30GUNIzVzajqlqRvo0nBmoe
         AVFJuXwLStiXXtDRAlIUAbsonPmMrjZZ/Iy4IcuraPvyBeyb9S6MoquRW45sCkItY75k
         TgkCDZItERfUitO2RtCIwV2JeA8PdOZv8sZxliAbW59ATbuP9MoJ5dkp/4ZKSgo8G5IE
         eDXV/WPQU5sgYaptLmJhRafCJzVmX/SnV0oKGHb/v1Cl99EgcPCmQ8VLt6pvPUgPRlx7
         L5fw==
X-Forwarded-Encrypted: i=1; AKwUvBzrO6e1cQXg/C+1Qg0YOEj6jGOqwOlTMAWaYipIpvkwlsbMk5Ri0bGsjnZz+t7GJMLAA7s4sf/ghq2qKA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++kN/a1A+Z1jcbHUWgO1ptz6eYB0abSuso0X+oYQRnrEv4hoj2zV
	kvAgiqeWWw9m1BaWUpKsGMPScn+Uf4eew8YcaRNlWH/eyHNxj0dXF4D543xNNASM2y26oNpq2m1
	BWU/F26+nDHfsER/n7lDZo9M+QqNo5/c=
X-Gm-Gg: AYBFou1fRrysyOQ9G8XDAG6GzoV47I1o/3pQaL3LTp+xX5PAUbDRAhuGEli1trQWczV
	6m8txsjhWDnHNvJ/RFOku8chvt4JkO1jBbhh6vDY4ezKp7w31R5nzB1UO6WuRMN+dvAILl35fla
	ziRn6/VcQHEjxaP/uJFlYrzg20+8rhGpETqYB1e/nJluGrlTeXvpEpzRQ4Nq69amjk7nJskhz/C
	vrhN7eaBnzZ0U9K6Tj6P+Esit8WG35qsRlChu1tvgYWKyDFfhag0WEvK91iaX15JenkSSrzmFZt
	BXxaPereg9iwJf5YbCj3tAYuGNGkUxc39PxlbUjBs6ogFhz1f6oS+zLdKfZgicNrWqwrv+C/7eC
	uZO+rvq4wLLV+
X-Received: by 2002:a05:701b:2506:b0:14d:ef19:246f with SMTP id
 a92af1059eb24-151c425f5e8mr2955545c88.45.1791023416729; Sat, 03 Oct 2026
 03:30:16 -0700 (PDT)
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
References: <ar1xOV3x9ZMGx9XY@MacBookPro> <20261001060131.51103-1-l3b2w1@gmail.com>
 <ar_VWGhC1O6-4w0a@XiangdeMacBook-Pro.local>
In-Reply-To: <ar_VWGhC1O6-4w0a@XiangdeMacBook-Pro.local>
From: binglei wang <l3b2w1@gmail.com>
Date: Sat, 3 Oct 2026 18:30:04 +0800
X-Gm-Features: AclHuK_LxsbsKKpjJ7YEr_1aJWjHRX_PDMRNTW2QY9TLuY_nPhyJ5ArgFbn6088
Message-ID: <CAJ3C4KxhLQd+pOupWY+kbGerBpZM8nndKnZDGfv5oHw4Hw-1Aw@mail.gmail.com>
Subject: Re: [PATCH v2] erofs: fix folio reuse from a different address_space
 in erofs_bread()
To: Binglei Wang <l3b2w1@gmail.com>, xiang@kernel.org, chao@kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, happy National Day.

Gao Xiang <xiang@kernel.org> =E4=BA=8E2026=E5=B9=B410=E6=9C=883=E6=97=A5=E5=
=91=A8=E5=85=AD 00:01=E5=86=99=E9=81=93=EF=BC=9A


>
> On Thu, Oct 01, 2026 at 02:01:31PM +0800, Binglei Wang wrote:
> > erofs_bread() reuses a cached folio on page index match without
> > checking folio->mapping.
> >
> > xattr.c calls erofs_init_metabuf() twice on the same buffer without
> > erofs_put_metabuf(); the two in_metabox sources differ, so buf->mapping
> > can switch while buf->page still belongs to the old address_space.
> > The next erofs_bread() then reads the wrong mapping, dropping shared
> > xattrs with METABOX.
> >
> > We require folio->mapping =3D=3D buf->mapping in the reuse check; other=
wise
> > drop the cached folio and re-read via the slow path.
> >
> > Fixes: 414091322c63 ("erofs: implement metadata compression")
> > Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> > Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
>
> I applied this patch with the updated subject:
>
> erofs: fix xattrs handling when metadata compression is used
>
> Reviewed-by: Gao Xiang <xiang@kernel.org>
>
> Thanks,
> Gao Xiang

