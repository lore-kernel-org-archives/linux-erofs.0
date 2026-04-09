Return-Path: <linux-erofs+bounces-3245-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72205F31E21
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Apr 2026 14:21:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fs2Dc6kcQz2yfS;
	Fri, 10 Apr 2026 00:21:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775744496;
	cv=none; b=RMbs7we8z9Z7hSdW6n90thHunmX5ro/OU7RbNkB6OEbjAssOrPtHU6dY8aWPAbI/qXD3lTdULmas0QCMlRR71luwZSIR3w0nmkklT7QN0WRJiODIbWbp4SI8GEszPMK8zaj/Oc1S7K+grp01UO+PsN/5fzh5t4HPqFwiMPs16Fzgm1mauaaaSOZXcycMs9YbnCKq0iHGUIC9JbmXLitrfcd+s0KmV1E/kQ9CTSvufTy986ACLx2ISDyP+Jg5j01eDIgwFRFIfTsYvxA6qdr0qL+z1afIYn5G4nopaciwuuaYLP6H3FJfsxQMJi+R+/w2EGj8jFLr/1/YcmCQGMKdFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775744496; c=relaxed/relaxed;
	bh=aTxGI8l0r04nOEb3UC/ArkCWhXNCZAZID+kdMOdexuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DORdZTeq+GOKcnYvs5EGArOyCPDmjFtPMBiyxicpZqK4NEZJn+/XFhKIR7kQWB8mhZBWqx8hEqanhihYA/WpinOFXp0YMn2wUptbXaxlR+nUnA/3xqSxqpu9p3AF7pkQfeFTeEcUZF3ealfxY4rxvq/33CgJtBDfBAUHQOBPwPgkSKfXGBRWQCQVVDC6BAHnQMj3A1jr0gPniyyC+ue6BnkBzxyhFcZEnZFwf+jbxZpl3Ffcb7beZ/Em6MOT7bvOShJhaiGI0YA+Cj6DyhYaAnRennWtkKn+4Fw2Syk6aOLfWf1/Pfxbzu0UhTdznpjTBzitBrfztVqqBu+b9Mfzbg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KlsQT2qx; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KlsQT2qx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fs2DZ110Zz2yS9
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 00:21:32 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775744488; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aTxGI8l0r04nOEb3UC/ArkCWhXNCZAZID+kdMOdexuI=;
	b=KlsQT2qxCY2RoienJFh0CdEMjeZj2tv9Agx2CjDzvNag53GTZEg/Y2chZeqv0kgKZluAammNm8KjeDstf1wFuHw5II5shXN5saeSxCcqGa3v+yNUHPy0HepQTyw8gqqfMQpe9k+BiLFtVHc3ZbbZa5hNKvMvyxJHMBRtHUCq/yE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0ibMHm_1775744485;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0ibMHm_1775744485 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Apr 2026 22:21:26 +0800
Message-ID: <d82bf7e2-a076-468f-89d1-754210c1e190@linux.alibaba.com>
Date: Thu, 9 Apr 2026 22:21:25 +0800
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
Subject: Re: [PATCH v2] erofs: fix unsigned underflow in
 z_erofs_lz4_handle_overlap()
To: Junrui Luo <moonafterrain@outlook.com>, linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>,
 stable@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>
References: <SYBPR01MB788118F7F3CBCD0B894B5460AF582@SYBPR01MB7881.ausprd01.prod.outlook.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <SYBPR01MB788118F7F3CBCD0B894B5460AF582@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/9 21:59, Junrui Luo wrote:
> Some crafted images can have illegal (!partial_decoding &&
> m_llen < m_plen) extents, and the LZ4 inplace decompression path
> can be wrongly hit, but it cannot handle (outpages < inpages)
> properly: "outpages - inpages" wraps to a large value and
> the subsequent rq->out[] access reads past the decompressed_pages
> array.
> 
> However, such crafted cases can correctly result in a corruption
> report in the normal LZ4 non-inplace path.
> 
> Let's add an additional check to fix this for backporting.
> 
> Reproducible image (base64-encoded gzipped blob):
> 
> H4sIAJGR12kCA+3SPUoDQRgG4MkmkkZk8QRbRFIIi9hbpEjrHQI5ghfwCN5BLCzTGtLbBI+g
> dilSJo1CnIm7GEXFxhT6PDDwfrs73/ywIQD/1ePD4r7Ou6ETsrq4mu7XcWfj++Pb58nJU/9i
> PNtbjhan04/9GtX4qVYc814WDqt6FaX5s+ZwXXeq52lndT6IuVvlblytLMvh4Gzwaf90nsvz
> 2DF/21+20T/ldgp5s1jXRaN4t/8izsy/OUB6e/Qa79r+JwAAAAAAAL52vQVuGQAAAP6+my1w
> ywAAAAAAAADwu14ATsEYtgBQAAA=
> 
> $ mount -t erofs -o cache_strategy=disabled foo.erofs /mnt
> $ dd if=/mnt/data of=/dev/null bs=4096 count=1
> 
> Fixes: 598162d05080 ("erofs: support decompress big pcluster for lz4 backend")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>

Thanks for catching this:
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang


