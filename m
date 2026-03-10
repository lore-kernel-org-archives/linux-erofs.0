Return-Path: <linux-erofs+bounces-2607-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BAF4FD2D64
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:05:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXd15xx9z3cH3;
	Tue, 10 Mar 2026 23:05:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::120"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144309;
	cv=none; b=eMlRu9goGUaXhUIsNE/qjxzWDRN1EZP0eEu0DyJg4lNx1R13y/vheX6AxCL7pUK+XqRNqchHQU6Z4qRzVV5P5fx+E/1KMhkIHlB7cP7S59ZB6qpWd9O9PfeeKzsy6xAj9EVTnr6+PjPORWbFTnd++gjx9IMl4WMdnYd4ScPfpjaNUp6TMgMwoLQOo55MNDjh9ZmtDGETaVRnGlUH3TkAcYsx2iBBPnHlKB+mqvLI8HaNLyZmXVb0NFfnD8SOHstnqDzdlRz6zCNN9+xYaQ5AHNxrlPmdc930TIGDl6yKb5vDdKoCXP4xzMHVbxrpGyiUNdSZMAJ/teG5JylSXyjvyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144309; c=relaxed/relaxed;
	bh=yrziLFSnm0I9lFRRCdtdTeG5oxuLL9+866/OTbm9RKM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Eu27mCAlL9oaNqHUz/WZ+aQgmKOH6IdgT4eAA6XJpGQnJZNQ28mEUdT4ct6N2i3PCeKj5vQGSSFqDZcVgQNa9K3FbpTwUJiorkva1WTvfjXZ6pA3Vr70zbCWJJsp1m/LbR0M6VmmREjwEuCx7xjv/OZ6dDGOIb/FQP4IwMlhjUNRH5SM7Qy+448IY3OP8DHj6e5TP18wK78g6tYIeHWU77yb9qoLhX2T80IyRSNk4NY2jHAUxksEDGC8Ee1z6lCkyUOyUm0vThg04DwY71y3XhToD8518T4fftdAkN3BCUFZTgZF6Hhn2hrXZE/0jLHU3bbKf/qYn8v2cqZ/vcmArw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=E8nt1Igf; dkim-atps=neutral; spf=pass (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=E8nt1Igf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXd119rmz3cH7
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:05:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143723; bh=5P0DiWaZEPF/d3SPdMB+rZQJk1DY1mVuY8d9xffySsA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=E8nt1Igfikzg1UTgOGISAzAMiKswf2ND49bi7Kfi9UIZL/Ebzc+UJJz79rFMcVayH
	 w+/EzW9fK7u4Bg5GlsqH3X/nHnzFmDjyW7AnMKYXmhb+RvNdMihtj8ZP/p/a51PpAe
	 gPrdgwP6uGn176nZZmhXnabbuO0mAOF/przWQZhQ=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001bfd2-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:39 +0100
Subject: [PATCH 13/61] squashfs: Prefer IS_ERR_OR_NULL over manual NULL
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
Message-Id: <20260310-b4-is_err_or_null-v1-13-bd63b656022d@avm.de>
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
Cc: Phillip Lougher <phillip@squashfs.org.uk>
X-Developer-Signature: v=1; a=openpgp-sha256; l=775; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=5P0DiWaZEPF/d3SPdMB+rZQJk1DY1mVuY8d9xffySsA=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYCOfXcw6nKYZXjZ+DBieT/hiu2NsAfQUre0
 jlVRw6aXW2JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGAgAKCRA0LQZT0ays
 213oB/sHjZoOpAMz20yPf5W58oaVS3VDOW1zZjyOZfXyKihmnOb8lV99cBPQClALjvBUcqLXemg
 tpELfmCMWmmS2DLDh38s8m7H4SkSFm3iB+qUl+u8a8NGrDjTz2g0nlLXJ2i4mzmAqWbDldfEhAp
 ePslhLAf6MqAOAwxF9goTetOQ472ZWbOa7vI5fCqcvwcF/q5QIEUmGs+z5b0yUklyrSflqQlQo4
 adffOC5kl3ETGEGqBgVXEIg3h8JiDkJe6MaBbDmB/JG3IQRjeJ8YfJc6t+cVg+eXVpCRQOreMFS
 jG7NgF/eCJBIlcELmHlOCy2pst+P0hiPrthj4RBlPC3hRS93
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-265C1A3D-EB4B679C/0/0
X-purgate-type: clean
X-purgate-size: 777
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/squashfs/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 67abd4dff222235e75d8c2b10d5e9b811d6e38d8..8888cc02966e2e33210c872c733205d4c581ecc9 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -198,7 +198,7 @@ void squashfs_cache_delete(struct squashfs_cache *cache)
 {
 	int i, j;
 
-	if (IS_ERR(cache) || cache == NULL)
+	if (IS_ERR_OR_NULL(cache))
 		return;
 
 	for (i = 0; i < cache->entries; i++) {

-- 
2.43.0


