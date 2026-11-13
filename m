Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8016606A89E
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DWJUqibd
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtNC2hgDz3bdQ;
	Fri, 13 Nov 2026 21:12:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564731;
	cv=none; b=VKE/ygYEWfuxzcBN84IAcjQ2izxOi90OZgCfyxml7HEnf51F27t/EyNiiiEnIGJNRv+TgQo7WF8JwXSjrt2W/QD4lkTtnyA3+DP3cI1t0mkWX8iG/O/a0wR89AKaLoo8Wg8AGlk/Csmx2LMBuYHugm1DXHHOVlq6CYNREK+myDtG4hHsLlYu7T7/asHJs3U/h9jBjEEGLoxddHrzACeqGzQSR5V2HE+1jkodfPi8tHtsVRnkRbJGcW925vrRGS9YbqpMjLtNeN0UgiJmdrowQ5fw4bKwwhA+v1JG7vIaQAs1wyIP2q+hCzsx+wVInfFwyAxQOtUNTOX3nW3CxfCsRg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564731; c=relaxed/relaxed;
	bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Atu6aKw2iG7Ny9+LGuw/YaQw6/fh+mxTRIE0yGRjoj1zfTGIS1jsVslmpKlXicX19/OoLA3391p08eeki2NWn+e6madiUQwniQrsg93TmATPmwKfYEEh8eWKyNFph7YoC5VbO/c2+ypd48kHC6SwOSFG4/4eGO4SapcRu6tvWongujO95RqOV+oNrInACcxofrgm2J4D5HURhqZPRMF2INOPKlhrcxdFiBl/kFz2R+WQxWV/510ysFQC2fWlBGAyugLJR/mzYFgbLaZaFmQh3oUyQgQPVdpqS5/9RSNUucZwGVaRatvH6wI3Vygs+low5Vipldzd3+fNrKWm29IE8A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DWJUqibd; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DWJUqibd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtN94wZdz3bd0
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:12:09 +1100 (AEDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so8032545e9.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564726; x=1795169526; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=DWJUqibdnmhI6H/ZHI88ZNyQd9GakBE1CiFzbjYi/43Vo8s8GQwdv/X83a+D61Uiqx
         Rkfnoztudd7RS5jKi7ears3xginvJnzHM60XZn5aSOUKoAkBeKKBbprsKAH7XCuGbIG6
         7cRXF7BjZo+W8Do7bUBVYHgvh95p3oB7UwEOLjlTVG3LY/D7f3ijY3a/eCoiK6w/4t7a
         1vHfF0wPXfJw3/vMiz5siLwt1o+uqXfOK/qRUi0lu0GMrPP1DOiodTZ0/RNIKazAYKyE
         01Knzwlx0BvgqYx2kF+AtloHjCngmh0TQBNIr1JfORrkj+RAvlIyxwfk0RMz/dDJUdmS
         zZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564726; x=1795169526;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=eeMbsWnBOio6EQZn4jStWFEozxkVakOrRKhGfpWripItU4Fd6dIFqc3ns6LVwky+qF
         ZMO3SKtnzXhfshzANZujdDyr2jOexOsUGm+jK1CXykfdLZWSrEkoaYpviq4015XOg8zc
         hIdmynDB5aORuQ8+vyv51n69zkg26U3KjaGuvuvmvnow3fXlF66+ZXBLyqNUx7zJKc7s
         5/nxWHBy5yfxDUPS+zvbMSEfZIlCD5/UFfK1GGTOGCPZA3Ze1KY8hcwvOFVOmuub1o8x
         rAIoY7qzQLlLwhQH6qcd0ZD1s+blAGaAEWSJZB/LR4I3VtUO+MELXShyIZSyN6d27DFt
         9M7g==
X-Forwarded-Encrypted: i=1; AL+hErFV/kicgXNm15mV1fxBjUmHQNT3LakjFwhTAuUIICp0xGyTruxHypzXASn1/uFbZK1XlLZE7KgA0ZhAkg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/pMcuHiK3P5YCNgYOFHOX9AciKzaSRMsUQ7nU2Eqczf/TwG1q3
	MjT4K5M2FEqUF+WSfMSSVWtkV1huB/nCWkAY9AMgO9eW4g9gJhcwIpzsuQJVI3rtwBV1
X-Gm-Gg: AYBFou210RbckC8yJ+olsEvWyqO1W98WBgy1l3Gjzb7+RkfiyIgZp2iCLqCMRBvVTlh
	xC7eHBiAjuRxUORJ4jXMULq/xVeJBUEniDQ/68fK8azLg8jNFvf3I1AIxuSjgaYOCeKuvpN44QQ
	DBl3OJfH8ktOp1JMdI56SPeyiLNylkbYIeXwtWg+nlmDGp5FpF5YUqWKa5KxSpNstJs7DPcFO1U
	IqshDWZbVhEVG0meOuWN22LY4h4zALNDCcL9tQVfL7u7ZJ24r/IY0LWtVy0Ym6ogbKC+e23/XYZ
	EzRgHnyB7VY11cid2aq8LXsZXfhZv4JrmzPU71HzFlf0ag3uaLGfpCMn0HJle128MTIi50O+bwq
	EkwwNt39/VELxbjZcU4mv4UKq3/WYi1ApbENt0CTjADjfGy6dpWeqc4a1gJ+m0F0hXHc0Bfpn+l
	i4ittOk1gwtPHAMiewBwPx+cGV9W5NVIuegejJjNue/0F8+FU+SdgqsGfn0QmjwWPDAGE+xPMs1
	lUdR9zNA62BD5+jkk7jgCzkw6Lo0E8TtJDDSGT1oykgacH800f/824otUb79VrhmVvhf/qMdOaQ
	3qNr+jPRpqc6WzBlr+ag7Sg/OeA005KC8QI1O3n0qDiBt3qEt66WXPYEVoHnwPYwHmBQOlhQ1r4
	FODqOkPpN
X-Received: by 2002:a05:600c:c4a3:b0:4a1:6992:f861 with SMTP id 5b1f17b1804b1-4bb55a02932mr40317635e9.1.1794564726124;
        Fri, 13 Nov 2026 02:12:06 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm142085915e9.4.2026.11.13.02.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:12:05 -0800 (PST)
Message-ID: <82d691d2db7579d9630bf89f73132e36124bf74e.camel@amutable.com>
Subject: Re: [PATCH RFC 19/41] smack: use fc_init_pseudo() for smackfs
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
Date: Fri, 13 Nov 2026 11:12:03 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
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
> Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/smack/smackfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index a72bc7fabea9..4a56bbeaeca3 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -25,6 +25,7 @@
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include "smack.h"
> =C2=A0
> =C2=A0#define BEBITS	(sizeof(__be32) * 8)
> @@ -2880,6 +2881,7 @@ static const struct fs_context_operations
> smk_context_ops =3D {
> =C2=A0 */
> =C2=A0static int smk_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &smk_context_ops;
> =C2=A0	return 0;
> =C2=A0}

