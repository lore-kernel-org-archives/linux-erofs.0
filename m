Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9451060A382D
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DOIXzfRw
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQt9r2C3Zz30MZ;
	Fri, 13 Nov 2026 21:03:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::62a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564192;
	cv=none; b=ClM4HeEGvOrfjAUOrq8HcYGW+asfiW9FpMAzvR9RdxllUtPJbKgE7nvGIOz3FJOIzUUw+tCYPMAPekAN7hbFbsMxC+ZEhIo45p0qnK48FdKUysnWE4Bdxnyk4JO2kJYwEoPPMjsRh+R1gAo82bANH2LazNnYGnriINLwMlaTthu+Nh7mRheT+VqmuS8fJOsbPkVnhI7W6YZfd3V7MS8XmQT3AEVNFYe/9LB+OCAJNdVBQG371RsWqZ2xeU8ws6Qje/L3nKBygcJGyVvVLQiKG2qbPcnQpQsBkFJwXZB0XFflaRhePh90yEqcmsuvMajfLiqDqgHxNj/L+UxlXCjDmw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564192; c=relaxed/relaxed;
	bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aZ8O0AjNWAz9TEELgoAHY/70NigUEPgnE0KIgpbmndwtqhOp2ZG1bf+0AeZvfvubC1rjlC6G5ue3aUBpX6R7opzHUhpdxzCwAdO6FwIRU5h6NJ5ih02OiMwlm8nQ5H10tNIjJjm2qtYuFPDCHb11Ojmz8F8LkAyzyJwYvTTw/tp7AP7X5i+1ywn365SDyMhAIr49zUhoM3NOD/tvzgyCTT5CPHe5/lVWkH/5PB1wuG4GZ28hzy66/yrLMQLP1qauEo3yhq8AZ4iKIf4Dye1qAQXf7uixId/awyxzHZsJNiayBI5PBIozd1DF1kqjbwDwcXuQTmEbJAzJk53M5aF8Ug==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DOIXzfRw; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::62a; helo=mail-ej1-x62a.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DOIXzfRw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::62a; helo=mail-ej1-x62a.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQt9q2Dt4z3bYf
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:03:11 +1100 (AEDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-c50a4a2132cso50319566b.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564188; x=1795168988; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=DOIXzfRwl0Q21F6dt3LgSjUI7ZmnP1GPqj8LbCTG5GxgujfntmK1kYBP4JHtOe2TuK
         lwfsiWdFlkLGJkUBkmOJcXXY+arvghs/8ebJfxIM4OMLMbG/npq2UQ6PWbhHxrnz9YQ0
         YbMfp1UJ+xl4pgE0W1ArQdPMSiQ8qPbJJDTxypunOaI7XwRd+EIEDhhVjUy01nkhvEmT
         XvbD4hsHnEgbGlTMEnBiBQTasDquNXz/W1LpVaacAtWXdqyRNssvK7uA56L7NpNJ5KRa
         jawkuZlGUT2L90j2U1Y0MWz6LpyV+pdDDLxXUWC79C38s0zraG+jOsZ6FM1Crr3yvZqB
         qmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564188; x=1795168988;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=0Q3L2RBbEl7/69xl9i8GpQA7s7Q6mm5dS/NY9KUisRQvqPyNUKL18GzuqxsnBHZHea
         9mcr1tc+NIo0fJOWScblTrd8i+wRj3fNXaRIvDQz9Xc9zEi/bl+vLNyjK9lHlXXLH4Yv
         CvdCnh0N5VFLkwa3EK4jtyztwmoauQz+cueosiw7uCaJc2T6Op87N8WJuhaa3kR91QVd
         MBBRwrdhAbFSE/IJFSAgwufu9maFnOg9KWXRpymIRbYiZQ3uDZ0f22SNfQx97HJQUt6D
         ZHdolIk8qss0C739Kwj0qfBEj1INzY43gmr4pubO0jevsunyPnM6gzqCaGRRnv4tu5he
         GKHQ==
X-Forwarded-Encrypted: i=1; AL+hErEyoHRqMA8mhAN7uuyaAEzWpbeCIvD89hfV5r/7pi6NnEWUMEAEbpBzT52oNdGE11vRZYSyOxVpIaTF0A==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z9G1CLaHrG6oipNkpF3cZwHFO4ks18A/bnKxUj8lUz8oRNSRAKC
	yGTt+9BDg4mO670/OoWWKgXqOY7Z+rawNCfZHSIk1A9lGZpFvzd/I1iAqdftjnmoW9YQ
X-Gm-Gg: AYBFou141xrht8M7QmunpU+z1DdmB2u7Tm1GcKDJC8jk169E0gqzs/STpcCcfPAb5gZ
	Puc22+SifTc22z6RMx5/UlmUEFqX6NSp679JGO80YNHJ1s3WLC5KZhrf6CTWDqqeEizTJmtfTUF
	MlkPmTTZ+TYavmN/BDXoOx4gqnWXWzFuFAZ/bcczyV8WFL1j6HenX716m1ctKTnm6U0UI/FNOEt
	a9yWHxruni3OYCQKY+sjT3OhtT0XTNlpPfemjEb4nQIDxETTQMC1WVqvrfaz4vg8LcxB83smcKc
	z/vswlOCmkHGdlCTgv6DIvAWxlOZwHqOm7RkhQSi468tWSnWtHFoORuCbg6iEvCt/QGH4qGCTT2
	uy0X+LjiAEkjwsG2yj4O7dyHe6Dkm03TFXvRtgPRE+/hIXGi83lWsukagqrPxwgV0rjVgp0v/+s
	epBATwiVFtwKM8XxncRygla6ERiOgkRDo6ZUN9qoaULw6cpZF42hDgi2F1M8DKV+mMmMOnPOqVM
	EE/Q6bPBMMAl94Pk2rAVZrANqMPg+ijZQm4ujJoq2HTe7yHs5mYR6shw/oe46P7TkyFtxYtKZlR
	scCMEwQYo32IQainfl6bUSYA65YFADMO3ZgXAVdn1J7oxK6K
X-Received: by 2002:a17:907:d12:b0:c4c:b4fe:c9e8 with SMTP id a640c23a62f3a-c50963dbee5mr161853166b.38.1794564187801;
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b3dbaesm74933966b.32.2026.11.13.02.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Message-ID: <fffc4f7f87fd5f03d1ef409df76f71ddad552213.camel@amutable.com>
Subject: Re: [PATCH RFC 07/41] binfmt_misc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:05 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
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
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize binfmt_misc as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/binfmt_misc.c | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d945b4f6e158..7dc233becd98 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -22,6 +22,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/kstrtox.h>
> =C2=A0#include <linux/limits.h>
> @@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	if (user_ns !=3D current_user_ns())
> =C2=A0		return -EINVAL;
> =C2=A0
> -	/* Never exec off this instance and never let anything stack
> on it. */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +	/* Never let anything stack on this instance. */
> =C2=A0	sb->s_stack_depth =3D FILESYSTEM_MAX_STACK_DEPTH;
> =C2=A0
> =C2=A0	/*
> @@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
> =C2=A0
> =C2=A0static int bm_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bm_context_ops;
> =C2=A0	return 0;
> =C2=A0}

