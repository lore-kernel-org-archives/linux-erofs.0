Return-Path: <linux-erofs+bounces-2596-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8217AFD2D64
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:02:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXq0DxRz3cCC;
	Tue, 10 Mar 2026 23:01:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::119"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144091;
	cv=none; b=T+iW+gmfNp00mCpc83fqf9IefE/3sB1hREslTIogWxBIoy1mLV2bBrAU445yTzH1wMuERP7tT7rmhnJnnWRFVYwaXEqXP1NbbxuFjEU5FqgmmVu76D+c+F7rNrUXKx3t3Bf56sq7r+p8f4F3MXpat6o2feis0YOdMzYcKqqBtGPXHnIdkkzK4EzIIbzOygPoyWu+Uk6GaVsVE4tVxQ0396jzqvhd6SLhgV1f01TRKA0VS1yIg0wjOU8HOnt81rStgGaQ3DvGDHKL1R53vOqBbxbJs8OK5NLAWlTqVRWC3H/DsdcZ2I5nwfVwA9BGOUJGEWYYn2DVSxEY2CPAnwtRWw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144091; c=relaxed/relaxed;
	bh=dTXCjBRniTLoTR5IZDzkCFvkxhSidV7zyOsOCp6MmUg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EA5ZZKXJ7Bs7Gu429V76mMBs9vz/OZ5j2lwlZWiWis/sVEBmfjYQ2YPjJ5EyEBfr8SBqEBtJnngBzw+1vEAOaRN2NxBvCh5xLCFlWf5ND7Vn2N5WsfU/hR/8NeeE6eO3CL8US9oVixIsz2ch0yEA97hDkGYGz5OlzasD8mKRxeSXEbHkNFwzVbxhrVeYMktBciHSzMPziF8hcTU1dRVqd+ELW37oq4zsmmN23IzPYSrXOb2Dv8P3kTvDIMsPL8l7zAr1szVS2jfxD0dsOjkG8mevKblyWXR2uzgEnltUfLNQrATcrSl/sIcRoLWfDG3sIzqMbTfBsOMBsNDDDOc0mw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=ZhZk+uUN; dkim-atps=neutral; spf=pass (client-ip=2001:bf0:244:244::119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=ZhZk+uUN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXp2XwKz3cG5
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=kiPG2WUM9IIy6uswgVTVvYBzahqCQdDF2WT1QCoS/Vw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZhZk+uUNXnEjnXl3w1yfhkldMOPDqhhLXZDAMjGv1auPlOiTaiSmNuwae77r69zpo
	 wcrpRdQM8a/BZjLbD65ntammcni0DoJ16RicrUwWgtwucTmCe9C/jdQpatxzC+dLyR
	 7BX2TKdOEfp7WLvyJKm7RVbstZgrWU81uOV3ziCw=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-2367-7f0000032729-7f0000019d32-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:40 +0100
Subject: [PATCH 14/61] seq_file: Prefer IS_ERR_OR_NULL over manual NULL
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
Message-Id: <20260310-b4-is_err_or_null-v1-14-bd63b656022d@avm.de>
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
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1255; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=kiPG2WUM9IIy6uswgVTVvYBzahqCQdDF2WT1QCoS/Vw=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYFWY4XXOtO7D0H7zI3NI24qzy0WRyWgjhsq
 Pb/2PtoUG2JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGBQAKCRA0LQZT0ays
 2/mIB/9Q6s+1zeiVLXadpRpmyYqAancRy7Bn2FComUQinQhHrSfolPuiVxb6YyfHfnSDtXR2P+o
 ZC/nc1mJGpByDWP4SS6acK19nNK/UVhicQydNeQRM17jmZovojRAWhs2/Nh6sutbizWZwHsYvxg
 dtISFMErQIBKR+INYDqNnYmu1VPajdqnQ2qfmPWd9l1FO4V1847kZKmczXV6MF80eYNGSPwebB7
 l5j+3Vv8ufK5FuVMTE1IDmjxjEXHtLbmfXLvEEcTc8Z+XvV4Rj3NOSWzcbcpJ8pMZ35IaPEecEu
 E1IfNqm4CamuHsKtBBAJcEXcTCoiSwuZuARjawKppxNaRDTT
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-84C8DE1F-2119C3CC/0/0
X-purgate-type: clean
X-purgate-size: 1257
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/seq_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4745db2a34d12b1084cb059a667c367f4fb56dad..da30cbd6485ca8eff6c2572eab10659c694387d2 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -226,7 +226,7 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	p = m->op->start(m, &m->index);
 	while (1) {
 		err = PTR_ERR(p);
-		if (!p || IS_ERR(p))	// EOF or an error
+		if (IS_ERR_OR_NULL(p))	// EOF or an error
 			break;
 		err = m->op->show(m, p);
 		if (err < 0)		// hard error
@@ -266,7 +266,7 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 					    m->op->next);
 			m->index++;
 		}
-		if (!p || IS_ERR(p))	// no next record for us
+		if (IS_ERR_OR_NULL(p))	// no next record for us
 			break;
 		if (m->count >= iov_iter_count(iter))
 			break;

-- 
2.43.0


