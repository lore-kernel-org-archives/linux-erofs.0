Return-Path: <linux-erofs+bounces-3930-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4B2C44507
	for <linux-erofs@archiver.kernel.org>; Fri, 17 Jul 2026 03:42:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h1bMs5YdWz2ySg;
	Fri, 17 Jul 2026 13:42:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784259769;
	cv=none; b=Z2TE5tpoFmH+vMcIaHIF3Cg8phxMD62DPQYeGf7LmurJKpjAek1bwCDJPM0HyygUPbfbuTP3RixYZRLYG41O0RiVgIQfkmTUGJlaOgU3noPjeH/u2ZiPdn7Hptbiq1+NTjgJOAG40/LXTLOyxV2503P2oER4gEGr7OGcxbJg0TJMYXy8CVlakJyiwneQ7VbJPxVf4fJB4+wHxDoMjM4NZGd5RHUp/ZNlpxkvnEekaYiXA8sSoVo43rEdZgkxaQvsqAc8DKdgC6tPnSaXgo+UMMUIbc4Z73LGoryw1PGUhKQ8Wlxy2OJwd3ToiYKomqkPeO9v5fINeqU9ZFbV/NEiYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784259769; c=relaxed/relaxed;
	bh=5DvvIMn/V+Lz9bnP310CzHmXUZlWMDUr4Pw3ahRkInA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h7F5P7YrAowX57B2lwUZoST1freVYGJ3XJapcOP9LvxLk2aHQtyT5urvn+E8l6Hp7sM3qrl7v+r6mKSCYUPrFjpGaWtVuvbUNza/3txtzs/iATQTc2Sc6xWeyXtxl5ha4/gRSEiWQuFBIOzZGLXSghv60chWIcBaY6fFGSim/xvlf2VKRAIRzUhcdIgpoV7jY37M2O2r1S+FTux0xbUOD82I5q+FhcaMXLqz/GT1/VIzgKyfKHXJPs5qwSQ4GgcPYFMRC1P5bxPOfVyYV/0ji8mqV3to1X4EgygHLdHYyuxBfY5VyWYZx/fTsCPxnlwqKKQkxIzBD9y5DEXVm0qfHw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sr9ZKl+e; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sr9ZKl+e;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h1bMq2GSjz2yRF
	for <linux-erofs@lists.ozlabs.org>; Fri, 17 Jul 2026 13:42:45 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784259761; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5DvvIMn/V+Lz9bnP310CzHmXUZlWMDUr4Pw3ahRkInA=;
	b=sr9ZKl+ekpqvJaBfIULogfDmga/Fz3Ro0QEIPK3XGtYZIXwmST5c0RlqsH68Gm/FxIYNXZpJ6ecoMd9EHbm6WvIGq6RfDq/m8IlaCSc7QFO4CE6FXKr8NEJhh5cpB4ePSMbhkpm6X9yEizbVtDskLgL9i6wAi5Y7ftCeW+o33PI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X7G2Tnf_1784259760;
Received: from 30.221.133.5(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7G2Tnf_1784259760 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Jul 2026 11:42:40 +0800
Message-ID: <a3ee4538-6273-4d25-90d0-8dbaac092a38@linux.alibaba.com>
Date: Fri, 17 Jul 2026 11:42:39 +0800
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
Subject: Re: [PATCH v3] erofs: accept source file descriptor via fsconfig
To: Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org
Cc: cyphar@cyphar.com, linux-fsdevel@vger.kernel.org
References: <20260714154917.489993-1-gscrivan@redhat.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260714154917.489993-1-gscrivan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Giuseppe,

On 2026/7/14 23:48, Giuseppe Scrivano wrote:
> Allow userspace to pass an already-opened file descriptor as the mount
> source instead of a path string.  This is useful for tools that already
> hold an fd to the image, such as composefs reusing an existing erofs
> backing file.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Use the current erofs-utils testsuite, the following tests seems skipped incorrectly.

[Error 22] Invalid argument
SKIP: erofs/008
[Error 22] Invalid argument
SKIP: erofs/009
[Error 22] Invalid argument
SKIP: erofs/010
[Error 22] Invalid argument
SKIP: erofs/011

[Error 22] Invalid argument
SKIP: erofs/017
[Error 22] Invalid argument
SKIP: erofs/018

And the kernel message shows:
[  116.477816] erofs: source is unsupported
...

git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git -b experimental-tests
$ sudo make check

Thanks,
Gao Xiang

