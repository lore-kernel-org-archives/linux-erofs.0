Return-Path: <linux-erofs+bounces-4752-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F087CCF2D3
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Oct 2026 07:52:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j7SS35J6Dz2yFk;
	Mon, 19 Oct 2026 18:52:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792396323;
	cv=none; b=I71YdAaX0KoIrBfgS6bnrIT7TyC9OYg/pLj/Zb8DjDU3EkHsvAYptEZRNh8lsM54vtVUgdo18p9W89bBNJSCdHe4UP/e3S3W9yZ7aTlfNHhjxrJdF2a0ZRut1siopu7vzjmxuvuLqiBekNFrcgpZ1mh6y7eDyas3LuQnmGtaoPIDwFpIN1C6nbGasCDNYHqTrAgCmIZveZWPsyAx3dOi0AGYRVQSwpU5Wydhn1th5Bmuco3fHeda30wDrDiulf0+6dyE7HWNot8zZ5ZXCZpp3HHfgKw0+jda6BZOtHf4esq3XTu2qCTeloh84jJ+YGrua2hcqYA8TsvF85qb0+jnkA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792396323; c=relaxed/relaxed;
	bh=dLkp+WiPk1R0YL6fbPz37amU1kPYUP1nQKQpPrgnrNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IOQJCppALv/bHrwDpyjakMh0DmEiO9PP2QzcAh4zXsuT+Rxrr5lp2LZecigtK+TGp5TuSZwExv4vAbJ44fxKGv8lA7HbIS5ByHL/wTO6Vue/zBVqT+fVgcOl3ZPATLiCWDEPwljHmgTEL7Pjv0/KweEf5Idg3N8J61q5yjAVqyzXLJ0+EoCAWsXK6bCrkbjDTLfce5r61vYHQNHKMds9aYrXfzTwFVe8BC31NJvkPUX4dOL1SUJLE8o1a3kYr3OK1LcPOcq6p93Cz9ekRz+xdiI165Wzwdsd5Zy/JuYojikMhOpBRc0ZJppYS1Prn96zJfwVFIlyl3ShJoLIHHhm7g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=epL9ySQ0; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=epL9ySQ0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j7SS23mdSz2xjN
	for <linux-erofs@lists.ozlabs.org>; Mon, 19 Oct 2026 18:52:02 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E429241ACC;
	Mon, 19 Oct 2026 07:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FF91F000C4;
	Mon, 19 Oct 2026 07:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792396319;
	bh=dLkp+WiPk1R0YL6fbPz37amU1kPYUP1nQKQpPrgnrNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=epL9ySQ0y8cskw2lwIqBKNJhhTMqFdPQhrevyGicECTrJQRf82Gqvra2GFPSUOCJp
	 KrR62vN0bM7B35KQuWfdtribUM+4ObiqRMf3ykHiK/KidDChjsXQyjwD7HMSfMB3cA
	 had+omkwGpGXxlXTFdTkmxP9eNIibGFci4OqTIwifVS4Pq5lUl17c5mwYcoYgV24k+
	 MrCToGJ0p4yuQXn92jLr/99kJszTjYEUXfmiLkl4NTtJL99z7RZbSwKFvNsJlEM8ly
	 wQkWcPXQ3LMk2OBryPaFdS4zmalTPuX9bRvrmjm+GzP+zogR1dcKFeLxmTHf8safu7
	 Cof1rlj0B3LvA==
Date: Mon, 19 Oct 2026 09:51:51 +0200
From: Gao Xiang <xiang@kernel.org>
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	hsiangkao@linux.alibaba.com, hsiangkao@gmx.com
Subject: Re: [PATCH 0/2] fsck.erofs: implement concurrent extraction and
 decompression
Message-ID: <atXMF9UT1qEpokcz@XiangdeMacBook-Pro.local>
Mail-Followup-To: Nithurshen <nithurshen.dev@gmail.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	hsiangkao@linux.alibaba.com, hsiangkao@gmx.com
References: <20260919151443.29012-1-nithurshen.dev@gmail.com>
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
In-Reply-To: <20260919151443.29012-1-nithurshen.dev@gmail.com>

Hi Nithurshen,

On Sat, Sep 19, 2026 at 08:44:41PM +0530, Nithurshen wrote:
> fsck.erofs currently traverses the filesystem and verifies inodes
> synchronously. While data decompression can be offloaded, large
> CPU-intensive workloads block the main thread, bottlenecking the
> I/O-heavy directory walk. 
> 
> This series resolves thread starvation by decoupling traversal
> producers from decompression consumers.
> 
> Key Changes:
>   1/2 Localizes shared global states (fsckcfg.extract_path,
>       fsckcfg.dirstack) into task payloads and dispatches them to
>       a dedicated traversal worker pool.
> 
>   2/2 Introduces a per-CPU worker pool and asynchronous reading
>       context to batch and offload decompression of files >128KB,
>       utilizing pwrite() for concurrent out-of-order output.
> 
> Benchmark setup:
>   - Test hosts: Acer Nitro 5 (WSL), Raspberry Pi 4, Mac Book Pro M4 Pro
>   - Formats: lz4hc, zstd, lzma; cluster sizes [4096, 8192, 16384, 32768, 65536]
>   - 10 runs per configuration
> 
> Results (best of 10 runs; ST Base = current master, MT Trav = 1/2,
> MT Comb = 1/2 + 2/2; ImpP1 = improvement from 1/2 alone,
> ImpP2 = additional improvement from 2/2, ImpAll = total vs master):
> 
> Minimum Execution Times (Best of 10 runs)
> |Alg  |Clust|ST Base|MT Trav|MT Comb|ImpP1|ImpP2|ImpAll|
> |-----|-----|-------|-------|-------|-----|-----|------|
> |lz4hc| 4096|  3.80s|  2.75s|  2.74s|27.6%| 0.4%| 27.9%|
> |lz4hc| 8192|  3.55s|  2.68s|  2.60s|24.5%| 3.0%| 26.8%|
> |lz4hc|16384|  3.43s|  2.59s|  2.58s|24.5%| 0.4%| 24.8%|
> |lz4hc|32768|  3.52s|  2.57s|  2.44s|27.0%| 5.1%| 30.7%|
> |lz4hc|65536|  3.37s|  2.33s|  2.33s|30.9%| 0.0%| 30.9%|
> |zstd | 4096|  4.33s|  3.00s|  2.86s|30.7%| 4.7%| 33.9%|
> |zstd | 8192|  4.21s|  2.88s|  2.84s|31.6%| 1.4%| 32.5%|
> |zstd |16384|  4.00s|  2.75s|  2.69s|31.2%| 2.2%| 32.8%|
> |zstd |32768|  3.98s|  2.61s|  2.58s|34.4%| 1.1%| 35.2%|
> |zstd |65536|  3.89s|  2.59s|  2.56s|33.4%| 1.2%| 34.2%|
> |lzma | 4096| 51.44s| 33.39s| 14.23s|35.1%|57.4%| 72.3%|
> |lzma | 8192| 61.08s| 42.71s| 15.11s|30.1%|64.6%| 75.3%|
> |lzma |16384| 65.37s| 47.38s| 15.77s|27.5%|66.7%| 75.9%|
> |lzma |32768| 70.51s| 52.73s| 16.44s|25.2%|68.8%| 76.7%|
> |lzma |65536| 76.19s| 58.38s| 17.83s|23.4%|69.5%| 76.6%|
> 
> Mean +/- Standard Deviation (10 runs)
> |Alg  |Clust| ST Base  | MT Trav  | MT Comb  |ImpP1|ImpP2|ImpAll|
> |-----|-----|----------|----------|----------|-----|-----|------|
> |lz4hc| 4096|5.37+/-6.98s|4.21+/-0.99s|3.30+/-0.85s|21.6%|21.6%| 38.5%|
> |lz4hc| 8192|7.42+/-13.7s|3.98+/-0.51s|3.14+/-0.77s|46.4%|21.1%| 57.7%|
> |lz4hc|16384|4.06+/-0.95s|3.27+/-0.86s|3.02+/-0.77s|19.5%| 7.6%| 25.6%|
> |lz4hc|32768|5.33+/-3.29s|2.88+/-0.47s|2.76+/-0.28s|46.0%| 4.2%| 48.2%|
> |lz4hc|65536|4.40+/-2.11s|3.11+/-1.19s|2.65+/-0.56s|29.4%|14.7%| 39.8%|
> |zstd | 4096|5.96+/-3.65s|4.01+/-1.97s|3.08+/-0.36s|32.7%|23.2%| 48.3%|
> |zstd | 8192|4.99+/-2.23s|3.08+/-0.33s|3.03+/-0.16s|38.4%| 1.7%| 39.4%|
> |zstd |16384|5.42+/-4.06s|3.13+/-0.53s|3.03+/-0.46s|42.2%| 3.1%| 44.0%|
> |zstd |32768|5.34+/-3.90s|3.96+/-3.19s|3.05+/-0.52s|25.8%|23.0%| 42.9%|
> |zstd |65536|6.08+/-4.36s|3.86+/-3.24s|2.87+/-0.39s|36.5%|25.6%| 52.8%|
> |lzma | 4096|52.16+/-0.6s|34.38+/-2.1s|16.06+/-3.1s|34.1%|53.3%| 69.2%|
> |lzma | 8192|61.45+/-0.4s|43.34+/-0.9s|15.85+/-0.6s|29.5%|63.4%| 74.2%|
> |lzma |16384|65.69+/-0.5s|47.78+/-0.4s|16.30+/-0.4s|27.3%|65.9%| 75.2%|
> |lzma |32768|70.79+/-0.3s|53.02+/-0.3s|17.15+/-0.4s|25.1%|67.6%| 75.8%|
> |lzma |65536|76.50+/-0.4s|58.71+/-0.3s|18.10+/-0.2s|23.3%|69.2%| 76.3%|
> 
> Summary of Improvements:
> Patch 1/2 alone provides a reliable 24-35% reduction in minimum
> execution times across all tested formats and cluster sizes simply by
> parallelizing the traversal walk. 
> 
> Patch 2/2 targets CPU-heavy decompression, delivering a massive
> secondary impact for LZMA. LZMA extraction drops by a further
> 57-69% on top of patch 1/2, resulting in a 72-76% total execution
> time reduction compared to the current master. Lz4hc and zstd are
> fast enough to bypass the background worker pool, so their ImpP2
> remains negligible, as intended.
> 

Thanks for your efforts on finishing our GSoC project.

I've applied your patches to experimental-mt-extraction, it works, but I
will finalize myself so that it could merge upstream.

Thanks,
Gao Xiang

