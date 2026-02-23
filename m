Return-Path: <linux-erofs+bounces-2346-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE4AE909BC
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Feb 2026 02:31:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fK4cK68Q0z30hq;
	Mon, 23 Feb 2026 13:31:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771813905;
	cv=none; b=oQ25psPacM0xVGGbfBgRQmub2Fc+nWD3HTywJ2tn+A+6LaUu95OIzL8IKm0r5TFnhJQQFeT/sskcfCsmhy1NxWopaduGHpPipr2SgmHsKv+7UECI7Shut5SJUPeTaBnY/DCBocdyRQaFvGf8pneQcXAAt3NQYSaku58Spb+bLxEqwRSBSQHcsxZ6GCRd6WG6ZCp/Jcr68dAhLiCtxbgVY6/G/rUBGuOpX8IolSCfpoyz0U2dJ8iNewJ+6z0viW0e+wZGoKZXBVDN0zZ+arf2qNd8pU8ZyYHIT31lrDMeYTznFqkvlFVdfChMkaMumPP5MPFCz6uqcRdVkcjT7btBzw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771813905; c=relaxed/relaxed;
	bh=oVdh8jhbOgmCfVl3Zcbm6neqLdmc0cLpE3ItMDoHJYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vw+sd4LWfDub/q+ASIqN8t2F+sTly+rMgGz9UGTXivNFzY9WzriHvBVBL0jK+RUxB/YUATkXKjJzOGMR3OxRf1r/HD+R9uFPACIAKSKgSKjhwZmWDAfrNUEJnyVgQwV8ZSRt9WgU06s08dRc1PylEq542KJ3RgmaZyqktboVzs1of7gubPLswGHig8+btoR4G8cfio8CGNqf56JqsS/CdZGkwRgnbiStRkRXcS4StHhLCJreSqk55aMt3NZS2kAxNhkEWJzjJv8X0PYAU3b4YS9UxP3GhtcHFTNT6ByxT013rI/qc/yOD0Zbdb5cU06Msy2Vvu6Uh09LrqhtruZCkg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=jrB9iU57; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=jrB9iU57;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fK4cH4HCyz2xSG
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Feb 2026 13:31:41 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771813895; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oVdh8jhbOgmCfVl3Zcbm6neqLdmc0cLpE3ItMDoHJYU=;
	b=jrB9iU576Vi3BF5Sl1iWBzZNpc6hrRtdybyN3S4lJAmKbxAPCPKLxrTlUB1eTwXcn2bOK76mKveBZXwoF7Kapycd7jIcPFPJYTDvn9/ElOGna7PPRib7U3LNML5Xqcz7VoQivjYNNeg1l54Zamf2IIi88hgFRTo0BKAHUo7T1/I=
Received: from 30.42.59.174(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzctCGz_1771813892 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Feb 2026 10:31:33 +0800
Message-ID: <53b460ff-6744-4bd2-a000-5a1aaf08eed0@linux.alibaba.com>
Date: Mon, 23 Feb 2026 10:31:32 +0800
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
Subject: Re: [PATCH v2] erofs: allow sharing page cache with the same aops
 only
To: Hongbo Li <lihongbo22@huawei.com>, xiang@kernel.org, chao@kernel.org
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260214030248.771925-1-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260214030248.771925-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/2/14 11:02, Hongbo Li wrote:
> Inode with identical data but different @aops cannot be mixed
> because the page cache is managed by different subsystems (e.g.,
> @aops for compressed on-disk inodes cannot handle plain on-disk
> inodes).
> 
> In this patch, we never allow inodes to share the page cache
> among plain, compressed, and fileio cases. When a shared inode
> is created, we initialize @aops that is the same as the initial
> real inode, and subsequent inodes cannot share the page cache
> if the inferred @aops differ from the corresponding shared inode.
> 
> This is reasonable as a first step because, in typical use cases,
> if an inode is compressible, it will fall into compressed
> inodes across different filesystem images unless users use plain
> filesystems. However, in that cases, users will use plain
> filesystems all the time.
> 
> Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

