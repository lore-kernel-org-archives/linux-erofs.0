Return-Path: <linux-erofs+bounces-2386-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF10CE9B249
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Feb 2026 10:34:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fKvHC2ltHz3cLN;
	Tue, 24 Feb 2026 21:34:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771929287;
	cv=none; b=hwW8TtehcHoOpLDeNqsp5GqY6zGxWAjTJXXoOGGPViZ9QLkWuaKvL+qi6N0ZodOrNMVQyc1DEXMRSjcutM+u1jhdQu4gKC8Vum/F6kaaewb+HASX0ekU6/BB+zmRjfJB8/46jeX+WA90d/YGNA7jGUjZMRPhMkhdOOYym04xQ28QG1SG2yjLCLWb0e02FbkWC1zPfLKv+MUq2CPsBFmyjpwfsI4wZp3JHQbQo8L6x8PyySj9H2fllKI+EBv14o+jdrxk4yYEA8Em//b8yL5GOXEGJAa4cyB1vbmfPCwGAvieQ0YJMYWNKU0P5A/41aO08B6LOXWXGGVRQl7ZiIQcBw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771929287; c=relaxed/relaxed;
	bh=dfK/h7ykdNIlNJihdZKk5J4vMG/oP2siVLcPbLZ1zSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hizK+8vDdmI0g6jhfRubFUIPJ/9su+MCw2aRPO04o//AhlEtN2u819d3Fo7Gx0llmdIc1syDDdI3EFZWFyZMmnW3HdT3U4NJsmfOc2SquL4nSjeeRy+0lZhEiJD2KLmjb4HOWDBTwuDIU1kyH+MssCmtgLpaUXRdpJuuAV8crjLkg2ve3xYfxxbmHztDUV0YGKWfJ5+/QRS3iGppcbuuqC4PMvYX80w4++ej+qdoRdJfEsZwZmC9vaqDejiLYvdilIrt03vKEn4OhkuxAH24d5Y2mFz/jE5nHXjVuR/zWjXzbJu4jRCva65uT1xeX9rUj7DTF/Ay7goCzNlNrHohYA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=O1k0/rDl; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=O1k0/rDl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fKvHB1zdTz3cLy
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Feb 2026 21:34:45 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771929280; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dfK/h7ykdNIlNJihdZKk5J4vMG/oP2siVLcPbLZ1zSI=;
	b=O1k0/rDl3tt37SzdyrgMQLfLri0bi6QcFv8R+KtQtcFy/quWJSwY0HsxY+7/+fZQqC3FblVadKXAMOVP8Y5mfFYNwjilJ2rc32FMxZDgktOEBUWjVlD57i+4rrnPQnXIv6nThMAEEySWe9hRAlgEV4IgO2jkTr8qY/KPrVY9zlk=
Received: from 30.221.130.254(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wzj9mZ1_1771929278 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 18:34:38 +0800
Message-ID: <664fae30-9dd7-4f21-9143-072e81854336@linux.alibaba.com>
Date: Tue, 24 Feb 2026 18:34:37 +0800
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
Subject: Re: [PATCH] erofs: remove more unnecessary #ifdefs
To: Ferry Meng <mengferry@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20260224060207.49649-1-mengferry@linux.alibaba.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260224060207.49649-1-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/2/24 14:02, Ferry Meng wrote:
> Many #ifdefs can be replaced with IS_ENABLED() to improve code
> readability.  No functional changes.
> 
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

