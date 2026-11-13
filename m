Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA72606A8B7
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aGuiZleF
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtFS2xBJz3bSw;
	Fri, 13 Nov 2026 21:06:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::52e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564380;
	cv=none; b=b233rpZyhYeVVbGcSZfK5l7dV9pCbPm/jrOhm8TPCcIyGBeUtY1jdePcaDNNgQ6UwCfLXdIx61o0GUZbN4LejstvdJw8SVSit7r7Y7K++Vv7sb0+Ac/jk5cK7LKG/mknWQIqFFH3fZ0+AdqDyRNjMJ1xx9fN9MtpGMf7xJ0sAZPG/QpOvBwBTIll9l+q66EMt0IUAKqxl4R37IVLjY1HS5NkXQ+YXHyM7W8MoaES92fVn7yis+D+RKBFm8x+0LfNbLla2Grc3E3b7gcKLMIPKqy138qTQPQ4SoVuDENaziff0ZhsZmlGp7H8PoHaIUs23Vp5SbJbfRqG262kGXa04Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564380; c=relaxed/relaxed;
	bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kfYTL3McnVECvEtHfLtIq6VORucepdKkf3FaPcDSOOKd+n9b0BNnprvQ3agrOAXWjhc9Q8FPtwPrhANHE8cR8ex6ylxLMBHRMXdrBGUr0E7zwnxjWa1U0YjXIKsz1CljdpT5XS3rcplJBlhp31JiMyVOr1SgdcxvHGej2iwUtKOW17HscajEO4Rt3LTVPzG0h+aDVNMmdFyTxgZcLhAvh71VZW1x/Zcxqc06mXTe0aBBvD5zYNkBswiIX2FQG6doLtZq3Q4fEOelZr5PvRAtSjIvzdMnoKskCqrbCuv40KQo5L+5lOKLyZPj0KTZcltf5DVXYPMHguDHYangl/UpoA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aGuiZleF; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::52e; helo=mail-ed1-x52e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aGuiZleF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::52e; helo=mail-ed1-x52e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtFR3NSRz3bTj
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:06:19 +1100 (AEDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-6b6e8b6d424so1596904a12.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564376; x=1795169176; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=aGuiZleFS3rrlFdfnmjAMLACnQTiqOudYf7dIKerXrPqR8N8VqSx7bLh7a4wXVu5YX
         yKBSf4pGnCJFa3WvUBjFzfBJ6fpjVVB4PB7n7LY/p+zqn5ax85QRjJwzRpgTmchGqWXT
         RGEwgzA6nsVtLhIhnQmI5vLAWSd2hY24Fp9W/6O/ovdbTthFxUYCwtr4kG5s1UNC5vPF
         tXueLN9j5fs/QfoL/yCvmW0i4na176Gjl6P0U0M/fMxknCTtemBZvDbZntufPAMxL25R
         WeM/5OWpjQSjriQ+SqPC9vNlQPF3FCWTPwD9jit1LhIdTbHchjKXNgmJvyMpvh4Ausxt
         r38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564376; x=1795169176;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=JAr/ZBoSz0Ydn5zbdWK1g/3k+9/p57psGMSyOfXDtPeO1iQUNj6AuEWC6jFOh5CFq/
         aCqS7hbmAFBA0EOZVdECDG6g5s3wdezQXlY+HsTN1lZTjOPikvGESz3i44DgpQUoK8WL
         oK2BJwoYofSj41is9VASweg76LpXkW4GgFwXC2pcsIdA4eihah3ea2Lce42FGDWGPItn
         AKo4aOIOu3lvJu7x+oK6jl05uxXwqpqX7r33u9CiJVh+JvdJACr3S9Ozm0H8JK6fPlE5
         hZlo+dqbdJKhptvwGwdPMnccIi70oEFByY0PZHn5L276LkU0w/0B75dMPmO1ddQ081P2
         OJUQ==
X-Forwarded-Encrypted: i=1; AL+hErGnn+I1loEj+UGyDE8faikEP2AGJXXg/4va8rWgT2Rd532WMa9kcto/pd0HBi3Bm6ICjtAfFgY5DYVkqw==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+v4YrZKukFQRhx9aRtZkj0FLCkPHjyMTRhWoVmhJBKs8fvJAN8
	8xhsL3yae+Iwel/LMeh/cSE1DednN/9Wkeu/uu11Ic2Pa+aRT+FDbMdnz2Dio6ARLJoT
X-Gm-Gg: AYBFou31zYnZV6pJtmgmv8Cs+S3KjvCTvaCuF/v4yjWcTfvHCJHMQeUsni1ZH/eYd80
	3WV7Iw08FDfOwiTvId+qKzvkhWRbZ5lnfzWCqESKTwxcSeESQfbjksfNWvMhbm168cXFTdraefK
	PwYl7y/WJQk6N+j+DDI1CtstoFPO3F8KVgTLutXlVxJJ4iN7khJ7L0YEPjvgk1Z2IMpmliQ+N+4
	evyr6gLCpLfwyWKS1fqC1pH2ekqbZbYAWYy/NVfwKMZ8f4dFtWrR5DrNEB4yniuptsM7sv91cKQ
	/zAz6bRMN7S6dOajr90/NgD2HqFu0bMawRzA957yeJh6eqGeSzk39eMlHLSdIZTev6Dw4jUbA/u
	IW0RYBs6BiQK2VEke0wM+U2UR25BzDkQPhxuoePDVR+JYse/9D/s/mwpAePBjjCKF1tFi6xIITy
	SlgRlUXKDriDNubXA6xcZ4vd8U8VHSBzdW4Tt9XVyE4o7/JJda4chTJEMImScl97ttbZeBRcBwX
	cIOsvwCm7Y6Nvea3Sk69aTbttrkkP89s0Pi+u1T6kjUbWi5WruqrJOJfol3nVTOiqIZQvt2/eK7
	vB0Eva6LpZJx9/fIyf9fYHUNbL+Ng3fmm1Clzgs093IRIwId+RAl/HubAQGVDR4=
X-Received: by 2002:a05:6402:280d:b0:6b6:4dcd:967e with SMTP id 4fb4d7f45d1cf-6b7c0bbc394mr1685420a12.20.1794564376161;
        Fri, 13 Nov 2026 02:06:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c21b1b5asm706711a12.4.2026.11.13.02.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:15 -0800 (PST)
Message-ID: <4dfa19dd41ec1a202182284d9617926a259288a7.camel@amutable.com>
Subject: Re: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:06:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
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
> Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/configfs/mount.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> index d8cac1cbf3bd..60ba24e7ae2b 100644
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> @@ -106,6 +107,7 @@ static const struct fs_context_operations
> configfs_context_ops =3D {
> =C2=A0
> =C2=A0static int configfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &configfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

