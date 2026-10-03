Return-Path: <linux-erofs+bounces-4653-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 241C9CA5FDD
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Oct 2026 23:35:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hy27Z15kpz2ynZ;
	Sun, 04 Oct 2026 10:35:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791070506;
	cv=none; b=QTCf24iNCk4MBM5DX7TwmCQMQF6AV/pJHqomMPoxEKX7Yzwhh70j5SQqDEGG2/4XfEytZum6rLKDsHfnxFiFaFKVMIvME81n/OB4tTog5p4Fg/itsv3XLpVEKOzFy/RHWXI48XXVZ4et2QnZe2YoIz7FP1eLzyMK0rjnuJo2S/sblo/73NgkV2vuefF0u/5LTUA2QTG7mGqtB/eMHidvz+h7xNCXgdKC9Y837A3Lgc4O9yvCzKIdsZe35q/JWMwI1nuWsO8f7f2soWY35RRlzExdxe2pSn9DHV6RGb3u9uFQ7qaRmCRbhxQ5vsSrnA+cMvMZfg7lUCdPxo/hi+uxdg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791070506; c=relaxed/relaxed;
	bh=06jrm1eJOKkEfVYjfM8urZVFEtTHJTgdf4MXi9Zr75I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=OqQHt4FrOvTkySlj/wzk6DH2dDZr77i2XVlZYzik7mjQ4x7Ad2vB4PaquYPI3+YAXVw+vVCaEa/NZEDDwMGCn7Vcb+3SW1Ggybrz9DoZxvtEb/S/PHxDXE/h2ipBO70xhSLU3XM9Cc6GO8qrZi3g4rea8CCqffhNaH9I4DIBfHiW0G/aphbohu85IyZQ9WAqh7aRE5c3UO36GRcDy33LPkdeRmrf8lKeOSk8wWkxwW06Ip7qoRylGJe3e+CMyew9NzzWGxU4/cgQOO6aYOYXuQ3XHCYU/Cq6I15OC4tbZoKGVTUAvYGRzV7KUgXZD7LiYThWyCDqEYGD88zQIASwxw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=QA/UIMng; dkim-atps=neutral; spf=pass (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=QA/UIMng;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hy27V2SRYz2yjp
	for <linux-erofs@lists.ozlabs.org>; Sun, 04 Oct 2026 10:35:01 +1100 (AEDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261003233450euoutp02c1894a969f4aa7dcdc13711324b510bc~bKR8fdgbC2968329683euoutp02C;
	Sat,  3 Oct 2026 23:34:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261003233450euoutp02c1894a969f4aa7dcdc13711324b510bc~bKR8fdgbC2968329683euoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791070490;
	bh=06jrm1eJOKkEfVYjfM8urZVFEtTHJTgdf4MXi9Zr75I=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=QA/UIMngsEzopfyR2oMgeAvIpsxY8XFVWR6aszTu2KASkTE9HgfdfrEoibwj1+Ish
	 q+q0jX7mWyllAGunxNTWrLk9JIZLUZdZDUhz/mwcYRQDpGduTJEE52K7M5/4/L7CfC
	 t/2nqVLqsIrV+xGRicpyEUeoh56qvM0ZzTVHWVaE=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261003233448eucas1p1a273f9ebf3e825f88405f45e28ff1fc6~bKR66LqvF0047100471eucas1p1Z;
	Sat,  3 Oct 2026 23:34:48 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261003233446eusmtip1e9b417cfe901275fcda452a3fc458927~bKR5M2kGA1826618266eusmtip1H;
	Sat,  3 Oct 2026 23:34:46 +0000 (GMT)
Message-ID: <34143c5f-5b1c-4ae2-90e7-d999d10b73cf@samsung.com>
Date: Sun, 4 Oct 2026 01:34:46 +0200
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
Subject: Re: [PATCH RFC 1/9] lib/lz4: import upstream LZ4 sources verbatim
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
	<ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
	<justinstitt@google.com>, Russell King <linux@armlinux.org.uk>, Thomas
	Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Heiko
	Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
	Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>, Jens
	Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, Phillip Lougher <phillip@squashfs.org.uk>,
	Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <arnosKlQYVIdmTR7@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261003233448eucas1p1a273f9ebf3e825f88405f45e28ff1fc6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a
X-EPHeader: CA
X-CMS-RootMailID: 20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a@eucas1p1.samsung.com>
	<20260925-lz4-vendor-upstream-v1-1-1c7ffbe21c4b@samsung.com>
	<arnosKlQYVIdmTR7@google.com>



On 9/28/26 06:12, Sergey Senozhatsky wrote:
> On (26/09/25 13:27), Michal Wilczynski wrote:
> [..]
>> +#ifndef LZ4_FAST_DEC_LOOP
>> +#  if defined __i386__ || defined _M_IX86 || defined __x86_64__ || defined _M_X64
>> +#    define LZ4_FAST_DEC_LOOP 1
>> +#  elif defined(__aarch64__) && defined(__APPLE__)
>> +#    define LZ4_FAST_DEC_LOOP 1
>> +#  elif defined(__aarch64__) && !defined(__clang__)
>> +     /* On non-Apple aarch64, we disable this optimization for clang because
>> +      * on certain mobile chipsets, performance is reduced with clang. For
>> +      * more information refer to https://protect2.fireeye.com/v1/url?k=e59d343e-8402d40e-e59cbf71-000babe403ab-24cad800d51083a3&q=1&e=1265adcb-d286-42f9-9d57-b9b998ba2ed0&u=https%3A%2F%2Fgithub.com%2Flz4%2Flz4%2Fpull%2F707 */
>> +#    define LZ4_FAST_DEC_LOOP 1
>> +#  else
>> +#    define LZ4_FAST_DEC_LOOP 0
>> +#  endif
>> +#endif
> 
> I just checked https://protect2.fireeye.com/v1/url?k=f36de8be-92f2088e-f36c63f1-000babe403ab-1972efa3caab0762&q=1&e=1265adcb-d286-42f9-9d57-b9b998ba2ed0&u=https%3A%2F%2Fgithub.com%2Flz4%2Flz4%2Fpull%2F707 and it seems that
> LZ4_FAST_DEC_LOOP is enabled on aarch64 now, but we still disable it.
> Am I missing something?
> 

You're right for clang builds. v1.10.0 enables the fast loop on aarch64
only with GCC clang has been excluded since PR you mentioned. Upstream
has since changed that neither of those commits is released yet:

0aa33884faf5 ("[LZ4] Limit disabling LZ4_FAST_DEC_LOOP to
aarch64+clang+android")

ed86bc1ed802 ("AArch64: Enable LZ4_FAST_DEC_LOOP for Android")


The first is already enough for the kernel.

For v2 I'll backport both commits into the vendored lz4.c the same
way patch 2 backports 5ef1f16929b5. They apply cleanly in order and
give exactly upstream's current condition, and they go away at the next
resync.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>

