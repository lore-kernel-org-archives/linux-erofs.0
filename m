Return-Path: <linux-erofs+bounces-4735-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA9ABCC6B1A
	for <linux-erofs@archiver.kernel.org>; Wed, 14 Oct 2026 06:31:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j4Ltw5Q5Jz2yYK;
	Wed, 14 Oct 2026 17:31:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791959464;
	cv=none; b=CyuTy9/7l5mL5ebH+oiXKUgf+NS7M4BtcWW2BA09a49OLz1jdb46adoZK3EfKiEHqU3IsV6YsFwQhBQCkTllFWighimGi3xZV86ooONWc8Z/W137U4oQqUSUays2CbRsuWWJ1873QQnRqrN1cFXV0fJqaQ6Ik90NQgF0LjbsQoR2Tu24e8Fw5q+mlhnRT1TsrEtT2becJJSFSWXxyLnJ5hqtTM0WkNvEwre+jIDbC2rCKfHGLgDIKk7srurD43vYatRJXpZX0M6SEIdqX6lFrEPQqhL2gRhdq8fTTY3OzbU5IusDBwNy2LPiopwwz4MFAXQbXP4oSobWzs9nZc55Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791959464; c=relaxed/relaxed;
	bh=rAqJBY8dv5+WMP3CBfvKTe8EJH3Fbbv74cbOG+BQnvc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RtFDrgAAU3bgE1Z6xNS6x0M9KEThpqeUCpwE0twx9uF6zI2RRLfsJ6mgH6lEYo/BmgdvueTK1U1ZZKMlns0XrSM+PsJ8uUxO9QSTpsReiiOklxFEe8D9c2495pjioWFpR6A2GaYKRAGdf0XOzNFbU28g8Nfv3+0sgz2nbUVf79G3IWldUfqKRsE1EMYyES0BtEVaUgBAqXWAxkk7/duVDxEsub2dX9EJg7gJwt4jkF3UAZ8O/XbPOzoJsb9U9teelSTANhgrcTeDQpjJ2sep1lOM4nu0vvj8zx1FCSjsKSDNsec2cY919B4kGmgd+wQJ9g3wt0NS7ydIYRGNbnEVtw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPgp40P3; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPgp40P3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j4Ltv1NnHz2yVd
	for <linux-erofs@lists.ozlabs.org>; Wed, 14 Oct 2026 17:31:03 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B413260267
	for <linux-erofs@lists.ozlabs.org>; Wed, 14 Oct 2026 06:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE71F1F000FF;
	Wed, 14 Oct 2026 06:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791959458;
	bh=rAqJBY8dv5+WMP3CBfvKTe8EJH3Fbbv74cbOG+BQnvc=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=TPgp40P3n/o2tfHr/KQ3IaoR5s3Bsi2GjmugWz9MjAp9qcM/qZ3mR9iSkh3MTMwji
	 HsCp/nDA+8bqHKpNQ/dUepGTwqec2Y3XICiMS5Fjy9IF+3Ts2qXS3u/f4dKYS2AT/f
	 UZtduNTiJkHbV4egLYb7QhTvVK/+gPOpySvxGdgEJwUL6iit8U1zsolEiTJuEvSC+Y
	 kAqxhYCsxdMPwcnkST2mY2g+oFvBn5F33F7mvhMzKo1q6HBrwhkSqbCbTxAVWgcvLd
	 M43GinIwAyaeZRmS+R/1x5oexZZAAOLTS0snN2u2IXwN9ER1xGnLUOeKM2SMhwCLHt
	 AO48c61WIV3JA==
Message-ID: <24e13ed7-d1d3-4c3c-ae3e-8734c519b87e@kernel.org>
Date: Wed, 14 Oct 2026 14:30:55 +0800
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
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: erofs: add dev branch to git tree entry
To: xiang@kernel.org
References: <20261010070623.1766952-1-chao@kernel.org>
 <asqt-vM6LOPyqz_p@XiangdeMacBook-Pro.local>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <asqt-vM6LOPyqz_p@XiangdeMacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/11/26 05:28, Gao Xiang wrote:
> BTW, could we request sashiko folks adding erofs mailing list
> to their review list as well?
Done, FYI, it mutes by default, so we need to check review comment in
UI(sashiko.dev) by ourself, let me know if you want receiving review
emails whenever there is result.

https://sashiko.dev/#/?list=org.ozlabs.lists.linux-erofs

Thanks,

