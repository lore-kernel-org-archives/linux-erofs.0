Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B26606A8AF
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 08:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WukFXrRW
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTHzJ51RQz2yln;
	Tue, 17 Nov 2026 19:32:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794904348;
	cv=none; b=MEUmgGbGa29A1tYOlG5DXsyEF+vbmsxqXV99uO1SmuCq7fT/ciw/XZVudHHqYc/LOxeo71/mx18Z7PPuz5MOg908qu0HHqtpgayjL6oMScHi6AXe/ihkFGkbnLPWijlrueRVvGbX8VpBersRxUPpYYoLjiMin7gj42a95q1WiyLOWt+JyZhknuBl26MN8Y8z4lv09KJ96t3S3xJ0JyYQFgZ5fU92Y7U0f9mMNSjWvsZqmZ3bTdMevsxoAHExnG5Nqr8PLFs2fggkSUopG/uPPI/qaARVVSG6FBeQRqnCRphW5/shnmEHAkLyi4zbZBGq1190uewTYLKnFi9o+f5O8w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794904348; c=relaxed/relaxed;
	bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dPBxKSEKYZOCPUWFZm5j22R/UUYNfGC4v/Ui8xScTxnA1LPUl1Q3qtDtbFpPT9Kn8k5vDlSqGbwlr143frsEsKrgJFp8hZizthT7Jy3roWnB4DUKr1QeFFRlm6K2TqzvNnYgm/3IFpJzgW0/FbeTFKpKzpgbN8kdENkW6gHykodRLaHsBPI74m5Kv0bGZJ1hW4WGNs3BzWBNwIQULq3IayRDdVvRG5sFNv8Z2Y8D8ew1c+aYgfkryaRevLpLWeFroImsHYRhpj88WMYkbk/Fa4sOHrptWbWVcv3UsmSJl+6G5KlRuE8aJznJ0oFqg7XAO5likQtlm1nAnps6M4vSdA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WukFXrRW; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42e; helo=mail-wr1-x42e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WukFXrRW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::42e; helo=mail-wr1-x42e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTHzH30wdz2yjp
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 19:32:26 +1100 (AEDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso178006f8f.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 00:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904343; x=1795509143; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=WukFXrRW6eO0ufEScgpXNJcdFyJFRY/rlh/5Srp0sMfWECo/2SS9xq9xqcrj0F67i7
         lnRcoZEP+Hn9uUV+WdSkN44ZQv37AJhGJYHQLcmOm3vjNpCWwC3ddtLEaUU63nMHZgFR
         /+eStEHG38Y4qtsW2Ro/gpWG+DtzQ4hE3sb9PHlVvbuYZ2apqc7VoSP1Wa3Onejmppe6
         +fVhcDHsnGEkJayegXKICykrV0hkMq7mQLSXug0c3bknRdCft+ILyL4QOog3lXrTk2T3
         CoGmqpunt+10RaMvLZIgQNJNdGHPCj+yaMsHpj79s6ZxxBJVJYSivUkQPeOw8umbj492
         HQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904343; x=1795509143;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=rwkZVx3plf53ld7Bx+YdyHlpT/FyMAl+/pQuSmLns74W55dqdy0LESInruHNU/2tlr
         fmRQMwJZsqwcd4hRiLen8FVztEuoNDPOUA0kNq1/qlyvjTXDBArS3Ys1ET/g/Yft76xY
         unxxLGxQCq8XQ1Oy1Kf3UfvnC2k9jHAsR9DZP4HBS8At/XDqu9sQhwuOE8k762vrA6Zn
         EFa0sMNYrFOjdwLeMWscI5cGWZnQvqRkXDDCPmmIX7ukuRGVu+0HcOCMVPW1kuqhAixB
         JDdvZiNSEFm2lCHPlCoRj2mgrs70sAYnkQofCs/2fCg/JOXZDG1EsDrqUvfg2a3vj6Wu
         co3w==
X-Forwarded-Encrypted: i=1; AL+hErHcGzXiIXq9qymCuRk4HyRH21/mWDvBcmsLnjoIPHh94gGC1APCcjwiqvn1wyjmR3rR2R4CwuxMohF8bQ==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z9Mwyifw3bb0yN7347JvgIXlwv+2ZDj3IfzqL0NNb+EzG8n75r4
	BgW9v5Pu7BBVirbj/PMQFbdwvtproHwzZPH50B8rPSRRuyZLkwZ6E6Gg6Fdh8o/4uLv6
X-Gm-Gg: AZFdTZeqy4bQ9tGo9BGelTHrL7ZZFX5R3Gbix3PVK911pzHTZEcA/aLG3ojAmV0Xinu
	aqJ3+xAr2wWS3WzQsmZVbdyobbO6IobGqBg6TfWdiu3UW4KwyAaAPHvRupDmNhrVFTsc5R6dety
	JiJ1SHqnCrcchofq7C9/4M1RTtW3wos1DuSpqK1woPJT9/4XpYSSr/u0cloQpehtT+8nwrPSoVk
	0fu4/fuSjkTeCuXQfXNkI9qyyu9MONhqOKzsKLNNKbhXrriReNcr6PwLhjyKjMztmzFxn7KdOAd
	ctmErcgYndR1SSspD7Wg5iOoPqB/RBwxf3oU3oIyx/HGwJwfGYBb2Y94ERF9yGnAwzh8HXCYw5F
	cN5yHuPR0DuMEwfa+H1WyTGdoWdv0mlHmTuEnrkOBiJj9o7fJlq114bN6kBS0RnO08NNPnGCun3
	953K/ZT5c+vaJGXKNR/QTaMoXFJcv4gRB5iuc1tD0zyLMCH4UakVp31OLICLsPyCmLkHZbYR2ut
	P9V82vSg27Pfg6okEJbYiDd4L47fXFcVqdfx1krzVPCXQI1lJF3iO5ZnF86b9CIaGHorhy8ffyi
	icGAvFzL/CGsPet94+XMf7Ojl7Gi34Qog2j49lWkbQ6epy5vzeGF8GAozExmlTXfJdu1vw051qa
	0qS94cFr8mFE3J2ilBQEMixW5TBDZtDnAdRH9/h6M/zb66sMmZywx1TxF
X-Received: by 2002:a05:6000:3108:b0:48d:f9dd:e3de with SMTP id ffacd0b85a97d-49c7353c415mr27089117f8f.45.1794904343236;
        Tue, 17 Nov 2026 00:32:23 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608d10b2sm43646659f8f.44.2026.11.17.00.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:32:22 -0800 (PST)
Message-ID: <fd39200976086130cc82d59699a988fc3e0689cf.camel@amutable.com>
Subject: Re: [PATCH RFC v3 27/44] openpromfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:32:20 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/openpromfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
> index fb8d84bdedfb2..6cd02d456bac9 100644
> --- a/fs/openpromfs/inode.c
> +++ b/fs/openpromfs/inode.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/string.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/seq_file.h>
> @@ -419,6 +420,7 @@ static const struct fs_context_operations
> openpromfs_context_ops =3D {
> =C2=A0
> =C2=A0static int openpromfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &openpromfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

