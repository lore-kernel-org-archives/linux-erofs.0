Return-Path: <linux-erofs+bounces-4086-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA18C55184
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 11:19:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDDjK69Wfz30F0;
	Mon, 03 Aug 2026 21:19:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785755989;
	cv=none; b=ROcwalho5ZRtNxXaeSl5RwdlkRyvozKi6vfVeNlrLKmQf0b0n9kcrXuaVzprF46RiHD88WdskQlqvcp1db8iqL2n7cPMnbOap93RhCtHld+Xr2FR0cuCacKFYb390YnOB1rHM59nT71st6oWpVp1OXZuzEU2yNuV3aHhmpjn8HOvpB7Fs5nPGVwjAb45KJNoohwJrH773ddm9es1kCQcBl9AMVnDexLrVfGyKOdBDVvrdyiXLguRsj0ayTTufiF/NRyVkOXfgVYstGX1V36Ei19zv9hzIrfkAF6iUwDAx1Cr/BsgzV51jkS6UeK/VUhSpkh6vmp4ep456qUJNxQCdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785755989; c=relaxed/relaxed;
	bh=WQBkxQ2AX/52cAHPkbqQqMsNwDfEvMybiycZcHAqjwQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NW7p8xHlWNJmainJIUKWg/2wSbQGeXHZfQsh3tA4ReYXThYKaM+OTw45QV1GR33ohClUY6ubjjDFut2xzAb0ufuOSG9xijTS63YmeG9EhQSY4vHILrAkntGadBaTK/TG3MLwYZa2jyiPa31znPkYZZnHbYozaM1S8QPFG9DtOLF9ZvDNLTW489l06y47nvMOm8ql25S1ONQ8Nyyy7TPRgWRicLwJ+iJigztrm3SJTsJUdI6pEvZzpT23y2dVnEnCnIvXvXPVmF55xvzM1CTg3Nl42/p8tPEBzBk14VVaiG3I4Eo/sSz1pCQoXi33EkBwpA0PfSdY7hw2r/wFIE5e9Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CZzcNpJd; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CZzcNpJd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDDjJ6rbbz30DY
	for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 21:19:48 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5434160A82;
	Mon,  3 Aug 2026 11:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E851F000E9;
	Mon,  3 Aug 2026 11:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755985;
	bh=WQBkxQ2AX/52cAHPkbqQqMsNwDfEvMybiycZcHAqjwQ=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=CZzcNpJdKTPlgXOhOcl6kBBt4QSBln9/4VVQdV4I0xY6gsofsyaiqEdzGTQ5Hq4YI
	 CKANlZTOUbiMJpqGAKoYszhm8LVi36kM24fYR8VuHcCR2XIlcTbzK1WKZlbcmPeJeT
	 zThWwkbTiz18Oj/evLGz2aYmZTs76IrXwyAT65zqBh7Ox7UetPxT4AeKA+WD1KSLdq
	 X5j+n8x8guDzu5D4zCh7lyOxiXTU9NPzYx6NM8Sb3WWBB3RJJhdlPrR3FHMAugJe1b
	 +taUo2sqpNv/Rqkjsg0nV0db9Eyusiq+YZxaacmOlkiW8lShs4Twnd1Y+I5+6QZ3IY
	 SMs4l6roCM0dg==
Message-ID: <e9814344-c952-4eb9-b905-67da60b39850@kernel.org>
Date: Mon, 3 Aug 2026 19:19:42 +0800
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
Cc: chao@kernel.org, xiang@kernel.org
Subject: Re: [PATCH] erofs: fix typo in error messages
To: Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org
References: <20260731160642.2273938-1-gscrivan@redhat.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260731160642.2273938-1-gscrivan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/26 00:06, Giuseppe Scrivano wrote:
> the option is called "inode_share".
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

