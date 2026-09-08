Return-Path: <linux-erofs+bounces-4496-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D02EC79FA0
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Sep 2026 06:05:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfD1h0D1kz2yFK;
	Tue, 08 Sep 2026 16:05:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.135.91.214
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788847511;
	cv=none; b=GK+4KyozJv6kiv8o6dGcINipQVSpZ3R4TtfOwLgQwJCD+q7vNdBxY41kfJHcY3AfzYqybWDv2T3bQ7LsGMMzOvzfcatxrNwUgqFdZEp+Atbda9cksILfw3niTo13CH0Y1u1ziEl9TgEavlran8bDf6qWaX7ojEH3vzUbNQizhlQ1g1UuHid8THCVE3DQTWMi8i6136bxglki/Rkwb5YsFKEf1DucWYr02F7gnsUx3lnhXOeA6SLhJzL7+wcTh/bEmZ1c7ssaVmOJbqj/y37Jrk39axD3Orbf/qcePz2ZTWxNYAgWw107ojhQBjRUASdYrK2afAPdrGfBDTtw4vHR8g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788847511; c=relaxed/relaxed;
	bh=ZteNFlbVKtQFbhOb1IFZdAQlOhf06PxVtOnx8xHKOKk=;
	h=From:To:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OkyA1MDpXhi5BEYj9+JklpCZYu4zyxdnOD330hQ1JKhBqnYAtjy2AzFKgGa7mbfu+UvNIEEIL4ny2aCxSznlQ8TDHPZJgbvaByTnaeKcpamsgxPzC7+5RpUT7GFBVM97eZVxn4VsZPwuw0OXTDXU+DhMh2jCUb/FoAWhpeK193qRzsQ5UU2wKwyeB3HMTP9hpNzyB1t4BxkMV8ha3M+OkNBYblxODxSlUYWmxmh9GmJLIUmAw2OieJgwKhDO7aSTK4paPQwx80lG/fr0s5LBBq6i25Pog64QcG04m5sjA+DhGPRAwJOwqPHRIopD3Cm7Sr5z5j+rZ10dojoUWAKFuQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=culturalines.com; dkim=pass (2048-bit key; unprotected) header.d=culturalines.com header.i=@culturalines.com header.a=rsa-sha256 header.s=default header.b=h36kETmB; dkim-atps=neutral; spf=pass (client-ip=148.135.91.214; helo=mail.culturalines.com; envelope-from=info@culturalines.com; receiver=lists.ozlabs.org) smtp.mailfrom=culturalines.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=culturalines.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=culturalines.com header.i=@culturalines.com header.a=rsa-sha256 header.s=default header.b=h36kETmB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=culturalines.com (client-ip=148.135.91.214; helo=mail.culturalines.com; envelope-from=info@culturalines.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 4056 seconds by postgrey-1.37 at boromir; Tue, 08 Sep 2026 16:05:08 AEST
Received: from mail.culturalines.com (mail.culturalines.com [148.135.91.214])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfD1c5Hxpz2xqp
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 16:05:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=culturalines.com;
	s=default; t=1788842496;
	bh=ZteNFlbVKtQFbhOb1IFZdAQlOhf06PxVtOnx8xHKOKk=;
	h=From:To:Subject:Date:From;
	b=h36kETmBGKothyiOiemDEhtZM/pwh8NaVl8+QkmsiFL2rMhGdEsOgUWBOH/zSbAnv
	 DONTUXXTTNdlmm+WYyiKlJp3HmwvBNV/HeVVRZ+SgJJxSQesJD/9TUOWffscaZCfj3
	 CcLMUI+2/OnefoG2f4Q4TV7m2fvQIqUmRn4BgNaYNP7H+Myf709RFP3IzHRjAaJgQ9
	 uhZWB7y/hduwFXKuNcFvCrOtRwoyn/Uqfv/3fHkkonHcitywy3aM099AXs70GNtvzz
	 F7HOLYdKE3kQVVW8wffb5biwR7OBi1VYvvxx+GEOj8vV/YEI02bVA8zGt1ex7ihwK/
	 QyT+97a1a3s3A==
From: "HR department" <info@culturalines.com>
To: linux-erofs@lists.ozlabs.org
Subject: Your latest payment stub is now available to download.
Message-ID: <f9f681dc8b7f192b68c8affd9d8c053d@culturalines.com>
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
Content-Type: multipart/alternative; boundary="91dcf73a582a86a4bea1293812b6243e6971"
Date: Tue, 08 Sep 2026 04:41:36 +0000

--91dcf73a582a86a4bea1293812b6243e6971
Content-Type: text/plain; charset=UTF-8

Dear Team,

Your latest paystub is ready. We have updated your payment account details, so please review your statement to ensure your bank information is correct.

Best regards,
HR department
--91dcf73a582a86a4bea1293812b6243e6971
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<table style="width: 100%; background-color: #f4f7f6; margin: 0; font-family: -apple-system, sans-serif;" role="presentation" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="padding: 40px 20px;" align="center">
<table style="max-width: 600px; width: 100%; background-color: #ffffff; border: 1px solid #eaeaea; border-radius: 8px;" role="presentation" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="background-color: #0f2a4a; height: 4px; border-top-left-radius: 8px; border-top-right-radius: 8px;">&nbsp;</td>
</tr>
<tr>
<td style="padding: 30px; font-size: 16px; line-height: 1.5; color: #333333;">
<p style="margin: 0 0 15px;">Dear Team,</p>
<p style="margin: 0 0 15px;">Your latest paystub is ready. <strong>We have updated your payment account details</strong>, so please review your statement to ensure your bank information is correct.</p>
<p style="margin: 0;">Best regards,<br><strong>HR department</strong></p>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</body>
</html>
--91dcf73a582a86a4bea1293812b6243e6971--

