Return-Path: <linux-erofs+bounces-4575-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCE3C982CF
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Sep 2026 03:54:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hlhhD5kXSz2xYh;
	Thu, 17 Sep 2026 13:54:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::11"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789617244;
	cv=none; b=eMUqL7sRh1r55cgTH3nri8p5j7s/jHOArLT2mgTGRKkXG/loDBIjBYhZe3kUPmem9wvbER2t/4vctH3FlRAfWnLpwuck5UYGZEqPlHUlAKmny3/jpSsslI346HWHneFltG3oObAPW77uTW0+ys7TrWD/zs/bYLbg0lGuoGkB0JeH7wphkrFL/gRnsbu+84AXQr6y3Hp5CgIzycyj1svMEC3vtNJSrzq+anzKjlQzwWM60tEg+Ilto6s2BBUrGGspXBzOvDJcqI8Q82xJKIlSv1mlb5P+UOHlxFr6YoBODkuUekEjyAb2yx0Ykr/JZWWTXTv8R6C6S/pbW/8Y/qi0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789617244; c=relaxed/relaxed;
	bh=LEiYO7vIwlZ7lFS+2EzcWNkKUltSrmqR3qlO1+3fgt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLMkLZXH3OM3kGjKwSEite9Xg1CZ59j5v5zdzIwDy32fAxk2o77tCTqBPxv20drp8lKc1H+5hfa/9f5UZqXzG0zxuVx9yqy/sSc7O5j5gYsHU4Nm4gKhCkIuq3SjRzjFZyoYiyIgeEU8Q5KyUP9YHsRlhdTFd81f01Vs8U5ctVsjC5D79tkcsp2EE6pDe2MCEqkGoAlae6kI0r+hDHbX8pAxk+5Dl33Se4g7/tFvNUFcsfrR6lECojcvdRq88dEG89w+84E7E9URi536xq9GcI1rBAkjZFjQWldBRB67z1UrV3i6nsMX9Zp0YXJhPYFEljiMBiDlowpwokoKNGOOwQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AnSwXlAa; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AnSwXlAa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x11.google.com (mail-pj2-x11.google.com [IPv6:2607:f8b0:4864:39::11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hlhhB6prVz2xbQ
	for <linux-erofs@lists.ozlabs.org>; Thu, 17 Sep 2026 13:54:02 +1000 (AEST)
Received: by mail-pj2-x11.google.com with SMTP id d9443c01a7336-2d8fb334e72so3701355ad.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 20:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789617240; x=1790222040; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LEiYO7vIwlZ7lFS+2EzcWNkKUltSrmqR3qlO1+3fgt0=;
        b=AnSwXlAajPJTAFCdQzA9YnZaOkg17epLPKzJS7vMEI3/RNS6sqHUNm8Jdxt3ItSIpk
         YK87Ds9xwXSH/kPo5R2+dAlOWsN1gQPoGYcqM5bPeJy1ujMGtJD2a04lenPP/wsx+ZrJ
         Y2HuMHbdJJ2hc11K9W0MG10BNzqWq3ljtQRz/Igvr0kgyO+Opj/qjzowiO2VOw4YI/yW
         JQT1yNQqEZp8jxGpg4n4cpUmPHqUrIHzCbSjaZtjA/nAZOknHh1ETA8Vx/cCkAVGgWFW
         8nt+28vvDkgtd0pr7QKGE5Cfqy59QdGyV8p4uL82TEf+/pVb/VOqYeFFFN2zqtg5gbsY
         2F7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617240; x=1790222040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LEiYO7vIwlZ7lFS+2EzcWNkKUltSrmqR3qlO1+3fgt0=;
        b=w6H1r80bkskjBzpS81AuVlUUDNwizOz64FSlgaoF7Upe02gbIfoeNri6QmqJMk1wWx
         lLg63EWQADCHeUnRxNB5MiepLAbBlvMGTZ7lv61fz8nAL1HKk6kmwgNN/hEOwfoELMP+
         8FXPmfehK5xO+suDOIB2m/4RqT2m4vk9wqA4USY0EqyMZ/drg7RRo2TZ93dGWhbad6G8
         sTGiIeMZCNsL8h5etqfxkITEmBrmDw9BDRRc7Mm0lPocdTbwOdSb6pIRv1/e6KsxuG4Z
         R74jYW2tnxA+meteRabCLbqVKjLUXZSXG7EhAEQrg2aRYSGaMVg27OpM+8CCeh67iuHA
         Wuqg==
X-Gm-Message-State: AFuF++nfq+dDT/+w4ruTfigQCluGNCTG9Y/OemelgewKeRZLCKPnG8P/
	Mgz3YATWJ0dTtJ8hN3AXqvwfD2z+0UFBIsGbdknq/jH7CxVVWid2aJImMCSaJkFEL/A=
X-Gm-Gg: AYBFou3QXY5pc6Ly4ZG07k65xSuUFgSjlRnmG5SyqibFyAiVZmr62U6fWgfW88bzO6z
	4r4CHQ5YjZK9DbQ4U+rlkO7p8rvltkDJUR/QL0r6FI2LQUhaDBc7trQ5m/+7YAGDWZHxXImoLNy
	yPweKLYxig2SCkNTR9iRg3vTervWNFa5yoCEtnEeQ2H5lVRbEEVGlqyyE1jg8YFsqVfavqF3JvC
	8CiVPgCef2BWevQbcEpD4hM5QXZKpQampr/lMWoRsveaF4uFlPgHN+4Sw4Ht+R0btj44UC75wrN
	hm9vFqrC8U/w6HbO/ozOKkDV4H7028OUwVUiGAQjGN0cwCECL9BzKXCx5ReUkL1FACm0WOsJ2e7
	N0eGBiGRUfaKmN4UHq5tviISh/To8r8NfHytstsIQOhp/r9onY2kp6NgBtrauEp/xzMN9oP9I6S
	5F/G7qhgbQMy+yCVTPvFZ6dN0BhES7eD3seIvv9SalaVamHjahhk5ow4b8Wh51JRpWvJmN96mTO
	C7wN2haoKaQuVHXmysAu39ikmtYHIPOVcK1Lv67K4jsxkA0BHo=
X-Received: by 2002:a17:902:db06:b0:2db:18fe:bb08 with SMTP id d9443c01a7336-2dd8e632e4emr110152315ad.10.1789617240477;
        Wed, 16 Sep 2026 20:54:00 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89ee3557sm19423245ad.52.2026.09.16.20.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:54:00 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 2/4] erofs-utils: mkfs: validate chunksize before computing chunkbits
Date: Thu, 17 Sep 2026 11:53:47 +0800
Message-ID: <20260917035349.1339521-2-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917035349.1339521-1-stopire@gmail.com>
References: <20260917035349.1339521-1-stopire@gmail.com>
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

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 mkfs/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index d9b4e22..f0d3d8c 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1262,8 +1262,9 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		}
 
 		case 11:
+			errno = 0;
 			i = strtol(optarg, &endptr, 0);
-			if (*endptr != '\0') {
+			if (errno || *endptr != '\0' || i <= 0 || i > INT_MAX) {
 				erofs_err("invalid chunksize %s", optarg);
 				return -EINVAL;
 			}
-- 
2.55.0


