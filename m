Return-Path: <linux-erofs+bounces-4657-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2959CA5FE4
	for <linux-erofs@archiver.kernel.org>; Sun,  4 Oct 2026 00:05:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hy2pX3MmSz2yqw;
	Sun, 04 Oct 2026 11:05:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791072324;
	cv=none; b=fziYMjZGuw0+0VW2/bTsISDrefl8Rzj3OyIc3xpCJn9JxjQq+P8tG3wWSNEJq6IAVjOEYmhR0RhgR1JeRsAXnsL4vL4/IT7Ufe71PzmnxYEKK6L3Gc/rM3tonWuAxfYJmubGwyc8GsYZMpfOOLK9cXGJrAu+4mXNYWBvPLMxPbOSISLuv6RduhxhYwVSbw9nXXgu5X5UxOjBfwPDPiuctDFBfBJc+qThOuztvPR8T8RU5aLbB2dymP7fJV2gjHKGhki2yrEVeebVvz/RWPYwlApOI8wEvLHLqRjgqJu3H0GCtsz0Owh/XWhv6OXduU8nHYd6vJn63dC6PghriMlLww==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791072324; c=relaxed/relaxed;
	bh=ZJZTrL5SQnYa6gvVNuN2LjMawlbBBC4EWuE7TxWcKx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=YDNdQ7bAhsYZcSWUbjKUsVj4HaIe7IHjShNIDBqqpczKHUorzafXL/Nbeb/tNc1Q9y7bO9SIaVK+kfBEkX3Wtp3LOvHX0WLc/QuoXXV3yWdLKC7W0uyeB7U5SAPEd3NXcGB6mXdpE/kxHUwi/pqhbF4uoc3B09/wB+UJ4nN2vRQI261q15rUSCX6yaIwWQ2LtPQA/yw0Ygu5icUPWWnD8L5dLitums/VNOuSKlyeB2MSDnrpMft/gBvZ/NknruheaA3Px2XLSSJUq8wyVyxeTFo6AvqEtCwpeRI6Osk5Fg0aczO1T21SECv205v4yheAUVSmJ2f75HkXi0Fx8Oy7Jg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=KFP5LNkz; dkim-atps=neutral; spf=pass (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=KFP5LNkz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hy2pT5c9gz2yjp
	for <linux-erofs@lists.ozlabs.org>; Sun, 04 Oct 2026 11:05:20 +1100 (AEDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261004000510euoutp013ee4f267ec7b07e822726f0b5d88d0fa~bKsbKQ__B2163921639euoutp01V;
	Sun,  4 Oct 2026 00:05:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261004000510euoutp013ee4f267ec7b07e822726f0b5d88d0fa~bKsbKQ__B2163921639euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791072310;
	bh=ZJZTrL5SQnYa6gvVNuN2LjMawlbBBC4EWuE7TxWcKx8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=KFP5LNkza8OoBtj5HTuawzDRYYYBZ/WrfFMAfjXatZRd5ZwpmRtkrpGNteNnFAcFW
	 a+pvo77kefjxlg+J0Kbo3aGXfUJFkeO4mBIkzt4cVg0+G6B7j2sqT1cGqS4uI3Kd2H
	 +7VeWQwlvnZ97NOV2yx7DRYeXvD3SKk6JpL6yeyc=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261004000509eucas1p12b906a44a576ad1b1bf6f8099f081cdd~bKsaNgMf72285022850eucas1p1h;
	Sun,  4 Oct 2026 00:05:09 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261004000507eusmtip2934e51491ae1d0ccbd9db1e873d1df61~bKsYgse7o0742707427eusmtip2n;
	Sun,  4 Oct 2026 00:05:07 +0000 (GMT)
Message-ID: <ff30763b-d39b-450f-82ef-cba10d221ae6@samsung.com>
Date: Sun, 4 Oct 2026 02:05:06 +0200
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
Subject: Re: [PATCH RFC 3/9] lib/lz4: add the build environment for the
 vendored sources
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
In-Reply-To: <arn9tK5MxxxfH7OW@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261004000509eucas1p12b906a44a576ad1b1bf6f8099f081cdd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113456eucas1p136c3cd1f08be7201ad6b3f7b0e8ff02d
X-EPHeader: CA
X-CMS-RootMailID: 20260925113456eucas1p136c3cd1f08be7201ad6b3f7b0e8ff02d
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113456eucas1p136c3cd1f08be7201ad6b3f7b0e8ff02d@eucas1p1.samsung.com>
	<20260925-lz4-vendor-upstream-v1-3-1c7ffbe21c4b@samsung.com>
	<arn9tK5MxxxfH7OW@google.com>



On 9/28/26 07:48, Sergey Senozhatsky wrote:
> On (26/09/25 13:27), Michal Wilczynski wrote:
> [..]
>> +
>> +/* LZ4_decompress_fast() and LZ4_resetStream() are still kernel API. */
>> +#define LZ4_DISABLE_DEPRECATE_WARNINGS 1
> 
> Is this upstream code?  As far as I understand it, LZ4_decompress_fast*()
> deprecated upstream and are strongly discouraged.  Do we want to suppress
> deprecation warnings?
> 

It's ours lz4_deps.h but upstream's lz4.c sets the same switch for
itself lz4.c, since its own code calls deprecated functions. We
include lz4.h before lz4.c, so we have to set it first.

I agree on the direction. The only in-tree _fast() user is the pre boot
path of lib/decompress_unlz4.c, so as a follow-up I'd move it to
LZ4_decompress_safe_partial() and drop the three _fast exports.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>

