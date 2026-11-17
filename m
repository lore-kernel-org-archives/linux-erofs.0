Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D6606A338
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 08:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JTgW99Kd
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTHrn1yLSz2yRn;
	Tue, 17 Nov 2026 19:26:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::436"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794904009;
	cv=none; b=TGDIGIEw1m7qszObRzmUNbpMmI13n2i8AhoQP4yUCsVi0U1MqmdPPznXpIKPi0bRxnv8Jvhnom5JWtbPJFGdg4hPxtG59PTcqaBmpesicqRsYdAW42DVOlk+fdlC6rXnocrTlf1N7xn/PU/Qzr/77SQfsq9trWDnWXWJT2r9POuGlV+48sBfgx6cVC6k6j5dd0warp1h9u1VdNlNgtpfNNKKOwKuRVm6iXwY99ZASSKKNS58zrkz753kqFDlQwURfEoDV5s3SqEK2KprOItqiIXsUe2GNt3zdG3UX1ZMTvV1jlyAlafqJSXp93ianmL4g9NeOvEKoFIuW0v9dAWtXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794904009; c=relaxed/relaxed;
	bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZZUqA3yOetFN/zbVcPOpnE3pBn1DAB+PoxLqXLnop1Gs9uMOppzrwQhJ1j7F+eJytJcsRwx/NsFOGwSzmwTnZ+7ibKJ2kthY2LUNgkMkyDCbMsxsSeteFZqWHGANJCRLqp2rv5CGXEUDzXQdC0ZdDozUZgGnMWEcCcG/GFJ/gdQhfkzSfvE/B62KOzMZlLu8yik3IHXKv9gcVeu4PNDjAc5Bs23LJNOtko1R5aMEaTz/bCvC/g56qdm5kAb2qMlvx7enYD096MQxPkyp3HsJUNfE1LV4t1xahqjFo6Vuz529SYPB536NXQ982FtfW6tNSayfqyUiglZ+XAi053nlSg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JTgW99Kd; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::436; helo=mail-wr1-x436.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JTgW99Kd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::436; helo=mail-wr1-x436.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTHrm1ZPGz2yD8
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 19:26:48 +1100 (AEDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-4a358881793so374284f8f.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 00:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904004; x=1795508804; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=JTgW99Kd4BsiByFVYcf8RXZHxX91pIoM/e8I06s1vA+HqGs3H3NoR5grFAwDdpfsP/
         +73JsinLnNSAfgg49DoYoUTcG06RhV2aal4yfANnd+v+7iVFm/Si5uHApSYnDWu9jImA
         3mWPU9DdPvsSiR5nVaEzolkIFiZnbS7Elkl7BGBR5rXlyZnNhaHcVTV6S8xYp4zw0QN3
         wSYLqtFkkveMlxI7WzP8Mfc3p+IbWFaZHqvllw60Dyo/hdUZveipBey/1BehcgufphwK
         3+Auvw1h9B8OfFq/2c5fNme9/CU0aY+ljetBc4sZ2hoWmpYCaBmLiZxo3SaSm1TmjIva
         Us6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904004; x=1795508804;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=uUKDXtbLi39QvtFO+Fii3cVAVEgo5jaEYXffPM2QloVwI8sW5eM2YphrHLQWc9lynP
         sT5wFWy1Uw/Mz/si/0q5qRzUGGTOGSXXFLTwbE9hD3ipnylRqgq8X7O9DCbxpdQHLhS/
         e5NfCvY5o50RFAzwiQ+CQebz+G0xYq4/DmLawtIHC+JrldWQJfFNe9YZ8ps7GzOAs5xr
         x6KVDmkJ5smz5UFKHDiFiFttLn4TWdGz/6ETy4QQ8tMmVyjENOwV81CBUGOZjilIn9aL
         Q1FPkffzr2CMtkiZWkoWL+GewgQMc0YZYs00ulxBE6k5wDjWOUgRUYiY2CooLHWsak18
         inhA==
X-Forwarded-Encrypted: i=1; AL+hErGER7cdQ8vKNskKosiCrbdMDSGBY4gHXf8aITopO85sHR0xPC4I8Sn+BJ6cvOEZQZmHRK1nq662R0dJOA==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/fm8eQUTxCkomlyj/N4yTjV3t+QJLA1PeH93sT8Ibqd7kbNOms
	YFNgbseblcNVIZnjorM+dBAun7m37CBNy10aHfRiXnHYZEbBbXMZSKP2bELl11eudxMN
X-Gm-Gg: AZFdTZdrp9ZkL6Ji+TkgnkPzxHfQWumid9cROn9u+vthsy1dJNqTNvxcNm1taDuUDUK
	jz70+g6DHml74PrA8vW2hPJCcS2jVJmtVktpzjXAgAAi2U/vW/uJVSu9gzjr+1W9c1/HFmiwDVl
	cAM7uo4StKmwoT0gAX2jdstSp0vv8QZiRuDI2siWvd4S+lzQLjVhMK2ukSQlBhWHU1nrSRc3lhX
	JrOgUKyb5UaI9LsjXtYD2UPqtVkeE6oMVYL93StKd2MSV8tIML9kDzGrlvrFwvjpRHAFXVR9rsR
	AmaskkSejQhQyCAbfQ3tbZPQyMDxhxuwvs5DtGPUtZ6ly8A094P0FpdBmpuydLDpfSvYS5wne92
	f9JYa4sBc8nnVtRsdWx9x54RPo3N91UY1z+Bg5T7yPuwtZMo2wvxtxWp+5i/PcjIAYmw6l3Ypyg
	9drTJEf6qwws2sbr0/AIpm2pinyDTvGyX9puuU3dLtE6SGg4Z+7YStGbGNWuXoq7za5LGOrUCSW
	jEao8xG3j3IfYbl7GbfuQFKWdT+V+JwTpozNzPmq572/VBOVWar5kAs7BUdU5R1CpZQsXxJG+Ck
	DXvXo/uBdmRvBnuoMKBzyFrJ7JIKJaiacqWmKySJglxSouzNDHIfeTeF5mceWSdEMoxX0Ug21iz
	RzuH9HLkF8BRtdyjfxHSf/6qBuvhxGazONFatqaJjKPRcQmm2kXddj4zR
X-Received: by 2002:a05:6000:2009:b0:4a5:2e5b:51c2 with SMTP id ffacd0b85a97d-4a52e6a947bmr243585f8f.29.1794904004601;
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a4de4cb1c3sm977858f8f.8.2026.11.17.00.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Message-ID: <c43d70badf41f62f8e149ac024bab3df979fa756.camel@amutable.com>
Subject: Re: [PATCH RFC v3 11/44] failfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:26:42 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
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
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/failfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/failfs.c b/fs/failfs.c
> index 437cdc981c2de..f03334f361c0e 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_struct.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> @@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fc->ops		=3D &failfs_context_ops;
> =C2=A0	fc->global	=3D true;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0

