Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F7D606A330
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cF1OcgNx
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtPk4gPxz3bfZ;
	Fri, 13 Nov 2026 21:13:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564810;
	cv=none; b=hJ6KaNvrp0ra1c7RwrvCzTWFso1/tpsdvFNiV9iX8GJlSPEqIJQS388qVohyIeAsWrKBygXWjTrfHe/Ae4qevbRW5YSSdcSuZ9u5QPf8kEomaYfhwIWJBofMOq3qn5G+i3sKifE3obrmzlCFtSmDf0QXBXKUqa9S50XVuXx0Cmqcze5vKZM+JTzw5XOKP4wJQvsEC56H4PzBxzQCO0s6HpH+0bT3hj+EOi2tEMptFwFPwSMWaN4kLxlSJIXXfTv5LhwyA8CPk0jTpQVzVQVJ0Lt/3J+gCDez8jc8iegnViaOq5KgGj697H8uJKEDNraOGyZj0vPYdwipexieWpVw9w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564810; c=relaxed/relaxed;
	bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kCPT3V5e3EAFpSL45kzHypp2uPFnckoPbe95zRbbJr2Yfr/MyhZyTFsdy5k2vSFJriJH9ATuYbkmDWDkN0NffYDxvo9aM3PTb5KlUQzKScUB//6P9tfqy5CaTndqwOfrnpscrssNXZcIIw/T6qserwULiY3lz002mdSWc+LZQnCLu5nWbx0pu3dDggboe1PfL19pF5KiGcGeYVXEPYXoET7Bl81udnRwdUUXMuKaeQyD8D9mVZjKctFGI4OTE9eHR3bWva8YX9l4HQKadUsiyUdckqtKngzv8WkY3a5nBPJ6L3RNdnyPqmR4nZDaqizXUmVFkLOj3vNdJMgVCrRqAA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cF1OcgNx; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cF1OcgNx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtPj57Pvz3bfR
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:13:29 +1100 (AEDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso10214335e9.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564806; x=1795169606; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=cF1OcgNxncdcLD57KAJgJfSmmITbFhX7Emhlz2xIJs6KuetqQMXN9gx2Zp0Ou1Lmqp
         WDQTmNqDyQ/miPV5Yx0zad2No5I5lBSN5aGSkHvyIxcxkfUdeA7edbDMp+//PJQDBolN
         kAhEncWdIe3iMD13aRJ0T6rItXI6GIYQnOuweONj2jD0o9CKKBXCsNKM/yO7hpxnT8wH
         VOPU28vo5+DBZt5bgTYovC4rqU1yg8BeNShV3f57y4dTRDS/kdPOjTVUci0BrWMEzL5R
         mnBjG5qD5FVws4qxsCvLlgIKe8+6hE7yRdz/qy5gmU2uoM1OqlJ2FahpSo4FM7lFDLYC
         nw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564806; x=1795169606;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=e1kCwu3KWvNi3rZNG5AlCUYOvnwQNSt0IlOLQZ3iydvgxZqnozUKSHkj88Z4HbToCK
         zi4+d4zwVSPDxEpEbd5FWe4sxnwGzZhyLJojKw6BleSqG8r48GDQDGwus6pgJuej+u9c
         F8NVsLK2HIZRAyqCLmV+BjGiYjS1gHJcPiIWvA8EG1m7kHPtDlq2rIabvWxC7aC0+6oa
         zct+SYS/KFGZBLynOU6z4jsKZkXCU/ziZdr/QPva4pLdfzsAPVtuDgCeSCD9vx/wq0Zw
         +lkpTmeNRF35oXatasMqH8jNvJM/mEJe3q0csm3E6Lzd9pk+PHbvnzo1RPs+K+CQRBGy
         Vjuw==
X-Forwarded-Encrypted: i=1; AL+hErHfcTBbP1toSaFIFAAjvevW/pNJPec3vtJyNGSqKnt5XGWjisTVJLVIwShjomgubK+sAm032P9KrAIhKw==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8yC85lSz0ExQCagnw/TmL9FCbkIlSCmHzdheqDm8hH/HZr/1xw
	fa5YxUOOYn2uKb8P72k1n0vtSUoS9p4kNwalKgCNG8hRb/hZ5Dt5qtuaYwM5x5zYlyw1
X-Gm-Gg: AYBFou0paZoTZz6+m1VbIx/vGqFgOA3arqj+CbK8WKy1GE4bstR2KKPtGhVXs/Upqfa
	pFe3zPLCCs8cYg7JewjeppdzaSdukHm3ghGzk8k9Jd56v/l1U/rmwftI1mSBlUv+41Y7rs1zrs8
	0X4Pgp68676Dgj+NDuGWD9dPRP/OFU90cPqUt5LZPz8+3k724T2pFpCKnqOUaijV9mcGVcpboBt
	lUbtG49+ss8XTBBjZYNHGustqIvAq1tApKYLu5lqPoB4hKSGS+yVTviPq98YWGPE6T65hn0Tjxk
	3UuIg/c3/LJT4oeLcFpzNbdZYIuOW/gyf391h9PiJcevikwJOZvbSNX+8H5SX8PRTXOFrnYahBZ
	NrrI+63N60+CDzn5S+KaZoFdiQ752SONgBEf5+OUFkd7/9zO6xeejwnVhpS5m1SZs9vrBt+Cvom
	F4L2wjt3RFo4j+rIPhvTMhHuXzjxwM62Ej8U7SB316dwHrFWqFUwZ1sfgT+l68PqGs0atC2z6/0
	p9F3IcVNQnjBWm0npzgXjollh8Ae7IS3Vp+jIqL0jU4u1X3/5/t1U9r1Bbc51EfHmHLLPsHwxC6
	tMnks0hxhQ2tu2fmIu4LN6BFOPcF8ltp4BMk4VWk9hkP96jYqKCF5H64v8xiVk0=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43583035e9.2.1794564806374;
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c8a77sm4362275f8f.49.2026.11.13.02.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Message-ID: <23edc29c421f5d4c1103004f79e104e9f94d42c2.camel@amutable.com>
Subject: Re: [PATCH RFC 23/41] fuse: use fc_init_pseudo() for fusectl
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
Date: Fri, 13 Nov 2026 11:13:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
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
> Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/fuse/control.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 21ffde596d61..4497362e7df0 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0
> =C2=A0#define FUSE_CTL_SUPER_MAGIC 0x65735543
> @@ -334,6 +335,7 @@ static const struct fs_context_operations
> fuse_ctl_context_ops =3D {
> =C2=A0
> =C2=A0static int fuse_ctl_init_fs_context(struct fs_context *fsc)
> =C2=A0{
> +	fc_init_pseudo(fsc);
> =C2=A0	fsc->ops =3D &fuse_ctl_context_ops;
> =C2=A0	return 0;
> =C2=A0}

