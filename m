Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FD0606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IZrqVrUZ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKtD08zfz308H;
	Thu, 12 Nov 2026 23:47:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487667;
	cv=none; b=hQp2ZVfPivXWwLB8mjzz9jbEGGh8cpbvVknUdSv3Bwxdjnl7fw6PBwzEB7VP2pLEkM15qrxmTlZuJm+gK56PqurI4bc6RFe7nd1xDXGJhcAetXbK+myLtgozn0410NwC+k40ZGZNJPhKsdZK8aBLdxt5nYerjrZdNpTDs3A5K8jDzw8aG7QCJ/WCMWo4HJ44iXA/ewubtulvpPpvuaQQqqVquhlP8lKLRFCItXFAWwJE2yDRvXWSlL+AyeMM/nBFuxQhA5VMJZiAyR4ZsDou/xr1Jge26/WxTupNhtk0VOX0uu5A+r/8Ya3Hz8n5cnE5oTvHnVWUsVS0dbceeSiOzA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487667; c=relaxed/relaxed;
	bh=Ccf2tA+u0ITNQSGnxfCbG0ulPNf26II2Qmu3vURLPYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft7elTHfJviQPfer+sN63aDjm18wzeo1lGTF+T/RoamIya6lMcmyVqTtjV+AWQzHmKa3pxVvruq+FScf2eOh5GbyJ0/OUnyS/CJYj8VMgN9Z2arKrDtXUkAtGFwc1LHVCvN46tOsWcBJX117WBzrYygVBCyLETDInEAeyWmlzlDXHjd6eW/ae6kpSxvljgHu1yYk1HIgGMQWIwVdKw31zIncAML0dOCd3ivDQPSrOnSDoSiSB6wTjloX+aiLw7hcbvq1iqdKn2od0UJb9K1Jgl2XOXZFbnumkGSbAZsnlmaovlhojQAO+jujzPfiSOTsnDs2dMISDE5dKpPLvdGwgA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IZrqVrUZ; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IZrqVrUZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKtC348sz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:47 +1100 (AEDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-2e987a2ba0cso24757145ad.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487665; x=1795092465; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ccf2tA+u0ITNQSGnxfCbG0ulPNf26II2Qmu3vURLPYM=;
        b=IZrqVrUZKIbeLstCkLhxxqfUi9pVf+MC3R0CWDItNbRj2nA/aSMsQ1Cc38XcGfzlGU
         LhMcWRStxVZoPNHhgDSzVdvsCRFIltJOklYWQyU8keGZcCkR45/XT82ilzpYQK51Efc3
         TYcnD8D50+NeIdTXjhrxrVRXmA0K93QkoW663AeTAQb6tMjCPvAA0ubN0A/RUC/dttV8
         kDkh/hIOhUsJq3ItlWy7ct20j2JOzjsb0xiFoPVO84FnoQYu3xArgPLVt9lHc/Q6yqNa
         /CF8yXy4mHU2AJ1BihJQdUYJNniARubIE4tV+jrc8ra3TkAKhrmgzcmFO61VIwllM9Kt
         aPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487665; x=1795092465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ccf2tA+u0ITNQSGnxfCbG0ulPNf26II2Qmu3vURLPYM=;
        b=0gmb8S4voIG1LhXW8qlVfIKbpeVF1u8TYTL3jcG4xIFgAC+bg0AUYam63AzvMnnW8H
         ynfHzyBjXhINVyvJ6CZ+RBggtGo94RhuqEK9R3LOVb3We3WqR5wI4AMd+H8G16yFje2I
         2TYixPT2EyeeHoNx9XlsJ9GxtBphGoa50yZ/RyGoflm0IHBgN5koETE0J1u3CZf9nAu0
         iw45he4Tm0ouW8OLREav+c+v2H1L03yKEV15c/2NkNoKcNfXahekETKfrUBAVM6suo9D
         Pl3G/pP3XbryEPHqAvNvWgN1BHa2NoRd4EafAHQUKyeQ5axsPTP1BHpZVf06RvqDrlF8
         UKPw==
X-Gm-Message-State: APuU4Z8wc4Uyei/0RMd/odJidE1hh2F/cARdOcXLRb9maQ5x/aoDJ01/
	y9wIbSfAflsHZE+FKwJrixTydu066ysV5k0iZ3tqZ5tl2WWFpxXmxdV6s8Yja6nXUPw=
X-Gm-Gg: AYBFou1QlBWPamxJT9VT7/yL4x/gP1z4qObeXisPzyICXTOgPTVbVkj/UjgQkr6ghhP
	AoZ8tf9DVAjP86KawzPnYwsS5avy89UePzvcSQI6G89V6A2I/xr3sy+DK0g+e/KzJ1rwlV1esmf
	YB0US8shonhbPVb2IpY1c4kRBFWICGA+DWi+0kAhZ5UImHH/pApfv885ICgDk+3dPngU0pXAbsy
	OLs3Ib0QKqWFvxFmYith2DL7yMXBG5lnV9+xyfiTRYWky4J0zQkpKzDUVkEx9/OtC6VCr4dq5ZZ
	BLrrBiWZ8n2Hx6UP6qNk8Kuyx8MLbjeLKmje3084W/SErHZVZ8Md4L/rMxg8+09q8LHlsdhXKqz
	QzEC4qyQX3pwWLE+02YqFQ5ejSeuVRo2hLYDT3n2oY6wKhElE9T77IhWf9xJWoPHJ3tRG5GJfH8
	W7UVXVkwssp2RFa9sK77WA3UXA1P+d2e7zU936C8hu6xQWxUDrirupnOi3LcBpzAJds+O1VViE3
	+tV3SQ2wDgHDgw3IPBnYWFqklHGgZt9Q0YvX5pT2W/zrRi5zxkTQRYkgQiRR3mjamV/8BE/nbrp
	+Yd/Q59yIshO+XYw1/puKvIDxzBO6t1zR3XSMWItDS1+SMKO
X-Received: by 2002:a17:902:d483:b0:2e9:3dd2:a8fe with SMTP id d9443c01a7336-2edd76c1e68mr56528045ad.21.1794487665187;
        Thu, 12 Nov 2026 04:47:45 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:44 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 3/8] erofs-utils: tar: fix out-of-bounds access when trimming PAX paths
Date: Thu, 12 Nov 2026 20:47:20 +0800
Message-ID: <20261112124725.2774244-4-stopire@gmail.com>
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

An embedded NUL in a PAX path makes strdup() allocate less space than
the record length used to trim trailing slashes, causing out-of-bounds
accesses.

Use strlen() for the trim length and handle strdup() failures.

Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/tar.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/tar.c b/lib/tar.c
index f5034da..bab855f 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -527,8 +527,12 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 					eh->path = NULL;
 					continue;
 				}
-				j = p - 1 - value;
 				eh->path = strdup(value);
+				if (!eh->path) {
+					ret = -ENOMEM;
+					goto out;
+				}
+				j = strlen(eh->path);
 				while (j && eh->path[j - 1] == '/')
 					eh->path[--j] = '\0';
 			} else if (!strncmp(kv, "linkpath=",
-- 
2.56.0


