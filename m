Return-Path: <linux-erofs+bounces-4708-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC95DCA9ED0
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 16:23:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3N7516MGz3bdq;
	Tue, 13 Oct 2026 03:23:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791822193;
	cv=none; b=aNgNZsdYS5+D7w3BzV76u3Sc0In9XvFOA5nyVDEzdbpn700D98xJvTLJMgpP8ZdtqZraYBmI2171OOs2/sz1r5ovpDRI7/hxWToYj8Wrq5LPRpsMYkcc/jvsAB/1Vh28C17Ecj4lx6h+T7RThKQX7izZ+oHgS0AvscydnPJQN7iqyYX3UJopoRmaXc84ZfsD2/F8JuncEAq/uWhWPV+SYDwi01PdlCVOGRcfwq0kbgJToKZeysWeacT7Mneuqmxh7d6DuyAB0ugTFLPKpcpoHeEzWj5f2jzRq19lqCULVCCU1OU7PsxVYgirmB8ccA2TqWgrAfjbWPZUckzEZ+y/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791822193; c=relaxed/relaxed;
	bh=+NrO4pBu2qGs0CONcNp7yNgWTs73KFTjj5ZvduOqD98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RUDCb/LFCaQPcN8z0OwcU8qCxC+apMI7vRXEndTzfnsVpqWL78I8Qb/xcb+AHh06iRec6XFV3pB28Z2e0nvanHZoczjf0xcWCvCDpvaZ5vAvF2/zp16FbZWYEcXtO3gl5DhxQPvvlEBWsY0JPpkLAv7BjrLwm+3aPsXhPvHn/eOClRb7ODfQS6YWqXordEutKKR66Qxo9PIDvoMrDpcjFyHc6uTdlUJfSUD+2gnfuXmVl+E6gEfUu7svOirOlZBgF/NV8ta1iUCxm6ZjH6ac9M7fs5YpITZzW0HqZ/SFXByowyVPUG6Fjbh15zVGotWlrnnoJjiSxyVgkFRcpFN1ig==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoQezf1+; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoQezf1+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3N7333Nnz30HB
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 03:23:11 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EAEB40976;
	Mon, 12 Oct 2026 16:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C380F1F0089B;
	Mon, 12 Oct 2026 16:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791822188;
	bh=+NrO4pBu2qGs0CONcNp7yNgWTs73KFTjj5ZvduOqD98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aoQezf1+3FH5asE+xZdilwRBZggDGInsRkIPQGUSwmGuccTxoynGxGJ+j4GddumFE
	 wWwITSa0usmVpYVq10j52i2/tvAerVpn2oaJUkpVbKUtsIVdYNVjwZCItnbWXrxw9x
	 NhVNGaTJGEevbN1mUon/l9/yxmDn+rwzryrXadU/IKIcb6bsGdqS4atebLgUgaL5eI
	 RMKL5iarBHdUocCuiqAEbeLHXt6qoo82sE2TUW+yhT8IfckburG+pBjUnzziSmdMK8
	 TpLvQV+wdv0roC1ivuyjlQTl5sv5xPGa30zUi2TWiOjqIvRfLIc0fTxkFqHdsRGf4D
	 wPX2jeUeBWE8w==
Date: Mon, 12 Oct 2026 18:23:00 +0200
From: Gao Xiang <xiang@kernel.org>
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	hch@infradead.org
Subject: Re: [PATCH v7 2/2] erofs: reuse superblock for file-backed mounts
Message-ID: <as0JZCSfTBo0e3Lq@XiangdeMacBook-Pro.local>
Mail-Followup-To: Giuseppe Scrivano <giuseppe@scrivano.org>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	hch@infradead.org
References: <20261002163225.1258203-1-giuseppe@scrivano.org>
 <20261002163225.1258203-3-giuseppe@scrivano.org>
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
In-Reply-To: <20261002163225.1258203-3-giuseppe@scrivano.org>

On Fri, Oct 02, 2026 at 06:31:44PM +0200, Giuseppe Scrivano wrote:
> When the same file-backed image is mounted multiple times (via path or
> fd) with the superblock_share mount option, reuse the existing
> superblock instead of creating a new one.  This allows multiple mounts
> of the same image to share in-kernel data structures more efficiently.
> 
> The backing file is identified by its inode and fsoffset.  If mount
> options conflict or extra devices are used, a separate superblock
> is created transparently as a fallback.  Remount is not allowed on
> shared superblocks.
> 
> Tested by mounting a 177M Fedora EROFS image 20 times with full
> traversal:
> 
>   #!/bin/sh
>   IMG=${1:-/root/fedora.erofs}
>   OPTS=${2:+-o $2}
>   N=20
>   DIR=$(mktemp -d)
>   trap "umount $DIR/m* 2>/dev/null; rm -rf $DIR" EXIT
> 
>   sync; echo 3 > /proc/sys/vm/drop_caches
>   INODES_BEFORE=$(grep erofs_inode /proc/slabinfo | awk '{print $2}')
>   MEM_BEFORE=$(grep ^Slab: /proc/meminfo | awk '{print $2}')
> 
>   for i in $(seq 1 $N); do
>       mkdir $DIR/m$i
>       mount -t erofs $OPTS "$IMG" $DIR/m$i
>       find $DIR/m$i > /dev/null
>   done
> 
>   echo "Superblocks: $(grep $DIR /proc/self/mountinfo | \
>       awk '{print $3}' | sort -u | wc -l)"
>   echo "erofs_inode delta: +$(( $(grep erofs_inode /proc/slabinfo | \
>       awk '{print $2}') - INODES_BEFORE ))"
>   echo "Slab delta: +$(( $(grep ^Slab: /proc/meminfo | \
>       awk '{print $2}') - MEM_BEFORE )) kB"
> 
> without superblock_share:
> 
>   # time ./test.sh /root/fedora.erofs
>   Superblocks: 20
>   erofs_inode delta: +45864
>   Slab delta: +37448 kB
>   real	0m2.311s
>   user	0m0.222s
>   sys	0m1.998s
> 
> with superblock_share:
> 
>   # time ./test.sh /root/fedora.erofs superblock_share
>   Superblocks: 1
>   erofs_inode delta: +2044
>   Slab delta: +284 kB
>   real	0m0.679s
>   user	0m0.157s
>   sys	0m0.469s
> 
> The time difference shows that sharing the superblock also benefits
> the page cache and inode cache, as subsequent mounts of the same image
> avoid re-reading the backing file.  This is particularly useful for
> container hosts running multiple containers from the same base image.
> 
> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>

Reviewed-by: Gao Xiang <xiang@kernel.org>

And applied to -next.

Thanks,
Gao Xiang

