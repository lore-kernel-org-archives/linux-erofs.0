Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E526606B110
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ao5Zl+jh
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtPH1tvVz3bf8;
	Fri, 13 Nov 2026 21:13:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::335"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564787;
	cv=none; b=AgNJwKgXWXDVSvDqAe79RExdsfnGit2OQNaseynd99Hhm80B3g/BsABQ57fnRiFi4NfB+RVJw7FCSnpsoHG+9Dj/UzjuCG93gjkzeSADeHIH29n920z/yEi9FFdyBaKybhxYRvaiWw+UcjH5L4kKVGSe5B/YSglQYMd9D07CucnlDfdeynwQZwz0N6t/tCm63O6m0woaMyevZKjaHvVpiudPPM81o/rg8gKy00pcofZhs81Q0DiJM7zliFG3/tOjHEPOQVMxJ3Ac49oj8vj1AMIg9oHJIqbUctSW5z+qdCbjxtf+A7WyT4N/G+GjyCoSCBh68/qyE/KxR0tzuJ5iig==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564787; c=relaxed/relaxed;
	bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fTd+2SJKMqj6teBX288k31NwiFzO5bQAu3oFKdqdvbNsxnsYboVwEPuMn/+w+9eLIdl+Mv/57KJDH3lNQcuQ4hF0HIgth5sEdY6pInHb1swkX2uaIBeJBroXhQ50C6wqA7KxhV5QHHyyMuVxMMQbApPQoeBoJwLh6ja/hqZ6yGj22rVGlVKmt5JkT9ZeRk9oKl24nccZ+6RWydLvPz7t1iYVGAX/iuXfFBQ4EltuqndAI3iHl4tQC4p0NH9SLo1Cv0SZO5dv+BPFGQlxlCzcyakO8f0C4zgGKV5/nyrEg6N8u1EwdtNHmP6CUYO7KpeIpOKTXFrEzBlklURlMMyXnQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ao5Zl+jh; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ao5Zl+jh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtPG13Hzz3bd0
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:13:06 +1100 (AEDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso13116815e9.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564783; x=1795169583; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=ao5Zl+jhHIxJaP+p4f+eLL5EAOMvkabnxeOohgeSo3uUsOTzOAzI+IOupg/CxBZ4LW
         jicm90ykMnHqMbaMQYNatOPy90QICKrBJsGu5M2O49Nj84IwDRrYAq+Z2ktwNPCCF+V8
         Yn6+frBLtad271DlUXd2TeQQA2+AvmCj5bpzoH7zxzrRIJpkmWX3VZBJE6bBiHv6k+Rh
         xdnVvfjBf8glV5Jt9Z/X7hFnsKKF1Sjn5gIR01gq9vHKBgCTD2YXyVrQUUI5zuTNd4yv
         g7qahBdqw9TepMc0FMttEgzurSNX0BOTrqqSmTrKOOj7hZnzKt9zfU1MUDTMwnZ555Vp
         fiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564783; x=1795169583;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=o9/O2+lSX/on4VTwDgff6EZp80u7lgYc7r+hJfcsBAs9wpkVHRQhs6SpJlnNB6JqxR
         4LsQxFGrn/csAyeiJ+tQIYuk/IDQaujkuJK42FAevnvxxsaT2DpUG9FCP4K9o5zaADnL
         RmNNRQ4BD9aLy9yE/FmhqLr0IA/MpvLXX0ngr/x2bSiUz93nfkrF1cihDfDy+iCvF/Z3
         EaHds37vFf/Up5tQs1lJYvI+cSIxPkcJF1oJZineoF/7+5yopIduy4+SkoDUhBM9CBiA
         K24Xix6mA7zqJ0zJyVwEoT3D7Qj/vZDheIPKV6QQq6xlsMRw7CsoBbGlve8RmalAD2kQ
         muew==
X-Forwarded-Encrypted: i=1; AL+hErHE5aDTlllOdpG09lpN7xL7fb5k2l9D/2UxOaQgHpGzoGzg0R4WgjtYLnq2niXmRarzQnwWE6nWq/MTtA==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/u6jdYe3Atr3Ksm84ZY7vW0JT66cNZuFhU1KcoRW8u2g1XUpv0
	JIWPhrcTrF/KuH1w6tGGMFjHhtTMoZXl/5E5LrM41+uRM2fPElFuj8acxxhkmcIiQAG4
X-Gm-Gg: AYBFou0xYE6o+oksZfMGrI+xPLaqqCsXeqbJW4mWjcUNUPIqOG07ycEYPR2qPa+U2t4
	Dfjj1mxcUiX+ZYBkdmvWmSJTiSuZCgLfsS4lcPwmQ80E9y/HzxdCx88CkUoxDdOHAkfBxvNecDU
	6+F3oU4MLijYmnrc4evAHS9MnPd9ZtdLOb/PGkWZDigCGDPMB88IQkz2285OObchj8MhIY9j2t4
	1SG8M3h4EsMmi40TWOpqnfQOP9MGrGPkB+ueN6MxTiseSncSYcPY+kYvW5Llmx4WaECq+1N/tEr
	XxFVlTRme/sxS7AayK3NRlKGvLQx7THY1TGzrkBEOkMtnzuwLbvtFRrwv0NjAAINGcYa6ibvhUS
	fELuBGXytHj9YcJZCc24RHSfH3Sk8SeXD6Qj5SI8wdMpAjjkeW1vJRYn0PBv3rl7WOoB8DRFBtQ
	cyrQyQtgR52vDwPzqcCxDnxiMsp5RFPcfjSRGZswVETHqdFfUvQ36GS8vlWNcv/7ydakdbUxJLo
	qUZO85qrKOFzNJAwkFVkrrhOviyKQr8zl7PfYNNeDdF8kRq2ueKs7n3x3AdlOzpj6PDqSpJkCjl
	+1cQw3LsE9F1vuj7cepnW3OCviLo3or6EOGY1KLv5uUEft/I4ArznLl9pz+l7CZy
X-Received: by 2002:a05:600c:4f90:b0:4b7:6c16:7b43 with SMTP id 5b1f17b1804b1-4bb55a47602mr36814615e9.10.1794564782834;
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5d2872edsm4056955e9.12.2026.11.13.02.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Message-ID: <94dfa5ec75f4479663dd79f3ce05c1dc6c080185.camel@amutable.com>
Subject: Re: [PATCH RFC 22/41] sunrpc: use fc_init_pseudo() for rpc_pipefs
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
Date: Fri, 13 Nov 2026 11:13:00 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
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
> Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0net/sunrpc/rpc_pipe.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
> index 9d349cfbc483..37277a6d2415 100644
> --- a/net/sunrpc/rpc_pipe.c
> +++ b/net/sunrpc/rpc_pipe.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/kernel.h>
> @@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &rpc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

