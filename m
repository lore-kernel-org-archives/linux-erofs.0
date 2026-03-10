Return-Path: <linux-erofs+bounces-2579-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259F7FD2D64
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:01:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXk3F0gz3cF6;
	Tue, 10 Mar 2026 23:01:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.94
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144086;
	cv=none; b=JJGMxd10c/4v1SQNucoIcszoio6pwyC4m86sA9Pv0959d7CBXKTlD0BjosY8R38kKlkYi2sdU4SS4rR9O31OGUGosfB2PxiJ94Mg/mTKTzfx6TsI+6ZX9YTfS3YGiNNaQGawaBMqeoALJV6uzuW3Y2DIYOq5ymapfI3lQI4aX+jaDWaeUKqCLT2jlCQTRoPHeP4nkqdvjR7uWg47otoEU7uyXvohlwHV1peRkqb+fpjHB5sDOGTs/VaLVwbNGz7BSzP+X/joYMNhcl1DDL1lfqXFaPZODCVfnbYToMvhfi1n9Dz0aD3eDaTymaS2dtIB8q/Y3AZprHUBmANUEjK5Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144086; c=relaxed/relaxed;
	bh=1RQt94wsCFG7IJEQyvVRUl8nd2Z953/wokMRXtIM6bI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IIAIXrkGSIwQkGneNCdMId4RhUpR/JW1Zq5b0alQMMJ+GHXUoq5FRXUjZaQoK+SLzw/8WPYKcHyMtPyljZiqGg7wD37dv7Max1j1e9evaKh2cjRBADAkJ2dL/Uht3EYDpDn2yvQFpNUxh3yI9UX7tctZdi5dQukw5N56ivTsfMXosux36bYh1VGRm/GqLUzT/cMMdArLB35+eX4ufky33eKr+UAb6jhJOjcGETGE3p8ypRW9rKMhcw39nr0SDiQm+CnHiEcL6/w9f+CSmR3Khk81LFWJ9UpT+0EY8/BeYPmuQsmzY0CZo0WQwxfJmwYIkFLK6VXc+1KD9t0J3FbYnw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; spf=pass (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXh1QDmz3cDT
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:23 +1100 (AEDT)
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-e21d-7f0000032729-7f000001d9e2-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:47 +0100
Subject: [PATCH 21/61] lib/test: Prefer IS_ERR_OR_NULL over manual NULL
 check
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
Message-Id: <20260310-b4-is_err_or_null-v1-21-bd63b656022d@avm.de>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2236; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=dZgGx+TJ86HynJEVGMrEA5pIsLW37DebkwtATXmSHOI=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYdDyn9P9EqiNuLjohkPV9X7iASajPgIoE/Y
 Nuv6AjHInyJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGHQAKCRA0LQZT0ays
 2wT8B/9ExWKAo/Sn9Hy5RU9mMJnGJZfEhSDSh3BrEyzAo8askVVJ9+5gjVv5zubvVRZSl0xsWYD
 ONcBymLUypUnGPDyKoUOhx2btlwnIrxM+A/znjwtFfejlhgahBH8clBf9ppwmWxz+aomfSi8dH0
 gI3DmyyOVIa4OSRnV4I+RdKzJvI1/m5sEwA+61ywfL4pM19NmtFK9XOne0dvmugbwth+SSxAJRb
 vUziX2Dy0AcV+RxD3aCuKKv6tZLzJkBbkKbaQ16k0qyAZb3zbS92hAPdw+yFsGOJMaFjGgEs6OE
 FCCv3wHl+aKzbAwbrH/eK6sw740pLs96xx8NapXtmcrko8Wn
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-98670F2F-CE18AF23/0/0
X-purgate-type: clean
X-purgate-size: 2238
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Andrew Morton <akpm@linux-foundation.org>
To: Luis Chamberlain <mcgrof@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
To: Daniel Gomez <da.gomez@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-modules@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 lib/test_firmware.c | 2 +-
 lib/test_kmod.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index b471d720879a70c0db82e605960abe69de28ab4b..fc3177927a02e2d7849915309048529395ece0f8 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -955,7 +955,7 @@ static ssize_t trigger_batched_requests_store(struct device *dev,
 		init_completion(&req->completion);
 		req->task = kthread_run(test_fw_run_batch_request, req,
 					     "%s-%u", KBUILD_MODNAME, req->idx);
-		if (!req->task || IS_ERR(req->task)) {
+		if (IS_ERR_OR_NULL(req->task)) {
 			pr_err("Setting up thread %u failed\n", req->idx);
 			req->task = NULL;
 			rc = -ENOMEM;
diff --git a/lib/test_kmod.c b/lib/test_kmod.c
index f0dd092860ea6f9c69a71e10cb1c8b071b1cd1b7..f44a181f6f1ab53cf95a0a0b598b88cb5f8f369d 100644
--- a/lib/test_kmod.c
+++ b/lib/test_kmod.c
@@ -327,7 +327,7 @@ static int try_one_request(struct kmod_test_device *test_dev, unsigned int idx)
 	info->task_sync = kthread_run(run_request, info, "%s-%u",
 				      KBUILD_MODNAME, idx);
 
-	if (!info->task_sync || IS_ERR(info->task_sync)) {
+	if (IS_ERR_OR_NULL(info->task_sync)) {
 		test_dev->test_is_oom = true;
 		dev_err(test_dev->dev, "Setting up thread %u failed\n", idx);
 		info->task_sync = NULL;
@@ -358,7 +358,7 @@ static void test_dev_kmod_stop_tests(struct kmod_test_device *test_dev)
 
 	for (i=0; i < config->num_threads; i++) {
 		info = &test_dev->info[i];
-		if (info->task_sync && !IS_ERR(info->task_sync)) {
+		if (!IS_ERR_OR_NULL(info->task_sync)) {
 			dev_info(test_dev->dev,
 				 "Stopping still-running thread %i\n", i);
 			kthread_stop(info->task_sync);

-- 
2.43.0


