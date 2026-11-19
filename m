Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05154606A320
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 21:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OhcmJSW+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVrsd2Kzbz2xLh;
	Fri, 20 Nov 2026 08:17:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795123077;
	cv=none; b=lBDMPTa1FQskc+3KUGdePmV/3uHVkowWwwswbLNfZVhiAT5ZYNj/mXaNitaTC0k4v8aEFlp56k9SThj+kecroLOyaRv27MuE6bV9zF1SrCokexXYLSDPCC5penpyEOvUuPedWrH/vzkp972NmwzwT84X74ow8j0UUwbdCNBmSogbTbJLqNpZWexwOoUnmJVY66zigEpyRccaS1+AM5xTtbCkF2/ZEhyQUdmVqzAcUg7ESkoGPXdEnTHB8k5O3JAwReSmbyPOLr3NSmfcqTEZuB80+MBQc/E7N8sGPa0mkRIRvJoEE81rrQZ2foXzLGF+MlFsbpkMHA74M+NqeyoY4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795123077; c=relaxed/relaxed;
	bh=Fse7p9SsspMc7R+vIhuooBKhCKsbu9xtP3buzFRAVxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNkymxbQw6DpAb0iFc6X1DVjJ+bDlIZarC/urNq0C7erIdmbswHqkP/6XmnEEKkQTBMGNL+QnYUZ/a21PIK5+xT2e0z+Hx9z8kxsrl/JE4Xeh9fjx/dscxRzkNqwt7LQK/+4lQ1fE4ykqKTHOHcrIeLpBKv373uXQZZTdsgD3g1MlIDcdk/sC7NCX7/4phwZZrwz06zEWBE3LuhA/TVA6bry3izPTRANls9edIo87Ik9RsneDvr7Y6/BaIbMF6k4qsblaIN6wXw/a8lO576qoyOsmf5Up+LufmivCkDDFBa8xiOXJQsah+71OHR3OnH/yDHPx+bduKOyUtBd9UF48w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OhcmJSW+; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OhcmJSW+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVrsc4rDtz2xLF
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 08:17:56 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1643060416;
	Thu, 19 Nov 2026 21:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00021F000C6;
	Thu, 19 Nov 2026 21:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795123073;
	bh=Fse7p9SsspMc7R+vIhuooBKhCKsbu9xtP3buzFRAVxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OhcmJSW+nehYY3c7/OCCcVRGjCMN25K8S9b1UYXtuiQ1qDL2wWHpMOazcNpCRIVvJ
	 OMe3AdIyhF/t+S7TqEJlqMy5EBxG4XkDZzSpQJaIMSZF5J/De+l36MC3N/HOiBXy7m
	 uYPxtEGS+QC3d2rgrJWPyTyHeqcL5/CKCfmmRSaDcgMHMNXs6xzFgkVuGJR+nfRBCX
	 9hKAwlxRq9T/SlhiSVyEDGrV6bFEpra4/K0q9JEVxbUd7zA4Szr3vm3LvM+upB49GU
	 3FqSjRho6zvKl2UwXK2+QwO+VtNu2o2wecFWhIT1oLoEd4kBUWwK6+e4Y7TTxLa929
	 0ETJmYNOmVmmA==
Date: Thu, 19 Nov 2026 22:17:47 +0100
From: Gao Xiang <xiang@kernel.org>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org, shengyong1@xiaomi.com,
	yangyongpeng@xiaomi.com, qiwenjie@xiaomi.com
Subject: Re: [PATCH] erofs: enable buffered RWF_DONTCACHE reads
Message-ID: <av9ne1tKVIBQgCI0@MacBookPro.fritz.box>
Mail-Followup-To: Wenjie Qi <qwjhust@gmail.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org, shengyong1@xiaomi.com,
	yangyongpeng@xiaomi.com, qiwenjie@xiaomi.com
References: <b168501806b41e3f0be15efec4b54b371d8dd4e1.1795059802.git.qiwenjie@xiaomi.com>
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
In-Reply-To: <b168501806b41e3f0be15efec4b54b371d8dd4e1.1795059802.git.qiwenjie@xiaomi.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 11:52:50AM +0800, Wenjie Qi wrote:
> From: Wenjie Qi <qiwenjie@xiaomi.com>
> 
> EROFS uses filemap_read() for buffered reads, including the inode-sharing
> path, which preserves request flags when cloning the kiocb.
> 
> Advertise FOP_DONTCACHE in both file operation tables so preadv2() callers
> can request that newly instantiated file-cache folios be dropped after
> consumption. This is useful for one-pass reads that need not retain data
> in the page cache.
> 
> For compressed reads, retain trailing readmore and propagate dropbehind
> to the single-folio neighbor lookup. Readahead expansion already marks
> new folios through readahead_control. Suppress prefix readmore so it
> cannot refill pages already consumed and evicted. Ordinary readmore is
> unchanged.
> 
> Tested sequential reads of 1-GiB files with 1-MiB requests on NVMe-backed
> LZ4 and Zstd EROFS images in x86-64 QEMU/KVM with two vCPUs and 2 GiB RAM.
> Each reader ran with memory.max=255852544 (244 MiB) and
> memory.swap.max=0. Normal and dontcache ran in ten paired rounds per
> layout, alternating their order and using a fresh guest for each run.
> 
> Results are arithmetic means of ten runs. Memory values average the
> run-level time-weighted memory.current means. Percentage changes are
> relative to normal reads:
> 
>                     MiB/s                  Mean memory, MiB
>  Layout   normal/dontcache  change    normal/dontcache  change
>  LZ4      2513.57/6350.61  +152.65%      169.53/17.39   -89.74%
>  Zstd     2535.57/4066.49   +60.38%      179.01/18.17   -89.85%
> 
> In this test, dontcache reduced average cgroup memory by about 90%,
> left no consumed file pages resident and recorded no memcg reclaim
> scans or steals. Both layouts were faster in all ten pairs. This
> offers a smaller cache footprint for one-pass reads on memory-constrained
> systems.
> 
> Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
> Reviewed-by: Yongpeng Yang <yangyongpeng@xiaomi.com>

Yeah, that was in my own plan too but I never find a slot, thank you.

It would be useful for one-time load on large files like AI models
and these numbers are impressive:

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

