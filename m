Return-Path: <linux-erofs+bounces-3943-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E370C4451C
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Jul 2026 03:44:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h43Cg4L05z2xqJ;
	Tue, 21 Jul 2026 13:44:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784605455;
	cv=none; b=gyMlHHnV9MF0It0Hnj3kER8nDPZA9bEmabJNQyfTlR75rSDEJWvXcCevvumwhRAlY0547gob4AYuR6ZKljgn+IQppkCYKf9DNJxww+CH4Ren9Sxqf0AqUHyTax3WcBhdATYKAUcwKsdCHP1B91mYiBU7lpsH5corAQ1S0Xrx6WDVJacmogvuiUwSj4jPFBAgDuabw8m3Dto4i+Nrlbenkcm3u8r9zJJy+XlHDoZW1ViULyoOf1oseGL5CcUrLJ3MWB8U9SMwpSbkWgvoNxC/uE5pf+NbbZv2ja/b+p6r9x3yS33JqvqxPxV+ZWCGLn6bZeyObNZPLJVqjdsttdNGag==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784605455; c=relaxed/relaxed;
	bh=T55NA4EysOXjtaF5QyCcmdll5bxsIXre+LCQ2EP81Dk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jXFfnVH0jqZMVZk6mfP7d9hzEQQ2iaXCCX9FIVePcKBTllJe9rjiaAKuomr3w4Jf1LknqnENmpOq4z6vYWIjSpVZvsPspgO8Fsxk/gaxzZibYXgF1MoQ4ye8sthUE0xpAtqms3Eq6h8F6YbEP1I3Ca4flrptoTCzZrrlZaEEc3a711uNjfxW60aebpcZNzVjtRvP6SPqEZaQ9b9tYNuG5+FQy56yEyfp5GjYfVQP2nc5TNu4FP7+5aACYIR+xEIm00mDOe3uQcYJIyXTT6LSz2tH9ZpmulbN5ob9iMZ0Ib3hMbK/WR9KAXkAuYHU/WtB1U7+a7lZau5/65LP/MgMWg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=c0c+WMsq; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=c0c+WMsq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h43Cd4D46z2xjd
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Jul 2026 13:44:11 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784605447; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=T55NA4EysOXjtaF5QyCcmdll5bxsIXre+LCQ2EP81Dk=;
	b=c0c+WMsqoTyFhb/+uAIRoFXenWO3ebH+Eq3+bD5kugOqNgkFZ4tVfT4ui3eiyncBkLyZyRp5+wy9U128g5psJn8jJWm0YrNvYlFYaJAvvoo/11HJn4wdUM87ZKWNZ6vKDnsh/uIdokkEqI1HnzBa/Xvx0BfU3ouPvgCWhgUxmCU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X7YM.8K_1784605445;
Received: from 30.221.132.10(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7YM.8K_1784605445 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 11:44:06 +0800
Message-ID: <6179ba55-d53d-4c46-8220-d7340f18e8b5@linux.alibaba.com>
Date: Tue, 21 Jul 2026 11:44:04 +0800
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
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
References: <20260714114729.3760594-1-michael.bommarito@gmail.com>
 <d0d5816c-8aef-4155-806f-37094c79d847@linux.alibaba.com>
In-Reply-To: <d0d5816c-8aef-4155-806f-37094c79d847@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Machael,

On 2026/7/17 11:43, Gao Xiang wrote:
> 
> 
> On 2026/7/14 19:47, Michael Bommarito wrote:
>> fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
>> pool from num_possible_cpus() when the lzma_streams module parameter is
>> unset, then z_erofs_load_lzma_config() preallocates one image-supplied
>> dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
>> systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
>> decoder state until the erofs module is unloaded.
>>
>> Impact: an attacker-supplied EROFS image mounted by the system can pin up
>> to 8 MiB times the LZMA stream count of kernel vmalloc memory.
>>
>> Bound the default stream count by a new
>> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
>> worst-case default preallocation is 128 MiB while preserving the existing
>> per-image dictionary limit.  An explicit lzma_streams module parameter is
>> still honoured as-is, so administrators who deliberately size the pool are
>> not affected.
>>
>> Fixes: 622ceaddb764 ("erofs: lzma compression support")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> 
I submitted the following version to -next:

 From 4ec57610a769cd93027d12134c75160390b23b08 Mon Sep 17 00:00:00 2001
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Tue, 14 Jul 2026 07:47:29 -0400
Subject: erofs: cap LZMA stream pool size

fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
pool from num_possible_cpus() when the lzma_streams module parameter is
unset, then z_erofs_load_lzma_config() preallocates one image-supplied
dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
decoder state until the erofs module is unloaded.

Impact: An EROFS image mounted by the system can pin up to 8 MiB of
vmalloc memory per LZMA stream, either as intended or unexpectedly.

Bound the default stream count by a new
CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
worst-case default preallocation is 128 MiB if the number of CPUs is no
less than 16 while preserving the existing per-image dictionary limit.
An explicit lzma_streams module parameter is still honoured as-is, so
administrators who deliberately size the pool are not affected.

Fixes: 622ceaddb764 ("erofs: lzma compression support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
  fs/erofs/Kconfig             | 14 ++++++++++++++
  fs/erofs/decompressor_lzma.c |  3 ++-
  2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 4789b1077d8ce..36f027c1c5ac5 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -131,6 +131,20 @@ config EROFS_FS_ZIP_LZMA
  
  	  Say N if you want to disable LZMA compression support.
  
+config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
+	int "EROFS LZMA default maximum decompression streams"
+	depends on EROFS_FS_ZIP_LZMA
+	range 1 NR_CPUS
+	default 16
+	help
+	  By default EROFS allocates one LZMA decompression stream per CPU.
+	  Each stream can hold a dictionary of up to 8 MiB taken from the
+	  mounted image, so on systems with many CPUs this can reserve a lot
+	  of memory.  This caps the default; the lzma_streams module parameter
+	  still overrides it.
+
+	  If unsure, keep the default of 16.
+
  config EROFS_FS_ZIP_DEFLATE
  	bool "EROFS DEFLATE compressed data support"
  	depends on EROFS_FS_ZIP
diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index f6692d0f2f04d..6b0cdb446c6ad 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -51,7 +51,8 @@ static int __init z_erofs_lzma_init(void)
  
  	/* by default, use # of possible CPUs instead */
  	if (!z_erofs_lzma_nstrms)
-		z_erofs_lzma_nstrms = num_possible_cpus();
+		z_erofs_lzma_nstrms = min_t(unsigned int, num_possible_cpus(),
+				CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS);
  
  	for (i = 0; i < z_erofs_lzma_nstrms; ++i) {
  		struct z_erofs_lzma *strm = kzalloc_obj(*strm);
-- 

