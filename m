Return-Path: <linux-erofs+bounces-3628-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9FBCD98DA
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 11:33:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gflGp0RPxz3brH;
	Tue, 16 Jun 2026 21:33:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781609585;
	cv=none; b=OYuKRH9d0pIvEgjZjJ8BFIGONNcOsCSctszG2xAwq4q5D9+dsVu5t2SBwr6azDTGeqEXbnDX8fI0JYfOt4bCf79gD1/HD1nb394EsWUcVHTPQ+6TcnXrD8lJqDmz7pvFEqPJyWAjwInXO1GLwDzYfFpFr1D8RoHdptH7on6m6tbq80pRwJRnmG0Au51lMHUtElzGYFZLdoeqD1P9B80dptfJ0WfHK9Rl8ybYT9CHuR6vOPeSaQncpGSYAGfFvMbUX83yr84AZvIFbaehFLxA/qbo1E7bvZM0o3v7vhh7ObQmc4IJgaUaCbEM4mJt278Vw0PgoxaCKiOSNY42CYrkqw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781609585; c=relaxed/relaxed;
	bh=3jUacLBnaiUT8m88bzKss7QjSDoac1btVgY57AcZMV4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fUenDAO/cLEzqf9Xspe/cqULpM+B+TA95DxO9K4rJbgdgMcs0B6nXBXZtoWQgBv6Vi+4KsMfRU8yKEwZCUatBmO6vvM0SiSsVXWG2Ec1VeO2uXLq1qFFMSJpWaVn5bHH3o2gZkHPcb2kJaX+JxBRNrGnT7jQTaqbG4D6gkxM2zZlFEohv1StywR8dc4LKDILKVFwUHmZbWvFrr+dyxDIZPb7c9suK6/jkKBfnTw9V5pqTAaxTO3dWZjs6AV7Hk1QT1Uq3y/qkS9FAnyMrsor3tKP8uLOx7C4fOjhaYbFTUkWMO+TGVxrhC3JPEg9yWY0AsQCaFQ9peag0ZLQxbnajg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WgjKow//; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WgjKow//;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gflGn0Fjbz3bqh
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 21:33:04 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F4314180D;
	Tue, 16 Jun 2026 11:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595771F000E9;
	Tue, 16 Jun 2026 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781609582;
	bh=3jUacLBnaiUT8m88bzKss7QjSDoac1btVgY57AcZMV4=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=WgjKow//JXgyD/56WCfiaRtjxvaNlvsSgGjwQxbqfY4iz2B8IBBtcwob2gffp9IwJ
	 Xmni5VWtpJ7T00KneG9C5Ysy/nqL+pMgpDoAL77+NHDQ9WG3h/eUkYKuORKj7gY6zH
	 vGdBy+Q8iQSvCO0VYm8LEWbccgu5vCT+q6E3KMAumHpJZBqCdlLe3aNLtEmqkBJg6N
	 JpGwYVkwXji79LbkmONEiWvTQTnSxtaFq7WWLbhN6t4rQ2RkXsFp0e5o7A7WjNnow1
	 P+ZcHOoXLrmkuOmzwm3fETPYQVSOy1ya+p9wnWFoK03/QEZkxig1/N59puwpiQjSqW
	 BySWEL/FNYekw==
Message-ID: <09934a59-1504-4de7-811a-8cea4824c64b@kernel.org>
Date: Tue, 16 Jun 2026 11:32:59 +0000
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>,
 oliver.yang@linux.alibaba.com, Hongbo Li <lihongbo22@huawei.com>
Subject: Re: [PATCH] erofs: clean up erofs_ishare_fill_inode()
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20260607172132.2695176-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260607172132.2695176-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/26 17:21, Gao Xiang wrote:
>   - Use the shorthand `si` to replace the overly long `sharedinode`;
> 
>   - Introduce erofs_warn() and get rid of barely-used _erofs_printk();
> 
>   - Get rid of the variable `hash`;
> 
>   - Simplify error paths.
> 
> Cc: Hongbo Li <lihongbo22@huawei.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

