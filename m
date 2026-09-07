Return-Path: <linux-erofs+bounces-4488-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710F8C79F9E
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 09:10:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdh9g355tz2yjw;
	Mon, 07 Sep 2026 19:10:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788772215;
	cv=none; b=e4KAZM6LmucVJ8eB13WeQkT+zr0q84RYFzUA8E97fZVV65gLDv3ZIfVGdHmWqBaNPFhmhGyeqGPPosoNTkizpGj7pBoREi649nbqXuyoXDDoirEQk65Tsf/juL3+58KoIGzeV7Gv0RRM4THRTdHrSs2rcQI0/UtFWhfspIXqPPqP1Rgz18hWm3WGTNBE0jiNJNIpNKU/GQomsEi+pphKsahkPoyMu2PVArDlW6FwdeVDNeN7f4DbMSOT7AgSmWpv4cWL7cmJWdPDLD4Dvw17QnBl7IKWfonsjyLryRdRk/RmXJKnFAADxLGght74Cwe7iYNwpFS4fQQSNjHUHxcqmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788772215; c=relaxed/relaxed;
	bh=8saWKBIOrYYki44TNpASpMlsBes6PmQBp6zroPpo3RY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cI3hyLlzq6vHAsfW20pukE3CVJLCmkd5HsNXUPBWOGauaBgqFYbMw4zxiYYNA93Oum8QJ9QAPV9yw7w7MjKdJItgqXyzu1KSA/SYg4nwIzgq7jHFuD9sCKoWM1hEcVPPLfEziXVrS9q6bfObf0kwgT+N9HLaTFNTgFnZoGaRI1d0MREPkISdbv7o/0tthfMvVrbNZRp+O9himnalZoQy6EEn4Z+gmtgAx+IQHQKgkga4ZLNPVWpw1Yqz4/5BcxuQx0gpRafu3LizQfeeYLtZHGmEsMxjwolGZOJeEvm8AsB+ZG4lOVYv6Zb9AVT3X6zUnWmldlZkXe7eOSiOAzjBag==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WnoHhqAy; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WnoHhqAy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdh9f306yz2y2L
	for <linux-erofs@lists.ozlabs.org>; Mon, 07 Sep 2026 19:10:14 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7327160D86;
	Mon,  7 Sep 2026 09:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7681F00AC4;
	Mon,  7 Sep 2026 09:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788772210;
	bh=8saWKBIOrYYki44TNpASpMlsBes6PmQBp6zroPpo3RY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WnoHhqAyDU6jmTOf1EXaCLtRJO/lAz+MFKNxcrC7xmIVZaRk6gCxnYIk7c0+dTklD
	 R/MO0xQ6pWRa9YICIwOsm2UrMsMdtS/7rnFL6Smr7sxDKX4JguWHy/5nmsJz538+c8
	 wj8xWF4NY4DMLjKND1AlDdtxRfEvtHZoNy+Xk+NDlTltqiACXFRl2ptWhUnQfxQFXD
	 Lx/Okj0Qh0j0Vl+o1yCIVDWjP4I0rTdusmgLCnLw9AVCCcsl3sKxf2XB+mqsrL7IQ8
	 a/2rzNzzbsASZhgTII29ioKjXNE1iqydVie2V4b1fXMWSFpozYGoN+ITZBK8/YZAAc
	 p2jxwwgr75kSQ==
Date: Mon, 7 Sep 2026 17:10:04 +0800
From: Gao Xiang <xiang@kernel.org>
To: ChengyuZhu6 <hudson@cyzhu.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: Re: [PATCH v2] erofs: delimit inode_share cache key components
Message-ID: <ap5_bAWLkTTqbHen@XiangdeMacBook-Pro.local>
Mail-Followup-To: ChengyuZhu6 <hudson@cyzhu.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	Chengyu Zhu <hudsonzhu@tencent.com>
References: <20260907072440.76001-1-hudson@cyzhu.com>
 <20260907083319.69644-1-hudson@cyzhu.com>
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
In-Reply-To: <20260907083319.69644-1-hudson@cyzhu.com>

On Mon, Sep 07, 2026 at 04:33:19PM +0800, ChengyuZhu6 wrote:
> From: Chengyu Zhu <hudsonzhu@tencent.com>
> 
> Previously, inode_share keys were encoded as follows:
> 
>   fingerprint || domain_id
> 
> It would be better to have a separator between the fingerprint and domain
> ID so that the fingerprint won't be parsed as part of a domain ID.
> 
> Change the key encoding as follows:
> 
>   domain_id || '\0' || fingerprint
> 
> Since domain_id is a NUL-terminated string, this makes the in-memory key
> indices unambiguous.
> 
> Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

