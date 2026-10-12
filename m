Return-Path: <linux-erofs+bounces-4711-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ABE0CA9ED0
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 22:33:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3XLN4Vv8z30V4;
	Tue, 13 Oct 2026 09:33:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::c30"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791844412;
	cv=none; b=AP3vLiHLiArV2VMpUR13FG2p/CaAIP7yVzwywEClu/+scRd92JNsvkj0ksYBfBAuBkQKCLYZmNBKwr0q1JEQZWqOUbDiZ1HVDr/UYRP3KqdlE86xVdj6NOvPFzLLFL7iHPQHSEwpqmAwkn2sg6QAJ+WsSHQBCIp/jxebWNC9vNBVre2h39oy5uY/0b6hdubfrx4nXRR7Ry0XUVkdZ4qLXPqLIM2omgi/F70HsyAM5J3J4Bvq2fhFhNxE9a9ExCGYDMAZrrkbb7OPNo27vzpX0TdzoY/CgDcZBSovAWwyaws6f2neUyB+aAL2ARZREM8WcDvNPXJEF35BPGaHGX5SMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791844412; c=relaxed/relaxed;
	bh=Sd0kXVfEv0AcX8wmbp+GJLEkdmbum8rwELuXWLA2qOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWNtnoTaCJ6M4vAFdtJLxPxAoVpGZvbcuedTj/0Y5pEmcD9mgcNNjcQJnBU17PBAd5wt0uLDtJG348xrbVi8RHMVfAPqZYtLV+xAMuyNnEeUertbl/xQ4r6+0oU000ODCPHbnbV+E9TBZDPVGhRrKRCsj3pr22PLi03qzxo1j3bzjekf7LBrdBZLgHL6cl1qE4tfC7zhCwV/n78FbMkgKxDCCoRKniuhmmltR8MiKWb0XeiaKIYdAhCSfPfFFyKvTRsa1rRdABC/8+JMbqzbmkWjm5QjgDv8ccdsIziUyidjYQS6pIv4M46SUp7cnzFQd8QBF23Ujmb+wRiMY0WTOg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=konsulko.com; dkim=pass (1024-bit key; unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=HKxBtCky; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::c30; helo=mail-oo1-xc30.google.com; envelope-from=trini@konsulko.com; receiver=lists.ozlabs.org) smtp.mailfrom=konsulko.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=konsulko.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=HKxBtCky;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=konsulko.com (client-ip=2607:f8b0:4864:20::c30; helo=mail-oo1-xc30.google.com; envelope-from=trini@konsulko.com; receiver=lists.ozlabs.org)
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3XLM3wnlz2y1W
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 09:33:31 +1100 (AEDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-6cfed5dd083so1390616eaf.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 15:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google; t=1791844409; x=1792449209; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Sd0kXVfEv0AcX8wmbp+GJLEkdmbum8rwELuXWLA2qOM=;
        b=HKxBtCkyGxZPMzDsjaGbfNQ25SQDEplbuYGZe1q0LjQ4UC5Oc4weaVwR4tcACMBwQv
         PMVQLkuUpWxECKsgwqucxBL6LFimp279gIE8h43+rQt/QT5L9Jwak3dHpV+nJkAP1rK5
         Lrtzg1fRmK3oEQkafOCUXyUIliC/hrjeguUII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791844409; x=1792449209;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sd0kXVfEv0AcX8wmbp+GJLEkdmbum8rwELuXWLA2qOM=;
        b=fY4hIYjbMVsZp2jS73NwKpQv0Oo7kEsatL1+x6oMBz7bquJyzWPKQ5ebi8hgGBGASb
         kwt7dknMPAy6irK0aBMbvWJfPDGggcRN5gwLcn61xiG6jgp9ryzxjVAsWYQK/vCx5jlM
         ybUOFVy/UgRAOfbPMojMm1l6aifyOn49uHb4uYLmw3vSsmNAlxjlNmrLeox4HtEeW5DN
         b5RNPQTmZxFQgLMdySY8X2KLV7kVeBg+WezPnURi3o+SGEiKn2MYfp1fpuNWz5MRg3Pc
         +ssaqSZS2qIOO/wYE/YKOQ9cbM5kKVJbKhl0tMz0Krq7fAB1CEqYyxyzmhENWru3TdnD
         TWdg==
X-Forwarded-Encrypted: i=1; AKwUvBwekmkO3ueD1iJbCdb6AJHzkjhPom0fxCcKBk3vQGjgPU1m2oaDxyrPom4L8ypc6z+CB67tw57J5l3yHg==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLFw0L0H3Jasl4KWRHrRjkbjhXxlUUfWCpUC7+GdaDZjKSyhqOH
	cGZ/UXWACiX02iUi2PIWLZFkgPJhuPywhs/o/XaFYMT2S5OkBBLNYyvm2GCy36UjLq4=
X-Gm-Gg: AYBFou1y9dMYCb3mZtSy2PrPJPawRE6taIIPvvEEuawIYSxTa4JCe01SwqSkxi2WHtZ
	cocQKeVdkf64amveIBRY3RZcSyz3GRVXek2yFZCGFyPdr3mrW4aE0QjIjp/E/ZRCn3mN3UsLQP3
	+wkMEoaPlFYCt2ZUIv8j9CAjVBjGzgiYjBe8YQU+np0P/DN1Bbsj0YQRYTe6daql6eUZb8KfPwn
	mX55Is0g4gQgW/PI3LwRBBss2G1vutd/asUN4hc6i55kjjyzGthHVrUsf3MugRpKeecJbyOGVY0
	9jtRfnSMPSAgXXPYb0w/FBHeyc440ZvXuMQKd+PQFu6mfFI39eIBE9x83NW7uDBI54KnNlJq5uX
	Rp5wdxkypawyDTNeBN0OgWMcfP8QzD3148sehysgARu/yR0qwwRTIDU2AYL3AY1HM6Ra+iJ6lQ0
	2V5SGfrm6nuRPyK1WOT91n0Zk/gxm6vgzgQ1rlVfrKQeN68xEm0Sae33ZGiOgJRGf9eAJveDi/u
	7HZV7zqh+PEO/mvp+JfyHTWhh2/2G4jaUwoUMleTFW1leVnnwNUJS7DkQIjh6cqYr5Q2mpZX/Yu
	Es9OPINRFqbTnSkMyQ4=
X-Received: by 2002:a05:6820:7098:20b0:6f5:f71c:1acf with SMTP id 006d021491bc7-6f5f71c1d5emr2482124eaf.58.1791844408216;
        Mon, 12 Oct 2026 15:33:28 -0700 (PDT)
Received: from bill-the-cat (fixed-189-203-100-56.totalplay.net. [189.203.100.56])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6f85a9e6783sm1769865eaf.7.2026.10.12.15.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 15:33:27 -0700 (PDT)
Date: Mon, 12 Oct 2026 16:33:24 -0600
From: Tom Rini <trini@konsulko.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: Simon Glass <sjg@chromium.org>, Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 0/9] fs: improve change date handling
Message-ID: <20261012223324.GN3722450@bill-the-cat>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
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
	protocol="application/pgp-signature"; boundary="ncO1TmiKEsXwvSWs"
Content-Disposition: inline
In-Reply-To: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
X-Clacks-Overhead: GNU Terry Pratchett


--ncO1TmiKEsXwvSWs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 04:00:39PM +0200, Heinrich Schuchardt wrote:

> * Let the ls command print the change date for FAT and ext4 files.
> * Correctly update the change date when writing ext4 files.
> * Adjust tests.

This is a little thin for a cover letter adding a new feature. What's
the size growth here on a few platforms? Thanks.

--=20
Tom

--ncO1TmiKEsXwvSWs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTzzqh0PWDgGS+bTHor4qD1Cr/kCgUCas1gNAAKCRAr4qD1Cr/k
CgrYAP49vVaclgpHzW354uWTQ1JiMhluvh67xiZgez2JXTZX+gD9H06LBxyBV4o6
Hw7KpcYhDOqjo+/4DCUoIx88Gu64wQI=
=XAR+
-----END PGP SIGNATURE-----

--ncO1TmiKEsXwvSWs--

