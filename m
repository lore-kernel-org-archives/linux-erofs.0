Return-Path: <linux-erofs+bounces-3690-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2727CD98F0
	for <linux-erofs@archiver.kernel.org>; Sun, 21 Jun 2026 12:01:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gjqgJ2rSxz2xQD;
	Sun, 21 Jun 2026 22:01:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1029"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782043292;
	cv=none; b=j8G/8Tomk7FEW4I10NGMzjesTnrTpjqqXmcaRXG3sU9IJM4yYZyFs47GssDWArMVVW0VdMZnv32Qw1vJd/lHvpXr4qyyXkWmXqaduQ6RufnS0Tgv4GSaHBYasm22os4Gb+ev8LWv9oPXSvaj/lp691S3X9DmnnOLCccx+CcuOc4oh/ZCPHcsm4rUixubcTJWxkuEzmWCOLaMHV7mp8KzY1NnorPOheuvPyZ/816aH4iLykusJHLDaT+KSQCPUGJXqcqrZP9Mn7FNcR8Ccc+k+q/aGiUFEfBI3VVkrhhwMhX6TEq+R54PuQtMH7gDo7vmJZjt6g6DoVlh2C64yeFrRA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782043292; c=relaxed/relaxed;
	bh=TeINYBX0Mr4wUDuh0j9+dOkqoVl0oaOgLhyEtOP/gWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m9WjX3WBZym++uFMWb3vNQTrinVbV/75fLRe7Lz0ruHpVs2T+w6cBfdrI6e+ul51v3hisTFyjhz1uib1GxCWe7d/HliKiVRrqeFBz4CwwmBziDfucKVFnKNZ1chhiciUKdbOItUJ6Re6SfJ8z+5UJD+uuGksa1+18MS5IjX9I1OWJPez/Z8HbMIUAtdD9lCO0GR5RVs0EdqZZmRj88CUIv11+PflW5xvhHnzYGOVSMq3U/HcipfMCpZfl/Z2TjAI3FXWj3kz6uVMC//INyRzOrPHCwmdrPRus6spjyAv+QZlD6QwiONWyjIIGR6gyaDPqR5aa0awPEBFTuJVihyGug==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KvAuwEk2; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KvAuwEk2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gjqgH5Mn4z2xPL
	for <linux-erofs@lists.ozlabs.org>; Sun, 21 Jun 2026 22:01:31 +1000 (AEST)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-36b9033d230so1815309a91.1
        for <linux-erofs@lists.ozlabs.org>; Sun, 21 Jun 2026 05:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782043289; x=1782648089; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TeINYBX0Mr4wUDuh0j9+dOkqoVl0oaOgLhyEtOP/gWA=;
        b=KvAuwEk2fD7kRWC4+jeWlVh18GM+Xks3bHFM15Vg0uSVPPNEcflaZIPyU3RCnja3w7
         TbdPNKnO3lZpDsAJVjeKHGtcHMACfR/LzUT5cYP/QNm6/HcdYQ7TsxUUNvCaAsTWD2et
         mYNbpI4BR9UuF+RQG1niuPN3ix87P8BR2TKv1OVAfC81+ym5VZldkVo/hxdOy2GCch+e
         NoGhJP17HSzTbOgnQ2WiW9nQlRU89lm8wmHVb7OZezVXDRncvXbqUk2WQgKauiKBx3bT
         zLViZWO+YsJAB8qnbqtMsP94uI3OUGs97IPEDYnDjllICu9ZY481tH3mX9j7zKMk9I4M
         aeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782043289; x=1782648089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeINYBX0Mr4wUDuh0j9+dOkqoVl0oaOgLhyEtOP/gWA=;
        b=WbySa+pyZMjelpTPaOUwDdZ1gxa8d9KkJnt1QW5fYgL+E3zmIC8c4WQtY2FLF6i/wQ
         WuIIAu3zNni0swVTwJtC26YHV3pa/dgykHu/9ouorzxDaUtMHKZkcV9UuVgdUz5mOuQz
         +2WnkcZSlhwE5nRpkfgz7zSZINsMhAxCvUkix+C2VIdEdTEM3nKTEVYLImxeFTjjRiKc
         IFTdkI+F+NyLjk1K9LNS0hqQbRvXO83XkvwtBlBc3yKuN2VOadDLzYcKYm12VOc67fFq
         DRkl8meVodE3zxX/xTIuNXLXaxbfRlksy1CbkH+mLbCCv1U1eB3L3qNFt1agDPvaYufR
         TxAw==
X-Gm-Message-State: AOJu0Yyfpyin3sZ7H4Wt3CJB7+3Vpo2lRcMS6qoT+9KH6clyNroYIq6a
	KTN9TuNw/4Am/nhaPT84LYHhVHU+cChjGCPTx5vtiIuEKaUgua6wrpaps6xqBw==
X-Gm-Gg: AfdE7cko1C4N0HHBdoOwsauKaSehZVob56vK5ZxJ9ea/7oSckI9HSQ4Sp0CIqYYB4Rs
	OqoG1p8/kMNzIpVYrCBrOKiZ9SJP0coDQbwticl5wCCtMWSk0Yc5p2Pjfu9NHWZrtOy8b1B6fpH
	pEwgqJ3DSps60/rD2NyVgMnUkT8v8CQu/Qu27LPtsz+vmXZa0lPZrlLrtCzYiirvTkvoPELccSZ
	Y7rENxmfaxHn/Z06fHuj5SYQpgNJogT6dVzn4J3kf11jfmd9HWLYonQ+txlx16qwD9uDk1n1B5P
	WU7Xyg7qDvLhyW2eByj3vVtXk8kEQPNsb8VzB4vSsDI7nkpFsYscvWtoVbsfBs0JfS3EiF3qw8s
	evwEzP9F4N5zLjbJzEkeBmgPEYJVZA5RidVqviHUiuO9xmd+VTLVVQ3wuA1PRS/xwZFcpRERGME
	EzC9ABmPx6xD0NeFxBOkHJGPmtYNvlYD32q/og5ZFYgiCb
X-Received: by 2002:a17:90b:2891:b0:369:9469:aeba with SMTP id 98e67ed59e1d1-37d19c9db59mr7992853a91.1.1782043288840;
        Sun, 21 Jun 2026 05:01:28 -0700 (PDT)
Received: from localhost.localdomain ([157.15.11.68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d4f315842sm4266278a91.17.2026.06.21.05.01.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 21 Jun 2026 05:01:28 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	xiang@kernel.org,
	Nithurshen <nithurshen.dev@gmail.com>
Subject: [PATCH 0/2] fsck.erofs: implement multi-threaded extraction
Date: Sun, 21 Jun 2026 17:31:19 +0530
Message-ID: <20260621120121.73114-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Xiang,

This series introduces multi-threaded decompression and extraction to
fsck.erofs.

The architecture is divided into two decoupled workqueues to prevent
thread pool exhaustion gridlock:

1. `erofs_traverse_wq`: Handles the asynchronous directory walk. It
   localizes the historically global `extract_path` and `dirstack`
   states into individual payloads, safely traversing the tree and
   verifying inodes.
2. `erofs_wq`: Dedicated strictly to processing `z_erofs_decompress_req`
   payloads. Decompression tasks take strict ownership of the raw and
   output buffers, preventing data races.

Testing on heavily packed LZ4HC images demonstrates smooth asynchronous
fan-out, successfully overlapping I/O traversal with decompression
compute.

Nithurshen (2):
  fsck.erofs: add multi-threaded decompression
  fsck.erofs: implement concurrent directory traversal

 fsck/main.c              | 450 ++++++++++++++++++++++++---------------
 include/erofs/cond.h     |  31 +++
 include/erofs/internal.h |  20 +-
 include/erofs/lock.h     |   3 +
 lib/data.c               | 216 ++++++++++++++-----
 5 files changed, 488 insertions(+), 232 deletions(-)
 create mode 100644 include/erofs/cond.h

-- 
2.52.0


