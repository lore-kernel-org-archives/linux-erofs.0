Return-Path: <linux-erofs+bounces-2801-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B3DFD8769
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 13:29:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZt9N4m0Yz2yh4;
	Wed, 18 Mar 2026 00:29:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773754184;
	cv=none; b=bnkX+3x8slz//SD2aQiVV3wFYqo9Tn1sUC2T81dFDNd+qjlzpl2+1Z1bsjdGJkCOlwtYPv+ueo9KELQrCO2oOy1wPn4Vjyz7qMnNYXIc3JgeKIPls/FOpCew9P5VsOt8llOaghOGZzavJI7b1mHQb8Oh9wjEVdtB+TTSSVnhB97ki9PXEDKzvKldD1n9QtyxC9h3MMoU/QeSlslUSQc6iTI+w96FodXDSg0xnpZXCdD7Y7xkDMMlCAEGIW2MBKiBZZ7o7dRzQwcdHl3BgoSr5QjOUpfmJwz7HlMeqhl8logbRfMSTkiYa7gARVmx49RMfo0WhQul/lP/YZUZL/FEMg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773754184; c=relaxed/relaxed;
	bh=GoOgYZBq/1s/gphq/ANh1jp5J4i5RkrikJ/DqZVUdIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oAUt1MGPXC4Y3A4nqpo0gUlpCdL7JJOihLEyqgg9RwLw/2cHQFbjUeHsZe7Xua98Kj+wwo4wfxPrJcCzIPre5I6nhBLqnG8g5vmNslRpAyREHQhjcOMZ9G516sU3ZMGVEwx89uE+wnpVpkrXN+SuF4ggRswik6E+GlzXoyySqUoyr9MhKO2oVPzCteBacLvlYviP9fWC0EoWrKDxUTliuUccquTwG+NJFjlIpPtzVhRiofa1DSKMNHbwUCkh0+tgMM6vpwPioH3/NcNsiNFBn70VKCW+/BiF8p2wVjq66z81pgRxzRKEBqfQuQLjTDWxq74O+c9oynkr5wgo8wKtEw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RvDMt60X; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RvDMt60X;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZt9K6HNhz2yfP
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 00:29:39 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773754173; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GoOgYZBq/1s/gphq/ANh1jp5J4i5RkrikJ/DqZVUdIU=;
	b=RvDMt60XLdavs1ILLtSMpQMlRcGeLDb/9sum6l4i2zFr2ZhUthd4jZSm3SJiGWvrDyyuQPBGb5FbCJ3Haj7j3TIvjS6YJYbhL+/FBp8m0XXnNiq1/kSHR3UQju0bXBVyab6eQV4csdqZnJcYu3fpipR7kCHgzaaumRA5IBjjcUk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X.B94b3_1773754172;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.B94b3_1773754172 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 21:29:33 +0800
Message-ID: <b57c6213-fad4-41bb-991d-ccb80c842e34@linux.alibaba.com>
Date: Tue, 17 Mar 2026 21:29:31 +0800
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
Subject: Re: [PATCH] erofs: harden h_shared_count in erofs_init_inode_xattrs()
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, yifan.yfzhao@gmail.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260317132356.15341-1-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260317132356.15341-1-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/17 21:23, Utkal Singh wrote:
> `u8 h_shared_count` indicates the shared xattr count of an inode. It is
> read from the on-disk xattr ibody header, which should be corrupted if
> the size of the shared xattr array exceeds the space available in
> `xattr_isize`.
> 
> It does not cause harmful consequence (e.g. crashes), since the image is
> already considered corrupted, it indeed results in the silent processing
> of garbage metadata.
> 
> Let's harden it to report -EFSCORRUPTED earlier.
> 
> Fixes: 47e4937a4a7c ("erofs: move erofs out of staging")
> Cc: stable@vger.kernel.org

No, please drop the Fixes and Cc since it should not be a bugfix.

Thanks,
Gao Xiang

