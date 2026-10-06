Return-Path: <linux-erofs+bounces-4667-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2EF7CA5FED
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Oct 2026 20:58:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hzpVz6nncz30Sx;
	Wed, 07 Oct 2026 07:58:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791320283;
	cv=none; b=OX2HAtUav86TxaCc7YqLXuKLd+jDZ388RhIeZ/jInDcIbzu6FRFNRP1gU9GzAgqm09MjPN84jxE7MnsoRGIUkIg2Kk2Lz1iRhBSRnxkqW6wAI6Aiksxj54axPDUpHvqck5T/SBHB08OTmXxItHsQ4CzU5o71tquOYD98wr2mq4e2Qirdn0aCJQhkG3JMdK7EZEtAprVK+oaA0czDt4GhSCdzdagzbrm/g1Nbc3nf0QQ1AR6UgiH4cnbhbDczIlBWF2+eTx+zx1O3R57HL1ZYZpJRzSjcrXo5fEpr3MA4obCGF4+y4O6sSDHvi1A8jb00pluFTY+5OlJ67NiHxIXRTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791320283; c=relaxed/relaxed;
	bh=fqDun/MN7VRYFq8KkLNcQj6vRZdJbG8iRRUTS4ou0XQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeWFnK0nxBEbV6zUPuXt8zCKRqf/8uuy1aw1zeTR3MIGU7DJEvXWVHPi8tycGw4K6qmnzR7Q6Pk5GhE85Iyr1L0hWFF4KrSFRLiwzd5D0nL+IQyeM5z8QA0o31DKtPA8mRrr7ibWzezkTbZFD8AhBzauXMwk1bC2v+SqEEyoKOUVkTD0yZ+sE18/vwYh9CdwnaRt0OJeJS5hQHGtWSQmUKd6OZdU0zXqBWtAcnQINg8LIA0lqWr7criV43IO/Vx2sMMWwGmS/aJaaHZDkR5kl1+v3WSTDUlHMSwvZpvU9zqiEFLbfik23YNclTQRbYGRS3etNZpOs5x6oa4kBkPiKg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqi91ydm; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqi91ydm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hzpVz2HYvz2xdX
	for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 07:58:03 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EFD0600C8;
	Tue,  6 Oct 2026 20:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165E81F0089B;
	Tue,  6 Oct 2026 20:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791320281;
	bh=fqDun/MN7VRYFq8KkLNcQj6vRZdJbG8iRRUTS4ou0XQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kqi91ydmPcEp6FNzETik3C7QGIC+ZSxg5gGqF3Ndfkx/NYFP1bDDArJmKn49cgtNy
	 AMmDkhi9xHaOXrlgIm1vqhzYJq5YFV3FYFeqzpIc8ohHp63HG79IlNk2reeHTRJhWr
	 LLGJgmFfciT8DvWQkZX6HrbC9kzqmua4ngPeZVXjO9MnNIrBWjdoFUFML1V0NcZcIG
	 sQydRRSrPhu7RXAKhU5aVEw30q4hhx68/A5wvG1s+j5taAgqxMMuKzfUD0VY/f3RKh
	 pBco1YS+QrEEFZZXbxJTOEkmNcqV2getPEwaqRiAETPEnZGo+nvJJ6zWXI8yqmesY3
	 4sXohYTN3CBnw==
Date: Tue, 6 Oct 2026 22:57:56 +0200
From: Gao Xiang <xiang@kernel.org>
To: sadmanf@meta.com
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH RESEND 2/2] erofs-utils: lib: close source fd on early
 errors in erofs_mkfs_begin_nondirectory()
Message-ID: <asVg1MqkA3I7Gd7a@MacBookPro>
Mail-Followup-To: sadmanf@meta.com, linux-erofs@lists.ozlabs.org,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
References: <20261006-round1-v1-0-f46b13e11de5@meta.com>
 <20261006-round1-v1-2-f46b13e11de5@meta.com>
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
In-Reply-To: <20261006-round1-v1-2-f46b13e11de5@meta.com>

On Tue, Oct 06, 2026 at 02:04:48PM -0400, Sadman Fahmid via B4 Relay wrote:
> From: Sadman Fahmid <sadmanf@meta.com>
> 
> If erofs_set_inode_fingerprint() or erofs_prepare_compressed_file()
> fails, the source file descriptor opened just above is never closed
> since the job carrying it is never queued.  Close it on those paths.
> 
> The diskbuf descriptor is left alone as it is owned by the diskbuf.
> 
> Signed-off-by: Sadman Fahmid <sadmanf@meta.com>
> 
> ---
> The erofs_begin_compressed_file() failure path is left as is: with
> multi-threaded compression, z_erofs_mt_compress() may fail after some
> segments have already been queued to workers that read from the fd,
> so closing it there would be unsafe.


I applied this.  Although yeah, the failure path needs to be revisited
later.

Thanks,
Gao Xiang

