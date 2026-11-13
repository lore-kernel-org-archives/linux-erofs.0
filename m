Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470BA606A33A
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ULl2vP3W
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtjv00RDz3bfR;
	Fri, 13 Nov 2026 21:27:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794565650;
	cv=none; b=F6PZjEe5P5EyzVqHer4V0sCzwebhbH4jb6GpK1zZys8BUxXWdMfQX6y6pw8CQg7yUX5ICY1a0BvJcRuN5umoQzCBzKVBS4O2B8MgcqlJJ4gyO8/eP0IFENE1Xbv/8MfrUu6IztWTksPTR7MoJiE4kdPgRMzjB231nWRipXFSk7Pxe0ZRJTW46k985OQOg6n/YnnSkWLs3Qs7bsmDmOkdLeBG24zGsPzdOBida6rX0Bz8+LAT9bG8vHBoiM0/HzuGcVvSwzkGo5zA6UbUQqvtSaFIfSyb9hzYkmo7ar6aV+au7FXsghCK76iSIwKUI8XFpXiAFEXVJdM6eZOYtQ9mOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794565650; c=relaxed/relaxed;
	bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hQfbU0hdVA3QMIpzcLQZOYHNGDZ18FJir2dVAk44Cs7dKb4zKXiRD7LaqRPHTgMxlmlbSG/PCmLmq+9hlx3bPlX7xUosoPomUWWTteqRBXGQXx81cwmKHcbpTovzavI7cgjsNnZ2xnHUfbz2Ih5Hq9bML0TU2VkKP+V/dn97AxJUkc1NniN6Dp/DHqQwt/DXTBgktM5Ldj+jq6gzoBz6IMQzyA38PiRp5p3C4az1CQdonT0zAlqmFNpGd4iWNm8UjIHBzXFEIiQnKAAQoF+rMiguxS8tzkKATfYhkQ+AswVvkVVQDNMwNr++poJBCS6ov5ePkiPwoFP0h2pxpy6hvw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ULl2vP3W; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42c; helo=mail-wr1-x42c.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ULl2vP3W;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::42c; helo=mail-wr1-x42c.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtjt0myqz3bjG
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:27:30 +1100 (AEDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-48fd2e38825so516940f8f.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565647; x=1795170447; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=ULl2vP3W4S/nr8wZZgiGmz5dHbT4r1Qh4yUUUpZvc4UfpYG04yJ3jztTQvI7zeBl8a
         tAZjPYqSpUhgbapZdwCxVkavMzdnmyIwBtNjmc1E4g1EgpLJYQt3jxwr0DcjiVYUrQ44
         6xPFXcW+MStA54THMAPotZ6t64dvU3xMCKM/U0tu1tHHsi+ozKJSShYBnGbdwyTJ9Cvb
         z695RRSgCg2ga+5Fw5LfOr/cC4zHO1ppUAQyTEkH01OQqYKkVfGU13MkGjziX/dfYO1G
         uGQRzxgbli24edX/I6Abqg5s8Vlr33YWiWaJTO1VHMSLsUS6z16C/WwMWXT5RfuZCmoO
         pufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565647; x=1795170447;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=rwDd6s6dambtSU3iBshBthGdsnAQ/56UheYuQx16f3TpAPZPNvsvwN7SzoMGVKfv/P
         Psu3i+3xcP9CNodkZR6tXhAEr0WKWOJgz2y+a5UrTgUW/2oNJvzmdbgYr8CU+ufjIW8w
         ISKNfdhjKFwznCpPGI7Yp/yehdKiXfrv4w+9UxHMrWiYlIyhFgq7iU7va7lLpDA1cNzv
         vk1+8VHCmM9nzXQ0c45zZGD2Ctbvbgo5g8B23z2kd2dhdkr3Ms9yPlEJLgvNZB0g+XQX
         cxN0fB0EcrG2ddZjTYIWjzllDWJb1/15//bEFgwSHwSQQ2DbpG7jN7Hg4vkwYYUzmAbJ
         iULw==
X-Forwarded-Encrypted: i=1; AL+hErHgA899iJuUzCvmnKtAD0f7JmEw8VukA6ctgA4JOiDjlFGB86NBl7AHJcPdMh9zLhIKFqwDQHqkPFZLrg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/KMJ2z9C5cHiDkHeLiFhtASeWrbUiJEUouAhKdPC4eOrZ6EQoC
	VYbLjD81/u6mqLqGUK4JRYKZXYxggXPHY9Ns3gzgdYj9fb1mIkFLorVKaOujXCQE9bO3
X-Gm-Gg: AYBFou0Y7PNGFJ/QtkGq0y95TjaEEo3t7Sy2S/oqP05sDTsUwTEyDwpZ9fqxglqXkU/
	XZf59gJjnk1UifxMvB0meEti3js/uYYTVWaJMW+cslnLIgqwDY3KlpmhePC+h9Y8kK2dsvFJHgi
	hHLBVmbp3+UQBzdto9vNjQHWSpRGTW7wWKVDNRvv7HDqT9vBL6DVVRTs+1fwbZO0ZAvuuF6/QqY
	Xy6R/8LOw17HBWpyCBJeYAkeqjOJbTFYf7JTyUiShIB05bBeOmViTssz87peUtiLOraaOusX1Fp
	J2eRbdTd77WJLcJB0pXX+4EVRmLJp6XL6xXhH0zAubiLcNCAiO6xk5T130dhEPJM7u1irYGKnbp
	LULrB3QOq/E7REdanySquLVNZLK6x2f5GwD6KvdV3epYGp3lo/d4BLLhUYUIYYMmIBmASze9pOE
	v5gWbYP19MuNbYYYrkXNU6wFJYdxr5BqnQzuReFmQjZxKfyn1rRjQR98pJPueA+vux6EVWJmDbu
	CjJus+vCoOOWtJhdRwHIOw7mponcCAXBaSVp8Co6QyB5SVZY4I1ES6ZVxWU3yQH1rdtcJZLjMrS
	xct1xTbYelGUeH/RG4MwrhuzpXA3EQYZzwE3TL932o64tawuRXt3GCAtD6/eDLY=
X-Received: by 2002:a05:6000:4707:b0:498:c419:3728 with SMTP id ffacd0b85a97d-49c713ae367mr4463557f8f.22.1794565646661;
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm5077482f8f.0.2026.11.13.02.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Message-ID: <0c109a58804a2d782e549af6ad13e89532d9f9d2.camel@amutable.com>
Subject: Re: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
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
Date: Fri, 13 Nov 2026 11:27:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
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
> File-backed mounts take any regular file as the image and the same
> goes
> for the extra devices of such a mount. erofs reads them with the
> credentials of the mounter so this doesn't hand out anything the
> mounter
> couldn't read anyway. But files on pseudo filesystems aren't images.
> Refuse them just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/erofs/super.c | 6 +++++-
> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index ce05557bd998..980d5fc2b576 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -158,7 +158,8 @@ static int erofs_init_device(struct erofs_buf
> *buf, struct super_block *sb,
> =C2=A0		if (!erofs_is_fileio_mode(sbi)) {
> =C2=A0			dif->dax_dev =3D
> fs_dax_get_by_bdev(file_bdev(file),
> =C2=A0					&dif->dax_part_off, NULL,
> NULL);
> -		} else if (!S_ISREG(file_inode(file)->i_mode)) {
> +		} else if (!S_ISREG(file_inode(file)->i_mode) ||
> +			=C2=A0=C2=A0 file_is_pseudo(file)) {
> =C2=A0			fput(file);
> =C2=A0			return -EINVAL;
> =C2=A0		}
> @@ -835,6 +836,9 @@ static int erofs_file_get_tree(struct fs_context
> *fc)
> =C2=A0{
> =C2=A0	struct erofs_sb_info *sbi =3D fc->s_fs_info;
> =C2=A0
> +	if (file_is_pseudo(sbi->dif0.file))
> +		return invalfc(fc, "source is on a pseudo
> filesystem");
> +
> =C2=A0	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
> =C2=A0		return get_tree_nodev(fc, erofs_fc_fill_super);
> =C2=A0

