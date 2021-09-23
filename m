Return-Path: <SRS0=k0ix=ON=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF51EC433EF
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Sep 2021 13:34:51 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C80461164
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Sep 2021 13:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C80461164
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HFbkK2RbMz2yss
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Sep 2021 23:34:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Irw1kK6r;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=Irw1kK6r; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HFbkF2Kj1z2yNZ
 for <linux-erofs@lists.ozlabs.org>; Thu, 23 Sep 2021 23:34:45 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB2761164;
 Thu, 23 Sep 2021 13:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632404081;
 bh=LqLYzE3HwM72W3M0qWRK4FmjKgjMOvzgm/+ibZFzY0M=;
 h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
 b=Irw1kK6rPdCI9lE15ZkdAlF4md7Hovl3fABqEG9n0dgVhh3L3MH5O+srgtpw+jgkH
 Bg6AcWdBMrBzcQ21M1paqUcHpl1WoPdp/x8yUSv3q3swPS4TQCXGdJHTC9RL9Pk6uF
 owihBAnugJ3mkYk+oLlSVfhXnfghE3QVg/n6Ze+R4pBagWRE9aweluInkferJu44uQ
 WqzCpZ55gHywmeGsNR4g8rcRk6jAZ0rK8TjR0PvMqYwVvnEA4+U6KI5+w4CY4/1LMR
 mVm+zWFKJbRM/XvW6a7lqf3bUzvNGrcEH+mkxhn42WYWuFOrxXLtdXfaZBb3BUzVX5
 hgC4FlpY64s/g==
Subject: Re: [PATCH 1/2] erofs: fix up erofs_lookup tracepoint
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20210921143531.81356-1-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
Message-ID: <4823f65a-5282-0496-44ab-0d471a5b2b27@kernel.org>
Date: Thu, 23 Sep 2021 21:34:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210921143531.81356-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2021/9/21 22:35, Gao Xiang wrote:
> Fix up a misuse that the filename pointer isn't always valid in
> the ring buffer, and we should copy the content instead.
> 
> Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
> Cc: stable@vger.kernel.org # 4.19+
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
