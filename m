Return-Path: <linux-erofs+bounces-2692-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2ED10854B4
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Mar 2026 23:01:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fYH0G4gvqz3bnL;
	Sun, 15 Mar 2026 10:01:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::532"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773529278;
	cv=none; b=nQC+lLB/5Pl3GuNa9+8qiTHZfkzScLaIsEhxM83zGLtbtjNTNKRUdVg4BwWvHisGNyMQ1IV3I4IEV1/aSCxIIVDp3vOr3cAEGbKMU63luBeUAfc1Qs2Y1IWcXrSu7Xizwa+BalZ5NzCddARd3U12243GBCF/pm111Vpy+C879B+9x3PdEki+7S72YuWgkPJhpURR5sZAtmn1Z72CqQ54yXadOW8hCbMeVEoEKyEdJCqLl0zpi2Q5wHRrLDCHRiStcJBf4Hmw4FJ2dCkGSgTA80EC20fg63NpuWHV6z4WM3BXnxsg++Fb6ZvCPjstt1s8FhQ4vFcMud7PgXl8NP0p3w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773529278; c=relaxed/relaxed;
	bh=z2ubEZu08kNYvTY5shpQNqpb3ZkDkRqA4suelzjzeyU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i3bHc0FdzyAPRxW0r1rv9HBjG0i8VmAn8bpOowbwNrLFQ6AoOHQBjnGmhz32PAb2boP1c24jHyWASIrRDRCb6g+ll+wppkO9hmDqYvT+Z63hgd4Iiy1glJ6C8L79jpvt25RUR3RYJeCfDq21cO7d05D13d+AIg+J1Q71ZXA5k7whOr5OL+XxqEgmFVx7yeyBlHjl23C4pLswcMsJG7tkpFx/j/2F7gZzkwVfAj7PxT43NsaomWtrYuZRdGqq4QWx1QXbQQGAgjClGz/hRupUicM4SFZRu3kD1/Ljyn+4Sprae/dW26SG61Qqb+mjmKhXIK63JXrz/+4KU37CHk52PQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=ibzP3ncn; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::532; helo=mail-pg1-x532.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=ibzP3ncn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::532; helo=mail-pg1-x532.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fYH0F5Ymmz3bnD
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 10:01:17 +1100 (AEDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-c629a31d1d0so260949a12.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 14 Mar 2026 16:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773529275; x=1774134075; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z2ubEZu08kNYvTY5shpQNqpb3ZkDkRqA4suelzjzeyU=;
        b=ibzP3ncnrqr4KlGfaj2x1XCwYVxJNMyC5MqBtG/laCD72BP4gqjcoLLLV7sHkNGfjB
         XJAvC4AlglyZPHd0gPX8IgMUTwR2RVQRTevyyIfeiDxwKoV1VgjYoiv36rmLEHKwKhgm
         vVF20fOaZeoVH3b+ysvEAUDUz7LvzFctktOiVKbeJzR/Q2tq4gpvO290iN19Tv2odeUu
         0UniH9JzsOUCtgsnn7A+bfEOE3qqsuQ2MCtp5fWpzevomG9G68Y6Z0SLua8Y+j6x0WaU
         jGxxI3XaDa3c4W8dm22TKPrWsgoDUaZOEcfYmwvvKgyEAVpv3HbF6a2uiWJcyNkG+X8w
         23kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773529275; x=1774134075;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2ubEZu08kNYvTY5shpQNqpb3ZkDkRqA4suelzjzeyU=;
        b=mdyuSQa58pM/ZPRbKrzwYVy+WQ/jQ2ffzxy4XUMwuWJJ9y9zLldgYo/pvhuqV8uYoG
         f/C76FZ5UxQ+X4WYK1TyUcjG1yR7nN9YIc023jd7Dt3xrClvlz3w5lGfFCV1HHYjRaEm
         wmPqs4nXaHre7sWa+i4V+GySWr5dcUDIzQpzbZhvVxfcvH+6/tR+dFzul1r3ujYV7QY/
         IBr6tP2Yv+cXajKE2Lgryf+we4wBxOb7cYj9NzLeyZyDf6ADYHCHoDFEqCk2W6t/GIRZ
         Wn3quKt4PLkDJQZTkxQTVPrGh0FKEicnyZpSXoHLScDrNR2UGIvJ+/AxPuD3n/mDRm1m
         jNCw==
X-Gm-Message-State: AOJu0Yw8bEhHaC9KU7MwSZBee1aW0yteRPRyWMMNQLZ8qmXD8B6T2Olg
	xMQHnoPo5bZkVrEl/awB1Kn6vn77b65S228R8HieGriLlZXd3dv6aB6gcXF1ii9N
X-Gm-Gg: ATEYQzzh2NSHMUVgXrJRuhNW9OTAlfqlTLz/jfTNAyQ0ZS06xzeY8t7gY9GXNI2BWGj
	EmvU/maVpHPdxTwc/Qsl7GwZbVy79k/BWjWTKl11wDQwNObZNyLvZdu2R6iAl8v6QjErtEJZsn2
	CYsidhHfouGiiibRWnsyOPsgvkqcrS96fjtDbKiI9LftGZhbX2YE67Tg/cz9yDForuDxDxW+e6M
	XnRaTL3kxjGWferqYujBGdjOAvnhXY/b95Kh8Tt/b+OSW84SFEdPzt5/BMtSiO6uPmg/7bII1e/
	RAfHqJaQvHcWpkAHuOV/5BwlcAYpoPomPHkkVVm5ml8pmQovUMi5Xdwh7d0FtMA4TDWEAdrFTVM
	ErzVI7mJuryxRcX8rbBrsFRSozH7yd0ykCnvUIeKyRJDjjFUFud+VGnxPPNlJBQZDQcF32UJvVO
	dS9lobvl8nx9ePZpllriVlZWFe6hNT9T5a+sVv+AiyT0ggT1k1MYrZ9t5BmUfi6DdKLYAbYQ7hp
	lgl1IewWxgOYv8ZvjK+emXFVg+EGmTqlIG5
X-Received: by 2002:a05:6a20:918a:b0:398:6e38:95e8 with SMTP id adf61e73a8af0-398eca24d7fmr5288985637.2.1773529274985;
        Sat, 14 Mar 2026 16:01:14 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([14.139.242.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07340518sm9549375b3a.34.2026.03.14.16.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 16:01:14 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	zhaoyifan28@huawei.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: lib: fix decodedcapacity integer overflow in inflate partial
Date: Sat, 14 Mar 2026 23:01:08 +0000
Message-ID: <20260314230108.40100-1-singhutkal015@gmail.com>
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

decodedcapacity is declared as 'unsigned int' (32 bits). Two code
paths can silently overflow it and corrupt the heap:

1. The initial assignment shifts rq->decodedlength left by 4 bits
   when partial_decoding is set. Values exceeding UINT_MAX >> 4
   wrap to a small integer, causing malloc() to allocate an
   undersized buffer; a subsequent write overflows the heap.

2. The doubling loop left-shifts decodedcapacity by 1. Once it
   exceeds UINT_MAX >> 1 the result wraps to 0. On glibc,
   realloc(ptr, 0) returns a valid non-NULL pointer; the next
   write into that buffer is a silent heap overflow.

Fix both sites: change the type to size_t, cast rq->decodedlength
to size_t before the initial shift to force 64-bit arithmetic, and
add a guard before the doubling shift that returns -EFSCORRUPTED
via out_inflate_end when the value would overflow SIZE_MAX.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/decompress.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/lib/decompress.c b/lib/decompress.c
index f87efd5..ff703ae 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -4,6 +4,7 @@
  * Created by Huang Jianan <huangjianan@oppo.com>
  */
 #include <stdlib.h>
+#include <stdint.h>
 
 #include "erofs/decompress.h"
 #include "erofs/err.h"
@@ -251,13 +252,13 @@ static int z_erofs_decompress_deflate(struct z_erofs_decompress_req *rq)
 	unsigned int inputmargin;
 	struct libdeflate_decompressor *inf;
 	enum libdeflate_result ret;
-	unsigned int decodedcapacity;
+	size_t decodedcapacity;
 
 	inputmargin = z_erofs_fixup_insize(src, rq->inputsize);
 	if (inputmargin >= rq->inputsize)
 		return -EFSCORRUPTED;
 
-	decodedcapacity = rq->decodedlength << (4 * rq->partial_decoding);
+	decodedcapacity = (size_t)rq->decodedlength << (4 * rq->partial_decoding);
 	if (rq->decodedskip || rq->partial_decoding) {
 		buff = malloc(decodedcapacity);
 		if (!buff)
@@ -287,7 +288,12 @@ static int z_erofs_decompress_deflate(struct z_erofs_decompress_req *rq)
 			ret = -EFSCORRUPTED;
 			goto out_inflate_end;
 		}
-			decodedcapacity = decodedcapacity << 1;
+			if (decodedcapacity > SIZE_MAX >> 1) {
+				erofs_err("inflate: decompression buffer overflow");
+				ret = -EFSCORRUPTED;
+				goto out_inflate_end;
+			}
+			decodedcapacity <<= 1;
 			dest = realloc(buff, decodedcapacity);
 			if (!dest) {
 				ret = -ENOMEM;
-- 
2.43.0


