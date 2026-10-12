Return-Path: <linux-erofs+bounces-4712-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B45BCA9ED0
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 22:41:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3XWW0rZ4z30V6;
	Tue, 13 Oct 2026 09:41:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::c2a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791844887;
	cv=none; b=cM+P9ioly+DB1zBK98jRmXFoaveY9q3d6nMtjMbVJLHkF6jiVxHZd2y+Lyg4KOWI7vGu3FRM1n6rGvQuIs9NaRgE6LMps6AbP03Bn7yKc9/SWM79TD8V6sK0DS+kNMqVOm2Mqky3tnTlqwVWsqb/YDp5Gi9tTLDZWcEMXKawCgPg6qfgtpB2luazuifpevw/+kSZzqiRScIp58mBHoUZ/CNCpNjWYTKWDVBmEbKUUtV0iC0wScEfWYliKjl5umXrfIEQmlCNP2bRiapiDuLTePSFUV4BzZL/6jrRdf+nKAVNGDxRPrto48f2Zefd6Sry7VvSM04hDy/hvFVg7na1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791844887; c=relaxed/relaxed;
	bh=Vk/eZk6ySanjXJx5iZhfEftD9xgFiV+Ld6F+BA+7OFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0JeszFDkAYo2G/7UlFbZgoEs+BhNp9vc4ZS4fOMCHxNGqedu6adLYVFfSIdxSOikDQG/CDMTl+iLpk7h5TM+orRWEB4bpJbL8JPooztXzRV+AAAFPC+WsT6WMUxHek5Sd3+UReFFJFVSVU05W64KOmP+Nt7nS9SDdLtSFgJ/+Eg+PRmvAVJnBXzTy2/G6GmeeKluMYZXVvK+/utUzqHtb8PclkkAZjUYIq+KwS0On45QWIIIxEdUuR3pak8czs33KfmfGbyv1e64iZbFpmQ5HZJ//3KEi8/cznhef45uFgXHNHWVEMyNDHO4TCp7l9Ltb1/yW2H3gmI7CmmGZeQYQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=konsulko.com; dkim=pass (1024-bit key; unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=CgB+8Lns; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::c2a; helo=mail-oo1-xc2a.google.com; envelope-from=trini@konsulko.com; receiver=lists.ozlabs.org) smtp.mailfrom=konsulko.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=konsulko.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=CgB+8Lns;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=konsulko.com (client-ip=2607:f8b0:4864:20::c2a; helo=mail-oo1-xc2a.google.com; envelope-from=trini@konsulko.com; receiver=lists.ozlabs.org)
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3XWT5Nr2z2y8r
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 09:41:24 +1100 (AEDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-6df93f00f4dso974550eaf.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 15:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google; t=1791844882; x=1792449682; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vk/eZk6ySanjXJx5iZhfEftD9xgFiV+Ld6F+BA+7OFM=;
        b=CgB+8Lnsnyx68pXV4nJvgIk5WAuR/YPEJ1aZiYKN+NPoUTPlclwlbbHA5rrA43RxhA
         uteGLMBPoTHhSpidqdnTd8h8lCaYRxDO2by+PIwStjW0Bj19777wHvH6mSOdhQ5YXNTe
         s5pjNM0qVzMKa2Ls+n0WAVm380ByFIezGHXT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791844882; x=1792449682;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vk/eZk6ySanjXJx5iZhfEftD9xgFiV+Ld6F+BA+7OFM=;
        b=oQvhggoHU7hZHh93eeisSjIFzBd1FSBYwEIS9SOTxWZC69c8mLhgJuxzFrONN6EkYn
         XjR6EBN8rtHY6euPrntow3F7MXJ9bWnLWuxvpPIE8sYV1rg2ukMFVkXtfjH0ABWpvNfG
         dS6MNEAh/P9LXQdFUOYBxlkOYAD8ZjyeogM9dqMYjMRdkVPvN93jxqd3jj70QzfBVWEM
         YLP1vGyXV4UfImXKo9jguETex6zSvHRmRzub9mntb0W5GMR9RUJMcHO6hmWTi2Ln0cRT
         CnJPZh7Hlg3jyqR5fqKDjX0ocRFBgnI+DwjGaRaLT8yifSeJG1AGc8UYMCFPJLYMHErV
         iPBA==
X-Forwarded-Encrypted: i=1; AKwUvBz9+SW+ovB+KuWd0xcZNtpxkcsfHdRBwy/+Oov01v6b7kvoprnh+q/Hm1ICEQ+OYbRUmucjT6K/7tN/jA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLuji8QQDows9cDAxDBBLXz7+aIs4HJRGr5mJAWJW6bJBfmpfyC
	yyxCHbS9jzDyMLFZDtb0hZS5BdLI3yeDnHAjUbaH5WGPx7YJ4T3Gi3rQn+HnV/kwx/E=
X-Gm-Gg: AYBFou36O2E5kKn+u+cwLN2/wk25VOJe6r2UQwec3V0lkc30BpfelqjxBt1RFA6waEU
	MvAp/SFXBfCZSqv3/ywefdGB6K6Ecol4QcGWNmm/4w4+nrsC1f1t3c1k3SpsS3gFYZx5ETXvmz2
	hq2KJgqAIsPU5NG7AVnJDajNAwn50egB1quvBCadZXfmjBK3bEEBIpMQXH1yFj0DhlaTICJeWdm
	8+KR6rVN/2EpXckZcUghvG50l4srFzmwa78EMcAeAQRX99BtbYilKgB026CxrBmDeM/LsNU9vm/
	p/SagJghwvcHvnwl32pnDhp7/QgxdA5zDMWkWtHObXmRqxAB4RFdhCG+NgY9ElWujHACSvRMdNz
	VSxhxT44WjgK66ZFkchMvPc3paDb6v+hd6wNuB3SwVyfk5Jd2O0xpmhjqXthp28kRD3EDzdIA7j
	F7bdPxYsRS6eFH/UQQn9wIGwXiD4A2+90kH5VeiHNMrByN/IJehC3nTRbRPxulIze9Kmo/jynLg
	eutv7Zlrn3lHu0BkEq9oRMthgMJbr1Z1SueEBDdR+3fw3iN1qe1TIw46DcAjSkE1vOTeURhjTL+
	fL3aP9iwIc1vT66k0Y8=
X-Received: by 2002:a4a:e847:0:b0:6ca:b5f:e6cb with SMTP id 006d021491bc7-6ef10492c2emr7887408eaf.42.1791844882064;
        Mon, 12 Oct 2026 15:41:22 -0700 (PDT)
Received: from bill-the-cat (fixed-189-203-100-56.totalplay.net. [189.203.100.56])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6eef6e22b46sm10584655eaf.0.2026.10.12.15.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 15:41:21 -0700 (PDT)
Date: Mon, 12 Oct 2026 16:41:19 -0600
From: Tom Rini <trini@konsulko.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: Simon Glass <sjg@chromium.org>, Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 2/9] fs: print change date in directory listing for FAT
Message-ID: <20261012224119.GO3722450@bill-the-cat>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
 <20261012140048.214059-3-heinrich.schuchardt@canonical.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Buadw3Dj01Rb/9Rw"
Content-Disposition: inline
In-Reply-To: <20261012140048.214059-3-heinrich.schuchardt@canonical.com>
X-Clacks-Overhead: GNU Terry Pratchett


--Buadw3Dj01Rb/9Rw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 04:00:41PM +0200, Heinrich Schuchardt wrote:

> fs_ls_generic() displays file sizes but no timestamps. The FAT
> filesystem stores a change date in every directory entry and already
> populates fs_dirent::change_time in fat_readdir(). Print the date
> alongside the file size for filesystems that provide it.
>=20
> Add a u32 capability bitmap (caps) to struct fstype_info. Each bit
> documents a property that the filesystem's readdir() implementation
> guarantees:
>=20
>   FS_CAP_DATE  BIT(0)  change_time in fs_dirent is valid
>=20
> fs_ls_generic() tests FS_CAP_DATE once before the loop to select a
> consistent output format for the entire listing:
>=20
>   12345678  2024-03-15 09:30  filename.txt    (FAT)
>   12345678   filename.txt                     (ext4, squashfs, ...)
>=20
> Set FS_CAP_DATE for FAT. fat2rtc() loses the __maybe_unused annotation
> since it is now called unconditionally outside XPL builds. The attr,
> create_time, change_time, and access_time fields that were previously
> only populated under CONFIG_EFI_LOADER are now populated whenever
> CONFIG_XPL_BUILD is not set.
>=20
> Extending the feature to another filesystem requires only adding
> .caps =3D FS_CAP_DATE to its fstype_info entry and ensuring its readdir()
> fills in fs_dirent::change_time.
>=20
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
> ---
>  fs/fat/fat.c |  2 +-
>  fs/fs.c      | 38 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 4 deletions(-)

We should split the generic feature part from enabling it on FAT.

And, building on the comments I've already sent, I assume you've not
been inspired on some way to re-structure this code to avoid having to
have forward declarations of *something*.

--=20
Tom

--Buadw3Dj01Rb/9Rw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTzzqh0PWDgGS+bTHor4qD1Cr/kCgUCas1iDgAKCRAr4qD1Cr/k
CvJtAP9OoQhIZGVniC9+nas41Tk3+FDktSA2gXTYXf+jh2hHxAD/Zca4O+W40Zod
2lKdIx7K4Wu8wBXpO8GreCFaVw1LIAQ=
=IQUU
-----END PGP SIGNATURE-----

--Buadw3Dj01Rb/9Rw--

