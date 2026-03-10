Return-Path: <linux-erofs+bounces-2591-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4DDFD2D63
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:02:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXn3hQlz3cFw;
	Tue, 10 Mar 2026 23:01:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144089;
	cv=none; b=OwfqzwxgtDiDn0YIABlBEZ20XeaYunCx+K03U5g6GtWuEe8NEyNIHl/bP1o8TLevpnfhAU6ZmMiZuGS2nnej/s5XIUzuesD3ofCfxF5VYeRCdJHq/nrWbyJ2AMLEsZXmfjUHHu89BHNBTfzL9YGKeGxtv5gxX7mUy7GpvSoTrlvfdB+jPDnbX7GxVKoBzeDOn7j9Ms7hcUPrAz9zBK+/SbdM2gq9igFRSUU+PvKzo8hPb6XV8gNm/m1S9zX6Hel9CWn1yQ3WjSFkd5vzDw1bTPN4FP+MQg79l7JYMeW30CiJADCLCZ2oYz+h2j1olHR1QbUhvcyx/gvNBKsefyO01w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144089; c=relaxed/relaxed;
	bh=g19AfTKf4q9FJ0WXDwCXipJJzRo8bRjXvJcmm21JHGs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GdWv1ir+gqWZNHKMUgyxZYskWYXhbgno7FV+XLYd1xX6+osESKt5tzGYP/x6QMxh9wez6mboczlSyFLLq37WJ63ZpP+codfm13kT7d0yOKQp2n0j+DBSgg6TuU01BSvxeuPYzPUW0N7c8Wq8r/mkiGcmzaa32ba8qL64NKe2NhaeXDmSRde8ABIDSttqsUgYQ53ZxtLKiOpTnyPDIbNXi0s/B8wU86xJz8VMxdoBFniPf4X1ERuwjNDpqPm4Vj2h54M204J71itCgMCRqrd5xCYq21LeCpgQlhYir7zOXhbwcqAMGH5yM4MlMElG5jceJnl4SHS412kBztEs6tf8ug==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=IViq9CY9; dkim-atps=neutral; spf=pass (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=IViq9CY9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXl53Rnz3cCh
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=c7VqPpX5FOMjU1fomf/slDzrk65Fe9+ZUNfqosDKTdI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IViq9CY9kXhTGFn2wUsXBESaNCGz69a5nG3mhGowHHuPZ1SldVYsbRj6+GmFeE33Z
	 /voEH0js7pDgeDh21Z+MjLukbWz6LUMqpwiLZaBJ7bgJ90kdMj+qEaksFeCP8FnFLU
	 ahCh3Altzen7MVBVZyzIJ7pSy8eLwZR3MIuEFpPs=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-2367-7f0000032729-7f0000019d84-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:49 +0100
Subject: [PATCH 23/61] net/ipv6: Prefer IS_ERR_OR_NULL over manual NULL
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
Message-Id: <20260310-b4-is_err_or_null-v1-23-bd63b656022d@avm.de>
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
 David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1558; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=c7VqPpX5FOMjU1fomf/slDzrk65Fe9+ZUNfqosDKTdI=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYkT2ujfxBt0/qzL4FNFAkOp+gWHYFk2Lkit
 DIh+cvm64iJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGJAAKCRA0LQZT0ays
 28wAB/9/0/0cpf5vUgxn9MJJYzgxi6whlUVZ+hEx14I9GPhNabUzF2GH9pZZve+bNpQXnutoTyU
 +K2sycG7CaZHe4KrWGw/XkousnHUY+/rbl34+pCGgHYhtioeCxrYnt9GpyhiDjCITZjPGFnwVQd
 tZoQ5ZBU+ihaHpCBS+WuTGNPnpJCCDmn98dooJV56KJmahzsCdhoR05xOLdt45OLH8bgiYvcsMo
 XA7dPRY2ZqI4sORPZUvgQgkReuo3OWATKHpGF0IEcgG6WPoIcp2tLoXu42clOKjzJCoMFBALo5l
 /DTaIDOUTWpiOr9bQY0VQkO8G6JfVgMRTCJghvSt33zKNrUt
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-85C93E1F-A15B4641/0/0
X-purgate-type: clean
X-purgate-size: 1560
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: "David S. Miller" <davem@davemloft.net>
To: David Ahern <dsahern@kernel.org>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/ipv6/ila/ila_xlat.c | 2 +-
 net/ipv6/ndisc.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 8991805fc3d60cfd2499146e522da142f33ddc50..c5e3954488ab7a1b1c07aff86385f5000945f1e4 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -545,7 +545,7 @@ int ila_xlat_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	/* Get first entry */
 	ila = rhashtable_walk_peek(rhiter);
 
-	if (ila && !IS_ERR(ila) && skip) {
+	if (!IS_ERR_OR_NULL(ila) && skip) {
 		/* Skip over visited entries */
 
 		while (ila && skip) {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index f6a5d8c73af9721741c11b543e5abeecdbf2079f..ab340f2489c0c7555f48c1f3f5215cb1d0b5b341 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1083,7 +1083,7 @@ static enum skb_drop_reason ndisc_recv_na(struct sk_buff *skb)
 		}
 	}
 
-	if (neigh && !IS_ERR(neigh)) {
+	if (!IS_ERR_OR_NULL(neigh)) {
 		u8 old_flags = neigh->flags;
 		struct net *net = dev_net(dev);
 

-- 
2.43.0


