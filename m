Return-Path: <linux-erofs+bounces-2601-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F072AFD2D64
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:05:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXcy5skYz3cGv;
	Tue, 10 Mar 2026 23:05:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::120"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144306;
	cv=none; b=Af3pcOnybXDte3kT1J3Cp5EET52k5aEq4YROE9/cB/DaQjgCXEmd0DVqNFHeoaJe4Sesk2O4ok6K6lfTgiv2g0w3ADg/7ynoAizsMkoc14tgLdSKbfy7qvjWbO5t3exRW5ZYSbPNbuTHVzet+XQVEjWqQxMOwd38gLhStr8BE4TDsq2WmQWXRvxNREZ8595RlEyNXUJb7s6nAenRdRreNK1Wq4dm+ioH74ONnXPL5pfYW4+eMB5OJaj7eJNnzUrh+ShMBFVvjLJOtRyMb59JMIHOPLnAidZaYv9Fg+r9VhxIS7HEOeUo/zCPTeGvOUiQcQ5JGfiRGckiF/cOAcUwVA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144306; c=relaxed/relaxed;
	bh=C3ysDg7oU3Ik8LJ7AkFJ4IpI0srzE03Ecj3qWGQ34tM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=efac3NcDq5GbZd9zrig4NI92VYgOlayYPSCZhLvBYdET0btALW8QTRZOtfVC1moxkDRzHkGuCTMEM8gHyvlzxdrtOaR0Rb5gW50YmpAn6KwVMcK8TZmNghhjeMTb7VIFN6MfrI9bY7OLMlopqgjpgD0few+K3UEblqeh+r6pibz+LEDq1QPGAZeNAjfhqEwP8kBAqzVcPvWawTbj5piGRAzb+S6hkqiDzdcca5yrPw8XWS88kItqwZUZc/vM+9QNRNWGzXL5FUGSdL79Nvu8g4k+5pZvFJgVjG6VZKmLXar25cRbSjj3jwezBsOIFw+BKJDFBEEil4F+kvb1qrBZ7A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=g+N0/sgS; dkim-atps=neutral; spf=pass (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=g+N0/sgS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXcx69tSz3cBG
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:05:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=iG/6Gbypjz2OmWQb0dXEIiFm2wHO3xZ/QJrRffJjoq0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g+N0/sgSQ8SRQky5YcCPVvBqWjz0hDf6/mz5MXtIt5pp3nndKwnydeDBFFaGciw76
	 fK8hCsX2XQfm37mz50EiEfGo9ClFJDaFX6LRzTWB5+xeibMvG/0El8aLjh4dU3qpIV
	 pdtzYGFmANh8kH/hW7lr12MBHwTlKf1PiSqCWud4=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-b734-7f0000032729-7f000001c052-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:53 +0100
Subject: [PATCH 27/61] net/netlink: Prefer IS_ERR_OR_NULL over manual NULL
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
Message-Id: <20260310-b4-is_err_or_null-v1-27-bd63b656022d@avm.de>
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
Cc: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1045; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=iG/6Gbypjz2OmWQb0dXEIiFm2wHO3xZ/QJrRffJjoq0=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYxKX27oPhhgjZ9L2aN+uf2Pkd/lJuV0FZGx
 7sT5NeXxfGJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGMQAKCRA0LQZT0ays
 2910CACA5AX3Aqq6mMRjUqWLJkwISGQ/SClIom7gyl5y4YdXmFh365btAW6CDMrujm4g2yYHKMn
 icMIaMalhr2gJPGai/SU/Cr5CZi3ZY+4gua5T+uq+HkP8vLsixdy6MzBKvC4YJ7SQ9u1y3suTJ2
 dXw3LfFbSDyXJK4eAmt3Q9xLN+IDoqMq7+VyONJtkwZmjMDy5iHAJpd4FamMBrqSwy4GaDMKKm7
 glgw85FRb142AMKifN1ghWcWZj4AIrKdQR8M3/bZ64Q5ElxSWaeaZ0coUuPBsdwn1welLaCtuOr
 MNnjMGoWnx945CHnVYBBpgGh+sR8NWsokX9o62B2ZLaEYpxG
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-DEDD0A3D-09A71CC5/0/0
X-purgate-type: clean
X-purgate-size: 1047
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4d609d5cf40653e04de60f2d28ee26b8bdcdc2ed..58707b9da84adf1002ab9eff9401fa2083374189 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2667,7 +2667,7 @@ static void *netlink_seq_start(struct seq_file *seq, loff_t *posp)
 
 	netlink_walk_start(iter);
 
-	for (pos = *posp; pos && obj && !IS_ERR(obj); pos--)
+	for (pos = *posp; pos && !IS_ERR_OR_NULL(obj); pos--)
 		obj = __netlink_seq_next(seq);
 
 	return obj;

-- 
2.43.0


