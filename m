Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19491606A8B0
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SOJh2xDT
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtQL5Lzmz3bgK;
	Fri, 13 Nov 2026 21:14:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::432"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564842;
	cv=none; b=ICdGthat/ZFuoG4qn2/8ofScAs66acZu2NFFiieyyoah++AziGw1lYs90qLz9zAJxo/N9sZzDwS9NVh4yI8xUwKV+BMoE2WiiW0PCfpTgick4+uEIVA7p9DX2bqQBSkI8iFTZ+H9FwygKnMnmkjNizpzS/75PWUGivvJ4lLUC2KqneUh8AWtL7r2o1UU3dN8RFClH/+cWmRbCpFKDV1rrrPHdI/26L/XUWNY32qfdo8Yf+oUooCXB2S8ebzVhdnf+Zxdgwu8oQrH41ZF/eFuA0LoZIlR8e8C5AKl442hD1ggid9F+jxYjMKYliaqr4GxqBA9pIV2Gvh+/oSP7csAxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564842; c=relaxed/relaxed;
	bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xo0mHUCN5SgSm70RIdBbOj2mcJhBthi28rsJrqKG1Axa/xIPFY1zGmHaQCIbtoaCN9pWlaP/lqpQIiis3r4yU9WTUNV9PmSAl7UGnGIYhBpkiOZDgOaPjs9FQzaqX0bmB0CEr+942c+p4puj8EdfMsuNoZKfLFcG+4RJvC5cFiEeVhec0adMrGuvKbNGYYuN/mblAVb3F7/9namhhC2GVMM0ZIZq3hGy03u6MmdUjg8q5BLDHwIZg96HSv7teWSBRtgA6m8Q6S2LxtlAD+EbAFyJaFLwEhmmhbDXQKb+2X/pmyF8i6jizELVUhd93jZmu1oAUgmIQytxXoEp5o61tA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SOJh2xDT; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::432; helo=mail-wr1-x432.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SOJh2xDT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::432; helo=mail-wr1-x432.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtQK6T3hz3bfR
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:14:01 +1100 (AEDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-492690dd5daso1015556f8f.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564839; x=1795169639; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=SOJh2xDTOHCZvaZv+2j5f4C5Ww5q1OnG3c5iFK3BSooueHIzLyFLbVhVZaazu3vuIE
         ElpCSXb7ENvejX+NIYWely2AG5lpyba7NgRdpf5i0tfgcTkvShtXaEw3EKw786YKA3kS
         c4sDb47aXnOIJTvj5GO54vtudxAYQW9rY3xFWArsgoBFBMWh5hcfEMdvBF2GOx19g1hi
         c4jqbp9h0mhdwSTbX1EC2cTwtgwZRoIGEfy+j+9OaKgUG5NzTQLUik2xjonhw744gp0D
         u5cDSvrdvaZBr+nBByQLKT5121thEmCRIBDh1nIN8fykHHaDpk6JocyWGaLVoWiADAFv
         aoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564839; x=1795169639;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=PiCNnL0I5IYuKp1PTIYK3pAhfKQs2QV/ri5YAY/aG05VStNiAkSFaoklSsR0fOEYON
         d28eDZdWuysQsskzLJhxThyjZKLXaoBeHvA1hoXPw1nBQymCucBajzIJM7Rz/xy/rDqr
         gIayAJbg6JOcTYTJzd0Rxv3OspzllM0fShve8oeRYSOiGrLWxJEl1bZDYVKTRemefa9O
         RnA22lPUjmwKB1ix1LryPDSD3M+KOH9OLN8Qkg+JoBPapZocb2TJB76RA0UDt6ZGBOSz
         83VRT5pG1pH4Aib3Abhk7sqgGrbJOu8Wc8TqbElpVGeriJJyhFbsVoEZMGQ1aTRVTULc
         hoNw==
X-Forwarded-Encrypted: i=1; AL+hErEV+70HdQjMv0UtuLlVjCHeawDu+MsBh8+hCCZPw7j/HdQ52z9QMVnqhVBpN03a+H0chr9zD4q/ujGpmQ==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z879MHklKmNTb/xgg3XYhvNvDy6K662Qn+PNdYpBHuK8afO56hl
	mMezYMXqVD7932V8FIHNRrW2iCW3EeiBEl78WutHyz8aMiu+/0PSZ8vZVLbh3I84tYj+
X-Gm-Gg: AYBFou16ADu/iImWQCSJbmG3hPG0NE+04lowz8opOkds6ccgeIS1gZJuiC1kZjIfzqy
	fYyJTY9bIvMFwLsj28a4YK2MyYdUMYuLimprEx76ufLWfHO40hCmpD8NCLS/Z3V6nkK6fw542sa
	I7B5blxRrYR2A96Se32FXIQ7PcW0Z/ZVSUtJJaDjdPrOx8pmSMyIhsHuFp5TFZJ0VoP73+6YRRg
	7qSPIHE68AM8DL/39LTLsX1eg0/j8ZJ0WyPRJoI/r3X1AGkhoMrLYVy9rmOqqkUZM8wCqOn0dDi
	R67tkyOMTNnF5VoePOf2Uv76b3yAN5eVLO74jOt766lq/8aOxzA8PVpEt7Lj9rsfAE+TVs/2/SK
	mcv2jF6zh/DgjkrKgNlidentxfK93nwayy/kxYbInWcfgB4HK4QQz4t1FZW3LrCRpbPmAcvddUT
	Q1cDftyY0klmcBSPTiiTxqXgZOxhgDd4F0UdxYqdWRMlex96CIRbY/ncRQFsV5bOQI9iFFBHvEB
	nzjnIlgvxfF6NAdJD5asiceGd4nxPs4OP2YU8EToNYP3+NLYtdyYQT/0A+vlQ3zQ4KzKJ8W53SU
	cJKYy8UEqEUat9iJ3wgI8oAMNdjtiFcy9EZuhQkR/ghUW2y5nyg00Dx1ipVM/VQ=
X-Received: by 2002:a05:6000:993:b0:48f:bc59:ab9c with SMTP id ffacd0b85a97d-49c6fd932f0mr4358101f8f.12.1794564838578;
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d673ce75fsm190118f8f.55.2026.11.13.02.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Message-ID: <77855be3fb9f0e1888c6dddc56d73a1683c820f0.camel@amutable.com>
Subject: Re: [PATCH RFC 25/41] pstore: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
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
> Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/pstore/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index cf499ba72702..4658561cf90b 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/ramfs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/pstore.h>
> @@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->kmsg_bytes =3D kmsg_bytes;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &pstore_context_ops;
> =C2=A0
> =C2=A0	return 0;

