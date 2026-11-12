Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5854606B357
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 11:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=AvhYjNqW
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQJ3t1S7sz2ynW;
	Thu, 12 Nov 2026 22:26:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794482762;
	cv=none; b=Se1ieYop0Nb6AwTRbe9iIE7JoEg4pO2Ah3RAK3cjAdSfFv96FkoIL6Haf7ZNUWiOLPam1YPhjmXBYYNKAPx5f7+Jx9/E7+kzP7qw668aCdF3IZSj2nXPGaQlRY+rrG84keMsOgK7WhlEyitmi3Arotzhz7c0rwCcdnIsWwJNiiG/Nr77tFqAQH+muCCPqR/nhlYbNEUwTKuQZM9v7T6I6eSkvexBFkWJ50+mFUQOg7IcRAcfZSke+NBAHSX+igKSuuurD4KeNoVlM1Xbv04/xrbuRV9egZ3UC67//uCCR+FVV4JTpFCyvV8V6IwUJeSq/qpMN2/r3v6HUE1TLIIChw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794482762; c=relaxed/relaxed;
	bh=ipHsKGzdySUFK43kUSa1EUse/xjwdqGzCAkyYU+4IsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=cgehEmmqmsRqD/CwMvKf21969n1DqIriMh8V4X1dSqHURmRgB+fZNu5EMehye1gGWXe0l0IpRYFr4psIlSZoos9WXDdwe+eQuKR4x0vHHhbvKzpHSu2z1Fs/7ULJu8XgWLKLjxyOnSlJZFQnk9HMzU9JmMrKjjeAa3iUHEmOPp2fLWC0x/TtZQdfn5GSHZN0ksKFavd6neHykOey7cxKHlBvEgG7Y2wZtstuVUyFqRjaa15eqTozW2jb3RzFTSCcMl03tjDTMVCe3/hdyzgB77EfhWhziEvWSgDmANTs1Xyua6OBA90NxmESsK1iGQDURDCBZ/0HPHmSx6rztuuitA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=AvhYjNqW; dkim-atps=neutral; spf=pass (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=AvhYjNqW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQJ3p4zyzz2xJT
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 22:25:56 +1100 (AEDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261112112543euoutp010f016eb7fa47ed13835ab3afff799d5d~nSIxA7B940644806448euoutp01J;
	Thu, 12 Nov 2026 11:25:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261112112543euoutp010f016eb7fa47ed13835ab3afff799d5d~nSIxA7B940644806448euoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794482743;
	bh=ipHsKGzdySUFK43kUSa1EUse/xjwdqGzCAkyYU+4IsQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=AvhYjNqWqGDSDWciDHfOXU3HOJjD8I0PqyiBFvEino+CXJ/Ts8YCaLP0CTP7r83SV
	 D0u2NoLv9bExEfdz3CuNTS48kAhibm5QmC2eYY3NRLEJ1vo1+7ksYjGgKf8B93b7Ln
	 eIdw+0vhCIWca8FGDq/+owQFBplfxnoB2Ht47E5M=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261112112543eucas1p2f3aa7565474df56edb967cbecfd1858d~nSIwwzSqJ0570005700eucas1p2G;
	Thu, 12 Nov 2026 11:25:43 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261112112540eusmtip2793b80df566384250842db8b2aa8054b~nSIuZrphA1705017050eusmtip2o;
	Thu, 12 Nov 2026 11:25:40 +0000 (GMT)
Message-ID: <feca1837-fb17-4d96-b6d9-7e5d413ef222@samsung.com>
Date: Thu, 12 Nov 2026 12:25:40 +0100
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/15] lib/lz4: stop forking upstream LZ4, vendor it
 instead
To: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
	<ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
	<justinstitt@google.com>, Russell King <linux@armlinux.org.uk>, Thomas
	Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, Heiko
	Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
	Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>, Sergey
	Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, Andrew
	Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, David
	Laight <david.laight.linux@gmail.com>, Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261112112543eucas1p2f3aa7565474df56edb967cbecfd1858d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144247eucas1p15bdd0704f32d1cb3b19f9d2296a0cbc3
X-EPHeader: CA
X-CMS-RootMailID: 20261106144247eucas1p15bdd0704f32d1cb3b19f9d2296a0cbc3
References: <CGME20261106144247eucas1p15bdd0704f32d1cb3b19f9d2296a0cbc3@eucas1p1.samsung.com>
	<20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everyone,

On 11/6/26 15:42, Michal Wilczynski wrote:
> 
> The import is the v1.10.0 release tag.

It appears v1.11.0, followed by v1.11.1 were released in the
meantime. The next revision of this patchset will import from the
v1.11.1 release tag to take advantage of the newest code. It already
contains the backported commits so I will drop the backports.

I will redo all the measurements with the newr version for the v3.

> 

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>

