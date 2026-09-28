Return-Path: <linux-erofs+bounces-4622-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E61AC9832F
	for <linux-erofs@archiver.kernel.org>; Mon, 28 Sep 2026 04:26:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4htSt73mDHz2yVd;
	Mon, 28 Sep 2026 14:26:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::11"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790569567;
	cv=none; b=XhKS48zY1aEaLW80zGSoUduHA9RrcdY6hC6mjas1aHuu4pgLU/WZEH5VS+M0P9J3JCKRWu8dwDgFjCXaSSokAj7bqZehH00+zfIzFk2RtFVacXkf3taOyNSOP/NtH/j3vcNRhSeO7SIvXRVEtCSySB8uBzZ/rAbT87njUc3A0DHr5o+HczLQj/EUlJcjeQ6KjifqYtCRTqCUvb90vPw7Ax3zdY/OXQ/UjMxTLnzKERJ/2d1IyUtDG0LljA2TPgRXaHlYNfy/tds5tv2RTvgsD4tj6zGDQ+x+Wl2v0zMYW1aDwks+hkyncdYSA7JqkkckHFnl/xfEYP5KdwEaZoJqrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790569567; c=relaxed/relaxed;
	bh=FrMP4Ii/YMUEItMnNYi/9VayHYXB02wrW1zol6BNPjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cubWvg/Jh2B+s03i3Ool3KB9HjXfiXmMsrArz3MbvFc4YXKPwGKdV5g8xRKfNGaTg7+NgrsmAVf9VO2gyFgbiiA/f5pSKImEuK/6rkqTD4oJLXHdG/PdjTW/aJFrr8LHsmwMzW7i0qDhP31/TD2SPgNTmtdUI1lk0A2YGyUdm36sRUXnfSmB3amPInPO/UKNFDFChQuylj270URy/PHFLxW05kIWiHJM0V4HYjNMmLTARc5btrC3GZGW0PjafvPdiDVFudsxLQJxRK35PFY9mzFDLMIgX35pYCtPtk7HbGSU/IZWk48tmWb5GQmBKWF/uYTUav+jAYZL7eW1ru6YHw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YLnhmWD3; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YLnhmWD3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pj2-x11.google.com (mail-pj2-x11.google.com [IPv6:2607:f8b0:4864:39::11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4htSt62bLkz2y1Y
	for <linux-erofs@lists.ozlabs.org>; Mon, 28 Sep 2026 14:26:04 +1000 (AEST)
Received: by mail-pj2-x11.google.com with SMTP id 98e67ed59e1d1-398cb5615deso2148662a91.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 27 Sep 2026 21:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790569563; x=1791174363; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FrMP4Ii/YMUEItMnNYi/9VayHYXB02wrW1zol6BNPjU=;
        b=YLnhmWD3adQJCpOXovsegR/hzSFSPEGCYxaFrwnL8xUroLGmJopI8pswJNy88lMPFs
         c9LzUPfbvMZQcNsYAV8XdL7YZCXCHrKNGM3tolqPqxcvs97VuqesMCZ/GWDeMTPH93St
         tRXPg7D9FMFXyWUvV1Eq00hZcYSUy4H1e3D9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790569563; x=1791174363;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FrMP4Ii/YMUEItMnNYi/9VayHYXB02wrW1zol6BNPjU=;
        b=VAA9cqmJZKvGRXYQktu0haI8xkbobgAtUqGLtIhyLV80Nkm9NtcnJkwZrkOhCL21ef
         /x0mmPJouvKzUMskxewZPucz+dmssIJ7oTn0P9SzT61zY/V3jG7t6nFiW59CIs86YkqG
         CIin2bD3gQMRKA5wpLgaoFw24cAFdiBo8sqLMHDIYtmVeBt/X39GksrQS6uyj/B/EP+Z
         3P4blQJjTk9yiO1e10IiLdDOGJdzNvAfDaLKFsijPI5fX/w1lZ746nmdVtJiRK9VYMER
         gMnmwFFdjKOCE9aKHAw3d3iNKT4kwiwjufL7u9t5qc92Nxu4cS2RfPART8wSyEOT1z8t
         PXNw==
X-Forwarded-Encrypted: i=1; AKwUvBwHjnhvsyjwU37pVKb5TamTcR5FhvhYE7KXAnuPjzhq0YkVGsisukqGgAyWFy1SFIiK6qlexoXBoIQRPQ==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKtUm5Uj1GMpklNCabKCT6SNYVbLzCJe7oxFcuBQf8ley2MxrdX
	P57nPyXs+920Zm2+jZ+21/7ODhox6nCEJDmANA90uaIU+Wm4On9igCLoO4gZzFyZMQ==
X-Gm-Gg: AYBFou3ZouY4hWtAkSXsv8uAoQbkN978A/MuyDTT84+hcA1S710UL/YKzaMTKIeGYqj
	DEDNQfWH+Rf3m3XoCjUoCl4N+02TBDIhx3CynM7FZXOd2KANemo7Oswz/9/Qhm5wl8BaZ2brIh0
	tatqlk/YaSao72vHmp7UHqjwgChfDivyp9uBcv8hFmPfYft3m8mWd842UEfV0cpZoXLzO2XT1Pu
	GXgNZQPVKq1yr/OdcpQTATTqfElW75pNUkAWX2P+mkqL0Z34/bYi+1e13sw3uFiKybUFYUO6L4M
	hPU/R0Mb1j+GZDCNPSMGJSzGYrcITAKaid4L+pMI3vVSv05K7atveQ02DUR/C2XlbZ5iuOBBCyR
	xoaBaMKEzFfxi6b0kAB0n0YFhp/9KEqY+T5ozF+WJZp7cV3Pg6CtCybpX8IgjziN4hdvZtU4WyO
	MZmIuQbdoU22fX6MaW3xSbp7Vr9+UcezGEcMqYtZoPfMObSoEGkXAFa9FNOfbeEjE9Wnm+aQ9of
	t1heFL9rpIk3NTXA7AU5NgEFrIz2iYc5d2RcAI=
X-Received: by 2002:a17:90b:3b4b:b0:3a0:d2f3:fa80 with SMTP id 98e67ed59e1d1-3a0d2f40159mr5894433a91.6.1790569562955;
        Sun, 27 Sep 2026 21:26:02 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:fdbe:318b:98fe:bd96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99917besm17891690a91.14.2026.09.27.21.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 21:26:02 -0700 (PDT)
Date: Mon, 28 Sep 2026 13:25:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Russell King <linux@armlinux.org.uk>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, 
	Nick Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Sungguk <sungguk.na@samsung.com>, 
	Jaehoon Chung <jh80.chung@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] lib/lz4: stop forking upstream LZ4, vendor it
 instead
Message-ID: <arnr-Su0uJdK_rOb@google.com>
References: <CGME20260925113450eucas1p2fcf838f00f35e1bce0ca04a694cd0cd2@eucas1p2.samsung.com>
 <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>

On (26/09/25 13:27), Michal Wilczynski wrote:
[..]
> Michal Wilczynski (9):
>       lib/lz4: import upstream LZ4 sources verbatim
>       lib/lz4: backport upstream's -Wmissing-prototypes fix
>       lib/lz4: add the build environment for the vendored sources
>       arch: boot: put the LZ4 freestanding headers on the decompressor path
>       lib/lz4: switch the compressor to the vendored sources
>       lib/lz4: switch the HC compressor to the vendored sources
>       lib/lz4: switch the decompressor to the vendored sources
>       lib/lz4: fold lz4_kernel_api.h into <linux/lz4.h>
>       MAINTAINERS: add an entry for the LZ4 compression library

On my x86_64 build .text size change seems to be quite significant:

 ./scripts/bloat-o-meter lib/lz4/lz4_compress-old.ko lib/lz4/lz4_compress.ko
add/remove: 0/2 grow/shrink: 5/1 up/down: 8022/-1755 (6267)
Function                                     old     new   delta
LZ4_compress_fast_continue                  6028   10486   +4458
LZ4_compress_destSize                        158    3112   +2954
LZ4_compress_fast_extState                  4078    4597    +519
LZ4_saveDict                                  82     153     +71
__UNIQUE_ID_modinfo_466                       52      72     +20
__pfx_LZ4_compress_destSize_generic           16       -     -16
LZ4_loadDict                                 261     204     -57
LZ4_compress_destSize_generic               1682       -   -1682
Total: Before=14756, After=21023, chg +42.47%

