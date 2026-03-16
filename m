Return-Path: <linux-erofs+bounces-2712-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F21F7F30296
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 01:48:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fYyfT0Pskz2xS6;
	Mon, 16 Mar 2026 12:48:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773625696;
	cv=none; b=P74YKYqH1Qj+3eu5Tz7CEvuwrxijL0r1h2m8gFjH4p5WIiCRJy6EfZUaoPVaS1KaNY2ojDsQhLgpoSEIpAamns1zCDyDMF7JXHRguzRYxNuXEXjPZ4H8HibHm4jdRkrm1wkIeqFpCEhhTL80hVzu3XCMpkgi5N03Bu14cW67FVjhDzLpFCcagl0bdZ1J11snMw2EOxsZWuOXSX/n1FV2ca7VTEwC8E1SCRePLvY2rVjtZEzekBJYssC0tYCQ/8KYkXUelTQjtW+v6SGdQzQ2K+NtuAnpxYWSKXogcbMTfMJZ1f1o5ITatkCMu2TheA1sCpNPAP/1yGe57LWGhAZkfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773625696; c=relaxed/relaxed;
	bh=tjYSyouWdxg21ivOI9ueYUjH+6ofFYM/3eeTjSwkKn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZRpuvLtJqOIz6BI3EMrutc6VN3oVpjeTqLnxF7RzkyikeSCclEB24Vl8g4Y+xHqdbnJPEzhxOEYmYbLafSzJutvqB2SbfVL3WsgIibA96I1K8JkehSjf1APoBld/by9mGxLz1np/lG98/dIQ2roHY09sIEUwwhXDwM57XHYOiFAU/ddVmVFbhwhJGJgOXLghGqwem1c6xAu5NpYG9C4guqhjMlcvYFEnyvxiRauW0UYXHAxU3bBs1Y7jQcFwb7lgw8wI1609Ou8d4d9ooA1Bv0SEF3+wHI1BWodmfSBFnFXngtrEFEJtjPNXNo5pSKw701fTCNywB1RnPjDDKcXdFw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ujPLHblu; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ujPLHblu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fYyfQ5Rt9z2xQD
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 12:48:12 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773625687; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tjYSyouWdxg21ivOI9ueYUjH+6ofFYM/3eeTjSwkKn4=;
	b=ujPLHbludxQd1mUplmAwU6sGLfWvYDRKie17AXqOF8kLS6qUb8rfrAJ77ZssXZz747Q4efmInw0skRz2G+/RUKuz+ZBfIzUvaZ5Rwq3reJgyciTelpV8CahpQ3QZ6LDeJgSI82hw1fkdQrrggdzlWKyNVqZIx6gD6qGstCWKUDM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X.-F3MH_1773625686;
Received: from 30.221.132.167(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.-F3MH_1773625686 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Mar 2026 09:48:07 +0800
Message-ID: <3781ee92-cdc9-47df-a8f1-7f5b514907f5@linux.alibaba.com>
Date: Mon, 16 Mar 2026 09:48:06 +0800
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
Subject: Re: [GSoC] Inquiries regarding manifest format and implementation
 strategy
To: Sri Lasya Prathipati <lasyaprathipati@gmail.com>
Cc: linux-erofs@lists.ozlabs.org
References: <CABDnCWmf7NkT75a5zHAzixbLxpKSdK1s35GBC8d1s=-YosBncA@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CABDnCWmf7NkT75a5zHAzixbLxpKSdK1s35GBC8d1s=-YosBncA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/16 03:34, Sri Lasya Prathipati wrote:
> Hi Gao and the EROFS Community,
> 
> As I am finalizing my GSoC 2026 proposal for the project "Support
> generating filesystems from manifests," I have been researching the
> various manifest formats mentioned in the project ideas.
> 
> To ensure my proposal aligns with the community's vision for
> erofs-utils, I have two specific questions:
> 
> Format Priority: Should the initial focus be on implementing a parser
> for Unix-style proto files (similar to genext2fs), or is there a
> stronger preference for supporting composefs-dump style manifests from
> the start?

I think you could finish `composefs-dump` style first, and then
Unix-style proto files.

As written in the idea page, it should support two formats at
least.

> 
> Integration Path: In mkfs.erofs, do you envision the manifest parser
> acting as a "virtual source" that replaces the standard directory
> crawling logic, or should it coexist as a hybrid approach?

I think it's up to you, the hybird approach won't be hard if you support
the pure "virtual source" one.

Thanks,
Gao Xiang

> 
> I believe clarifying these points will help me provide a more accurate
> and realistic timeline in my application. I've already begun looking
> into the mkfs source to see where the insertion point for a new input
> frontend would be most efficient.
> 
> Looking forward to your guidance!
> 
> Best regards,
> Sri Lasya prathipati


