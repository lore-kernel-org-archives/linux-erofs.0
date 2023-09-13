Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72923EE0211
	for <linux-erofs@archiver.kernel.org>; Wed, 13 Sep 2023 22:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1694643119;
	bh=4A44RoDfklc51n8+hYlXfd7pnm1MJAH4z1HIawYzJxE=;
	h=Date:In-Reply-To:References:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=KIgtvTOComVUw6+YCNAlNWpIqXROsUoDh5U5pl75ES06rZiLyo4FrtHG3/klN00KL
	 nV9whZ9SYjRWR8OX1LjS8qpkBm/yNrHzH2NJ0+gqQ3ajX7ALTGkAxXU5anSaEZSWzr
	 ZC6ppHaPxlvzSIMWQ5S9Hi6wQrHFJNRYGLIYnQWTLJb8U44mLgEbazNwzCBudeNAxV
	 ISD6JrvaT+0MA4ZO0/Vqir479KlypUUx+25JderTc7TQdNRemv8pLCMwcd/Tj1sY17
	 4NHExIJUbBB0wvzo2jSDhTCueX1yMUM8T3IHv2GjrJ00fgAAl0AFkh63AcpyQdoO0u
	 DchWigsBcedBw==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RmF6l0sf6z3cHR
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Sep 2023 08:11:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=R5xt2xh7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--dhavale.bounces.google.com (client-ip=2607:f8b0:4864:20::b49; helo=mail-yb1-xb49.google.com; envelope-from=3kdmczqckcy8oslglwprzzrwp.nzxwtyfi-pczqdwtded.zkwlmd.zcr@flex--dhavale.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RmF6C6zNwz3cCM
	for <linux-erofs@lists.ozlabs.org>; Thu, 14 Sep 2023 08:11:31 +1000 (AEST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7ea08906b3so373652276.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 13 Sep 2023 15:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694643089; x=1695247889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4A44RoDfklc51n8+hYlXfd7pnm1MJAH4z1HIawYzJxE=;
        b=YUDP1s2nqrnaFIOwvlZ1JXWzpWnRAAEzIqeqisVjH0MAFKLsgyvVWXa4IplwrA1HLE
         7tGHTV8JH7ss4tcOWXgqLeCAiARzqATIjF5PK+4NB+QsLjXtJP22gAzTM5lYN5P8umSo
         B+dAHWT7Xp1/erScWOm7DKROyujnCSGTwAWmeakNzDuqOmQWKp/tEAF/4WMFM1jZv0HF
         zwkVnMF7Xn4KkhbKt28ZAPQ1xmkOxbt+/leCTS8qrZS0aAuHAr7JA3MAHeWg/werEPEf
         cIeb/bgpU9o6kMwjx93HzdrmZD/J6O2u37m2M70WpnEJ1Ft9qwkMSEllWuT22dnlo6l7
         WLqg==
X-Gm-Message-State: AOJu0YzFL2fpcZZxZnESiFWHjlwU9ZIwYXo5LCkNpr84zNTH8nO3cKlO
	xXercOfqFR05IjglXt0EbTTIMENJ6O6mQICsuZMQbBURuGRhtUQfXrkrUqRVMmdKbKlx72rccCb
	1s06RJwQEOomSxeHLARWEr6Agq0ehjFtSx/2hCsOMYrnYbuUQu1S8ZJHX5Kd8pzOMLFt+x+Lr
X-Google-Smtp-Source: AGHT+IHM+Wuenvwk0Sp8MQ9Xcq616ZxEKaIgr0729SdNBEBT+d+Go5CNC5vVU5Z07U9Mh5DsypYHsT7ddGf3
X-Received: from dhavale-ctop.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5e39])
 (user=dhavale job=sendgmr) by 2002:a25:7342:0:b0:d81:6637:b5b2 with SMTP id
 o63-20020a257342000000b00d816637b5b2mr63262ybc.0.1694643088948; Wed, 13 Sep
 2023 15:11:28 -0700 (PDT)
Date: Wed, 13 Sep 2023 15:11:03 -0700
In-Reply-To: <20230913221104.429825-1-dhavale@google.com>
Mime-Version: 1.0
References: <20230913221104.429825-1-dhavale@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230913221104.429825-7-dhavale@google.com>
Subject: [PATCH v1 6/7] erofs-utils: lib: Remove redundant assignment
To: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
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
From: Sandeep Dhavale via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Sandeep Dhavale <dhavale@google.com>
Cc: kernel-team@android.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The intended assignment is already part of the next for loop
initialization.

Signed-off-by: Sandeep Dhavale <dhavale@google.com>
---
 lib/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/namei.c b/lib/namei.c
index 45dbcd3..294d7a3 100644
--- a/lib/namei.c
+++ b/lib/namei.c
@@ -262,7 +262,6 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		if (ret)
 			return ret;
 
-		name = p;
 		/* Skip until no more slashes. */
 		for (name = p; *name == '/'; ++name)
 			;
-- 
2.42.0.283.g2d96d420d3-goog

