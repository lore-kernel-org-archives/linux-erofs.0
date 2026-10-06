Return-Path: <linux-erofs+bounces-4666-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3EACA5FED
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Oct 2026 20:51:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hzpMX6xW6z30TL;
	Wed, 07 Oct 2026 07:51:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791319896;
	cv=none; b=U6uoA4ytx6rsJsOhdeOiLKJ5xw7+2aGstCwDqNnLxAs6f4QxuqavDcSKC7KNADxG3BnavM46eQ8mhdoUOGsexD+sOBmcBSOqJbLfdjj8nCZg5nYj9E8vYAZThVjaQ1IOYlZj5I04Yr/jH9UDScamywMchGwpM8yBhKNPbbrN5z0gEUfBq4BDwE/kzXPm92L7oh9+U1iax2gZe0cYOZmErh9mT8gkrDbxlQZleI6y27qs+3WUHE01XW20V+N299FBIIRPsYBDOtM3ZdxjF4sLXFvY9PFrCsEqKY/TwZLWF1Ht4a9zUFqRoTmqZqBwJvXHryrG6dcirQrv203GgzytFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791319896; c=relaxed/relaxed;
	bh=Vpdak+cFgkiyO1RxFnFXzxZB4anoQzzDSQ5d90bf3FA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/RDJWT7fB4fXxJjcrwbucgvGCckbU1Kwz1SBR1phF/p2wX1SM5/EKllMYQTqXWSpI91eG31EztIfti9thWTfrLiyEDzNRWDCPECxSwaWZQuUXSWPDMzwvwcPQ77hNGBVuat6whFSzwi51oDmENvYr7wq/j3Oi6TnORoVAoU/3efVSqtMFdd99TuVUYKZZdYUPJyoTAE/p4ftS/RQlvQr4kTn8yOvIemxhotBMu2dWqYf1ejo1CQqSaLNyyyYEPrGXrOAqxxyiIuiQtlKXZWt8WdUtQQ1XPKPKt3rXIZxSwDnJDbGk185Fvh8IBnZ6dStu6tJsTUyBG1yXpbWLIPSQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9+Ek8ll; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9+Ek8ll;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hzpMX0RNNz30Sx
	for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 07:51:36 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 426E3600C8;
	Tue,  6 Oct 2026 20:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06891F0089B;
	Tue,  6 Oct 2026 20:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791319893;
	bh=Vpdak+cFgkiyO1RxFnFXzxZB4anoQzzDSQ5d90bf3FA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i9+Ek8llbgQSk+3g7tyv0zV15F+ictwgTaDQhaUF4UboErEsue9W0FmtfQTCnxP6z
	 SWV8L+i+we6nyHS/9w/BB6+1a4CW0WuIhwrGp7wMr8FwFnieyXKsVY0ashcDJ/1e7U
	 I+t3+hLbGYk8NAf2GjBA0xMrYMsbEPhbCnio+6Owj5CnNVB7r1Cpb0QWc4dIz2PH9B
	 qi445NBbLhLPReZt7u0yMeynbeoHB2QdLxoUa13CEKG4n/UOiS2Tmrk1v4A8M+cB4l
	 hB8kEzsmPciEMMqUX4WaPwHjawlSCTJrMB+136Lr9KnKtiFMGaQQOBPl6NevMV2bkR
	 xlgu3u5VkYsJw==
Date: Tue, 6 Oct 2026 22:51:28 +0200
From: Gao Xiang <xiang@kernel.org>
To: sadmanf@meta.com
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH RESEND 1/2] erofs-utils: lib: fail instead of hanging on
 short reads in erofs_io_xcopy()y
Message-ID: <asVfUMg4MmTLHtj-@MacBookPro>
Mail-Followup-To: sadmanf@meta.com, linux-erofs@lists.ozlabs.org,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
References: <20261006-round1-v1-0-f46b13e11de5@meta.com>
 <20261006-round1-v1-1-f46b13e11de5@meta.com>
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
In-Reply-To: <20261006-round1-v1-1-f46b13e11de5@meta.com>

Hi Sadman,

On Tue, Oct 06, 2026 at 02:04:47PM -0400, Sadman Fahmid via B4 Relay wrote:
> From: Sadman Fahmid <sadmanf@meta.com>
> 
> erofs_io_xcopy() falls back to a read/pwrite loop for whatever
> copy_file_range() and sendfile() did not copy.  If the source reaches
> EOF before `len` bytes have been copied, erofs_io_read() returns 0,
> `len` never shrinks and mkfs spins forever instead of reporting the
> error.
> 
> This is easy to hit with a damaged source, e.g. rebuilding with
> `mkfs.erofs --clean=data out.img src.img` where src.img is truncated
> in the middle of a file's data, or when a source file shrinks while
> mkfs runs.  Return -EIO instead.
> 
> While at it, keep calling copy_file_range() until it has copied the
> whole range or fails.  A single call may copy less than requested
> (e.g. the kernel caps each call at MAX_RW_COUNT, just under 2 GiB,
> while callers pass chunks of up to 4 GiB), and the remainder was
> previously copied by sendfile() instead of being reflinked.
> 
> Signed-off-by: Sadman Fahmid <sadmanf@meta.com>
> ---
>  lib/io.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/io.c b/lib/io.c
> index 5c5449f..038fa51 100644
> --- a/lib/io.c
> +++ b/lib/io.c
> @@ -642,9 +642,13 @@ int erofs_io_xcopy(struct erofs_vfile *vout, off_t pos,
>  		off_t ret __maybe_unused;
>  
>  #ifdef HAVE_COPY_FILE_RANGE
> -		ret = copy_file_range(vin->fd, NULL, vout->fd, &pos, len, 0);
> -		if (ret > 0)
> +		while (len) {
> +			ret = copy_file_range(vin->fd, NULL, vout->fd, &pos,
> +					      len, 0);
> +			if (ret <= 0)
> +				break;
>  			len -= ret;
> +		}
>  #endif
>  #if defined(HAVE_SYS_SENDFILE_H) && defined(HAVE_SENDFILE)
>  		if (len && !noseek) {
> @@ -660,21 +664,20 @@ int erofs_io_xcopy(struct erofs_vfile *vout, off_t pos,
>  #endif
>  	}
>  
> -	do {
> +	while (len) {
>  		char buf[32768];
> -		int ret = min_t(unsigned int, len, sizeof(buf));


Thanks for the patch.

I just have one question, could the overflow here be resolved
by
		int ret = min_t(s64, len, sizeof(buf));

Since ret won't exceed sizeof(buf) now.

Otherwise it looks good to me.

Thanks,
Gao Xiang

