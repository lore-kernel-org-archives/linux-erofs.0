Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67307C52D7C
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Aug 2024 01:45:35 +0000 (UTC)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="::1"
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=i0wzVao1;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WlPvf0cqJz2yk7
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Aug 2024 11:45:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=i0wzVao1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WlPvX24khz2xZt
	for <linux-erofs@lists.ozlabs.org>; Fri, 16 Aug 2024 11:45:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1723772722; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RZ+NlsySrY2vMHJpcxG2kxBlYf3YUdWlqXstIAWZcN0=;
	b=i0wzVao1ZQLrXxeKozR/b/3MmrRTt/Fzs7M2ZV1UzdobIMxhEp4Aba0Jz7BZOY8qIv9Na02cX7iM03fgnO9HbHne017AAwz3PRM8mV/UYtKoxIkLLxm6HYqPPeHP5SN2S2SwldnrskNvH5dWe5NtIc7bbNqnReidFtW+SoMgeDg=
Received: from 30.221.129.229(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WCyNzKV_1723772720)
          by smtp.aliyun-inc.com;
          Fri, 16 Aug 2024 09:45:21 +0800
Message-ID: <b7aefd03-eb9b-4a87-8282-3e1620276536@linux.alibaba.com>
Date: Fri, 16 Aug 2024 09:45:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: lib: exclude: #include PATH_MAX workaround
To: =?UTF-8?Q?Ahelenia_Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
References: <xs4azw3vs7oryqnpkvzsl6qbmma6p646igoklia2fextt6pdiw@tarta.nabijaczleweli.xyz>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <xs4azw3vs7oryqnpkvzsl6qbmma6p646igoklia2fextt6pdiw@tarta.nabijaczleweli.xyz>
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
Cc: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/8/16 04:15, Ahelenia Ziemiańska wrote:
> Fixes build on the hurd.
> 
> Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

Thanks, applied.

Thanks,
Gao Xiang
