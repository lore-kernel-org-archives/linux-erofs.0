Return-Path: <linux-erofs+bounces-2740-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21E9EF46443
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 10:05:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZ9hd4VKqz2y7r;
	Mon, 16 Mar 2026 21:05:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773655553;
	cv=none; b=QHOWIIVrjLTF9tAm8Zau9uoTkKUe+Q2IyWz1Shj0d0Wyf3gaxBDcXRLAWKcJHFWGIdTAK2msyO3sSmGfnYp04NV6P4er/RXTo2SICYhMGuXod1uv7y6NQ3pmgsg5vDz5nhoA+oqdfLh8dcRc2ph7A7vWE8JhlwQx5FFVMByeBchiw9dcorT11rubR+Gf82uLF2ZBo6CVVLswLpOuhuWLJoDymEsQrTddgRzPPMRXuIUFnBM4lZVk+WquyTfmpoO/EddB8nFkIIoA+YMjHaIlav+y37SC8dWf4mg9ZDd+3nnncM6NkWBZqSLSCB3kosXrjvKrpU0KJA22GrQmhp9ueg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773655553; c=relaxed/relaxed;
	bh=bB6Oas7JBeOBPOE2gPHovhx401HLRirj09UBX5U7aY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L9yqynfx7gSrDpTi1swu0ty4DXN25ULbzksTcGu/Pa4rhUE6WCTY8IhE3c+ollaEybJuZJ0VSgV2IWgcgUpkQCg+jwd5URn9UfOLAaSEvdS+bhgLvdK7j0KutKIjxjpNmYuHpHpIPKAHufDdqfx8mCPkh2lSFmmmiI2QMdqM8pTr6YqJ2pLSegJs2C6xkxuAlQVmSMvB1gqrtBm8gYbChnF7BS56+FTwsFI77EwS00V/zvmJ0W5IS8qn0ELa+TVjuuBVRlnanb21U9/TP+7hiXJhmF3xDRVTt0kd9DKoLP3VmJgfVICTVhM/A1ps1BXieTg7h9ps1jwGfOOgFan+Jw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xsPLhPX4; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xsPLhPX4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZ9hb2cKRz2xlP
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 21:05:48 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773655544; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bB6Oas7JBeOBPOE2gPHovhx401HLRirj09UBX5U7aY8=;
	b=xsPLhPX45t8yqKcXT+b98ZF5CAe1B2qqHQliiBbpsbMpglgIyvqF5sl9XLyJCjC4o7uQtzNW+b8x/7Y8eKsEL7wX1E6mWu4FJ6/PD9NZ5FmwG09L2xrmfcBt0GV36838hRREmHpPAeelXja7nJszb+ZBOjCy+gGDkOOk5mVXPLM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.2cMcF_1773655541;
Received: from 30.221.132.167(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.2cMcF_1773655541 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Mar 2026 18:05:42 +0800
Message-ID: <f41d39cb-fd4a-40b3-9249-96ac33ce4462@linux.alibaba.com>
Date: Mon, 16 Mar 2026 18:05:41 +0800
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
Subject: Re: [PATCH 0/2] erofs-utils: minor cleanups and enhancements
To: Nithurshen <nithurshen.dev@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
References: <20260306085717.12776-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260306085717.12776-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/6 16:57, Nithurshen wrote:
> Hi,
> 
> This patch series introduces two minor improvements to the erofs-utils tools:
> 
> 1. dump.erofs: Removes a redundant conditional branch in the filesize distribution output logic to clean up the code.
> 2. fsck.erofs: Adds a warning message when encountering an unsupported file type during extraction, rather than silently skipping it.
Those patches looks good, but each line in the commit messages
is too long.

They should be no more than 72-char instead.

Thanks,
Gao Xiang

