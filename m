Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E5E60A261A
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DZiKfUmH
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtB82b8yz3bbf;
	Fri, 13 Nov 2026 21:03:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::52b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564208;
	cv=none; b=KniFXuJZNpDO4noK9BPXncGZ6EgaifKoAu58iIcbHJCMqrq+8gPolrAAMaDpBhiXelWSgkGW3YvKnWw1tgxx6YVfOBaALzJUap+qyLJxcbT4x/Ttee9Z+m+yRLdNLV6djJsKjsQpw1Sr87WibYyGhWLJchLYai1+0I7LXgwO6DBI45gcyqz9OhPIvaWeW3jMssabRZ8OpmQg4qAzrJMz4NVUBobU3/D+3WKSGNTTF//3Jr1wpvRVkzyQHHP/CJVTA/I+ojsPbt8QqCD1Ni2zmfOQnUjp2KEG9pFMGV7hHVkfRvoz3K9ntDcD1Tni2pEAMU4a11IodImDJYft8vwbkw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564208; c=relaxed/relaxed;
	bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HbLq8w3VKmvgOmipQPwJIkQH7GIGayNtkCrYlrpaDTUUPcYb8JfkYmfywLL26GVAOV0HtZn5B4pBGLSInQd3YSgg4vX3sdkb+/0R2PmEy2lHAltOHN8UZa4Wi03V2YCVSCiHMcelfm4KP4jhScgO7IRa32QomkDX3nyAjlLOFg0vt6tkvB3kFbnfZfsS6FcnO3Paq/2SXcrTh2TT54tcQmwuzNt5zPE6VFdb052huO7bArqb2GeKKUami5bb8kbxPOWVQXEKG34L5DPvW3ArLRWmhUHS4MX0CLgvvqN0MPnVTjB9yiTnADLzagd6+7AP26xIdlfuyOFE8EvrteS98g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DZiKfUmH; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::52b; helo=mail-ed1-x52b.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DZiKfUmH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::52b; helo=mail-ed1-x52b.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtB73DZtz3bb6
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:03:27 +1100 (AEDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-6b75712fb57so1193804a12.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564204; x=1795169004; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=DZiKfUmHzKVZkDukmHBaewFRx/yV8JSa/Wis3mf9MqUW4XPp0hSiuxbP5KW1XnHuIK
         ly6RJ9nolk1gLxI9LpSiXLoKOeE0IZyEkwGVPbGqIf5caw4GgYdUSYTAsaxxtYESneaY
         8BmxtzU9rxLK+O8Tjww5tLtA5MgUgg/c4Uuf4xQAsgp9cg/GjNhMD0RdEPkfkqwG2xCK
         l2AxTcFJYq6n42+mdNL0Y7iC+3Cj7n0F5IODdY/S71hJU95FfeGiEpOpMuCGQdHtZL1w
         YyNJj1zQ1WSkaBXOP4atvimSPa+umUg3b/BKF0qG5UU2UFy+DOhnuGI3zPAtnB4yBb44
         0Shg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564204; x=1795169004;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=G6NoILhv76v+VPvtgI4Dp4GybA1sShVM8o7LDRQ0b6u7AcXvdn8l3+Cw557vUaccD/
         p5aixYdigbjWDiLfvzTrG+TJBv+wBNGwgR2Z5uCkLebp06F7MDec+rKR/WlM2CplTKz1
         yor5RmtsW23qsmXgEn5Z2OXpikfkXj6Mkwz4c10qlz9U05f4ov4mLte36fNf5E7INap0
         3JAojhcokwyHRSMz+1Ahp/kTZuOZiadQmeQ98YYS8luAIKk2DJOFjhRng2tk1AkiDHOc
         RtPg+0SCRD3QVe78M6V6v50HpvV4vy1SmYryyLZ25Y5K9fHu23WnByqpy3M9rQhIpVg8
         +d4Q==
X-Forwarded-Encrypted: i=1; AL+hErElADkZh4d7GFATnGV8sVQlRXYgnsN6rscTfCD6a9uip2iLy1MaRBsZvYHpdDoorgl29kZeiqUqfy+zOQ==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8A4aym0Y2Lv2RsKRUUcQzeMDj+obcDLwk6ml6IYVb4dKql2ZLX
	ZoZoNDh42/XY9UreSwmCKHOzHHJwhqljFIuXVYSeeofsw0ECoSBzhHDsASjtfgFpvDbY
X-Gm-Gg: AYBFou3PKvZ5K3DweU/vQi0OKKABxASTNf795leZ8Vfiji8Rvsn5ZSLVyv42vMmRpOt
	pZ6E4V3vdsle+WGmAK0vXG2yhYp23ZPfu6KjeEZJkGx5RUcwmw3fPH32Ac3trSwkvQz0Ks86CYY
	pb4kh58tv2SoCaFKp3xvZQlh6B0E17UP6Jfa1NRfYYZfHOCT6vGxWxXTqgzZ4l0/zIG30auiaip
	e7s57aew+npVyW3l6G9ztdD/MTsK3nlEyUxUdutCZvJVN2MTj37niaRRmZrcl4/UsIz1UWW4V0h
	QAGWLBp7ikwIPiXcQv9WkEE0TC6dyKfXnUZtuy07uLt4BgZpdbb4htLEy29j4fqRq2+VEKpq7pP
	LVVb+lyovp5fCBnBwatQVCxnerxbUiSA5giDAeg0xvnooBF6nyJVPPbJIn7O4XgdzZ1oau7ni71
	lgn2dQpMiu0zEWepduyXL2pIEZ822hH2GaHvOr3ec1JqMSZPryPHFCTK811YAvt/LJ0/ro8ViBm
	okZdEgbe5zCqUQg+EtFIHqgKRjUTi3NtdHrPvu/hYgL4zdX5KcmSJaRVFwe2Sl2c634BoIbs49a
	BUcde2YUW4WhR8kq5dUlIbrUNF08eKYLBijE9e8VmDbvkeWAyAVd+q5EbJXjr48=
X-Received: by 2002:a05:6402:270d:b0:6b7:d479:654a with SMTP id 4fb4d7f45d1cf-6b7d47965e6mr298323a12.36.1794564203570;
        Fri, 13 Nov 2026 02:03:23 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c236124esm752333a12.6.2026.11.13.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:22 -0800 (PST)
Message-ID: <e5f36cc53b733383ac1d1f1e8c03f73091595edf.camel@amutable.com>
Subject: Re: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:20 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
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
> Initialize mqueue as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0ipc/mqueue.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 322c3dd98c44..8bbe32d0881f 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/sysctl.h>
> =C2=A0#include <linux/poll.h>
> @@ -405,7 +406,6 @@ static int mqueue_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	struct inode *inode;
> =C2=A0	struct ipc_namespace *ns =3D sb->s_fs_info;
> =C2=A0
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	sb->s_blocksize =3D PAGE_SIZE;
> =C2=A0	sb->s_blocksize_bits =3D PAGE_SHIFT;
> =C2=A0	sb->s_magic =3D MQUEUE_MAGIC;
> @@ -457,6 +457,7 @@ static int mqueue_init_fs_context(struct
> fs_context *fc)
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(ctx->ipc_ns->user_ns);
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &mqueue_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

