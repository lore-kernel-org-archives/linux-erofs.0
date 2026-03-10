Return-Path: <linux-erofs+bounces-2611-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA01FD2D62
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:05:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXd36lcsz3cHN;
	Tue, 10 Mar 2026 23:05:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::120"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144311;
	cv=none; b=kC5aSyBLc8oUCxQyOVmdkSe3VinxG/ZGIY3YMkHYo1JPnWillJOTbtXBYLaSePzugWfC3YaCUioJXjdsGPfxfluvwe8M5TQJWO5YzgEINv79pEz4ESEe+XubjtEjBOcykfdnxrOxz9WI2px+/BmwPxqe7WSv54hZ9mmde5RHGDakgVPxdtRpRKt4cAg8MNTO+LCYHHBY+OD9LN8AVU3AXHGzFBj6GEHRBeCGzs1g4HzC2/XeAlxAIngD0hM2TOYvgIJhW5ySnOze39d1/Y3TgV0q1LxFa2dkiV1GqoBLr9hFApakCCtN5rmcQ/P8qvNzT3VSvrD/9EJr2UJIc/VTPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144311; c=relaxed/relaxed;
	bh=vRq2g61wWE1srncME+gnVjuT8yOFss+lGNNn6b4Uit4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X2HCPvBEsEyRYbmYOXPY3taP6OCELpH+GkJNk25UmU8Els1S/6sfnaQju0gxD2lu2Q0KpSTY0IXmhsASoS378mRMAR/KeZcFWGKB2ZvoNuTJrzIKjVI4EGyBihCtrtyAnkooofbWI2pq6Pl8b4ggIZlOD2woPb9v3Xw+2F5Le+nvbt/1M1YYiS1gHDFM6cAMSeKRMhluxTw+tNsx61/4tRTguIqcwhV9WCimPcyMDwMGWI+QVf++Na9b4XES0XinRAcNNVbftypCca0pARH+kXuQb5h3xc72G/464k1Vjue+4huBU5k4ybCio6QliBz4FW3PZLGtD0nOSC8CBJ1NZQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=YXGm2fdd; dkim-atps=neutral; spf=pass (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=YXGm2fdd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXd32XQkz3cHS
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:05:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=r2ZNUyu6wG+N08MfsdquggU1Q5xHuPu+4B/VYVv0t9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YXGm2fddB0bD05XRQUo0zroBzSiXv55w6mXtnC3/rbyTRBzDlz9PWwan2loANEchz
	 3nUHhdwioF2zPrdtj5GGDiz2/RlpAekCz2aZgV1toF9qbrEYEb5oV3jU7h9yUVsShF
	 X4koU5bE7tqGGpl7IdLmkPqUNFFBIWSBlmjRRwMc=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-b734-7f0000032729-7f0000019c66-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:20 +0100
Subject: [PATCH 54/61] aoe: Prefer IS_ERR_OR_NULL over manual NULL check
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-54-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Justin Sanders <justin@coraid.com>, Jens Axboe <axboe@kernel.dk>
X-Developer-Signature: v=1; a=openpgp-sha256; l=955; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=r2ZNUyu6wG+N08MfsdquggU1Q5xHuPu+4B/VYVv0t9Q=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaNWcUAch/xMnI0wAbOgPf41K9NsP36Msk7P
 Nki6xRL5YKJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGjQAKCRA0LQZT0ays
 2xbWCACfzS98X1Mp5R5EwpIK0pTgqrssQIB840NNUj3GRa/d9D29Lch2JFjR2Yy+ldzvSmEDJYr
 +FATwB8i4z+nArVkmYPgbG8vodjj8pep1H5lik7YhU3G9ClazVWr99T039Q+W8sEprULXLQ0dbA
 4Kpe3/L1QfxY1N+GchfqAHMv0rRJq1RvirATmISGmxTg7n0SEymJW83Bn4X8R0ZnvK6kohy5NEW
 2Ii5RKfTmBA8YgN2bfh5HrwrKAUrDiQU4qD40KTADcaRVC7Oxd160l9rFHE0+fB+GiDoct83TcC
 /85+2RTmaR+Iva1VQ69ftJxFcgDmZC/vMk3mknKyTuNPcNM+
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-DADD8A3D-0ED39ACF/0/0
X-purgate-type: clean
X-purgate-size: 957
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Justin Sanders <justin@coraid.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/block/aoe/aoecmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index a4744a30a8af4ff05113f3234021eec728265b4f..b31e539a66433a0a5d6e81117a32d12735ffc1bc 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1268,7 +1268,7 @@ aoe_ktstart(struct ktstate *k)
 
 	init_completion(&k->rendez);
 	task = kthread_run(kthread, k, "%s", k->name);
-	if (task == NULL || IS_ERR(task))
+	if (IS_ERR_OR_NULL(task))
 		return -ENOMEM;
 	k->task = task;
 	wait_for_completion(&k->rendez); /* allow kthread to start */

-- 
2.43.0


