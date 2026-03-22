Return-Path: <linux-erofs+bounces-2934-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4483FC72BE
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Mar 2026 12:09:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fdw8g6zZqz2ySb;
	Sun, 22 Mar 2026 23:09:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774181379;
	cv=none; b=ogvqdeBwZuVQJQ/HKSeQVITD0RxQeszwvBRLmndiBfLIstHA9lxdd0J7Jp6zUPplgp70X1fTfJj6coqF6GGzmhaWSMCvfqMkbGwWTBDbN2f9GWApLOWGafNgXJofJpfomAhT6ZPjj09mf3mY5j/WPmEhBbJrbZAVE4MPCU667JD49BDsgY/cyD1/1dQI8xY9u4CsQ3kG54CYwEuDG1nGY/E27WXOn+ScZVqs2juzoWJCBfRjyFg5h1qgH81c1lJ+0CjFhMqe1cl9xY2F2QXVNnBRrO2LEWeJS7AXsDf230BOKqrfRUTct+pKSrRRiUIDxaE5BJV1S2s7U17V9lSpKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774181379; c=relaxed/relaxed;
	bh=0Sqzb1mJe/NiO079w7+QTsALosZ2AdY4QnF0Qy0OA2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cDQh6QMISfiz82PlafY+BLQhhlY8kG7y9fGGS91paedzJi7g41TizdmTS+QICDzdcgaUtd43VPWBZ0gnBkqJQv00Sr+SkocmobqDTcG2nZprJ418zD8GeI9P381KyNZa1hqQu9moKYA1o4zVECOSp6AcmauJQKT2HLaakasUy3nQH+KUb8hC48o7L2RcWiVipEAaP6pqoF1jkulTyzmU8AfOo5ThOLzwWga8SCvBUDJzRoTWU0uUwN4Kn4wsdgyinT2q5WD3A+98qBX3GGBrs3NnkAsmvjM8Iw+PD1egyjMW7d6+r5f86VjALBT26iKjA/EAz1VgNQVnvk4U3DPuSA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=la6hzEjU; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=la6hzEjU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fdw8g0Qc3z2xlr
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Mar 2026 23:09:38 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0205E600AE;
	Sun, 22 Mar 2026 12:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13B7C19424;
	Sun, 22 Mar 2026 12:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774181370;
	bh=/ko2bSiu0GNPaHAMf464LndZue7PSEPY5LgTsYvKt5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=la6hzEjU9FZlEq1PXW9EkYDaU7K/PuC+c7hoB9qMki2JnUyBewf8ao24jflhflsTR
	 8h6wMjoOV9AjGgjQ50Whbk1WZIXmXLmFeuYt4J8lR5HzqwALfy7+/of7uFPPw8J8tE
	 mcZ4d13+ga2Syk0ldChbcHU4iu9u8UJVh5ZsUsJpE1bgFmExRvKBQ4oDEyDarwgJ3E
	 ApB2xTPhtvqx67PgNjTKwqPLphX2qsnUNjAXu19+xjWlFg0H+vfjUWb7PlfkYiXGdR
	 36aEMi8j1NT60v86BdPHy86TZinz++OIF+GIE29I8AfKl7bRNRpMW0VpTFTduHKppT
	 Y8aJ/pY1Qw2Ww==
Date: Sun, 22 Mar 2026 20:09:22 +0800
From: Gao Xiang <xiang@kernel.org>
To: Ajay Rajera <newajay.11r@gmail.com>
Cc: Nithurshen <nithurshen.dev@gmail.com>, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: Re: [PATCH v3] erofs-utils: lib: fix infinite loop on EOF in
 erofs_io_xcopy
Message-ID: <ab_b8heJ7z2hF3y9@debian>
Mail-Followup-To: Ajay Rajera <newajay.11r@gmail.com>,
	Nithurshen <nithurshen.dev@gmail.com>, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
References: <20260322060358.1495-1-newajay.11r@gmail.com>
 <20260322072608.2656-1-nithurshen.dev@gmail.com>
 <CAMhhD9jd7wcKtCYXY7Hw5qCgMZ+jsRe0t_d34H9tjSVSgBKavg@mail.gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMhhD9jd7wcKtCYXY7Hw5qCgMZ+jsRe0t_d34H9tjSVSgBKavg@mail.gmail.com>

On Sun, Mar 22, 2026 at 01:22:00PM +0530, Ajay Rajera wrote:
> yeah, sure.
> I didn't know that, so I apologize for it.
> I will keep this in mind from now on.
> Thanks,
> Ajay

The patch is broken, please apply locally before sending out.

Thanks,
Gao Xiang

> 
> On Sun, 22 Mar 2026 at 12:56, Nithurshen <nithurshen.dev@gmail.com> wrote:
> >
> > Hi Ajay,
> >
> > As a fellow contributor and reviewer, one small request.
> > Kindly send the next versions of patches (i.e. v2, v3, etc.) in the
> > same thread to keep the mailing list list clean and easy for
> > reviewers to follow up.
> >
> > Thanks and Regards,
> > Nithurshen
> 

