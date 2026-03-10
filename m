Return-Path: <linux-erofs+bounces-2602-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B0F7FD2D65
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:05:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXcz4rt5z3cGw;
	Tue, 10 Mar 2026 23:05:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::120"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144307;
	cv=none; b=U29KK1SdgIXNtK/KAs64jdPCoHaJLIhSFw5MxnTKGGCgG+8d2uPDrn5Rq1BxpNM5U2waTp+MhBDJHsuChzGy0gnEryAEE8thOipVaVPLZtA4mwxMLg7unyfQ2H1xeEH5LyWVT+KCGbKa+WqS6NZMf7NaROKP1ZF+a3R6Ug0qFxN5tI4qcnVxNKVe8cEgvvdtImpx1kObxShS5poiv8x8r6UK7it0WxED+HDVR24si6TXttq0j+w8Jm47e5xQXF05r/uk4wFxFIRBvcDKQZCfZcz073G5g8ujLoEuh1YyiKhWCKbyFP6yCBc3QMjtyUHgSFRqWLB2DANJn3WGMobZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144307; c=relaxed/relaxed;
	bh=x3fJnbtkYl6K0I0NQZZfdxYUdlec3ZKNUOa5GtYQQpw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W7uwOtPQhWYI+K/ZVhL9WsLu83KtbHSg9FEr1JR3O0dBOYSYIlqM292St/1iufF6trNOh90SucVQGpCgV4CagSPHT62gGflPviV+3sPLpLNYjXyWi4WxAkWzp/dG41DPUM5Vwc2I9ixPLpkVr8Dm2n01nxtB1TzoaTvqaSpQCwC4kRCOfdm1EvfrXBCRwJO6KfEkwa6dJP4+vIfVXrl2aHt1S4JZakyzRXMqtXd9M1b1Ynqwym4JZf2F7CeiC4jMeQ73eTirx4H9cCm114N+jZFKAGHJt425g2XrXgRYmTWP2YwSllll419AORmUodLQEld8MzW1JkAoZeWOlPYqaQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=TfMCcK8c; dkim-atps=neutral; spf=pass (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=TfMCcK8c;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXcz0mPbz3bmM
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:05:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=I6Je7s2Ep1qm9Op1Es8XHv3XLRiGLKRoF2kXcmkzRQ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TfMCcK8cpiyaOKFFZdA9Md6WNn5KRFS8tSOkSqLD2Jxk5OZPSDDv9UFoUEeAaWCfO
	 ihOoPJUrphZnBRuSVIXmC+zIb35xahiq+vRkcauUTds8dKZ24Y/dr6SYjxVJU0FDdx
	 AKL6kc8+lTp5jQ7C+ooCXPOvtrcw/oxBU6qxFp7Q=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001c010-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:45 +0100
Subject: [PATCH 19/61] kvm: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-19-bd63b656022d@avm.de>
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
Cc: Paolo Bonzini <pbonzini@redhat.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=I6Je7s2Ep1qm9Op1Es8XHv3XLRiGLKRoF2kXcmkzRQ8=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYW4R9Fa4g/yA6j9ZuKFu5I9Vr4Ret7hyOjN
 JwNhe7zVlGJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGFgAKCRA0LQZT0ays
 20QXB/4yM/Evr0C2rYQNWNfwS8E/cG5fl6s9dPrv/gvVYGXSEh8UExGqU9cLwxKHIKVMA5Lse9f
 LrwiXfgnVbG/jY2aDVr8SKAe8jTMddJh/8QeSjkaMwizAfr4QJuiagDa0h2xOKqhGpCOZN//1dy
 f1A425zzalFgQcP/cTon5ZDxtSFbyqutr29XmKKCwwHv2Q8Ku8umjOLZX7dw/4OhOp8cL1xvis1
 1HNcIwV+v3AkQdaY3X17qkaSSKgp3UINnn82IlkzUYd1D589D9+xD3Ra8N0AS0tymC/zbV06vOe
 lGeSrKAmlJiZ7dD4DXHr90X7Cpb/daCyNPsSKKM+Lq3HwsE1
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-DFDD6A3D-9438E50C/0/0
X-purgate-type: clean
X-purgate-size: 940
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 virt/kvm/eventfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 0e8b8a2c5b791243e230a91124d32fcc0250a0c6..4099dd11626009a3497ad09994ba6bc1b8211536 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -508,10 +508,10 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	if (irqfd->resampler)
 		irqfd_resampler_shutdown(irqfd);
 
-	if (resamplefd && !IS_ERR(resamplefd))
+	if (!IS_ERR_OR_NULL(resamplefd))
 		eventfd_ctx_put(resamplefd);
 
-	if (eventfd && !IS_ERR(eventfd))
+	if (!IS_ERR_OR_NULL(eventfd))
 		eventfd_ctx_put(eventfd);
 
 out:

-- 
2.43.0


