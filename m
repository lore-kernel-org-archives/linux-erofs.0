Return-Path: <linux-erofs+bounces-2560-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA74EB1055
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXRx3vwzz3cBP;
	Tue, 10 Mar 2026 22:57:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773143837;
	cv=none; b=UZyVCdhIpRrGZvb08miOxwXsFaOkJiheHsWSHv+FUMeCnfG9PFI0O9jjRXoZiIznf/mIHCCIYuGfYxbFQFoPcgh5YkWL3m/SjVevCqGUteWsjYs2m89zTA3s52nbTplwuGvW3V090ioJri2AM5QE1iuUdkZQVlFx0Tyu1tw4utJLjEo28pcnGiGECEiFHGM4WDXFT7wA9usCT5X8QkXXV+mclK63MHWoLB9XZzF6qS/87ZR6sF9WVfcYeV5PnvdgoWb1iJNtJ10c6BA8MBs4eiGRdnVFHcswPVal2vMzEFhOVYek5C1Xhgug4m5LbkLlCqlEnOUTlF6Tf9ROvBXnTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773143837; c=relaxed/relaxed;
	bh=PYVbgZ2nKxN5YxfS32Q6BrkzgM9oUAmR+BouSLEtSW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OSZn7a/hZs5asZmM8ApDFzTZpkuMDjQWC+gtSyYbTYvoU8UmtsrRxR6/ejTpmMZzUEvs6Z/mH2OKkzgQRE2oAzjOKy5Jq6WZj5kSzO92XL3hm0a1vTw5vU/vkenU+ZI3+Wdu+DVuYlFfGpC0yI6Zh6+dC3lNEGsfVqcMdbikDCINYHvvLnd6OUhnwKvkZuUbQ878PvJGkPGGtX2HMG63ntAOIWFqyzENOvPIKTLEJNCWCnRu6aBMdDV4qaThSKBDABpHGfKpo3bnLeGxvyPhvatnQy3OemhkqHqUJqsSEUHGkqXiLigBjeo6Uj6ECm6yaNeqwb/CziJT1+pPxRauCQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=FuoIkm8y; dkim-atps=neutral; spf=pass (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=FuoIkm8y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXRs0NFfz3bjb
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 22:57:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143729; bh=D3MT7fsInTbF+Q1IcBY1KlhxZOhv8n1GbgMEryPc1iY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FuoIkm8y1r9jmy9XkB/nIcxLjk6bi+LjK6sb5O5ohjTjMY18sKNe5fNP8s8fr+eSE
	 cVA8MM9YDRtdE2+c+3jQLNZHyd4epnj5ZDnSjfPWRMAs2R10VO12Ss6TLbgdzang/C
	 IuQfXi2yHqFGvraOYFSaQFSWS/mBIxmUmEAiJKQg=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b0-2367-7f0000032729-7f000001ca2a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:29 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:28 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:22 +0100
Subject: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
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
Cc: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1921; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=D3MT7fsInTbF+Q1IcBY1KlhxZOhv8n1GbgMEryPc1iY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaUcbSjlqDNveOR0T7quZaIRE99Gs4Y40VBm
 M+JmB4D/wiJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGlAAKCRA0LQZT0ays
 29iMCACZFg0QUOFeRuYtY3bNuohm/w3gB25wtydzkEpw1y51B0CHIEYO2D+JTSeLzAXWxzoBnW9
 HXPmPssLJbvCLWKHMMkr0gAWPlZj2r2H5W9oWdTzVn7prfkWfj3QlC8PF6krEUlEdaF6S2eKHnY
 z1zuimMLbUrpcxQrqC7ES4i2d/Rp5LYwIEnS9CU2G4AgF3dSj7KUVqb2Lo1UirL++DC+eGcQfPA
 Ura0HOmvOdmbreSMPuxW3hgubjzqbYDJe+u22CiDbkdU8O1mLNiEw60lO04uucHvbyqPHMrNt0s
 Po0xv5cdM7Uk0fq2L3KaKWcmaytoRStiJNfwvalXm+okYQVa
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143729-974B6E1F-DBF721A0/0/0
X-purgate-type: clean
X-purgate-size: 1923
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Semantich change: Previously the code only printed the warning on error,
but not when the pointer was NULL. Now the warning is printed in both
cases!

Change found with coccinelle.

To: Michael Turquette <mturquette@baylibre.com>
To: Stephen Boyd <sboyd@kernel.org>
To: Daniel Lezcano <daniel.lezcano@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: linux-clk@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/clk/clk.c               | 4 ++--
 drivers/clocksource/timer-pxa.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 47093cda9df32223c1120c3710261296027c4cd3..35146e3869a7dd93741d10b7223d4488a9216ed1 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4558,7 +4558,7 @@ void clk_unregister(struct clk *clk)
 	unsigned long flags;
 	const struct clk_ops *ops;
 
-	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))
 		return;
 
 	clk_debug_unregister(clk->core);
@@ -4744,7 +4744,7 @@ void __clk_put(struct clk *clk)
 {
 	struct module *owner;
 
-	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))
 		return;
 
 	clk_prepare_lock();
diff --git a/drivers/clocksource/timer-pxa.c b/drivers/clocksource/timer-pxa.c
index 7ad0e5adb2ffac4125c34710fc67f4b45f30331d..f65fb0b7fc318b766227e5e7a4c0fb08ba11c8f9 100644
--- a/drivers/clocksource/timer-pxa.c
+++ b/drivers/clocksource/timer-pxa.c
@@ -218,7 +218,7 @@ void __init pxa_timer_nodt_init(int irq, void __iomem *base)
 
 	timer_base = base;
 	clk = clk_get(NULL, "OSTIMER0");
-	if (clk && !IS_ERR(clk)) {
+	if (!IS_ERR_OR_NULL(clk)) {
 		clk_prepare_enable(clk);
 		pxa_timer_common_init(irq, clk_get_rate(clk));
 	} else {

-- 
2.43.0


