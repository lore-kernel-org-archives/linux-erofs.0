Return-Path: <linux-erofs+bounces-2757-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BC7F53D78
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 17:16:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZMF21GMyz2yh4;
	Tue, 17 Mar 2026 04:16:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773681366;
	cv=none; b=KtVeDXhsYIRLydlKAMQAsmyVcG32qIJRm7lXP5y2zbD3D/PSJBSojGGq8YNigVQfXtDxDqjBP3P3jq0jssnenwYbl0PC8aEcwcgl037MSgF4PEt0Lc8IOjys7sSSuXbSFl3z+AmjNCNgQ0hxqEnggC7QhG5/Cr5WT2JzUuYEoziUCOYk9EoXT+mke31rv5e1JP9eAa4G0Na0zq3e/1Sw69FNNSkamsvDgVwbcVLje25TRxVhQMm4sMzZH0LtpuAlMOcZbo3vNoJQBY9JNFS0wbMYSQ1UF1IMh9uGfCVtjnFu0HkEHivmvQi0dwOFZih/kHrd/zJ/us0ofODkiZSEzA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773681366; c=relaxed/relaxed;
	bh=FlP88cs/dF7Xr+f2/B3T2PvZLzU1RvGiOhjWjVzqcDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KD75uwei857gXHkdne9ERKdWUS3znQ/r0pgfeT21L1Z199BElMEeuabWbFc0NcBN9X2qh2rBA4SZsHBgmVuNSGgNn1RD2/xXBNXg07wzhhoEXQm+iek/rWGS1cnshZekTN0FnwjU0tG2MwzW+P3bvCJqgp8WWZQUM9XIjgZiSrSIn2UoHW9zz76sq6UFJdibl+XMH0XaRTz2imMxwEieMbtDEgrdtBVJ8BdFfU6G5NhExn3Hb3fdGuhhNXEskI/MrZ25fEHV2ZjPULoa+gYfH/4cyT1v2OXY2DkCPpuOLLKgUycfLOvwidV0jN0pU0PhQA/X1V2OgJi+ym/9hQK1Rw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Tfu7S4qb; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Tfu7S4qb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZMDy3n6nz2ygn
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 04:16:01 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773681357; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FlP88cs/dF7Xr+f2/B3T2PvZLzU1RvGiOhjWjVzqcDY=;
	b=Tfu7S4qbhF8o8VzosACVhlJtq02PviJMLeFIehH0jN6/BDvRFsEVu3L/8FySDOKh7Nf6GegBC+5lgQsx1EZBDep48920v7WQRBqMPJ3dD6qgyq6uGV5ySOm8r/bJ2S37S6cfWGkcjQkLWCzO6eIZ+YtNQjd5KKiD5mennR2RuoM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.5x7zH_1773681354;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.5x7zH_1773681354 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 01:15:55 +0800
Message-ID: <7e85a4c2-95a9-4ded-be83-97ceb7d707a6@linux.alibaba.com>
Date: Tue, 17 Mar 2026 01:15:53 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: name worker threads erofs_compress
To: Nithurshen Karthikeyan <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <20260316151352.59423-1-nithurshen.dev@gmail.com>
 <6edda81f-5d2e-49d0-9b31-181e3fdf0b18@linux.alibaba.com>
 <CANRYsKivDEJojD3xgLcL5+jmmA3X-YcFpF-mweN5ef=eMhL-Qw@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CANRYsKivDEJojD3xgLcL5+jmmA3X-YcFpF-mweN5ef=eMhL-Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Nithurshen,

On 2026/3/17 01:11, Nithurshen Karthikeyan wrote:
> Hi Xiang,
> 

...

>>
>> Why not just calling erofs_compressor, since those worker are really
>> compressor.
> 
> I initially tested using "erofs_compressor", but the OS thread naming
> API (`prctl` with `PR_SET_NAME`) has a strict 16-byte limit,
> which includes the null terminator.
> 
> Because "erofs_compressor" is exactly 16 characters long, the null
> byte pushes it to 17 bytes. As a result, the kernel truncates it, and
> it actually shows up as "erofs_compresso" in `ps` and `top`.
> 
> To keep the output looking clean and intentional, I chose to use
> "erofs_compress" (14 chars) instead. Please let me know if you are
> okay with this, or if you'd prefer a different abbreviation.

Ok, or just call it as `erofscompressor`?
`erofs_compress` is really awkward to me.

Thanks,
Gao Xiang

