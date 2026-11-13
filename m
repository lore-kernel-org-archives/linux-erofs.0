Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B14160A3806
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HEUZ8uOn
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtMl0NBBz3bf4;
	Fri, 13 Nov 2026 21:11:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564707;
	cv=none; b=nXp4X87skX9HZuGhuI7wwIQRaKUbGE1H5qFBtVhycNHtnrCDVB9T6HNj7c4mYsMDy0BuNTqvnmSfpn50e19JW2dUxk6LG6eM52JzHGKaXRlzDFPudSAWBVsorcOvjPOaOA6SXoX0FqYz+gKjYyuSEuoo08UOIgqpyCGedxVP+/wRJNoGjmJ/+Gl1CDKZD6w1Mar52WG3PFcEht/k5bn1L831XAGW+1zC1EMSUg75yxANuOqRndl95FGDnL/kTolcI8CHV+lDai0cTj3oyRtj2aYhuN8IX08JvfXtwPAJ+3z4xGVPYfZqihkspxzpnGt6f1ApIYG28cOitgvhTAeg3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564707; c=relaxed/relaxed;
	bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M2KRKzKm2KBG+P54D+NR0snj8LjW3AOVsQT/3zE+r+iCSrk2cB0mtwT1SaL7PRJt0XLgVVLu2ph/J75bbEW5oEf8H/bYGfHG69QCCOoKcGVGk4TGOWQ1acs8NbsVGfeT5Mn3xCJwS4bGd1JQSnXESk2SxIqBmv6m3r1QsVUhCydcbIodaxyhilWkvAT261y9UL2iwUm2PSn75+WV+0U1UkSqcHthF5rZWZWH7Lh82LX1IzYaoklO65+ZFCJVFOhMMayVrsN4PVEa8SBwxZ/qUsI0pYOVebSi3VfupUq3DG5eftCPz++bNPIB4iRXO48Kqjfm2wheZDYOyrmrzrGf9w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HEUZ8uOn; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42e; helo=mail-wr1-x42e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HEUZ8uOn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::42e; helo=mail-wr1-x42e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtMk1KVlz3bd0
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:11:46 +1100 (AEDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-48e09aa5264so307487f8f.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564703; x=1795169503; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
        b=HEUZ8uOndbcgGtx7/JlC6TkiVOuc2pKtQUUFRCE1W9Y3Hs9mrw/oRFEdJezDCiAWy2
         LRaitE1nkJDqGR4cfd7TEFgag2jf1WYxZnRcgHsCwqcoEfmvydkah2ooFH0pVuYzuDUt
         CjMYOD+3P+hqXnAKBYwMYL8z3dpvUDc54/1Wun8qCHo8IYuaAQjlbKpCkBhXO8/LqOgE
         TeBlzxpavYs+SWXkzJHqEcMWpS7MnFHbRjFw9LYzwJd4QxHoBUDwrRv8fh4vzaNUmQoe
         ht9ggiT/wxNqoij6zbpByWXBh25ajhxGE7gj0TMnLQrJ0BLeIlDqkx/lNcBh565C2w9w
         XOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564703; x=1795169503;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
        b=GpAnDUfCL3Q4vw5WDfz7qpL5xBfCaDGcegfjpbeF+IoQ3tHUTvOfyScrH86tB38xH6
         L1kBxvcpcwRqg18/AW4oF2JGe6UmVCWixvajOxatd4iHkRxz7awksYV25abuA3nBHfX5
         lGm9gv6NVl3hWPF2zZp5GlxJJmz4LRKBvZui0jRCZsaLSyi9L56UoSKK8OTkkspJM53T
         CRJBXoS6rqT5odZRWb0y8u+lqWwVM+DncuVUWKHykhuTUdzZFz36Dv8YU7ztuMiWBvpj
         a4/JGVOpNsFss20gY+IBuKfVZLk9NBOi57m/osPm3k9EouTfk6dqvJdikhIraEYFOOid
         id3Q==
X-Forwarded-Encrypted: i=1; AL+hErFG8N9bs8hwqavLsFl56QSuNSh/+K6X7x22qRuzeKo2QYEdxe2mYzeJsocWpQwQi0dy9a3EQEXnIDm2PQ==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+2DkoDabg5CJp1equTjd31AK9F4JBnRUrR6siq7IAGohzazScT
	xzjyC0lq+68ggDM7zIR0kl7nuVzZK5ZNmUTRLGf885QlPxqbIABuO1DuibX6Y884Jo0Y
X-Gm-Gg: AYBFou1BmmxL21Pisdf3zeMgMqwHVp3Uete3yZer9eJ3pGYN2UibTkKhdXA2OTihMzB
	/ML2JTc+Ed2sVS8gRAzE4y5SkwyX5wgeQ8vMlXzO/WnMjGzkxNdd+4zJPpj6FzQIdqoZbt4g9hd
	RXwdWQdZcLrfzztgJolDNo+4QYF3OlHCZQ6sVfwvvbUsGJG2yDPmxvWgTBr3db3TKo05pftIkyQ
	mH5pNHGKlvy/XuJHrkcR70L3lISBVQ81z+o02IM5kQt3sUTpg0PA+7Kt9efbgwFpg3E5lvl5rSK
	Rd/qIzfz0Q7HA2UtCqskXaEEIHcx3o+ZSYgP4JnjuvSDk5FlZuTb37QJCwsiN9xmr+vDE74ThIP
	Xsc5cvR/vWX51jTsk5+cidNGeLpVXAEAf7yNjaCIoMrqfljcEgJaXO36B0fGOA++LgiQyX59WVg
	GyJqUNwIiTKQ3PJqhZ0WE5S/J6OeBpe4iu32p8O6MAW/vCkTVHDWS4ZxJy+7JEK63TrkNfkET6X
	1ZeZFmR5HfFUfh4t+XosWSD7WAODXh8N1nTPG6qZL+N+UTfyY/FuQCGaOml/3h7AWAYbR8w1Zwx
	tJE/Z6sjSq1+1jDa7GQyWdSC58tFXtomvSg0KCEBBcD06wVkc0ELGtPFO+171iY=
X-Received: by 2002:a05:6000:2501:b0:488:88ec:59c3 with SMTP id ffacd0b85a97d-49c73259cc3mr5012611f8f.14.1794564703010;
        Fri, 13 Nov 2026 02:11:43 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm4931434f8f.11.2026.11.13.02.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:11:42 -0800 (PST)
Message-ID: <ff6d2a8c8623f5476d5c352dac1ad98ab3da303c.camel@amutable.com>
Subject: Re: [PATCH RFC 18/41] selinux: use fc_init_pseudo() for selinuxfs
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
Date: Fri, 13 Nov 2026 11:11:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
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
> Initialize selinuxfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> SB_I_NOEXEC. selinuxfs never holds executables. SB_I_NOEXEC also
> refuses PROT_EXEC mappings but the status and policy files are only
> ever mapped for reading.
>=20
> But selinuxfs needs device nodes. The kernel replaces file
> descriptors
> with /sys/fs/selinux/null on exec via dentry_open() which doesn't
> care
> about SB_I_NODEV. Android init however opens /sys/fs/selinux/null by
> path as /dev/null doesn't exist yet at that point. So clear
> SB_I_NODEV
> again in sel_fill_super().
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
   I.=20
> ---
> =C2=A0security/selinux/selinuxfs.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/security/selinux/selinuxfs.c
> b/security/selinux/selinuxfs.c
> index 310e19efff1d..d7ae853b6d68 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/vmalloc.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/hex.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/mutex.h>
> @@ -1852,6 +1853,9 @@ static int sel_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0 /* last one */ {"", NULL, 0}
> =C2=A0 };
> =C2=A0
> + /* Android init opens the null device below by path. */
> + sb->s_iflags &=3D ~SB_I_NODEV;
> +
> =C2=A0 ret =3D selinux_fs_info_create(sb);
> =C2=A0 if (ret)
> =C2=A0 goto err;
> @@ -1955,6 +1959,7 @@ static const struct fs_context_operations
> sel_context_ops =3D {
> =C2=A0
> =C2=A0static int sel_init_fs_context(struct fs_context *fc)
> =C2=A0{
> + fc_init_pseudo(fc);
> =C2=A0 fc->ops =3D &sel_context_ops;
> =C2=A0 return 0;
> =C2=A0}

