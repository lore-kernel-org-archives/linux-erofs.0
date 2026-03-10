Return-Path: <linux-erofs+bounces-2583-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABBBBFD2D63
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:01:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXl437Rz3cDV;
	Tue, 10 Mar 2026 23:01:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.94
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144087;
	cv=none; b=hfkmQYzVCaEBGelo75/2TBJnHwtFOA+CZOiQJLt5dQnmfXcN92U0V4hX+EpADpGFO0BG6caxXkcorwt9hPRu0z/n+e9IDEhZT19FccW2ptTlL2gOGpIunhi6wH4u+nxcOCm7JWE8PaX3pAHwk4/SfE55veO6Im78/rOPPB5qgGWqGCfu0khJ7p+4aJAtknZ1vQvyHt/VdiGGkvAYlpH7A2lGpK8skAZnL2zRnIPplU5JAjkhyyxvdOMkYicwk94i0EtVFU+c6yZk3XiRcxh0Ic1U9O9Aum9E0VbpjvKwht+XoaDtcc1nybbDpj+015g05vX8VxBd0KNO7iGmBR3cvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144087; c=relaxed/relaxed;
	bh=gy402GJXbgyAJ+YKb8LodXTXPBtJ8ptnh7Eq9VEeyMQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EI69rbTHKbT4JzUgtkFX9L2Nzz56xdf0Xqs3fMzPiKemaiDIEHB+am9Mny3BjWSDALN2jpno8PyQhSm51mHrB8SIrDJbY1cKN7mAvcahy+UvoccmOhLEo7EvkaJuMRDJtkxvZ/OwfEVQYSbFF7NFWCEQmT+5ghRa1Veo3f0o2vm39mGQ59Hq/EVqNR4BFS3ACZCHR+2YPimj4GyYzOoeYxQvv9bX7aJZE1gPbbnY2vyj6OGQJlGNgL0xUHkemGzcY6w1b7mhK9c4i6qG9a1TqE07z586Gzt9YhDCzxx5QyakeWgSTGHBUUt2VFM/OxT4ndqBxW58jspOgSixU+i4mg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=dw1nuFFW; dkim-atps=neutral; spf=pass (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=dw1nuFFW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXh6ChYz3cCh
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=ObADPYZ6pJh7dF4ZtW/umhCREHwhUDWMyq9N6rBcVwQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dw1nuFFWpVVdrKOfBC8Dj4wKZMjU9ddsg9cir5xT91Je3Qc4zdD9Tv9d84zEGU77U
	 bneXu7o4d3sJr/YNLcP9VRF/8FE25ShEW6LPrPIHkFN36JlEXF0VOvnj++ND2duaOC
	 CYWW988mCr9Su8D1d7S5dskAeFMN3TEqL7EVGhxg=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-e21d-7f0000032729-7f000001da1a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:57 +0100
Subject: [PATCH 31/61] net/tipc: Prefer IS_ERR_OR_NULL over manual NULL
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
Message-Id: <20260310-b4-is_err_or_null-v1-31-bd63b656022d@avm.de>
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
Cc: Jon Maloy <jmaloy@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1121; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=ObADPYZ6pJh7dF4ZtW/umhCREHwhUDWMyq9N6rBcVwQ=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAY/UcXAwJovG6A4nB7YjchfS8dWMTKJR/2Zu
 MZwvRUzfSuJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGPwAKCRA0LQZT0ays
 2xl9CAC38JfIZK13/o0jdZIM8Gu3hUV57MgGCpPmPgAkgZQzEtBGs2FDO8Fx54b796heUI6C17z
 ZbGY2wRKWGjXSBCngfD+Y2a/1jCSzGEuQ4jVEtxbgFKGiVGPc8zPo3j7RIqGt+XkDfXhUJV/WGs
 +J2xRVA9B3RKAYgO58tDVBDDKVuZmX4cu+ETIaOpu3+o52epJyZqzezdrVwvwMz+c005iQpPVgY
 LKvEVu+vfw1C/S2Bm6+j0K7soEoH7Q1wM0z8TR821F0SvZ3KgnganCVQOD062Ix1eouKRv0CD2a
 gtvYCJFRo6JoTu9p/1jJVnIebiN1A5uUYXaP+Bibs/sNVbrI
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-2FBCCF2F-19F0E4AB/0/0
X-purgate-type: clean
X-purgate-size: 1123
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Jon Maloy <jmaloy@redhat.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 4c618c2b871db681e69f7aec8f660d6130a13346..0d9cb21ffbf1539b7740e76521e3aac5fde322e3 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2971,7 +2971,7 @@ void tipc_sk_reinit(struct net *net)
 	do {
 		rhashtable_walk_start(&iter);
 
-		while ((tsk = rhashtable_walk_next(&iter)) && !IS_ERR(tsk)) {
+		while (!IS_ERR_OR_NULL((tsk = rhashtable_walk_next(&iter)))) {
 			sock_hold(&tsk->sk);
 			rhashtable_walk_stop(&iter);
 			lock_sock(&tsk->sk);

-- 
2.43.0


