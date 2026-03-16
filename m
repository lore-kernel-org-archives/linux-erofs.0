Return-Path: <linux-erofs+bounces-2766-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45989F013FA
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 21:29:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZSs01bWvz2xlh;
	Tue, 17 Mar 2026 08:29:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::430"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773696548;
	cv=none; b=l5ngCRwDVBTvHEb/KBEeXpJ667CsxUPBw/R1DMio9O8aIsk25w2LQGT9b/PE9AbWZiG7yDeMMZTP11m+z//JfJq0NvccB6Hf82iq1yhVfdUiW4bjISLzODKEUa/RrWPP4Cto9+uPFit8qG92naQriCP/+SOtbiqoG0ttvzgBedRH9asukIoStNcvyXPwtDAPbgUcRoxFOLbUG0T7jEjAp4BHif72uAngTAPkRZ+nITyKYJbR04WlXyhuStJ6EpKcPtIn4aAEPg8HQkm3sQTNTt5l0As467KrmW6FqrBirJljt9SHEqhPuNCIl1RuvEX9UkccFzhUPr7MB6vLZ0OzrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773696548; c=relaxed/relaxed;
	bh=aQM2eBicAhXo6KwJOIN/BFJJY6gLG4XSDShB32qmhRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4zMiGTUETpsOJnrr62d3rlWiROp8ML9L78PGl1MuvoB4ve8hv00/TQMCa+utwBlKwEsdUJ1SPu1Hevv0J4V7MkeLLC3PDm2AzwWhqfhiAOEQZEi+Dv/309Ab0qbFtFodT1tpMXEm9J9UJ88CiVgjYa1fG+ORJOpQcC1Wl5vGSR4xXzS0bmEMVu2b8OvNICVqM7yENLBsXZ9iGRvjs54QG1iwMYX0G630vcxsbL+igkn29RAZvdzXCdwv6Y81B8QLXIpDYAMncr/vgMGmRORhD1azM8dFFqOdbNgNdDXqGqQgPAYmM29wt2RYx8IOhbOCxTRyhki08p6LE1kET5wlQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=RussNVe6; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::430; helo=mail-pf1-x430.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=RussNVe6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::430; helo=mail-pf1-x430.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZSrz4h8Qz2xVT
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 08:29:07 +1100 (AEDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-8297bc55c0bso395640b3a.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 14:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773696546; x=1774301346; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQM2eBicAhXo6KwJOIN/BFJJY6gLG4XSDShB32qmhRE=;
        b=RussNVe6zlYt90dQ9bs2y8SfjYbV4WxtTS7Eu4n+quwO7pbP907AM4an9h7W5FI93p
         L9MSXbxwB9JJvIKe3TIWa8/eaiR/Ss4idq7f5bhU4tdeOM8puqY9woPIqXESoVS+KkmS
         jqH78156f0SoRirHtAhgPkqeCS1tR3ZolD7NeFNedcXfZAGEqPMQIAbmmloP4y+AR6LT
         U0FEuk5GZezsXnbmsi3qvrNaEUTau8EhjCmVkupLCnRz1Y5P81gZxEIe/6/legsXbXqJ
         PwhMaQHIUe+if6M8rbkJZ6Ell1BoiYJSIOEts7bz0dAAz1GfxLgWIZR+onxVeqZJAOhB
         gCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773696546; x=1774301346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aQM2eBicAhXo6KwJOIN/BFJJY6gLG4XSDShB32qmhRE=;
        b=gkdN86XT1xNTn98yOBjxwZXuBtvTd1T3GGQaRCRoLJZatTggIpt0avjwEc75KYcBMa
         XT3XkCpxMd0ndFpQGAQr8Hv6jEQZ4ApMhSsBRhTPXWlMtdEq/Y2EGuOS6HaqF/9SJNny
         vVqxaFXUWorTS+ecGVK1iShRCNrlX1YSjJAbQjXZGfU5Rhc2XAtMu4kF8EL6JwePcRaW
         s09f2OY/e1mlY/oQ+pQUCy1wnY6qoNlljbU6C0RUa6VrhSAE91dBuwvQI5LfC4tefcXD
         JXyiMZPcGgrTvhV2y8RbXyr/X5CahD8A63+l4nHJttmrZiuIAUGy1b/yOg+ATN0g0xoA
         cCSw==
X-Gm-Message-State: AOJu0Ywy0mJlFnU3D7Vc74CXRu1OUPNvJXzUpKE3U8/KciDd/SXiRlm8
	eTAdmA1a6+VwTAFWOTJhak5+xYvouzAsf4/MiZQnu0qCyayYppr4e+eIrOCmKrM7
X-Gm-Gg: ATEYQzytVYIzO4nmeocKdPnQTGNcHCFYxLORY+MIJ+z3/E23FCBMWGP8K7OtwbGuJ0e
	mP9Fp553KpEmJoVX29l1AgTF/p+xtYz076ATfne1gvzWIzcE+hNYb4/Lj3+DhK4xrDNYWINaXlr
	XMW4aJwUj99Vqh6MXxvxiuYTaTYeAJmajng9PyF5QO7cvRCp8/4jDXgSehKJoDwdViD5ELpaRrv
	IpVtIRap4q58/UetOzKXcEbDgisbwEEsbP1YRjHicnmcPEIAibtcwYTK/bdZsm7m92toi05kd9K
	B7vNK5lD3wQTBm6tlRnMmMtnxO/qngwi85QN/uvHhfNu2HU/YVdB236sFQmxWIq6ne6Sha2COrw
	kKDp72H33w7DvAHioWanpdkJFceefQiLfE8TqujTbD4Ofigvr7i/i8W+jWCpil4Y13gIgGmtAMq
	INmNMEEIAV3K0XCwtp/KKhY53NVwo06E4gEoBr8rCj8/NBKWJiIjK7infIYtTYrMQ2eZZ4uJPKH
	q3of5Go1f3KDMEAgwcxTCjATTceocn2YUlmSKbXIhEprDA=
X-Received: by 2002:a05:6a00:a21a:b0:829:a062:bcac with SMTP id d2e1a72fcca58-82a19937a69mr8545094b3a.5.1773696545587;
        Mon, 16 Mar 2026 14:29:05 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([14.139.242.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0734039asm17051846b3a.41.2026.03.16.14.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 14:29:05 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	yifan.yfzhao@foxmail.com,
	singhutkal015@gmail.com
Subject: [PATCH v1 2/2] erofs-utils: lib: return error on ZSTD decompression length mismatch
Date: Mon, 16 Mar 2026 21:28:47 +0000
Message-ID: <20260316212847.57030-3-singhutkal015@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260316212847.57030-1-singhutkal015@gmail.com>
References: <20260316212847.57030-1-singhutkal015@gmail.com>
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

When ZSTD_decompress() succeeds but produces a different number of
bytes than expected, the code logs an error and jumps to cleanup.
However, it does not set ret to an error code. Since ret still
holds the positive ZSTD output size, the caller treats it as
success via the 'if (ret < 0)' check in z_erofs_read_one_data(),
causing silently corrupted data to be returned.

Set ret to -EIO before jumping to cleanup, consistent with the
ZSTD_isError() error handling path above.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/decompress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/decompress.c b/lib/decompress.c
index fb81039..a27881c 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -75,6 +75,7 @@ static int z_erofs_decompress_zstd(struct z_erofs_decompress_req *rq)
 	if (ret != (int)total) {
 		erofs_err("ZSTD decompress length mismatch %d, expected %d",
 			  ret, total);
+		ret = -EIO;
 		goto out;
 	}
 	if (rq->decodedskip || total != rq->decodedlength)
-- 
2.43.0


