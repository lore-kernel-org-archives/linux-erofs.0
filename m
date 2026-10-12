Return-Path: <linux-erofs+bounces-4702-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FACACA9ED1
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzS6mKnz3bSn;
	Tue, 13 Oct 2026 01:01:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813684;
	cv=none; b=QE86KT1VD1fNNY4hodMqFzA92IF5AJVyonnF2Rw76TaWLSipsw2rfu2FCG4h6T3PSWjtJW6vMbiwJYnvWJTxExzVtjkM22BIlF8KRZ1qv7svw6CY8o/vOVLZMHI80Iz//aGc/EJOakBZ0PxSjlLOtd1qrjMTp7dXk8ZKFyxOBC65joYqKnQrX3PysPuJFvgYN67JXcE5ThmfuI5rBM77J5h5FQPVinaF1SoO/RIqgjff0mdCnH7GyIvfayEHabU3CdjMwamLUZBlmZ3zjqDY4O5r9wSpsFVzJcJaZdSwQ2vw8O9u7dOaqLlvw+t9g2s5f+14RYuPdhIjMw5G6yOHVg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813684; c=relaxed/relaxed;
	bh=6qauS+6863mYBUVE8gAUMAy2ifymlMF9k3JJZcOwu9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShkkcfTDdWIdMOW7hdllGaTvc0ICvFPPaWFilhXrackbmxddbhMArbVHQEKnmoI9mUx4nSYPP11c1Lh/W9u2YT81mLlE15n7o9R2WhlvbM1HtN83b9V14CrZdKRFWLZ8+b2Be9tXQsakdIzWLbS6JcmVzXe8AXjZ5nUeydgxMGqthWWhWiigvNG1n4BdjvbQe11F2f5xMuWa5X7ZiIZY2PTLXzbajyhuiMWgJsm2ACkzxP5P2TDhQxxpJ6HKnvh03X/KnA5I5ySte5W04bnWuxGeml+hUhudCGTx/OICwgCw22k4Mi8Q/Kro3nbGdLr3FPEfjgKpYX9U9bSQoIOwow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=THpKvEWD; dkim-atps=neutral; spf=pass (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=THpKvEWD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3JzS2d1Fz30Vs
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:24 +1100 (AEDT)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AE7A53F29C
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813681;
	bh=6qauS+6863mYBUVE8gAUMAy2ifymlMF9k3JJZcOwu9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=THpKvEWD8pEWDwtr5SgXDkAljUX2VTmG5i43VTyCa11IhpE4mSM1+epDbvq5qdMyP
	 ahWQVFJxQVOo+etRYEtEV2UGlSF61jxAtiHQ9q7ZJipyDW1te+pJr/ZUE452URwPHm
	 r6cvV0bRnz0G3T4pWR0a7rvK534Kj0bVe9Gk/kgTWsWeaUg8LnRigV4yS5QkhWWG7e
	 0WnE3JeUxrMLtV1KX5FfWJfGh49TnH6m+NfzM3uiqzHL+ilaOV8cS1C+bbTnVVt3Ud
	 /R17C0sDoTz7KcjEvWGLdZ+F2kXK2JS3wLu2xqoAe3Hdr3tcZyd7JmqhukP8AkaJiG
	 f2DiWq9MtH8OCO4upoxp8yjB26dlAOd8thNuO/yWO0kR7ydyplo9FA60HBVCilZE8E
	 yAjpXt2RjtquEDcNht2dQnVx6fySbnyTcXiCZc4/rSUzeAwUxOIFPXGBSrSJjJyv4p
	 lR7+BA184Y8jAX30tB9mGu5agP0QZZKCQdiDKvUiJup4Sp58FLgo/qgOY/jGj05CdA
	 Kz511z9RT82X7eB41rJB6DySxNB5FCywo/WHzp3u/v7uvYGk2iULCQhiNmpGI6QpVh
	 XMVrolxTWU+tnbux57HKAtKhnEjXDpoRxvX7mtZCiR1SQZAp0o0UJ30UaZA00WB6jY
	 qu8xMnYuktW6xD8GseVpH1fU=
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48afe67dfc2so2469229f8f.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813681; x=1792418481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6qauS+6863mYBUVE8gAUMAy2ifymlMF9k3JJZcOwu9s=;
        b=t4gMOjQ1Smc5gjq1wjLBUPyzjFgmOsmNaBdy3kBr18LQF1gkk+qUGFvXBMWKCMW757
         x/O2I0vkjA1PYRyVAeqlm3MtSOdpXFVB/bc+axuHI7pTTjG0SzA6YiKFopAEqcvpXj3Y
         JrBIyV8Q9EIVr6a4SG0uXWGB95pw0S4/caG46w0GU7nHRjtc+Ip/p7phozHMZHHr4iJN
         z9phMyoVACnJNdmQTeIPn2PxLEtx47topDAVMh1PXD3rwKjcKsARQKPqVYsq3wziZlu9
         2wZ3zk2GX2aynnjxfgq3bS5kpcHwkEVzCMI5+sYxohf+KNJ7zwFDS/rLn4UO1tHyVIe8
         nq1A==
X-Forwarded-Encrypted: i=1; AKwUvBwxRlP6GDxvrQDHa5oyo8ZYTg/a04Vl1RQlz3cBqioaTMrnqCDcCO70dtPJTZ1A/mzFHRHUZovR4wPOcg==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJKRWFbbxQoGfIS3V444PRQgwcyOaqmZrSYPBoGWufgeTBjrHzc
	RkhFNPWfEaFT0WQxZa2vmIeXpPiOapb5MMD5ZH1buRCkH7D4VguyVTUAURxWr4YFmopMRNiRjO7
	s1KsAW+xTl5OprwdlzsWqg5Cb7iBityGuW/Ct4YUN1goDTeqBB5k6lJUBL/2U+zqgMvavmA5Dua
	s4mknuyUsR5vS/Hw==
X-Gm-Gg: AYBFou0FLoJd5L0uKjMwdtN3uirIvdukMy6PtU9USfarvJ7jR8n6/k1H4kGzCm1e017
	Q4Jx0MnDQZZr+rrTQdBjCpWS11tHIhdzU6DGsannDL+qQY/QZL3S0GWXushX7CWew3zOHTNKN6Q
	9MQJBg3jvDfkM7PntkAV8FacgqfRclRRh59iqFiYAPIyUCBq0+wN0dsDVPm64QNoyCrbvhclOfH
	pMvOY/FtJFQYVDMb+o7pUuLWpj9NHFh+DPApdBj7e9zftYIm+B2PjmTtNySNvylrNzn6lLfrli0
	oe4E/QlqAjq2c1EYmv7hM9Ap7D89jIQgsuv4DT3rIUhDUoFoRrEjQGNZM3bHNPV4Hdgy2sHbf3X
	6oJZg2SDhuCL5PoQujt3uw0XTQ1jgrM8IbNn3kUzxX9lA7BsXAWu5vKk=
X-Received: by 2002:a05:600c:3e0b:b0:49f:fbad:29ae with SMTP id 5b1f17b1804b1-4a18e4b1311mr174042335e9.17.1791813681103;
        Mon, 12 Oct 2026 07:01:21 -0700 (PDT)
X-Received: by 2002:a05:600c:3e0b:b0:49f:fbad:29ae with SMTP id 5b1f17b1804b1-4a18e4b1311mr174041425e9.17.1791813680501;
        Mon, 12 Oct 2026 07:01:20 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:19 -0700 (PDT)
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>,
	Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>,
	joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 6/9] test: Probe RTC early in dm_test_host()
Date: Mon, 12 Oct 2026 16:00:45 +0200
Message-ID: <20261012140048.214059-7-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
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

The ext4 driver probes and reads the RTC which allocates memory.

Ensure that the device is already probed and read once in dm_test_hook()
to avoid false positives.

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 test/dm/host.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/test/dm/host.c b/test/dm/host.c
index f577377da6a..32a9818248a 100644
--- a/test/dm/host.c
+++ b/test/dm/host.c
@@ -8,6 +8,7 @@
 #include <dm.h>
 #include <fs.h>
 #include <os.h>
+#include <rtc.h>
 #include <sandbox_host.h>
 #include <asm/test.h>
 #include <dm/device-internal.h>
@@ -26,6 +27,18 @@ static int dm_test_host(struct unit_test_state *uts)
 	ulong mem_start;
 	loff_t actwrite;
 
+	/*
+	 * Probing and first read from the RTC allocates memory.
+	 * Do it before the measurement.
+	 */
+	if (CONFIG_IS_ENABLED(DM_RTC)) {
+		struct rtc_time tm;
+
+		uclass_first_device(UCLASS_RTC, &dev);
+		if (dev)
+			dm_rtc_get(dev, &tm);
+	}
+
 	ut_asserteq(-ENODEV, uclass_first_device_err(UCLASS_HOST, &dev));
 	ut_asserteq(-ENODEV, uclass_first_device_err(UCLASS_PARTITION, &part));
 
-- 
2.55.0


