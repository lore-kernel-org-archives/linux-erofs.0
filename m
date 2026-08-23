Return-Path: <linux-erofs+bounces-4289-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92711C5DF8C
	for <linux-erofs@archiver.kernel.org>; Sun, 23 Aug 2026 12:59:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSYz42jRZz2xnQ;
	Sun, 23 Aug 2026 22:59:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787489968;
	cv=none; b=kbyCRvpPo1mbN8zqD4C2xBPdo6gFzcFLIUtA+5FjQCbTx798uwQUBHcyrMy3ZptKufA39tSD+0cNM7KqdO7+3OpbNSMrW0ydvWyTTQWsQgmg+zTMKNaOWfV1rXkSUWY59dMXoHi9gwZ44kL3euZUuWFHSYYV1XPu9fEmMKa8qocXS93RougX9tKh1w1wOGys2QeEn8rk75nFxnzDkwRRrzgkUU9viMoF5ByowMJEDYmg7TnQOtmffyN3Hu9kFtfiAajVT4KqAiB8r1ywHZ9JUmJqPDhEpozpyoaD1mMLjw9ZffuoGvsfnqdg9Rn+c3m3O7b/QmLpBgZHUGGA7Q1g/w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787489968; c=relaxed/relaxed;
	bh=/Ov0tYDbk+TlLDpegxsvuVL0iS6K5D1KA8wlpfKMDCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcgvhf8qKT/6+Ro7ywVaddlqiXsd7Nj0f9737iECfcUjxIoZSaNis2oUbQh8UnW5q/S+hvS4+w4NWgUWNUZEVCVU7el/jRLd8ERqb5M8UXBDW71yc/LtbfjPpvwAbtS2hQJohHYDdNa+mJdVOWN8AR4VG4NlNxufhR08HsAxMuoPB0ZQU2Le4afY76H3hnRbFGx1xbM6jKqNZ/NmjXbkAAEY9XfeZD2mkAN3J8Ns1PQUsdF4A9GL4SLIzdzqz2a1nlamKd0cGRWQN7zQGmFV0NNKzk7fPIrwHZf69+Hn5V3DGvd6vJoVbnpmmkQj6h3xPtifm6E2vSqkj0xTggYHcA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qd+8aTFA; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qd+8aTFA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSYz30Rtsz2xQ7
	for <linux-erofs@lists.ozlabs.org>; Sun, 23 Aug 2026 22:59:26 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFE196001A;
	Sun, 23 Aug 2026 12:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204F71F000E9;
	Sun, 23 Aug 2026 12:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787489963;
	bh=/Ov0tYDbk+TlLDpegxsvuVL0iS6K5D1KA8wlpfKMDCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qd+8aTFAxFf6TM0MMNKwkF4kX+0oloujIuDykTSYZ6Y4I7RfQIukm0vXsEZynbs9l
	 Lukrj1aA6z5AUOMh7QAuRT6lAcn1q8vyFEVvHdpL4Wrfc74TnbElCwhEWd/LFNqbMI
	 rVBk/foTJ7gOCRRDCAx9yVqdTO7F7hCF0EKIWNp8H7CxXggZruluhWvqRSZQyQYpPk
	 ZHRibyN5Grvt10CVT0Pd6+LOnvtTaXedFyBVcNRQXKWc1VWMfRUTmdEm/MaYxFjJd4
	 kWj/e3R5StPnBsU4VhJ5Clap898HvpPUmmk6cKQpPsytHHNBtFypJoUCaNhhd13ZoE
	 OU9rezcv/WqQQ==
Date: Sun, 23 Aug 2026 20:59:15 +0800
From: Gao Xiang <xiang@kernel.org>
To: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
Cc: xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] erofs: skip sufficiently large global buffers when
 resizing
Message-ID: <aoruo-aVZ0IHJ58G@XiangdeMacBook-Pro.local>
Mail-Followup-To: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
References: <20260822140017.8119-1-nikhilgurudasani314@gmail.com>
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
In-Reply-To: <20260822140017.8119-1-nikhilgurudasani314@gmail.com>

On Sat, Aug 22, 2026 at 07:30:17PM +0530, Nikhil Gurudasani wrote:
> z_erofs_gbuf_nrpages is advanced only after every global buffer has been
> grown. If a resize fails after some buffers were enlarged, a retry
> revisits those enlarged buffers.
> 
> Retrying the same size then returns -ENOMEM because alloc_pages_bulk()
> has no pages to add and the unchanged return value is treated as a
> failure. Retrying an intermediate size allocates a temporary pointer
> array smaller than gbuf->nrpages and copies more existing pointers than
> the array can hold.
> 
> Skip buffers that already satisfy the request. Once all remaining
> buffers have caught up, advancing z_erofs_gbuf_nrpages again describes
> the guaranteed minimum size across the pool.
> 
> Fixes: d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
> Cc: stable@vger.kernel.org # 6.10+
> Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

