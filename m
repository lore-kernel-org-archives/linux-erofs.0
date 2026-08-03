Return-Path: <linux-erofs+bounces-4095-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2705C55182
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 23:23:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDXmR1JbSz3080;
	Tue, 04 Aug 2026 09:23:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785799415;
	cv=none; b=aQBGIE7Hao5cPgEipcuT/HzVOUv9czsCjfrSIGRQZV8LzlGPEDt/UtFdtRfLN6WgxgmbsN1FQgWzDatANd3BP+lqp/7FfayxWz0lGHCI5EOrTiAtenZ64IAvKOEeIY63aZmsMsglnEql4R7U51vm98q7WE0yvoTNYWGNYLgmlVdlfaWyh43lSV5eamn1iaiLqy5FdDQEF7N7/9bwUv7YzZRRuTZTiy22kfISwCmBO0KYh9VFN+6OhdEorbf6G/Ful3NTdihuC6v2Tt1U6jgzwMox0yQHsKcFpBzNgvhHuGhjCI4g2mpd46c4fj1nIGNytCUiPFXz1O0/Fp+B75Sc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785799415; c=relaxed/relaxed;
	bh=F4iuVFc968Ed+tEtohzbM+euqk4ou2sjXLoo8jFdN8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxAfjGTNtbB7Mg14RhpAvkdtZ9uNUnZ2kzhBVBF4ocnf6C91pW5nrVUW0RlHc1QPtPcq91zym2H+PcZLbvVLwc8o6aHcOpdufV59z8iAq05X0QjNVhg6WMAvaiUFq9utax1x6oNArrAmvuN3row2KuK4tW7cysoymerguDg80mPAoigbm5d5UXpuJU0vfqMQ7YD7C+w8YGBmtg0P1Od3LDY6pzwK3j8TDm/J9PpYAarFKSnfp+ovmMibTrgLsFDHzNTyOzUhZOlVq+absjADbgrbOuCyV/AEzcOsbDKzmwLoVpLhSHaRRqA5VV7DwW6w+0II1ZhSl4I7oJo+FbanLg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CXnAe0bz; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CXnAe0bz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDXmQ2DFgz307v
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 09:23:34 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B61960A5F;
	Mon,  3 Aug 2026 23:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307101F000E9;
	Mon,  3 Aug 2026 23:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785799411;
	bh=F4iuVFc968Ed+tEtohzbM+euqk4ou2sjXLoo8jFdN8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CXnAe0bzthnP5AE8eosIHduPXLS+HxRVvOMg8w/qKWTIUw7CV1KUIq4GJlNeAi2Ou
	 mcbCA2krXkX+qWHHZWhgR1shBLFBc60UpJSY0V9JK2H2rhdTjXccd7hwwhH355XjK8
	 zbgvh9zdMYT/8DeKu7Ix7BWcYQ7LzjRg4KtMS2j9sk8NPFMiBHktsiDCpZc/R/FYBW
	 t/Bqgkmlub6KCAC9OO7mP0aoxuh6XgBOZzbdoTvHbPhH5R9Us0AJCdw1yLQbnpKJRP
	 vb7nWsfKKgIookS+bT1P9eOVanNeRrl1BrklcQGrefy6X6E54IEO8WPJ166ylUwvMw
	 lzMg92y1FbDbg==
Date: Tue, 4 Aug 2026 07:23:27 +0800
From: Gao Xiang <xiang@kernel.org>
To: Martin Pitt <martin@piware.de>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
Subject: Re: [PATCH v2] erofs-utils: mkfs: emit an inode's xattrs in a
 canonical order
Message-ID: <anEi7yIiNTJ74jnv@XiangdeMacBook-Pro.local>
Mail-Followup-To: Martin Pitt <martin@piware.de>,
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
References: <anCBBdM7yw9Mm3xg@piware.de>
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
In-Reply-To: <anCBBdM7yw9Mm3xg@piware.de>

On Mon, Aug 03, 2026 at 01:52:37PM +0200, Martin Pitt wrote:
> listxattr(2) makes no promise about the order it reports, and
> filesystems disagree: tmpfs reports them in insertion order on recent
> kernels (or in a random order on older ones), while ext4 and btrfs
> report their own on-disk order.
> 
> mkfs.erofs stored an inode's attributes in exactly the order it received
> them, so staging the same tree on different filesystems (or on older
> kernels merely twice in the same place) produced images that differed
> byte for byte. That made EROFS images unreproducible.
> 
> Insert into the inode's list ordered by attribute name instead, and move
> inline attributes onto the on-stack list with list_add_tail() so the
> emitted order matches. The shared attribute pool already sorts by the
> same key, so generalize comp_shared_xattritem() into
> erofs_comp_xattritem() and use it for both.
> 
> The length tiebreak previously returned only 0 or 1, never a negative
> value; make it a proper three-way comparison with cmpsgn().
> 
> Suggested-by: Gao Xiang <xiang@kernel.org>
> Signed-off-by: Martin Pitt <martin@amutable.com>

Thanks, applied.

Thanks,
Gao Xiang

