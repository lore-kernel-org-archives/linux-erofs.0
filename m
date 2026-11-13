Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686BB60A2638
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqLI0Afe
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtDj4C0Dz2xlP;
	Fri, 13 Nov 2026 21:05:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::629"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564341;
	cv=none; b=FdeNBTDfGMFfIvA57azL+q7xzY7L0zqNSWKyPbge2BED7vwtAyOzzOVHpHDhFSs8Rq8+ImmLEVz3Gn1wqOEo5RRGc33ACv0/ACZJEuDoDwzyOG9fveNgLVVHRZMsajdA8HFawhe2E4X3b3xFKs2wmexTdPa0X7p1QloOVpqHPEVJQ7XUygNaDY4JY9iyD0yBvBW8Bek7wA1hE1fiueIehyeOgl+QNyLAMEcjrkMAH5i5Zz2L+ExSSRxDUj3oBPxac5CNwQ0lX6R7Dsa8Lqd5bFp/joFj04pI9IJXzru0VKoMsSmguSG0RI/6/AynyB3Mek+0cGgsc96iOp/Te9gSRg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564341; c=relaxed/relaxed;
	bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NsWl/fWqMp8Q1Kmfiee/DQnNAF5nsd8RRxNu3aq2qbE9iW7JNVh99hlH0Salc+kPvO+yN/Wh3qZl4HcC1UvC5HMVAFhezE3QliU3gWxCs0U2Dt8FVioSIQMPRkTdaTV2rPiLxEO51SLB176KAjSB4fYZChEa7kjEGBtnDnI5hOas4AM3OxIp5pZS1cF1RUWiAPyAblIKq0t8pZ8CHXzndAUQs/+7JuefcLn+p17dNczHXxWB2MPyZV6OJ6KRzNhwltuv2jsuLbreJIMGgfDVd/219hp9B6gH5EsbCRxE4Zi74uTDHR2d2X0iSoLd2A5OsY5lHy/clLJy4+EafZKXBA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqLI0Afe; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::629; helo=mail-ej1-x629.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqLI0Afe;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::629; helo=mail-ej1-x629.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtDg6jPsz2xyB
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:05:39 +1100 (AEDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-c4322d310e7so190392166b.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564336; x=1795169136; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
        b=rqLI0AfelY4tNM7XD/7hyzj1kj8Zh2yIEsdzd05Tp+aS/S0xQTTIL0GCas2XB0o3yv
         Xf4gX+STV1fJNDs0vv6O4nw0k69w4e1peHd85ZmTtlLqHOGc0P+PGIgD/DN5tspxowoQ
         tx1JgxThpV1T5cnhPtikoJFRIBiLqymNvaqGNXSHZujsL4lL5v9ASOpTMTT+fkvBFzGP
         abtxmotjyTwsd7K0PJlS9ay7tN71B9BxKY+PIN+xoTZXC5N09F8orU16gTPzRBWBzJPu
         Dkv1h14czk6vyv/fcHy//lhz07ZvmIVJKBCd79hGG7UKTyTTVd3+FfpfoIabLcZTwiPq
         Wq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564336; x=1795169136;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
        b=fIelgheDA0UNSaq8zmMC+I4Vkm8ywr4n4pj3S/+JFNaUx3BNJWjEMPh8ssoI28woH4
         iJSASK4azhTxgw6Qaoc7lTOXPXWVkXxJmn6yWihHWTIbFJBroZDK4iuckaesiM/1xuVB
         GkInvb/mUmlfQ54uCVE3JyhjlqFQ5ZRm6O5HcJCNtKtQUuxqhQas2w8RDkEPa0iTr3/+
         /pePMUZ7hui06Ww+xvdSVUPwHk/4ewQFyxqKWbQ58JBWh7kQ/Z/BskKivI8rXcWdj0pf
         HGVvZCcIXKucLq4/9ZViD/aaSHnq76Ay6vH6u6XjYtvJ7K29/1ERym7cJz/SDwUtege3
         +jKA==
X-Forwarded-Encrypted: i=1; AL+hErE7DZx/74N0t2nVdjHxM/iRUqckAPRS1Fb/32kIJzQ8GNXzAbNCfnMKkTPx75IMsTiTynhfUudBrRyfiA==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/NQAWBmDM6ZiQLJ4V0QB0HznNVnQUGRSVBz/4sz8NzbMQQ0kT0
	NSRoLzhvionaJLIQci+xj+iU2Q4RJHwNtO6raqvdXPaNlZIaHlmeZ4nDrO/rxZtFrbYo
X-Gm-Gg: AYBFou0zjHvJSJoNQucVBpXjW08ArBwAcZKuU60Y3l4GGZAGSAhzpif6yEOY7RDw1vx
	6+xAJss2XPZ/N5uT7Z7Jj2wYYg92CqGqj8oLBi2rnVcYj8W/H6SplgidTpV9CST7gaTKyBLOz0y
	Br+QRMCEMgv4nvGGV9RRpbNVRVSY4Wi606vASFBAAyxbSaYPL2X51r78iTX/i5Y2DBXW3LtC19M
	B43IkqCyzDdjtKCAtY2jt6emzCyx73yPnTXyGydtPJcpLbNSCFkvChCFsxJSTp281B16YF1ajHV
	O1jchuh/2//B6WAlPfB319rOlXDlu/DN2nuZkn/Y8IzJaduTp75K1XNV5ZeoNVnURpJoM+Go1zA
	KLpYVVT5rmPXl9w9OMPZCJX8yVeSr6chFE0VodKmC6ptAeEiqu+r1reqoUMjuRoC7uXANAO2MWJ
	VYUPZjsq8Z+VIc7rNvZU2vc8ZPFjtMMR1Ps1VcNE1TyrDm3FhIeyPp9OBKyo6hedlaLB263FqJR
	w3PYqS7KaVWhO6e7rFo1cXoNvP5FBYDYKmdz8SH24sGRxqA0/I93044IKEdK50qllk6PyNdVeCn
	mnF9JrqEFvdFSyCh9vz3j340ZEMNGeE+XZSTherXhKfs+5QlOQh2xA5o8DYrxZ4=
X-Received: by 2002:a17:907:94cb:b0:c2e:3a72:ffbd with SMTP id a640c23a62f3a-c5096389759mr162937766b.41.1794564336347;
        Fri, 13 Nov 2026 02:05:36 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095a5b93csm75365566b.5.2026.11.13.02.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:35 -0800 (PST)
Message-ID: <8f532a01f6cc2eb73582864343e25be4ec990919.camel@amutable.com>
Subject: Re: [PATCH RFC 14/41] debugfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:34 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
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
> Initialize debugfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. debugfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The debugfs files that
> can be mapped, kcov, relay channels and powernv's memtrace, map data.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/debugfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index b4915551ad31..f163f0bc5703 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -317,6 +318,7 @@ static int debugfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fsi->mode =3D DEBUGFS_DEFAULT_MODE;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &debugfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

