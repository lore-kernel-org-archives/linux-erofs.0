Return-Path: <linux-erofs+bounces-4709-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D6E7CA9ED2
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 22:31:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3XJS0wPNz308Q;
	Tue, 13 Oct 2026 09:31:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::c35"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791844312;
	cv=none; b=Bge54Ha64UxGlkaa8rdCcnIr2XinT/tsvvXcMHbx7hHBISkJ14eRRKx/O41x7gcYcR024P3siGrFfqBAa/2plfU2tbk8PvdjfwE/wI58Yod03iJZ0tMk5AzzrH4n2gPFvCLNX5K5bXqhcc6RNUL0gb+5N+wdFI3nuigdEYMcIZn3rfuNYIh8hzR6ebBo+NKZFX3ReE2MNRjGDw5HH7DWgmYFQNRxUat238ok9pZzOYnEhfvWobgh1I68tU38w5FBOViqTBqrqCz0Qc9bY1f/XeZqsG2dsgWgFCqMPiTvnOmN/htLVC4HVHW0S5LaTP55Ks3xpUj6VFXmEv1n+gyImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791844312; c=relaxed/relaxed;
	bh=402rDNrxL5De9/uJD7NLJvhKJtSHNB653jVvPuVTn0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cIieOn2pb3cntkDPsVNrPcwzYeJKMhNNMGNSTlZT4qAl+xu7ng/rgaqGOgk58CXNyOkUQeJ2pnIXfPRtNPiqaPfVmRtIZV5HzXh5MAH/7drOy9TLJG+OPgJBQhSSgGahmtkqj7K3pKkewrZ9j2fFk7tW6i1IMhwlTwF5DcYJ1qKNirMyVkzmBXM9F/7yrVQXxJRpoHZlObzeIacQevhOOHvWzVyLmcj+8hHP9SI6kHOCMhlEmcaCmgIGiIHd8biC6f/j9kgOJakpzD4+BhE8DM6EM88AB/uweRw6MHdsd5jjJYkuHc4ay6zcmeB+DWtoiNNWiD68jU+YAXgVWgaIhA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=konsulko.com; dkim=pass (1024-bit key; unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=IrqyOAee; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::c35; helo=mail-oo1-xc35.google.com; envelope-from=trini@konsulko.com; receiver=lists.ozlabs.org) smtp.mailfrom=konsulko.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=konsulko.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=IrqyOAee;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=konsulko.com (client-ip=2607:f8b0:4864:20::c35; helo=mail-oo1-xc35.google.com; envelope-from=trini@konsulko.com; receiver=lists.ozlabs.org)
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3XJQ5zZxz2y1W
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 09:31:49 +1100 (AEDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-6b19e291cc6so2364769eaf.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 15:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google; t=1791844307; x=1792449107; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=402rDNrxL5De9/uJD7NLJvhKJtSHNB653jVvPuVTn0M=;
        b=IrqyOAeehXq8iJqAHDD9N8hYdCXFZRk/2KtS+fZOjVxPzNELqDKJi2oqdXwHLXkleh
         zWEX7SkhKfKLtwsKJs36+UkSBdplKNQnBZwxYxPGjvloD5bDIADUwPyJR83n0uoOF/sx
         zO+Ce0kWWgd3SdsPV+nRdDfRosI430yPYXwho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791844307; x=1792449107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=402rDNrxL5De9/uJD7NLJvhKJtSHNB653jVvPuVTn0M=;
        b=pyVC7BTPifu5gbI2BMlhcwSc1MxhqsnsbctQbJbqWcfKf/BQ4nj3ar+MOcoQmINzxo
         zVVnNmSN0lRbPv9OrMZUWonkn8xJpQ9GEAGS9cs35EYhYsJwIAERptzG2Js7w1ykbsrE
         63rRnINg9gBMRqiaCjbzOf3C9hccTxM78Hhppuf3fosagWesaRe/c0SSCXc7O8vPyZ62
         kdXSiQ7WhzaJ/sQGl14FkpgXu9qBF+Q/MuLVkK0gkKEyzw84bEf0NJS8AM01TFVIdlE8
         o1letMNPOlM2fSbXcpoz4uYkL34tqptAZ0D2WA0ooADsG/iBl8Zw+CWohZcCigVC35jR
         caIA==
X-Forwarded-Encrypted: i=1; AKwUvBzR+VfuHhIo/C3yGcnpKrrSRiyDg3pb6WckrKOaRO1ozOB01dnf1Gvo05wQH9u/YbmIHlk2wMUwI3QT1Q==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIAgQTzsiOFP44AHH3v1jyQyCNpxHARel2LbniMOgykLQesqSfW
	Ku3l5VkY4uNMyzDpxSpG5ftkrMPGP4IGAm4LIxfXs5u0IIpU7jSP9PlS0vo6vO3SLGo=
X-Gm-Gg: AYBFou2KvLAOiq1EZ0rzY1K+b17ZQq45/rO06LX4faW/bztZ+8FOagAvMYHT3rWsRBt
	WQz+c+y/2yahvgmO1x1ohEnIjdx01YKTKLnOtxXC/Ex5+wFPV0x+tLxGgoKrUK6A9Sus4VAKAq0
	L9tx8BhjWeGNnU5/+8M2U91F3GBx3KYe52nfwD4hITKCWDOfGAAFD34EsWQzxjt/Gzhd35Jp3Cn
	1vUnnrWlLc6+8NpkF8iR5iCVRHQrk4Vvk/CYiExWamvVHlxmd/CTzqJF/qAYZwJ2RxbcBtMyTAr
	jwSDnDM7ekpE3Fm+vMfEWIbJMqB17MvERYJNmObYqbBYi/Ehc48OjKsrFaTxerjZpl0XtqVg0aA
	klunCH5DIPIOjgTe6KdcTkUjrdkPyF73z4H6A7SCmtqlpmweOi/BBnhgt1yOfI9ddzhP/AzVucI
	yYxlLnYVWyH0+QoKv0kUmzsxVSHXlu+IN3aXydJJYCvMrt25MluL4IfyqK1n1FRwm/usWKq9avF
	s3H9+IBa758IS6NXbyJfhHkcvsd/6h7isq9ZOu6r2iEpD6Fuk6ehQrz512gLP6fjT8/11xsKTmn
	GY3OsYxmYpVXvazRlO0=
X-Received: by 2002:a05:6820:6ae3:b0:6cd:3fdc:6006 with SMTP id 006d021491bc7-6ef11a30b8fmr7693980eaf.87.1791844307541;
        Mon, 12 Oct 2026 15:31:47 -0700 (PDT)
Received: from bill-the-cat (fixed-189-203-100-56.totalplay.net. [189.203.100.56])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6f6ed64de8asm3153599eaf.5.2026.10.12.15.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 15:31:46 -0700 (PDT)
Date: Mon, 12 Oct 2026 16:31:44 -0600
From: Tom Rini <trini@konsulko.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: Simon Glass <sjg@chromium.org>, Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 1/9] fs: move struct fstype_info definition to top of file
Message-ID: <20261012223144.GL3722450@bill-the-cat>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
 <20261012140048.214059-2-heinrich.schuchardt@canonical.com>
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
	protocol="application/pgp-signature"; boundary="TyB4zb+Ol+rPGVkJ"
Content-Disposition: inline
In-Reply-To: <20261012140048.214059-2-heinrich.schuchardt@canonical.com>
X-Clacks-Overhead: GNU Terry Pratchett


--TyB4zb+Ol+rPGVkJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 04:00:40PM +0200, Heinrich Schuchardt wrote:

> Structure definitions should precede code using them.
>=20
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
> ---
>  fs/fs.c | 86 ++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 43 insertions(+), 43 deletions(-)

Should we just shift fs_ls_generic down in the file, since it's not a
"dummy" function like the rest but rather a reasonable default?
Otherwise we should at least explain that we're doing this for later
changes.

--=20
Tom

--TyB4zb+Ol+rPGVkJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTzzqh0PWDgGS+bTHor4qD1Cr/kCgUCas1fzAAKCRAr4qD1Cr/k
CkuwAQC1oqmwnAVrIym2uraYzw5sI7t3JCxBg5jY/SlBB03qvAEAxoLYfrdZB+NY
F70RddOKg+0J/N9qvsLanBT1VjMBkQ8=
=9xIq
-----END PGP SIGNATURE-----

--TyB4zb+Ol+rPGVkJ--

