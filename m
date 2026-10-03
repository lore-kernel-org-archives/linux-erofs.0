Return-Path: <linux-erofs+bounces-4654-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C725CA5FDD
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Oct 2026 23:38:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hy2Cv2TXKz2ypY;
	Sun, 04 Oct 2026 10:38:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791070731;
	cv=none; b=KFDeApAfzgZRD/oRVbGnvN60zFNOpciHZnqj8IWCS4Yzdvl0o6X0sdOO4v+toM4+bHJPlEsbSkVKrXQkBhXUopx7goNda8KAD5K2P+BPnLSe3zvlNJVYomS6pfTi3AB6BK6oy+AnNWy0iITF2E0E1n4Z9t2flEe1yt3TOv1wfgKRZtuz4UB/Uuao6JrSjNmR0uTBmVJ/uu5r9RXzknX3lQCeLpKE2QV5UwaXaC6w0T+AVH9k1LvxGdGevlbberIX9MMZM8MdOVFege2L7LMrb7EvpAGF2LUH8ybx3oJSL5jnz4XI+2BPzi0bMmP5YpfWok1BOeZ3Pf+yh4sLHb7T2g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791070731; c=relaxed/relaxed;
	bh=DCSSTKMktb+HuS50/2vCoVXjx6kQyokLqg66BRCB0B4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=lctpfMB36NqYHoWAKqEAYDd+03hluuwlTzcQg4NDq8Fcjss8UdWpSPThK/93FP5p0G3TtKRxg9aroABbe9k4g7o4ZEIh0PzFUWcSeuNJGb1/4fqdmxVFH5FS230s0eFc1Iuqtrf3qJ9jrrUqO7l1NjZxqQmsl2gYOkgPoP6ZdlwD/9A7kj9oWSg7J6HVKXGeF8rlyu6d2WpqRAhCU0Q/47O0HJ3iucoS225yx3E7jKcTShUl4cQrxlf7ZNonjYOBj18gs/i2l+GhEkCV2W8XI67oMkzNRXDW/W1+RNRHGf9Mb70SqoV5tIR5DCbuTkFf4iLw9w8HmcH9yR1KOi4H2g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=JHm5783m; dkim-atps=neutral; spf=pass (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=JHm5783m;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hy2Ct23Zbz2yjp
	for <linux-erofs@lists.ozlabs.org>; Sun, 04 Oct 2026 10:38:50 +1100 (AEDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261003233839euoutp019b93e0a38d74f7844d866dcf976a036b~bKVRYyCTw2859728597euoutp01F;
	Sat,  3 Oct 2026 23:38:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261003233839euoutp019b93e0a38d74f7844d866dcf976a036b~bKVRYyCTw2859728597euoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791070719;
	bh=DCSSTKMktb+HuS50/2vCoVXjx6kQyokLqg66BRCB0B4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=JHm5783mcsClVTOaAWZXZGUM5Mak3g4ei3h3Phsta5hYe2YrnBr40qBI7wEY0xmvN
	 UMD5Hqg1kFQ/WCC4EuAuxIXk8MsORKJXSu+n5fnbc6nyJUT/p+4BAj2I/JULzrOMYS
	 TIDbvU8ViajQeQ9onvYQmblwNgBjnxB65Btm5B/c=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261003233838eucas1p237c405e495deb98ca1ab7bffb909923a~bKVQa7ruV0031900319eucas1p2V;
	Sat,  3 Oct 2026 23:38:38 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261003233836eusmtip19df22b79e12bcb1dd0f2058e4a99ebb4~bKVO0uuxI2102321023eusmtip1C;
	Sat,  3 Oct 2026 23:38:36 +0000 (GMT)
Message-ID: <d60a30e1-7e9d-4061-a61f-d50909665c19@samsung.com>
Date: Sun, 4 Oct 2026 01:38:36 +0200
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
Subject: Re: [PATCH RFC 7/9] lib/lz4: switch the decompressor to the
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
In-Reply-To: <arnpj53cgDErAQEz@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261003233838eucas1p237c405e495deb98ca1ab7bffb909923a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113504eucas1p25e50de59c02681fc1385220be8acd184
X-EPHeader: CA
X-CMS-RootMailID: 20260925113504eucas1p25e50de59c02681fc1385220be8acd184
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113504eucas1p25e50de59c02681fc1385220be8acd184@eucas1p2.samsung.com>
	<20260925-lz4-vendor-upstream-v1-7-1c7ffbe21c4b@samsung.com>
	<arnpj53cgDErAQEz@google.com>



On 9/28/26 06:16, Sergey Senozhatsky wrote:
> On (26/09/25 13:27), Michal Wilczynski wrote:
> [..]
>> -static FORCE_INLINE int LZ4_decompress_generic(
> [..]
>> -			/* Necessarily EOF when !partialDecoding.
>> -			 * When partialDecoding, it is EOF if we've either
>> -			 * filled the output buffer or
>> -			 * can't proceed with reading an offset for following match.
>> -			 */
>> -			if (!partialDecoding || (cpy == oend) || (ip >= (iend - 2)))
>> -				break;
> 
> Worth noting, these lines are downstream commit eafc0a02391b
> (lz4: fix LZ4_decompress_safe_partial read out of bound).
> 
> Is this intended or are we "loosing" some of the downstream fixes?
> 

Yeah it's intended, eafc0a02391b was itself a backport of upstream
c5d6f8a8be39  which is in v1.9.3 and later; its own commit message links
it. The same check is at lib/lz4/upstream/lz4.c in this series.

And upstream's version also clamps a literal run that would read past
the end of the input, which the backport didn't take.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>

