Return-Path: <linux-erofs+bounces-2561-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C03FD2D66
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:00:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXWs6bTnz3bjb;
	Tue, 10 Mar 2026 23:00:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.94
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144041;
	cv=none; b=eEXk9fynhAzu07zTlI2TREwa5TTmGnALzzbCrTVAJbftQdcGOr8CSDaqInnoX7yifLu5Fdn0DF0yZ3Qhe02CdInDkIXW8c3lAWhoN1rX7wuWzet+zWl4fJzHUGGonkWvmkFeuQ/wEVdV14MDjGy3zrf8QGcsSdNYV3C3l+hQfy6N6GdIbXdrQkkTJOXT1OvKVX6ucmCWPlZKQmpma9L2tBxTTtPtDxwgYSnHIYtPcSG4SL+5PDK4fwW19TEPu9eSHrn12WLz+f12QXWauTpKmc36Dw/Dif9tRa9tpORP/VqC22Z8V82opHEtqXRGAM9DHUXKqvE1imiDvOdQIH0ADQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144041; c=relaxed/relaxed;
	bh=p0plzaKeSbxjl79A2lleHYZjr3IgqG3bFMpzk2gkjBk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lGqb73wGJYef4jECfz1r4MRryrFfieto+QdtMsTpt/Gu+7wpGQXEgorZzo+1HEV4Biu2y69hJvbLnTxrCApCNK76m+ecz8hWOkOX+eJXuAxuvH7imbadViIBQ+cYCwb4tUc21upfongsyC1rFQqBaEAP0kXfMiA4AD+9FvDL8YRhXn6mvqR3fN2auLjDeZMGxm5y5eR+8/Njb0W4PHsAYImbU4Ff5uFLwAK3kQ90idsXD9JKohqeupD1yDVjIMzd/tpVhzJjWn0jqBaZBYQEYhvNsvAJIavGmXIj3WeKfktpAuTZmurl4D1OZZ/8UwTmvx1tNIWkPPlNfBLn9AZpLA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; spf=pass (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXWs0nbKz2xlx
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:00:41 +1100 (AEDT)
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-e21d-7f0000032729-7f000001d99c-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:33 +0100
Subject: [PATCH 07/61] erofs: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-7-bd63b656022d@avm.de>
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
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1165; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=Wx/k10vuVbp8ZUI17J5Bmoq0XIce6rBC9+YI4+K5MhY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXuTWLAsZgE3CYfS0prKIO5oYoR3eM1fSwdn
 +XKr0TQn0GJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF7gAKCRA0LQZT0ays
 2/j8B/sEd5J2vRHsnvhncB2lMo9VZ5h3+ZMJUztWw9QhmuXX9Qx3HEdJ5GLZ84ct6sqOhNTdJzS
 JFD7aVZEzrOOhcVXC4LBSF/0LTyuRs08pHBx90juaWCHs505i/RK57onvWUjJYv2jNvBVJQQ+S6
 AU4u0SqHLiT0AAUqbjuiM2TTHxhB5xD59cg+mk4rXkCdmvt3sw2+h9McRwE+VdqWIniC4/IsZt/
 lSDklfOcCL2PaTrHCFhWHaM0/yrWd/ljPTRmFceOPsri9YRyl2VkofnQ4LBx/tIitZdlpukR5BZ
 3gdZMB70thXOoVOpRxkVmdjJvHPiGXebLpJqAK8oxLcbLF+S
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-8966EF2F-D5F13E8E/0/0
X-purgate-type: clean
X-purgate-size: 1167
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
To: Yue Hu <zbestahu@gmail.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
To: Sandeep Dhavale <dhavale@google.com>
To: Hongbo Li <lihongbo22@huawei.com>
To: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/erofs/zdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 3977e42b9516861bf3d59c072b6b8aaa6898dd8a..88c293ab2b1ef7962c6f5c0aa82639859e41b8e2 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1227,7 +1227,7 @@ static int z_erofs_parse_in_bvecs(struct z_erofs_backend *be, bool *overlapped)
 		struct page *page = bvec->page;
 
 		/* compressed data ought to be valid when decompressing */
-		if (IS_ERR(page) || !page) {
+		if (IS_ERR_OR_NULL(page)) {
 			bvec->page = NULL;	/* clear the failure reason */
 			err = page ? PTR_ERR(page) : -EIO;
 			continue;

-- 
2.43.0


