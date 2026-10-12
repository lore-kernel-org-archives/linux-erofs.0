Return-Path: <linux-erofs+bounces-4710-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C92AECA9ED0
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 22:32:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3XK40v8zz30C9;
	Tue, 13 Oct 2026 09:32:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::c33"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791844344;
	cv=none; b=RC5eVkhwq5+3PeCtzE1vRhZhanKGSMrQnCIagniigc7PZt5lgWFYD4lHkllHTZa786B52aNTIzbcPoyglGwsQBf3NPDZDWfglseZa4DWi5qPeHkSTEynt3SqzyOjNFr4UunhxQ1ZZgCG3lgPPelinW9UTJlJIrs39wcV9Ou3VUjqH5CGFkq6/0SvfJcW9l8i7tMjTbG3YoZECm7TLANtyZrEy/0YPpxU8CDj9CJjbDnaJmJs1IrApxlBl7oT7etAnnx5L2WfC6eJ/OzSGBIWzGNTmZmM8itFSYdQBhf/eFX/3MS/bLXXIzdfWftzfv2emRFQq7PIFWAbxCoB85Fi9A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791844344; c=relaxed/relaxed;
	bh=av3icJWMHG7nOgMUXfzoELfx9ICxqDmHRFdPStghBD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOr8pF/56fV6pvhsl+y4gfZycb0AjJF/uvlCgT1WhN31uKZ1xwpbUjbIjzY5JlgEYF2DlMDnLlwX1/QX5ULTZBPhkU3W0zVjY3hNdF30a5/AV5ngaFN8ndrmYFKmAF2PWbjfj+Z+rSA+UMnDtSdlAha/Efz8HhGcyuoK/bY/hddu53TEDSJmVPGoVQkCxNy/UMBxGWoAAv7WYZCQ/UzmBtRGuHN/1dHFmmMcQZuDC72QS60TBbF+ZzpEvp0rwtwWQufyWg5xvnz3yR9cyARP/M5fidpBgyhShQrDCy5pmdpuaT3qI1BzX+Rm2GQwslXJN29En57Vvs1gImfRp0Pe4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=konsulko.com; dkim=pass (1024-bit key; unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=KMUDsw/v; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::c33; helo=mail-oo1-xc33.google.com; envelope-from=trini@konsulko.com; receiver=lists.ozlabs.org) smtp.mailfrom=konsulko.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=konsulko.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=KMUDsw/v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=konsulko.com (client-ip=2607:f8b0:4864:20::c33; helo=mail-oo1-xc33.google.com; envelope-from=trini@konsulko.com; receiver=lists.ozlabs.org)
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3XK30xDGz2y1W
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 09:32:23 +1100 (AEDT)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-6ddef424972so1684079eaf.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 15:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google; t=1791844341; x=1792449141; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=av3icJWMHG7nOgMUXfzoELfx9ICxqDmHRFdPStghBD0=;
        b=KMUDsw/vM1Lz1wsPgHQZab14KN9s/HsTQ6gi0EWAAS+ySg+rWb1ZOE6KKdKiMF9WSK
         cKjnRZT4vDuHomK5LCKOq8O1JZrNaxlVItSWIz72DUZHX9kdJrqqDHDv/MPQ/CvIEOL5
         tcurhR3n+WwwmqAvAyZmUgCN0ss9fNU215HiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791844341; x=1792449141;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=av3icJWMHG7nOgMUXfzoELfx9ICxqDmHRFdPStghBD0=;
        b=OxF/6sIfAQ/Bq377nOtRi36/e6x6CnaSts6V5PHtvAUFaP7iImVt48ZaTNqeHTuCFw
         l7qtBDuWbPtzJXAZwfchFbygIRgZF5KEySVZN4M8xZ5GYGlMuTxkeahpQ2/JTwLbuKXu
         vHcWl1SO8hUaPbKhcnVs/TaQSRGaJfL5fgtn9Ia3/+85eZciuDgAGEJ4nIPQuY4VHarr
         fA9EXeql3CzRL60/Xz6GzCbNFre6GQIVlttReFEjN77YW90gpi8TrfWRQXG0wswGrfKg
         Cjzm/X8nwq2KETQMKpfjHzKmwrHDAhIGqjPOruistDDiTWXZfKpc1i2MewlB8A4Xmaku
         OSrw==
X-Forwarded-Encrypted: i=1; AKwUvBxCoZDH9OaaQgdRYAd2gGEofKXT25GLD+EWmxeYWgr6YiQqiaU8h4H3rOuPxHryq8DbyQYJAePZBEhSqw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKl23VBru1gkamAnE5RCjJiJD5QBKcKbOrUQclDhq/fYqwPOWyk
	w3W+60QA8wp0wKOOSui+MZPETu40uzgJwc8tKh6wJ9Og6oAV2Au7IZEI8TIfM3+MNFI=
X-Gm-Gg: AYBFou2jtqlnNSV3ggL9a1l/SZeYsosn6HPtz9lsThZ68oU0S0gVAksWrRAxo0lcBlN
	R0kaKIzEsQtw7AHPlj/0D+nKb2zpvirYoyFVBVyjduYeHz64CJ0WpiQrHpm1UvYrbm3/aRfiYiZ
	EeoNbVOMRd2meUJIn6J3N3TrBsGiFscL3XOm8SHD9cL877s9YykSXXwdRPrfLe8JSqgcC6Fddqz
	9xHsAUCJuQ2KqXoZj77T1L1u2onfbOtpPqvMb3DkAhwN70dxPV4X6EnWltN3fDB8nNfpJYcywmf
	mvjl61S6+gTSCPSMNAUoRkBqFs7N+R/C8VcBYcwafCFpRVjTbWnxMs0EyGSW0/yzmZZKDgkAmjn
	hHDz3/ZNAORM5sY79pqvk8gSG5DfnlNDBWHmTvXPSsgeuNwoQM/q2jgzODgoMnH1MiDwQTQez0x
	jhknJ3ZtuEgSA2A4/vOfMv2VEMUeXJqChDcZK+2wHtCxDIJ/aW0Yjsab04ViAJohAMr2mNv88JK
	n7xMmPNNUpWqy6jLOXFKARkOm9dYzcQNuiWoDzM8M1YXAi9wWuecKpzrdeDITAExaTr0orTbZ9O
	98OqQKRsgad89Qm0rJY=
X-Received: by 2002:a05:6820:1992:b0:6e0:84b2:edb8 with SMTP id 006d021491bc7-6ef08c7c614mr8570720eaf.1.1791844340892;
        Mon, 12 Oct 2026 15:32:20 -0700 (PDT)
Received: from bill-the-cat (fixed-189-203-100-56.totalplay.net. [189.203.100.56])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a2a86317a5sm10523087fac.17.2026.10.12.15.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 15:32:20 -0700 (PDT)
Date: Mon, 12 Oct 2026 16:32:18 -0600
From: Tom Rini <trini@konsulko.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: Simon Glass <sjg@chromium.org>, Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 4/9] fs: ext4: don't read time fields in XPL
Message-ID: <20261012223218.GM3722450@bill-the-cat>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
 <20261012140048.214059-5-heinrich.schuchardt@canonical.com>
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
	protocol="application/pgp-signature"; boundary="2M7mKRdgJ7wnBF9B"
Content-Disposition: inline
In-Reply-To: <20261012140048.214059-5-heinrich.schuchardt@canonical.com>
X-Clacks-Overhead: GNU Terry Pratchett


--2M7mKRdgJ7wnBF9B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 04:00:43PM +0200, Heinrich Schuchardt wrote:

> The ext4 readdir implementation populates dent time fields in XML
> builds though that information is never used.

Typo, XPL, and should probably be xPL.

--=20
Tom

--2M7mKRdgJ7wnBF9B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTzzqh0PWDgGS+bTHor4qD1Cr/kCgUCas1f8QAKCRAr4qD1Cr/k
Cp90AQDTqCEQHy+W+jAorhDb7O7dex0m4AOk1ivjTK0G0//q0gD+KwZRrLBIauh1
fpksNoTFvgtk0geoBQTBnjJlv4xPcgE=
=JeeW
-----END PGP SIGNATURE-----

--2M7mKRdgJ7wnBF9B--

