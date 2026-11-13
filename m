Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B616606A888
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XLKPtpT3
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtQ26qZxz3bfF;
	Fri, 13 Nov 2026 21:13:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::529"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564826;
	cv=none; b=Pc7p8NjTSBomktEr5dusP1DDiegypu01/tzz1FnbLIYZceZsmF8ZBZjvguIAbanr02zjwoZPZu1t5HD3iq7C5RRhIGvE21BMlf1sHCrF30Z/y27szoZwYxxDDH9SNMIyPs9EBRBTaqZ5C3eE4paRT0uht7GrAmhcFnPhI/jOYpYKcIa9TbjccEkMTN8HFDoj5wb0uWAq5MG/y+9LW0qE4B2hPkeepCdMngMIy4kpFI66nLr/6M0SjVAKLgyFLQYd9JELnP0Csg1yzKLtqao7YrgFqKgHrt8WCFMRJaknuE2W4v/oXDe6bzv8gjJanU3UDV8Twf/DGfJ6169vPYGc3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564826; c=relaxed/relaxed;
	bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oDVsb15TeGTtd7kGpSUbhyf5foSHXamVTuZG0RbxgCBM8XJOpFoaDIGd8X4+8m8bv8TAycG7kdxqQfyEEpMfSmJbQBXjoMiy/S4i9UlJAF8XUMkOHUSgGSJc4J+8FAgEzk8ndk26TGUR+XuowhP+awpVT1GUP/hp1+WBR1N/4s9D8PJHtLv8fZa0llqpPcTCt5LNCsGsNAFz/cFpPj/qlUYiPK5hzr2xkvv8/dpFJKH42RrlNCbrxDBG3BvFzqzhZniv7Lkj8q3tqdm/6nFzZ6rbaM9/dJwFN7uUrRoW8gs4mEA7fGo5HsdtTRvg6gPuzaA7NSmp7zMoRXy0gErvrg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XLKPtpT3; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::529; helo=mail-ed1-x529.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XLKPtpT3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::529; helo=mail-ed1-x529.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtQ20dTsz3bfR
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:13:45 +1100 (AEDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-6b71b012e3cso1051578a12.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564823; x=1795169623; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=XLKPtpT3rHSFFgvOMfJ6F5YXkL+LxNERKNPUf0SV5E8UoBa5RndfBMTp/aPpGz2kVm
         M4WkMt7V2pjxmsLKsNTc/YcbCxr3dJccUegYpNwZViv9Vh/zUwBkn6bwpWFwi5NDWB2g
         i/QB5xasT2lAaClJ+/qXY+qJzUCAYXo1hmh6wyvY+/qLPaninkkF8sk7g1FMTtHx5TnN
         bqWWQ5sFLfXK0GwoeXPj9B75algibwOh2s3bHFa6kj+LtgVfjWW+LAdJp4CTu1QT221I
         h2jp2ZktQYM7C3HDYp7p+jPCmDJ+I2NGMz9wD1ElQhjPmWkU+OxnHAYhswgnSLFKtrjJ
         LpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564823; x=1795169623;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=s7t/eoKta9sjncCj8m5uErAjI9MReZy4I4apfbvxsuZzbh4wHytDMwQ6LwBz7E2YoC
         WvRZQByeQjrmRK9OTAWNt+TZGD0IPGd2ikJ68LKV8wy3OHzZ8eQTcsy7IM24L15wKq0A
         NKTj66bhXf5su6mmoqTRVTBpEc/sQwof9qyfEz37892XbfkpQWm2jkQd3h4m6dzHreN0
         MBdNucaeR/fl3z8sn3x/S8cPfAQUf+LFNvQ80w+Fm8md6sN7wUVLJ4va3M06oVMzAupb
         9HCx/4Gf9Yu/hHbcccG61EZdENACDnDHibAwfzEx/5W/WXm5WhZiPrZnThNF+LnNEIAC
         HHvw==
X-Forwarded-Encrypted: i=1; AL+hErE787AEDlMUQQZXNP9ix1KIKSIHfcsJf1MU3A5NOdBf51vJGaIUsAHou1xSDJSAHkd7HlprrL0Y+BLVsw==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8O3eFeGZsbHTDg+0LHAPf8Is27s2R5CTF5blkxkFH+UGCGHKSP
	jo2FFRwBQrMsldvwlIkaZhnK3HKZtLvGzIE6p2Uk3sXIFhkFeOpK9A4bZhu/nZg9wwq6
X-Gm-Gg: AYBFou378RVLCx5/L12gftq3Dl7E26qyP1NLo4PXo7ma+SN0Et4XKVv0Z9nFOEmH3fO
	9bozEtScQvXVIdhH/CVIu3vfS6jyxfU3Ue1C4AW0ivYddbD+/B+FqTvimv9sLDyam9zvCEc4JxX
	qb5dRXjK+mLp2WiTxC9GM5QVDfhi/z8Nye38eGFduqGf3VY8aJFKSzPwDGbZH06WMRM3UMVAy6H
	f3xH41GKDDTsA9Ug11l96mxx3toVB/D6AVCNfeePA05ENi98YC9PxJzlBwU2tP7VSigcixdE1gx
	ecT6apA4AoTCQZ48ECSh8kd2xFEumYNaFtUi6uJZrWc4hN4tZuMn1lw/KV88lJz1GAuDfwZGU7b
	RCEfAQMQOQmh7q2V9sHodW+J30ci0tQfIND1zvBoXKOQjj1PwOPRG8sMzt3CNIOhZj/wmNeqPZQ
	psX3VPSq4AGFpj809y6zrdZMB6AsB5dS7gYG1LzZKKkX21tjNt5sPlfcuH5+5LiPILV5DJsoMQD
	t5qCjbwzvV4ICSq6e925it7ipatCrhU2wrcjWJqyVEFEZV0Kojj2zXNmeXtlS9YnCTWwYfa4EW+
	ihEqxuAWwaJXWmKXIG3TRL+qrY+gsK2siCjFQzbIT2C7qWIpeuAgCtoaJ7tx/S6OuYbpCx9dk++
	wOO2hztAU
X-Received: by 2002:a05:6402:208c:20b0:6b5:69f4:e7ce with SMTP id 4fb4d7f45d1cf-6b7c0c62bacmr1415990a12.39.1794564822367;
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4d29sm4332158f8f.35.2026.11.13.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Message-ID: <3546dd28b1d63c1478d391a2015fff4c1b976639.camel@amutable.com>
Subject: Re: [PATCH RFC 24/41] efivarfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
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
> Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/efivarfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 12746ced6dc6..e598d42c5f42 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -8,6 +8,7 @@
> =C2=A0#include <linux/efi.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/pagemap.h>
> @@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	}
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sfi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &efivarfs_context_ops;
> =C2=A0
> =C2=A0	return 0;

