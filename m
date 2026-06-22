Return-Path: <linux-erofs+bounces-3723-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20805CD98F2
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 21:52:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkhk84DFJz2yVd;
	Tue, 23 Jun 2026 07:52:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::331" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782165120;
	cv=pass; b=YtQ27bpcSEMSU3j8VXxF6m2Kj1MwR15EVz2+nBEUOXCxWD483RJsGyyDXDDEn0VcKBqLw0G7BZxt8OukPLxwVK1QhXWMg0WSZAZxV+Mv1xJlNF8wdVYme/5lNoordwgYNRZTcB/fbQ+cujeJny0lLn4j1PdC2u+b6Hx5As69aHiC/H1CqoX/4p7cL8hjKCr/8I4EEJ7dyoQdPQaIscEhqX5PzC5FdJpM6matiTjzq0zc0kSGyUyqN8MBfDBXeGX1NgAv61HrErjBjg2R/1auWrk+xUNe+KUA8k15rGU7zAScR7W1ONxsqKzvgvQ7tOFoWIalM8S8OASNbaoWKsO9Gg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782165120; c=relaxed/relaxed;
	bh=xjEUxqC8qO1qlPJz0zZDAHSSpl23PeHKm/vTJBwS5AQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K2hXwDhMGgBGDq9nKbtLNqwDrIbaqBeRFlWEvZozVQXYn0/vaUBfMhSoevSNo0WFKEprYM6OeoCcQfzy40eb1r9m7T7YsXPz8tk5P444X6WUEfQiFyy6/SBtMthRT8yP5/kmZo+i13bJQxGuivQD9ODd6Ie3K2wbZsK0JmL0laSxjcwn1imrtjSV0TwV2Yisdm2TdHkLGXmLK5ja7JesmcFa1bI7slT/z/DAxQ3FuFXf60eS2mEcZMVlXZa+C1xPJcGeNR0YIU9FkFC9XWMC0tVcJdfWgb9W6Ymkxu3Kc4gFJi9sMsFZcH2TtyyQTjZpl3A5couOkmY1ijGWHqhxpw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W4eyUtnJ; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=joannelkoong@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W4eyUtnJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=joannelkoong@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkhk65rytz2xnH
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 07:51:57 +1000 (AEST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-490b613a17bso40716775e9.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 14:51:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782165109; cv=none;
        d=google.com; s=arc-20240605;
        b=InMxl85MX1G3BcyzqfU1MmJwagqrGsE0roZPpPZa/CuxjMMDm4Vq9syLR7AjI1QmsT
         xp9M6VeK6DteWriirh5yrmFb6pqp7yMYuW9SVqnbUOOtcpkYEfIJpm5iJXq0Sp7DTBoz
         LlsJsE0QPrGhwhV7LBus5XvQFrnmvtHGbJdkr7yH8u7hNgkkWo9uRobuvVeudWJiNjRQ
         EUagNT2+EkOEqj5NWAESCdQaRTU4WxH2iBk+eHIfmti2k1RjwRtntZ7ZLZdmEyR/Gc2q
         WbcDPEIWy4IUsEt7d+q6EzVV1kLQdN7YklnGvIcH1T6JN2Pe3Tv+Sn8zkqe901ZVvcAE
         zZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xjEUxqC8qO1qlPJz0zZDAHSSpl23PeHKm/vTJBwS5AQ=;
        fh=uD+UfJ4AogOko9OErPd3AdeJ4TPg1AsIE6Y9nBaTuog=;
        b=UBhUJHaL0vgko4NpGFoepp1AQ49uK7A74tDZ38Mc84hRqclQEYwJO8BwKU4t3DqHq7
         /T6MLgMNm0oavddj/9WjBe0tAjLPQpOVRz5mv4FfaWY9VdK2EKDuQgxh1G2JvUCts4D8
         WqsVgTk/ML5+3I0oOntxC7y/IByUhST9a0DSL3MvFWka6cZ1RZStHKPfZHMtX9z9OJws
         9XjcAcoazCqc8kMl9JsfYCAcQJIjbgVm94Vh6UbsArIWoeEDQhqxVkOEchRIEc+Ycvoy
         3dq6+2cxQgZTdn7/TtG7AEQq2GHoy7zXiOfFvoxfXnnNwsNCawE6e5c3HSiyGcB3zLoY
         0qrg==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782165109; x=1782769909; darn=lists.ozlabs.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjEUxqC8qO1qlPJz0zZDAHSSpl23PeHKm/vTJBwS5AQ=;
        b=W4eyUtnJWkU/hSz5QCZQD9Qw07cSH19UMUpix5v3j1tovEPOwM5/PjtNprz7RBHpQF
         LaXXDDP8JeliO56OegFMwhRzAAnKe745JIsnm7XXixoXnjZBq+sQ0QYRLOqdeiA9n0Y0
         sd1vXHPKJR2Nejdwv4U5Q7moQGcafo2xrNwFr43Uw9GWaie/2ZHcCKH4tB77sBL5ZOjb
         IWIBhagTQs01pgF/wKVxTppgGQ6tS2WxT7KqsV0InCuvER1W8uUroRajLu+FddtkMk0y
         cLe6Vgorx7tfGI7KXhg6zQWp7lXFCkR6TKZIc4j1nut3G+zgkX4KpdGXBeLxIFSUFJ8Y
         2p2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782165109; x=1782769909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xjEUxqC8qO1qlPJz0zZDAHSSpl23PeHKm/vTJBwS5AQ=;
        b=iJnW1ajtTKcIlZAv55goae2GgBezPQadLa5QLyTSybVQRynA/Tlv24U2FSF0+6AXJu
         qVBgXMDmnpTz9VQXg3b5HSnDYKD2u3E/4P/BxW3pkZ7hvCjkpcChPrR8w6SpOO0oZ/vr
         rlQftM8R1rCnPSfIp8IkR219vMBIoVcyDg10TW4M1X2HFjcdi43Fw/KuhcpSfu2flCOp
         BHv2HUmW85m8BGc/dTEN0b914zJ2swoXUoOEAJR0+0FWCDoxAhreW5SZJHSxwT+4ch2M
         41SfqkMG+lCcj3qKzdIh5+74XKhNmdHZczh99IEjuYpvUa5twrWC5Pk/kEPmvbT9GUpn
         O39A==
X-Forwarded-Encrypted: i=1; AFNElJ+/zU2s1qK5pvX7gIrmH94We0QxvoPe6A1Y9O91QJ4sMRp73moiemplpcAnIiFij/Vus8WBk8hcOXXTjQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxenbfwCEjOlMCw1WnHUXdad8JPx/p15nNdkQ+R6C/FPlH9BL8c
	4MBC1FnssPAPuHbX08Dtzt5xvOzwD7NxlEAr5QCMmHEHPdUbFdvKxUFL/vmPEV7yRgCfnq23F4s
	O5hqKkn4868J46QlucynoSrp7FIZg4NI=
X-Gm-Gg: AfdE7cmDMy61LAzFNELgQQ0CAWTQApRyulATgYEKwpvnteagW5koZkyZ4otNuSD+TtA
	pb6mxOEinP7U4cmbgUgTYoi1J0wOzJHEQu/8vQDcd/0EaZcHquVeWeuzY6nbJLX5RLKuA9ce04I
	4hMX4IxNwR3fPW+3BJnKFOjXPXw2UOSAQZXK4ugTX7iYJtlaLs6XT8+Kl1+lWdTSWXaE5pML9Rg
	JJ1goiOWLmF9JZ2mYqgxbuQwm3gEf2C81Hb2Ehw/9KryXRkt/ent5o3dvdUsK5eKthjdfnkE0gY
	EUdLmu2cseiQnDNptYDIxvAIXV79BTiWUTcJvojEKA2EAQbRm+es
X-Received: by 2002:a05:600c:3f14:b0:490:b446:fb8 with SMTP id
 5b1f17b1804b1-4924908ac6cmr166056525e9.11.1782165109012; Mon, 22 Jun 2026
 14:51:49 -0700 (PDT)
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
References: <20260619050105.439956-1-hch@lst.de> <20260619050105.439956-2-hch@lst.de>
In-Reply-To: <20260619050105.439956-2-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 22 Jun 2026 14:51:36 -0700
X-Gm-Features: AVVi8CevIgfNYxQYNyFNPu8nm9hh_BhFChXmfrfRf0pPdEn4KUuqrVDih803y8Q
Message-ID: <CAJnrk1ad7Wxr9CB4P1=VZPUS_BRmHTTmRVXVgRjM628iFCZh0w@mail.gmail.com>
Subject: Re: [PATCH] iomap: submit read bio after each extent
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>, 
	Yifan Zhao <zhaoyifan28@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 18, 2026 at 10:01=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Currently the iomap buffered read path tries to build up read context
> (i.e. bios for the typical block based case) over multiple iomaps as
> long as the sector matches.  This does not take into account files
> that can map to multiple different devices.  While this could be fixed
> by a bdev check in iomap_bio_read_folio_range, the building up of I/O
> over iomaps actually was a problem for the not yet merged ext2 iomap
> port, as that does want to send out I/O at the end of an indirect
> block mapped range.
>
> So instead of adding more checks move over to a model where a bio
> only spans a single iomap.  File systems can still create iomap
> that span more than an extent if they want to build larger I/O.
>
> Reported-by: Kelu Ye <yekelu1@huawei.com>
> Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/buffered-io.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 8d4806dc46d4..7449cfd995d5 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -524,6 +524,14 @@ static void iomap_read_end(struct folio *folio, size=
_t bytes_submitted)
>         }
>  }
>
> +static void iomap_read_submit(struct iomap_iter *iter,
> +               struct iomap_read_folio_ctx *ctx)
> +{
> +       if (ctx->read_ctx && ctx->ops->submit_read)
> +               ctx->ops->submit_read(iter, ctx);
> +       ctx->read_ctx =3D NULL;

Does it make sense to move this line to the bio submit_read callback
instead of unconditionally clearing it here? If we clear it here, I
think this makes read_ctx only able to hold per-mapping state instead
of also being able to hold persistent state across mappings. fuse
currently uses read_ctx to hold per-request state (though this patch
wouldn't break anything since fuse only ever returns one mapping
covering the whole request).

Thanks,
Joanne

