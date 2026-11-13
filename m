Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6A4606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HHWb0FY8
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtLs11Z1z3bf3;
	Fri, 13 Nov 2026 21:11:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::432"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564661;
	cv=none; b=f2vSHzMicv3XGvhDaKYGJkrDfNVA0k8s/2t/TgBBYapDYg50W3yKlqOY5MSiJjrNyybEtZZJKJad1QbniEiwUxkKFY3Uch0c+xyp2AgZ+J7KDKBW+j2oHzH8ytp7docxFg+Tf17RIAZkCK8LFqhGZL+ZO5J5LTOhv7cQOF9Stn0lCuaAAeO4skeZDuhJdDKNJYDFN6/W5SyWhEyWtEGeklvLXzCH6C4tKDcbbmP7vTmIneGqQUJ9bGzgub+GaJ02XlQbCAbQvR6dYRJIajWuZD+F2TKyL2pjP+PZVoR1tEyuLyQ22uokzXBkxcI9gVMppwrR5y3hGOjAv50DIi+1fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564661; c=relaxed/relaxed;
	bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hxK9uST/txfpKOrMMSS3vJhR/3zdhhPSxeOJfVqEs4JnBQ+bTsywcGzixjAD/dfI0INPVPdhZstXj6TLZ8A0wlqZ+b5t80QVQgUV/2YMJvg83BRqW9Jm5IAKRuUPZsUz5yG33zeiyC3lf1IgNvh4B/b+FM5J6m9jhY1g13JMWXh+al5Ogj4tiPIUWnIKOhz1zIiu39HXWEVB66iv2P7O11jwuukveSwsf+nHXmBTwJ1cJl7A5i0YbCcU1+RWpQaM7jbp5Ir8KgxICPdZBjkeulkN058MblhBksjuyXye49SsHG8EikwEcKhelwgOJn7ncWlpcYgnHx4BLIrrNoJ1mQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HHWb0FY8; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::432; helo=mail-wr1-x432.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HHWb0FY8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::432; helo=mail-wr1-x432.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtLq4vvrz3bd0
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:10:58 +1100 (AEDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-490d59c3edaso395272f8f.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564655; x=1795169455; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=HHWb0FY8OU5UTQblznlRwbnF9h8XWOlkgY2vu9Z6d4Vr6Nef0THqPgWhFUxKHZlvTZ
         IeTRyehnnQFPJMSTYPKmhgSzRv0lqIWqZ6xEl2UdwLz5krVaFt7jo9gsLHoPEnfJ/xt0
         LMF025ivN6CP+9+4+GsSj+wUNJMfyQZvKs1t+p630z7C+fB4b8Xy+y+hjjO4bjahLBBv
         ozjYs28jKIQgZQOh8DuFLK7HQOXY45U6AKsNY/85zBAYXrmKnKqQJS7t8HR1kjjQx3ez
         NQ0tsrL8JPPEpgo4XOqESrkosPwCPjo6s5L3qNrpQrwvT+QgBJrjJwXpA7DmWz1+puuD
         FxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564655; x=1795169455;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=JyTWCDeBA22UNWfi+5KQxFyzEiGwrcHk5w4Bwk/kgkmWFjtigq1tQAbyQPCYvVrzzA
         +Tv7HnU66ho6QjgkySztA5DFZPnpdiixZw48sty0x27GjHlkrlEgYG+CzjlG24l+nGUj
         QZMFTszacQkJ9U8KgHyLwMbRrq9adt7iIlVFRYsIEQqlt/8fuYllUheBoyIPDDaiErVT
         lfdtCMPFiqyD/oWlx50CM1mj9O6Qoh9BjGY1B5aYZKmmT+CkWOgwNLZi9FAB/EHKNCqW
         08vVaahRclVtinaHdG+Nf2r8U68R+w5pbheuRCTGA+9xjDAHTXLcXodd7e9vEGURlkCy
         fO6A==
X-Forwarded-Encrypted: i=1; AL+hErERMJ+r/bXMH+Vdob6/zGnS+kEXbH/LZSgBzLX1exWN96v/qAY4665hOMrFYjUJG2ObQ4y5tJ/zkx9Sfg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+YLgUtY0vSCRt5xI8al0Kw38gEZpYARziNX/Zyqo5G8o62pjIb
	bnWaTYRzCT9gmyu1C4ZPGAjUogcDurgWXdMvZ/YruM/jCj9PIEgC4K/d//P/CpIJX45N
X-Gm-Gg: AYBFou2n1zM903KslXqP1au/JdzrZJoV1gHKH6nitGFN0ooxhc9DB9qzxhXgQWPda5H
	n6O7OAwuH/ibfdBOSlBiihYN7Pn0u0CHKzW8+lHmAzjrSY5JOoA1LhqUFtkXxv7R7QOyu10p+S/
	9BMKnO+um1ZmbIRwE+tE3zgkB40bQGWXAzdFjcria4/SjD18wFfXBcpb78Z9ocMmjsBQc0QWN2g
	vBXMoHzdQRq/JpMBT74oFif2+qtxIoiqyvdTVdjP+iuf/FRRezF9m90jTMSIl0Dg2DFykNQDhiz
	F+LNhppxSNhzOQG7IDA7ZNM8fsTOVG5/Jrw+pkKOgsZtxzNgZFfWXXp27hEAgpHbBgEWo7a9MAh
	AUn92pgV1jZbpe0LvIfJwf0Vn1KhKOrqhBdJlgqM59dP/P4IRnEXrZtVApob54lUxZvFStvbVx9
	gM/a5OH7aTNc152KfLxdAa4Q3PtYZW/9OQsHgoD/6QLoEyZnshr7Y4JmsmpOZdvzJNAecHuJMIU
	ak1FQHV8UV1QLyTsz0oAMzPXZfpPclSyeaS9Sbno2gGT2WXqB39L7O1pmb5SqPkvRtkqC7HgU7K
	Wom/Dcl6bfmX1YOLBdfqgFgoefHFpnG2FUetIrCmu7L+NgIpiMVUa31kYuJNu4Q=
X-Received: by 2002:a05:6000:470e:b0:499:ffd4:f519 with SMTP id ffacd0b85a97d-49b02d4c2cfmr11662822f8f.23.1794564655454;
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm4988050f8f.0.2026.11.13.02.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Message-ID: <0894c601b3f3c5b92008c6c399faaa539b658307.camel@amutable.com>
Subject: Re: [PATCH RFC 17/41] securityfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:10:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
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
> Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables
> or
> device nodes.
>=20
> AppArmor puts a .null device node into securityfs but only ever opens
> it via dentry_open() which doesn't care about SB_I_NODEV.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/inode.c b/security/inode.c
> index 080402367674..93997a9f16fc 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -14,6 +14,7 @@
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -64,6 +65,7 @@ static const struct fs_context_operations
> securityfs_context_ops =3D {
> =C2=A0
> =C2=A0static int securityfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &securityfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

