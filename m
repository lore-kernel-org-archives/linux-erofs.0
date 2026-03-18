Return-Path: <linux-erofs+bounces-2823-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC00FCD0B4
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Mar 2026 06:07:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fbJJn2cbvz2xYk;
	Wed, 18 Mar 2026 17:07:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773814057;
	cv=none; b=ZorJAfzVxOkf69Di1qzIe3SX7g8CMzc12LZBrkdGLkyjsF+5LQ0TL/8imaXdzrJbbSU3AbTijLX7ln/FKORBOGgnqndBkhRIJeafnu+RqkywJ9/Hgfriv8stgPXukzWC5wrYEHvOI4nmB3vdCzVtLgpssouGecfZ/rLvPcJWAPdVL7dIoFD5/1qD99fZtYyDBYwgg38MM9dYBSoz5105OvuzXRBAleL4qdz3/7SewSS6MAvJy+BWOqsa3Ra65MJrD2iGFI3XPK0IufzjK4M9etbiyDzz/O5aTAOyDhU4yKmTEeIbOTfRX6Kt7HGtUNRi+PpvIuqJKobXYvL6r+wTdw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773814057; c=relaxed/relaxed;
	bh=6nXXbp+CWTRlt75k7NmWZIWPkfIHfDkui+z+H2M6AnM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eNeOmL+cKYvrEvzBZK9ZuriWLDbaWZRZr0bHIsEcjFzyzqoqoqhVzfqcZNoB+rq2JYJWtgMaqFuEEqWnjNIsQcpaTLgmcNJxwXxJ6D6ohWCfkuAWyoWabhou1DMWK6EfBOTJN/3jU0xrftbP6qdTKFv0Wie/JOCLIxIwwRnxo35VuE8W4wLi9i33k/2xPpAPSv0JRcCdEovYrdyg9HTbVuo0dNzqzw+Fyys6OGtwonwMSeVnigG2ZblEjUXVxR6VNoXUmT32WfAip8uWF7u2S1dG4+OlUGLU7BZLLfJ5LLsWVt4H5HRapH0kn7kZ9zZUhQNu9fkqXERSee3VUzi4Jw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=F6McLun8; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=F6McLun8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fbJJm3hT6z2xQB
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 17:07:36 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1AE760054;
	Wed, 18 Mar 2026 06:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C03FC19421;
	Wed, 18 Mar 2026 06:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773814048;
	bh=yP5/iQJCNcG6ji06jAFAHa49tFVPh+/YzwK+WAC0kSg=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=F6McLun887k2J+kOsvXUUIrKgJoD8v5E54/s0h88YkYuINDVE8c69qjlQSSU5/RAP
	 EscQ5NHtlGYk/FbRpzQbd2Mm0axcS4UbL7UkSVz+jNx1NKgfQ7rqNw7MxLi78yyvbk
	 +/MDRTIrYpD98qMOfAey/DrTKXD7bRjXzy25rMMTQgjGQXToKKq5TU7BMG7/EYPQZv
	 zE5geOvs/oKeaE4pDkFbww7yhfXv9YyVVBcyJYoYOPQxy7AxuTj1e6FCOhAzlIrgmV
	 O458+M89lEesi+ixpOUngaCcc929xGNctXmQd8aO3jOeZWeHl8GIl5mvL8WXLthGSK
	 X2YZnrfMja2Pw==
Message-ID: <4acad3d6-ce48-4191-970a-95bcbe8edb01@kernel.org>
Date: Wed, 18 Mar 2026 14:07:21 +0800
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
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, jianxin.pan@amlogic.com, tuan.zhang@amlogic.com
Subject: Re: [PATCH v2] erofs: add GFP_NOIO in the bio completion if needed
To: jiucheng.xu@amlogic.com, Gao Xiang <xiang@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>
References: <20260311-origin-dev-v2-1-0657cff690eb@amlogic.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260311-origin-dev-v2-1-0657cff690eb@amlogic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/3/11 17:11, Jiucheng Xu via B4 Relay wrote:
> From: Jiucheng Xu <jiucheng.xu@amlogic.com>
> 
> The bio completion path in the process context (e.g. dm-verity)
> will directly call into decompression rather than trigger another
> workqueue context for minimal scheduling latencies, which can
> then call vm_map_ram() with GFP_KERNEL.
> 
> Due to insufficient memory, vm_map_ram() may generate memory
> swapping I/O, which can cause submit_bio_wait to deadlock
> in some scenarios.
> 
> Trimmed down the call stack, as follows:
> 
> f2fs_submit_read_io
>    submit_bio                      //bio_list is initialized.
>      mmc_blk_mq_recovery
>        z_erofs_endio
>          vm_map_ram
>            __pte_alloc_kernel
>              __alloc_pages_direct_reclaim
>                shrink_folio_list
>                  __swap_writepage
>                    submit_bio_wait  //bio_list is non-NULL, hang!!!
> 
> Use memalloc_noio_{save,restore}() to wrap up this path.
> 
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

