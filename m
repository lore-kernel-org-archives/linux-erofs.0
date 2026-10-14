Return-Path: <linux-erofs+bounces-4737-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBE8CC6B1A
	for <linux-erofs@archiver.kernel.org>; Wed, 14 Oct 2026 11:30:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j4TWy1WtMz2yYY;
	Wed, 14 Oct 2026 22:30:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791977406;
	cv=none; b=a1iE5e+Yr7kVwMPmJT5279Z0aRCXiU7zbyfGdV10eLuy5oM8TWcynuQDOvTBKVlJH4B5i+QxvQZRwzdrEZYXbsKa7Dq2s9dvED7Egd0V22ODiI9KjLB8v5v2fL3JJ0INzgR/qBaJZw5QJYCYpZVJdHPUNFmdK8SFDh46VfT3zo0LC086jLm1naTOYjSoYjj5DYN66WDHPKNoqDt0zVvjyHibrg51t8vcVJAX5kBAQOU9FigY2FBKHjMmUtRHf1RAyFfVUp5zUXOoybTC4HeY7X3kQsCiQnDXBN0sj8dCocXzwXx/6mSyD8X8juiJOQDoDgmPlWLMO7+NlC5sDI60/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791977406; c=relaxed/relaxed;
	bh=xZAOGqD0V9asvlFQFz61mG7hWqFSRvGUK+v/BohrL8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g96BO/c0VSIpVV1H95UlSGndoSpC9LgQITRzglE75df3fJxLFLg2NoEIiBd5jTlkJjEHdGModu1q6PMKxVlBdZ5EBpT2cSfSW0xAvvoIL28G0YBNPenUiL0SpP4cZXUXnQ+Cxv2BcqbI1QCt1wUnMVGpMUze37JgNqH1bQJPGPWooyzyfDxJp1uhD4XXsc033D2g47AOoUPpjJ94rnukTeD+bR8fdUSCzbZ3aD4GqA/w+bR+NfFTZMfFXWRiY0Mgqk/8IR4WKQ59+pMQZAgsYE6HYAbM9jtfkduf1vwiAVY4UPod2F/bdqRS4kgjDmI+36rbkBhMg8YXA41L5qY5ww==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPjaXAkB; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPjaXAkB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j4TWx0pW5z2y8p
	for <linux-erofs@lists.ozlabs.org>; Wed, 14 Oct 2026 22:30:05 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B25BC6057A
	for <linux-erofs@lists.ozlabs.org>; Wed, 14 Oct 2026 11:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1681F00893;
	Wed, 14 Oct 2026 11:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791977401;
	bh=xZAOGqD0V9asvlFQFz61mG7hWqFSRvGUK+v/BohrL8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LPjaXAkB+nmSt2Am5UyGuKwwg7cy7uNdN7hMG2xRfrV69aWICyUYwbV/Z3mwTsxGA
	 lPKr7hSpadwDMU9FhWLiiuSlsJgufxn7liA7vv5XPG/lXTl/gmExs8JZcq+X5N4xax
	 DLw5hcVCgXT7mTXfNtnnrDglRvKjycDN2Di1ZcYHw4N6D7JY8BE+jzfLsEa+6fmr65
	 BcmzHNEyEzT/Ws2h1tENxDqtDnwkCTpcS64fzvEH0IZHkxK2NM0OqFUoFqwM0+7sZJ
	 zMNRZQqLzE2evQcnAOxhO8iDG1fhGwHPtcvbu5aLVgubdb8zq3uhRILJd7fm6E8GkO
	 NJ9qaSlmDzKXw==
Date: Wed, 14 Oct 2026 13:29:56 +0200
From: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: xiang@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: erofs: add dev branch to git tree entry
Message-ID: <as9ntKiOFsEN96z4@MacBookPro>
Mail-Followup-To: Chao Yu <chao@kernel.org>, xiang@kernel.org,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20261010070623.1766952-1-chao@kernel.org>
 <asqt-vM6LOPyqz_p@XiangdeMacBook-Pro.local>
 <24e13ed7-d1d3-4c3c-ae3e-8734c519b87e@kernel.org>
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
In-Reply-To: <24e13ed7-d1d3-4c3c-ae3e-8734c519b87e@kernel.org>

Hi Chao,

On Wed, Oct 14, 2026 at 02:30:55PM +0800, Chao Yu wrote:
> On 10/11/26 05:28, Gao Xiang wrote:
> > BTW, could we request sashiko folks adding erofs mailing list
> > to their review list as well?
> Done, FYI, it mutes by default, so we need to check review comment in
> UI(sashiko.dev) by ourself, let me know if you want receiving review
> emails whenever there is result.
> 
> https://sashiko.dev/#/?list=org.ozlabs.lists.linux-erofs

It's much helpful and sorry about the late reply.

Thanks,
Gao Xiang

> 
> Thanks,
> 

