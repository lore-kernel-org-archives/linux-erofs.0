Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172CA606A32E
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=bCSMFy5h
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQJtp4YhBz2xmV;
	Thu, 12 Nov 2026 23:03:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794484994;
	cv=none; b=PfjMB25gMN2z4/CHSUu/sOStLrni1v4iuU0z7JljRlNhQ0i1b0LySc4qkK3edjffTfxEsaWRqh5od5N1TltTs1mJ+01JQxCk94pwbv3UwN0PZjszso/2/ArHam5NdQkBfDdGLY63lX0lnn69eRqzlU5JZ1ajav4/2aTfyma0qneG0eai6KTF6BxXVvzMT9KPIIL4T1Z7A1fcPT7MOCxLJl29i7sQVutm6MlLmzAwsf2VJdfY2mkKYaxKhg21KCBgvyRzX6FkNQXXYiKF/4PP0OfuDVNGr9S3kLYddE6NRys7MIE7MEjvrSqpNoOIPLgyaMRcq6hCXoVu2R17YuLF5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794484994; c=relaxed/relaxed;
	bh=Xw7r6iF+zO8fXkdzLRufgVhinglmDPnuGGdycV+HHa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=A8p1cpjXVkPZwwKGTgZIZyFvZYEbFgIhAwH1wj4tzpDDyOcsLaJMOGGm/8P6tK/qdJuT801pkonEdbXCGyeBpAP2X+MfwMdsr05VsJ1cDxHiJ7f9l7RKhIVhBwsRYgd2wi/cWBSgNcVS/up7Kuy7yt2vADyXssmWIDQg8QhUrzLu/u1uU9J66wZ7RoBuZ0N3Yh5nO+9Gz1L4bEbqlA6Ggkvl2opTXMGKES7uNTf8/FYt8lZmq3mdvR607EdiqlRWo8RR5PEQ+qZu6OD6F3lf0ITuFmigmxH9hTshHfSzI3CSjbSMG4GlflqZjq5G/AtfnYOaWNm7XcMsdn7aOgRKBg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=bCSMFy5h; dkim-atps=neutral; spf=pass (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=bCSMFy5h;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQJtm2gQ3z2xWt
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:03:09 +1100 (AEDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261112120258euoutp01964489faf544bdddd3f3211e2255de7c~nSpSE0Td51139111391euoutp01a;
	Thu, 12 Nov 2026 12:02:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261112120258euoutp01964489faf544bdddd3f3211e2255de7c~nSpSE0Td51139111391euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794484978;
	bh=Xw7r6iF+zO8fXkdzLRufgVhinglmDPnuGGdycV+HHa4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=bCSMFy5h9WR5MXhQfr/yYMe50oNl4ZJ3B9PhLvn3AfoVJ3Uyo+MSQBjlm9BDOqF/s
	 YI8qgTWpK/VpOR25WqLm1BIOQY430YCMn2hX6owWJ0ZuGG39vX4A1Pt/J8PKIj6edQ
	 41nNcZwJxZucP719/0INyVtl5uX7gSp1npjbR8yk=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261112120258eucas1p1c5cb56175a355c1eae521563b7e5958f~nSpR05hFs2595725957eucas1p1w;
	Thu, 12 Nov 2026 12:02:58 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261112120256eusmtip247d84ecda0f477bf594f640a7999ebf7~nSpQMIK460511505115eusmtip2L;
	Thu, 12 Nov 2026 12:02:56 +0000 (GMT)
Message-ID: <46236db8-c386-4db6-a8cd-e08073a5db0a@samsung.com>
Date: Thu, 12 Nov 2026 13:02:55 +0100
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
Subject: Re: [PATCH v2 10/15] lib/lz4: switch the compressor to the vendored
 sources
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
In-Reply-To: <avKs4_S7r6EiUVgC@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261112120258eucas1p1c5cb56175a355c1eae521563b7e5958f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144305eucas1p17b3b27d403dc7d13b85cdd9a4bea83b9
X-EPHeader: CA
X-CMS-RootMailID: 20261106144305eucas1p17b3b27d403dc7d13b85cdd9a4bea83b9
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144305eucas1p17b3b27d403dc7d13b85cdd9a4bea83b9@eucas1p1.samsung.com>
	<20261106-lz4-vendor-upstream-v2-10-ee04c3f0d7dc@samsung.com>
	<avKs4_S7r6EiUVgC@google.com>
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/26 06:36, Sergey Senozhatsky wrote:
> On (26/11/06 15:42), Michal Wilczynski wrote:
> [..]
>> diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
>> index 1e4ad31d39a63f45b3bddd3d8a467d8d7d095beb..50265e3ce256490994cb6dae32a45da376e408e0 100644
>> --- a/drivers/block/zram/backend_lz4.c
>> +++ b/drivers/block/zram/backend_lz4.c
>> @@ -42,7 +42,7 @@ static int lz4_setup_params(struct zcomp_params *params)
>>  	if (!params->dict || !params->dict_sz)
>>  		return 0;
>>  
>> -	dict_stream = kzalloc_obj(*dict_stream);
>> +	dict_stream = kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
>>  	if (!dict_stream)
>>  		return -ENOMEM;
>>  
>> @@ -88,7 +88,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>>  		if (!zctx->dstrm)
>>  			goto error;
>>  
>> -		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
>> +		zctx->cstrm = kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
>>  		if (!zctx->cstrm)
>>  			goto error;
>>  	}
>> @@ -112,7 +112,7 @@ static int lz4_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
>>  					zctx->mem);
>>  	} else {
>>  		/* Cstrm needs to be reset */
>> -		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
>> +		memcpy(zctx->cstrm, params->drv_data, LZ4_MEM_COMPRESS);
>>  		ret = LZ4_compress_fast_continue(zctx->cstrm, req->src,
>>  						 req->dst, req->src_len,
>>  						 req->dst_len, params->level);
> 
> The zram code here is outdated, it has been reworked quite a bit
> (patches are in linux-next and Andrew's trees).
> 

Right, I'll rebase on linux-next.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>

