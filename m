Return-Path: <linux-erofs+bounces-4212-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD7FC5B56A
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 14:26:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKrQS44hlz3brB;
	Thu, 13 Aug 2026 00:26:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786544784;
	cv=none; b=WZCO/uBxDFaF02rxY5A/dWLgJs5hsuE6/ujtu0CpBl0ixhkqN27Y7t3rDDNTAkbYrRdkF0TCF3hNTPDK8YuneEHhFFTBpoFea8PxwmwK3nPH0s1fMvMCkQ6k2eu/Uus6G9OqKZ/A5Gw3nBGwVWG2dIWQu3UAwrr/ZyoqzKdlFBQxazYjUpNvSGao6gEkSQNnFnyN0mZx0u/U5QVa6qTL2dfMYmiVs9HlxBbV9HfzE63ll69TOGiIGp0FNSa3B7skOhETPAU9ULJF9oqiLu+SgoVf2QdLddcKVKlrxP+vBVuo0zNZnEIARsOZ5TuBaSXlemLTonLpv8Um8S6obzZPFw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786544784; c=relaxed/relaxed;
	bh=n0+XZgok1eHql18L7XHMKns591enUwwfrPR1jXjyqIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YX5tBQ6A+r6dPtCToP6lFZreq1fvDT6i68w3iqIV9xZS1jAgO0mbIsU78HKG5uPhhwJXMBEF+53ndDj9uNW1g2Zx6CocQsomLdNj8fJP2/fBEmz8Awx3qcR9jAUIrjqCFOQif8a+8mhmDf6IKjbIb4DkRJSNDUoSitN/p2U9cDhSMvW3/uOaaEzlhEM7SJ2F8RIie7toU7wdxQBot1UcotXVevoOB5quUNDsmU8zBfK8qpm1ylaSwvX2jmGB2804wp87Gncr9gJEZ5Os4hEDg5v3I8oekkkjRtlDO+BGs8a7EwScrB5In0nYsfPlS7mQatCbEtG+njVTN9xKzESBow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lP2idE8G; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lP2idE8G;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKrQR6jNvz3bqW
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 00:26:23 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 424C641791;
	Wed, 12 Aug 2026 14:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165021F000E9;
	Wed, 12 Aug 2026 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786544782;
	bh=n0+XZgok1eHql18L7XHMKns591enUwwfrPR1jXjyqIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lP2idE8G4Hw9D9Tma0zrsBhKrGeKkaRQyzPS2IrmnXsS5l2AeqzWnw2LtDafEn/Ci
	 LpogMrhm0LLU4sDudrL407ywKSM3QvdRzmlsO7/DXPlOtMA7NWq1iDcUUU6hjTzqof
	 vzYiUldN3c0idffj/EaYpC6zmSKCyfUh2jwfD+cYlycpVjaFUvIWRt95PtY9szVBWr
	 seJdC7ag/hVXZMb3IZ7Ce/0Te37m+waFSihzCK7xGKVIqWz0K5bpyVVBil6vI7rfxE
	 iJtqEFu0Qf50Uy5nEPOJoDEhYgKniWQSgu2lbUlnz66iVZHdTej9a769bT9hfomxcc
	 bx52NelttEZlA==
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	bpf@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cachefiles,netfs: sunset ondemand mode
Date: Wed, 12 Aug 2026 16:26:12 +0200
Message-ID: <20260812-gegeben-messung-weltgegenden-8491254df0e0@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1046393.1786544127@warthog.procyon.org.uk>
References: <1046393.1786544127@warthog.procyon.org.uk>
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
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1289; i=brauner@kernel.org; h=from:subject:message-id; bh=kf82btbWVEF7ldoT0M+F8gWvP8RldYftJie0/C8/1RY=; b=kA0DAAoWkcYbwGV43KIByyZiAGp8goigQJZBZ0vpz73ayYqFRuXcPPtdGeUSdfbXGadNG8aZO oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmp8gogACgkQkcYbwGV43KLCVwEA2KA7 +HpySt6MAFnPPRpzqO5RdG8hsjdBt+VmjmloJqEA/1sQ4QMUc//v2o0fb7V44BGKPBq/w3tCBN9 0RkPdYEoC
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 12 Aug 2026 15:15:27 +0100, David Howells wrote:
> It was an effort to enhance fscache as a kernel cache for lazy
> pulling (at least according to previous Incremental FS discussion [1])
> and EROFS over fscache was the in-tree user of this mode.
> 
> fscache has since evolved to be netfslib-oriented, serving network
> filesystem inodes via the netfs library, but EROFS never acts as a
> network filesystem and we need to cache golden filesystem images rather
> than individual EROFS inodes.
> 
> [...]

Applied to the vfs-7.3.netfs branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.netfs branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.netfs

[1/1] cachefiles,netfs: sunset ondemand mode
      https://git.kernel.org/vfs/vfs/c/949eb95d5bcc

