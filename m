Return-Path: <linux-erofs+bounces-2588-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7147FD2D62
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:02:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXm58s1z3cDy;
	Tue, 10 Mar 2026 23:01:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.94
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144088;
	cv=none; b=aIB+1dE4Cg6kPfDWxHkflMg3a1gLIcVhgWQZ4WmX6+3eYUdMf2ptvvefsfoZPvmMqN2gPZbOn+Wy2D0/kfQ4sTYgje+0cySyLQH6hcsQArvUAsXWCNngMYBpGN8Ic2jH/rTrYZtZIAE5aDZnBhW7/qpvegOKRNGDrtrzK+S7wjCkr9AnyUM7UEmY7AqlQnI+bjKi7cqE7VYCaswNOoFqQFPwjMHUuoGrs9rS14fb/8AfR63CophESQ7WRmWDV6h3zxAa8ThtmeRHwMCP895gdvKKw9djCZ0woPwGB/jlcmCC9qiPK8B0pfxC5Iw6Ka2AVWxE+i/OrNehiBnx36oi8g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144088; c=relaxed/relaxed;
	bh=SsDTIIufDBFhlyEIKSZoh0ke1dsx9IoMTvg8hAIVw3s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OEy0u+BTHEXtMLu3gBp5pTjKBx90iNnLFmLCzoKcUqpL3iKUPJS5FTsywhSKILIu/tqJRAxml+5IT0QJHkRKM5zOO5LUL+72R6LFedT5Np0n+lgWlSih5p9eDPjzKHfytQ14ANlhTDaz9sJPH7/BqeSRQQt68+re/plbUQ907blwxYrit9iXlSbGoKLozshS1ZtJam9V+N1v7GPG/GfjW/lcP7ftmfM/Tipv7JIKBvglwFRzVe0VMTyHRDGZwENHO7wso2kwl+4oYmga4/0YI89LGVW/mMlaJrWuEQ323OQv9WkjcD1oYWmAVI5y5xVBCMEVEujEZIyOAxjw3Tf1vg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=xKnBkg56; dkim-atps=neutral; spf=pass (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=xKnBkg56;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXk0m20z3cF4
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=sIEabNGpfTtaNmN5jdtpnoUYPpUdFMe596BbQNmq6Ew=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=xKnBkg5622xaCaFlGwFQ3bswFSgdcTVbCDHB3k8l65KFt6Ule9kyi3QR8HfOXuW5L
	 MKbugm+H1wq/E04UmM1cfkP9mUjiEZ3Ws7yzlEjYYTJHZ64lqewOtbO15JI10WApm1
	 CoPFx+DZxYAYXylALiT4nuOog37Am7eL2zh2ct4Q=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b0-e21d-7f0000032729-7f000001bae4-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:28 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:28 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:19 +0100
Subject: [PATCH 53/61] hyperv: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-53-bd63b656022d@avm.de>
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
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1146; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=sIEabNGpfTtaNmN5jdtpnoUYPpUdFMe596BbQNmq6Ew=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaKQPK6RykE0QE2RJD5htL1ZvRNh+zI6jTmu
 VOYpL5CXyeJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGigAKCRA0LQZT0ays
 29fzB/oCGLAMazrUNiEmwKr9nq0MNT5XdhZH3wkJWE4yJ+UKMd35Xi9PPSb65qZMk+N4uMiZj2H
 T6Td1MreYgfIRLT7kTJk/n1BuSWWFP55nfvFZFjjhY5aoonvuH6RpMC7x9+9tNKQtJ7ne+y8JUp
 qmDL3C1GxXXFNKbwYmtZySONDO5gXmgMnGjDdckVFucnIkQYwHywWpIrPTZv3zUS9k6qS6F4HLs
 npSrcLjQ++9xnCfmtppGIezlVuCbkGtNbWVtJ6RuDAqRXXu4e1NER6f7pIlU/5AgYfpLOxyecDo
 JLi+d7tyzKhXU/h5ql9oJc0IZPZktOy6eLbVlaElpfc4YFhD
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143728-95676F2F-E8C255A2/0/0
X-purgate-type: clean
X-purgate-size: 1148
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: "K. Y. Srinivasan" <kys@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
To: Wei Liu <wei.liu@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
To: Long Li <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/hv/mshv_eventfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index d8471546e6a0c7e6eca933c640459f1d02152cb2..24dff7a498ac9c3edd31f4c9bc2f23729ba2a6ce 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -516,10 +516,10 @@ static int mshv_irqfd_assign(struct mshv_partition *pt,
 	if (irqfd->irqfd_resampler)
 		mshv_irqfd_resampler_shutdown(irqfd);
 
-	if (resamplefd && !IS_ERR(resamplefd))
+	if (!IS_ERR_OR_NULL(resamplefd))
 		eventfd_ctx_put(resamplefd);
 
-	if (eventfd && !IS_ERR(eventfd))
+	if (!IS_ERR_OR_NULL(eventfd))
 		eventfd_ctx_put(eventfd);
 
 out:

-- 
2.43.0


