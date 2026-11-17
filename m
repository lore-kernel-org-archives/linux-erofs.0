Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96AF606A88C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 08:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EN3FAQ8B
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTJ2V3rKmz303B;
	Tue, 17 Nov 2026 19:35:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794904514;
	cv=none; b=KJ9pwp/KD4bTGqJ1QaUDUqDlAzSc7UEHHlH0/OZSz+/LJVwO14h4tvymxHH5uOmPAprPuSAXwMRRsz46ANZwb6Dwr47R1jX9pB3yuOtctSITQ7JXekkX+t3od3e3YlM5zupRhzsIXiq90UxgOQQiCWlRnCoeR3TQRIgG0mBjVln4l6x38JiXHgNYezlJsDaE2fXKx/tN3yrqDPRIFtrxg3Ya/3rpyM4Ezbubg4FEQj9c3i5rRyCmwEQ1O2K4CpovxgIGXaiDIYnxaGNcu2iWJdNm3EmFDfJ8f5DZLyFpf98AVUBB4nhbOKbHJtKiCAk5zT/tWeRqkydUIB8Vt2FjFg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794904514; c=relaxed/relaxed;
	bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IiJZ1QHIg0MsqGXjQW6WGhpMqKfJ/mvljxZtrhJimcvwlN2q+8uqbZ3xbjmyhNSgUfFjeLOOU4uLaR+KSh/HuJNvNEbV932LBzDEZo/Z/6dVLjaJGmgB+WmnehoJc9112LX63UeSyUZ7CulefkigOxwSc+UlFoBqaGVBsCcZ9gFfcRw4MU2wsmugLq0pGVdebW8RaPWhdY0h7FZYcrdTlFxQH+tnT+MMXGmlDfWmWojpYs/wM6h/9UInd2WR3ssYHoWjjnEccewWcFoDy2ybsgUzbyOb/+61X6C4RnwBTEva6evg1Aki3ur6al5WH2wwqMSKN4dEUUNXI80522yJSg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EN3FAQ8B; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42a; helo=mail-wr1-x42a.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EN3FAQ8B;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::42a; helo=mail-wr1-x42a.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTJ2T4zZsz2yql
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 19:35:13 +1100 (AEDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-4a2f4ca0dcfso581583f8f.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 00:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904510; x=1795509310; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=EN3FAQ8BMiImgI2/cm/87UIZw4BtDjH9L6jjiSKVoxQWA70l6MTU4pWCygBY25oRqh
         tlVeCDSMdpe8sx8zAol/DZ0Uo38aR4Dhdt3fClE7YjlLlzrtz93g+pd3CKk2Oonwe+YF
         NPuqWoI/AYljAZDDEJNNT4sRJ6L2Bf/70AE/2yzCQZA1v75MSmJrwIlq85L1p/1tC5qD
         KR42uWLxE9/xzXUUmkEOcrqJKj7Yjx80+/j78Uqv5UopdxIu/z4fXHu8vqzUjUaZA11w
         xDt2kWDOzGIJ8bTe/8XklLCq2qO2qtHNxmTRvL8wlWxFH67UZ/oQqQnC4mvhaJ3QYb5+
         9pFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904510; x=1795509310;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=nNuF6JP8b779x3g1dyv22UHRiyu/GenJz3npW5m6iLKwhtTfwqYvvU4YyjfVACozX1
         KvoxSWhlVbW8s/2lUhBhJQo0fSeTXnR0EcP2DAe5qSd9yNKmmlAbyRxxHyqrzBGKkYSL
         S3X4wQAcUkagg03V1WN5VKedVNgfshYTZwqe8muhiKtv2jxGIy04+c3ElEQqbqYgiYwL
         f9z/Vx8kOQKyfjpEPls5lObZXTITCtvI+pfu87I2oQycBjEGeAdV71wIBK3M5/xQNJgf
         7b8SmVIqVQYTae1miw4462Igt75BHT67mJsSm6D9A/mJoGr5tDdV4pTYX8RyrfoyEPsk
         CvcA==
X-Forwarded-Encrypted: i=1; AL+hErH4Xcxe3R7TiwoAXzbCOTL297NQVx8awjQOKQ2LDqq9CDW2kgvjakSJ2twoB9vkbPXU1Ze9fQz+FWVo9Q==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+Dx76Fdkjhrx1VR9GpA/mJImIl4pVG5JRZAL67ia7fU6hJTXrm
	RpEshh8rby9ueFMOBE+qjUyEF/caceKB0tdbRabGnfrBZGxyWebUQvqEPkLifVr9ZcGT
X-Gm-Gg: AZFdTZdwH8YzV2tUpNmvaPxfO1V0PHGXuTWvBlM6nFzUR3XHwHhTjAr3gOrnmqE0Wua
	66Bp1qrPh+heGvzPlaepfBGfdmOISajLuZn+8gPDcUuvAtYUdMvi4dU5Tv3g8ftGdZBMzq7ZtFn
	jp0Jllx7AcugGsEkXS6k3eV6BsqoWXVMleScqIFNSBVvOjQSqkl/ATi1y+XQD77gyXdDNVod39h
	nsGwc4+gZ1DXi10iC5GULUKjet6tm3dX3+dTtNZR65pYx419y+eKsQTBolduGStChiYdM6y8RUb
	nlYTr2M4t+7d5Q6qHK6Ap1BDdfTkSrugzBEVYFGzDm9a2kXicrIkJuXmvG75GLq+NkL5SrNCfqY
	9Q1MUm9F02c9CGnRJtpFXW3P3RW4uFP5oK+DEpy2zlcrf53ns9uRykF8OAt18iKHj2PuGLe+mjg
	lyeetNW4yO4MFC0OPV36A11cUOa8XaEuGE2MjTHpFkf/fWy5LlsQH9lonTRuZR74mv69j4nwN3P
	VBfH9dWssxCXH7EwQbICGeA2mBTPeQlq62J2lZ/XlRG6GtUw3EgmITmHZa3T/D37/ZtYg7wWIgU
	Kf99u0rYWRLHnGk3Nh/ntRxfGVZCw+JPaxYGtTyyTIFA2/ba+DxwqvOAs1BUV8/LCLbYdnUF0ON
	a2UepFVV/ytOnf15gaNPhEjN0I6EuYpyXIHn5F8n1rSCtU0bUixAxDfFC
X-Received: by 2002:adf:e193:0:b0:48c:7306:18e9 with SMTP id ffacd0b85a97d-49c728c6e6amr26569239f8f.43.1794904509932;
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4e2esm26338505f8f.36.2026.11.17.00.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Message-ID: <b0ec2cd8f9b7a6a2e4a54c6df2fa897bce068cbd.camel@amutable.com>
Subject: Re: [PATCH RFC v3 28/44] ocfs2: use fc_init_pseudo() for dlmfs
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
Date: Tue, 17 Nov 2026 09:35:07 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
> device nodes.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/ocfs2/dlmfs/dlmfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index d3bfcada3e3bf..1789ec96dc130 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/types.h>
> =C2=A0#include <linux/slab.h>
> @@ -563,6 +564,7 @@ static const struct fs_context_operations
> dlmfs_context_ops =3D {
> =C2=A0
> =C2=A0static int dlmfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &dlmfs_context_ops;
> =C2=A0
> =C2=A0	return 0;

