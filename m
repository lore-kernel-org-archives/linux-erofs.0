Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BD9606A889
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 12:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mRu4c5T5
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQxd43jdzz30V0;
	Fri, 13 Nov 2026 23:38:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794573512;
	cv=none; b=UgSpM+WIT1xlhXGeHHdtbQ+b8C9pS+lq9IH100bzIBVLfsLyYeZ+h/7IlPcahTyKSnT4h24fO2xGtS11MVdwMBh2nxYRcxDfNYKvuo5JCTurSykiEcbt1M1fAzmCZ518xNbgxdrR18Cc8/OIeGF5iyjzt92F2QNFElPSiqPvKsOjlrKjaCAU1KE9irrzohmClAm+B0l/Nb7GKicYT8J5ANDucx9f2HcnL3YUDTG716GbkmaEYBWTvTvtDcZG/HYFlolfHFSkdBiEYAEeWwcSvBIW+xb9aI8WrUyfoppkPYJSBYLhvaIpLIJFeimglNzPAaIFCy3nDEYTQlMlmekvjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794573512; c=relaxed/relaxed;
	bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TgunAdyL/wZ7BZ0mk9TKx1NxuUItOGKD8c8G/7+91A8tusaX/OX0jcse7tcU7apj5VTb+PvE0gK5x0gNOjnDNB2qJDqEqjXPUDW5mXau+/BfPaCrr+pc7x18iXAjtumzBlXCfAuXG778XN3PkGogKpNPf4I8Pvj8uUal0LVBgtfLxGWJCcH7PP1p2gtlmqYMVBhFzs556iiMA6UtlD81uQrxUrNwiya6WontRY6x1YfjK8ykDHRx9T3ojFtW25wvDAzTfMz2NNe5GpV1i/w/bvVcnuVnt3wKkgeRIo87pMtLsvRbB/BrtHD13OuXA/6wK6QhYDHXVyjn3D1RydMEoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mRu4c5T5; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32e; helo=mail-wm1-x32e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mRu4c5T5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::32e; helo=mail-wm1-x32e.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQxd3577vz30C6
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 23:38:31 +1100 (AEDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so9108285e9.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 04:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573508; x=1795178308; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=mRu4c5T5AU1lKDY4Y40TxFZTbiE9VaKrrkgbn0+8ONQBXkqXuPlSRV2WQebNDcDM7C
         f9rQ3P1aoSM19Jn27Rpff2CGjE0GUSkfpfEw2jXO42kHfI/39g8sxNmrapVLxqqHdBlF
         O2en/sf7V1H2MBOppqS+81NtnjqwBjNeyeOiKUC7JKQqzoXpCfIvyAezZpj8EIl9SeVQ
         UO355RLWQrjfLOg20sAUQ7wAvXbI9Zc3+Y6OADyqFpceqD10FA5woMCBG/7HEJV7KHhz
         I3ohTMVGGES7AVX0tpDs4jolGiqB3Fo1CDQf9nb/Fmtc55D/UD+Jl7Ic49gNm2AiIxmI
         hxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573508; x=1795178308;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=MwlSJ0gwuu6LStvyiTYzdQ7TpRoBtUffOGgZRQL2Z5PgYp7NIx+1fkF85ACTI3pNZi
         3HsEMVYK6fK3V/hDTq3Y8xQukbMioVF+qOZWbzXs5tPjpf0dT4abxPMSc9nH99T+SzGT
         3QpY8fBNgG8cl0ahtsX5EXlqSGE7GMZqtr7csl24L627TDBhrQXUT8gLvTGEewiHAW0x
         aaXRZTCn+UWliC+iSQ+URNoMqAwhv7HVyUTZyq4fyb7LJsDJ1SHgrT4WUz0aynB/5w4Z
         IXlCEJ/nQFAA+1yo1brU53s5N0qHJw3P1vPqCkLPSdRhL4ssMD7W9NwGso2z5U3kTu50
         W91A==
X-Forwarded-Encrypted: i=1; AL+hErG1H//t/EX5evjiCm4+4pPIeJaYNiDV+Bb0KpvPzdsiO6gAGzjkzvYK/gm5P0DAxoWWHUvK3bKj99RslA==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/DBTHtLp8o7OD5p7UQKcGhnr16XxAJW0+lOE2sIqOljRUeLeZ6
	zWk1wv/+qOrwl7iimkcCqfY6yl5N4aCLYESVN3QBwugZzFjuYDzEqn1fi8Y4VvTPZyco
X-Gm-Gg: AYBFou1oE3OzJm1GJlpQdPxgEUQ+REZnN77oCIVhKkBONojjE7ou1KAg3MMfttzi9HL
	vLcewxN/v7AjabP7jLIpQEhHmfDHVTy/7f5w8QX9C+1BjEJxjS5APvesKNEH8dbXTKgpu9EouAy
	aFohm/Or2cmVQrPGTnnhfu60VBqjtEBJBXVnLtURh0evqcMz53EccFtwcvSlBVYvIhyEbBa4f8p
	Xf5h6ZN+TCrzvvmxSkfjjih/eZoTbg71nEgdmWF7pOWwYx2e2oVdmODEG96D0loCssFmOfAm+eV
	qjPE7auTqp4O20cB8HhXEmgA5FR6BMBVb0StftmOZyD4u6fStJtundcZNL/HWWODzyXWBy30jUz
	1KHQ9gZ0lZXddgsciMdfA1fQmpbzuWS4RquNcBGBWQ5Yflpj5tnfkxuLKJiDbwfK6WpucCxipod
	JuA6FwHUuDFmwjAlM9ydiwcaLpx2f9hAjcJDnd8a4o1E5A2PkI+FsTDUnZwRlI9JaaN/JNHnX/a
	bZebE8l2c/wtUcV+SbsEhAJi4PLE/OqtvIY5q8x7C2jOkgEVgk4I8BUSzZceX71INf8jmTfRMyA
	+4YpniXBXStE1uJgMWcmgRkkIQomUL4UPGHJx4Tn6d+LhUbritslwAH2/ms/JeA=
X-Received: by 2002:a05:600c:a596:b0:4b5:d95c:2380 with SMTP id 5b1f17b1804b1-4bb55a86fb2mr24790785e9.11.1794573508217;
        Fri, 13 Nov 2026 04:38:28 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571cfa2esm48348475e9.2.2026.11.13.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:38:27 -0800 (PST)
Message-ID: <28a33fa649dcaae2eadcc934ec49fa591ec1c283.camel@amutable.com>
Subject: Re: [PATCH RFC 20/41] apparmor: use fc_init_pseudo() for apparmorfs
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
Date: Fri, 13 Nov 2026 13:38:25 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
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
> Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/apparmor/apparmorfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/apparmor/apparmorfs.c
> b/security/apparmor/apparmorfs.c
> index a99366467217..351ea3a7120e 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/rcupdate.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/poll.h>
> =C2=A0#include <linux/zstd.h>
> =C2=A0#include <linux/string.h>
> @@ -263,6 +264,7 @@ static const struct fs_context_operations
> apparmorfs_context_ops =3D {
> =C2=A0
> =C2=A0static int apparmorfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &apparmorfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

