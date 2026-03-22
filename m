Return-Path: <linux-erofs+bounces-2921-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7989109448C
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Mar 2026 00:41:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fdctn0VcFz2xlt;
	Sun, 22 Mar 2026 11:41:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774140096;
	cv=none; b=Ip1VuP5WiT4TLQx9ZaEP6lraq90/8nGYTJywf9IM00S6Dq8/e79LjoA2tLuUCRgZVWhCabXDdiZJ5oiFYhfecICpjYKL8ccVal4CBPRwZ2lyCHtN3bWv9j0/zMrhUodcq38zYVSeaRsDbl5Oh7R6DyCirR6FOpvzDrLhTT0LtYeEGgljzX7lGQTS/f7SbZiznbhBWI0MdqOQXhzJcW82hoZR/motvLrG1BO0ejcSRwxdeZ5OI/fhCZW4ayCgK6Hl459R8svGbwYxk41aQzluI8yh9P/VLOu0VxVHAeLCU0u14z2gu3PBVjxPEAfauKSwUdxR6IzCOcfxCQ3rJFC0vw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774140096; c=relaxed/relaxed;
	bh=y2eQfPGTI7Xo5iKZZtvDMTajRO4+saU4maeK4y9K/4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E0vkDQQrRTf9XFqITtCz/VZeQ5v+O8WmyjWKUYLXhwslytHfInIpKBysuSdhj1qOmoQrR+LKT9Yo90Ag4rySyj4ub/GGZfAxDGxGs9BezHjt1nWVNqu8yxrXm6mvk/+OQxZooWMJIGTK1o6TOJ89SOIww8No0RLiYWSGY8dms1wD8el6Ld6HIK2UUvA3JLPRI5lIXDidCyGSRZceDB+NQIyVwwDUhhxA/ShDiJTuK041L9gxZj3/nFqEp4QoFl3VdNwZMRvM2NcL/XK4KpujWVudiYelJ8c2KWMUA56hjlQ5eGZ+qVBTB3F1gFDbtic3mJmuS2Med5cYcN8zNf3bjw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kdpJuJ0u; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kdpJuJ0u;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fdctk2rPmz2xN2
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Mar 2026 11:41:32 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774140088; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=y2eQfPGTI7Xo5iKZZtvDMTajRO4+saU4maeK4y9K/4s=;
	b=kdpJuJ0uJcq8GjR4umWdXpbpBoU9oMteQAc3iojtw79uVLqGEEKe9u887IzDlNWA0LWoimfHhm/DlHi4NTIItK96JzdkMeJtpPiuz4KcQcBtIR9uIKTae1RVpMn+PUfHeJf9e+rliSr36rgHQRrUJeny4Wa2Qv44I/HUWPM9F0k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.PoL.z_1774140086;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.PoL.z_1774140086 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 22 Mar 2026 08:41:27 +0800
Message-ID: <9fa87530-6c44-44fe-86a8-ff546d6b663e@linux.alibaba.com>
Date: Sun, 22 Mar 2026 08:41:26 +0800
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
Subject: Re: [PATCH] erofs-utils: fsck: fix directory loop tracking
To: Nithurshen <nithurshen.dev@gmail.com>, ch@vnsh.in
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <20260321142852.35991-1-ch@vnsh.in>
 <20260321160551.20683-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260321160551.20683-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/22 00:05, Nithurshen wrote:
> Hi Xiang,
> 
> This patch LGTM.
> 
> I tested the fix by compiling fsck with a debug trace and running
> it against an image with a nested directory structure. I verified
> that the recursion stack now correctly pushes the current directory's
> NID (inode.nid) instead of inheriting the parent's NID, successfully
> fixing the loop tracking logic.

Please help work on a testcase too, thanks.

> 
> Reviewed-by: Nithurshen <nithurshen.dev@gmail.com>
> Tested-by: Nithurshen <nithurshen.dev@gmail.com>


