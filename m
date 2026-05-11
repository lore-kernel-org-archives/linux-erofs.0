Return-Path: <linux-erofs+bounces-3397-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C569CD37BE
	for <linux-erofs@archiver.kernel.org>; Mon, 11 May 2026 13:30:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gDgZb2TbYz2xlh;
	Mon, 11 May 2026 23:30:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::535" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778506215;
	cv=pass; b=oKRS4YZw1kTd4MPham6+ddD+x81cQk8OB81ncVZlshJ9b2Pl+nSF7yZ+WbnBWlrHnEJFGiPncsAp2kiGAmsQoQvzw57CxAqVgNofC16ru2X9nBF5s9iHkuxsW4SjzvXNtW+1t+t+gZg7rEXqJ+x9C2PFq4eukxQM2E2TXQbXRoZdEnACnevmPfy/hQEA1/BRNbB693hyfSidKC/6huwmJ/ctFE9H342kvM/q0DB7mwwmwhBCj2wSyTWHNUArcvTo/PbH2kNRjniZWIuIXJeWMWPY2fV5MPm8gzb8bY2hO1LBJHU+Y700Tg/+3Rc2D/tckr/3qbjE67dcxUW5x7ubwQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778506215; c=relaxed/relaxed;
	bh=JjfE+F6s2ZbNPQcsZgsykBwKdYDljSABQbHVqqaaXKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ndXl+UwYQNibcLVSITXpDAuIQgvtr8cvJcWqRvHaJE28WQoO1jOfsipMFKIGVWtF9/o6BGMBXDjU3F4zS4UfCSGIsV7moZMp7EDCXkg5QNQL3yN3b5MQryqj2Y+OgdmX/6vQT/I5wTCizkPQIj4nb1SXAHn45a29pWxzJC3TxLO+h6dF+xbNebcxWDBpcQJh92PnxXwTiGIuFqkNKiISG8DP6qCaeXoXJeCMqPOgkkSvbOWCf6tVFi4HCRuexuJ3Z0x+2UAGrbNQfsO+DzZcsTLuBUeOCnY6kpK3wjGeqkaO/LKaHrZhDoqaNdBnSr6t3SL5WQsZNSLq+5yHKyAebg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=LvrPgBya; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::535; helo=mail-ed1-x535.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=LvrPgBya;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::535; helo=mail-ed1-x535.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gDgZY3N2vz2xf8
	for <linux-erofs@lists.ozlabs.org>; Mon, 11 May 2026 23:30:12 +1000 (AEST)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-6763cc8775cso9603767a12.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 11 May 2026 06:30:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778506208; cv=none;
        d=google.com; s=arc-20240605;
        b=JdJS4h9rxrqmakEZxLVAvCYeEDulpxHxTbKsrbj8LAc3i/te0pHTfNg9iHawowBZw/
         AMIm8tsh4BSxSEltgGiB6zi8/oVooFBCgXA2S6RXCmSjxq5Wy5AMsIIaVeM8g0ep7zyO
         hXB2DZ3MBWwwbLoVH0kbZ9tOVWFA5akL9Gd+4b7gH18ViWs5CKBDJzbnm5SziBnPTMWn
         +JqMio7enlrwh8V1nZmRXP8AotIiVghHfJj8f+z/eaI0w5wUtH3GBzBXmhRhVtq1Ps4a
         KbTejura+yob0hSwdJBDOQKQi7w3331GJCeZXZ5H1Beg7DwYSbVkNb07qe8im9vcwMWF
         r4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JjfE+F6s2ZbNPQcsZgsykBwKdYDljSABQbHVqqaaXKU=;
        fh=cCuBTJakmx9hC47U6UG+jToUqfIhwwIv4s5Y6bZcPBk=;
        b=QXDbLkyjyZtjnyA6Xqy7sU1jUTE9dMdf0N07BVjL0iwqxofvWrnBLacKhXYzaxkzuZ
         1CJUqmoDdPu8+hHLfVbamskImfBw9dguBJfaymwZU8duuUnLZ5v1OPiQD542BZ25p9UO
         NkygmdPg/ddRVrwWYOMEZyBxQqNV342MZAjrTPWGpD1tSt7H9dBMF5MOidsOasek8OE1
         z3a3oZGi8O79CooGq/JtgmdNOFiTZSluRiHGTx5MPTJlKMHknroOpAoudjs5wYAttdS9
         U3XyT5rUEV3nny/HT3VVOYSr2SrLPjYq8PPHqGGxra7/DxF2qwH1Hi+IKtuTB0ytXfJW
         BTsg==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1778506208; x=1779111008; darn=lists.ozlabs.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JjfE+F6s2ZbNPQcsZgsykBwKdYDljSABQbHVqqaaXKU=;
        b=LvrPgBya7pvBbvd4abq7Qq29pAcOCLg/rIJbWWu5f6UHWFs3qx6NHeMjCdLk+uT0Lh
         eMLduW8fwzy6yHK3Qh7Lm3bHikWJJqlDb9xZS8nddbP8bN1gIobrRpt1yJpCsyJ7bzSF
         OTmmOkizaIlZnSyWyPHx/5jbdNlU0OyWoPbIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778506208; x=1779111008;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JjfE+F6s2ZbNPQcsZgsykBwKdYDljSABQbHVqqaaXKU=;
        b=gp1LIeJAmN1Zd8moBQZ+yw5jp1rW3gi1yjePZy+D7ospGjgIJofZ8W5kt08EEb8U87
         K/2IOD5SJ9YzrAbORJ5C/UIiamWKfuOsk4J1XpiBdOYebJhZmSsr8+xqSLOJ1ALhKg32
         CZf0YbQyVpr0U3RP+LqizdpZiuO3Rvuf9xAtRXqkmLXMbH/HljyHiIl3gKdla1CFF47i
         uzJ2lfQua7z+KfP3Ob3+J5hekTNyRFshqmmCOYmxlMlOb/wZF+eRABmojn1VY0UU575X
         YMblRrXbN9vVu1JfRRkBnl7WFTcdKrD7xIIXtbm51X2e5IbRok0rXOdxdAs1orWsaoQh
         sS7A==
X-Forwarded-Encrypted: i=1; AFNElJ9/qanW9OwEGH2aMyQb4XEonByCRz+W/ekuRXjlL1YXF25IrEL1uDYBVTKDAJM/In2KUrXQyEMSTyS10w==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyxmB/WxdLVHdbrhtYaaWpz9kuPaoN6WbgkhkfIks7S95FD95UL
	GErdRpaaJvL/L6LRTJsvm6MFzFKwDVosEst5Bu0TXDCqUrwXAqIahsfjTBzU36CAPf8vL1QIj4T
	u69JyFA976LD0ZhAt+2Huks3SeXblUvXfKDNHOHh7
X-Gm-Gg: Acq92OEmB3nW81X7BhBbq8lv+c9B0/2YOYTRnMe+nd44BCqFu+lMBh104EN0vIe9SvP
	VCzz6z+w6KtrJ4vC8A0/dgCZXIeBnOiBH9VQTRaooAJZo6M9fLjSXjQUXJnxJXUCkDrToUJo8Z2
	dfk37FPnSn5axXxb4jC/pEhXifDICVnI4PIYXoM12h77Rf4bXAL+oNnngDq4z9d8xOOOhOR2C82
	VFveBUE/4WSS0lf0il4RK5DIxXC9dPavmG1WmOHCtS5FPqDoimevvj/KLjDQPkDzNuXI3vcOThL
	tfMeRQ==
X-Received: by 2002:a17:907:da17:b0:bc6:3122:c241 with SMTP id
 a640c23a62f3a-bc85c890f00mr884516966b.18.1778506206699; Mon, 11 May 2026
 06:30:06 -0700 (PDT)
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
References: <20260511085857.3933053-1-aristo.chen@canonical.com>
In-Reply-To: <20260511085857.3933053-1-aristo.chen@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Mon, 11 May 2026 07:29:54 -0600
X-Gm-Features: AVHnY4Lg4XVR9wvuDUpHJcF5pKVCmG9l3jD_RQJuL3ZhRxhzRofxo9uKi1e2U8c
Message-ID: <CAFLszTj8kmRyf5_GrcP2zKRxouCwr3BNoPOk6GWse8RRVQ2BJg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] test: fs: Use shared generate_file from utils
To: aristo.chen@canonical.com
Cc: u-boot@lists.denx.de, Huang Jianan <jnhuang95@gmail.com>, 
	Tom Rini <trini@konsulko.com>, Joao Marcos Costa <joaomarcos.costa@bootlin.com>, 
	Richard Genoud <richard.genoud@bootlin.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

On 2026-05-11T08:58:50, Aristo Chen <aristo.chen@canonical.com> wrote:
> test: fs: Use shared generate_file from utils
>
> test_fs/test_erofs.py and test_fs/test_squashfs/sqfs_common.py both
> defined a generate_file() helper that writes a file of a given size
> filled with 'x'. The two functions were functionally identical and
> differed only in parameter names and docstrings.
>
> Move the helper into the existing test/py/utils.py module, which is
> the established home for generic test utilities (md5sum_file,
> PersistentRandomFile, attempt_to_open_file). Update both call sites
> to use it.
>
> Signed-off-by: Aristo Chen <aristo.chen@canonical.com>
>
> test/py/tests/test_fs/test_erofs.py                | 16 ++++------------
>  test/py/tests/test_fs/test_squashfs/sqfs_common.py | 22 +++++-----------------
>  test/py/utils.py                                   | 13 +++++++++++++
>  3 files changed, 22 insertions(+), 29 deletions(-)

Reviewed-by: Simon Glass <sjg@chromium.org>

