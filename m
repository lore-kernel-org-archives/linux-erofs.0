Return-Path: <linux-erofs+bounces-2951-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95CA6EC01B1
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 09:59:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffTDN6Lnkz2ySc;
	Mon, 23 Mar 2026 20:59:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774259988;
	cv=none; b=KhBxIaD71BSDpK9dc5fiZRo9qsjaWOo/+Hl4hs9oabkbKEdkDsDeY9hUR2HF6GavovwsAsjHJlMzw8YshnQxdYVp9HjSHibLHN/uDMIeemn5T7pKm7IliKOyRnZcbCdhyklTKREDD7+Z9A9rJr5OHsGUpayc4SzhvwauGP/QPkqPoGOWXg8EodhpE9GaQgs1kLh4B70w2BxZ+UpuQQjhXonO3s4YP6CuV2/5o/+o6XIhBoy0ITkrUATl9LuJYJPTEGxejrw8kZsQMT1gAtO2F8H4z4cGUp46NOla4rq1kQ58WBa6ZbQr1hKz9ry9ADK2Io59k2brk3p02NBQa54zUg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774259988; c=relaxed/relaxed;
	bh=BjsMzS+Q9We+mYzRjTpIH2UdhNZQt4P8O4fGNIk/7JA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ILiZiH4tNiXpecB6NsW/b0s7iY/iMwXsNKQPEVLcvz9pbVVjJ9H9bMO/va4hn2Vc3sWkKEOcskPRIpdw7S3e+uqkFynRPmFHKlwScY0Q8XoVo6Ctds4xXiVx6JBbRQ/Q3vVW6OX3XOnBipgDpSb9QUyr/UkIuMHbAayzXXfqsH1LwClUiNMgkoSi7+NqdngHfjPyPdffEwTpcss8qZZcsRc0po7NmTxFluPXLT0xaGVrk2uD3ocESrfAlefvdVJLh4Plcnxblwb+u9ZL0qB1JYeg2r4/M85QI0U1LL/Kl0oyJX12r2d4LrAFYSiAWW5KALNG99RmNDgicAh8cR9cgw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=VX8jDzQJ; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=VX8jDzQJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffTDM6rW2z2ySb
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Mar 2026 20:59:47 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55C06436CA;
	Mon, 23 Mar 2026 09:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCD1C4CEF7;
	Mon, 23 Mar 2026 09:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774259985;
	bh=o9VDcVaeOW+9PxAISKA8BbwHP5JjMc2drei/sa5NuKk=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=VX8jDzQJUG5re5L6rbV2/LwwAYcZZCVfU3aSXZsizRDBKRzrFzpPz1d+kWdQKZpAt
	 ij/dnMCc0iX/thIVzwGEq0QjpkdvA2jRYV284XEjAIPr2w8j/gWSXwKnEbtKfjjlPo
	 zW5Oyt8JmdnhBI2C6XI2rn0ahpi0UvF0S1ucCzki3Uiv7vaqtWT5GwTxr7Ke7ZA+Mp
	 1+n6UP2SpVZvJyfnUWp9kRMTIghaxfPikBGqrWoULvf2UOF+LHL4FWAmmkN4YCoQkf
	 a7K8lf0kNreH68/0nh2HqYtQeTxq1/ALob4Ax62kc2tsDIlxwbusqowdAIZuopim8a
	 gO3A/TRBV//Dw==
Message-ID: <927c52ee-24b5-4b8f-98ee-3a18f13fa8b5@kernel.org>
Date: Mon, 23 Mar 2026 17:59:42 +0800
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
Subject: Re: [PATCH] erofs: update the Kconfig description
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20260323094857.2187994-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260323094857.2187994-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/23/26 17:48, Gao Xiang wrote:
> Refine the description to better highlight its features and use cases.
> 
> In addition, add instructions for building it as a module and clarify
> the compression option.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>  fs/erofs/Kconfig | 45 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> index a9f645f57bb2..9489ed8ad95b 100644
> --- a/fs/erofs/Kconfig
> +++ b/fs/erofs/Kconfig
> @@ -16,22 +16,36 @@ config EROFS_FS
>  	select ZLIB_INFLATE if EROFS_FS_ZIP_DEFLATE
>  	select ZSTD_DECOMPRESS if EROFS_FS_ZIP_ZSTD
>  	help
> -	  EROFS (Enhanced Read-Only File System) is a lightweight read-only
> -	  file system with modern designs (e.g. no buffer heads, inline
> -	  xattrs/data, chunk-based deduplication, multiple devices, etc.) for
> -	  scenarios which need high-performance read-only solutions, e.g.
> -	  smartphones with Android OS, LiveCDs and high-density hosts with
> -	  numerous containers;
> -
> -	  It also provides transparent compression and deduplication support to
> -	  improve storage density and maintain relatively high compression
> -	  ratios, and it implements in-place decompression to temporarily reuse
> -	  page cache for compressed data using proper strategies, which is
> -	  quite useful for ensuring guaranteed end-to-end runtime decompression
> +	  EROFS (Enhanced Read-Only File System) is a modern, lightweight,
> +	  secure read-only filesystem for various use cases, such as immutable
> +	  system images, container images, application sandboxes, and datasets.
> +
> +	  EROFS uses a flexible, hierarchical on-disk design so that features
> +	  can be enabled on demand: the core on-disk format is block-aligned in
> +	  order to perform optimally on all kinds of devices, including block
> +	  and memory-backed devices; the format is easy to parse and has zero
> +	  metadata redundancy, unlike generic filesystems, making it ideal for
> +	  for filesytem auditing and remote access; inline data, random-access

duplicated 'for'? otherwise, looks good to me.

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

> +	  friendly directory data, inline/shared extended attributes and
> +	  chunk-based deduplication ensure space efficiency while maintaining
> +	  high performance.
> +
> +	  Optionally, it supports multiple devices to reference external data,
> +	  enabling data sharing for container images.
> +
> +	  It also has advanced encoded on-disk layouts, particularly for data
> +	  compression and fine-grained deduplication. It utilizes fixed-size
> +	  output compression to improve storage density while keeping relatively
> +	  high compression ratios. Furthermore, it implements in-place
> +	  decompression to reuse file pages to keep compressed data temporarily
> +	  with proper strategies, which ensures guaranteed end-to-end runtime
>  	  performance under extreme memory pressure without extra cost.
>  
> -	  See the documentation at <file:Documentation/filesystems/erofs.rst>
> -	  and the web pages at <https://erofs.docs.kernel.org> for more details.
> +	  For more details, see the web pages at <https://erofs.docs.kernel.org>
> +	  and the documentation at <file:Documentation/filesystems/erofs.rst>.
> +
> +	  To compile EROFS filesystem support as a module, choose M here. The
> +	  module will be called erofs.
>  
>  	  If unsure, say N.
>  
> @@ -105,7 +119,8 @@ config EROFS_FS_ZIP
>  	depends on EROFS_FS
>  	default y
>  	help
> -	  Enable transparent compression support for EROFS file systems.
> +	  Enable EROFS compression layouts so that filesystems containing
> +	  compressed files can be parsed by the kernel.
>  
>  	  If you don't want to enable compression feature, say N.
>  


