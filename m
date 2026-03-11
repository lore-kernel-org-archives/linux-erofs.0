Return-Path: <linux-erofs+bounces-2654-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B518FD0653
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Mar 2026 08:19:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fW3Z76rHpz3f8T;
	Wed, 11 Mar 2026 19:19:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773217167;
	cv=none; b=ZvyUHrTg2BWazeWqkRGQSoJQIo9+u6XQWSfCGDK10mIUyrhkNHhiiIhjRgKu6euEKpGBFggNDTCSyWcfk4zn2uavPh3NMYNurnHPBtvej9rOBvyauxDc8zj01HP0fakV99eVZ4/UWslyXQqTSZRrkQL9BdldyY009eZn1G1ORqL00pmFUsTA3wbO4F7SGQ41lNZN5d/83QNqqBHqAV1Nb5FU5zHLQqLDREMCe2fKiU9PZ1suU6VkNJMLrgb/9NX/UkW4e0pxHP1yECDWOkRGtblVIGKQReonDuLhnx1dp32s6NX6zh5bN1jUfiSkMNRgHfiBZgY8jcSd2w+egLW0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773217167; c=relaxed/relaxed;
	bh=JTxTDVVq0upaxuI0ouj/OP39FpslhCyMw1g3MsypxGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JOkGh99k3c/omLQrhEyzSPr2BDUpynfFSTHEBGGYgyMuRUsJk9cbKT7EwU3Bbo+Lo7MFX3uXf5JffK740uT33FWYD0mbMKjXq/YhyyQ6bIJsYd6FTWwL2TFf2RxdLfVHtr/5jtHe2G1uVg1BqnrXMNtLj9bGRVl6Rp2k6ZvXPH2G53gV2etIpGE/hCN+URSuJg2E4wa5PKZ7p5WahW3pmsY/FvomyzAkwyj+699K19ZgoDbJIU5LvPbk3T+Ow1BRhGdGi4PYTPFxeQatg4tjHA/wcCOEJJk0jGApRI+kdBQzTABotDleQYXpXm2KZ3rXLf+MvO0l5h9DI/9vGVWDxw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Tf0bNa4H; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Tf0bNa4H;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fW3Z52qwkz3f5G
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Mar 2026 19:19:24 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773217160; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JTxTDVVq0upaxuI0ouj/OP39FpslhCyMw1g3MsypxGU=;
	b=Tf0bNa4HDJgvEyf9C0udGLsuagmzm8XDpI9dUSwMu4Q9o74zJNacdZQ7s3+YpVV/amk8DhYROiORHhIuAiB3Faj8Cmf5jM9B9oLM/1UA3TAamDLEoqLAT8vgu6P/Zy2ppCfwZh8ALL8bUTaM2y9PdeILbbMpcWbfQ3Ap8Xc6Zek=
Received: from 30.221.132.200(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-jMXHR_1773217158 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Mar 2026 16:19:18 +0800
Message-ID: <2e5c6004-af37-4483-aa3a-fac0e10fcb6a@linux.alibaba.com>
Date: Wed, 11 Mar 2026 16:19:16 +0800
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
Subject: Re: [PATCH 6.12.y v2] erofs: fix inline data read failure for
 ztailpacking pclusters
To: Zhiguo Niu <zhiguo.niu@unisoc.com>, stable@vger.kernel.org,
 gregkh@linuxfoundation.org
Cc: niuzhiguo84@gmail.com, ke.wang@unisoc.com, Hao_hao.Wang@unisoc.com,
 linux-erofs@lists.ozlabs.org
References: <1773216869-2760-1-git-send-email-zhiguo.niu@unisoc.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <1773216869-2760-1-git-send-email-zhiguo.niu@unisoc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/11 16:14, Zhiguo Niu wrote:
> From: Gao Xiang <hsiangkao@linux.alibaba.com>
> 
> [ Upstream commit c134a40f86efb8d6b5a949ef70e06d5752209be5 ]
> 
> Compressed folios for ztailpacking pclusters must be valid before adding
> these pclusters to I/O chains. Otherwise, z_erofs_decompress_pcluster()
> may assume they are already valid and then trigger a NULL pointer
> dereference.
> 
> It is somewhat hard to reproduce because the inline data is in the same
> block as the tail of the compressed indexes, which are usually read just
> before. However, it may still happen if a fatal signal arrives while
> read_mapping_folio() is running, as shown below:
> 
>   erofs: (device dm-1): z_erofs_pcluster_begin: failed to get inline data -4
>   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
> 
>   ...
> 
>   pc : z_erofs_decompress_queue+0x4c8/0xa14
>   lr : z_erofs_decompress_queue+0x160/0xa14
>   sp : ffffffc08b3eb3a0
>   x29: ffffffc08b3eb570 x28: ffffffc08b3eb418 x27: 0000000000001000
>   x26: ffffff8086ebdbb8 x25: ffffff8086ebdbb8 x24: 0000000000000001
>   x23: 0000000000000008 x22: 00000000fffffffb x21: dead000000000700
>   x20: 00000000000015e7 x19: ffffff808babb400 x18: ffffffc089edc098
>   x17: 00000000c006287d x16: 00000000c006287d x15: 0000000000000004
>   x14: ffffff80ba8f8000 x13: 0000000000000004 x12: 00000006589a77c9
>   x11: 0000000000000015 x10: 0000000000000000 x9 : 0000000000000000
>   x8 : 0000000000000000 x7 : 0000000000000000 x6 : 000000000000003f
>   x5 : 0000000000000040 x4 : ffffffffffffffe0 x3 : 0000000000000020
>   x2 : 0000000000000008 x1 : 0000000000000000 x0 : 0000000000000000
>   Call trace:
>    z_erofs_decompress_queue+0x4c8/0xa14
>    z_erofs_runqueue+0x908/0x97c
>    z_erofs_read_folio+0x128/0x228
>    filemap_read_folio+0x68/0x128
>    filemap_get_pages+0x44c/0x8b4
>    filemap_read+0x12c/0x5b8
>    generic_file_read_iter+0x4c/0x15c
>    do_iter_readv_writev+0x188/0x1e0
>    vfs_iter_read+0xac/0x1a4
>    backing_file_read_iter+0x170/0x34c
>    ovl_read_iter+0xf0/0x140
>    vfs_read+0x28c/0x344
>    ksys_read+0x80/0xf0
>    __arm64_sys_read+0x24/0x34
>    invoke_syscall+0x60/0x114
>    el0_svc_common+0x88/0xe4
>    do_el0_svc+0x24/0x30
>    el0_svc+0x40/0xa8
>    el0t_64_sync_handler+0x70/0xbc
>    el0t_64_sync+0x1bc/0x1c0
> 
> Fix this by reading the inline data before allocating and adding
> the pclusters to the I/O chains.
> 
> Fixes: cecf864d3d76 ("erofs: support inline data decompression")
> Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
> Reviewed-and-tested-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>

Acked-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

