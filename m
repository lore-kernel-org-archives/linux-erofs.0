Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956D7606A31A
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Oct 2026 10:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UI3XTHxi
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jCr4j1dvNz2yLF;
	Mon, 26 Oct 2026 21:50:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793011829;
	cv=none; b=Tc5vHNJcqJk6bTDhanBptqNk4rQ6RriUXhInKE8xPefFbKcWyxFZ3uAvAax3lDuAWz6vGCDxl+mfIqDOa6j4xF+6CGnf3gxeFqSa5/R5eUGIgQ16OWEqxmcF5nasjIpvw5MJ+u576AeWr/QQsMomuD3xSVUsZTNjtL71OZcyXsVUU9Qi26G8ZfbR9sGEiIQjiqcZaCtHrAPd+8guSaOQye8Cwrj7X4QrqoeElakyGdeI1XjZXV+tTeVjHUVy7F/1+0GarMzhefDVEJRTIjrvPYV7y0PYue3Z/zLPJR7noqJmouNTsUelx2qR1Z1RaipsGK2e8Rv0GLX6BZxSSM/JDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793011829; c=relaxed/relaxed;
	bh=3GpmrM73TajpRkmoorZcEKVSngjXoQOPyN7l23YEKT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMdVffgxwuEe2aUtpiFouqejyT9Z559xPjrGTebfBviqWbcV7mr6hq5VoBMuv4HXZmZ45QIfQJxXonT9kfUmyj4NLkTskBX28NUaHFAa2h0+f1JHyIKGqAzm1cpjkL/q3naIj0Xj9JTZJoYLHp3J1LZ/EPzSEoqQIFmlOsZQ/gHzjIvKQlo8JsDmmNz+qDpzKMO0tMujSAHbbC2VzNRFDR46LHYBQzAPhdAfStjk03XxcmZaIocRm0j3I35fIJmrfvhkZgi5KFYQS/Xex7Kg8uihxYSBc6uJBf/HnIc23/nytKtTPtwXa/EvsoCbLUEa10C1aIyp2voNhFkOF2FOeg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UI3XTHxi; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UI3XTHxi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jCr4h0MvMz2yGT
	for <linux-erofs@lists.ozlabs.org>; Mon, 26 Oct 2026 21:50:27 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9406600CB;
	Mon, 26 Oct 2026 10:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35861F01825;
	Mon, 26 Oct 2026 10:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793011824;
	bh=3GpmrM73TajpRkmoorZcEKVSngjXoQOPyN7l23YEKT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UI3XTHxi2JJpWb7l2uiEQUYFtYbbsKanJf+QH/iSAB2QAB+kEhTFfP16584i9GqQx
	 vUK+HdB6+DhXFczml9zYqREiHyzORlC+fL5UgVXiTel8s7jtf05P9OwNIycTYh7YFT
	 0rP4cJj2eCHeVxnOu2O1hPRzwLizhd+JBGZXeM0XFIzWbJLc2WIs7W52OHK9DsYTwx
	 nBy6xaEE3OWATaBE9nUDlKpzBz3h7ib5Kcp04pYjMDQJsoR61jjhZJG5tUgNSrp9ZZ
	 MarM+VnoDE/pHAx9cPuFHzvMCEldc6VASB0rW2M/bwsmMMY8q0yocf+p4a5HtVfOFA
	 kXFBzjQHHgSEw==
Date: Mon, 26 Oct 2026 11:50:19 +0100
From: Gao Xiang <xiang@kernel.org>
To: Matthew Lear <matthew.lear@raspberrypi.com>
Cc: linux-erofs@lists.ozlabs.org
Subject: Re: mkfs.erofs: --incremental=data segfaults when appending without
 -z to compressed image
Message-ID: <at8wa6YrhxbUrbvW@XiangdeMacBook-Pro.local>
Mail-Followup-To: Matthew Lear <matthew.lear@raspberrypi.com>,
	linux-erofs@lists.ozlabs.org
References: <CAPrOGNCUbo82kEnriuO1UAn+EA5+xZS6EMkAZYgRbgW8afb9eg@mail.gmail.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPrOGNCUbo82kEnriuO1UAn+EA5+xZS6EMkAZYgRbgW8afb9eg@mail.gmail.com>
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Matthew,

On Wed, Oct 21, 2026 at 07:13:18AM -0400, Matthew Lear wrote:
> Hi,
> I've been experimenting with appending to a base erofs image to try and
> optimise for in-place updates. By appending 'volatile' paths (which are
> anticipated to change more frequently between updates) at the end of
> the image, the amount of write IO the device will sustain when applying
> the update is reduced. I've noticed that if appending an erofs image
> created without -z to a base that was created with -z, mkfs.erofs
> segfaults. The compression scheme does not matter (I tested zstd, lzma
> and deflate).
> 
> The reverse is not true - an uncompressed base with a -z append is successful.
> In that case, fsck passes, contents seem intact, the superblock gains
> the compression feature and the appended files appear to be stored
> compressed. The failure only happens one-way.
> 
> I've seen this on an arm64 box (Raspberry Pi 5) but it also happens on
> my x86 box, too:
> 
> Versions
> - erofs-utils 1.9.4
> - dev at 27a171f (1.9.4-g27a171f5)
> 
> Environment: x86_64, Ubuntu 24.04, gcc 13.3.0, libzstd 1.5.5, liblzma
> 5.4.5
> 
> Configured with:
> --with-libzstd --without-selinux --enable-multithreading
> --disable-static --disable-fuse MAX_BLOCK_SIZE=16384
> 
> plus --disable-lzma for the zstd and deflate runs (LZMA enabled for the
> lzma runs).
> 
> Reproduce with:
> 
> mkdir -p b a
> echo base > b/f
> head -c 4097 /dev/zero > a/g
> 
> mkfs.erofs -zzstd i.erofs b
> mkfs.erofs --incremental=data i.erofs a
> 

Sorry I'm very busy these days.

Yes, currently for incremental builds, you need to explicitly pass the
same compression set as the base images.

> Backtrace below:
> 
> Thread 2 "mkfs.erofs" received signal SIGSEGV, Segmentation fault.
> #0  erofs_compress_destsize (c=0x555556177390, src=..., srcsize=...,
> dst=<g_dstbuf+4096>, dstsize=4096) at compressor.c:82
> #1  __z_erofs_compress_one (e=<optimised out>, ctx=<sctx>) at compress.c:634
> #2  z_erofs_compress_one (ctx=<sctx>) at compress.c:796
> #3  z_erofs_compress_segment (ctx=<sctx>, offset=18446744073709551615,
> pstart=4096) at compress.c:1379
> #4  erofs_write_compressed_file (ictx=<optimised out>) at compress.c:2172
> #5  erofs_mkfs_job_write_file (...) at inode.c:1534
> #6  erofs_mkfs_handle_nondirectory (...) at inode.c:1594
> #7  erofs_mkfs_jobfn (...) at inode.c:1666
> #8  z_erofs_mt_dfops_worker (...) at inode.c:1741

It's an explicit ask for now, so that firstly we need to avoid
the segfault and bail out gracefully if the compression set isn't
pass in.

But I agree that we need to read the compression set (by reading
on-disk compression configuration) instead of relying on user
inputs as a future enhancement.

Thanks,
Gao Xiang

> 
> It occurs with zstd, lzma and deflate bases, and with both -b 4096 and
> -b 16384.
> Appending with a different compression algo fails cleanly, eg:
> 
> zstd base + -zlzma append:  <E> erofs: unavailable algorithms 0x2 on
> incremental builds
> lzma base + -zzstd append:  <E> erofs: unavailable algorithms 0x8 on
> incremental builds
> 
> Regards,
> --  Matt
> 

