Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558D6606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 08:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EzHGtbsw
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTHsH0Kr2z2yfS;
	Tue, 17 Nov 2026 19:27:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::335"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794904034;
	cv=none; b=SHjcLwjvQQKqjg4sSKjUPa7J+9mxWlmoz7RhjBUsqezMPQEwOQbYJ/BWCSO3T1fm9a2sqrTG1Edh2lq3OgAMdpVCixiF4J/cBS+GhDPdnIUPlmSoIJcGxB+eozTOghHARx1nZdrx6ive5T4FRes4xzhUNNkg6JydbTQmSKm2R3IZG2tkozEP30cx9wxBEGPtGWx941QqTceaVa2RtJ54PRFUdX4FY3pqp+2R29vSkI8+eMQeNf9auPwmKDJxc+X9hoJc9vgt7pNiw9+AfWDdtTYEsuHcec42OBGrmgF+Smc90ntFNIlQ8BWDAz0/MH/xQPFSWhuxcfarm+2brHCLXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794904034; c=relaxed/relaxed;
	bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QBqs2Fv0DmJbMEF5caAidCNarIkiyjReqi/+b7Q+kqPXXKfcPbqdi7Yc5AIWcp0cVt0QV8no3GUA6hI5M2+NXe+P35Xbmsw2HTgpIK0XT9fyxrMK1hqCW56CRTRzc6UcETds+aMTGNJQo7WNCul9tE/kOo6GL8Ft/g+MlWoYhGQ6lqE9sWA06BH6rWLkIfT41370j7lcec6GgMs24Yqc033PdwN8e4YiOdw1JefEjH0Ix7INSdrBj8ywgRhP4F7KdknGITD14ciU2gVPMI7fiT0INGo9kmDDbKNsArkN5aoZbUk1vbqbFu5oc0ruMHcfubqco0Fof2jx7PRJ59UMZg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EzHGtbsw; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EzHGtbsw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTHsG0h6kz2yYd
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 19:27:13 +1100 (AEDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so21934075e9.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 00:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904030; x=1795508830; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
        b=EzHGtbswIamnLOXfvPcwYvMv7Q4Rzy1RBFSMS/Jp2BpvmL/9QUqtvZ+4EfxZc53qPE
         q9oBCkSVuYoWwwCAb6vAfaPtXgsekttw4t6J4XqrRMhW2Px3HuNGis0/YVCASryVqGoh
         uWLu7SZp1VFetmj7/EDG/Lxjpo6F91AxWvjXt4WzstLJAVNp6GP0a50EoYyymllfOK9w
         iCbaUukIOsuQ431EKix0ckptrFHFPGso2julCV9+bxwlpOzkdseT4X4Vf0UDgvfd8uR/
         KXcnU5721CK+kNPSFjiO16xqb1liHd/iXjZQYKtB8EjIuDvYe+PZSFOvIYQyQoCpgn3n
         tZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904030; x=1795508830;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
        b=k4sNB3VvTQLjXIRiY/0lmjEbHL2agLJRZsSlbjX8zcrZW43ItX16Q2phRVNczlmfke
         R2M7Zah+v294at0a4B57UiJwRghoccab3rqTUpF+K4UqER8eh01qwt6TOm/Fwzmh0tpT
         U9gSDlfVKSas0tETsyhi2vBlRHBdCqBYg/ACKyfJw9md9QPQ5Ie0lfR7+DoAurV2mwiQ
         OlGjmP9pOkDbnvjtY4t9zw2ohKB6oSyz7iWWgxCtm2zG+T7QZHoFUqI2ddRHAX2IHnlS
         u+EgdzKFMh90Jw2hqnSqM+9Z7rtCGtznsphJiz7BD6qapoUWRLbEyTJ7+WmOO1YZB2X6
         kdlQ==
X-Forwarded-Encrypted: i=1; AL+hErEpRpS9C0QTRIuqAzqaR0xRhsxi5GvFlMh+FIe1qNAkRFcbRN/ndUupIOyLgJfQtahePcLAhfYn6MvEeg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z9eS1S/M1/LNOxfaDzS0RbhcZ/IUgx0aqIw5dIFLf1OMZ3CwmSs
	bfVqcmcN7lhx4rMB+yR+vEBCMs9QJ1qH1YLQiVjlpF/VzwGdewmA4ZZW711mXYWvK6gV
X-Gm-Gg: AYBFou0tQryOsU5vwi6rdzJ8YhySMwLzNc5DUcBQS9h18ITq8s4SoWyEVb93DDlXur9
	nYXHQOGiFcedLMUlQyYQv/w56w2U8J72qP1InGSbHgnCjkkB8/6UrrrLpzSZ4U0LgsMwW0n6rp8
	ApAVuFFoxpCM/YQmgPEGFIQ8zD3Z2qGYUvDOCtHizvQAyS4Dj2qFnEgnBV/ZfDVTrb2qq4hJC8r
	PMGC81on9Pm1NzC3PwuJyOhBnqTDmfn1Uqkc7TSrli1IvF+YBYBVaR8T4EX7WAKhO6GsrS3JU5p
	6b8UC6jncbrSH4VwT8C0/v5G26yUWNeVNAbv17u8/SRV/FUvghjOyucobX4Thu/wd9iHiGnLNTC
	pkpOmRWxk29n6n3RCuGHRxFx3sOBLGw3Fe5jI0fH/0IwlloeRG0p9LCxNAFuX8s58HPgly1MvbK
	9FH/Et1CG57G/kGHzNaZhXAxs7F+RLrzUnHp48vrGI1mi/q+UNKjaBKARJFoKz+wHQqIY2oDmS8
	qHaaLzRC++5jVr0C9AgKsTxP0QxnUqrLPpQsOlAVAUl+UJev6Le+N6QUgfB/hHzuHh3IJKf0YF7
	ddTDWRP5//dlJbqv/ENqb3mTJNPRqs8Ns76eWm3vzWosgXG+Zl/VOqMIhAthPHNRtGQLSjdTmQ3
	pN+uDqma6J3Jfn8AKmVUB4K2rVwCw8BP7p5ryqtKmU7N97P0rgMeOcA1I
X-Received: by 2002:a05:600c:3494:b0:4bb:6c71:b268 with SMTP id 5b1f17b1804b1-4bb6c71c232mr134135095e9.6.1794904030378;
        Tue, 17 Nov 2026 00:27:10 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7838c912sm45730155e9.4.2026.11.17.00.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:27:10 -0800 (PST)
Message-ID: <0ec7b8c90cc456b24e5b19c1db673d497ae43735.camel@amutable.com>
Subject: Re: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:27:08 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize binderfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC
> by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
> SB_I_NODEV for the binder device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/android/binder/rust_binderfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/android/binder/rust_binderfs.c
> b/drivers/android/binder/rust_binderfs.c
> index 5f020226720db..04468c5b5c116 100644
> --- a/drivers/android/binder/rust_binderfs.c
> +++ b/drivers/android/binder/rust_binderfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/compiler_types.h>
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/gfp.h>
> =C2=A0#include <linux/idr.h>
> @@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	 * necessary and safe.
> =C2=A0	 */
> =C2=A0	sb->s_iflags &=3D ~SB_I_NODEV;
> -	sb->s_iflags |=3D SB_I_NOEXEC;
> =C2=A0	sb->s_magic =3D RUST_BINDERFS_SUPER_MAGIC;
> =C2=A0	sb->s_op =3D &binderfs_super_ops;
> =C2=A0	sb->s_time_gran =3D 1;
> @@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->stats_mode =3D binderfs_stats_mode_unset;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &binderfs_fs_context_ops;
> =C2=A0
> =C2=A0	return 0;

