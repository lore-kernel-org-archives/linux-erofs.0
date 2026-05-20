Return-Path: <linux-erofs+bounces-3469-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A273CD4F54
	for <linux-erofs@archiver.kernel.org>; Wed, 20 May 2026 06:36:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gL1z70W9fz2xrC;
	Wed, 20 May 2026 16:36:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779258994;
	cv=none; b=C0lfGz2G+WvdlQKWuoQPlD2oo1CMICol7c7i0tvtZM6xv+srJXAJfc4zJFIrUI8spY9pIprjxdv4PPQC+EaDue8O3FPjEtCF+f/W0EUY4isY3nJ+KbtgHGrugKOFtSfH8WwJroMGfNFs1yfFFG248cCCa+vr11JkVXrm56/Hbt7os2DKOTHc2GJzbIhvzKUsK3vXn8/DbxGhP+qsQReCeGbchP8MonDc8LTkN7icwyRfFAV14HcCkfggbeunFaO4A1WyY2NoSpBB2O5OJ5uBQISy9AY1qsBT+RlcyObJMqwhw25Xqy74ouAZAiPNqfCPRUrINJMeNq3ByZNc9MqHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779258994; c=relaxed/relaxed;
	bh=5dh5i7z1bpxiBcX7pyprUm5C8cR79plwwq0Zm3WDNQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=if7tCFitDz4+uCvBQHKsOYJmGfZdYyA+iYqKTdpb2P9ZBBbB3ZuQ7r/PAL+1cLhoDtHuNFPActAplSIY6ZFqtlDlDXJrTiIjBq+rYvlGyEL6xWlv6NUL0rOKq04bsnZ+jHo9MSPkk6lHt3LHA+3qT9aIEvGiikxN9CHErA3B7IgFOERkTvyCVXJfcvfPCVyvCFHKCpx0UJMZIhBieEfVTbgg2tpd4fcfa3XMC05GCKysQvGHZRWK2wrIHUfrfYyv45GmbXtKmB018MKtB1NUFb1jnCEB1k7ng2kR0Y1yI3u+so2U4qHLKKiSKFw2iTlOXiF8P33PK/xonOPBn8Vpyg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QOuYtuk6; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QOuYtuk6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gL1z5231kz2x9N
	for <linux-erofs@lists.ozlabs.org>; Wed, 20 May 2026 16:36:32 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779258988; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5dh5i7z1bpxiBcX7pyprUm5C8cR79plwwq0Zm3WDNQ0=;
	b=QOuYtuk6PWZqw1bQzWBnQfL6leRsnWOC3m5zZ8YRvTCSs0gKufU2dW9k2dkZs/TxBL1pO5XU64kDCsBn6OaBsI4LxKGLw0KUHor2AUBYgfVo8P9QaJRb3/a3xfNT8qKu2rRzxMEbtonGdq1ktVo5Z0yZIaAqsgCdZTtcgY1YeH4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X3HewgN_1779258986;
Received: from 30.221.132.121(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X3HewgN_1779258986 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 May 2026 14:36:27 +0800
Message-ID: <f7f41a44-6045-40f5-bd0d-e15e7d746194@linux.alibaba.com>
Date: Wed, 20 May 2026 14:36:25 +0800
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
Subject: Re: [PATCH v2] erofs: fix metabuf leak in inode xattr initialization
To: Jia Zhu <zhujia.zj@bytedance.com>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Amir Goldstein <amir73il@gmail.com>
References: <20260520034252.40163-1-zhujia.zj@bytedance.com>
 <20260520044607.50992-1-zhujia.zj@bytedance.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260520044607.50992-1-zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/5/20 12:46, Jia Zhu wrote:
> commit bb88e8da0025 ("erofs: use meta buffers for xattr operations")
> converted xattr operations to use on-stack erofs_buf instances.
> erofs_init_inode_xattrs() uses such a metabuf while reading the inline
> xattr header and shared xattr id array.
> 
> Some error paths after erofs_read_metabuf() leave through out_unlock
> without dropping the metabuf, so the folio reference can leak.
> 
> Consolidate the cleanup at out_unlock. erofs_put_metabuf() is a
> no-op if no folio has been acquired, and this keeps all paths after
> taking EROFS_I_BL_XATTR_BIT covered by a single cleanup site.
> 
> Fixes: bb88e8da0025 ("erofs: use meta buffers for xattr operations")
> 

Useless new line, I will remove this line manually when applying.

> Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

