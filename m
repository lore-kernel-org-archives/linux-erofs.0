Return-Path: <linux-erofs+bounces-4670-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 656B3CA6007
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 15:25:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0H4W2ZbXz30HB;
	Thu, 08 Oct 2026 02:25:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791386715;
	cv=none; b=hOcoMscF4d0mztqprGJubbvoeye3ddW+RH8qMKEvPKkYn1I9SNHK2g4IfhKM+GqNQGlUp9q5zjUtTIbz4Khz5MrVSbNenTNqx+I3tOIZcDiAbnBOuclQq8OQOxczOamiq39/vRbaPojX/BwQqcqQSyR8fjoqbEGkuBV+qnPpE2P0P8/5zQFrZPqIPJ70zXOmz1BVmISwNh2ZjJ/HE3xx+xk3eHKMavODYrseloG/xzY/lDKOb3n7770P8lqFn5HaVSU+oAEeNtc2q9KA6JdPNc2KO2Keu9zP2p6yAoAtaHiwmvll7Uj8VGix10HZlu4unmQhNcroaaLyDL2BT78Zww==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791386715; c=relaxed/relaxed;
	bh=riVmWw59znixSjld9DzTbi8F/0EQ8yuZ4B1Rmgx1SSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNWNRa5sNMmhZ2DI9sw2tBLvoJ5H59AU6cPEIpvpPYabQmEZ+h9ZnXrNWmgrlB2xsC3q1DyGB3ZGGIMUY2WrlRSm/tni7m9Qgta6LQ7/Ny30PUmq8y4RC7YGr2UaZ3orSuRythImOFlw5YL3GYaDO7t18uiYLrQc+/MN1l2tj2Cy33gVGY9pM+pdXove7eIjzziN5NFusgkFQHAZXtVYv50FvgvvSUI4MXvpbHSz4U4nUvAwB53K6wSDeQInxn810X2QTguuM8rVSoY61A+U08By73X2ljLcNxPpt0CC0hmEL5zVrccqPfk7F4dquf8tzzfCkkbbeAHLbLI3ck5g5A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vq1jobUL; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vq1jobUL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0H4V3nYkz2yYd
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 02:25:14 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDF64402B9;
	Wed,  7 Oct 2026 15:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661EB1F000FF;
	Wed,  7 Oct 2026 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791386711;
	bh=riVmWw59znixSjld9DzTbi8F/0EQ8yuZ4B1Rmgx1SSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vq1jobULzuNxaO0Xu57clFM0xKN2LJ+oT1BZrVO7CnOmofWlbZhN62RAIflW1m6tV
	 tRETDslfPVM58bzVoarRD3xWzzZpBRxRv6TLAnCuf5ivIo+Gku3bk1wRg5HEFaZmJs
	 UMriTP2ZmmJji1bNXafsRdeZef5Xt6MLqpLbHicQoxkqCFqbAEXAjZkqFtm9oE9wiE
	 4akVAGs+wZ6JQ2qcn+8VVY31BmjGttL06WSDnZI4dER7N/pcY7+UCCA9H0dzrPcAg+
	 Rk17iNZ79kZ37+abU7wMSDUgYp8vxibqwrmtjfiRFBdlir+wDPj0xal7UOecF9WvWi
	 wGUDYvGu8iVnA==
Date: Wed, 7 Oct 2026 17:25:06 +0200
From: Gao Xiang <xiang@kernel.org>
To: peacherwu <peacherwu969@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com,
	chao@kernel.org, Kelvin Zhang <zhangkelvin@google.com>
Subject: Re: [RFC] AceDelta: OTA delta for EROFS images, 30-40% smaller than
 AOSP 17 delta_generator
Message-ID: <asZkUv1TfTfWG0a8@MacBookPro>
Mail-Followup-To: peacherwu <peacherwu969@gmail.com>,
	linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com,
	chao@kernel.org, Kelvin Zhang <zhangkelvin@google.com>
References: <CAOisCUPoZyE7TBoEW_O=06cJSCrMZSzBEzLaKMRKtvffB3pqdw@mail.gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOisCUPoZyE7TBoEW_O=06cJSCrMZSzBEzLaKMRKtvffB3pqdw@mail.gmail.com>

Hi,

(+cc Kelvin on this topic)

On Wed, Oct 07, 2026 at 10:58:10PM +0800, peacherwu wrote:
> Hi,
> 
> I'd like to share results of an alternative OTA delta generator/applier
> for EROFS partition images.
> 
> AceDelta diffs whole EROFS partitions (system, vendor, odm, my_* etc.) at
> file level, recompressing lz4 clusters on apply. Compared with AOSP 17
> delta_generator (minor_version 10, -enable_lz4diff)
> on seven real consecutive-build pairs from five phones:
> 
>   Device / builds                    AOSP MB  AceDelta MB  Reduction
>   OnePlus 15      A.22 -> A.27        1152.6      683.7      40.7%
>   OPPO Find X8 Pro C.76 -> C.79       1059.1      733.1      30.8%
>   Xiaomi 15 Pro   2.0.105 -> 2.0.214  1038.6      655.6      36.9%
>   Xiaomi 15 Pro   3.0.3 -> 3.0.7       833.4      490.4      41.2%
>   Xiaomi 15 Pro   2.0.214 -> 3.0.3    2657.9     1685.8      36.6%
>   Nubia Z80 Ultra 16.0.12 -> 16.0.16   767.9      514.7      33.0%
>   Realme GT8 Pro  A.68 -> A.71        1268.9      878.1      30.8%
> 
> Generation is ~2.5x faster than delta_generator; apply time (on PC) is
> about the same (single-thread 8% slower, multi-thread 20% faster using more
> RAM). Hash tree and FEC are
> regenerated at apply time by my own implementations. Detailed info, plus
> Linux evaluation binaries:
> 
>   https://github.com/peacherwu969/acedelta

That is a great effort. If you're interested, you could seek
Google Android staffs and see if they are interested.

> 
> A question for EROFS people. Both AOSP (lz4diff) and AceDelta must
> reproduce the lz4 compression exactly; mismatches are patched with small
> fixups. Although AceDelta is doing better than AOSP in fixup sizes through
> lots of experiments, it's still like shooting in the dark. Is there a more
> systematic way that ensures exactness?

I'm not sure if it has a better approach since it relies on a strict
compressed data reproducibility of the compressor.)

> 
> Is there an EROFS WeChat group I could join?

I will message you my own WeChat number privately since I tend to
avoid leaking my contact info publicly.

Thanks,
Gao Xiang

> 
> Thanks,
> --Peacher

