Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DC1C4345F
	for <linux-erofs@archiver.kernel.org>; Thu, 18 Apr 2024 05:06:01 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=s81RJ79i;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VKm2J3gKGz3cT2
	for <linux-erofs@archiver.kernel.org>; Thu, 18 Apr 2024 15:06:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=s81RJ79i;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:40e1:4800::1; helo=sin.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VKm2B2SHhz3bv3
	for <linux-erofs@lists.ozlabs.org>; Thu, 18 Apr 2024 15:05:53 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 2C67ECE127D;
	Thu, 18 Apr 2024 05:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30448C113CC;
	Thu, 18 Apr 2024 05:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713416748;
	bh=vXLA4brUunEkDTq1V3LlnMpJxlSSuZODdJ5A1+shPvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s81RJ79iW/AYFhL10sRzTbCuabeZAMs5j+0ALTPvf91vcp5aTBgXzkyt3zVFOb5LL
	 nhlR8bJVGKEXCAJ1GuLKRi3VnPDJXYIrFVVfv487lApqrUDZ5WlNh2gIH8KylChn4M
	 JS8+uKse1JB9ycpiCMjRe8ruI0qlLt5ixyDWu0tBycOswFbeDz//purlvbKDSCd8zB
	 gYzyg1Qeo3dqEvvGPm0xxhxFMWQ7RPDzvkoo5URl9HwTjYx0RUUJdOejPBtntd2Amj
	 5rufDn0oHrusJ+o1ZDJzP2zCxHWjY9LwDO+DexecJE+XrCLmFlZvK88lT7tyBoZHO8
	 V/cStzWjLadwQ==
Date: Thu, 18 Apr 2024 13:05:46 +0800
From: Gao Xiang <xiang@kernel.org>
To: Sandeep Dhavale <dhavale@google.com>
Subject: Re: [PATCH v3] erofs-utils: lib: treat data blocks filled with 0s as
 a hole
Message-ID: <ZiCqKhV6wX7BtYir@debian>
Mail-Followup-To: Sandeep Dhavale <dhavale@google.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	hsiangkao@linux.alibaba.com, kernel-team@android.com
References: <20240417234845.2758882-1-dhavale@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240417234845.2758882-1-dhavale@google.com>
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
Cc: hsiangkao@linux.alibaba.com, kernel-team@android.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Apr 17, 2024 at 04:48:44PM -0700, Sandeep Dhavale wrote:
> Add optimization to treat data blocks filled with 0s as a hole.
> Even though diskspace savings are comparable to chunk based or dedupe,
> having no block assigned saves us redundant disk IOs during read.
> 
> To detect blocks filled with zeros during chunking, we insert block
> filled with zeros (zerochunk) in the hashmap. If we detect a possible
> dedupe, we map it to the hole so there is no physical block assigned.
> 
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
