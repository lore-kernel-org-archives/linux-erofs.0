Return-Path: <linux-erofs+bounces-4351-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA2BC5DF97
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Aug 2026 19:25:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVZPR4bhdz2y32;
	Thu, 27 Aug 2026 05:25:47 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=37.120.164.117
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787772347;
	cv=none; b=TOfOKHIs5sM/d+sdHNHSj1T4Lxr2kAS6E2B+hMZwv3uCaSy9L8hg4KUK1F5haA4FHrlh0vIVwozTrOO1ND5uGmOn48kUZMD53I70/Qm4UdF2H+GOhStep0WuFjruO29l8MV4WVYXVFjWHHhuacuzF1igd5k2MV+f4gNHe+PoRxmqZlyn8N5ASRsdPgcclUTeFK85ihGqH+PZ6urObIEwDuFUVp2Kiu6YXrNZdBbNSEcoUUFrvAfG9j4i6e11qQAzMrgnBjIwLmkG+7fR+i8YUoTpR4ve2Rgb6PCxHTp/LuMvfu267yKaYoXvMUX2Ny3rnK2otf1s6jzEpWJ02Fk+0A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787772347; c=relaxed/relaxed;
	bh=zbVbbzSiFYSTwzgZtR2zHH4b2eBxT69+2G319cZ2Rv0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwzSxgm6igJuohMghlbj+ZLdn3xH6afhsIkNn2dkmLkXQgNdt0v7Q+bw7bL5pC6R38WKeH2MLwAxktH1ClQHq/eIM9sLEkfa45TaDLLWX/ronWKxMg5SptjL5t7pHXrd0AhrzNBxElbV8SC41HZAB6LzpGdGyXKJtHjItUCgzaqLVWbeZ1cUk9CIk12SnuLw/vyTMt41hcxLrQRL1LcPJQYMajOckA33sy5Uc0R8T1A3tOQl949i56TWy5IEYrAWln3LUpKdH2AF7HFbB7oG8XfqHSLJOY6eu804brotJyXAP9mQZ60kDmkEqDZin05n2AJ9HeuIysS7yFkeOJU1wg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=softfail (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org; spf=softfail (domain owner discourages use of this host) smtp.mailfrom=amutable.com (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 401 seconds by postgrey-1.37 at boromir; Thu, 27 Aug 2026 05:25:46 AEST
Received: from mail.piware.de (mail.piware.de [37.120.164.117])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVZPQ2x6tz2xyk
	for <linux-erofs@lists.ozlabs.org>; Thu, 27 Aug 2026 05:25:45 +1000 (AEST)
Received: from piware.de (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by mail.piware.de (Postfix) with ESMTPS id 36E4CFF866
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 21:18:53 +0200 (CEST)
Date: Wed, 26 Aug 2026 21:18:47 +0200
From: Martin Pitt <martin@amutable.com>
To: linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 3/3] erofs-utils: tests: check that the xattr layout is
 order-independent
Message-ID: <ao88F-F9wTDhKjvI@piware.de>
References: <20260804033214.211267-1-martin@amutable.com>
 <20260804033214.211267-4-martin@amutable.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804033214.211267-4-martin@amutable.com>

Hello again,

Martin Pitt [2026-08-04  5:32 +0200]:
> b260119b8edb ("erofs-utils: mkfs: emit an inode's xattrs in a canonical
> order") made the layout independent of the order listxattr(2) reports an
> inode's attributes in. Cover it: stage the same tree twice with the same
> attributes set in opposite order, and compare the two images. The names
> differ in length and share prefixes, so a subtly wrong comparison cannot
> order them correctly by accident.

I see my first [1] and second [2] preparatory patch made it into the tree
[3][4], but not this third one (and the main test).

Do you want me to explain or change anything, or did it simply fell through the
cracks?

Thank you!

Martin

[1] https://lore.kernel.org/linux-erofs/20260804033214.211267-2-martin@amutable.com/
[2] https://lore.kernel.org/linux-erofs/20260804033214.211267-3-martin@amutable.com/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=experimental-tests&id=4b02ea1792c14cb9f250bd55aced5614e699397a
[4] https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=experimental-tests&id=887ce207bc8b068de9771b736333a8da6d939670

