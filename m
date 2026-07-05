Return-Path: <linux-erofs+bounces-3817-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41084C43458
	for <linux-erofs@archiver.kernel.org>; Sun,  5 Jul 2026 14:00:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gtTfB06h3z2yRM;
	Mon, 06 Jul 2026 00:00:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783260033;
	cv=none; b=XOEgHmqSaTKiFZRwvyfE0eZIGKXHb/q09Swd5nyqiYiGdfC1GVXtRkglKJ5PdHXsDo5nQKdBzZR/RS/O0JbRX9JtyMgwNsQsBp3Q2ZAYzbZfGvORd1W1+YfVYElUF3OaYuUI8MGjqpN2P/v2iQjvp86k2ritIfEywpdyvUT2TnkDGCktuFpVfSSy3Qx37QTQehXM2q1svh1BUW8nNnENd4wWe3/+yg8QY2xdL4mXwCDUcAtV+0zylI9li/fTjQl2gQiJh4ssRidViAShlniJMcWoL0vtVq+PaBNOc0Sy1HVLHlukOUNT3Q1UJiSoAOlDVypeS/G3dc2W0ao0pCh4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783260033; c=relaxed/relaxed;
	bh=DeTmob8IHGPQhXqJ5xzuwTDaZwRRR7mbiYM+s61QcXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjWClUkTJESNqWcRmlvBO5w38jYh3680RLZYNx4VC5DBefKJdpHyIlJcf0AYYEmf0j8hLEi5hsdv2gaKzo+4QmFf1XMQ8yQ9fa+fXJl03Yh6nMVI2k9+fuOQPdLTWWjtyv1+3X33yItEMjEWI+x8i5+mto4gFwhGJzDDLb7H2BAlW9m1pheZ+epFBQ7x/UHhN8HUTBuogdVWBiTdh38L6Ti3uIwbjegTbo0aQmCa6rbS36y0R1WJUoPIUk68GKHeL8fjCZCNowAbRs4I1fchmaba4gyupOz12C2Fz+pEvQR49fB6wl8GxudyCjSFuWwxanrpkkX+QoKS4W9YnhUezw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HqjEqs0U; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HqjEqs0U;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gtTf84Mjdz2xYg
	for <linux-erofs@lists.ozlabs.org>; Mon, 06 Jul 2026 00:00:32 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72A106138A;
	Sun,  5 Jul 2026 14:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA431F000E9;
	Sun,  5 Jul 2026 14:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783260029;
	bh=DeTmob8IHGPQhXqJ5xzuwTDaZwRRR7mbiYM+s61QcXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HqjEqs0UY2OrAaYW/Mxuw1AZ++Sx1jHu/VJHhmJiVxBN08mALFwvIOGyi+aV6UtcI
	 onIn6Kk76JWznuVdb8lZrY0QAQm9P1+VLzfCx/jj5XjytqEtKN0JFFaxRMYB474BcI
	 9MnxUrBUVcAMp7mte59OWQPBFfR1IAxlgDus2hFyrTBtntHc9xHd//AreE+ivTRScW
	 GNsTEFG9gDTQeOspqXMnXnOxW9wkOmwm223d65qSfvsKXBtgsHzpxArU/dCGFxkPMN
	 Ht6G4RNBEk9K/icNr7z2GiwKYnIvTDrf5/1P/Kw4DWH2K7is3bKz4HdkJFoEMtp6gC
	 Fru/9ySVPjhRw==
Date: Sun, 5 Jul 2026 22:00:23 +0800
From: Gao Xiang <xiang@kernel.org>
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: Re: [PATCH 1/2 v2] fsck.erofs: add multi-threaded decompression
Message-ID: <akpjd2Cgu-nlCkLR@debian>
Mail-Followup-To: Nithurshen <nithurshen.dev@gmail.com>,
	hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
References: <20260621120121.73114-2-nithurshen.dev@gmail.com>
 <20260629095529.58597-1-nithurshen.dev@gmail.com>
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
In-Reply-To: <20260629095529.58597-1-nithurshen.dev@gmail.com>

On Mon, Jun 29, 2026 at 03:25:29PM +0530, Nithurshen wrote:
> Currently, fsck.erofs extracts files synchronously. When decompressing
> heavily packed images, the main thread spends the majority of its time
> blocked on a combination of synchronous vfs_write() syscalls and
> decompression routines, bottlenecking overall extraction speed.
> 
> This patch introduces a scalable, multi-threaded decompression framework
> using the existing erofs_workqueue infrastructure to decouple compute
> from the main thread's I/O.
> 
> To prevent massive scheduling overhead (futex contention) where worker
> threads spend more CPU time waking up than actually decompressing small
> clusters, this implementation introduces a batching context. Because
> different compression algorithms exhibit vastly different scheduling
> thresholds, the batch size is algorithm-aware:
> - Fast algorithms like LZ4 utilize a larger batch limit (up to 32
>   pclusters) to effectively hide synchronization overhead.
> - Compute-heavy algorithms like LZMA or ZSTD trigger at a lower
>   threshold (8 pclusters) to prevent memory bloat and thread starvation.
> 
> Key details of this implementation:
> - The worker pool is dynamically sized based on available system CPUs.
> - Decompression tasks take strict ownership of the raw and output
>   buffers (safely tracking memory via a `free_out` flag) to prevent
>   data races and memory leaks.
> - Output buffers are explicitly zero-initialized via calloc() to
>   prevent trailing garbage bytes from leaking into extracted files.
> - Tail-end packed fragments are processed synchronously by the main
>   thread, as their minimal overhead does not benefit from asynchronous
>   offloading.
> 
> Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
> ---
>  fsck/main.c              | 122 +++++++------------
>  include/erofs/cond.h     |  31 +++++
>  include/erofs/internal.h |  15 ++-
>  include/erofs/lock.h     |   3 +
>  lib/data.c               | 254 +++++++++++++++++++++++++++++++--------
>  lib/global.c             |  15 +++
>  6 files changed, 307 insertions(+), 133 deletions(-)
>  create mode 100644 include/erofs/cond.h
> 
> diff --git a/fsck/main.c b/fsck/main.c
> index 16cc627..c427a70 100644
> --- a/fsck/main.c
> +++ b/fsck/main.c
> @@ -8,11 +8,13 @@
>  #include <time.h>
>  #include <utime.h>
>  #include <unistd.h>
> +#include "erofs/lock.h"
>  #include <sys/stat.h>
>  #include "erofs/print.h"
>  #include "erofs/decompress.h"
>  #include "erofs/dir.h"
>  #include "erofs/xattr.h"
> +#include "erofs/workqueue.h"
>  #include "../lib/compressor.h"
>  #include "../lib/liberofs_compress.h"
>  
> @@ -509,40 +511,31 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd)
>  		.buf = __EROFS_BUF_INITIALIZER,
>  	};
>  	bool needdecode = fsckcfg.check_decomp && !erofs_is_packed_inode(inode);
> -	int ret = 0;
> -	bool compressed;
> +	int ret = 0, wait_err;
> +	bool compressed = erofs_inode_is_data_compressed(inode->datalayout);
>  	erofs_off_t pos = 0;
>  	u64 pchunk_len = 0;
> -	unsigned int raw_size = 0, buffer_size = 0;
> -	char *raw = NULL, *buffer = NULL;
> +	struct z_erofs_mt_read_ctx *ctx;
> +
> +	ctx = z_erofs_mt_read_ctx_alloc(outfd, true);
> +	if (!ctx)
> +		return -ENOMEM;
>  
>  	erofs_dbg("verify data chunk of nid(%llu): type(%d)",
> -		  inode->nid | 0ULL, inode->datalayout);
> +		inode->nid | 0ULL, inode->datalayout);

I'm still not sure why this line needs to be changed.

>  
> -	compressed = erofs_inode_is_data_compressed(inode->datalayout);
>  	while (pos < inode->i_size) {
> -		unsigned int alloc_rawsize;
> -
>  		map.m_la = pos;
>  		ret = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_FIEMAP);
>  		if (ret)
>  			goto out;
>  
> -		if (!compressed && map.m_llen != map.m_plen) {
> -			erofs_err("broken chunk length m_la %" PRIu64 " m_llen %" PRIu64 " m_plen %" PRIu64,
> -				  map.m_la, map.m_llen, map.m_plen);
> -			ret = -EFSCORRUPTED;
> -			goto out;

Where is the check now?

> -		}
> -
> -		/* the last lcluster can be divided into 3 parts */
>  		if (map.m_la + map.m_llen > inode->i_size)
>  			map.m_llen = inode->i_size - map.m_la;
>  
>  		pchunk_len += map.m_plen;
>  		pos += map.m_llen;
>  
> -		/* should skip decomp? */
>  		if (map.m_la >= inode->i_size || !needdecode)
>  			continue;
>  
> @@ -555,85 +548,53 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd)
>  			continue;
>  		}
>  
> -		if (map.m_plen > Z_EROFS_PCLUSTER_MAX_SIZE) {
> -			if (compressed && !(map.m_flags & __EROFS_MAP_FRAGMENT)) {
> -				erofs_err("invalid pcluster size %" PRIu64 " @ offset %" PRIu64 " of nid %" PRIu64,
> -					  map.m_plen, map.m_la,
> -					  inode->nid | 0ULL);
> -				ret = -EFSCORRUPTED;
> -				goto out;
> -			}

Where is the check now?

> -			alloc_rawsize = Z_EROFS_PCLUSTER_MAX_SIZE;
> -		} else {
> -			alloc_rawsize = map.m_plen;
> -		}
> -
> -		if (alloc_rawsize > raw_size) {
> -			char *newraw = realloc(raw, alloc_rawsize);
> -
> -			if (!newraw) {
> +		if (compressed) {
> +			size_t buffer_size = map.m_llen > erofs_blksiz(inode->sbi) ? 
> +				map.m_llen : erofs_blksiz(inode->sbi);

Can you explain why?

> +			char *raw, *buffer;
> +			raw = malloc(map.m_plen);
> +			buffer = calloc(1, buffer_size);
> +			
> +			if (!raw || !buffer) {
> +				free(raw);
> +				free(buffer);
>  				ret = -ENOMEM;
>  				goto out;
>  			}
> -			raw = newraw;
> -			raw_size = alloc_rawsize;
> -		}
>  
> -		if (compressed) {
> -			if (map.m_llen > buffer_size) {
> -				char *newbuffer;
> -
> -				buffer_size = map.m_llen;
> -				newbuffer = realloc(buffer, buffer_size);
> -				if (!newbuffer) {
> -					ret = -ENOMEM;
> -					goto out;
> -				}
> -				buffer = newbuffer;
> +			ret = z_erofs_read_one_data(inode, &map, raw, buffer, 0, map.m_llen, 
> +				false, map.m_la, ctx);
> +			if (ret) {
> +				goto out;
>  			}
> -			ret = z_erofs_read_one_data(inode, &map, raw, buffer,
> -						    0, map.m_llen, false);
> +		} else {
> +			char *raw = calloc(1, map.m_llen);
> +			ret = erofs_read_one_data(inode, &map, raw, 0, map.m_llen);
> +			if (ret >= 0 && outfd >= 0)
> +				pwrite(outfd, raw, map.m_llen, map.m_la);
> +			free(raw);
>  			if (ret)
>  				goto out;
> -
> -			if (outfd >= 0 && write(outfd, buffer, map.m_llen) < 0)
> -				goto fail_eio;
> -		} else {
> -			u64 p = 0;
> -
> -			do {
> -				u64 count = min_t(u64, alloc_rawsize,
> -						  map.m_llen);
> -
> -				ret = erofs_read_one_data(inode, &map, raw, p, count);
> -				if (ret)
> -					goto out;
> -
> -				if (outfd >= 0 && write(outfd, raw, count) < 0)
> -					goto fail_eio;
> -				map.m_llen -= count;
> -				p += count;
> -			} while (map.m_llen);
>  		}
>  	}
> +	z_erofs_mt_read_enqueue(ctx);
> +
> +out:
> +	wait_err = z_erofs_mt_read_ctx_wait(ctx);
> +	if (wait_err < 0 && ret >= 0)
> +		ret = wait_err;
>  
>  	if (fsckcfg.print_comp_ratio) {
>  		if (!erofs_is_packed_inode(inode))
>  			fsckcfg.logical_blocks += BLK_ROUND_UP(inode->sbi, inode->i_size);
>  		fsckcfg.physical_blocks += BLK_ROUND_UP(inode->sbi, pchunk_len);
>  	}
> -out:
> -	if (raw)
> -		free(raw);
> -	if (buffer)
> -		free(buffer);
> -	return ret < 0 ? ret : 0;
>  
> -fail_eio:
> -	erofs_err("I/O error occurred when verifying data chunk @ nid %llu",
> -		  inode->nid | 0ULL);
> -	ret = -EIO;
> -	goto out;
> +	if (outfd >= 0 && ret >= 0)
> +		ftruncate(outfd, inode->i_size);

Why ftruncate here?


In short, it seems that you remove a lot sanity checks, if you
touch the existing logic, please explain why it's safe to remove
them.

Also please show valid benchmark results (at least with enough
sizes, and the decompression should take many seconds), so I can
imagine it's a good improvement.

Thanks,
Gao Xiang

