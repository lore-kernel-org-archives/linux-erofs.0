Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FCC606A8B9
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MD2K3k9e
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtDh2w6Tz2yhV;
	Fri, 13 Nov 2026 21:05:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::62b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564340;
	cv=none; b=cISbtP3GFCiAgD7rGqscXERlTScXZ28ktW+CX26UqfJzMzuddq7ZtrAe7rGWUpmcTXkLbV2ScOLnthp8zqeJbXgYxZ9VCs6spwtSNoYPvy97ynwopHjjAVeSjUThJOdwGzElsy12hQPB3SYhDhJB9JO6H3+2I1ileBugQEgpmM8A0mpPUIefb8QmB66TLw7DmdhZdS2l+J9px9ORzFW3trnIOQUnOl/ug6akoyd8rGej6o4CmyAOtVLvlEjP+js8VFgNTqbfpVNNwTkEpgGvGaoh6eTHkgfbrPlzd9QU1JfICrcP1aIt9oiCTvQkIqxu2tOiRowfLXZhWhI+h9deUg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564340; c=relaxed/relaxed;
	bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XK+m1tuFVwcRG4owGOnU7SoW0RXXVt1EKj9n+mKSqCy/OECtl2jKBEz+vGRol+ZrRfV/s+LkubbO2wTDlRTxCo9Wxbg5hxon652M3ebqwHeYxkJHYHCqLjm2ZbqX2fCHS8jbRNfg79qXAEXMFnNoGp2X5USEKjvYh1YAVdwqmai0TORN0WqEb7Atn3ehmXAAM78HKGUsIZYdOd3SYLS8aYDt3+WpmsllIWaJPMugM3FIHI21Fr5nP1x/Z2qCsGNpFEEoY81M5aAEKERogKKyCAcVlvmleMBKNsOpSw+FIHoafjQNf99aHrbdUh5gJZFqfXDEZMwJDFDpzgN25fyjLQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MD2K3k9e; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::62b; helo=mail-ej1-x62b.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MD2K3k9e;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::62b; helo=mail-ej1-x62b.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtDg1H7Gz2xLG
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:05:39 +1100 (AEDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-c40f29667e6so164617266b.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564336; x=1795169136; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=MD2K3k9eOD5vy390FSjndCNl2fr6XeZe6JAIZSL+EAsrC0Gtnb3T74I/ihBEyL91SD
         VsOuC8f1J0PcAz/qz2QFTXbVCk5gJU/KFqOb53r50BYCd0/efPbs/nVQ67zRfBN2yivp
         56/G9qni811vPMt92JEko4Q9E5MGldYkqGKPMX7Yf1QGOpqpHiDLQTCHZjNSbuS5Mgo3
         6b1rZPE+3j73d2afGdNdGrqX+P2dYFCFdqHBz8OpVu4OgYtvRAnQTSpt2twoM2bLfEPh
         VGtNsCQtJhpz3Sd3ZgoSY3iCiDXeRKDGX05M9CeVGaTsDJrCqg2wTmGekwPwCZidPjXZ
         7hDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564336; x=1795169136;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=LQ0mrQrB7bq7tX55Wxnkzbsi+d5pgU05v1zKhzQxpbayC8BsFWvlnZNQarr19SghJh
         wLKYjL3R+pNWbZIUClXZVtNjxNCRX+b2NdvmU3H9AwnHLpM4ZXG1gJ9TnqXgBL0w6veh
         XUJeylwg72WNzCQVobwtsOBT/I8feDfKf6mpccDFxEpQMXLatA/R4GbVYYj9NnoHVPVn
         jZXAAwmCKW9+obRlesdjIbUcVjlaLuwhmMZjUHPhRnop51+inu0kZI2GTbLqk8Oo+VJg
         w6cogC7nqE8QYpri3/BNb1HTllPRKlae/Lx5rlsskzhHBG42d4tyzgJgKk4Ob3QbPLVe
         fCVA==
X-Forwarded-Encrypted: i=1; AL+hErFaQY3XBZE64YYrn5saDJucAUWcIZsFzUYwd+C5FrKYHGakRazZmlBHYubosQMeu4vwYeoqXIK+g+8FgA==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+NjBsqUiOBi7f5dDfHReyHKlsW0NKjNWdat4quinrwh+tku9MB
	9VMU6sr8HDxv+z7E421VzzCiBWennE/8cGaFMx821b8ZdGIId9d/791ykMRjUm8mT3w+VvkkOac
	KIop/+cfUTD0=
X-Gm-Gg: AYBFou2i+a9oWnGv6rF1Wvm4RhG5ANpTuNmJY+Kc4ag9zLSIN8TyKoOjCUSXl2Mjdk7
	k6nj4IR9hXDLhnRLyVtqRrUvrbLInFSs1DIzkK3tVukVSTlHq029oaPLHDGFPI7Qi+0vyCZEFJd
	l7nSz82hrikEv+34FNrRtdHPxyOARi612WMg7n/ItcAOUsFh2w1U3jIsT8sOZzfFFYTFcyddzH5
	gnqT8MFU6ioqg5XfGUP3eCCrC6GoMNaMUX6n9sKNpj+6ph+9biPZHYDeUrcGI4tSEOiVE0zept+
	jAJl9xyIThzB3xljcbVpynMxENV79OT+ZgTUOZxmq91xsAIvBaszlcKBG6HKkK4hZORAAa10bZI
	W52U5G/+livfB88e7icV8Szq9YjR72HvejSOkod6kkEmX4tXQim/5/w03TW/GAWA9SY09heZvNU
	22czHYBu5NNlqqMp9LYs6MIk8ixwn07JGUkB0U24TTCkgiPGkGUpR1ZWmQYrifUwtSFsAnRWfi3
	+Um4yoWf9Pfs0hzCLnAmIpCfySAtvBFNcEhHrmOVLDT6T3aFYhxYRL4MxsOqZ+lI8WHnTkwJjEh
	+f6wrmfb6DTRxqdedcNGuVstbOPoSW55eULaGMNlegd/vnBX7B74e7FLuWGY93k=
X-Received: by 2002:a17:907:608f:b0:c43:eae5:ee80 with SMTP id a640c23a62f3a-c5096398b03mr148720566b.17.1794564321873;
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7b2c9sm75811766b.73.2026.11.13.02.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Message-ID: <08fa1be263cf4a3db6b3e5ec2847107fba7acfba.camel@amutable.com>
Subject: Re: [PATCH RFC 13/41] devpts: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:19 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
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
> Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
> SB_I_NOEXEC. devpts never holds executables. devpts_fill_super()
> keeps
> clearing SB_I_NODEV for the pty device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/devpts/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index bd1e8eb26edb..47ef12241d92 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/namei.h>
> @@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct
> fs_context *fc)
> =C2=A0		fsi->mount_opts.reserve =3D true;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &devpts_context_ops;
> =C2=A0	return 0;
> =C2=A0}

