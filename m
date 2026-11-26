Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38691606A31E
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=0mCrPwB5
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCW00q6z2yMP;
	Thu, 26 Nov 2026 23:02:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::336"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694550;
	cv=none; b=Ev2KlY2h6ksGoLW56F7KgdxlFDIkpjhohChaB3fEfhseRYVUko/m/Ruqp7UOs9kSdlrDBjP8iP2D4oa6+vvaleLIWHM3FjxqLb8R5ixp1NFTfqdLXfrQWRT+pI/isKjfpJ2StHnl6xF8H619q/iF7P75IPr7tHF0gxsvjyln6kLQc/tNqTE0lt9l3T4UHaL/ysaFvnd12WXS/Sw2s6AXWXKURFO3bY6z3bfdpSNntAxmMwJavVp9S2TEdohT96E+PpQ6dbd7F+33EGAxgJTq84nVirsdWRP6J8ov4NOr7shCrD37/ZWOKxFHy54f/0u9tUUOCEUgTcHTb4xrCa5q1w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694550; c=relaxed/relaxed;
	bh=jBJowxRInZhomdZqGHvuyQQZbuT1ccn+2ig4X6S/L9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXvH00zjb4NHRKxOh0WjRhOAEm6YWloV7CVfV6spYDwvUGCJlwTuFOvs1bnxsakFSlcoo0pRCve3iird5dG+f/GQ1z/GV9Kdz016V3JZWl0dGo1nhtej/O4SWZ4vsq93Xz8173LfSEQthWq6Bn/QYCxse2HJtTkFty7Eb3p59X7ECSQnm+/PuBpn4UYJFogEeDGAFGDG8qY5AHR0B5dMYoe35QnQf6iqKE73Hq8NIjb5y0CZ6sxoIX4XRMye636aJ7MNz4V37/lSyxtHw46Cr7HZ0aNeGQHfk6MG0gaCqs9JklvuXYhuNo8sJ4VEqFd98FDObpU/szWdTWa60JhAMg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=0mCrPwB5; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=0mCrPwB5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCT4Dt0z2yLY
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:29 +1100 (AEDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so89278125e9.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694546; x=1796299346; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jBJowxRInZhomdZqGHvuyQQZbuT1ccn+2ig4X6S/L9E=;
        b=0mCrPwB5E5zEcaAr4vYrxkaTpCLYa8RDd3yvzlzhR6+1thv15rM7k8xN0yisvjCJFa
         HcprdTFAHg2JbhiErY6MFA6RUZpb4BdcVQVT+SOHdMo83K+KkmwgS0r1vqcxB9ZiXAQj
         L+1WI1AfGNZ/Xiph8wFFICaQwoSmmfKqcyRZ4U3algr7HQPuNvl/z/131RpTUitRsW9I
         0CjcJJ+Jhn6Bgs6hEPSSnnjuzdgJOQOIjkLaVuaMBAytlXXhKZLF+PqSoDg731JdZ/ma
         5p4w2BihyG3X3rTWxQ0jwyk26VDnno6a4GR/aOoOxpWnNbSYXMCHZ5s8lxXUQcrU+bVG
         MXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694546; x=1796299346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jBJowxRInZhomdZqGHvuyQQZbuT1ccn+2ig4X6S/L9E=;
        b=mGi5D+vEOS3X2hZEjmqVaCOWdDsHzmBOGGgyqQRIqANfiwK6DvbL4OtBNRImGsSxq/
         Owj3LmvSaK57X7FyA2ZwUA39MCFiZ8j5fa40QZV5PkHhZrOmwEaxERZYFLiiwVsoozew
         gZWbRZxF5/DmquXNTYUKL4sZIRyVOXG9YvevTOysmJ46S9uiOvUASxHvOdb/o5O9os9V
         ey54b3DFE2w59tvgHpJhmgXckHIMgNQJLKpFxI0i/9T6eGGRpexOVp9Gny1me9r0z36j
         fMXMaqKtF9ao65/YdmG3F8nscgb0HnbPIN2/IYDn73cvUmhiwH14cUe5jTVX3hbutMAd
         WH8Q==
X-Gm-Message-State: APuU4Z+lnHMvrbImMl3gBz/lTKRipvCVu74F+LnkYbJhdMCL6t1yqWH8
	5RIPm1V/VNPk7zuvUpMIXBiwVyvDKXAH/gO/QBZ1L8M0towaUqV9Ki+Jj1MYfKKCMaJw6I8qs1A
	FdF/UWBA=
X-Gm-Gg: AZFdTZfinvQUGBR1nAiu2IMvTfdNQQfGoPi2vMInfnWse830HS3Hor/On8X6JSSxqIF
	AGgCvU8CaMfc/s6zw7Z2C3ECK14xWzaIPPAlp6fRsl0N2vB1mtC2PqojJm6dOZU4l0C/60NsHCv
	aWq0aQU3niTqyFiDuWwJIXZ6VM/+g1clF4VjDQYAMRc+BoG14R2eGPrYcD8vBUuPNktQ1e2zAgx
	+u1Di+A5nDTFJQaI5Q5I4v/jdKz9abs//b3G7mrSINWQcqFSIY9l4LAQUprHVz5OjY8nI2IKy2P
	jaGf+i6bDFuCvv8rLAneLQUchNps51FmYfr8s4N0ODT0dUdJLqNUBBflegH13ahbj0ix75y0Y69
	8PzLLmK5Bo5LAEdj7C4fcDJUPO0ox5JLYeovtyA39xGUEdJlXCoXVwz85cSthD82yTnWLWXnLj7
	LV1GMIuuo6uEImsgemD1MQbv1Nw1Du/5KBshmBeV7x94FtdK7jLPbtTWCcVfrsBsiHQK7ZNfrLa
	ClveINRWj8O7jNnWgU7aWKmdo2EndwNtsK88r+L3KeYTKCosMEl8FJ8YNHoyULgFAhHqJR/vZ4v
	5ICPYDmd/ucetiT4CD/rdvxP/zhIuZOYrtJyM2EotV3gUZG62OYTTbS63DhZHpgrKpb6Jw==
X-Received: by 2002:a05:600c:4504:b0:4b4:a551:681a with SMTP id 5b1f17b1804b1-4bb887fc396mr425493125e9.3.1795694546051;
        Thu, 26 Nov 2026 04:02:26 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:25 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 02/10] erofs-utils: lib: reject overflowing device-table offsets
Date: Thu, 26 Nov 2026 13:02:13 +0100
Message-ID: <20261126120221.4384-2-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261126120221.4384-1-xiang.gao@docker.com>
References: <20261126120221.4384-1-xiang.gao@docker.com>
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The on-disk devt_slotoff field is a 16-bit index of 128-byte slots.
Incremental builds can allocate a device table beyond this limit,
truncating the offset and making the superblock point into unrelated
image data.

Check the slot offset before assigning it to devt_slotoff and return
-EOVERFLOW if it does not fit.  Revoke the buffer allocation and free the
device array on failure.

Fixes: 7550a30c332c ("erofs-utils: enable incremental builds")
Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/super.c b/lib/super.c
index db8f23f..920d572 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -391,6 +391,7 @@ int erofs_superblock_csum_verify(struct erofs_sb_info *sbi)
 int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices)
 {
 	struct erofs_buffer_head *bh;
+	erofs_off_t slotoff;
 
 	if (!devices)
 		return 0;
@@ -407,9 +408,17 @@ int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices)
 		return PTR_ERR(bh);
 	}
 	erofs_mapbh(NULL, bh->block);
+	slotoff = erofs_btell(bh, false) / EROFS_DEVT_SLOT_SIZE;
+	/* the on-disk devt_slotoff is a 16-bit index */
+	if (slotoff > UINT16_MAX) {
+		erofs_bdrop(bh, true);
+		free(sbi->devs);
+		sbi->devs = NULL;
+		return -EOVERFLOW;
+	}
 	bh->op = &erofs_skip_write_bhops;
 	sbi->bh_devt = bh;
-	sbi->devt_slotoff = erofs_btell(bh, false) / EROFS_DEVT_SLOT_SIZE;
+	sbi->devt_slotoff = slotoff;
 	sbi->extra_devices = devices;
 	erofs_sb_set_device_table(sbi);
 	return 0;
-- 
2.54.0 (Apple Git-157)


