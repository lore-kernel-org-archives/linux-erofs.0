Return-Path: <linux-erofs+bounces-1625-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EADBE784BE
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Dec 2025 01:43:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dffBk5P3rz2xrC;
	Mon, 29 Dec 2025 12:43:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1766972622;
	cv=none; b=VuOKZz0/T7m9ln0j98hx1IBpISEEMiGpShiEisFoh1iOtnVAGh1W0cVUDFeJ+GqKndyInC8i9iqAEDF6hJ4qt7wV6uy1BksKZZykibhwmNjmRyutHH4nRow62WhJ5LkLqKdb/+OZfOHkzL84IVJ83vH1EJimRDBAHPSJTOAK2R/g6yRNsJ1TnvVEWh0SgJy4PRGRtdRtf7ZbioXLuJezyna4YqxCwKb018z0HKtRm3zhMZI8zNn4FTCA4pD8wrM2VwJkx6Ar9wxp0IntOD3lt68Bd2j9fd8KKkT4eXynHdPfUpcl1D5UwT1t8xh14zUrAwQzoI/LMa69SxQ7LwDx1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1766972622; c=relaxed/relaxed;
	bh=Kj7QyA1sJlGQCQaKjhCCmobAcAwqlRtGtkOkQpYqJgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=juMEYS2jsAPLPPfLmX1y5sV2cP+mCEJSVDxWI1Aq9ONKA+YEBx8k+jgtyyHCpSyDxPVHEEOotGcvmQ1w4p5DoWx1fZ56RFwkl00oWhWwgWQdjs6bO7DhufLpg0FHQ85yzxeVBQk9FIlBALYBrWw7AlOGZD5H0MWOS2vB+2yUSJk0Wev1m4da2cYg49sfPFrXTVC7P1uPrlAw8JW1baSHRN9L60MA69m5bKEREOtk5bSD3utY+NIy/4W921K9RXBqRgVDvrH2bSs+o0DevX67/i1W0ul5783sli60/kmg5hQJ9QlDQP88DzQ14FpzPfuqJSjz4TAAZUHzBqCTtFts0Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cr7YNLb4; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cr7YNLb4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dffBg6lvyz2xqj
	for <linux-erofs@lists.ozlabs.org>; Mon, 29 Dec 2025 12:43:39 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766972614; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Kj7QyA1sJlGQCQaKjhCCmobAcAwqlRtGtkOkQpYqJgU=;
	b=cr7YNLb4SI55ZNG49yCC25061nCvIRlIyE5xCzY36rU3ywLNAgfToSsepZSiasIhJWnMgcixH3GziemvHPJHFjBI+jsgQkplYVEOJKKbsXDZSbVyct5ghK+EIP/V24g7vkDdrYnRGi7Ue/oNiFF1sM0GEOUT2IySsgzl7jIztYQ=
Received: from 30.221.131.9(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WvnT78n_1766972612 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 29 Dec 2025 09:43:32 +0800
Message-ID: <cfdb5acc-765c-4106-bf7a-96054c211bc5@linux.alibaba.com>
Date: Mon, 29 Dec 2025 09:43:32 +0800
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
Subject: Re: [PATCH 2/2] erofs-utils: lib: oci: restrict `ocierofs_io_open()`
 to single-layer images
To: "zhaoyifan (H)" <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: hudson@cyzhu.com, jingrui@huawei.com, wayne.ma@huawei.com
References: <20251216070557.743122-1-zhaoyifan28@huawei.com>
 <20251216070557.743122-2-zhaoyifan28@huawei.com>
 <0027bee0-b4b0-4cf2-888e-d410d08713e3@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <0027bee0-b4b0-4cf2-888e-d410d08713e3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2025/12/27 16:48, zhaoyifan (H) wrote:
> Hi Xiang,
> 
> Could you consider apply this patch first? As we disscussed before it prevents subprocess
> 
> from segfault while oci.layer or oci.blob is not specified in mount.erofs.
> 
> 
> We would better not add an error print for now until we refactor the current codebase and
> 
> fork one child process for both netlink and ioctl, otherwise double error messages are shown.

Could you send me a patch list so I can apply in order?
Or you could just resend with a new series.

As a generic rule, bugfixes should go first before any refactoring,
since refactoring impacts more usually.

Thanks,
Gao Xiang

> 
> 
> Thanks,
> 
> Yifan Zhao
> 

