Return-Path: <linux-erofs+bounces-2592-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA3AEFD2D62
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:02:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXn6LtJz3cCh;
	Tue, 10 Mar 2026 23:01:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::94"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144089;
	cv=none; b=jo7humroH9I5LRU9ixoGxEurbyJAiJufR0N5qtaT8cxdMir0LU462unEgxC+kLPczrcKOp1qtDZpE5db9Jts3zBFVRIplBMA0cGHJnOS+nJ4Q6ak/xYrJPxHIJFKXCLidln/uHw8+ja5S+Wi0PifwvcBvXKvJmUBlFFutQ/Saz8LLRvi0OmtfHq2+mAUxXW2qPec/PuRZNP66zXfKTKSEmaSLwUzlFaArGmTj2pLn5N7OCQOu/Fo+HBaV4LoGmb8CLLAlJlu3LnUw3RkkTk3U8GHDk3lKbjUbp5wqPECcSCjvjCeObsRzg3QYSnjUokbWgnNn3H4bqT3NUqjMue84g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144089; c=relaxed/relaxed;
	bh=zS/lt7IufKQt9b00w4tg0H1pDBP8jbAdIjOpgPRguTw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MgYfDr4ZJW69IhUivEIAqO6r8eMWhwliuuWMuiSy6OxFGk7k+jeUg4hJGpW65OHAXzhtt/rP89WBFbG9taaLIdOshjDD8MYGGlOMuSHXwM/S+Wltnbrz8BScXK3byEchF7wmusxcUOh1+QuF3JzNqgO9cA8PRFnEKEoKkzmP/Kj/vPBvLpZBKaqJyJU+jBmXWwxT/Ax5T0A/3rOtgS63EIZV+p3H6o5tAUKrfXNhkFGqqcmuHbIgKZ7Lhy+qqkHx29L0Wq6aibTgCfp5v2ghBjOJIzaynGSice91H78FImC9sG2bbioheUUlUz9+bL9C3qfzDofe6+SR3G3lmnmhEg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; spf=pass (client-ip=2001:bf0:244:244::94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXk66bPz3cD7
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:26 +1100 (AEDT)
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-e21d-7f0000032729-7f000001d9ae-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:35 +0100
Subject: [PATCH 09/61] ntfs3: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-9-bd63b656022d@avm.de>
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
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1617; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=0D7JqCvM2HduGB7jcCjsvL2MgPxSPSMnqWoOW6gFXPg=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAX0gr7ZqouZ6B9Y6l873KDZh87VRkMxmLSVt
 AItcTzXYr2JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF9AAKCRA0LQZT0ays
 2/XgCACwqNRVP1ceb2sCHMTvH8vznLrrwbRdBid2VGiRwlIoIqclnUBeLwwGZ/n/hBxtkijY1s3
 NziYVgznq0k9VYxacmvzAvuKhhv5805K9y/+itK+PFXmzL3ZRzqmfWP6ng28fVSUYAufwVEc7CR
 9llIbOBq8N4aCpqTBELhb7mwymU8hNLZpMBK934i79wnmNx9OySShuCrTBL+FEQ9g/aUtfHcqTV
 4JM/tu/NHEvIwEfZrC8rjS3HwU+8fz/vbF4We+/TjORw4iEGT1m6VfBdB71QF+Wi1viRKTPIkVW
 Nxf+o86GuJolrkUsNGy4WHdCFW95aUilkAjXyF+7XIpdZkLT
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-80E01F2F-4A43AD77/0/0
X-purgate-type: clean
X-purgate-size: 1619
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: ntfs3@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/ntfs3/fsntfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 0df2aa81d8845f21bfb571c408bd65b9e1fb8128..3ced4f95c2e95bac1fe5b334f976b8c8a15cf19d 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -237,7 +237,7 @@ int ntfs_extend_init(struct ntfs_sb_info *sbi)
 
 	/* Try to find $ObjId */
 	inode2 = dir_search_u(inode, &NAME_OBJID, NULL);
-	if (inode2 && !IS_ERR(inode2)) {
+	if (!IS_ERR_OR_NULL(inode2)) {
 		if (is_bad_inode(inode2)) {
 			iput(inode2);
 		} else {
@@ -248,21 +248,21 @@ int ntfs_extend_init(struct ntfs_sb_info *sbi)
 
 	/* Try to find $Quota */
 	inode2 = dir_search_u(inode, &NAME_QUOTA, NULL);
-	if (inode2 && !IS_ERR(inode2)) {
+	if (!IS_ERR_OR_NULL(inode2)) {
 		sbi->quota_no = inode2->i_ino;
 		iput(inode2);
 	}
 
 	/* Try to find $Reparse */
 	inode2 = dir_search_u(inode, &NAME_REPARSE, NULL);
-	if (inode2 && !IS_ERR(inode2)) {
+	if (!IS_ERR_OR_NULL(inode2)) {
 		sbi->reparse.ni = ntfs_i(inode2);
 		sbi->reparse_no = inode2->i_ino;
 	}
 
 	/* Try to find $UsnJrnl */
 	inode2 = dir_search_u(inode, &NAME_USNJRNL, NULL);
-	if (inode2 && !IS_ERR(inode2)) {
+	if (!IS_ERR_OR_NULL(inode2)) {
 		sbi->usn_jrnl_no = inode2->i_ino;
 		iput(inode2);
 	}

-- 
2.43.0


