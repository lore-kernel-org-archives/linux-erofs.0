Return-Path: <linux-erofs+bounces-3112-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107BDFC97E2
	for <linux-erofs@archiver.kernel.org>; Mon, 30 Mar 2026 08:51:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fklNc3pdlz2xpt;
	Mon, 30 Mar 2026 19:51:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774860704;
	cv=none; b=iK/PR9hpOhXjvUpeNj5MYjREL/S8LB6+WWQDsmv20SqZ47PPnFeGAZJDxVi0J+XxQvl8mvhd+axJdeOB3NaIk6ZPMCDPUfEiv9qk1KyQmtI54EVRDxWwevJEej0V4inLC6lt1vwdkMyI5B01OyuLQqTZpmpiNUDsN2ZlXHWIS74hdAThH6lhtxyaV8DOGYAJi/yeBerMfRxgJR4UXRTLJENtkF2tI8rv1vwZa2G83YE42bTrDwmVb2mrKUKR4ajr/Mjw/gr6203XZ98iVigrT8jElKub5Wiiwsyu9bjaajJhHPOjEm6PbkdfgbhWAoCn5zEVm8GspUkf1TjOQtPD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774860704; c=relaxed/relaxed;
	bh=sksvTwu+SyyEsCrpTPCQ/SP+FtrsmIoIUQ5MnisbLUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZBZcBZNfME7VH78LLwQoUj02lttYdBSteYHIjkNl7vhmxLEHFN9uIuTbv3TTY4onc+cr/hE7wdGABS+CSUlhO/Ja2gMbDqiUbOry1Rf9saKDBycsax7cmL4yWa1a3XUNxijIOzAEoGPZbWhGGvpXxdBhZwa7o+lgZyh50vg5H9l5CKRJ4MhQxrw1jJoFkJa6a8m6pCY3NAORPrH+lanT4kNoTRo6EQnxFpvyoM5MZAZHAOHtD9KoEbAD0LG5lJ27ekNyBrvjqMDdPLsr2BMzHuWwBWjAsABMVpk8BbbsLxQYU52Q1rkAuqr3ltYBAa/n3kzRpgcakxc82qUZNi68A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tZD8RJT2; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tZD8RJT2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fklNZ2V1Sz2xT6
	for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 19:51:41 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774860696; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sksvTwu+SyyEsCrpTPCQ/SP+FtrsmIoIUQ5MnisbLUo=;
	b=tZD8RJT2J6VBgk9dNzAS3ePbyECOL1eZ6HjAqSiq5Adx/eMw/lNwzlk9oL4n+4Obqjc6K9wihPDr9vtBqxZFKgb3pTrqUtGjix+d47dRqoeAgf6NRnhMe1urYOGhFzlv1rExjDXLzlO8aMWxgHLFlZXED0d4pvsYgkFTio8wqhY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.x6sJS_1774860694;
Received: from 30.221.131.246(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.x6sJS_1774860694 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Mar 2026 16:51:35 +0800
Message-ID: <c73c558d-6582-44b4-ae7f-36669e98928b@linux.alibaba.com>
Date: Mon, 30 Mar 2026 16:51:34 +0800
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
Subject: Re: [PATCH v1] erofs: remove the guard of showing domain_id and fsid
To: "Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>,
 "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
Cc: Hongbo Li <lihongbo22@huawei.com>
References: <20260330073235.3328579-2-Yuezhang.Mo@sony.com>
 <bc6ac6ae-ef88-4ff9-96ff-3395f84ce4ef@linux.alibaba.com>
 <TY0PR04MB63282B4D6BAEF754115502548152A@TY0PR04MB6328.apcprd04.prod.outlook.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <TY0PR04MB63282B4D6BAEF754115502548152A@TY0PR04MB6328.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/30 16:48, Yuezhang.Mo@sony.com wrote:
>> On 2026/3/30 15:32, Yuezhang Mo wrote:
>>> This change fixes an issue where domain_id was not shown when
>>> CONFIG_EROFS_FS_PAGE_CACHE_SHARE is enabled, as this configuration
>>> is mutually exclusive with CONFIG_EROFS_FS_ONDEMAND.
>>>
>>> Both domain_id and fsid fields are present in struct erofs_sb_info
>>> regardless of configuration. They are not set if the configurations
>>> are not enabled, and remain NULL. Therefore, the conditional guard
>>> in erofs_show_options() are unnecessary and can be removed.
>>>
>>> Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
>>> Reviewed-by: Friendy Su <friendy.su@sony.com>
>>> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
>>
>> `domain_id` is a user-sensitive information for the page cache
>> sharing feature (much like passwd), so it shouldn't be shown
>> in the mount option by design, and only the mounter should
>> know what it was set.
> 
> Oh, this is part of the design, not a bug. Thank you for your explanation.

Yes, if you need that information in the follow-up steps,
you should keep somewhere in the userspace: but the proper
permission is needed (e.g. like /etc/shadow).

Thanks,
Gao Xiang


