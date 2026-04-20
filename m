Return-Path: <linux-erofs+bounces-3333-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78AECF36C49
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Apr 2026 08:21:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fzdjm116Jz2yqT;
	Mon, 20 Apr 2026 18:21:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776673276;
	cv=none; b=AetIDDu0bQLKOVAEP/PI5paahqan3yNz3Vt4YuEiEvtYbsACY86wquDpYDnw3fcwonbqKy8rec5quoQpx1KmrtQ/rjdsi6GYr9qe1IaxGGceHrknLU93ZglLLpFjITsdn6D1qs9H0HqSKvXvCMbs7eTD3LmkzHep2p+eJK1MJSzEkaf7+g4OJUog6UvWjbY7AupbtJvh40DOoPE+FSHj8UkooET5FEoAvMeRQoGy7CLG1WoGofN0ozmbzCekqfmMKOGgZcZmUWZNp4LVpiD1XyXDL21wXtz+zk/Cx7ra1j4vm92P9D4DuS9j7pp+wmfkLHINxlJGAHFi5qhkCmGTxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776673276; c=relaxed/relaxed;
	bh=dG0iEpQkyBcPtKIdH71WBVSGudWH9LQTlowpsJ5NxD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nmvLfbrXqexoDgv+SBkfcG84JELphMfSv1z94pjop8X9mFJ8BwGH/36m/rFIvpHZgrPx7YEj6hrEQ9pYpzPIBPS+uoKAG1xXC2vfjRqp7Xa17vBQTKOtiao/CG5DRXQnGR6XV22PauwyXBNCrPReMov011K4yi/uLRYbarbcvrNGwgEwaH4mK4tY0QXcthxHmeWIBaBtAjbAYnbvH6ZjNwbCys2QvdwCb85C0cbz5KciHU3g89hLcIyKIk/WaPSvB+5MnVQZbxGQZDvNhlsVEuOuZYVp/SOb5HKd+ENQ95T3gPOc2sHHfhyhA63fQeN04gBT/wZSA9csRjiciiLUlw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CUnBOehr; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CUnBOehr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fzdjj3B2Xz2ySf
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Apr 2026 18:21:10 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776673261; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dG0iEpQkyBcPtKIdH71WBVSGudWH9LQTlowpsJ5NxD4=;
	b=CUnBOehrM2eBYmpwrqM7hp4nHEJjAp9zmVtk3K8Z3i8BeDOjVx1YTxSPmppM1GHDF5mHzh36vL9Din3if6ZEZs2mJbuJbkX6Cm+fWsdkOA8zM8RJg+EZmtAPkcHrLJ+dSbmsdoJqpk2lKTkLpZ5if5qTZqh90LJs3b9oF5sGbJc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X1JCOZQ_1776673259;
Received: from 30.221.130.173(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1JCOZQ_1776673259 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 16:21:00 +0800
Message-ID: <3d2e0a50-abc7-4479-9437-d44066d891d5@linux.alibaba.com>
Date: Mon, 20 Apr 2026 16:20:59 +0800
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
Subject: Re: [PATCH experimental-tests] erofs-utils: tests: add test for
 rebuild fulldata
To: Lucas Karpinski <lkarpinski@nvidia.com>, linux-erofs@lists.ozlabs.org
Cc: jcalmels@nvidia.com
References: <20260417-b4-fulldata-test-v1-1-234654bdb930@nvidia.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260417-b4-fulldata-test-v1-1-234654bdb930@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Lucas,

On 2026/4/18 04:06, Lucas Karpinski wrote:
> Add a regression test for building a self-contained image out of two other
> erofs images.
> 
> 1. Create img1 & img2 with various file types and sizes.
> 2. Rebuild a new self-contained image of img1 & img2.
> 3. Delete img1 & img2 to prove that this isn't use the blob based rebuild
>     path.
> 4. Mount the new self-contained image and compare the checksum to the
>     original folders.

Thanks for the patch. I wonder if it's possible to:
  1) Use a common dataset as the base layer (see other existing tests);
  2) Mount two overlayfs to get the incremental layers;
     - one to generate some artifacial dirs, files;
     - the other to change/delete some files, or delete dirs, new another
       dirs;
  3) Test typical metadata (whiteout, opaque), and data with:
     a) fsmerged erofs;
     b) overlayfs mount;
     fssum those two mounts.

Thanks,
Gao Xiang

