Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F6D606A88C
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Jlzf20Cp
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQt9W47Xdz3bVW;
	Fri, 13 Nov 2026 21:02:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::535"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564175;
	cv=none; b=jhZk72gRat9lu1UjI31vL3s1KZe9oCw1E7LjRKLwN8E5igdXe1bFRA0431ZwGpS7vC1Zo2QqFcGgxDYzWRJu3CXRXpfMpBppRQjyV3DDm3sfpjcHOwkNOAipsqfhD4uT/aGg4eDhh/bd+ZTlESe9CGG4eY6mqOq8c4e+oh6qi6IqFczLe7U5MElXZpAbBxdgCV1JPcSch/o2qYAxrPM3Fj/PbK2XcPV59wZa9BmcKMYJ2UzKHjySrGbYztswb9NxCTmbzRd0LFL5sQOvtZudufogpSlJz+IRPvxyZF8zo8NByATr0L7uESrLimFjLNaLaxoxD0RUgsqivow7KbQPAA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564175; c=relaxed/relaxed;
	bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GUwJw8Smj2ICmYQLZorIqOFJF9X8PmbVuU/ECMtlD+seZ8+4tyGRdDBkC4SzluktEd/SzkdaxquuRVN8K9V/PxkafJeIUB/jonVzzVGx0V6ze4Bm3ShrleaJTgAu1dFF+1fIwubvE/h0wvksuWKjBLrrEtSjurecXBr8+IQXm2RR83BdIA2OfMOInNw3Ex8ljkZXL9Cwgcx/KzCme7jw4zwgHOKH7PpuskS+2G8tf3JC3thXNJDp/u1lbFAOjeDR9YJpaWBdPX9irg+SxVbNSBfMu8IvGHURS4OUPW0Xakemr9us0wTCknhCdhiiq3QLlSn5AxhE9oqn5Vj/sfyTKw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Jlzf20Cp; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::535; helo=mail-ed1-x535.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Jlzf20Cp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::535; helo=mail-ed1-x535.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQt9V57tZz30C6
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:02:54 +1100 (AEDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so1163226a12.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564171; x=1795168971; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
        b=Jlzf20CpqdukFljg6Znqq9A4JMmZgp6Tj/WBpnweI9XSbsOy4+FciRY1cOEMPfqLS9
         4+JcpZ+rZHIzchA6t+4rB/67u9Wd98UEG4nI7irMp2x3BqexdB5RmLbQI2AcvicR3Ded
         OZoHRig1/Q5K/47EL6cfal61gxTB3Wkv/LNADqI3XQ1jp2kvLirMjJI/Nx6WICvdoe8u
         +6+qGn+g6S27REZDVk+aicWECsLMXBVMkjUbF5uqJ2VSh1k8Yf2AfYuNTTytCuB7Nmco
         P7drLtr7uY3JljWd1Ch9W4pore7O6XouzlmVqT3yh6H9Dtkybj05ePMcYVBk92Z3N9Uf
         0n3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564171; x=1795168971;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
        b=DoWYLQ30KSEn+liK/7S81aPbnGffThPmELaCTX209zfj0nKPU+fsFnScxhNOWHm450
         ZuPIQk1yU2ddstn61cC69UtmTgyFOKd3sFfbpDDB7apgcm9H0ItMXfPvDmuU9J9yfBQ3
         Y/CYGLfpkF7IpsE0STZqwhbE51uf/T8lT4KsNnn2RoG2NEjMzPkyeSi4Th914AjwWilg
         Rjx9l7fFjWG40b+eho2l5TV2us8ccbhwy3O5yZY3Gz6q8zZQ6gSARZ2jRuh+rezaVi3y
         JebaI2ImPms0s9x/tRogguyBuGIUltOmLs1LN3YbKTx6VyROtF5RM4QKnEmuvD1j3MJT
         13JA==
X-Forwarded-Encrypted: i=1; AL+hErFWvh0aczkejd3zfqBDFjDHc4hzfMPzSOmhqNpMYdKM8rl3fK5QxuVmpuoHJlSOB73l8HrXeznyseAP5A==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+wtmxjpwjfDi3DHCn32k71RN43nDzfmPFTfUVYQ0iY+CAJqBS5
	0ws/9vq9ztHPBVURMSawIAUsDuuiRySd2w+vg/4vc+LBvq2CA0ZZMA8Xq0pN4HVKlttu
X-Gm-Gg: AYBFou0QFbXbdiFYwwyP+NEjdER8sY+gNVT+9cXLV8KGxsAb7p5tQT4CJLrLQjfzKel
	guKw2eC8L/I619we2uvEnlQLxqj7SbDj39K/eV+kKffj71zk3+d0pv5rtmzvwlEs6YyBUd1lO46
	vFjnLk9HABoxNkmdoCrEpRT50Ovsrp0ncKpIdj5NfxziaGyiVj5YBEkVcMiiOgT7VlDS/hoK3Xv
	WCMtXVUiw8Enm1cHtxhknbZKMgw3OM2WxfZXJHsoEzk/x1Ogr45HDLj6DPJ1zYJHJwsdHul1DRk
	bL6QW3/WppK++G8btQtvqXslTxCJcVI3unx5gmsQo5tlOFTZC98UNekRNZAZbPeaSMZK9mkNsLC
	Yzs2+FlN6sXay8T3PctFNK3wgyOV7cvq3wIGyT1l9fqWsvixJfd3UDmx0H0YVhFMRMxaDHwgF3X
	6LrHrquplj3drtAA/J8tw4UN0qLR0vq4oIZ14TWpLSo58/HXHm5827Gigl6d15k0qUWX1XjsQ0i
	vAjtzdpH/riMOK2Ro0//pydf2w2l53lplebmwX8/jL3hcmVtwYtFGJOnfgYBXTMeTtSMCHCGiU0
	LcWsb/a8cqePocqMytFua1EUqOe58/A7S/DBmBXa9eGTcJ5W/TLocg+IfAml81M=
X-Received: by 2002:aa7:c842:0:b0:6b7:82cf:f69f with SMTP id 4fb4d7f45d1cf-6b7c0ceaefemr1298014a12.41.1794564171137;
        Fri, 13 Nov 2026 02:02:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c262338csm739270a12.33.2026.11.13.02.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:50 -0800 (PST)
Message-ID: <06b194053de4f4b65895248d1f2ba29d42a21b17.camel@amutable.com>
Subject: Re: [PATCH RFC 06/41] proc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:02:49 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
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
> Initialize procfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> =C2=A0fs/proc/root.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 7fbbe92bf73a..ca0e75081934 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -17,6 +17,7 @@
> =C2=A0#include <linux/bitops.h>
> =C2=A0#include <linux/user_namespace.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pid_namespace.h>
> =C2=A0#include <linux/fs_parser.h>
> @@ -265,8 +266,6 @@ static int proc_fill_super(struct super_block *s,
> struct fs_context *fc)
> =C2=A0	if (ret)
> =C2=A0		return ret;
> =C2=A0
> -	/* User space would break if executables or devices appear
> on proc */
> -	s->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	s->s_flags |=3D SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
> =C2=A0	s->s_blocksize =3D 1024;
> =C2=A0	s->s_blocksize_bits =3D 10;
> @@ -350,6 +349,7 @@ static int proc_init_fs_context(struct fs_context
> *fc)
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(ctx->pid_ns->user_ns);
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &proc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

