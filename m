Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829A6606A327
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nR+r+VBD
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQJz951x6z2xmV;
	Thu, 12 Nov 2026 23:07:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794485221;
	cv=none; b=ADg/8fDEyIOL2CAudAISdQI6ar19cYqPfc9uW7J7DS9hk8x+oK1EMv2MBXB9IQ0yg61rQAd2rW0KqQQYjQghffU3po4cWteN+BQJAKSMAoQnQw75opjHyv58m2QbTSiAxgm4uYvkiQ+sbfMootSYBapM2mDP2GEu0Ar3JVtgw6C+Qo0yeGCnFQPN+CSw6YXbpzCHr6I4prkbMN5O5txSK5r1wV8pkJ8VRE+OxW3haA0qu7Wb4qAt3lJDFkhNa11bCWVouoTB80FuHsDUR6UbvIX/H7/hmaoydxl07bHOP8f+h/jwFGu11fJDQ49YFNEGPf40YkJZ0AK2oisR/FAEyg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794485221; c=relaxed/relaxed;
	bh=3Ng2wYSW6+d3+F9nDyhML8DvJgaVLNMXoO8xfsPtTcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Lp+T1WjQsYUF6ECqMH+0rTCl53e4avYz7WZMt1VCRwSxPqX0BCcfav/6+aKrXdOU0cuZI7VYXM4GQhmFI6xv6PjuqmBkXMTMQVdMgjS/WZ105K5tucm19U8VatKI+LqGFPjTGM54TQ2w3O1XPToVWSIpu4JcYXNfi1emSLZrbNyWjZU1Nf9Te4Z1yxYvFtmRY6oWLfVgX2kwao/oSsgH3SAGxSvo02YE+1eqoGkpVfOVfUDRI9whnaHPKEkogPgOBskXTkDYFxyLFh17vgfb2T+pv5vke47YOkqdyv2BMQKaAsO8ljxBBrLWOFSeLo9LgXDX8znJZ1JFpQKxrTBxbA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nR+r+VBD; dkim-atps=neutral; spf=pass (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nR+r+VBD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQJz84YxYz2xWt
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:07:00 +1100 (AEDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261112120650euoutp023394506fcbdf2a5d3fc56ab466d5f422~nSsqNDOqh0675106751euoutp02X;
	Thu, 12 Nov 2026 12:06:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261112120650euoutp023394506fcbdf2a5d3fc56ab466d5f422~nSsqNDOqh0675106751euoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794485210;
	bh=3Ng2wYSW6+d3+F9nDyhML8DvJgaVLNMXoO8xfsPtTcI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=nR+r+VBDOV4dVPVZ6tVQVAV+2ufcN1J8T2VQozNQKBTjeh1k71ccWpdHsHNgI8C7r
	 CM7J2sePfPZZOiXnXMfytIDh2ES0EF9kB9rcJXE5tsaTcDudkOHHpGSzUVEgKo5+QX
	 Epi4ngn19K3aDJSY4rfpKYKsTXWEmx79MdJPM+6M=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261112120649eucas1p2065df671e614cc14e86e0a5504215744~nSspZAxiA2721327213eucas1p2v;
	Thu, 12 Nov 2026 12:06:49 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261112120647eusmtip1e71d40cb998922386d7f896a16ce37a9~nSsnwl8x91412914129eusmtip15;
	Thu, 12 Nov 2026 12:06:47 +0000 (GMT)
Message-ID: <450cbb3b-6118-4b1d-9a71-7f0ea98030ed@samsung.com>
Date: Thu, 12 Nov 2026 13:06:47 +0100
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
Subject: Re: [PATCH v2 13/15] lib/lz4: switch the decompressor to the
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
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, David
	Laight <david.laight.linux@gmail.com>, Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <avKtyCOOmK3AH0xy@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261112120649eucas1p2065df671e614cc14e86e0a5504215744
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94
X-EPHeader: CA
X-CMS-RootMailID: 20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94@eucas1p1.samsung.com>
	<20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>
	<avKtyCOOmK3AH0xy@google.com>
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/26 06:39, Sergey Senozhatsky wrote:
> On (26/11/06 15:42), Michal Wilczynski wrote:
> [..]
>> diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
>> index 50265e3ce256490994cb6dae32a45da376e408e0..b9b8a5f678c155442fa3fd2c1984e45182e6fc38 100644
>> --- a/drivers/block/zram/backend_lz4.c
>> +++ b/drivers/block/zram/backend_lz4.c
>> @@ -84,7 +84,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>>  		if (!zctx->mem)
>>  			goto error;
>>  	} else {
>> -		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
>> +		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
>>  		if (!zctx->dstrm)
>>  			goto error;
>>  
>> diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
>> index e7ee3740219852f079d1e0866da6b213a3f3a583..1e09c93016264259c149e2913b2819571b56fab6 100644
>> --- a/drivers/block/zram/backend_lz4hc.c
>> +++ b/drivers/block/zram/backend_lz4hc.c
>> @@ -65,7 +65,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>>  		if (!zctx->mem)
>>  			goto error;
>>  	} else {
>> -		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
>> +		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
>>  		if (!zctx->dstrm)
>>  			goto error;
> 
> Ditto, outdated zram code.
> 
> My ask would be to not squash zram changes with lz4 changes, when (iff)
> possible.
> 

Will do.
The zram changes will go into a separate zram patch ahead of the lib/lz4
ones.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>

