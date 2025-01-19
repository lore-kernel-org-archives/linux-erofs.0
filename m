Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1DC8C02183
	for <linux-erofs@archiver.kernel.org>; Sun, 19 Jan 2025 12:49:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YbYFN6qhWz307V
	for <linux-erofs@archiver.kernel.org>; Sun, 19 Jan 2025 23:49:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1737290950;
	cv=none; b=N9pDRAvtrfTdqeD/dTvau9x5uJDVNGaxDnmFTT/IPSfyvZo1nGF9SCkU7xhYTl+feP164wfcS3BKfp5AxmZZyvnzoPQ2X8MYbrj5TyOuc8S4US9AVrFXvpv+ukz+LvNeDrEOpktdSjGV7vpR3DAQE432sj5j9AOlGJt/CM2t1U51rz1iekRURDIk7//NPfPrT81EpIEoCPaJNW2T23MqB4DJ8H+BC0nD/oEndVgkFVac5enlRy4vLkePCF1Sn++FYCw/11wOek71h6ftmT//QoSz5CaEBsuEB7y5H2jGkAEdxf+8mrsMBYKYm98kxO6Be9mWynxHL0KipUl6T61sxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1737290950; c=relaxed/relaxed;
	bh=TWMPaFfYcsP4FSA91TADumQmbgN2OyXXY/BOngPxQ/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i1zE08DbSE9cMkTVmaJbXsy3DHIqpj3KypPpQ9YIk0WM+MEyscO3PTx12dc3Vs3PanB+1R+RRuOkKx+/qAWjykx5fy3bkLcf+TolZksD5jzQ8I5Eq5ARM+4Lm/eUoua9kYmpl2sLYyjVZUunS/WBOGej+RAVEQQ4TkB+da/G2pbmH2DZ4UBnip/clRBjesz42znbK3usXVu45k5VtS3+vD8c4eCsfS0LKvrUnjHx95LaLSmtNgfndRClzMQqqfk7gENztwzGSe3i4AmduX6m8qfvZVwi5nc919bJg0pwoYRyae/+kpXo8gGxdSqWI4RtqlGqZXJOPXTXSY1CUI8c2Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DP8DJPcm; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DP8DJPcm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YbYFJ4tz4z2yDT
	for <linux-erofs@lists.ozlabs.org>; Sun, 19 Jan 2025 23:49:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1737290942; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TWMPaFfYcsP4FSA91TADumQmbgN2OyXXY/BOngPxQ/4=;
	b=DP8DJPcm+0e6hpvVmtoEWTRLMTsX1m2hgJX9ptNKnq/gDIeJKfwICxkUnRxuQLNA3lrBnFanqRN62QcBMomkz2iMDR3NzLKNQSVTfyUqiFGrb8ZgFns7OAFk5NbbmLLxRmNb+ygEG8GQHpM+hxPIpopyZu3nngWtKaxBrbuC2LU=
Received: from 30.41.10.74(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WNtp7a._1737290935 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 19 Jan 2025 20:49:00 +0800
Message-ID: <e3bacff2-777b-4ced-9797-05b44dd18930@linux.alibaba.com>
Date: Sun, 19 Jan 2025 20:48:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] data corruption of init process
To: Stefan Kerkmann <s.kerkmann@pengutronix.de>, linux-erofs@lists.ozlabs.org
References: <c1e51e16-6cc6-49d0-a63e-4e9ff6c4dd53@pengutronix.de>
 <14b78097-ee6a-4e91-9688-172ce807299b@linux.alibaba.com>
 <1ee54399-88ef-440e-9262-cba0bcc28c90@pengutronix.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <1ee54399-88ef-440e-9262-cba0bcc28c90@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2025/1/19 20:07, Stefan Kerkmann wrote:
> Hi Gao,
> 
> Sorry again that it took me so long to respond properly.

Thanks! Let's me look into that first..

Thanks,
Gao Xiang

