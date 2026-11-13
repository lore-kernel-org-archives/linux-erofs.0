Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3124606A894
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=C58uwuRA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtVr32HXz3bhH;
	Fri, 13 Nov 2026 21:17:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794565076;
	cv=none; b=IE8KYdmeLKeRUN5ELZyMG/5pXkn58pnz6n9axtOXf7UFo/bWdnwq6AZA7cxUHIJV/+HaLFeaZ8/7l5ih8S/mzArVsjnf2zj3yNlsgNQJ8YT/ZF4Cn35Nqk/y/NoC8z81hxCk6WgZ7/U4EImHOqpBzS6xnOlh/3InBGb3rzTczC+PfBgXzbqZLm1R3PnUGoizcO5pItdbmu63IjF5jIeOd7HVwg5VH9LMz1z4worNKUOBlzyNVN1cwCkrpFvdI4pSVxXS8ZZOrnIpbiUTowdcjfcGZ1Qd+rLBmv/psmS03cjBfE1K7c9hZ7hdlbYg27jRuzhgb6+ZjajskCARWs0Owg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794565076; c=relaxed/relaxed;
	bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FmIZ/90KqtzXXXXknImpJKavwSkYSi9/ewtWwZXFbH08PDUPvJMi7tgVsjEfAoiZUgy4oz++6m0jB7rHFMuDNmwqLbFmEJu3K5kTYPxUUznLkosqDKhpoAiAH2ve5t58RxLOihgGJFFxX2ujEKEE7fHdvxrKQpZcl1M7msjm2GcPisnOxHNcz1MQlmzSsTlG+JvvuKc1jQ0NAoMj+vfTx3tQBqkE5Af2/zfvmF5IpgHyvDa0g/roRc8OWb2dsxUd6qyHbNapSORWOIZemaUH1E08RPjSp4R7Z5I8jCsZGZEbm7da1LIy3oJ+9bCxCOANjFpoT5oqX+mtoSvswGuewQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=C58uwuRA; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=C58uwuRA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtVq23hdz3bgx
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:17:54 +1100 (AEDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso10701245e9.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565072; x=1795169872; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=C58uwuRALK00Efbqi1lkevcopXsljKIGkylbObObEvCAYKV3AZJy9c9bZwaJZb87SX
         3jYFix8xNSJ7C2gp12IdeDAOOvAMMX33hbdJSsX2CePZxf6J3sv8tIRvt2V47VNZmtMT
         3JKBzeaRnF0rsfmBT2e03P/Wkjw0vcfxpjj6qBNuwQGC7crYBTaDtyTWcLtKjeeVv+gx
         fBznFBoRYPfyke4TD8WEGoPWqn3HvJUDaN/aFPounUZufVyYHvVOAPWU1/d2qOZ648N9
         h59Nzyl4UUBTsIgX5WyFBOAj9P+lrqObpg4C2hc6r3pSaSpKvhUerFiuGIkGdPb+H0zY
         A4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565072; x=1795169872;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=mBunJwWMmUm+7upkDT2qG/BjYsadj1UzAKBRqeve7byOqCfq+3ZE0BcM5n6LGfQEHJ
         NcySP98pz3m4xk5iNsAIIKrBoWZlGXFiZ22vJhLpd/Wg0Rcv8RM6MJFaNU2TA0wau+ue
         N4SrB4gece9kmoYtWIunQ43ANnnJlzTOZrz/mx+hJjNPfJCfPTSft5cR1iCpRNtZw+5f
         0MPLvuMkGxppK+NCYUpQ6o79h5N7gYLg7sehX7bROVbvy7HkgG5VA9PiGqXy8xFDwL0w
         Yp42BI/3FLiWfUbEDAVjxLYBQelQiKx+6sK0u3+d/0CPw9VUa/fxbaUQsrkn9lsJ0M92
         UCRA==
X-Forwarded-Encrypted: i=1; AL+hErEyxWIWI5Am8pIxih5UVUV4j3xehTdBx1ZBzZl07P5cDJITbmnn/kQl5WvxPT7s/DrbjVCZc1fL+H8Mrw==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8lSEdaGAJGUEI38e6bw/CdC9eKymXh/5e0xZ+Kw5Ihf+6Ql0a1
	fwa9dfSCEB2O8VoCmSkJcvH3tplQ27u70upZ0UZi3r6z3BXnkJ/M+08kQfU3RKerA5Nm
X-Gm-Gg: AYBFou2nrik32mJrLQUW+GOcStKgUGxg7NHRl0KQLhtWpdvl9tXXPJ4ry9FssfHbEKX
	aquMjFX1Pvft4etMa1tQ2iw+AfyFkRhIi8HdSRyPIJ7rXbo4gDecJMahEwRbP8TSGGGpVAZnMlW
	ENUg8h6AK61Ogn0A3UPdl8pHl2SyxbvdNcOxD8fPsH0MNp+LcFeq/z1i3MhgbuVIoxfgd4H31z9
	QaqBa2xOdPT4adg7iRaMUObdertIwy0iaQQrpu5Manv0W4ByShkC/qNpZPxbB5lyR/g5TRRrBDe
	TjgNndiyOOZad6E5o7rwct+01eVeuu2J+cwi84odAwImATxObMQrWUwu1rVENwBM+m+Ne3iphGe
	koEllanCnqq25yUxgCnubm/F0DEkjGTiZov8w3POqEx3GLppTSjERJhfsnVysJpz4qk2rAtpsZv
	/uPmjzqQZBhHi49IbYJAQeyEC3MC3w8j7n4KPLOt9XT8iyt/m/NBTS0hISqA8CxyCSRePnK4v9H
	w4Y/MBw3a+I+Adn9zIBCVyBF8GJLOcZEeuzG7X63dcQ8g8msCC84RkaSwyY6kbQvEztkTlmjetT
	0uJkcIp+DV7glyN1CY3TdvWQdj+X9DkHGtKW22fDaSvLN/uJ00LDsbFlayQwgBs=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43851425e9.2.1794565071804;
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c7da37b19sm3937770f8f.5.2026.11.13.02.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Message-ID: <7cde6f3091f9d90593e4a6441723b6b889cc4024.camel@amutable.com>
Subject: Re: [PATCH RFC 35/41] zloop: refuse zone files on pseudo filesystems
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:17:48 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
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
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> zloop opens its zone files by name below the base directory but a
> bind
> mount can put any file there, including a procfs or sysfs file.
> Refuse
> files on pseudo filesystems as zone files just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/zloop.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 65634a39b0bf..dcc06dd47b04 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -1137,6 +1137,11 @@ static int zloop_init_zone(struct zloop_device
> *zlo, struct zloop_options *opts,
> =C2=A0		goto out_fput;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(zone->file)) {
> +		ret =3D -EINVAL;
> +		goto out_fput;
> +	}
> +
> =C2=A0	if (zlo->block_size) {
> =C2=A0		ret =3D zloop_get_block_size(zlo, zone);
> =C2=A0		if (ret)

