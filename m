Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2FDEE4993
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Aug 2023 15:25:42 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=kfWflLKZ;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RW95c5CGzz3c4l
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Aug 2023 01:25:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=kfWflLKZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=139.178.84.217; helo=dfw.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RW95X2Nr4z2yhZ
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Aug 2023 01:25:36 +1000 (AEST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 770146199F;
	Wed, 23 Aug 2023 15:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0828CC433C8;
	Wed, 23 Aug 2023 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692804333;
	bh=KEPHfyKB9dhGJ6q8QlmUUhxO7CUxAWlkhe1aFTi9XcQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kfWflLKZYqhdg+s6/ycK27d0p+oNcB1h/hTqSIm57KWJxLyvQRoFK9tWA/AlT9phR
	 MNT1h2Cxah1tZSgSLSVuZ+DQ5q4F6cymQDKP/xn4EoJ0giKhDm7382G2Qpm7lkc8se
	 aKRGIjm9ryTmpr1VvUDPGuAXqEFtYhCiu4F0Nbh4m2Av+ub4lmOytVGdIfv1ob5Y/y
	 lpGd6G5j7wgleoKIy9jpmepvB5kQBYs3JVza9TOPrS5xf45esr70TqhasqXBM3gFJP
	 omDtKQJEygyNpfK3JqTessFvHCfs4j3Elba+pPgrGvFZ81F2aOfdVZXox7yRQxNU6m
	 O7ZNqBKWbVCzQ==
Message-ID: <90280d3c-c3d0-0ef0-3a75-97b609fd4299@kernel.org>
Date: Wed, 23 Aug 2023 23:25:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [v2] erofs: don't warn dedupe and fragments features anymore
Content-Language: en-US
To: Gao Xiang <hsiangkao@linux.alibaba.com>, sunshijie
 <sunshijie@xiaomi.com>, xiang@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com
References: <20230821041737.2673401-1-sunshijie@xiaomi.com>
 <3a107c60-532a-dbc9-d899-40cfcaf9327a@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <3a107c60-532a-dbc9-d899-40cfcaf9327a@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2023/8/21 12:22, Gao Xiang wrote:
> 
> The subject should be:
> [PATCH v2] erofs: don't warn dedupe and fragments features anymore
> 
> but it's not really needed to resend.
> 
> On 2023/8/21 12:17, sunshijie wrote:
>> The `dedupe` and `fragments` features have been merged for a year.  They are
>> mostly stable now.
>>
>> Signed-off-by: sunshijie <sunshijie@xiaomi.com>
> 
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

> 
> Thanks,
> Gao Xiang
