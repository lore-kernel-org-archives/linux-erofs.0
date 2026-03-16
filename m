Return-Path: <linux-erofs+bounces-2753-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 145CEF53D78
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 17:00:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZLtn5Cs9z2ygl;
	Tue, 17 Mar 2026 04:00:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773680417;
	cv=none; b=FcUr6sJxch51sDBTsG/zVbl9H6OMtlSSbgDTp7eQH3ETFvkzXHKahfDqdJCCBtwZVLPMGHDoeriAM0jSTaID0cPcTe6U9yZDCMYUShtbHETKAhXKD0uDWsPNgma4kdcppkwVc7jX4gnZZUGcM59COMhlVOP3DoUoDRvfXeXl+ECoxHWU0kfkB1GwZtE4XLnZmOpgMpVBWKAvNxuBQC0H+8ftoIX7FEIWc50/pShKtlIZQ8i5ejuYrTWtn58KKN1AYnDpflDzbnw17hMcD2Z/kYuDgKVvjatiy5LI2TpTyb9PaR1I/uFv44RcmkgAD8Ohslu96PHnBcOFoPHdFf/1ew==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773680417; c=relaxed/relaxed;
	bh=0A45twAKblJsoYFUgABexUIbN8Gh76AgW4BbNLmtxsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUxpF2GVlGewNlbpz5Br2Mj4F2vNsUCsA36/dp2VdngjGZNqlmn2vyXcbh/jrt2ec+P6mDVGPu/xDETiqvBTLvpNHtI8m6pMyDSQpy0PrxQ8EDwaV9wpV5eXDCVZU2wqfStEAdE+K/ZSfmc6jAeDV1ye+vMYXqmILr01RviP9R8N5+5GeLiFwDykrjGqkwk0FaxcsAyF/EVmGTF/9rtlayBnBfZ98AgU0mm+Xuqw9gy0VHZ2ecFDaXDXHLjFaL5F7bBN5asWRwbcktL8ZjRVnKqUF2uVyOYS5xcgZq1kwMZdxIPmottTSSRPHcqoLT+lXorUJradKX7nGu6BYe+ybw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AU7Oj/nq; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AU7Oj/nq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZLtl1fQTz2xS3
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 04:00:13 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773680408; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0A45twAKblJsoYFUgABexUIbN8Gh76AgW4BbNLmtxsc=;
	b=AU7Oj/nqdpa12zhw+uqaqDQlcx9ZPAt/DOaO4YozUk1gl4olMou8HAu96Lw8rBnSHBx5ZMXwkn/Ni8D7oBPuZ3/m/qIvkRCrlPoK/fKz4TIVmr9d+KSPsgutxZGzhOZbANF5Qp+4B0uPY7uVRiPEEtF1hBW4AUPPGOl3eywWoJo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.5royw_1773680406;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.5royw_1773680406 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 01:00:07 +0800
Message-ID: <19a568d7-17f2-4eac-890c-1e66a9592edc@linux.alibaba.com>
Date: Tue, 17 Mar 2026 01:00:06 +0800
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
Subject: Re: [PATCH v2] erofs-utils: lib: name worker threads erofs_compress
To: Nithurshen <nithurshen.dev@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
References: <6edda81f-5d2e-49d0-9b31-181e3fdf0b18@linux.alibaba.com>
 <20260316165418.7051-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260316165418.7051-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/17 00:54, Nithurshen wrote:

..

>   static void *worker_thread(void *arg)
>   {
> @@ -9,6 +12,12 @@ static void *worker_thread(void *arg)
>   	struct erofs_work *work;
>   	void *tlsp = NULL;
>   
> +#if defined(__linux__)
> +	prctl(PR_SET_NAME, "erofs_compress");
> +#elif defined(__APPLE__)
> +	pthread_setname_np("erofs_compress");
> +#endif

I'm not happy with this part, please read the v1 reply.


