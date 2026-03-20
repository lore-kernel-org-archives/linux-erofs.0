Return-Path: <linux-erofs+bounces-2871-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B7451093163
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Mar 2026 02:00:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fcQkL4nn2z2xm3;
	Fri, 20 Mar 2026 13:00:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::633"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773972010;
	cv=none; b=kqTKi4yzBKQwaN8AoOw5HuMZA8xK+IsXneG0CfU7YKkYY+Q7BpwNrUnm6v4voKYJsxIX/ecoqtu4dXdMS2x5GH7wWd2d8PZjYAdnNfw0sZoKSKgJPtHkrXABqCTKA2zboTUKT45q71gyzky0bbrTbtF8FxglvhGgxcqX/Nop+zn2JfsQJTvDiG2u8pWXbqVozPyaIpudwzsOw/ouEGi3etLX7ONLgKgQKyNweAWTAy2l3R0WnQZc5OpO0rjvxlWGm5yKOZoe9Pqn1IbiJEMuwO5PUoNAI+IOFHCAHMPAEBX9zjCSsZZplKysXYHjITcdAc3Cz2vUGFBTfTTBjunKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773972010; c=relaxed/relaxed;
	bh=61/lOMRDRrUrxt5y9m0Iyr26eyGHQ92Wc33+MRFGRec=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QLEAu5E+1eBzjDaL+8Xr8QdRbDVYGpHkWvfS+a7naDkOew1zavcO33DNEhiTR8KjfrC2yYOhxZOerAu3wit27babWhbEc4rt8/sqtnqVv4cz6+NZgsPxNquu1cBpPBKuKUieBzFBj7AxI1sXuiNfCFUF7OcobIba6kG4cs/rNNvq+iLaLDQ6HI7P/LUJ7Sb90Z7X/xEgy0WkyiduGdu02G4kyku76xcgMQZhgn0IqXKBzjzLKMX67+SaRjIrM9RncFtihBN++jlFhgvazgqd7bHVMox1Bdovuvhcl40q69z7Fd1qXvN8+Cu9HjPjEDLrRPHRyjmuioEeaFu+x/f8Eg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=in4OReMW; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::633; helo=mail-pl1-x633.google.com; envelope-from=smsharma3121@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=in4OReMW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::633; helo=mail-pl1-x633.google.com; envelope-from=smsharma3121@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fcQkK5BWJz2xly
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Mar 2026 13:00:08 +1100 (AEDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-2a8fba89cb5so1983695ad.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 19 Mar 2026 19:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773972006; x=1774576806; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=61/lOMRDRrUrxt5y9m0Iyr26eyGHQ92Wc33+MRFGRec=;
        b=in4OReMWf3lYATmOLlAxjeZmYTepeXKoB84+IjMFf7OqWWDtMFlEc/X3yceTeVDhDi
         bvU46GSOtbembVxrPqx7F0wkIGb0yLL8P0wvGeNdTHVHC3+8VDHysVc7oXXyyWehnf+3
         FIsGe6BnGXH5YsLSkACstto0CFvz5EGVrdrTv9pG/8saKu/pBDXU6nhMozwvr0GiuZPW
         TvthUJHPlR3DPAn87cAs9VhpxsFCESknZ5kTCXeb7NntmDGlktJv00liXTysTczdppUs
         22N5p4yoGn4c3QGKKdOYWJC/23LY8mHLHIp3CyS34WcUrBONqwFVIo6eOsDfqn12UYCx
         NB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773972006; x=1774576806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61/lOMRDRrUrxt5y9m0Iyr26eyGHQ92Wc33+MRFGRec=;
        b=d4GpnlP5wbMVTRy6pUpnCJKMa6pMdcKcXoT2lv/caT4utdmGlNcaloTsFvZ+w7W6Wa
         F1X7D1RW7miNE5nvRMc8Q6S0IairrHq7MhbAGzG2IuxFk2Bt76vX7c1msV2hn/WcIT3n
         T+82ivxsKhr/EVe7Qgdej0fqUnHPMks7t16aK9ksDsg2Op+qBnQ8cGCdc8Y2QD18vdF2
         zLT++bfg0lIcY3fTKMvBzoC8ZgA5AkQdaQYRcvO1EQw88C5LhTDEYZ9Lyiega1iXfqZY
         lns78v/kndm+7aF4jN3c2/XxMnZgGjEeVM3/ALqQeOptQjkfIgUQmP7Sg73GyTYQewYK
         +ATQ==
X-Gm-Message-State: AOJu0Yxkxnt6kf55F91YaRoxukDrHmthMp6yOyrUsJIZS2Ry7ik5c9W+
	KyH6W62UcP0aB8LQewd/DvRv9rxSMrc+w1bkWkldxrvzRQR+z6zXOdEmZqUqX7nC
X-Gm-Gg: ATEYQzxp/KeKL2UVUu9xOsmAjB4AiFirC9BsL9vLniS3lAA8SC+4JNiesRCplbmUuzM
	DEE07iK5wOdYa5xMuBCdJGco1szv1uLn8Ieg6lOp4WaqiUVwd/ih5RxA9pQ2jzZBBzMHzUTmtht
	B0D7AHJoZGvJhxbex5iREybwENoAn3aOuiliPPI7Xzp1R8gSgEKcXfLTme/TlvW3hTUA8+RaWlP
	w0iIQc5k6clgxpoFrfG99gqK6jiesYFi2dt/R8EKgYN30oBkQwLDjt5QBvoMhIqI+YAtqoHFZWF
	pXP861lys6rrrrYysebffxyTr66cDgTbAoS0TsB4HQ2+I9TfB2TgJACAV47ZNJXUUMFAUu4kN7W
	n7tVdZ30TZidUCgRtinyOVft5dKsHt5b3xcLfxS+h9SQ5G/yk2DlkqJO9Je7qeoheLKPjMDK9ZW
	KfqaI+dcZFsC0anKAFG53R5a3SlT56nROvfVyG+dgNw7urkdEzDiKrkr0=
X-Received: by 2002:a05:6a21:4d18:b0:394:1532:6619 with SMTP id adf61e73a8af0-39bce9f733bmr860723637.1.1773972006034;
        Thu, 19 Mar 2026 19:00:06 -0700 (PDT)
Received: from localhost.localdomain ([103.115.155.109])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b040da3dfsm456331b3a.45.2026.03.19.19.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 19:00:05 -0700 (PDT)
From: Vi-shub <smsharma3121@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	Vi-shub <smsharma3121@gmail.com>
Subject: [PATCH v3] erofs-utils: decompress: fix QPL job leak on error paths
Date: Fri, 20 Mar 2026 07:29:47 +0530
Message-Id: <20260320015947.2325-1-smsharma3121@gmail.com>
X-Mailer: git-send-email 2.39.1.windows.1
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

Two early returns in z_erofs_decompress_qpl() after a successful
z_erofs_qpl_get_job() skip the cleanup, leaking the job handle.
Use goto out_inflate_end instead.

Signed-off-by: Shubham Sharma <smsharma3121@gmail.com>
---
 lib/decompress.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/decompress.c b/lib/decompress.c
index e7ec83e..eb696d3 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -196,13 +196,17 @@ static int z_erofs_decompress_qpl(struct z_erofs_decompress_req *rq)
 		return PTR_ERR(job);
 
 	inputmargin = z_erofs_fixup_insize(src, rq->inputsize);
-	if (inputmargin >= rq->inputsize)
-		return -EFSCORRUPTED;
+	if (inputmargin >= rq->inputsize) {
+		ret = -EFSCORRUPTED;
+		goto out_inflate_end;
+	}
 
 	if (rq->decodedskip) {
 		buff = malloc(rq->decodedlength);
-		if (!buff)
-			return -ENOMEM;
+		if (!buff) {
+			ret = -ENOMEM;
+			goto out_inflate_end;
+		}
 		dest = buff;
 	}
 
-- 
2.39.1.windows.1


