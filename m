Return-Path: <linux-erofs+bounces-2434-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991EEFC5913
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Feb 2026 09:28:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fM5kF035Cz2yFc;
	Thu, 26 Feb 2026 20:28:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772098132;
	cv=none; b=Xzk0l5hRvNNxQkgVXbDS7kLHdY0oq9RiVZVW2QA0MSK0Pu26AgSkDqWKYAiUm6g9gM2cTB314uz2Omt2AGsAYR2+dCLx6WIoABxCR1BU08fcpH+WDUs4rC66GTu31D1aX2PUrlbd76UJDdoFsNzHQ5XykkiAZNU55eXcAXWTkEcY4AEs3B8Vo/4O2jAZCi3JsGOxnVeyBHdIKc4ggjgXsa3qeSSE2K/IPAK2cy2cEUOAhS40i7D1KVN5uYgS35nxztM89DhhJNRhtJwAAkvEL6snGuUeIHfVuLTo81nsPDoGRSBe3G/U6N7qlPEu+a/2QJ+Rlp8USmvgAR2oDfwKtw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772098132; c=relaxed/relaxed;
	bh=0VZpcJ+PxELmlM3qbdngIv7hCBv9Ut9yz/VwjOeHpxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=myLuEBF/gY7ICXXNqC5MLgRq/vh60KasB4V3wJfElUTf0SysYBrD22F8l20MzNrGfPAL79EdyH1cCQVrkL+Wi9zoAmvtEqnzEaWwa1snwEXZGgnvbgEVYYKojY+WXH2HZrQANFEaLJ4NvL+whyQpBCyGAMyfV2v2TT0N5gASLfU6Z7i1kb0r0hspjbvSOEU3Ou4Ml7r2e2Npa2M/ZyEx6So/9fmyt6pushqTLbO72ZeEi1Y4TIr9dd04geGhW7GGk6jSHlFrRRJ/yhGQRYIRW+sW8TpT4pX5PBeIIW67ZfVvszectB/YYArjXn6+iKZ7Poe56IGoHJXEOj1NEWHvPQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LhXeZf4T; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LhXeZf4T;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fM5k95fR0z2xMt
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 20:28:48 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772098122; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0VZpcJ+PxELmlM3qbdngIv7hCBv9Ut9yz/VwjOeHpxg=;
	b=LhXeZf4TZp7r0G9W7ZrKl0oMCFnynYA8dXkvi8bD0O4SpcuB7Oc+IQrXYY5XBf0GZx3bU5ez/Fm4I1Hav57dz2LmvItyBhhc1p3o7RSHbK2OiN5VkoljtaZxJ6xMPSd0YhtTF09hFHPkBKRIhffE7xLqyToJuhkF/q81giuHil4=
Received: from 30.221.131.221(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wzqqyl._1772098120 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 17:28:40 +0800
Message-ID: <f748ff61-043f-402a-b4a5-e285a4e5db99@linux.alibaba.com>
Date: Thu, 26 Feb 2026 17:28:40 +0800
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
Subject: Re: [PATCH] erofs: mark fileio folios uptodate based on the number of
 bytes read
To: Sheng Yong <shengyong2021@gmail.com>, linux-erofs@lists.ozlabs.org
References: <20260226090947.2808686-1-shengyong1@xiaomi.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260226090947.2808686-1-shengyong1@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yong,

On 2026/2/26 17:09, Sheng Yong wrote:
> From: Sheng Yong <shengyong1@xiaomi.com>
> 
> For file-backed mount, IO requests are handled by vfs_iocb_iter_read().
> However, it can be interrupted by SIGKILL, returning the number of
> bytes actually copied. Although unused folios are zero filled, they
> are unexpectedly marked as uptodate.
> This patch addresses this by setting folios uptodate based on the actual
> number of bytes read for the plain backing file. And for the compressed
> backing file, there may not have sufficient data for decompression,
> in such case, the bio is marked with an error directly.
> 
> Fixes: ce63cb62d794 ("erofs: support unencoded inodes for fileio")
> Reported-by: chenguanyou <chenguanyou@xiaomi.com>
> Signed-off-by: Yunlei He <heyunlei@xiaomi.com>
> Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>

Yes, it sounds possible. But can we just fail the
whole I/O for both cases?

In principle, we should retry the remaining I/O once more
for short read, but failing the whole I/O could be one
short-term solution.

Thanks,
Gao Xiang


