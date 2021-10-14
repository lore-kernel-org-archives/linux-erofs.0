Return-Path: <SRS0=6UYs=PC=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9673C433EF
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Oct 2021 01:46:13 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44C1461181
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Oct 2021 01:46:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 44C1461181
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HVC0z6jpXz2yp8
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Oct 2021 12:46:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=J+9z2m9w;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=J+9z2m9w; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HVC0w72njz2xvP
 for <linux-erofs@lists.ozlabs.org>; Thu, 14 Oct 2021 12:46:08 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5469960E78;
 Thu, 14 Oct 2021 01:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1634175966;
 bh=tua+i/uJvDkd/ZtFDkoqVbra2yWlOooBf2r2SG+eGKw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=J+9z2m9wTvKTY6lWS16h6yybTBuwTAZdeEvVgdwQwr+8rOhFKhvXt/C3L71ziMzi4
 pe9PAadvDGR0W7Ct7B17451hZIJ5J1bojQ0/Sh2BW5SJrll2mojz6rKLhWiFrhlvCI
 plmAxHJi1maoiie0XASFiZxFGkz9QCH3LcVKsIEz0od1adpPHbtvsFmOpYhym4KOJX
 rUV8mcTIXSDAewVsUbvPDau0snmnUXzNU6WqPvk+iXDcAxLYVljCigXXIqlI4oJBLS
 ddBqVpUhg7RGgcgdUbYcu38VYFe3UUgaasj8+yEjX0wAQc135qz5ja0GOF+lGskNs/
 vsZt5/PGPIGew==
Date: Thu, 14 Oct 2021 09:45:49 +0800
From: Gao Xiang <xiang@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] erofs: add LZMA compression support
Message-ID: <20211014014548.GA14439@hsiangkao-HP-ZHAN-66-Pro-G1>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
 Lasse Collin <lasse.collin@tukaani.org>, Chao Yu <chao@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20211010213145.17462-1-xiang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211010213145.17462-1-xiang@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Lasse Collin <lasse.collin@tukaani.org>,
 Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Oct 11, 2021 at 05:31:38AM +0800, Gao Xiang wrote:

...

> 
> 
> Hi Andrew,
> 
> Some XZ embedded (lib/xz) patches by Lasse are sent out together in this series
> although they're irrelevant to MicroLZMA but quite coupled. Can I send a pull
> request together with EROFS LZMA support for 5.16 then? Many thanks in advance!

ping.. I've tested EROFS LZMA support with my own ro_fsstress. I'd like to
apply them into -next for wider integration tests even though MicroLZMA
itself is relatively independent decoder (it mainly calls raw LZMA decoding
functions) thus it should not impact all the current users.

Thanks,
Gao Xiang


> 
> Thanks,
> Gao Xiang
> 
> 
> Gao Xiang (2):
>   erofs: rename some generic methods in decompressor
>   erofs: lzma compression support
> 
> Lasse Collin (5):
>   lib/xz: Avoid overlapping memcpy() with invalid input with in-place
>     decompression
>   lib/xz: Validate the value before assigning it to an enum variable
>   lib/xz: Move s->lzma.len = 0 initialization to lzma_reset()
>   lib/xz: Add MicroLZMA decoder
>   lib/xz, lib/decompress_unxz.c: Fix spelling in comments
> 
>  fs/erofs/Kconfig             |  16 ++
>  fs/erofs/Makefile            |   1 +
>  fs/erofs/compress.h          |  16 ++
>  fs/erofs/decompressor.c      |  73 +++++----
>  fs/erofs/decompressor_lzma.c | 290 +++++++++++++++++++++++++++++++++++
>  fs/erofs/erofs_fs.h          |  14 +-
>  fs/erofs/internal.h          |  22 +++
>  fs/erofs/super.c             |  17 +-
>  fs/erofs/zdata.c             |   4 +-
>  fs/erofs/zdata.h             |   7 -
>  fs/erofs/zmap.c              |   5 +-
>  include/linux/xz.h           | 106 +++++++++++++
>  lib/decompress_unxz.c        |  10 +-
>  lib/xz/Kconfig               |  13 ++
>  lib/xz/xz_dec_lzma2.c        | 182 +++++++++++++++++++++-
>  lib/xz/xz_dec_stream.c       |   6 +-
>  lib/xz/xz_dec_syms.c         |   9 +-
>  lib/xz/xz_private.h          |   3 +
>  18 files changed, 725 insertions(+), 69 deletions(-)
>  create mode 100644 fs/erofs/decompressor_lzma.c
> 
> -- 
> 2.20.1
> 
