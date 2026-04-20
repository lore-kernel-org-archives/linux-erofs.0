Return-Path: <linux-erofs+bounces-3329-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EFFEA71A4
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Apr 2026 01:54:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fzT742b03z2xTh;
	Mon, 20 Apr 2026 11:54:08 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776650048;
	cv=none; b=cu9a3p77I/OgGJkw3Jg9NvWP5Dvzjbeavktht9Qv00WqUzNu8LEj4btV3Pq57P0D3YsGjIn68A337FpyLUMXgOVt0rMBCohKFL+AhAT8wXHiD4EbjEyUGOUAmXInJw7jaspFuZKNzUsof9WQX0Me9c/H48cv79RF1QBoNHl7PQbxI9kMbPaIiiPjhMYQfIG+2wH5MZidSe7OtNvsCTigKyjLhrZZt6yb/QHX+NC2cJD1aWcm2RoNhwwZy/YI9F/qMOOtOKzvtF7/sQMMZb9vKIEo9Wu6PNXyAZcgmakIBn3DGuCysZfNOgh1kAZ3uAl47IRoJw/IU/tLJUSBwnfqbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776650048; c=relaxed/relaxed;
	bh=4RMnuNbO0/jQujtQ8lLINRmO/1eQ1Lo875lWkDVnl/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FkyqVje3Ca+K5VMqDud2GhE4HXVyx1aFe9odA9O4Uv8O2ZbxSsUSKbWX42WczN7RYg2WRHCuK72fUYG44ZfVCLSfEF94oD9HYLkVSEogB+bC27xySdx3TE6FzFXrNemwC2ytqRPUogK2qYnUwaejEG0wqtsmMAXgPmBuIyRIh9tbNGQuGK48Xe9sMlxGTn/cwfWHl4aW+MCSeiT843iYaHiH9R0AF0ZeBuLiFJhIkweLFC0ov8wt63bGplYYxWAjxuNiyL58ycQvAV5n15xc5ik/+BHGbQToDBInGtQwSxKxibcljiMDJth1wEw5WpVSKQy1RhNfnpw3zqKLY7wh/w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xuSp+qD6; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xuSp+qD6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fzT733VD9z2xSB
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Apr 2026 11:54:06 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776650043; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4RMnuNbO0/jQujtQ8lLINRmO/1eQ1Lo875lWkDVnl/A=;
	b=xuSp+qD6Cmj41jsaXsbNzLt6imT8ZZyiR2fW75pWvjicOHI1+98x1k4a0P1ZcB64QiE0slQDBFdnFw4GxbJ31nW9/Gv93tFirItx2cZKRA0Sb+nETqFFdU+t2xWqwbpLa1qdlBI5z8VcVI6kkVnmPyu+cZvt0n3cTqSrdGG79e0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X1GZir3_1776650041;
Received: from 30.221.130.173(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1GZir3_1776650041 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 09:54:01 +0800
Message-ID: <154f55bf-aa67-406b-bcd7-1306b408be81@linux.alibaba.com>
Date: Mon, 20 Apr 2026 09:54:00 +0800
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
Subject: Re: [PATCH 2/2] erofs-utils: libzstd: fix undefined behavior shift in
 setdictsize
To: Nithurshen <nithurshen.dev@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
References: <20260419131604.95875-1-nithurshen.dev@gmail.com>
 <20260419131604.95875-2-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260419131604.95875-2-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/19 21:16, Nithurshen wrote:
> In erofs_compressor_libzstd_setdictsize(), if pclustersize_max is 0,

How pclustersize_max is 0? explain please?

