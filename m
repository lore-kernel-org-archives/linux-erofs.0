Return-Path: <linux-erofs+bounces-4624-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33163C9833E
	for <linux-erofs@archiver.kernel.org>; Mon, 28 Sep 2026 05:48:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4htVjB3RGkz30VF;
	Mon, 28 Sep 2026 15:48:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790574510;
	cv=none; b=IB8D5c1NdaHPGwP8fokl4Mq62OMnMqPHYiKDYI8DLEdOMqD1F6w+f8rRBMEwEFpallso3vLEIcGEBgXGv4PRWW6F/4YW6j0Zqw8ZIgYjQVP6N9XynYU1YK+mYhsXEiHrv7d6alsYngTQU7VYFzoe2QHN0AWWr11dVOjBYGZdSTQofZu9rpWLGecv4LKBr4wgXlVgn8SeVRCMgblrqMxtcGEoBKCTLxbdJUAsoey5BzUO+q1P9Q+48+JUWsHjpAeQQU00MRg8R1V6IXrzEsAlfEEpsu86hA6A9igYElRBLxH7iIDtNB+UzIT5nsuncppCitzzmVPBRyNARDurhxWnAw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790574510; c=relaxed/relaxed;
	bh=kWV/wHWLQfhp6L6mSocYwp2pbMQ9zmUarPxSrrFDYg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lb5h7M0RNLD8mzcQNLAo2IGihVu2HzqXJJ13P+cCthFIiwedpY4scjq0I9anbItqTui3+PAiLzYfvIQBQJwgyZvaq2y7Gb1jCxEKSmk+JPzdNosOwLeUleT0CGkjWKfOQVO50nS1BNSqobgIBRb92Yy7FcjxKzRkpvfFD0BSeVVp4O3Iuz1Oexx65GY4iXhL+mFS2DY11Sg8EkXO3PEH+uCHoJYeGaJT7l8QRvtZqSb0tUMPmJBtmkiviXUZ38rgU864TXVL3Yp94wlgePJd1fa+ahUkkH/rfC3FbuZEoNXr/jysVBK4Lm/6LcnxCJMabnqCh910PevRrTGnQJlonA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bDJUpGWg; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::c; helo=mail-pj2-x0c.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bDJUpGWg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:39::c; helo=mail-pj2-x0c.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0c.google.com (mail-pj2-x0c.google.com [IPv6:2607:f8b0:4864:39::c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4htVj86zR9z2y1Y
	for <linux-erofs@lists.ozlabs.org>; Mon, 28 Sep 2026 15:48:27 +1000 (AEST)
Received: by mail-pj2-x0c.google.com with SMTP id 98e67ed59e1d1-3a0dc47fee0so687800a91.1
        for <linux-erofs@lists.ozlabs.org>; Sun, 27 Sep 2026 22:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790574505; x=1791179305; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kWV/wHWLQfhp6L6mSocYwp2pbMQ9zmUarPxSrrFDYg8=;
        b=bDJUpGWgS533HHvE8Dzi5TM6+omybNB60ZPwCtSSKHJy9KrSDd0ECs3RfOe+cttG0s
         D33e82ynMAjFfBnFimUENqegvVJwiXIhF5ofwnSgORk0okDNlRVwWPm8TGBCkAHm5XKe
         bT2xGYJpVdpmRxolQA5QwywHGaeHJizmsnS5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790574505; x=1791179305;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kWV/wHWLQfhp6L6mSocYwp2pbMQ9zmUarPxSrrFDYg8=;
        b=mhHk9Wa7L4+rBoHtDGpd3S9nUo23c8cdEJvImtaGDWWXu3Ao7ecutWDdlV4pD/5msN
         R+yg5xUO6c2AsdsieOuQx5p8am2iEVGXpzqoDa7f8/bFTt1uuADkE5N6SoNiUNDxn4Yd
         +4dRGwkJu8tJ2BGktlAvjLyANi9a0bk16QMDggkpKiP1c1B6HNEYmf0LBMo2H+jWGb+h
         EnQUT55KsWDv0WiL0OFxZXreQHM5rAQhuZW5cBl2i99QF08UBuqoymdZKhMfkFz4+p42
         MAtUvRwZglkSEfVAJD4vesZq5LpTbwrNi8UWw0W0Jy+uxov+XM0Lxl69Zrzvfgr7TZtW
         mYgg==
X-Forwarded-Encrypted: i=1; AKwUvBzrZ7SQpMyD5LEA15GyYDLSf0MvfRd5oa3sewQvVaKlRyb4xsJRS/PH70j2Bqbe2v2dzJ7UheLwWNt2cQ==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIicuJmV09c1uv16Lzc6p+7cW8pKtuS/eYS1tv3ajd2HUAbElu7
	ETDN1wNt0RIyvH4xMwalvddpGfuG9RkYOQGJWZBdnT+9/EAF3p1kwb6ftqfYu2omIA==
X-Gm-Gg: AYBFou1Oho3lhCKf61gMsVV9aS0L6JO1LwAso9qsW459EZ8Wl2Jv3Gy6LhHHWsz5Vxx
	157S7qLZRF7gJj+hlgMw3yLDHSW+QvoXCzDjkvG4qUaF52xMyntIDB+RisnQJiOFT693ZDzfBsJ
	bG48UjNsctq9BXPn/XZcnKLdQNROBp1jUGhEvRNnHciv90m6pcTZlgQZdMHXBopQ+gOAH9CqMB1
	uYBln7m986bme+fQ+6/o7m8K9ztwkXLOEAar/WL32nXnkCZyMgg5o6u/edpBL1PVp9WD1cUqR2h
	nv+QhrIZMrXp/bza3o4sMBQVAmfUceBhqQ/3MKat6qc70t0jFlLcbfbCWvIFOMrOY7m4YEXBszN
	qQ4LtINIrbq6ipTbI4dsSpJqAdXFjrmI9E3WuU+kwV4fb+AOZGeqUXuCgLAsSQVjPoUAKRFtVy2
	sYRE8nZ4PW+7YJcs7CExopRyZdZ9Xp+6jVjnPYA8JXQgFWqlMQe1AmjiSCmoqcFqkM1ageQQN18
	gOdlg6pMLPJTQsSLjHhCVDgJ0SznQwM2Zgl9qV6SkhvbU2uUA==
X-Received: by 2002:a17:90b:3888:b0:3a0:cc33:2287 with SMTP id 98e67ed59e1d1-3a0cc3324ccmr6256726a91.6.1790574505299;
        Sun, 27 Sep 2026 22:48:25 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:fdbe:318b:98fe:bd96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0bec30aaasm17853889a91.15.2026.09.27.22.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 22:48:24 -0700 (PDT)
Date: Mon, 28 Sep 2026 14:48:15 +0900
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
Subject: Re: [PATCH RFC 3/9] lib/lz4: add the build environment for the
 vendored sources
Message-ID: <arn9tK5MxxxfH7OW@google.com>
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
 <CGME20260925113456eucas1p136c3cd1f08be7201ad6b3f7b0e8ff02d@eucas1p1.samsung.com>
 <20260925-lz4-vendor-upstream-v1-3-1c7ffbe21c4b@samsung.com>
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
In-Reply-To: <20260925-lz4-vendor-upstream-v1-3-1c7ffbe21c4b@samsung.com>

On (26/09/25 13:27), Michal Wilczynski wrote:
[..]
> +
> +/* LZ4_decompress_fast() and LZ4_resetStream() are still kernel API. */
> +#define LZ4_DISABLE_DEPRECATE_WARNINGS 1

Is this upstream code?  As far as I understand it, LZ4_decompress_fast*()
deprecated upstream and are strongly discouraged.  Do we want to suppress
deprecation warnings?

