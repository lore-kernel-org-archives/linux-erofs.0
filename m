Return-Path: <linux-erofs+bounces-2405-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD33CF55437
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Feb 2026 02:23:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fLJL61K9cz3dJw;
	Wed, 25 Feb 2026 13:23:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771986222;
	cv=none; b=LEFR7jtKLt4pUmdsmD8i5P42MFO6DeFeBzIarwB7+WSTPkg4hx+yM94LwD9Oxyb8GKlijcJhPa6tvRItxpCB7G0lym6n9HFWiRtWTn0xTKPMjC7AE1SINEliFZwNBm6ozKdeu9LIX2hYkafnP/xGxEr2fpvwMyGAPEpU9a5SJNc/SmdM6NyTNnp3783dpEQf5pGoV5KbHDQa4DY8Nsi9iWmt/MjHqRt26lwoVhK4bBwN9V92sbLcKeUW4BWsSIbD4iWfx2xpDczbcgOPTm0Dr7xoVjqDf1IxERvTDUSkBKIZa84mNrMO/YXaCPi8lgQbvdd4xHfOl7jNtdsQwiT8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771986222; c=relaxed/relaxed;
	bh=5IeQWShbexQQqZX6+JDsBvsl8Xp9jcNc0yotflXjUxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f53QCLftOLWba6d1My6qsmdTnZ7rcLy4KrtBsyz7gkubFFmmp9Zl01szMiFgrCGtRMXBgkqG+0wpXRddCqWHOAQld1MBDsyofktE7hgcpxlurx9ZTOeoMB9DnTkxlaQFR6myytLwK/GTu6NvGN6tzsRI8tAbdKnLuhzB5ULoavaYeeIpF910KNCk7upPNvJxsXyZIq1Do6u+weGiihdR78FOJS3dVAaQpp956fJvt1dZhOhB+Plcgf6bA/+trFr1naTLNvayGXIr1RqtcMbVp2vbWNOXEAuq+JJ14BnLH5edwsFm0UGNfRm31PjoKVnI0HVEsMYmequ1kJW6HqozAQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NGZXaRGu; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NGZXaRGu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fLJL25H3Dz3dJg
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Feb 2026 13:23:36 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771986210; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5IeQWShbexQQqZX6+JDsBvsl8Xp9jcNc0yotflXjUxs=;
	b=NGZXaRGuPyNVpQyFYZQMUME0pSTHD/lLmPPUbp/Ba59SJEHXL9seUEfa5Kjy0TpVYoQAeTqIyKo4jk2ldyEIVgTc99CV5BsLcXMtXq7+BBKcbIlICxu5xIskJloucxVvp5DXWbOsaPlUSpdVJvJEATVPqAZ9i4vgdsFx5gcG/20=
Received: from 30.221.131.204(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wzkp4G6_1771986209 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Feb 2026 10:23:29 +0800
Message-ID: <af4bff1e-1893-4a09-a5ed-27dca9ec7767@linux.alibaba.com>
Date: Wed, 25 Feb 2026 10:23:28 +0800
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
Subject: Re: [PATCH] erofs-utils: Raise maximum block size for aarch64
To: Matthew Lear <matthew.lear@raspberrypi.com>, linux-erofs@lists.ozlabs.org
References: <CAPrOGNB56AjZ8C8fRChucWHHhLHQoim7xPpz3eyFXwDCPJ02YA@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAPrOGNB56AjZ8C8fRChucWHHhLHQoim7xPpz3eyFXwDCPJ02YA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/2/25 01:02, Matthew Lear wrote:
> Ensure MAX_BLOCK_SIZE is at least 16384 on aarch64 so that native block
> sizes can be used without the sub-page fallback.
> 
> Signed-off-by: Matthew Lear <matthew.lear@raspberrypi.com>

Thanks, applied.

Thanks,
Gao Xiang

