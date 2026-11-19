Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEEF606A320
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 00:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=u2rhf8A+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVJt31wL6z2xnQ;
	Thu, 19 Nov 2026 11:16:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::634"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795047387;
	cv=none; b=HvwsJBbm9oLCsILJz1oibnJu/X845DKdGjLCP5/YIx/zwedz24w7YYbFctB9EDTHF0NCAH1DGXmZcp1BgPZ+8dBZHUVCXKTRn1RmryrbTQf0Zcy6xzWZh2yQx9fUPI+CeAUoORTXmusD9GXLQE3o/JL9Sm+mcUbTt9YSeplO16HhfdEvtK8S58CqhEEcB0zwzJkLCCn9E3ZY4DiQedHRZL5O5BfElte6qxOtP0n4pbD03ayfwB16c2GH/8xgvfx81ounJrwrPukGyotBUBVWY96GYT7Ob48VrkLepDA+aGF0Xk+/y/UlhI3pQALJaxeYBasZuXjGfgpeD0eIgi+pLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795047387; c=relaxed/relaxed;
	bh=SRjW5r7AuzFOz4woN4Fv5DPsQr45k6R38Fy+cnjaDWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hdIAz6sAyTxM9puG8CCSl2sjk/UHl5ygUDj3pdfd1xHm4uEDCCWeHjIq9eqi4d0i0dhRLCX/9FBN1yZL3CGhM1/qkMsxThbyKkpCMopL0vOEu7aB6XPkjnDpsAtdXsZtq+qv/ban7Edjgv1FXMmiSLBAdXBYKGQ5DOxiPEoaC8TBDGjYllwh2O5A3elsDS3vwe2US123LUj1LXjoAcb17p7V8kswDegBeq0PDyh/H/HnHo2YsUF/P3L78sV9TBLBFLz50g3AIq5keBap5kpFGObcOhyWVsRoTriHzO/cNuhRAGLwvmvGzYPnWJGcMMD7O7pXhPlEbDS/7rGRGWFsVQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=u2rhf8A+; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::634; helo=mail-ej1-x634.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=u2rhf8A+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::634; helo=mail-ej1-x634.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVJt124ttz2xmk
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 11:16:24 +1100 (AEDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-c5126505cb3so63220466b.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 16:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795047381; x=1795652181; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SRjW5r7AuzFOz4woN4Fv5DPsQr45k6R38Fy+cnjaDWo=;
        b=u2rhf8A+9BAV11eZNG/NEl83UoQrg/8yo+8oCKctiTfRxXbqZ3k4ZV91gzF0CqEPHd
         Gaoat7WY/s9spFAJG3VnuoBHUBCEKVmT72uyjvKuc3Ki9M7aCJCxwCzcRwtmmbMcanWV
         cIdrhNDxWs3vSKZiBLbiA0b4ShNxp6u+IR4qCcXD9z8SfGlvSz/xYKhND1/0inZXSFOc
         JaPt3szdhrM/fsmZQYsRLSGSyMQnNQ3s+2u9BBV1ZNGEVyfpBZy4+wT8FD0oYjPIUGn1
         XVEd9R19NKahWvnAkXCXS6HgSceo5JuTnDZ5uLtGS9YpNAHlyeKtL+JdETabEZoHFs5J
         YCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795047381; x=1795652181;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SRjW5r7AuzFOz4woN4Fv5DPsQr45k6R38Fy+cnjaDWo=;
        b=KEZuZgAyiqi+mVSQNYjtWyT9cUYAmrmzd/zhA0GjBYA3bs05L9pCGK/5C6aXJmAKmN
         ffsgXos9At4JMUHHnpJpPgtEcogxaznhQN9pRPLfxuGVZEUdzyl/eeErdqR1uoqzLhK9
         taUpp3agPxfGpTnnBtniiH2hc/0DuZgFPyKsH4byOFnVPb9TPLfGdFmliD6uQQeicagd
         eAiakqa4rM0JiRQH5KRI4WCMbEsyGHk+vhK2QJVpA1AlwBbwQ+Riv65kmIfsU1BXupiC
         6CgpxtTNb5X2pJnNCfdBD0EeYWTTEXCl4ldHFmQ63czGqXE625dlHrODdg2eZYTszsmf
         MT/w==
X-Gm-Message-State: APuU4Z+3V+7otLKmIRpS1ybgQIXyGCFNO1wuanOHUzXcU9SCh/ux7TTg
	Bazt8uubhCcS86gCtIzwJpUEN86N/rm9uhAPFOYYmVLnhw3zH/bDJrITh83qndHcRo5sbM8L3bB
	9e1UWY0o=
X-Gm-Gg: AYBFou3tu00xe9Hz30+jS/igyu8HFDFLn4G8ozRs6qYNKfYbnVAPYQrCixKurCBMwFA
	lmD722KfZ8X41pdMeseyPXuJfIiwJHcLsvLYNeUVayRl1LiXvx2SLu1h/KqbAsaiO/kMlNo1TDf
	c8VZrW/dWqIl8r3zs58H22ozx0924QXZpYtqSDp+er2KcmD3R71OHstBtSdnRph2DvKM0ym/VTx
	pX+dULiALRAvlzth2EWKcNXNIDf6T7aoaGDXlU7t8oty5ZDmAMg94/SvNcoJtaP526jetI1u+8y
	/MoqNKjzUjKNPaDDUy4ZgJFFWGS1+4rvdDobnkNXDwVqzg7rUFC8DdQXKYp830K3S0wCanQ3Ane
	0xiT7MHegrPDE8zgEQFmdb51wSl6Ef+LyNQsLs6+MJdVRoBzzC6EZBA3N1fEItUjTHrtlfUwzbm
	KpnKXPbFFEOMmBu8CAZ3xoP3DMvnSIWH19PM+QTqiCX6mHMcJ4Fci62QhOyCV48GK8AapSazvLI
	0T+ZPFbg2G8C8OZvgkFA/PB6doGUhmEF7yS7Kk7xzpfTYK+ttG2O2TdajjFZj8mzWFFRqCjZSbf
	Mww0CwRnp5u+Stg1S/jUf0x3gG1QdN+Ocn/IZFCiqRZdsDCKIOEOM7KLKFLo7ohtaU6KLj0=
X-Received: by 2002:a17:907:9607:b0:c49:a235:8e0c with SMTP id a640c23a62f3a-c510e1f18bfmr414810766b.22.1795047381454;
        Wed, 18 Nov 2026 16:16:21 -0800 (PST)
Received: from F7R9GP321C.tail0bfbd.ts.net ([2a02:8108:8388:6600:f542:cdf:8725:3e84])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c51233c3fccsm54789766b.13.2026.11.18.16.16.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 16:16:21 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH] erofs-utils: mkfs: fix raw tail padding after compression fallback
Date: Thu, 19 Nov 2026 01:16:18 +0100
Message-ID: <20261119001618.38764-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
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
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With -Eztailpacking, compression can prepare a compressed inline tail
before falling back to uncompressed storage due to insufficient space
savings.  However, idata_type is not reset when the raw tail is read.

If the raw tail cannot be inlined, erofs_write_tail_end() treats it as
compressed data and adds head padding, corrupting the file contents.

Set idata_type to EROFS_IDATA_TYPE_RAW when writing unencoded data.

Assisted-by: ChatGPT:gpt-6.1-sol
Fixes: ddea76ad592f ("erofs-utils: mkfs: support tail-packing inline compressed data")
Closes: https://github.com/erofs/erofs-utils/issues/61
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/inode.c b/lib/inode.c
index f687857..7a26a18 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -651,6 +651,7 @@ static int erofs_write_unencoded_data(struct erofs_inode *inode,
 			return -EIO;
 	}
 
+	inode->idata_type = EROFS_IDATA_TYPE_RAW;
 	inode->idata_size = inode->i_size % erofs_blksiz(sbi);
 	remaining = inode->i_size - inode->idata_size;
 
-- 
2.54.0 (Apple Git-157)


