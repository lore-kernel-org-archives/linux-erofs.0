Return-Path: <linux-erofs+bounces-4149-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 983BEC5AD4E
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 00:18:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJFjV3p3Sz2xq0;
	Mon, 10 Aug 2026 10:18:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786321134;
	cv=none; b=FebwGzJR7Twq0poftQXxQcL8KZNWX0TiN3niLnFYA6tCVGTiXoIpbNizGDre+Qtcv1XZotkyJ8lxZM6yS6M4T3hpAbWcFtKOuZIDa2qEHjachIylJMPynhh+YEex19qP1O2V5smyRMpY+ax+S85PUx6tKGT6eudk+YEXk5ut+DRbHEB/tfT1ESxBV4NC8HZxLwhYtaZQHIbsRK9cWvOvBkS+4R29Z2YZpYBLhV5CS1klFDD3wdWQ63f1spY2uR0BYm8UN1issD3UOvxeOAo6Kg4mkNR/8PVtKF1xZuU4Pw5/ne4jVIajGUuZ5SsNrbnmDXs7mGa+fbbdq6/XhrpA0w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786321134; c=relaxed/relaxed;
	bh=zdzYfCN9v02Qwn7VmVE6pA9F2adO4XVygBdDVbL7wII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYP01Q+wcDmqR3blr7PxuY4yNZvE/B/vzlRQ0TMMmiR5K9Tor4DPiiGzPT7Saw9XN4Rt49uGJ853E15mdUp34eCuARyA+ZMFRRakYTaRAXYW4907HVxfwdzE51qGQgP5GuizzFLCKemzLqThr2+LaSXD7DqZHH8yVZk1mM3bf9FZW/zYChtCTZYFr9rHJq+LvI9m3ikc4hJoSjxHMWScDnFk1/E9Gk/whNrqVGRYYwQyZmRzTpDBOwEW/Ic97K5x4iEZcsx6Gk5UE0rC9oiGy9IXYu375SRNznt/s3RPJgBW0/jKUGlhDxd8pi5WzLcqLkQ1/kKtfurIN/uWrigq5w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUu8mULk; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUu8mULk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJFjT6HQZz2yPR
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 10:18:53 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FBA7600AB;
	Mon, 10 Aug 2026 00:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D894E1F000E9;
	Mon, 10 Aug 2026 00:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786321130;
	bh=zdzYfCN9v02Qwn7VmVE6pA9F2adO4XVygBdDVbL7wII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IUu8mULkv9iskYdOe2LL60e+A5mBQolvURk0tKlQOjG7R1ccdHDTUg6gmdXlmpZ5O
	 Q9BHD+gd1fsA7Oo4bVQhfxcwc5NTP8zj3AE8KtfRXxa1lEzWxsP8IzDLfaDQZi/82h
	 QaeCZOMqp9Uc2pgKfjVbO/wMU0Us2vAYCeoqcE/L1G7N7Usd5uSCVaCp5zVAQnwK9o
	 3CXzWmO8ojcf2o5OuRPjd+gazJoW4XLDJYJ4AGI8vJACciEHB4fS3zstu5snUZkwu4
	 4QM26KtNO2LTs62XeMSErh33Nn6X3wojOk9Hym+SiTexor2AinFtom2WTGCimPySl2
	 7M5rgFXnjFthg==
Date: Mon, 10 Aug 2026 08:18:45 +0800
From: Gao Xiang <xiang@kernel.org>
To: Chris Ayoub <cayoub@openai.com>
Cc: linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] rebuild: prevent quadratic snapshot merges on wide
 directories
Message-ID: <ankY5UFLlWbKkNyd@XiangdeMacBook-Pro.local>
Mail-Followup-To: Chris Ayoub <cayoub@openai.com>,
	linux-erofs@lists.ozlabs.org
References: <20260809-rebuild-wide-directory-index-v1-1-ac8b7bce3edd@openai.com>
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
In-Reply-To: <20260809-rebuild-wide-directory-index-v1-1-ac8b7bce3edd@openai.com>

Hi Chris,

On Sun, Aug 09, 2026 at 05:44:08PM -0400, Chris Ayoub wrote:
> Directory entry merging currently performs a linear search of the
> destination directory for each source entry. Repeating this operation
> for wide directories makes snapshot rebuilding quadratic.
> 
> Add a temporary hashmap keyed by the parent inode and entry name during
> rebuild. Use the index to find existing children while preserving the
> existing merge and replacement behavior, and release it when rebuilding
> finishes.
> 
> In the original reproducer, merging 129 layers containing approximately
> 2.4 million entries did not finish after 1195 seconds. With the index,
> the same merge completed in 1.40 seconds. The widest directories
> contained 65,212 and 83,318 entries.
> 
> Assisted-by: Codex:gpt-5
> Signed-off-by: Chris Ayoub <cayoub@openai.com>
> ---
> Snapshot rebuild currently performs a linear directory search for every
> entry being merged.  This becomes prohibitively expensive for container
> images with very wide directories.
> 
> The patch adds a temporary rebuild-only hashmap keyed by parent inode and
> entry name.  It preserves the existing merge and replacement behavior and
> releases the index after all source trees have been loaded.
> 
> The original workload merged 129 layers containing approximately 2.4
> million entries.  The unmodified rebuild did not finish after 1195 seconds;
> with the index, it completed in 1.40 seconds.  The widest directories had
> 65,212 and 83,318 entries.
> 
> Validation against current dev (v1.9.3) on arm64 Ubuntu 24.04:
> 
> - Full build with LZ4, LZMA, FUSE, and Zstd enabled
> - make check
> - Byte-identical output versus unmodified v1.9.3 for file replacement,
>   whiteout and opaque-directory handling, and an 8,000-entry directory
> - Extracted-tree checks for replacement, whiteout, and opaque semantics
> - 8,000-entry local rebuild: 0.23 seconds before, 0.01 seconds after

Yes, it's a known issue, but could you avoid using `hashmap` in
erofs-utils (we could just use `struct list_head hash[xxx] instead.`).

I'd like to get rid of `hashmap` since it's out of git codebase and
the license is GPL only.

Thanks,
Gao Xiang

