Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50211606A33E
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 08:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lPdFuJO+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTHtM0Dsxz2yjw;
	Tue, 17 Nov 2026 19:28:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794904090;
	cv=none; b=C15U1ghjnqAPLdyBI3Yn+OUOMK/Dm4oU6weuKtmRnobj6AGBbhwnEQHH1JgrqJrVg6S4Tj6yH5OQxcIfr8/+Z3koFah+ZOn7OmllTcbP+5gRhuIX8o9uhf0fyzO93Ob4C2kRRStmUHaeJ9c5G/uOEwY4uLRHZH/syFMbP6Yo1Z/eZvwL56v/2kHTcv7A07acHEzQOPSylqTt2jKCYgVlL1PQhnfGO41DbN5xOHdEwitTFkWmmEF45MYaJ5zGy+RAB9Aoyo9m4kaPKUcOV8ToX01hZoAdelmUfIgNVpGy2o+Qz8FEOQBgcCP3bik87zIILXNEPlCF2ZCi+iPol0ASsw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794904090; c=relaxed/relaxed;
	bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DnY7i+x51VyIWAPZK5SP1j5+2caRFfgUlMEGQr9idDqai8FS4Nt9AEbx6YTiakZcVg8f4cIHAYKQESFMHRPoAyU4NEzM83nsry1dCrXUjawmat6Q1eTkfWTG6jLqQQCBLdsPRBQNHw+Gbor39I+f6d5q1C60EPE+jjteXtWs51nn8mwpllkrcqDlsNLymloGdWZkLcuJxh1I3w2DRYd72LAMB9H9Mg/NOs1X3vTkUV816YndcZ/MbDLGIsbtlICLXJScpsWadGMJiC6O18bHA+Uc3pQ2sI3wPXHimCfbuepx+SeOeAM7w7elc8FBkraaYcoHigtoZUU6KfG2fGNFxA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lPdFuJO+; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32e; helo=mail-wm1-x32e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lPdFuJO+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::32e; helo=mail-wm1-x32e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTHtL0QX9z2yfs
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 19:28:09 +1100 (AEDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-4bb61185057so19298065e9.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 00:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904086; x=1795508886; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=lPdFuJO+DGh3071aTCrz/IEv07Vt7xHuofQXalMQL06k9Gdg+7gCAQ3+9jXEGwknr2
         3BKF+ATLL3zsMUdfh5XhBsB+lBZozqdNP/mu4CKGidww3Tr5FRBfxmgmaChsrffwVh5g
         57MxNsVnOyMlaWjS82KhO3j5cTuhyr7VadRIYP+lo6vozj9Dp54E/F6ZlP1CqqmDEPRt
         sH8nqOZpnckoeIHtpcsppTMXVq0MCIvy0ZxuRKt6MVOeSDZT7wqj39XCILXBDrzHxgJN
         KXshL7ABzxJqkgXDvA1/04prK0+F84ZfvqjZbUguIWNgaivCkn2EPqxIkl7/StYHKg5b
         DtkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904086; x=1795508886;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=hi2phNeDPOdWV06gl+VBVBjyYAhw75q1i4xTU3SflZPU4Nd5urVIddU/Yk/IdVxn7q
         WP+EwuFs4Z6w3S2MgXAUZhsZq75JawAOFqVnMTElaxpISyYkktpiEne+vOcfz1blFYq1
         dn3HVr/X1OdwBR2RaCqAOaf/cNsWOpTOAq+eXXtJV/gE21SSXPwJEY5sAiuW6PsnWe+j
         J7YassJzd2lSi06FjUYhlHh/fwFjBN/8rrtYRlL7kRplPNJVY/MmJWug+rCO4k03UDNQ
         qJjpPJg1LouiyUXasvI0y2nyKaybGEvZVXWS41qA/matBtdh7JQ8oXO6UsBT41BaSS32
         MyUw==
X-Forwarded-Encrypted: i=1; AL+hErF3mVgEgDw28EQAXmHVNKQY/zZfwwWKqRWmHT7sSwrqICsRbQ0CeiipF45n1B/3i7btorWNKO6pERy+sA==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+d4hK+SMe9NHjpPjDqHAQXl3Y+GKdhgKq3tesXyGu/O6jegQLq
	vys71ysDtqvqIq0VidNOl2ZDWajUYvGmfjOSJnPlYKwgIoITrZa7ozcdLB3i0WFkz2Ic
X-Gm-Gg: AYBFou2JcisgO9+e2qGHxw4/ZWkWdq2eHj4Y8v3eo3zV3kqxxRBTbxzTsyFLt8WnA+E
	GahqzVyuLaap+LrBi0eLY7b2y34eBuYUqg4I2yMmFTMu0xJPya8SMadjhqsHA+spr7JPm7oItRw
	Ocan6NW46DQVx8katu9ql75SA8aoeeaGyT7ta2erMqxRXhKmnapff1RScyDaibSnpEttdcbahLD
	7XULRY4Z+zm4e0ObLrfpm8YiwPrHeaB7YHaIRKMZbZuWQuU42N/ZgkWtiYKPFzWdhjXn307/dtZ
	9RXPyVVhInyPtGRhR04YFZgrq8JLQTxN/bxU3VzT9U4HAJMf7MJ688pJJVAz6Qbmb9Z592lbKGG
	4HjjnsyGIO4IUHWAmS7Vto80T22w75lKXajTPEkl8MAtgouYnnHhZFY6nBpm0BVtiKBwZXtJOoo
	bNutbCcb8/ujOjY0wQItBkQ6UuZ8KL19ftmliV9oncBQKCKEjbfl0rbvZi0+rnUTrSinalrGoH6
	9ziv94R6/UhsAXmbeXtXxO/GrSmqFxHcelJGuWfQwYj5SlR5IT1NDHZwHAdfITzt5C5D58Dk/p7
	J38ri4ISbEBxo2RV7vYVgVnywf5FJ2Y46dclkvWtJgjed7FMeTnydzVZck3SAnraaPekiOJSn13
	DGezPa1DTcp9NtPjymPQG14IPGjm2Q9+QOan+Dj4cBMf9NWSCNWKTDcfb
X-Received: by 2002:a05:600c:512:b0:4a2:a9:ed87 with SMTP id 5b1f17b1804b1-4bb55a5aa47mr209766355e9.19.1794904086313;
        Tue, 17 Nov 2026 00:28:06 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78418853sm74782845e9.8.2026.11.17.00.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:05 -0800 (PST)
Message-ID: <fa0ce0f7ecdbe91cc6773bcbe86be137d2129944.camel@amutable.com>
Subject: Re: [PATCH RFC v3 21/44] nfsd: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org, Chuck Lever	 <cel@kernel.org>, Chris Down
 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:04 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/nfsd/nfsctl.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf9..ce2666deddbd9 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/ctype.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0
> =C2=A0#include <linux/sunrpc/cache.h>
> =C2=A0#include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &nfsd_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

