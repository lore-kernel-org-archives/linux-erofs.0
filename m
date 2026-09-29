Return-Path: <linux-erofs+bounces-4626-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520FFCA5FA1
	for <linux-erofs@archiver.kernel.org>; Tue, 29 Sep 2026 08:32:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvBJJ4FgKz2xwZ;
	Tue, 29 Sep 2026 18:32:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:36::28"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790670768;
	cv=none; b=XNV75l5b68pmZuZDIcXJ807ZJ75G06O2Qpwf8IkStXIOf8rLI2FTC0fcsiSw8nyrrr4vaephnVlQG8lQCxs0XRFmv+cnw/2wqxg/F9EUjSedM3PsuhD2ypcp7xSZ7ydn6kKUadX2d3qfjpBJG0SDuESfYVdHn/54hi+5TPJxSho1Qd+V+yzIP2nem+gyU2vYiBetnj4RNsAXzV2THfvpY47wPrTELLt8lg4b26n0VUKr1V/4uMhh6JaM23pZIVZGed5iHj6UchWxqy5DEiG9vSEVfHrLAyJtev4AYdZ7Hkf9dfYDt8SXeXPfqmysUYYT+MDPGSlQvvgZ4pDuQ2kJfw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790670768; c=relaxed/relaxed;
	bh=Tsp2vQ/i1AKk2o2/ZSeX1uOLKeMrsiHIBClCW0c5sDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H9zJYOvDP7gfZM8HCBsLiBwUQ0m4wMxnAPMQ5BODCTsdl0XKPRrD+zMBCdKYgLKEVCaTDt1FBDhFsfkdI02mros8Ebtr9Npl1S32jc8toKbulMCkrIG9kG07fcQrqnk7D4DgstUmCVBIM6CZeNACRCGIKzcf+L3xGzv/uJEjG2+yjTqk0SIwsI8lGDdjG2yHSoIxguHKPTwJ/WMvB7MYsVEdPR5FBZWCrvfsPpl28SzDTLS5cllrM/0KFkSCARLn3jrQ515v9PlJrpHOrFnr6EhZceRZS1ZfEGhJYvO+SNOGFi5DeduPaAP7CwVd7XBrCaOGDKWLlDun9AtXH90E/g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=O1i01xJ+; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:36::28; helo=mail-dy2-x28.google.com; envelope-from=garvkumar1502@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=O1i01xJ+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:36::28; helo=mail-dy2-x28.google.com; envelope-from=garvkumar1502@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dy2-x28.google.com (mail-dy2-x28.google.com [IPv6:2607:f8b0:4864:36::28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvBJH277Wz2xrL
	for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 18:32:46 +1000 (AEST)
Received: by mail-dy2-x28.google.com with SMTP id 5a478bee46e88-328664c2da6so3344434eec.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 01:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790670763; x=1791275563; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tsp2vQ/i1AKk2o2/ZSeX1uOLKeMrsiHIBClCW0c5sDw=;
        b=O1i01xJ+D5C7ZruSsgfB/6nTnQw1L/TrtBWoYGXAvYTzecl/T+37V1raEB/l57KZTS
         CMnIvDxrh7mHUp9JcHvkY6qnROJmkWaaeEjVrpZoaUJ/C/GNykrIR0Rs6Os6sXONesyK
         fS9fyf3SYpGCZdDKaixTdNVS65pzAOtGMNYJ9V63ryEq8F+sUEJkHpJ94eyduRZFiUfA
         KRwsziOtmRW2qy4YiAIcpRj2MZ4WfTT/ENTSlyeSvlZyU/Jwr/pJDHS5MRkMSxJmhZvc
         AaJLQwjb5YZjLXt6Wyqc3MyerwRLwZXj5isDvGMvQ3VnquMUVgspFSrOYHnU/1BzC2Ga
         ilew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790670763; x=1791275563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tsp2vQ/i1AKk2o2/ZSeX1uOLKeMrsiHIBClCW0c5sDw=;
        b=pgtTsC9SHrX5X63to8DwtrIAMYvXoXLfnP9Fd2Ks2J7kGIGa1S668iZx9TlA6WVl0G
         gZ/e8BTY3wb2ma9hrqEE73uBx79cjr/bF9JQBgChGipfzSmRy3BtOVWVBIJWTWvWmc38
         r20/G75mXmSAak5TkgZGcJXkR3AaYX7+zd6IDuD6DnfYIuPTXdN5TEZEouPrwrDcGah0
         28tpE9ExT0LUOHnlRIxezQcEEtLUKTZ60B7WVrhgeJcj6BgrqEOGeS5LI+qW7aGC05XT
         +l7Hrfv/4wAKYyoVNJs+GmLAvhipjNL8JMatgMKONETnqTqXUHoSz3A+RWoZr/McHQxa
         y7eg==
X-Gm-Message-State: AFq9FYIcOToTIaIhwBEe+e0VbhrUknySQ1GWYqLk4Zd/Qj97FoRaD2eQ
	ZjeJKvA7OTot2+9znBMhU7ZzrrM+OoyoOmtUPzKBgfx6YV5pPk8nhOVO0QUg3GpT
X-Gm-Gg: AYBFou3rMQvGHKVYl6276Sgl44RdejO3pVfsD/xvvjTWvgjIkcU1yWyyfdq3XDAxb+e
	ypSNRdROVRiMeDrlQUeLYmVJEwV4+U35X4nhMBAbuBouwnAWQ9wDShdyioSZMpQhmLuPuESRPo5
	CoikPHl2GHcZmAUP3fjGq3Jv1GlYH2D9/PA9tXjP1nayDUPF96HBI+o7iTDKbPRMTHIkTSmaBNh
	qcpwGDg+JIowDdOYyrE9xZOXNnfwmPGE1gm6v/pWZ0Ndq2dnL982wFRMpah10v2EW8KJ1qtzNxa
	bRaFBvTPc3xKqdmS+iHdeOy04ADLuob09ULauhCCR6gjJSlWUJLzpqgYMiTbQluX2nlUzGZAdCG
	LAcpMyoKYajH1jJgQImJECZekOpuhR++jXQE5wYfXKYkYIOEFqd0g3bW9Jh+ZHQUPgdfuVAWq9Y
	TiSfy7Dxs+LmCLAuIYbGtb4QGs5bR+QwESKY9qX79gyWHs70WOp1XwysnCsgZ0cDHfiwJVpnvNp
	ASfLjyXSWSqpMPlBg0Qr9k8BZw=
X-Received: by 2002:a05:7301:18aa:b0:34b:5ab2:e221 with SMTP id 5a478bee46e88-34b5ab2fb13mr1180528eec.33.1790670763041;
        Tue, 29 Sep 2026 01:32:43 -0700 (PDT)
Received: from localhost.localdomain ([106.221.207.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34141a4a00dsm36345313eec.1.2026.09.29.01.32.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Sep 2026 01:32:42 -0700 (PDT)
From: Garv <garvkumar1502@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Garv <garvkumar1502@gmail.com>
Subject: [PATCH] mkfs: keep summary output with --quiet
Date: Tue, 29 Sep 2026 13:55:31 +0530
Message-ID: <20260929082538.89102-1-garvkumar1502@gmail.com>
X-Mailer: git-send-email 2.53.0
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

Signed-off-by: Garv <garvkumar1502@gmail.com>
---
 mkfs/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index d9b4e22..4cc1bf9 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1551,10 +1551,8 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			return err;
 	}
 
-	if (quiet) {
-		cfg.c_dbg_lvl = EROFS_ERR;
+	if (quiet)
 		cfg.c_showprogress = false;
-	}
 
 	if (pclustersize_max) {
 		if (pclustersize_max < (1U << mkfs_blkszbits) ||
@@ -1743,7 +1741,7 @@ static void erofs_mkfs_showsummaries(void)
 	char uuid_str[37] = {};
 	char *incr = incremental_mode ? "new" : "total";
 
-	if (!(cfg.c_dbg_lvl > EROFS_ERR && cfg.c_showprogress))
+	if (cfg.c_dbg_lvl <= EROFS_ERR)
 		return;
 
 	erofs_uuid_unparse_lower(g_sbi.uuid, uuid_str);
-- 
2.53.0


