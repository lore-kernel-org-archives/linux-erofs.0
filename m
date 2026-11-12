Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65DE606A323
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MfeYONuc
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKtJ3Qnrz30C6;
	Thu, 12 Nov 2026 23:47:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1031"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487672;
	cv=none; b=YLkywbcNF8v+ODV3653yWyYsN2yVeOFel4QQa4lheT+xow7hTnObkvfd/Q7n3ukE/NbCslYlOKIWP5cgdt8NHANyhYBAGHXbDQ3ktcfClhyvgSriSvcxQNpwtXwV75BckVZ05STPxVcZSG+l0y3ZPilAyJkr1iN1ECr7d2V3nocPenNdBIaPXnMXdOqYDpv1wO9X60vBtpvQJRSK8wQSUHIZpoKJF6jDHG/B/31B/h/pWtxHKFaUgLMnm9jFifSPbnzv2no57uSXrgHNQ2FxvFONOQNkl01u1nSAZGTpQmQqxvE5M7PgXwuG5/E2tuYLCPwhmf2Uok4WgvXnArBevw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487672; c=relaxed/relaxed;
	bh=s3g6J5Tc4r2n68A+dQuf9qYuUA77cnOiSmvV5T2YQoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxKr0ogk3xtK7mm1oa0MY1LQWt5gNSVGhMClYYTtNMewSL4Op3GKbbs2pxRyIjLbXg9fQU1qhM6k8gVB2Mh6WptAc4tizG5/aU4JVr8lWa0R5soKUeqpY/LFbAw2D0p9RgmKiKx8wR8S/K4xLvkMv8mxuEOQQGvFPkpqb4h2hN0wtVrDh0gUHc0BMl2DwLZUryDwFnhTOiSxHrFuRPQiRfEaXtuq4/SpjRrhjFmYlXOZhQduOfCQhw5v4AxEKIg6+gQ16UvOqe+sm6nMnCkAn49TrdzDXkJr0w4Taf1qekM1qf6czOeK4JSRMct1YIkMeUMb0ejBLzBjf18pvtLfFg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MfeYONuc; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1031; helo=mail-pj1-x1031.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MfeYONuc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1031; helo=mail-pj1-x1031.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKtH4xRbz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:51 +1100 (AEDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-3b0d09df973so3336910a91.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487669; x=1795092469; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s3g6J5Tc4r2n68A+dQuf9qYuUA77cnOiSmvV5T2YQoI=;
        b=MfeYONucddM4lAxQejSFDjQaC6LCPi76p9pnoukv5n/oSTVLpNA7GLo6vpIuK6nT6T
         rptHxpEQiGahr4n6+yJ7JZOoBtBTE5rRaGVgXAi+qggPsqYkoyYtp8lKToaCl2LCEevh
         +OSLd+o43VjBVws0J+W/EwOEQHzyQf43qZeICHzYmXn+hqwGl7H6qAxShMwJ8qChqhFt
         Q8Fxj05kGO6JQQ64Az2fy/XaSWvcakn93Iap/RNX6YLe6xHHUYY+10sJj+Z5rQAObGm9
         laLS3oR3urrZZOAFlKGIcspzZ5PiYG5XK1eFikEOTVMsRTAPmTHnGH8Z7COPjnnArbYO
         y2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487669; x=1795092469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s3g6J5Tc4r2n68A+dQuf9qYuUA77cnOiSmvV5T2YQoI=;
        b=HrYnxU+b1Y0xa0+cv4PSz51Zq2WcHzcKQVEzYvEtI6ApHf2aaUufA4WmrcHhgPL3WQ
         dAEZ5QLTjil2SDF42rjz7MWU+cwFiA1d0b5GdeR/zeWQNSgL1GhY2EaoEBdC6OlQWXLt
         5JzSB/19pHrer/e4rkXPxOMWN5Pd3wVvvIwdYYYhyNhsfwSmX04SK5+tMn0Z889JmmOO
         ntz8lYN8/TIfIAyDo97N6zoUDQk2Fpsag4vtbw7BuS1p5RlasgcP6kkfr7YeVzYmbP81
         zsV5pPNpVHd+XyXzq2CmlFgSg++JsaRg0DRus04bUtxg0E4zcQBWfesnf2wicxFjpPmo
         4QXQ==
X-Gm-Message-State: APuU4Z/DUinK2u0IUeKMYGYo7cqeTlnKn39FB0CCXh/y8cmgxUBFvU0T
	JyhXMSnw8FS/jugAPkor5CK1ycLXW/7UPVYja0ZDXEB646zIPeztnH/QyGWfqXYcIgc=
X-Gm-Gg: AYBFou1NfngKQeijCRqovvPw1BlwvNuzl/ZZJg21A3UqlMtZnf1gWnZiLkBZkd8qmPo
	fxPUtGUMV+mWWSDrPwukH9oiyP2k2AdzurSl9IvSB3KnG8vZiLGshjFMA74IBWSvkNWM2aw9WZ0
	isVPwomdsFewksK6dmJguR2skZgZuvn8mxFSbWh8dcAYctJmiNt2uiqB8+MKUvmsRHQDwaQLw1i
	uPlDx2ZFYAAGiiF80PY3ZOSK3YIM2zy/fC0tV1SxnFTy76VLNgjpaNlplnMlpmV53Zz801uxbZe
	5mZY8zHWTjSc3B4ZLDmZq+gFmarATNCX/gFUR/x3ABwBqeuJ8TzQTsJ8YFLZlLtAhiQuoFP1TRQ
	+CFwu17uNXrbzRD+2pKW8TEISbQkeFmtMcCgx+wFKJ9zvtXLDWP9xUESfpHmvQHnLLqKEpL8Ngj
	mn99aCGA3lqL+oP/QzBc46gRl8xcJlwE1bm0sYl5uG6eYOaqdKfoGT/STP4MIvAnBUa2OhgWokS
	FDdTachlLracsEH/0kgqPjcyMT5Bamhgjria6iAqrBSR6b7a1eiovhCDRnZMUrct+bpiTwssypz
	hYOmw4caFlA9gQDbStA5ywAlUbeEkyQJ1le3sQucqy8S8MeQ
X-Received: by 2002:a17:90b:2cc3:b0:3ab:188b:c5b1 with SMTP id 98e67ed59e1d1-3b182f192fdmr5927539a91.56.1794487669425;
        Thu, 12 Nov 2026 04:47:49 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:49 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 4/8] erofs-utils: lib: fix buffer leaks in error paths
Date: Thu, 12 Nov 2026 20:47:21 +0800
Message-ID: <20261112124725.2774244-5-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112124725.2774244-1-stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fragment data is already written before its buffer is shrunk.
A failed realloc() should leave the original buffer valid, so the
fragment commit can continue without shrinking it.

Also fix an inline data buffer leak when loading compressed metadata
fails during rebuild.

Fixes: 84bae6acdbee ("erofs-utils: lib: keep full data until the fragment is committed")
Fixes: 1c230a485f25 ("erofs-utils: mkfs: support rebuild mode for compressed inodes")
Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/compress.c  | 2 ++
 lib/fragments.c | 8 ++------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index e1cfc05..b5f75ca 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -2607,6 +2607,8 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 err_free_ei:
 	free(ei);
 err_out:
+	free(inode->idata);
+	inode->idata = NULL;
 	list_for_each_entry_safe(ei, n, &extents, list) {
 		list_del(&ei->list);
 		free(ei);
diff --git a/lib/fragments.c b/lib/fragments.c
index d4e79b2..3398888 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -366,12 +366,8 @@ int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh)
 		memmove(fi->data, fi->data + fi->length - sz, sz);
 
 		nb = realloc(fi->data, sz);
-		if (!nb) {
-			erofs_up_write(&bk->lock);
-			fi->data = NULL;
-			return -ENOMEM;
-		}
-		fi->data = nb;
+		if (nb)
+			fi->data = nb;
 		fi->pos = (erofs_off_t)offset;
 		erofs_up_write(&bk->lock);
 		inode->fragmentoff = fi->pos - len;
-- 
2.56.0


