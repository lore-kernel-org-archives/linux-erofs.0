Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6327EDE994
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Sep 2024 03:14:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4X2phZ15mzz2yWr
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Sep 2024 13:14:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1725938057;
	cv=none; b=J1tEkzsGgejTnMZIkQVnjOZJo0FH34wKEhlEBzYidLPEVk5uu3pHmBATmd+BBaXMxWFss4ROpO4GrxggIPazlMOhfo0ui/dfAjg4PoplXbmkqFHjdDSmikbpbeCMoboFXcCJuk4pnYXA5zWpU1IKfAXCewz2Fp0R2FLwYn6sSJinYC1e5yUpT2Us06WvOlIEKaRTc/nhCpvvRxiP2/RDmCEZAmUkTaFZmuYaKIJ49U+LBBya8B2HDYjBrnskWkVuDfX4IhSzCfm0DMg85OG1o/njqwSVMUGcxwg/co/miypg7ojiDlFeJX3zXbes08vJqJhYBdWkPhuMAbyepKGtCA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1725938057; c=relaxed/relaxed;
	bh=y9vNUmSFnNm/KQJ4QgEqnS00RVgJhaO73bA7gtjFJ/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dg5MN7sZ0kQDvltd9q2TyXQA50QjlP+dhzJInUHUZGIaeWaGXe1KwHjKLeDGzPj2HjxLTcMD3A0wfQS5NoSvMFlWdYR1zx7WhQCi147aTXkzm/Tm2rB5oqeurFAtD9x2EQUiA7oNHMeCON47w5rudkNCgOyaWw6P3bnIS/4qLSXhsoMriVXV2AtRksWd5mMFxvPdsKfIzT0NOKRsLt2I/ctNCS+lNYrtwzWRPzqvRKt3lHMP5nKT8BtIkRx/oW93dkUIEfOs1nHvxkTeEYQFtn3PNVQPeT6So8yjZrAH5SywNfGUB4dz6UYXgP92LTSCx8H4DpeUASdbNpDBZMwPiw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nBQsYakg; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nBQsYakg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4X2phR3NRyz2y8h
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Sep 2024 13:14:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725938049; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=y9vNUmSFnNm/KQJ4QgEqnS00RVgJhaO73bA7gtjFJ/0=;
	b=nBQsYakgp2+RulTswBlwTyX5yzqS3ftmbTyDss9sZxEAwMPjQslHnXUjsulmCKqSjIm26wew1PgXZWjxZ/+RXcfxFkZBbjBK7MY6SjW6AyQ4jHb6nD2cZ5AfrjI9zbLwk9gCVNlZuPBTH52uw27Dy96rP9bGOJ2/GU8sgy9cwoE=
Received: from 30.244.152.37(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WEil7vA_1725938046)
          by smtp.aliyun-inc.com;
          Tue, 10 Sep 2024 11:14:08 +0800
Message-ID: <6c548d68-1666-421d-8c7c-cc4c1e689bfd@linux.alibaba.com>
Date: Tue, 10 Sep 2024 11:14:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs: allocate more short-lived pages from reserved pool
 first
To: Chunhai Guo <guochunhai@vivo.com>, xiang@kernel.org
References: <20240906121110.3701889-1-guochunhai@vivo.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20240906121110.3701889-1-guochunhai@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-erofs@lists.ozlabs.org, huyue2@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/9/6 20:11, Chunhai Guo wrote:
> This patch aims to allocate bvpages and short-lived compressed pages
> from the reserved pool first.
> 
> After applying this patch, there are three benefits.
> 
> 1. It reduces the page allocation time.
>   The bvpages and short-lived compressed pages account for about 4% of
> the pages allocated from the system in the multi-app launch benchmarks
> [1]. It reduces the page allocation time accordingly and lowers the
> likelihood of blockage by page allocation in low memory scenarios.
> 
> 2. The pages in the reserved pool will be allocated on demand.
>   Currently, bvpages and short-lived compressed pages are short-lived
> pages allocated from the system, and the pages in the reserved pool all
> originate from short-lived pages. Consequently, the number of reserved
> pool pages will increase to z_erofs_rsv_nrpages over time.
>   With this patch, all short-lived pages are allocated from the reserved
> pool first, so the number of reserved pool pages will only increase when
> there are not enough pages. Thus, even if z_erofs_rsv_nrpages is set to
> a large number for specific reasons, the actual number of reserved pool
> pages may remain low as per demand. In the multi-app launch benchmarks
> [1], z_erofs_rsv_nrpages is set at 256, while the number of reserved
> pool pages remains below 64.
> 
> 3. When erofs cache decompression is disabled
>     (EROFS_ZIP_CACHE_DISABLED), all pages will *only* be allocated from
> the reserved pool for erofs. This will significantly reduce the memory
> pressure from erofs.
> 
> [1] For additional details on the multi-app launch benchmarks, please
> refer to commit 0f6273ab4637 ("erofs: add a reserved buffer pool for lz4
> decompression").
> 
> Signed-off-by: Chunhai Guo <guochunhai@vivo.com>

It looks good to me and it seems useful for the corner lagging
with little modification if reserved pool is used:

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
