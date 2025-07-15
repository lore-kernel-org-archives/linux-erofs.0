Return-Path: <linux-erofs+bounces-619-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C56C83F1A
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Jul 2025 02:37:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bh3HJ5yrmz3bwp;
	Tue, 15 Jul 2025 12:37:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=147.75.193.91
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1752547020;
	cv=none; b=Zk+b4Sd4OG0mJ/15lw0vuftQGsVrxOxmNvY7pjJOKWNlAsVzfORQ3Dv3XFjp/rpYqG5kJaODt8jQKLNxCbyY0jbdgAjU5Z6kzxaE6Iyu9wvg6sX0bB3CEDcjoPSGeMBZM6Q6nfbw6C5wBlmiwZTYlwELxmJSY5JwGYFCcGQaHHPkh4eb+8BYJUxiIzL0m3X8yqD84rt/L/rJ5sOn1EwwCfhG+/ga5HX/NrTMpSEpVFLtbKOsoGECl0CtuX2JFo0HL3b/eJEI/Vg3JpoaF44QmjMH3nlrrgtxynzbA9lyG41qZ2QAUZrCKZAXe32bz1JUIZm2Bw8hyraaeMi+xvaN7w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1752547020; c=relaxed/relaxed;
	bh=U/NdrzgyrlEdE2+NBmFHTxuu2zIPoYjGijYMnDwRrqI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ON/aowvN0GWd/RU86uS0DToPOMExW0OL5Gm5a/tEscANibi27WSAyu2fmjiBre6GbOyl2/ZDzDkXZGnxMIe/VBUFOzxeJ1eq8IlGdDsGqBoGFCg4T1IVf2hB2cET/ePGou1/1oqtQBqAAvpvsW3ziWzwEFoM0QD8mtrhzHYHekrmcURr7YtYfpRzSDFdbRd2Vjt/P0A6S94wsYUn8u/uqHAIWWXdWIQ8422WzkfzEw3NwVv6JRwfysdIyLKSAzcNgzVikPkHCAihbg4oUmtuEEnUEuGS38ovN3araoXE9rYSHUcx4vn5LiPU9OQ2BjqETjzNCDHuBHt+d7psNihJyw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ST84jJ2E; dkim-atps=neutral; spf=pass (client-ip=147.75.193.91; helo=nyc.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ST84jJ2E;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=147.75.193.91; helo=nyc.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bh3HJ1xzvz3bwf
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Jul 2025 12:37:00 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 3524CA502C2;
	Tue, 15 Jul 2025 02:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055F6C4CEED;
	Tue, 15 Jul 2025 02:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752547016;
	bh=KRgeF7wD/feJDZX13wASjrkKxr7mSsP2tkO3lDVNsIY=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=ST84jJ2E0VrrhM1RGegBuPswbGnUshbWFe9DEgzeTQl7f/7qHkyNoYxlNGc3xiZPm
	 YCe7sJ4KxL022JM19LzgGvQJtiWTME7cfW7+H6BVoEftzfIp6dnI9uaSwBTG7O6Sfe
	 sNmHA47PGfk9cOrP+4qN8ohelyViQMoJDg/94xBD99n2m3vCr2IvMrKvApQ8gThcuF
	 k/R47P2eHhiDIp5vOavcR4+bmuslbxN/MjBYiMwgSkJgJguBABQldpkFIePvFtfNAT
	 qqjeoGxcz4KZ8jpqk3WZ6fhSp+ouPAVJIsK7HXoCo+om5Dv8QJG/XW4EoAczKA2ENC
	 ERk6QuPjT5IFQ==
Message-ID: <10a23be8-ae70-47ba-88e6-9e0bd07b9b1f@kernel.org>
Date: Tue, 15 Jul 2025 10:36:54 +0800
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] erofs: remove need_kmap in erofs_read_metabuf()
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20250714090907.4095645-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20250714090907.4095645-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/25 17:09, Gao Xiang wrote:
>  - need_kmap is always true except for a ztailpacking case; thus, just
>    open-code that one;
> 
>  - The upcoming metadata compression will add a new boolean, so simplify
>    this first.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

