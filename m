Return-Path: <linux-erofs+bounces-3195-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED1AD6AAFC
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Apr 2026 08:27:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fnBg402lQz2yVP;
	Fri, 03 Apr 2026 19:27:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775204863;
	cv=none; b=mR+PvNj+7pn7ZKZn1+ufhypM0bX6k880VqQ6AiP92xeRS5sjAc4E76y0Viwmazv5BzNolGajR24nz+i+Ssycg7CF9Duf9uA7bp2hGTJDn31n75Rt24MB+rzY2vZTC4ivkCe8Q1P7JEbXIXZTCiqiUyHFLsWaGiTmZhz6lLXNFuSMq+clcPb+j9D/SbzWwiiA7ftu0kziNvYcbR7zLfT+wIvh20G3RNNxH6GnBALPE15QW228MgR/Lx7SP8f++Bwx6UsTv98kI7FPZx8/IKXPazC58q2Slq4Legh66HK+ECHG4H/uUG16J5GiCJF50ENm/c8AVKe4l/dSoRkUk7lMGg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775204863; c=relaxed/relaxed;
	bh=WwIVq++6ZGZSOsvQFz6ZBP7JWcltK+ZVE+dMkEeDzmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BELIR1peF+Gin3Mx18VPecyQXXWOLvA9dP9/ZclOoUtC6R+do5bvFvJvPG6mP/KpiQLJm3eXSZrCaaSbv+/7beTRR77/QUeKDwpkxtpDIn1J4a3OsO79gVhMvDOG4BgHjxDCssXgYoP9E2kvqh8XZ9odd82O97JGVNI04sh3jz55OhHrj5o6XJT5SBgql2F30GoqJl+BbmOszSFh12JWLodLfVqSMXnO05fGnVCAQNrm2agAi/o7MPdQrNsMRxGGWyXnqkx2mBAtXAoB3KD9Q1fmzvVQN0bt2OmlUKZZB0+xTM52xdSCUX8BvGMCSbWxCr8LMYmRPrRz4IWOERrbUg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=L6aJ2lkS; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=L6aJ2lkS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fnBg13PSxz2xln
	for <linux-erofs@lists.ozlabs.org>; Fri, 03 Apr 2026 19:27:39 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775204854; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WwIVq++6ZGZSOsvQFz6ZBP7JWcltK+ZVE+dMkEeDzmM=;
	b=L6aJ2lkSgnWfv47HiS/OR0B5DPcAlWNMgZVqQjjEI6dNR+u/SOw371D7PppCI2bZYeQ1tk4ri7GFNU5T33wZE7xt1vVNC9PcG2O3rHVg1TUf2FO1grJMESovxyA+54Jc8/e40LG6wHRGYFIFBJbzVm+2U6cDW4fZitHm0Ze53sk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X0JhcaF_1775204851;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0JhcaF_1775204851 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 16:27:32 +0800
Message-ID: <bc326e0f-dbfd-43a0-9311-00fc72efb4c3@linux.alibaba.com>
Date: Fri, 3 Apr 2026 16:27:31 +0800
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
Subject: Re: [PATCH v2] erofs: handle 48-bit blocks/uniaddr for extra devices
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Zhan Xusheng <zhanxusheng@xiaomi.com>
References: <f54ce712-9d7b-488b-8dc2-9d5e2455f80c@linux.alibaba.com>
 <20260403063658.72140-1-zhanxusheng@xiaomi.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260403063658.72140-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/3 14:36, Zhan Xusheng wrote:
> erofs_init_device() only reads blocks_lo and uniaddr_lo from the
> on-disk device slot, ignoring blocks_hi and uniaddr_hi that were
> introduced alongside the 48-bit block addressing feature.
> 
> For the primary device (dif0), erofs_read_superblock() already handles
> this correctly by combining blocks_lo with blocks_hi when 48-bit
> layout is enabled.  But the same logic was not applied to extra
> devices.
> 
> With a 48-bit EROFS image using extra devices whose uniaddr or blocks
> exceed 32-bit range, the truncated values cause erofs_map_dev() to
> compute wrong physical addresses, leading to silent data corruption.
> 
> Fix this by reading blocks_hi and uniaddr_hi in erofs_init_device()
> when 48-bit layout is enabled, consistent with the primary device
> handling.  Also fix the erofs_deviceslot on-disk definition where
> blocks_hi was incorrectly declared as __le32 instead of __le16.
> 
> Fixes: 61ba89b57905 ("erofs: add 48-bit block addressing on-disk support")
> Suggested-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

Thanks,

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

