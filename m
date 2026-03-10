Return-Path: <linux-erofs+bounces-2569-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59847FD2D62
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:01:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXf61Xmz3cCr;
	Tue, 10 Mar 2026 23:01:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.94
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144082;
	cv=none; b=JpMLxPRgoGs4A8cVqYoDmEiLFJHbSWBs21DugeXWYE1j2bktWrqRLBD0QsCeWBkbPap6IESPMlKR6+QdcQWAc+nNJ3kBgz2dnjuBKIG3Ce9GIu1q1/m1GWmuvwuUTq3c5ThL8l7SltiLnQXRXNqhRgGw3sxecsKQySAzbBUwVIpPrA/6IdOT4ZvvsUJ0WVlpOVbZLSfhn6JvLxMt0euxZebyeAq7Y10GIofRtoUd69ivDtDqt7A/Yyhflpof3us7wsigBoeeL6p9SoDzo8X/ven4cGkt203vrKU4YADUAA7H433Khbo+0AZ0xnC44RlDMGRzXyKn6GkdKn09hZeRnA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144082; c=relaxed/relaxed;
	bh=7lvZfuNFeBGCQTG9VmwycsVe3kjmL+ED4p3via/ahr4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U7KFfBtMisZczwEJlsGCHv0GMecSgUKTpgh/ombcSV1RmwgpyMyp6s4PuhDqviUbspt6vqOG34ODzyVx6nSoaDfJx+lCBkmJI2hfCt+KWq/jTMrxMiGl0quUw7yTPpqmGHMj4v/gsaWoAuzk92BP+scqmH3/8jdhs/WnJ7m6i9FucKPoklNxq3iB/WXtBw1VA/HYdpJIr/t0Vy0gZ0L0ZVm+9VEdFAMuoqJTsA7nU7zscNEIBRn4jIGIJxNmu/YZM4O1nLd+BY83lHh1GphncOE5S+wcEdKFQiDgNGzIAOk5TuGyMO9LVFqVzKyFp2he6JAbi5Gy3xXpkPePw0oruw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=BoFkjZya; dkim-atps=neutral; spf=pass (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=BoFkjZya;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXb1yLXz2xlx
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=a1YtuPUr/A4Jokjiqoyr22dEN0gVE+OOIk5/iCzuB9k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BoFkjZyaKFG4I+0my0U16P/ZlsfjMrTgDD1a+wOsKM3wW6Hyckunq05e6+k99D3Gi
	 4kV+7om5pC/Efx3ZEKmiJFTqpv4USFiYyuVuVp1V1iQJ18dYlrQIte47hFcyWAgg5r
	 KM84isD0nokr7A5umpY1I9BsMYrFHMDwFBwVekfs=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-e21d-7f0000032729-7f000001baa4-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:13 +0100
Subject: [PATCH 47/61] nfc: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-47-bd63b656022d@avm.de>
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
Cc: Mark Greer <mgreer@animalcreek.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1019; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=a1YtuPUr/A4Jokjiqoyr22dEN0gVE+OOIk5/iCzuB9k=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZ1Y/UGouoeQcc9WQ8MxrI8d8MHBXHMF2nKS
 xW2sTsLmvSJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGdQAKCRA0LQZT0ays
 20jSB/99EGQGPGXfwgc9aoZkEd87WlbZAw/E49hsk8skwCBZpOQIbZBOjpLkfsW3KBFKwpYL6hr
 zj+vjAPS0Kbx/wu/htgTOseyb8dlXJs2DJCBqPrRUWk2pbJhfh9SL0jieoNOSPl5SCoElM11Tk7
 rVQVkuo82qw4WSlg3liLUmo4Aasw+ALrReSJUM+VyOL2Xm/NrCTSIkyRe46UeXgqxXym8K01Jiw
 UcwLAnfIONTcOH9YPD1gA7uZh9C/pYgWe8DkJu23THTdXZuc/7KopxZDLw5gOH2D1JgCmfeTZcx
 ZHAC2ZLeQRVUrAJ1qKHgI4k8WSRe11aWcTzhA96+gLBGdLHb
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-8161EF2F-9C4586C8/0/0
X-purgate-type: clean
X-purgate-size: 1021
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/nfc/trf7970a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index d17c701c7888b3be0b46cf95c4b77182313c97c0..f62fc2b80b05bd7a82269334d7f50e6394bfe80f 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -651,7 +651,7 @@ static void trf7970a_send_upstream(struct trf7970a *trf)
 	dev_kfree_skb_any(trf->tx_skb);
 	trf->tx_skb = NULL;
 
-	if (trf->rx_skb && !IS_ERR(trf->rx_skb) && !trf->aborting)
+	if (!IS_ERR_OR_NULL(trf->rx_skb) && !trf->aborting)
 		print_hex_dump_debug("trf7970a rx data: ", DUMP_PREFIX_NONE,
 				     16, 1, trf->rx_skb->data, trf->rx_skb->len,
 				     false);

-- 
2.43.0


