Return-Path: <linux-erofs+bounces-2904-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D2D108B8FF
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Mar 2026 07:21:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fd9pT6Kdvz2yZN;
	Sat, 21 Mar 2026 18:21:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774077681;
	cv=none; b=cevS5cltsTmfIZr5msxHI9U7DlzxsQNvqZA6UHqu0b2mjUOIZn4go2UZhVPW0NfwleogaI+Xm7ztdBLpVYyKdQW0nBcKJy9Ul0zzrF55VlaPGRzwqcckXJRpA2jxg/demnXeFCATGECNIHprrtXKWdiUmT2ZkCgw0bXhvm5uWm7U92AuQA2AoaLbPgzq0mPVZh3bLTR6wbujUPBHNNets1yEaiU2UNh3Mj9EqXe0ZfnyZbnOho+4eb/6Ft4DLFfdXNHFr1uszZ/su+v3zJn2KDmxkMMdauuXGVzAtPv91cU6iwoaPwrLvnI+MNaAGWuXDlGVvstjxkXt6A523cuJVw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774077681; c=relaxed/relaxed;
	bh=Sm/tjsVL+frWSs587KnpPtakMYO7x9q4LCSbfi7VuV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTL5RkAZnhA+SwzAecihGHb75FIxXDBb1IfC8MdIbmZh26ZhMH/dNLs8lFR0Co1VpFRBhZndm+kYdZNaUYeRaeW5Rk1T2SaBS4fIEDAbAKyMv4Kvtf0b0QXtkONDVyVKEgL+3rJmIlZ9w/IHgDNRjCo9cdWkeFNyBioces0oYYhYcaVFQXXGv1yqIzCktIHfPqKs77J33aDArlO5HnuoJyEumnq6ae4GDSAa2977K3ELeIuoROWlFMHOgbBK5VH9DA4VGGFBars7BO97O85FIRlvHTtRszAnwEDEK71fe0Ji6Hzr2pVmKMNsPlYGN548eln0Uu1La8OYT3U4vIwv+Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Tpl3G7To; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Tpl3G7To;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fd9pQ0DM3z2xP9
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Mar 2026 18:21:14 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774077668; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Sm/tjsVL+frWSs587KnpPtakMYO7x9q4LCSbfi7VuV4=;
	b=Tpl3G7To50vQYxQgk3k0hW89myAfjKdzn0kgZpIH/t/nRrFPR7WVUNjZHh+jd8gtbqtv6K1P1x7Si1yaT3ubQSmlzbsnAi8FZcePtEJDfTdNthehHeVW30XtHz6ctzR5cWSgj59+7UMTxGOWkdaaNJ2OMdMLoztJMOCLJWajHdg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.OJF2C_1774077667;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.OJF2C_1774077667 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 15:21:07 +0800
Message-ID: <e06d4f47-5fd8-4a7d-95c8-b4fa0fde62d6@linux.alibaba.com>
Date: Sat, 21 Mar 2026 15:21:06 +0800
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
Subject: Re: [PATCH v2 2/2] erofs-utils: lib: fix memory leak in
 erofs_gzran_builder_init error path
To: Ajay Rajera <newajay.11r@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
References: <20260321062604.1905-1-newajay.11r@gmail.com>
 <20260321062604.1905-2-newajay.11r@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260321062604.1905-2-newajay.11r@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/21 14:26, Ajay Rajera wrote:
> When inflateInit2() fails, erofs_gzran_builder_init() returns an ERR_PTR(-EFAULT)
> but forgets to free the previously allocated erofs_gzran_builder struct (gb),
> resulting in a memory leak.
> 
> Fix by calling free(gb) before returning the error.
> 
> Signed-off-by: Ajay Rajera <newajay.11r@gmail.com>

The same issue.

