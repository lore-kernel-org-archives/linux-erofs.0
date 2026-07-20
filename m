Return-Path: <linux-erofs+bounces-3941-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54ECFC44527
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Jul 2026 09:45:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h3bHQ3gtNz2xm3;
	Mon, 20 Jul 2026 19:45:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784540754;
	cv=none; b=Dfhd6h9Kg3HTn/Z5Nhbon5B7mAnILd6CnbPEpCPKqaTlvPy3UwWU7+ZMc0VHFCTksgGcknA8PNhjCtVCDHNZtJFFMmJCFXfqcUikaAkym/lpyOW7MrVrYQ3Nior8qJnYxUAr17fGSS1PGPLDGJC7rjtj0fhiRp7zqKe/w/PanGkUADl1inlAKrWpYEHxRRezw+psSGqlZjVww/6sgFWxfsb/XK943rrCDj/BK8mwItOq8PEi8u2cw2vSiKuhuVcgIPgoXRrswrDyqMDaZx/tnQKJ8yPbSZDPf5n2rRkFe7cWqhv/htjIEl24XdwEFzYrciKN5I+R41X/yCGEF5f4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784540754; c=relaxed/relaxed;
	bh=8MwbgXwZ3zMaHcDnJViuu8BS+HJvN2qfbWu5++MyV08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PajAi3VQCq082Sg4ftEkDaCfiCqVf9HGbAaoa+kvHRsG0VaIImFpaSkQBvjvTyM05X4Ouo2nX9eExkFlYnaSz/1mFFlfIYYoKCVWcsmS894w/L/XDa341V3vKde3JcucpdnMi+e08Xv9b6wLSweP1f7Z0QmT3VpMVbzydPViExihtDa1s5ljEZtu4iL+9RNio6VMDbEVrTMZ3w4rhVWuna8hdV3C3taHDs8X6eNdSGCiQUSFw/YJZ9egglNc3ThuTif+Os4d6CZqxrGPyRyOLVtgcg3cGjxWIItNigCwHyPpKf4hWo6OkGXdOKpc9T52bhd1jb1Tup0XpSe3LmrdLw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UCecfo/H; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UCecfo/H;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h3bHM6pp0z2xlZ
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Jul 2026 19:45:50 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784540715; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8MwbgXwZ3zMaHcDnJViuu8BS+HJvN2qfbWu5++MyV08=;
	b=UCecfo/HhO4B50prlDgWLx+ciM/JCBu7bxkwE5EUXPCTxKleuwz5O1bwDDbDmJ+1zUNB49tE/Swm4rauIVCh+5Vcd8WkZGHJUeFjw/RvG37F5Estznp7+I2rkwydWh/2GeDIXqU3oBRaClp4Q75hFo+WJC0m46W/YlMAo8uNEgE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X7S8pq3_1784540712;
Received: from 30.221.133.33(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7S8pq3_1784540712 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 17:45:13 +0800
Message-ID: <d8230340-0b06-470b-9195-ef9942b1004d@linux.alibaba.com>
Date: Mon, 20 Jul 2026 17:45:11 +0800
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
Subject: Re: [PATCH v4] erofs: accept source file descriptor via fsconfig
To: Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org,
 Christian Brauner <brauner@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>
Cc: linux-fsdevel@vger.kernel.org
References: <20260717134147.1602735-1-gscrivan@redhat.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260717134147.1602735-1-gscrivan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/17 21:41, Giuseppe Scrivano wrote:
> Allow userspace to pass an already-opened file descriptor as the mount
> source instead of a path string.  This is useful for tools that already
> hold an fd to the image, such as composefs reusing an existing erofs
> backing file.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> ---

Looks good and tested:

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

I wonder if Aleksa and Christian have more comments since
anyway it touches fc->source, but I will queue for the next
cycle if there is no other opinion.

Thanks,
Gao Xiang

