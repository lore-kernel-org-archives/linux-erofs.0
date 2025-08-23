Return-Path: <linux-erofs+bounces-891-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B7A5CA0EE4
	for <linux-erofs@archiver.kernel.org>; Sat, 23 Aug 2025 09:37:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4c8BmD4WPwz3dDT;
	Sat, 23 Aug 2025 19:37:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1755941836;
	cv=none; b=at7DdGTvL344FjwOTGvuFwrWHt6iKARXnv+IUZ7b3SKwjaWah0irgx+c4TbV/pGqvcxMY6Nd1Q4D4vWqDJs9ABJ2OtmfZ3POAWt2TulSL6YSffyZMh3ruLTlUYQ/te6xG6fCopJCXBgrXKyYmwLsptw0LHVsppWhZlQlpHcm+itGpjNmUtaGOqzZpkWFeyj0SHWJuMyVSsVKslcmFxzxxOkm0guTO/thisGju4JrLosCs/O1UdYL1y95CNhZvaXjeKLZFwq9Rg+reKHtOVz/5blaYql/LC5jCdUSxmxoqbUgkDJsnZB9LR8gbmKs9BZtm7OwHP58aSjoPdm8N/4X1g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1755941836; c=relaxed/relaxed;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MWywfsS2kqgnm2NEOmyoJYWlTlit4oC2lDPF1h5AvoHBDZpnv6PI9c+hZWhYOPmlIqkkP9fZvLJI4BxdDa+/mIpOu03cbih40WktswkMWI6c0gFOnQj6CYX5f+79G3N7r4Ltvntd1SVmHa9mPoNvmqjTjVHzsKjN9YwPxtZNaf+4OzcMTBoyxjHYlqEO7dDAjUgEBmu/88fXZOBMHTLdgzkS0SH4WtE766d1bHdHM9rLWjlbyC/DOEC/SHR4uz6BwDwzNW20boAkkRmK3W+10Qa5HkL2+jt1eRSV/SPk0d5asPxyPV9CgmvmojL9aN8JTEd6DQ0uBIan4KGO0VRH+w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Rm4CBlPZ; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Rm4CBlPZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4c8BmC1H55z3dDP
	for <linux-erofs@lists.ozlabs.org>; Sat, 23 Aug 2025 19:37:14 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755941830; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	b=Rm4CBlPZ1sK+wn2kdpA2/ST2AoAEf5EqJu0g+E5CG1I3D89lPmRZy5oCaHIJtUFtfMTNq7E3Qm/q7CpUQs1SbF+gAqXXvDJdLlnY97hMkf2mx+D2FdP2V21IHQ05KsQ3qN5HPNLXVYlgY+/50U5JIFckgV9mDWnUuNe2+zLaG/0=
Received: from 30.180.0.242(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WmLtiKk_1755941828 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 23 Aug 2025 17:37:09 +0800
Message-ID: <2387bd7a-0abc-4c3a-a547-cdaf101cd555@linux.alibaba.com>
Date: Sat, 23 Aug 2025 17:37:08 +0800
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
Subject: Re: [syzbot] [erofs?] KASAN: global-out-of-bounds Read in
 z_erofs_decompress_queue
To: syzbot <syzbot+5a398eb460ddaa6f242f@syzkaller.appspotmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68a8bd20.050a0220.37038e.005a.GAE@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <68a8bd20.050a0220.37038e.005a.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test

