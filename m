Return-Path: <linux-erofs+bounces-4401-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82706C61DD3
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Sep 2026 07:33:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYyJJ6CLfz2y2S;
	Tue, 01 Sep 2026 17:33:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788247984;
	cv=none; b=lQoLGKTudwOmv5y+r19pCszi1LsaYQKB+sehfJq6mwjApxKkXU2LZ867ztnAwTjywl8J1njwiRyDR+ya/0FXK2ekU/ekjWWlWGYsbX0UF4UMwsNlInrRlqpkZawcdvgTplpaYyKaQvUxqcOKvClhA3WxX2P8gcWU72fUXTRgYqqtrYfNUwimefRtRj72TD4xi1kpyUaHdKrUmMf+XkkDvkv7+6hgJlLPLg9L+1NzKB55Vd1u4788bld0hUdBVJH8BrOEYnjT9vSghqn7dkguArjURj+4PhKJn4LlBaXXIyBkmXqO+AjpEgXnPyCOmXBxaquH8MTkyZ3iy6hwn2iRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788247984; c=relaxed/relaxed;
	bh=dvXB6JlFJ7X9cDLh9nu97HQ3RuIBY4MfLc0NAOT+UXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqWY4qc9etsjN/03uXWgfohHhKo8+tJdmhPFhhYDrCPRJldQQGhPdIayRse62yv7B/rslmeM8q+pcjA5THSvvvwpJq7sqc0GPbWZQlC7BzTKJcO4zGgM3/xVCMfHKiNB12itjduiO3vRORjI8h8C0HZY+yIoOp8WAMCrsRYL8fzAhMjcaMsvp67m/MiORba1Q1wohCP8w6ZIgcHmBV+/lQSsMCWaYC/90Ws8rG1tT7GRFzLmA8oh/xTXWYhYB55lC2MQEwAnLbsg1ZaoL7oJuPAjixiT+6w7QlQpuQx4pUmSTerXSTuTv1LvR/UpnqOSjPPDEJA8nkGfFWZMtDz+TQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7/cGw2X; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7/cGw2X;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYyJH6sBRz2y2P
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 17:33:03 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB5F7600D1;
	Tue,  1 Sep 2026 07:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160FB1F000E9;
	Tue,  1 Sep 2026 07:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788247980;
	bh=dvXB6JlFJ7X9cDLh9nu97HQ3RuIBY4MfLc0NAOT+UXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c7/cGw2XQNGsiIXqkgdTeFyQNQ60PhocbgoSrLF3JwD1G3esYuminR/vw9PatwZsf
	 FoXJOOazky/fOX9+xbD4LrdZfMqIzvDj851UDsexdzGt5wGGdfWzaDydcZg1G4oW+g
	 TYnPF36/8jDnVETfdfpOendapBkVXZptAiW3J4/iqVzOmU0d+6tfn7euWIqa/OCd6N
	 Kxqa3idA3K7tKYJ2R50kEFvVF/AAjyo4a/UhVdJDZidnEOGX9llb9iRPf+nD/wuxRq
	 AcQ4xHx1BB0JPEIpgH1c6dfXBqxjqnVdHj6z3GJommJaVbAe4NQoEU7EcB545AWAWF
	 +qtWTD6J9NTxw==
Date: Tue, 1 Sep 2026 15:32:42 +0800
From: Gao Xiang <xiang@kernel.org>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] erofs: add sysfs feature entry for xattr prefixes
Message-ID: <apZ_msfJd-XscfnG@XiangdeMacBook-Pro.local>
Mail-Followup-To: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260901062243.109172-1-jefflexu@linux.alibaba.com>
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
In-Reply-To: <20260901062243.109172-1-jefflexu@linux.alibaba.com>

On Tue, Sep 01, 2026 at 02:22:43PM +0800, Jingbo Xu wrote:
> Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
> supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.
> 
> Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
> Cc: <stable@vger.kernel.org> # 6.4+
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

