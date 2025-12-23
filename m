Return-Path: <linux-erofs+bounces-1550-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D64E6B26B
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Dec 2025 02:32:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dZzZF1zknz2xlP;
	Tue, 23 Dec 2025 13:32:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1766457173;
	cv=none; b=WW8j6r9l1jieujScjS0RiAPqtbA/TUF0d5thqjmfkVVJ0DvCYyrYDTQo4mMaHuYm1/xqjEqABkf6QAGDSUHMo6IljWtPKIFDPab6ew5slYov4TWhxK4i6H2wKZaALpc1jDelUkt7R+xN19ZNlzxhqb7BAXEQX69G+1aDXecU7CdZPAXM1p/MqZj/V2fXZZ28EWVwEJFHmpLLIur75FuMJ5jQjinH5bro4F7PCFSaysl5UMIZJYc+qkgiYdNJ4zQqBbO0UzPFSnjTvkElEZH1SF2hoDsSSmmNcxRGThH4eQFHnQ4TMJ7lH8YsEJZN8emyG0eOYQwaweyTVcOsfTsulg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1766457173; c=relaxed/relaxed;
	bh=LafoTpYEo1plUM3lq+PWv9KVMIu0u9uxFJf3gdwcn2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KeLcm+5HERfEsf7LyYgndf//815ubmtw6WUONnOv3UyqZDdG/KoR6DNef4uyvUV35ZIRiDFOdBcrIRrYp5uBgnIxPCnooUWIz2BY67Vc+dx4PrCB4Psb78i3/iEFjYC50WtHFiW8OVcFK4PHyuUIWq5QudRgt8KvQNfEIiZgsqf4nBIPMg+mOGuYxlUzQFPpBF4+4V6EjMfK6Nq7QEbaNwlCd8vHW6Tq082fxo+APJNnf1wFLXLl8aAlg5z4vebLYexFjoCpMHtghHlnNM2M5fuitRzBCFvYaH7vm/aWu39+IZoJqQvlL+2QzR0Xhs0QC/tvWfdCrOZ3/x2ouqInyg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HZ3ATcnV; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HZ3ATcnV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dZzZD2CCSz2xdY
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Dec 2025 13:32:51 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766457167; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LafoTpYEo1plUM3lq+PWv9KVMIu0u9uxFJf3gdwcn2s=;
	b=HZ3ATcnVPc6foLiadTcmiPlF52U/6xh+m0NCOb7myVL8HOxGfKupd8x+HbgQHI0BaEw4vm2oWtDbdW8KZNdqdDWDQvA0P2/qiyTQ0O9HB/vgjozL09hxcjsY7chdjLnv8k+UOwM4AO+aemLDRXFliq4vShbyiyg4x+uYIXbpKCs=
Received: from 30.221.131.244(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WvVyoMz_1766457166 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Dec 2025 10:32:47 +0800
Message-ID: <65cf64e7-c395-4508-9bac-5a8dc08e8f3c@linux.alibaba.com>
Date: Tue, 23 Dec 2025 10:32:46 +0800
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
Subject: Re: [PATCH v10 02/10] erofs: hold read context in iomap_iter if
 needed
To: Hongbo Li <lihongbo22@huawei.com>, chao@kernel.org, brauner@kernel.org,
 djwong@kernel.org, amir73il@gmail.com, hch@lst.de
Cc: linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20251223015618.485626-1-lihongbo22@huawei.com>
 <20251223015618.485626-3-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20251223015618.485626-3-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/12/23 09:56, Hongbo Li wrote:
> Introduce `struct erofs_iomap_iter_ctx` to hold both `struct page *`
> and `void *base`, avoiding bogus use of `kmap_to_page()` in
> `erofs_iomap_end()`.
> 
> With this change, fiemap and bmap no longer need to read inline data.
> 
> Additionally, the upcoming page cache sharing mechanism requires
> passing the backing inode pointer to `erofs_iomap_{begin,end}()`, as
> I/O accesses must apply to backing inodes rather than anon inodes.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

