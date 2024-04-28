Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD3CC4345F
	for <linux-erofs@archiver.kernel.org>; Sun, 28 Apr 2024 10:00:22 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=mBrsri1k;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VS25K0d8mz3cSq
	for <linux-erofs@archiver.kernel.org>; Sun, 28 Apr 2024 20:00:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=mBrsri1k;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:40e1:4800::1; helo=sin.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VS25B625vz3c5J
	for <linux-erofs@lists.ozlabs.org>; Sun, 28 Apr 2024 20:00:14 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 2172FCE0185;
	Sun, 28 Apr 2024 10:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2EFC113CC;
	Sun, 28 Apr 2024 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714298408;
	bh=Qd1fqPW8u0tnbx6oXHidvD3XgBUn59/jezsd1Be/U8k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mBrsri1k0N89fOWW/+z6N1VQywuP6WHbOi9hVwBBvvDBBWuZoiaOgW8zs4pOivab1
	 x8BDfqC4TMLIQl2Qjxy25VtZZ79xi6O0Ck8m7Zoi95ehbOxnMjUKtZwCKwI/hKZEa0
	 lFrXULF2dgin562ULGWyRyY5SLKiuO9P/7LktLBbYDFekv7dDasUS4s19jyYMThjMs
	 lFcJlg8DWDPn8WBO+OQnC9PxmiRNysGNgo1femE5OmTkEdBD5UqWUlTkoU3prWJKbV
	 qb1X5i5xIFzt3fFRRF1yKTuP3r+6loDQQ9CDqBRCDbrLZzK9Z8m2UrBR8Hlx/ipo/u
	 xzFr0kjvsFXuQ==
Message-ID: <c1c11066-c2d9-4f88-9903-b80dae4bbf04@kernel.org>
Date: Sun, 28 Apr 2024 18:00:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v3 1/2] erofs: get rid of erofs_fs_context
To: Baokun Li <libaokun1@huawei.com>, linux-erofs@lists.ozlabs.org
References: <20240419123611.947084-1-libaokun1@huawei.com>
 <20240419123611.947084-2-libaokun1@huawei.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20240419123611.947084-2-libaokun1@huawei.com>
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
Cc: brauner@kernel.org, yangerkun@huawei.com, linux-kernel@vger.kernel.org, huyue2@coolpad.com, viro@zeniv.linux.org.uk
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2024/4/19 20:36, Baokun Li wrote:
> Instead of allocating the erofs_sb_info in fill_super() allocate it during
> erofs_init_fs_context() and ensure that erofs can always have the info
> available during erofs_kill_sb(). After this erofs_fs_context is no longer
> needed, replace ctx with sbi, no functional changes.
> 
> Suggested-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
