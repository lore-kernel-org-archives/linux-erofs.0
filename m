Return-Path: <linux-erofs+bounces-2341-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4412CC61DE1
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Feb 2026 10:16:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fJ31Z3J5Tz2yrn;
	Sat, 21 Feb 2026 21:16:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771668994;
	cv=none; b=ENa8JY+/rbuFVn/4RAud03c/n9AgReRLNA53mASf2Q0ZO5sdcH/2Km++xb4dE+kGf3PHPZSkd5gQ0I1cD0RxDl3UBhgZlZKPEWKRblfA4JNOlJv8N5aN8G6z3H6HuwilxZRqPTS3AOGPUmFoBM9vtWj2DUrA+6fBafxp5LOT2/rP93USmhTmh1oCHQaaY7LR66Rhdr1uAxrPv/NU+kcJZ84DLq/aNtCnIrjCWRPy8Tb7MyorVj3XQt5naftETt2a031eRu9GVodazjVfPcDNZesZgQtDJpwxdW8Kg9KHQCzm5ySkoYF+MetXagw8ZBdLDsQAhaSVZ4nqAyXlGmYl1g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771668994; c=relaxed/relaxed;
	bh=yjjGZaVeU8H2iQuhAl0NXBgR5+geLqoyotWslXE9UF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hac5CIZKvQ5PKHcvmAag0aY2+z4brhbI0iDUMHlSWIdsfELX6NZLkrJKFyUOAEu2bljUPlCwhbvkQkpq2zgB8oaRf7BdL47G2q2ON8jUAmqitD9y8yxjnc12xyoYEHro3kniUQ5obgm/KH4bT8Dfv7QoV4ldI+BodPPE8A99v25X7Kglado/OCvO9Vw/BaBkl0fPyvIoQBCUbjj6XW3XPBnF+wDSaCBONyrer6oFu8lBtpzMDLALt3gmdFNlw+zzJjvdmRJ/CNE3rXQrpK65Yfkkc+4ez/U90H4Ru3dINcmJNaRjbVgg06dV1r8oxK1gy8A+6mFQcKS4fpWP54aB9A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fQaJDft1; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fQaJDft1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fJ31W6HPhz2yY0
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Feb 2026 21:16:29 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771668979; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yjjGZaVeU8H2iQuhAl0NXBgR5+geLqoyotWslXE9UF8=;
	b=fQaJDft1RsKeZzJTlTXxgfddX/lU9zfCkcMpydpY5K+TQCuuPH0ducO48suJzpCbjAthVjuDUTQNUDuFaYzrukH2DnfTqmIXWLZVTxYOUGKLzC5kCFB2gfhrSA3GMGuVS/76/xhOPXKEoJAWjeT3WO+Ej37QivEIXyHlrlhWx3U=
Received: from 30.42.59.174(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzZO6qp_1771668977 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Feb 2026 18:16:18 +0800
Message-ID: <f3b30443-3e33-4f29-9859-c092e3021ab8@linux.alibaba.com>
Date: Sat, 21 Feb 2026 18:16:17 +0800
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
Subject: Re: [PATCH] erofs-utils: fix installing erofsfuse.1 manpage
To: mail@duncano.de, linux-erofs@lists.ozlabs.org
References: <20260220183110.2633838-2-mail@duncano.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260220183110.2633838-2-mail@duncano.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Duncan,

On 2026/2/21 02:31, mail@duncano.de wrote:
> From: Duncan Overbruck <mail@duncano.de>

A fix was already in -dev branch yesterday
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=dev&id=bb4d440337258ea8a047779c9ca4875c73806ee7

but I'd like to wait for more time to release
the next minor version.

Thanks,
Gao Xiang

