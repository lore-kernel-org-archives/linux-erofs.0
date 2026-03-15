Return-Path: <linux-erofs+bounces-2695-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5689ED58B0F
	for <linux-erofs@archiver.kernel.org>; Sun, 15 Mar 2026 07:27:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fYVCz5YKCz2yYy;
	Sun, 15 Mar 2026 18:27:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::629"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773559631;
	cv=none; b=bt0ehWCNoaGWBQUKshRsttwBIBH4OtOWcPJBY4Ly8knNOuvQQPx1/hN3yhOWpXoaMnukjjZ/LD4vJalRx8eoVH65PMY0eL9RwVbOOlvOVegJsj0fr23724jCxBgLlwFag5aEpDsTBdMHEgPx9JJEaiXGaMSx927mdlT6pRXKL3E03Mi0Mxdm1NH+7+uUjEGGEgUGvhY4dF5/W7Z65Nl9Dyg2lQjR+AmJ6aWjT5YyBKYPoo/Enk7FAjN9RlCQYekNVF2nfKqecsmySQWIKo0SakxFKr+vS+5U205nZWXqLeYRqRrZTSsnzxlt7DDGAVlUrD9yO9b53DAcXPiuFeA6Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773559631; c=relaxed/relaxed;
	bh=fTpO+85/GnZ5rgpOwhJaW7UCAP+4jsoUV8gsBgHdu54=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CZ+8ctRDKlDducMC6zu8i7E7vYvulhf+1VnEIVREnjuL5uY+2A82x1P/OdE8CWrH0h3WmWnJSIaEAFMr0n8iUal2L9cYAm0qjSxpS2MtYn5xmEDoY6gTo4oApw+VrfAisrQWpmeGhKbQg2OlZpzKM1xYBVNmObJiR2Kd2NQyJ7cUPaNTYrFizCAUYZts2NA9mU+mgo9nztDLRwT/BbVkwU0HY0r4XHeK9VPY8h7cfi5+HMLx7jE+XSMX/dnbNgSvCkTZc/WYApp2WRYweVFKZipNAaEjy9s7cLVvmnC5Mc4jbrnVTy0LjeqkWnIsEKJFuod57M14d7XWVkCNYekrOw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=gfR+ZjdZ; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::629; helo=mail-pl1-x629.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=gfR+ZjdZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::629; helo=mail-pl1-x629.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fYVCy6vVFz2xVT
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 18:27:09 +1100 (AEDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-2a8fba89cb5so4519815ad.2
        for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 00:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773559627; x=1774164427; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fTpO+85/GnZ5rgpOwhJaW7UCAP+4jsoUV8gsBgHdu54=;
        b=gfR+ZjdZShPPJ6jih7LxVa8hU4Isj0UZidhJAbS0sk45ha9B86PNbj+ricxt4JAEY4
         PoeGBgFwqrmu85gcfu/lgH5Xw6CnohTAVlGZK6jerSekuy0SNZ5xb09UvFZJyNEOCyqx
         viwjgmKtJvlrkTpoWyM7NWJP89JKMlGuG6m/HSELJKaGxvue6lNbMN8fgEkpm5UEHlha
         ZqSp68Gdh48gkJqffrQxBTyq32x4hiCtuNv+IFNEf2BFC6IR0ZZNbzt88gexOpmuozDk
         6V2dbsuE3KUgAuFMTjkwRz5GsvI49OQCpR5vfcc5yOi9gkqjs51Mb9RO5s2ijq3ruQGQ
         xfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773559627; x=1774164427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTpO+85/GnZ5rgpOwhJaW7UCAP+4jsoUV8gsBgHdu54=;
        b=Yn48UBAhXNuhst8w222myNOmcbbCeA93JemQiLnz+f0YdCiKxo8PrxxDZ9EU8Lu8n1
         V3rJEXJIHmvlue1YeUmdaN8GlES+Lv1AJQnjt8Pdsp87CG/d/HPSD8kM2NFHkIZCsN7R
         6Lrtq/LJIo/0z1NZg/uqGewyRTkbi2tto4aCHoDjzbF4T1vob3hvQE20nwatRWbHRRIq
         RLILZeMaBC7oeJwoGZt5Zx1+lKloldcJY3crpqAqCUuO48B7WSl73mk7TKy0JBQhh2rK
         /XU3iuKVAn481Fi2RRaqkvByPDSVW/JDr2Xgh4dMYDmfV4Oh6nfc2fOfeLsxnRGGrfGV
         wnaw==
X-Gm-Message-State: AOJu0YxS4vPnHrXZ4W5BJShwgoLQ4qD0Z4yvnY+2GqTqZj2J+JKnYFIM
	3fJf8NxTlDf9amc1Gn4cyI4+my/cp0YcxljBlIZxs+adFLr5Z/1/V/bZ
X-Gm-Gg: ATEYQzx/sgZm57N0Exd+p8+xf49t+QhZujUNQ7AJYmf/ALvN11N1ucKBIWUL0AEwojx
	tDNoR9zUTQEMyZYdzFYXn9JAH4ifaml9OPn6W6cmF+0oz3rl0puN0yj12ul7TEG8SWVdxtULMKX
	SF3CXbNO/exgWfDVgj6u4FIozeXhXdD+tOT6BoJ1LPvD07tix7S2f//1LTQIoUOirR+8gV/Qm8H
	HHxQnBk/WDvuYe8aCU9ttc8tQ5sUMZzTqe7kn71S49toV2f4JZYrwbTO2NZ2l0SNabOT+PwXhHK
	BoKVl7mpZ3ktKy7YbAPpg9mAynKIdbb/r74AUmCllGDwGTZXnY/ReiRz1LoIqbWBwweYBJsxEi2
	bAZqAFgpA0CwMFg8YseU+atlxW4Prm2Uva4EdNDkkHBrEc5wA4NWYTJmSZ0KY4J7Nuua1dOAj9S
	4E2pZXddNLQu3i+P1KbvvhcrCWJ68cZXaFRs4jOVfk0tMiltNKwM7D2bR0kJKEBw5TrTRHbrdDN
	cfrdkF5fu/ulzaxfJdvWp9XNfOgx9DF/jAtIW4tim/3RIAM
X-Received: by 2002:a17:90b:1e48:b0:359:3426:c603 with SMTP id 98e67ed59e1d1-35a220c95c2mr5589640a91.8.1773559627559;
        Sun, 15 Mar 2026 00:27:07 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73ebb649a8sm5744485a12.18.2026.03.15.00.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 00:27:07 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: hsiangkao@linux.alibaba.com
Cc: linux-erofs@lists.ozlabs.org,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH 1/2] erofs-utils: lib: add capacity ceiling in deflate partial decompression
Date: Sun, 15 Mar 2026 07:27:00 +0000
Message-ID: <20260315072701.17090-1-singhutkal015@gmail.com>
X-Mailer: git-send-email 2.43.0
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

In z_erofs_inflate_partial(), the dynamic buffer growth loop doubles
decodedcapacity on every LIBDEFLATE_INSUFFICIENT_SPACE return with no
upper bound. A crafted DEFLATE stream can trigger repeated realloc()
calls, leading to unbounded memory consumption and an OOM crash in
fsck.erofs or erofsfuse.

Introduce Z_EROFS_MAX_DECOMP_CAPACITY (64 MiB) and check the capacity
before each doubling. If the limit is reached, log an error and abort
with -EFSCORRUPTED via the existing out_inflate_end cleanup path.

This also prevents a theoretical integer overflow on the left-shift when
decodedcapacity approaches the size_t limit.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/decompress.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/decompress.c b/lib/decompress.c
index 3e7a173..f87efd5 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -240,6 +240,7 @@ int z_erofs_load_deflate_config(struct erofs_sb_info *sbi,
 #ifdef HAVE_LIBDEFLATE
 /* if libdeflate is available, use libdeflate instead. */
 #include <libdeflate.h>
+#define Z_EROFS_MAX_DECOMP_CAPACITY	(64U << 20)	/* 64 MiB ceiling */
 
 static int z_erofs_decompress_deflate(struct z_erofs_decompress_req *rq)
 {
@@ -281,6 +282,11 @@ static int z_erofs_decompress_deflate(struct z_erofs_decompress_req *rq)
 				ret = -EIO;
 				goto out_inflate_end;
 			}
+		if (decodedcapacity >= Z_EROFS_MAX_DECOMP_CAPACITY) {
+			erofs_err("deflate partial decompression capacity limit exceeded");
+			ret = -EFSCORRUPTED;
+			goto out_inflate_end;
+		}
 			decodedcapacity = decodedcapacity << 1;
 			dest = realloc(buff, decodedcapacity);
 			if (!dest) {
-- 
2.43.0


