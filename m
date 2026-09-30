Return-Path: <linux-erofs+bounces-4644-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB688CA5FC1
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 20:29:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hw69G2XL3z2yfD;
	Thu, 01 Oct 2026 06:29:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790800194;
	cv=none; b=luAjuYYhX3QdCWrL1b1XESIa1JCbEygXgs7wFq7hbltbeBiN1NTOSHYVi/KedwMs4YVu58reBNfjWal+aC5b2Idj2eia3TG1Da2RjuhiuMCCPPEWW+jKZx8zrZ5Z3Inc6XyVvXDERPcG+zrd+z42sPG8/aSB8bPJ1Xd4wlrX087Igf/ylzZytkkUEc1MASIv5IMnt2rS9PgjbO8xAmjcEPAhYCvpUNCa5qA1q6sTQkH+PRdVwZv3wEHTqdH7vu2PwKs4lpJkAQ41OAZAIYqrfShOiiAfEoyoH6RL+2rhtkF/meWssHML6e1IINBSLpQz5iVg8egZpEdhz6BoaOBZCA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790800194; c=relaxed/relaxed;
	bh=9XDlwyLLM9YlYefYiTsdeeoH+mG0yq0IxsDgsViQ+IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djw2uz9ePShEfXcE9NWeRshnOLYl0t9GGuXgi4bQRRW5ZRTpYKtawLJwrq8W+XCHyfVlxKSUyKWMZp4yt95ct0J74EF152x46bDLnbQUAtWwW1pjH+SG2FdfBtxpq2Ts2Mvzo8CQxYWTMMOWRUqe1s+FCj9Jpu5RaQ6ZfgJprzHzwBWOI1dDBFgMChXI0VcAvmFFk4skLp1kl7JVy64aS6FNafsd99CTReXEGjp9KYW8dCs7OVHRcNwb09yS4noNGGLWjZ675w+BeaGQpnUwcmsl0INYPIyV5sfEPacLxQd0GEtDzcX9C9r3UvglRe07BABXFu45w5iNxEBsd/aRlg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPm4miCd; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPm4miCd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hw69F47LFz2yHT
	for <linux-erofs@lists.ozlabs.org>; Thu, 01 Oct 2026 06:29:53 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCEEF43C7A;
	Wed, 30 Sep 2026 20:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427141F00898;
	Wed, 30 Sep 2026 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790800190;
	bh=9XDlwyLLM9YlYefYiTsdeeoH+mG0yq0IxsDgsViQ+IY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hPm4miCdK5AuCUaM3UCFXuqbCNLS9yo/ZBw/UhrxeHXJOAI/s8Lg+aV/D751zutbh
	 qffXqhh+p+byAzEUWqSFCAL2tL5pvfwopIJfEhkhSO4IcN8A2St59sLpi1qB98k7bT
	 R9vnU7t/OkSc4YY2BdzE1LtrY5y1AiC5533YgLNoGTwRKU4SaxaGIJ8Lb550a7WPMU
	 wkASmmGPbyKw8U2Kz102VGm7MC9dWXd/LjGrX5PSVLXz9XUE/GRU4hHI9EbifsteeL
	 9+VwCQRCZ0ckgYDCJh1YimK848nru9TdwhMbwVniaEIjFxPxj90mPZAFB1iA5pCu8c
	 OsVfx1SHN8Aqw==
Date: Wed, 30 Sep 2026 22:29:45 +0200
From: Gao Xiang <xiang@kernel.org>
To: Binglei Wang <l3b2w1@gmail.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>
Subject: Re: [PATCH v2] erofs: fix folio reuse from a different address_space
 in erofs_bread()
Message-ID: <ar1xOV3x9ZMGx9XY@MacBookPro>
Mail-Followup-To: Binglei Wang <l3b2w1@gmail.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>
References: <ar1GgGSIZ1h0bBip@MacBookPro>
 <20260930191905.539-1-l3b2w1@gmail.com>
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
In-Reply-To: <20260930191905.539-1-l3b2w1@gmail.com>

On Thu, Oct 01, 2026 at 03:19:01AM +0800, Binglei Wang wrote:
> erofs_bread() reuses a cached folio on page index match without
> checking folio->mapping.
> 
> xattr.c calls erofs_init_metabuf() twice on the same buffer without
> erofs_put_metabuf(); the two in_metabox sources differ, so buf->mapping
> can switch while buf->page still belongs to the old address_space.
> The next erofs_bread() then reads the wrong mapping, dropping shared
> xattrs with METABOX.
> 
> We require folio->mapping == buf->mapping in the reuse check; otherwise
> drop the cached folio and re-read via the slow path.
> 
> Fixes: 414091322c63 ("erofs: implement metadata compression")
> Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> Signed-off-by: Binglei Wang <l3b2w1@gmail.com>

I have to tell you that the patch is still broken, and I failed to
apply like this:


Applying: erofs: fix folio reuse from a different address_space in erofs_bread()
Using index info to reconstruct a base tree...
error: patch failed: fs/erofs/data.c:33
error: fs/erofs/data.c: patch does not apply
error: Did you hand edit your patch?
It does not apply to blobs recorded in its index.
Patch failed at 0001 erofs: fix folio reuse from a different address_space in erofs_bread()


Could you just apply locally before sending out a version?
I could make a patch for you manually, but if you apply more patches
later, the broken email client should be fixed.

Thanks,
Gao Xiang

