Return-Path: <linux-erofs+bounces-4536-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45255C79FA1
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 04:22:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh1cB4PRcz2y2b;
	Fri, 11 Sep 2026 14:22:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789100570;
	cv=none; b=nEo1pObAAO4/yzzGA2bhbw/ZlKQbl6kxpAPh9qpaiVr/u4J+xWy2oFjn6ezY8EVq5ZfOelSKzmkHBYpl/QfPubAb0d/JF4rITcl/xwZAkIqaysy3FbXEewJOhAn+tQ0CzwY0kJyVGI2OaO2y9t6RScrL/b8MpdJ9Dz7mzvr1JfGxrr3agEw1/KyFnNWSI3NdD/flChExJqbyEcSFtG8X6mGqgm8rhy0er3jsidSjFosX2W9OlTKv3H6dC8BRLLzKsURVWjmPj5H3DDYEI7YAi9Np5HyoqdkkZgr3yWhg0P1/VsWzrGC/iRrccx43byJy4NmD9Fjrd4cdMuSt2hms/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789100570; c=relaxed/relaxed;
	bh=ebCesLcNaD3EI5S5Z4wZ6FRAvX10PMVJuluVaZzZqzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxoHt2bnaL2bHrlpDMn4R6aC19r7YymF/T3vSIQ1qm019bR0kOUeqZI6X6UxPOMA6Xlh8EQdh9ft77zprwujZWqXBK8Ee2+fcmoykr2tifTDbhOlRT0AuAXb1jUUwrcWNtV7PNCACq2uUfAFURx4/MZuhKtG0LnF3Lrpk/o739oAoVMCpP9J2XDGtAL7xlj6AGPJazh2Vnc3zDoPhrg/iuW3zhlTt1D/sGCSp7pQRXnSMz4wjfmcEqUdwPHXvY9VCBQ+mLjibXmc9EuExctoHWapNkhN8U7Czdy15/mS5MXwYt2WeOkKigEUwXXg0XaFiieo0AxIgXTGOGEpkTv9hg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMc0LM4C; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMc0LM4C;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh1c96kbwz2xRs
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 14:22:49 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0133601EF;
	Fri, 11 Sep 2026 04:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB5B1F000FF;
	Fri, 11 Sep 2026 04:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789100567;
	bh=ebCesLcNaD3EI5S5Z4wZ6FRAvX10PMVJuluVaZzZqzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TMc0LM4Cuh/MKjU2F2xFgT+SL4CG9nS+xH528hkR3jnHAM2sy3CMcNvEl/qMq5Z/b
	 77vd1EWCyLeIXeBvf0x8r5clTxscsk8f8yYxS5rpt9p5NTmsXH/OTANv1FDb1zxIXB
	 qnwaji31H6Xb10qmaF6WZDwEtH1t63VH4tovq+BuqJRgOfgNZSgFF4XN6d9cN3Izq5
	 JDRbet6pMUpEtQX2PPxDMm9JUSp7/LX3x/nw7biNIfXn07RSDs+i/LdJXZEYL+YDsr
	 qfQKWITRVXgCziGS4I0L6exMOJ5wG7/PSu9yKcv5GpwL/otMat/qWVqmnce8EeQ7hb
	 wNHGTd5vUTdjg==
Date: Fri, 11 Sep 2026 12:22:40 +0800
From: Gao Xiang <xiang@kernel.org>
To: binglei wang <l3b2w1@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org,
	shengyong1@xiaomi.com, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com, wangshuai12@xiaomi.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
Message-ID: <aqOCEK8T209eXwnW@XiangdeMacBook-Pro.local>
Mail-Followup-To: binglei wang <l3b2w1@gmail.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org,
	shengyong1@xiaomi.com, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com, wangshuai12@xiaomi.com,
	linux-kernel@vger.kernel.org
References: <CAJ3C4Kwms2my+y_T0Mx+XM_gb9gs7cVZ7w4v2GRAURF1rRFU0g@mail.gmail.com>
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
In-Reply-To: <CAJ3C4Kwms2my+y_T0Mx+XM_gb9gs7cVZ7w4v2GRAURF1rRFU0g@mail.gmail.com>

Hi,

On Fri, Sep 11, 2026 at 12:16:56PM +0800, binglei wang wrote:
> erofs_bread() locates the target folio with
> 
>  index = (buf->off + offset) >> PAGE_SHIFT;
> 
> but computes the in-folio offset without taking buf->off into account:
> 
>  return buf->base + (offset & ~PAGE_MASK);
> 
> If buf->off is not page-aligned, the returned pointer misses the in-page
> component of buf->off, so callers end up fetching data from a wrong
> offset.
> 
> buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff can
> be specified via the "fsoffset=" mount option, which only requires
> block-size alignment. Therefore, on an image with a sub-page block size
> (e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issue,
> since 512 is a multiple of the block size but not of PAGE_SIZE.
> 
> It can be reproduced by mounting an image that is placed at a
> non-page-aligned offset:
> 
>  mkfs.erofs -b512 -zlz4hc sub.erofs src/
>  # prepend 512 bytes of padding to the image
>  mount -t erofs -o loop,fsoffset=512 padded.erofs /mnt
> 
> which fails with
> 
>  erofs (device loop0): cannot find valid erofs superblock
> 
> because the on-disk superblock (at offset 1024 within the image, i.e.
> 1536 within the padded file) is read from a wrong in-folio offset. With
> this fixed, the very same image mounts successfully and its file contents
> match those read from the unpadded image.
> 
> Fix it by including buf->off in the in-folio offset calculation, so that
> it is consistent with the folio index calculation.
> 
> Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify
> filesystem offset")
> Cc: <stable@vger.kernel.org> # 6.16+
> Signed-off-by: Binglei Wang <l3b2w1@gmail.com>

As I said, I applied a modified version:
https://lore.kernel.org/r/aqOBLWQEkH7_3LSu@XiangdeMacBook-Pro.local

I think if you have some email client issue, you could loop the patch to
your own email, download it from your mailbox and try to apply locally
for self-testing first.

Thanks,
Gao Xiang

