Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58006606A8BC
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VhRlpcFv
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQt8w0SDLz2yqs;
	Fri, 13 Nov 2026 21:02:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::532"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564143;
	cv=none; b=SODjtLj6dREgzuwx+7wATyWmlcMq5/H3tj16mT57GuQ6yIu/qQtbWxvNwqprvkVWM81WRlUM5JI23mTeVCZjucI1SISOctML2y0D4mu//3VhGXfMECZxz5q9h8+dADevkIj+5I6N4uSHWlprLmdAtYFArCFjUdua+4/PQFmo4GZnVTkeEFuEg8NuOcoKQhHZHcS7lCIoWoZh8xXv/wvrXhp+u4eXBfouQio7HMaqVPgo6BX9Lj6ZzGbHKeE/O+qskqirlbL8MKdV8GF5i1pQivtXh4FszdwrgbSHjsI5b/FDL+Qj0PCkmVrF/L/SfjH12ia2obR/lPKFcyF1Zi3nfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564143; c=relaxed/relaxed;
	bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cHSDZqQikkAACCxnesEK48ehkAHEFuhpX9l1PJCHvH6mqvDl9E3fFKTwj4/5IxIVhM3zfhLY9zExMZgBFx7fYekntyIxdoUYgM853OMWcemumDiBJ+RQXiUv9kV0LOMsEx00CuTrneIv162JjrX4BzsixuD9Z+2FDCn5bStmJ1j6xasN/ep78YDANPJKtspeYnSIXlRJxdflF7fkeaSMCV48kGhqa9APe+sfDKUkTNFAaYqoBO5FWdAdcUUVoUT4bxxlNRwsNjxCjW+US7VzOs5Ep95UMadn9+tXWA/9xsBPcp9Ki20Ame+p5PoOO6F7KgSU7F9Z1Ki4a3cSme922w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VhRlpcFv; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::532; helo=mail-ed1-x532.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VhRlpcFv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::532; helo=mail-ed1-x532.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQt8t4Glwz30C6
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:02:21 +1100 (AEDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-6b7bffb5b8fso1233866a12.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564138; x=1795168938; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
        b=VhRlpcFvVbnjOlvsnK5JSDm2hhARLY5vKJaifqRAdV4U7ohU0jJl78Fy/o6RHY/SS/
         WCYGK2Idan4xAAEFuVY5DJE21hh0I037ly75mWToenaF9Dkj4wqU8qYCU0870xwgidVk
         ZNERmUDxzm9hM32Pxilxcv7Ec/Tbmcc+LWzZWcCnbXTNscywC51jpHnnTXV7wnUWJPFN
         3QW+o7FUyBm7fcJWVbnD2thZ2xU2sXZ04zuJaUuIDSB42sdQ9VVUfiHSEbq+onMTbvRu
         sxRuv4U5Q8Z2yVf294W12m+T0isHSgHTM0iOZxtGAUHLcDvcQ3BnS+myoFfUloj7AAMe
         TJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564138; x=1795168938;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
        b=WaTrcZqtMUS+JbPMPzAfUOssP5OdYIAu9Zd2ZMyJvcyk3azNBR+az0QVoRFXs+0rf8
         LgdhU7yBZsZpv44EoUtQatTsPAcRlS0YENTcl2f0pbfRmsjllKmeeFWzM0WW0Vo81Jsf
         PiQvwD1h32E7uw1CS6t/dBQJOJKnqrM/sJPqBwb21MZzkoKLWGGO5bfAd/pYvxsLT8gF
         /HGU+I9p60EE1I1hf93UHkyKe1qOn1Hg7RHDHG/NWJZx4Oy75SWQVyuShBJT0F86Ui4o
         5h30wzKB/4uQSivEj1rTWLUt04WZs2M5XZuuVdkzthYeEvG+Q2Qn3C9GK3TATNf9vHD8
         oalQ==
X-Forwarded-Encrypted: i=1; AL+hErHHdzMQpi2mkkKI6ODoDcyOkRAeOtc4NtYTTcrQGjhhVcPZAE8QoiLvoGP5iFhFcPLQ235H5a1HxTb6Dg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/0VF4nHzUMljTjNcXEvgvCzIkmaicKwKXGSbhV8ruZsoTLZlnW
	FY2eiSqtf/MbA+3FzgvQQnvZ/MWOdxE4nBDXuU5z9be3Nndmhk1q73oHyxdVKL5uni9F
X-Gm-Gg: AYBFou3AhwZ/Y+cL5BfiaP1NulW8kuZ++Qf3Xp/HndN4VmPK8uhGs8FKFAnVoTHKegg
	wXEzRy1Q1iyiwud4bSvqEYj3X9PrgVO9h877xmuLvcLSgWYQt/WztaI0m2px1Vs2YE647/qov7e
	Wu/sYxIl11++eSGCdrfz4P/+6byhi3nswjr+eNLgrDsQnbV85dAKnJr174VflzN7ZMUQTlaRqBC
	hhGzvw2ke013rbl52azyBb2+bjxUqgn8vUxstiWCqomDsSYkvqySKPBpvm7K/93EGr735s4J3zH
	H4nIinjLC7V7yMcRzt6lwzvgGt/Rv5Muaqo9xbZk83ZcJq3hfpHcido4oSiq9oIXlDQmBjfaqun
	c9MqnUXi/YYOuDhakyua50wpYYK8PxxHoj7IcPBQWRhVuy/h2Gi1rBtdtZ/zA4JYxl6+fa2oL2x
	arsywlUvBfOL877mUEmBAHf84lGSg+dasllQvbVkMHYeFeo+lmAVITmgm55NFb8e3GXk2ecG54f
	FfB71Cf6pkf/SEpYfT1ZEBkJoQXF05vt4ZrJwP5+6cM/LfldR7pNBY18jgCpE2xOotjXYuMl1hB
	YvRT+p+lo6YV4Gql6G8eSAcPAbLK+LQPnw3HRFUGOiCnmpNRlWTRgIHo+N8i8iE=
X-Received: by 2002:a05:6402:c4e1:10b0:6b6:eefc:ae7a with SMTP id 4fb4d7f45d1cf-6b7c088f8ecmr1236733a12.4.1794564138223;
        Fri, 13 Nov 2026 02:02:18 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23c672asm734155a12.15.2026.11.13.02.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:17 -0800 (PST)
Message-ID: <f4ce8239f22046e90cf4807853282a570c73707a.camel@amutable.com>
Subject: Re: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
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
Date: Fri, 13 Nov 2026 11:02:15 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
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
> Currently, there's no way to tell whether the files of a filesystem
> store data or whether they are kernel interfaces. Files on pseudo
> filesystems such as procfs or sysfs generate their contents when
> they're
> read and writes to them are commands to the kernel.
>=20
> But a few places in the kernel take an arbitrary file and use it as
> storage: loop, zloop, the nvme target's file backend, the scsi
> target's
> fileio backend, fuse passthrough, the usb mass storage gadget and
> erofs
> file-backed mounts. At most they check the file type and whether the
> file implements ->read_iter() and ->write_iter(). That's not enough.
> kernfs provides both for every sysfs attribute for example.
>=20
> Add SB_I_PSEUDO so a filesystem can state that its regular files are
> kernel interfaces and must not be used as storage.
>=20
> Pseudo filesystems also never hold executables or device nodes. But
> currently each of them decides on its own whether to raise
> SB_I_NOEXEC
> and SB_I_NODEV. Some do, most don't. Add fc_init_pseudo() as the
> common
> initialization point for all pseudo filesystems that raises all three
> flags and switch init_pseudo() over to it. The following patches
> convert the mountable pseudo filesystems.
>=20
> Nothing checks SB_I_PSEUDO yet so no functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/libfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +=
-
> =C2=A0include/linux/fs/super_types.h |=C2=A0 1 +
> =C2=A0include/linux/pseudo_fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 ++++++=
+++++
> =C2=A03 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 96a6e9b1535f..8c8789489fdf 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -735,7 +735,7 @@ struct pseudo_fs_context *init_pseudo(struct
> fs_context *fc,
> =C2=A0		fc->fs_private =3D ctx;
> =C2=A0		fc->ops =3D &pseudo_fs_context_ops;
> =C2=A0		fc->sb_flags |=3D SB_NOUSER;
> -		fc->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +		fc_init_pseudo(fc);
> =C2=A0		fc->global =3D true;
> =C2=A0	}
> =C2=A0	return ctx;
> diff --git a/include/linux/fs/super_types.h
> b/include/linux/fs/super_types.h
> index 72f4288e16c5..472200bdf081 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
> =C2=A0#define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on
> this superblock */
> =C2=A0#define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this
> superblock */
> =C2=A0#define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee
> data persistence on sync */
> +#define SB_I_PSEUDO	0x00010000	/* regular files are kernel
> interfaces, not storage */
> =C2=A0
> =C2=A0#endif /* _LINUX_FS_SUPER_TYPES_H */
> diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
> index a651e60d9410..0ca408aa60af 100644
> --- a/include/linux/pseudo_fs.h
> +++ b/include/linux/pseudo_fs.h
> @@ -2,6 +2,7 @@
> =C2=A0#define __LINUX_PSEUDO_FS__
> =C2=A0
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/fs/super_types.h>
> =C2=A0
> =C2=A0struct pseudo_fs_context {
> =C2=A0	const struct super_operations *ops;
> @@ -15,4 +16,14 @@ struct pseudo_fs_context {
> =C2=A0struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long magic);
> =C2=A0
> +/*
> + * Common initialization for all pseudo filesystems, mountable or
> not. Their
> + * regular files are kernel interfaces. They don't store data and
> pseudo
> + * filesystems never hold executables or device nodes.
> + */
> +static inline void fc_init_pseudo(struct fs_context *fc)
> +{
> +	fc->s_iflags |=3D SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
> +}
> +
> =C2=A0#endif

