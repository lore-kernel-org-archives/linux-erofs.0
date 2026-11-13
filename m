Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC146606A8B0
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=TTRR/Acv
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQt9H4c5vz3bNr;
	Fri, 13 Nov 2026 21:02:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::635"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564163;
	cv=none; b=gwRkq20lU5yZvFlI3Gfky4swmGsOJyPJBEuI/AfIMkazvRzVs9lKh7qfEwXAFWJo6nZZNxkZGogtzowY8LFj1zeTR0JdpdtNRAZVeqYq2hC1A3NFtO5Tso22TkOv801U2mNzDejthH8i4p5JvnZ/rGqkk5iIxxfWNgtzJPUVe4Km3ipgCwikDbTOkOR7GyYk7wZzpQQOpisrzMDlo7qIG82dhwABhAx0fVaMts6oHwLUZHeU02OQexKr6dTWDohwxYEj3sLvo3FI2pegR6KfeCr6S3rapYc0vPmN3I1u4DFc4aZM/uoL7591cS2CtDT5fr2fYwAZj8n1ahR8eGdhgg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564163; c=relaxed/relaxed;
	bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MzJCwqdDbCSYRKxpa7FWhfv4DDDqTFQheHH0tf4ZwD9uJ7wspO7IqekkIovM18G8x7sr8D6LqiBMaqCm8+SSpVD6sVOg3NU9OZrVGx2UqFf7cjFHPXj34T2W9+waMIxqL6EzoiZlV/kg9xRnEDHxIOrsZAG7xx1bYrU0sb2+1qpowZe9dcxvoni5MEA4hHx5S7obOiUPE9ZB7PCnvr87gb/DkJbyto7d5CHrhEZaO0cEJTbj8uzJDlbtcOG+FzG7FPvw5x/e8iwf5fxoFuOANO0+Pnj2pSp3X2ECjEwWiLwc4wx2HUwRoFM1Qag8YmUqlcnK8GEc5thT57+pQH6SxQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=TTRR/Acv; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::635; helo=mail-ej1-x635.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=TTRR/Acv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::635; helo=mail-ej1-x635.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQt9G5P2Wz30C6
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:02:42 +1100 (AEDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-c49c32650adso135814566b.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564159; x=1795168959; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
        b=TTRR/AcvG0TMk+0uGfilA7kQB/p6eTywOGFsf7cSj72Nj2Levg0GIYLjdmUCjNn5qk
         YMewAGfWmP6NBOhDX3Lt3VCV0ZizgeMSmYAuJ8LpUJVW333S8C6QWAJ/CBLi0NSeVBLb
         qaJir4Z8WfNoW+4/JxD8ARjnA50JWi0BkKLYmZSwHizHm610jKLXULbdlQZl+CMmK5rt
         XB+WfS/HGQLwlrX0iKw7JUdToKP3x3dcD1RdcC88TrOlIUDZkguFVDMD8rHfWRYMTR/V
         5Wepsb1fLDpjW+geFqVnKkZJd5NTvBpXis1iNuC+eXi813mQh2OFsmnoraa2EPVoV4ia
         vDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564159; x=1795168959;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
        b=Q26Oq+ZljTRWKbvrf9yG1DzqX3YXYA0o2tGXyKXdeHr9vjLf560uF3kh+j5lGUpKkv
         p4FAB2WWtGcFxl0Ls0VbLFQ9W35DZj2Ss1wmpjPptFYCLZ7mowzbjP/C9KMDc08ERGPr
         TkHCnFygXDvFNRORrgOVgKlJeTFGBCR9DETN5GyHZ4J5NqG6KHyhQ8X27jZYMHUT9vDa
         dMedw6bJhCZSO3t9JbHIVrNj+KZ3wj/sq69KXeRQdMHRZOtdqoMY608zKtQ+eWVaDt+R
         J7HW48NPouBAo8xRZA0N+gln03nf9JqSiG9C2GhzdvgwO036i65EDIHK7RMgC020XA6v
         g/Rg==
X-Forwarded-Encrypted: i=1; AL+hErGpeLOM+v9L33kZuwd+TTc3Zfl6Vh4J/KIQwCWY8YylmM2IiV2AgauWteJ5M19A6KdSa0j+jjGCqnlr8g==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/tPYPUXXYQtZ0Nst1xClrvjbd8mSyhJYhqVnJANCzNsRYcaCdG
	I6CHJaBSSMV26b/z7IMpfUs81xaafGkLZ4ZpBAIfHNEQHnGUztYoDaOx3OcJSf5lZo3f
X-Gm-Gg: AYBFou2sA6jrPU9hNyOrLTYD1JLHNvieaWf9yoI1y+uEciiRIejYfvKj5Mzp8ZNMP2d
	59TFvDNdybPKDm3bwgIOtR/mB837FC26HlnYt9/tO7CXMzAniik3x3uDkSgrZrbqvRHFCA5Po3p
	/lDN2vjg01WSCnkOZcJNxZiBpuVxpTwdxJj7HlW0uUEmmbYkt6MmnzGOt67r6+l6/YHMnMKhzVr
	LF32Wt7S2wD2zn5UipKLZIaN67yvUK37FGNjRmB4AfGQNLIj0/FUdQnPgTcgCgD173qldA6UhWx
	2UHrPisd2IV2HnTmJbB3P3ZNPD31RtBoy9dR3TULsJuIwpLB0ByRdPr10Ca3zttiQcLaXKe2feC
	EDSi+UMhBw6UsOx9at+LtnAFHcr69PYpUfl+fu3agLLvMUZTZ1HJRT4dQ8D0MoyucuxRck8sAFo
	WdpJ7/4W8nCzBI14XnjTGoCyTE+fDJwMkQB86SnSC0bBBOsUYoczhRj2WTGjwepT12Dg7jZ2bq1
	e4PQkWEp6xK9euOxot3ovewaFUpB+mrfdnmdQOt3dk3NmIRCB6XRMeCS94N9hrcP1vGn5C7OVLO
	sdH2IWF3ArWQTVoM5t9+7RsUrs8nNBt0UmRBgNdQxl+kPQb6QxqufTcuWfK0Yyo=
X-Received: by 2002:a17:907:7b93:b0:c29:f5d5:5a9c with SMTP id a640c23a62f3a-c509654de57mr163595166b.38.1794564159104;
        Fri, 13 Nov 2026 02:02:39 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b23afdsm74417566b.13.2026.11.13.02.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:38 -0800 (PST)
Message-ID: <8c51aa1ad231dea30af06ecf761a971f5958d063.camel@amutable.com>
Subject: Re: [PATCH RFC 05/41] kernfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:02:36 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
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
> Initialize all kernfs based filesystems as pseudo filesystems in
> kernfs_get_tree() instead of raising SB_I_NOEXEC and SB_I_NODEV by
> hand
> in kernfs_fill_super(). This adds SB_I_PSEUDO for sysfs, cgroupfs and
> resctrl.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/kernfs/mount.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index a0be784bfb06..6b60d212b003 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -8,6 +8,7 @@
> =C2=A0 */
> =C2=A0
> =C2=A0#include <linux/fs.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/magic.h>
> @@ -298,8 +299,6 @@ static int kernfs_fill_super(struct super_block
> *sb, struct kernfs_fs_context *k
> =C2=A0	struct dentry *root;
> =C2=A0
> =C2=A0	info->sb =3D sb;
> -	/* Userspace would break if executables or devices appear on
> sysfs */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	sb->s_blocksize =3D PAGE_SIZE;
> =C2=A0	sb->s_blocksize_bits =3D PAGE_SHIFT;
> =C2=A0	sb->s_magic =3D kfc->magic;
> @@ -388,6 +387,7 @@ int kernfs_get_tree(struct fs_context *fc)
> =C2=A0	info->ns =3D kfc->ns_tag;
> =C2=A0	INIT_LIST_HEAD(&info->node);
> =C2=A0
> +	fc_init_pseudo(fc);
> =C2=A0	fc->s_fs_info =3D info;
> =C2=A0	sb =3D sget_fc(fc, kernfs_test_super, kernfs_set_super);
> =C2=A0	if (IS_ERR(sb))

