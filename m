Return-Path: <linux-erofs+bounces-2565-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539FFFD2D62
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:01:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXd0sLCz3cBP;
	Tue, 10 Mar 2026 23:01:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144081;
	cv=none; b=grKFt8F1YEis5R5xRud8nnzcksLpe02c3LjVzy3DlsOg+ZplnlNuny3XaIvmoKaBBgYf0kjg07KOgQa+hZP/rjA4Uw4b2Akx7qVAi2698KwjJlJ9pwuv1td4GUXHMsk0oacwn33zknInQjl4JVwmO+1D/pzjnJ8z7IoziqzRtfIShrlPIP8ekB06YV3g9FZdxflrvCEHa+OGmgSCa0Y7lpTO7JVtdTNmyYuUYeDYDdtBs2xHm2FHSmKfcipAyxKqPuZZjnXcLfizbEWk+0zvXbgcXF6/+izb80WE+ri9SxBXelr8xQbs9vVoKhPg6yPDlG/Efd98CD1ZrBTGPj6wnw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144081; c=relaxed/relaxed;
	bh=CGmSA97P5zoUAPVKt40UlhgFAMOY9j0jHxmE1RUkWWE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=POTOiykhMpH5dRVgfUgARBWh7i0wMR2FxZx9z2KYv44FPgOfrHZvMUEpgsCweiz4qodpLMgtWAFFSXq1QlZgP2XK93oHVUb6u8DDqGuEj4dO6EurNYQTNUKmFlYJug6SwJEDOIkdKEOHFaHWHB6aL7J4CLEdJxrW5muAWtYb6Pk2dvqjtg+3RNVW5h7t7Vw+uKgPktBWFqSb/f14vnOwwMzP1kV8YERDrv1qgerx+rOVs0+NRESkoL7i2iUZg+F88N9lvbbteAZEvPurkZgnpZfnxubykV3gpkUhxQEIoT7HIAL7tUu5lZLi9JbXNea8VbphZPVktFygetgrbKWqTA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=vGHDpooj; dkim-atps=neutral; spf=pass (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=vGHDpooj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXZ5k5qz3cBd
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=vGrPLNOiClPR9kf2JYtGEgONwIn4sxqTHiWcc1kKKyY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vGHDpooj3kbLZ+8D0plCbMeYqQhZctChcZoWM2Oz3ppzOc10y+IZamI2t1Up6x5Oz
	 ZOQWpS5VxsHODQ5E0bYLhrVtG85jFVZABrb+vIZU9NfiYqywilzOFMSb7wFF9KlZxk
	 XMjhpb+uZFDFGYC7810AK5hKKVXc3NZ47/tNCbvg=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-2367-7f0000032729-7f0000019cec-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:31 +0100
Subject: [PATCH 05/61] smb: Prefer IS_ERR_OR_NULL over manual NULl check
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
Message-Id: <20260310-b4-is_err_or_null-v1-5-bd63b656022d@avm.de>
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
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2182; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=vGrPLNOiClPR9kf2JYtGEgONwIn4sxqTHiWcc1kKKyY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXmFi2noeXj0abdUjIB9kKoSnFcuerTTnqGw
 aIV0JkIMuiJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF5gAKCRA0LQZT0ays
 25ZYCACJTZVo2gUPO+X2etWPNlTUp7ClEwWSNg3dPZBa5w0Z7EuwahYUGGyy8BKX2Xr3Nw3eStQ
 sVKw7MXxWmXWt5UTxCuTdRP3F8qkFihhAcyZGnaWXtsHW80RrqCOvZyrn/d1kQqYEpMpKbZIZxv
 /EpbwmWT4XeRvGuaEWqQ2bbe/QDrikm2suvUw6m77AVK8ag0Unhi8yF7km5ZQPmNxRG0b7wRfDu
 f9v8qAqM0yTILYLsa5pGAGuQ+9RoWhRyw/Vp6w7DPGkGl5Ft2gyZ5dwPzpx69OognVNti4fm1g6
 tztjOPF3hTnYGvxjbl6RQZRancjyqct71KnXaO98GUCNnx9j
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-8ECA1E1F-59018045/0/0
X-purgate-type: clean
X-purgate-size: 2184
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Steve French <sfrench@samba.org>
To: Paulo Alcantara <pc@manguebit.org>
To: Ronnie Sahlberg <ronniesahlberg@gmail.com>
To: Shyam Prasad N <sprasad@microsoft.com>
To: Tom Talpey <tom@talpey.com>
To: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/smb/client/cifsglob.h | 2 +-
 fs/smb/client/connect.c  | 2 +-
 fs/smb/client/readdir.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 6f9b6c72962b09260542b711d4c64e7dc42c7845..fb731b2609465ebe50742936b458aba210ecbd4a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1336,7 +1336,7 @@ void cifs_put_tlink(struct tcon_link *tlink);
 static inline struct tcon_link *
 cifs_get_tlink(struct tcon_link *tlink)
 {
-	if (tlink && !IS_ERR(tlink))
+	if (!IS_ERR_OR_NULL(tlink))
 		atomic_inc(&tlink->tl_count);
 	return tlink;
 }
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 3bad2c5c523dbd1d4b1ab253567984612be0f348..aa12d327894b270b59ea30be0e6d77b4188fc98f 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2895,7 +2895,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 void
 cifs_put_tlink(struct tcon_link *tlink)
 {
-	if (!tlink || IS_ERR(tlink))
+	if (IS_ERR_OR_NULL(tlink))
 		return;
 
 	if (!atomic_dec_and_test(&tlink->tl_count) ||
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index be22bbc4a65a03ec64b87d8505d1496279f22efc..3e9260cca196ea8ab17aad82c4824ec5e468e2e7 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -165,7 +165,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			inode = ERR_PTR(-ENOMEM);
 		alias = d_splice_alias(inode, dentry);
 		d_lookup_done(dentry);
-		if (alias && !IS_ERR(alias))
+		if (!IS_ERR_OR_NULL(alias))
 			dput(alias);
 	}
 	dput(dentry);

-- 
2.43.0


