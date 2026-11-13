Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0C606A337
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bKhoVhDu
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtBl2vtwz3bb6;
	Fri, 13 Nov 2026 21:03:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::531"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564239;
	cv=none; b=Cl/56LLlkifkWILt0wTh0We87WciccAd/pr4uYQiJj7NixL25Rkpux6O8dNZC8MGdKkZODRSYb+IskoZX/Pq2PQBENN6L4PbNoqx8IFQFuNdkW/cNeUKVOvxfQh1ttOklJXQel+1cd5IF0XuQ7WIXciAi+OoGN+Y6fKbS6fwSxflYJXTPrD9TN+But5YF6LcTDWEEQgY0pPdb5s+03yAm6eYPNFopaemzqvcwb0aQOXtD6D3O9ttxP2tgjR8FFAYYyni7jnOe8HQFVkDvLo93LhPzy65js8SojZyznZBcGmbtLp9p5W8TcJS2lGgo3ypuGdOwH7Qda8z0dS32ue97A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564239; c=relaxed/relaxed;
	bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O/FbwZIlqI4PW+wY9pSaxfrWtyr1gDi8kdDUDdrOdOGvllUrxIvXJpJIcHm4e/xH6LAH7v7rs4lxFRBc28SRrW5q63kr6wankKPB4QslG5TnFXapJzITwlnwEh8g2iUe7o8eF2ChpnkYtl2SWWOfxzQktO8jME2D3MoxUo8ewURa1mTmXPgIQw7e9XbCMPSOUcymgkzijmy8jpt2reiJqg3xc0EtIEsHZ0IXSGgNfXU84G/Q2Zc9n8lv46di1/YZ0wivsIFZYFM/jkrd0WhaXXuY5EjCZMyOajw70BW0jr/JVav5ucH++IMpuJgSSvudTmacZuanxHtcnGFm4IKOPQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bKhoVhDu; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::531; helo=mail-ed1-x531.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bKhoVhDu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::531; helo=mail-ed1-x531.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtBk3fCRz3bbx
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:03:58 +1100 (AEDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-6b429f71dbeso1006338a12.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564235; x=1795169035; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=bKhoVhDu25gXhai0TYaMM0rdwmsYSGJGTM5i2G93kPqxiZUxBCMnLoi8so8Hibx5eD
         ebmPZ/x/Q8xVhw3s1cYhB/WcEgQ149pZuOJOZDNhLaAmMNVKB2gxyKHveNaIpy+8dsZc
         lXbSBWfkJ2T6gLCRNokolNMDIxlK6ItnxlPzgSaZiqI+CqNyndY8ncKVeq6ZHclzNxga
         1l6tUW1MC9mOXSTR6gT5fuiZzaWqODwk5C31SrPEE93wHHP3afGZGhSBuCbYWU6xrUfS
         gfe81e+2wQTQBPyq3B9XE/Qe8OlksV5pGC3RDb7wZcraxjOLqseC2SZmS3RpVXUQycD+
         F9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564235; x=1795169035;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=j9Nk0IA5tz36yZKIefuAgWW9FYv8MMvl8WXmH+mkeJr9LEvxf95islRL4l+7hwKT4L
         IgPuu+4PeRMAGxV9rHDWxWLHm7MZ+PM5kPNr+hF7xc0DoBdJujGWPj9UfbILOgvQDKqD
         06qzPDWtYvpzkjoAc8DCj533ZRT+Dwq+G5Gz4GFqSgHCs/W9vJEu5jAzNPxd22aMYedr
         hf8sE4GEwCjVSSvTdxleq7mmT0MzGAjyj5318VIAIGaEFut0tSiJDTvYMS2g3URoEh4Y
         4FjWoSvlhtu3u/M/FstoBRTvEEsZr/MMNeE7qb96/ms0hQz4+QbvJEU5eif9V9EnLP69
         sUTg==
X-Forwarded-Encrypted: i=1; AL+hErEsfjSfe+kI+KsPVy7iOiEblhRogqI3yIRyJ4VrVXkzVVbIUXGUU4aZW9OCd8XHzyXvokyomZOL1AT3ow==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8+hdUl+HWn75sstsZrvhYfTdaqy7LcIK/0a+6uD6sCgynHKJjk
	v2wqOfe+dh6HZi+phPwPXzd4vHlziofSBKWV+Xb2AzsrDI55tJ6myVH5x034r3FZKK9F
X-Gm-Gg: AYBFou3xhCKLTt03fMJ43bJvlHYW4QTi6W2zPJZHjl+5MnKGnVuFbjOFf+KLSA/gnsJ
	/cEtKXJkx47KacIOZ1TSTvJWkjQRiMVpwm1YM3w39Xp8fRjlNXCWxgb7DSWY3QiI7hLSzBRanay
	ztXP0psEvvfYxPIkfa5AMYZ3Flwg/x4vXZcX8Ybf2do+y5uEGgmqUXNjo7ifKxY/Ms8BRUwYv/t
	hnOKAPF6nT8r9bfPbdEtMDHcSqGdgixEUhsTp5sFIzHWy6VdyExhrmA2t+3Yg82orvJwHI6XzYf
	KYcFyy0tP2bJWFJg/16Oyt7+1JUv+fqpXUA6aBnC+nqJvuySbrqFxsAlUUzMH+7kPl+bk1yCq5Y
	/LSNFVoNxn2Ichtk6z/N7XH5JVnXmwBL7HgKXOHsYVy9eygA01GVo0K/3vNbWRS8KWoPfoM/LMS
	lLonzKy32ywQENgS80uVI/YTAiOdzeSgkTDGvPrgO5pJWtXq6XFHhsPz0d+ck+1Ndm6Wy2PrF3n
	Sl22kRwWkE729avKK/CacQyezoEPH0gnG75fByPKv7tWl5FwoH9R3mL/1nfV+ahxm09R9czP72s
	eWMSf5fkOUW8sGctdOSDsHwk1uuxWMbe3ojmXSoCQcXQqMkz1ZbpXkWpPPecWmc=
X-Received: by 2002:aa7:d556:0:b0:6b5:96e9:ae97 with SMTP id 4fb4d7f45d1cf-6b7c0ccaafdmr1234919a12.34.1794564235160;
        Fri, 13 Nov 2026 02:03:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23611casm766458a12.9.2026.11.13.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:54 -0800 (PST)
Message-ID: <16dbddeb5cbb9613dc806b43fc681eb26aa3b0dd.camel@amutable.com>
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
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
> Initialize nullfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/nullfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/nullfs.c b/fs/nullfs.c
> index 319c2f5c5a67..2fe24cb97160 100644
> --- a/fs/nullfs.c
> +++ b/fs/nullfs.c
> @@ -2,6 +2,7 @@
> =C2=A0/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/splice.h>
> =C2=A0#include <linux/uio.h>
> @@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	fc->ops		=3D &nullfs_fs_context_ops;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0

