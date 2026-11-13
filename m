Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7A1606A887
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 12:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=U9QcWikd
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQxbS4Kqrz2yhV;
	Fri, 13 Nov 2026 23:37:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:31::5"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794573428;
	cv=none; b=DAIignAju5WPXZZPeRBci4GNEEIeuqSha3KFU+74DW+h1ZNm5u+WwPa8Yrjj5dsuumC4R3YU/9Y6ULriH3rAA/yFLbcYIlDKhRt8Y1tQSaLruNBjiUKN3V2m1hvD5ML/S08CnYNdCaiGivF48WwmXotkHHayLaHW0V6XmCSDZ2gXgVndhxVBFsk4BGPIp3IPoNCpz/Sm4Jr868N2gHXDQS2qlKFYktL8pSm4NIXF64vgG4XvHM1YjTPEXOSo8Ry7N82f75e9R0A4Y/4td6HIHvLNhQPprgV7K96AnXGa92CUgPAYxQ3+pYk1pmB2kcKUqcTTmKynWDMmtNMPcodusg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794573428; c=relaxed/relaxed;
	bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DRGMradLpVwSxDbEKDVAP4Wdh4WS7oA1svcZgzXs++fWSMKrZzYJTWe4G9RgoDRIX+hLUQC7dCoiWfaprc22ROlwUBFelIjcHYGVrt210HKZYPIy257urfrNHQHAjBG/OzZkhJUIy0l0Du1SG5XFwhIeQm993ulbV72c37jroXR3GYsxcbzQ1ZgmMksU7u0YZIb3keAYJqFSE1xg3HkBdLpgwZC+pKnkMQvorFVw48KISbDimVSA8zdz8mNmO9amciIB/FvxdEkrfUE8HAOQ5PhYmkJ4nExvfbf/N3QiIkDteavaB7aADMtKFr46Rc3/d02pe4Wwci12XVDc5SpuWg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=U9QcWikd; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:31::5; helo=mail-wm2-x05.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=U9QcWikd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:31::5; helo=mail-wm2-x05.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm2-x05.google.com (mail-wm2-x05.google.com [IPv6:2a00:1450:4864:31::5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQxbR2ZZKz2yFb
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 23:37:06 +1100 (AEDT)
Received: by mail-wm2-x05.google.com with SMTP id 5b1f17b1804b1-4b886ebe069so3303945e9.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 04:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573423; x=1795178223; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=U9QcWikdjZk8yTzNPJpyHauuLAlaXSq/SqmqIND2uvK0gaHTJbBE5eAUpBxJiqgFvq
         bfxo2YzaNY/Y0jYMI6m+iV6S8v0NwDU/ViCxVBaNq5qzyayM3sPusNfRlhn8bc6405gD
         D5lz4vbiZC2DotgJY5McFwifvpj0xKY1OB10q38bab/KlLCqCxDoqTzkvkb8rdjVsmgw
         Gmb+tNhotB8avyG7TQ1+1A95PPs9zfMC5hWDNzDft8LCYko3HUaSEv+Ffc4A0r+q+QNv
         9S0PTvCI2LTpltkN/G6TuEhL0GYCCVr6REuAtZ59X2noMX+RLeOdMNirY3ry1KqteFPO
         mYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573423; x=1795178223;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=kK3i4noocDGgPEzPwYzzYRycAilhc3joqX+wZKp/+HCzFiTGq3M8AtpfXUD3i23pHC
         Rb3ts2mqgHLMETe+4k7avYvXDpoZxl8+Lu5KkwGg9E5Q7WyLdbpB4rX9yhFkGJxyHxob
         K8JmusMJsPb6XatPViqQqVOePIK4u/cL/RsdkFTe6hei+QXeQNjggecNpbCR2GBeWHCM
         EFtSoR2yWGcngzxJBYrdLMYBR121zKl4Boj16Ed8k2LPpsfLMraEatszb7T42z6ff1hi
         OKVTcHmH8p0bVR2jJP4RsDsHk7QPjn+CMiIWGdSwmlXuEaCsnD4Ocq7ZEVqUcwS5XNEC
         0pbg==
X-Forwarded-Encrypted: i=1; AL+hErGKPFuzBhfXswVeHCvn38IAVk4FxFTPIN7qMVEOpi2eTInJoGq30VVb/0ozvUESXG0IXouhxauQL6Cf2A==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/hwWz6+2yHao4KB/GtBNDMZsYbr65YuklpNux4kbyHA0fhrwrD
	K5/KTH/TJy5+L3R3rNIw2UBAiqgJDQnBlfZJsCAcXdk13x32v4P1etRsSB7bLrsZUgMv
X-Gm-Gg: AYBFou1hbS5zyvzpQwO0P8340dJ+VFLMpXTWC0YLGJnQbH1Qu3ChuLwBl/+EPKuVGp3
	B6v/63C97B0G1pYC6un/Lhe2q2Jve0KjqeZm1GaeryTV3ABIcKpcEDri2GpAY8QDV4uY05LLbUD
	Lxs2TsoV/IGTDAK3zYOE0TjBbXn1xKOpV9jQcIPexSYV1LQoC2fknQ1bixiz4kP17tWQ6bERyND
	191ocBPFN/ogby6Iq6H083LBvcl61sPVGiMIipxk7EZ5k6dL0If887t6Bn6xJ3TAG7qfGpD3J4h
	2jowBNXJyv5xkM8zYFgchQ6Gm3H4GQME686Mh5gkikawLGthYb0H60Ya38UeCUo/lI3HBwRKoUb
	aeRnhCbJraF+1ZKhsY+zjrf7+o+NZDGnukxRY0ILs21GGwmKF4wghSVDqaGmaFxLFMigwQ7JKT5
	5t1FZRElqa3USfplT/oAwck18P7GCrzzVakMZdTe5KlFgMPPOTCfvS/bwV7nR65NlM1kMK/314w
	ViPA6wLZHRTP4ZyLs+GvvmO1yc5qKTwpYt0QjTgf44WGQ1lw0hO0cnjUCrWNCqTVjACZtLCGIIA
	ZWh8inl0FtQnz8lzgi2+H1Luqt/qROs9D2SKBONjH7C0uRShtmXh9zXzhi+lTXu6j8laVPkG4Lt
	3pidzN1ew
X-Received: by 2002:a05:600c:b86:b0:4b5:d95c:2378 with SMTP id 5b1f17b1804b1-4bb55ac4030mr49782945e9.34.1794573423157;
        Fri, 13 Nov 2026 04:37:03 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55af2901sm57437255e9.13.2026.11.13.04.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:37:02 -0800 (PST)
Message-ID: <f12140be54ffc4d1e8e4026f80c41c75cf5727e0.camel@amutable.com>
Subject: Re: [PATCH RFC 39/41] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
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
Date: Fri, 13 Nov 2026 13:36:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
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
> fsg_lun_open() takes any regular file as the backing file of a LUN.
> The
> file-storage kthread then reads and writes it with kernel_read() and
> kernel_write() on behalf of the USB host. With a procfs or sysfs file
> behind a LUN the host gets to read and write kernel interfaces with
> kernel credentials. Refuse files on pseudo filesystems just like loop
> does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/usb/gadget/function/storage_common.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/function/storage_common.c
> b/drivers/usb/gadget/function/storage_common.c
> index 75831f2c7abe..83683ade20c2 100644
> --- a/drivers/usb/gadget/function/storage_common.c
> +++ b/drivers/usb/gadget/function/storage_common.c
> @@ -211,6 +211,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const
> char *filename)
> =C2=A0		goto out;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(filp)) {
> +		LINFO(curlun, "file on a pseudo filesystem: %s\n",
> filename);
> +		goto out;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If we can't read the file, it's no good.
> =C2=A0	 * If we can't write the file, use it read-only.

