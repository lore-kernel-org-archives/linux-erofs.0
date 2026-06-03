Return-Path: <linux-erofs+bounces-3514-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A839CD6E55
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jun 2026 14:37:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gVqz52yQfz2ySJ;
	Thu, 04 Jun 2026 00:37:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780497425;
	cv=none; b=LmpZDgqp+eyVFWwxjLxILtAYnRFebuXzq0YnVfGQJOBty3nMazemrw6kNTuU1MTYLB7Qz0HNXdlsUpsWurJssMp20+f+X+3AdotEL54VDWWoMFZWiz0PIpYh5qeqAZHpZnaSQP7paUKfechWMPx6bE4dXrOTl6BxJ5xRDwSJqYMx/ix14t32FVljkDxYiTD5WGPKGML7dcpcV65xZo5AW26u+Hn9CNecPnNgKrbroM33UEclVRe8peKsZ4F4w0LZKVlK/liMzB20yQDS2f+0ZJgaTP9oRwJgHXo9LwOPsbLnHArBOtfG9yoGlLJoxjBr/ztPn2p9ZETK7dVh8oIG6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780497425; c=relaxed/relaxed;
	bh=Is+IQIsWZoPxpiuokcPGWVYcSHSotjom/Ahs+BqduS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJpKxWhttG+FXniZrjaso3p+Wni5Yjqju79/sx0U2R86tdb36ff898rjxV68cXu6a+qWFi16j7C8j/1u8I1rGrbM4dGfVtXhCzGQtAMyPaDXyB8lMS5kldyEIT3yFqwdWZ/qP+uPZEBWRDVBiVy8UcQU4OglJognHXHAO66JBq8keecSspW0KVVf4okgq1m4dmZZcT1UFNIOOsatVxtzEt3QuSpY9S6LOe4HbOpj81Tgm/pVpIu7P/pBFLYqUJYlWWWIblZP75mviEgW5f2nkEvOiU2FfG9Br7xto5VmCqsxhw9zByyz390unqrBU91P68KB9MUYb5nlDXsemZuuhg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L3ddzUxC; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L3ddzUxC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gVqz352JBz2xk7
	for <linux-erofs@lists.ozlabs.org>; Thu, 04 Jun 2026 00:37:03 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 175BD602BE;
	Wed,  3 Jun 2026 14:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198B41F0089C;
	Wed,  3 Jun 2026 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780497420;
	bh=Is+IQIsWZoPxpiuokcPGWVYcSHSotjom/Ahs+BqduS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L3ddzUxCWoRNpZBvMXGKG4ohEQwRXvxwHNAGPkoEAv4ORBlktAtL4chqjN4Yt8tfU
	 WZXeN+tkIfggfPC9f+C/NTDMFz854pzgr/IFrXtLJT2arw21VAovtLl3gCdQfzFfkD
	 vJvcgCl8CUbBUwKSYjfnOnL5mWx/KkFjBq0sLzp2bzSuxpgQ+HJiXVPviC/ds2Ahmu
	 Jk34AlYOlejrHgME82mP99AMl9YDFZz5Cp9dgoo+e/XBa68Qw/7V7AKyfsgyeQyI3Z
	 /TUYJhc00tYPJdzNBstimdJd9rYME7YbaTtmgQqq2fHmBuif5jgJJkdf9iU78asUuH
	 5Ows/9KY9Oqrg==
Date: Wed, 3 Jun 2026 22:36:50 +0800
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <zhaoyifan28@huawei.com>
Cc: linux-erofs@lists.ozlabs.org, guoxuenan@huawei.com,
	zhukeqian1@huawei.com
Subject: Re: [PATCH] erofs-utils: build: link tools with liberofs dependencies
Message-ID: <aiA8AhQvFtK_QMwb@debian>
Mail-Followup-To: Yifan Zhao <zhaoyifan28@huawei.com>,
	linux-erofs@lists.ozlabs.org, guoxuenan@huawei.com,
	zhukeqian1@huawei.com
References: <20260529071702.981596-1-zhaoyifan28@huawei.com>
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
In-Reply-To: <20260529071702.981596-1-zhaoyifan28@huawei.com>

Hi Yifan,

On Fri, May 29, 2026 at 03:17:02PM +0800, Yifan Zhao wrote:
> liberofs.la is a noinst libtool archive, so relying on its
> dependency_libs to carry external libraries is not enough for
> static-only dependencies.
> 
> For example, when liblzma is installed as a static libtool archive,
> libtool consumes -llzma while creating liberofs.la but does not record it
> in dependency_libs.  The final tools then link only with liberofs.la and
> fail with undefined lzma_* references.
> 
> Collect liberofs external libraries in LIBEROFS_LIBS and use it for both
> liberofs.la and the final tools, so final executable links see the
> pkg-config supplied liblzma flags directly.
> 
> Reported-by: Guo Xuenan <guoxuenan@huawei.com>
> Fixes: 6c2a000782b2 ("erofs-utils: lib: add test for s3erofs_prepare_url()")
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---
> To reproduce link error:
> 
>     ./autogen.sh
>     PKG_CONFIG_PATH=/path/to/xz-static/lib/pkgconfig ./configure
>     make -j
> 
> Then {mkfs,dump,fsck}.erofs reports missing lzma_* symbol as `-llzma`
> missing in ld flags.
> 
>  configure.ac      | 17 +++++++++++++++++
>  dump/Makefile.am  |  2 +-
>  fsck/Makefile.am  |  4 ++--
>  fuse/Makefile.am  |  5 +++--
>  lib/Makefile.am   | 14 +++-----------
>  mkfs/Makefile.am  |  2 +-
>  mount/Makefile.am |  2 +-
>  7 files changed, 28 insertions(+), 18 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index f68bb74..17b4856 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -790,6 +790,23 @@ AM_CONDITIONAL([ENABLE_STATIC_FUSE], [test "x${enable_static_fuse}" = "xyes"])
>  AM_CONDITIONAL([ENABLE_OCI], [test "x${have_oci}" = "xyes"])
>  AM_CONDITIONAL([ENABLE_FANOTIFY], [test "x${have_fanotify}" = "xyes"])
>  
> +LIBEROFS_LIBS="${libselinux_LIBS} ${libuuid_LIBS} ${liblz4_LIBS} \
> +${liblzma_LIBS} ${zlib_LIBS} ${libdeflate_LIBS} ${libzstd_LIBS} \
> +${libqpl_LIBS} ${libcurl_LIBS} ${openssl_LIBS} ${json_c_LIBS}"
> +AS_IF([test "x${have_xxhash}" = "xyes"], [
> +  LIBEROFS_LIBS="${LIBEROFS_LIBS} ${libxxhash_LIBS}"
> +])
> +AS_IF([test "x${have_s3}" = "xyes"], [
> +  LIBEROFS_LIBS="${LIBEROFS_LIBS} ${libxml2_LIBS}"
> +])
> +AS_IF([test "x${enable_multithreading}" != "xno"], [
> +  LIBEROFS_LIBS="${LIBEROFS_LIBS} -lpthread"
> +])
> +AS_IF([test "x${build_linux}" = "xyes"], [
> +  LIBEROFS_LIBS="${LIBEROFS_LIBS} ${libnl3_LIBS}"
> +])

Although I admit that I'm not super happy with this approach, but it
seems that we have to do like this.

My only question here is that why  ${libxxhash_LIBS},  ${libxml2_LIBS}
and ${libnl3_LIBS} cannot be appended directly to LIBEROFS_LIBS as
others.

But I think it's fine to guard `-lpthread` with enable_multithreading
tho.

Thanks,
Gao Xiang

