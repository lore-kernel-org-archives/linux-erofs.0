Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBC3606A8A7
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 08:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AwFmaPGP
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTHqZ180jz2xqL;
	Tue, 17 Nov 2026 19:25:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794903946;
	cv=none; b=bvuKGTC4yqJK/a5IyDfwexWJzoWJ/P0rkn0nnDO5F9syNXvjD0NaxVPzQyJx/bcFzJIDzp9IOykIjSW+0FP6iq2jsxri9KP7fUQgsXwCOuyh0LC9os3PWTqfrB+PsuudSceeKialxx3FpEeRjjGc3KtUuq7ZaB486ay6rcqIF8bpMbbFaxNZBUhRCSqS9f+/5+5pQnVF9Iqrbr+Lg71al9vOhlKmmEOJpurLwtotJCNHng0Jf5M9MKpc2LHwCI06bHQ3sCkl1GmPUScKgmraVsQ4yaEjcvnmoGAZt3Jr51OeVENt4dL4UN1PewNQJtB21fOT1+a7BGmv97yizKcIlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794903946; c=relaxed/relaxed;
	bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SaLuNEe/uhwANvMhxcZHtfkKtbKf6zQouYl8O1Mh5VbCi734f2+5dJ1ac4VWpICy3TEuDr8x8Z5pm6uI7W6KOtovdBa+qbyCQJphmp2zKkR6aIBv8KfoMPXBkE/db2WBj7z6oAdy1gEG+A0yRj8vcX2f5+NSoxSiEYiCrV/3uZAN6ilcutOY6MPGLzp1pW8rFwXj6mqgCkl4wKBLvWccyQJHrxDtyhOcrF3HaG4xznk1lG0N9u3z821Cj5J59S/fKfHSPyVLLXCLndtRum75HJX39YUkUqiosisWB7gxCaajGOjJUQcoxlS6/3yzLFVzw0/uFu0tQdqppqvbk98yEw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AwFmaPGP; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42c; helo=mail-wr1-x42c.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AwFmaPGP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::42c; helo=mail-wr1-x42c.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTHqX2XVdz2xcB
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 19:25:43 +1100 (AEDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-492690dd5daso4102905f8f.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 00:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903939; x=1795508739; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=AwFmaPGPuIXOViNyk6pmcqmLhTQwuACZPJFO3M2+oRpxfugVuPhR21n2qSq6KeCyWC
         TiWiZK48QLDBKz2zGBeRXH2QjQoap+bx690jAST9BmYF8f97b5MLlmjuha/0o1y+zh/x
         C5zAE3sYkZuRn9XG2EI/Bmkv4IJnwWsiewuQROH6m2bqYKkM28s8HWGLC4M37lGLvbKU
         6FIXY+Y3d5tIIG7yJoIp7zGu10ZleairYmRE40BB2xlK5f7ldG+6v5zAv/cf3j8yXDhD
         rOjLGBgaqIwGxL+gWKs3QK4eQ+DFTgIzHEz+i7g87aazrvMZrv5KSJJK1m8Y34OVfgFZ
         Xp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903939; x=1795508739;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=eCxPT9MxJ+n0Jk3GhDzSRnSgYuTPzhGjGmcZ0x+MGkjAhlf5XbvclSeoAJ0L6S/3ed
         0FGyVa1KwZiGCE+67+x9TvrADQkmca+ZtKDrZ6X0IkbZncak9VOHcrz2YyVWHvR4Xrz7
         Ftpaggh4ZwoHCxU/VbsWkxAUDhfw1rxnotMDwjULG4ddd4EWs1YuoYK0lXZfoQzvDpaH
         WKBxmTMznfpAFXa4mVR0xDbBe6SBo1ewWWCnHxhwUXgQt6gJ5E2scsx5gOsD955gbrog
         aAUmI1q0VOKQ15MaI9/SdiufJu7HDZmfUAwPn4c8sEBnIhABUDrlEGFN9vHeuqqFJBb6
         45qQ==
X-Forwarded-Encrypted: i=1; AL+hErFnAQi9e/10HF3rps6FK9FcefjSZaUQBxNUqDlZX+h3ivZZRzDTMHQIlv2y+LF1lKQpLybBacnYcfB0Jg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8dfj/BTNzu4w9nmWUhvrgEl5z1AByr1um1bTo25DetnhQyGB7B
	D6e/DJwuHqj4XJ36KcG2T4l5N+Eiy2p9beXVoFL2JYEFNVTllEwYVZTtdGp6x5w+wiYd
X-Gm-Gg: AZFdTZdHb/wUuPImBbeHUYdC+co+ON9CGMn6FSum5CyJFlgajHcFYEKZkuzlDFBwAYe
	/BZp5cQBIw0nnagdLYvyNR1Cw4n03FKymTws/0TUoh8WBwuzjqtnPSktVMVZOSSTrzg1QLUbPNe
	nC6kIEeyuueTejy58LGujIMGxFM6r5/J9G0OTfPurIOvKozhMh2EDwSOB+PFscIcO3GMqLd7pH7
	/sMqrlFthwVYiIEcqSyLBNi61Zu/xjGkFWfHKLxWAActGArfTylow4RckZouSB/ggAE0yvXunAh
	aOUYmZtKhaGmSYfdUB2dFl0i4vgAe94frEyrE9+M91MhzK70rBJwkRjZ0aT0lgyuyWW55d2bArN
	OyM6E+mR+k4/aVhHRzSox8Nya44sKmmDCb0rZMLjn4J6hun3MoXM89aY/5xadHVjth+inumssxm
	MXqvYrNPIRN7dXQ3PcdxHFCTJdvHnPWydpQgZk+6FQSN6Yom1JLKMVT9uHYw8aNWSHhq1vRRCRJ
	I5OL42P8DDQoAkIi9BgFSapeigeLfIjrGoyW7VAbykwy3MK+p5cA/7jCpn3EMI76kCPpJipvnnc
	Q/e+R83rsq7BrSLBymFKHwSXtlYhYhe2vVtwqEh5KpsT21mySCmbtz6CNfL0cxu3GzK96K2y9tl
	cmmyOkUKunIFdy9uGmSI7YjMWhBXvioZb96mjsjPfeCQi72Lr/frDj+6FlQQeQpFRQRnSkVGEoU
	geRA==
X-Received: by 2002:a05:6000:2084:b0:492:46e:d4ce with SMTP id ffacd0b85a97d-49c6fd932c8mr25238543f8f.13.1794903938925;
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5ff2be55sm26907832f8f.28.2026.11.17.00.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Message-ID: <a9124bf1c858cef3e8ac06b1b2396dcb0e19e2a5.camel@amutable.com>
Subject: Re: [PATCH RFC v3 02/44] nvmet: check that the file backend
 supports ->{read,write}_iter
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:25:36 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
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
> The file backend calls ->read_iter() and ->write_iter() of the
> backing
> file directly but never checks that they exist. Everything that isn't
> a
> block device ends up in the file backend. So a namespace pointing to
> a
> file without them calls a NULL pointer on its first I/O. Only
> buffered_io=3D1 gets that far as the O_DIRECT open fails for such
> files.
>=20
> Refuse them when the namespace is enabled the same way zloop does
> since
> commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
> ->{read,write}_iter").
>=20
> Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/nvme/target/io-cmd-file.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/nvme/target/io-cmd-file.c
> b/drivers/nvme/target/io-cmd-file.c
> index 695963dd932ee..dfa8aa46188c8 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
> =C2=A0		return ret;
> =C2=A0	}
> =C2=A0
> +	if (!ns->file->f_op->read_iter || !ns->file->f_op-
> >write_iter) {
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> =C2=A0	nvmet_file_ns_revalidate(ns);
> =C2=A0
> =C2=A0	/*

