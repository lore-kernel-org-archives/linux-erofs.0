Return-Path: <linux-erofs+bounces-3946-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924FEC4452B
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Jul 2026 07:05:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h47h35PmFz2xlb;
	Tue, 21 Jul 2026 17:05:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::535"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784617539;
	cv=none; b=LBV/SLxY9GjbAGNuhFP00mF2y+pfiDuinhNKIDkco5hJPQhZapOqFDeq5jSBGHBWDCbpDDQvNt31hjheAKe8tIOfdsXFyjr0OlMl4EpEmlauPQxT/r4DTFxro6Xwr/jA9fqH2wxu84QJwobazg+aTGqhfltGPHltLXFyeMUzVXiI5+/X6LJD0wTaRSyL43Qpi1wlajDCYdD3Ns7uIiG5jn/cWE9HEbDF+QCC80nrmyOJfgSUvmIcENJQkV4WkoE+z/yQ7bHUP3yImN+GkPOmoG2cLpcs+ACyozNn69x8/4m2FIXp3E6TS+rP3+FiperZYA2g3AFolP+Wt/X0NvRYeg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784617539; c=relaxed/relaxed;
	bh=sgbW134jCVc/crdSP0VZbxCtt43v6AVIxUbE0tYuU0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VPFn0jZUI5ru5+P7mItJBRO0psM5+9+p0tG+pIwAz4RtMO/EuusLIiwkkTw1g5mv5dqwTakREdDnENmVjcqBB9DvaV49Qna7QFhWBVQbnfwDn5oFoUZterbp6hr4ZYutyLno1YX2kyCkjImi5Dwp+q+wbJqa4vl9vrrQqzTqhdCD6k2UZrg/mzIuioM1YhVUYYwh81Z9u0RleMyN7yIs8uVlq3zy0zRQymzTltTE/ABj065dMm+IpsYSsmIoxsFxZQaPaM9Vyij/38LzFYy/VPdTdjC8EEkMCqIXwr6lhR2WUT5ZV6QlqJBZv8awzak5MBiAJslCYZvn4t3CE3mm0Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oh+0mZTY; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::535; helo=mail-pg1-x535.google.com; envelope-from=lihb2113@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oh+0mZTY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::535; helo=mail-pg1-x535.google.com; envelope-from=lihb2113@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h47h264kKz2xLh
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Jul 2026 17:05:37 +1000 (AEST)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-c99eaa1f020so7605382a12.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 21 Jul 2026 00:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784617534; x=1785222334; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sgbW134jCVc/crdSP0VZbxCtt43v6AVIxUbE0tYuU0o=;
        b=oh+0mZTYgzv/higid8iTamrqhtx6damUoUKoRH/9JjgjEYFqCOe9NKBh5GC1mkGlVg
         qBYmfAQwkV+ZxtJxsp6KiKrXCIkyTMe7Xqjy+z23Gt4w5j/KdTDgWxr7sMM/YlLcg2wA
         hHVTLzm1UCszFqVBP6BWmrvQaqKQe/pv4FVEWR387e7OmytF8HAR5hhktfakNPJ8bZY5
         HK4pJvSUpEUxZB09Nh8uKJJEo4XbSMdUDo1EiH3MaO3iy3Z3oJ55Evn86oroQ9u6Tk96
         80YeR7nammHu9tbgPcc8aWPlJlAUzwTmsEuBHeA9zyftpaVFPTUBBAxvKdHSAwMa5Xi2
         ELLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784617534; x=1785222334;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sgbW134jCVc/crdSP0VZbxCtt43v6AVIxUbE0tYuU0o=;
        b=q43TsK0q4XQ/LFB+n/DoL3upRNe5TOKY23NTE7b6FaYWSiRJk//gAE+5q3O/UxM/ir
         rXpYfMZm8FPsFcyKd9iN19wEomT9xu8/GW/4hsUefgOU6euD1//ppbQ6HXihVWbE0YTG
         +cWK3qgwSqcjhx+8JsKu37LfazX97V6ycM/pdgWbQbjVWIcjqc3vwSBfKEBuQSEszpTp
         cVhW/BDB0PqC9xVyx/SutlaFwrvHU9rS5kRYcaoViVw+4hDcYFEn+RQiWjxtxpTzNzkb
         RbCeWjJ1KK38nOdDtueDmNrBVxteB4QY4llQQ565T4txudl4HOB+k5cy8PJjFpZXd9Tk
         8zwQ==
X-Gm-Message-State: AOJu0YxWL+5O+8BuX74qniGjserQgBvEPw1udHeRuHroSryzX2OR+ajs
	uBWpPvpHiFqcTcvdGrcaowA4X8Lzpp1DWWNeEsKw/DslKh/yTEwgqlL4
X-Gm-Gg: AfdE7ckrbyG6TOh8aqBL2a0EmHIIlAxTSEND9faf6mF8gIZS235ymm+16dXobgnHA2P
	g+5iRHHJpy/Y1qIZZXy0Ga2CnkDs5/NvM1ClEh09VghNbpYpFHlOF1QUuIKtuQ0OGBqDLI4QvDd
	dnazeGzR4wPJ6D6dXRmTr5L2GI4dk9GhgYoy0R14BPLwr50wdEgxBOhdmfdJv7ktggfww9P1laz
	fj1iRQAxo4cZwCoxfc0K2pL56T79Ck31TcBbR0tHt3I2IYhbUiFad8f4P2/+UIiwq9ptcsBpJFv
	4LYpClnVnJCT8gUfO5EKJmpewFia3VD/yMRtgMRu+dZ/s99T9SgIyn9riavmKve0gbDdwOtE/aS
	kz9c3gkKsBHUJmbZRXeRMmUmmRoHzX44uGl3uV/sRSgUYtlE+sxCtNHj55OGB5cYtt1PjUYPRw1
	OiZbN3omZazXVJUqWi
X-Received: by 2002:a05:6a20:c407:b0:3c3:b5db:d24a with SMTP id adf61e73a8af0-3c3b5dbd286mr12617596637.68.1784617534562;
        Tue, 21 Jul 2026 00:05:34 -0700 (PDT)
Received: from localhost ([14.116.239.33])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb5159b11a5sm5590915a12.0.2026.07.21.00.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 00:05:34 -0700 (PDT)
From: Hongbo Li <lihb2113@gmail.com>
To: hsiangkao@linux.alibaba.com,
	chao@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	hongbohbli@tencent.com
Subject: [PATCH] MAINTAINERS: update Hongbo Li's email address
Date: Tue, 21 Jul 2026 15:05:18 +0800
Message-ID: <20260721070518.2016441-1-lihb2113@gmail.com>
X-Mailer: git-send-email 2.43.7
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
Content-Transfer-Encoding: 8bit

From: Hongbo Li <hongbohbli@tencent.com>

Since the original email account is no longer in
use, I have updated it to my current email address.

Signed-off-by: Hongbo Li <hongbohbli@tencent.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 806bd2d80d15..1d73e80674f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9616,7 +9616,7 @@ M:	Chao Yu <chao@kernel.org>
 R:	Yue Hu <zbestahu@gmail.com>
 R:	Jeffle Xu <jefflexu@linux.alibaba.com>
 R:	Sandeep Dhavale <dhavale@google.com>
-R:	Hongbo Li <lihongbo22@huawei.com>
+R:	Hongbo Li <hongbohbli@tencent.com>
 R:	Chunhai Guo <guochunhai@vivo.com>
 L:	linux-erofs@lists.ozlabs.org
 S:	Maintained
-- 
2.43.7


