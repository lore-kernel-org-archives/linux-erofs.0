Return-Path: <linux-erofs+bounces-4485-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8326C79F9E
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 08:31:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdgJn0PJvz2y2L;
	Mon, 07 Sep 2026 18:31:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788769880;
	cv=none; b=QI4UMTHXAhNkuBMC5A6H0fSoidblNVPrgPCVvIf37UcEdC50Gl+nHCkGc9XDU40lkR3kfaJW+x8mAgkNUMl8h3JHQlPLHiUdoTinz6s2uuD4pMk8xRcFaQaqdYzetp7q4vfWXvvyWoLMr9mOmsHq2yza9HHnkPy6WCKA7Ah+ucfUqrNusMlCW9LhzBlpUh7vCDXzvQmfIhyT/pi4KX84qQzG2bgjmhacXkf3Wdb2iqWmV2MWrn7ruWHCOZWaairIZWXxk1MwYZGXAqH+ZGmpr5Qp0eSbudKvbfe0x140ocM2sQ1RWXupUkjT5Wc8uGvoSkdMNlfwTjtjBIff8AeowQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788769880; c=relaxed/relaxed;
	bh=Zy/5iMlRReRvHU3o0dN7xPk3l3MIw5hSOG7GNRXTKoY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YTTSiAGNdxWjZzIOViY3tkdjJQ5ZKSw+g1h3pTiSRjo4GA0ME9clu+z7uYTkKWxneKw6DFx6BilfiQ3UUzGOSlwDQNsDv9yb2D1x2W5LKSX6RoZiTmG4bGBosIwsXiOborUG/X+P4wueECtKEmSn8g7tQwX2Uizb34FIB5AaRTQHHULu8dvKkdqEI+XSEdfGjjtVTvuW4UyJaIG47npumH6PB6Re9PoyoZMg46I/RLaaNd865HFbsSSv+1lGUB0CfoAOckz+gEoMvFLIKQoFp7HiCQCpUDDEJzZUm/zKHFDko8slHUe0DN8XvhsvHTCXaq5CDp5+cX5H3rJ4hDvUuw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WKBDa04C; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WKBDa04C;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdgJm32M4z2xpv
	for <linux-erofs@lists.ozlabs.org>; Mon, 07 Sep 2026 18:31:20 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDC354344E
	for <linux-erofs@lists.ozlabs.org>; Mon,  7 Sep 2026 08:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF4A1F00A3A;
	Mon,  7 Sep 2026 08:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788769877;
	bh=Zy/5iMlRReRvHU3o0dN7xPk3l3MIw5hSOG7GNRXTKoY=;
	h=From:To:Cc:Subject:Date;
	b=WKBDa04ClG0rLqo9feWc+Yb2l5f2DJ9hkOwD4OTpkqR8Il8driSuOc7M+rnj1HdTf
	 6ijnzhbiKnj3ErRYM9CYln7pTx7+7s5s6QEGPeCq6bRM9SUQfvgh0s7IpPFMl3VyPf
	 PZ0OAmdcpsOQrVjFqCKRzLvovgRneWhwUZL8WUL5DuHB+e/mlPyB4gnORLLwP21Onj
	 fzJDHrz+JbqmKelfsqtmhbUFTxOtTsSIQFHUuj7hA/4O5LpyrnhN6xLkjngZQJmXuL
	 9WFGlnM5gFowA8DXIyG2gSZrWgVaxy8WDz+F+1rD7zDNUnWeVy8Nad+b7SG/3DiqLF
	 VrchlWjtoxEdQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH 1/2] erofs-utils: mkfs: resize blob devices as well
Date: Mon,  7 Sep 2026 16:30:26 +0800
Message-ID: <20260907083027.13793-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
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
Content-Transfer-Encoding: 8bit

Introduce erofs_flush_all_devices() to truncate both the primary device
and all extra blob devices according to their recorded block counts.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/internal.h |  7 +------
 lib/super.c              | 18 ++++++++++++++++++
 mkfs/main.c              |  3 +--
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 4d09c58..04775cc 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -468,6 +468,7 @@ int erofs_superblock_csum_verify(struct erofs_sb_info *sbi);
 int erofs_mkfs_format_fs(struct erofs_sb_info *sbi, unsigned int blkszbits,
 			 unsigned int dsunit, bool metazone);
 int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit);
+int erofs_flush_all_devices(struct erofs_sb_info *sbi);
 
 /* namei.c */
 int erofs_read_inode_from_disk(struct erofs_inode *vi);
@@ -543,12 +544,6 @@ static inline int erofs_dev_write(struct erofs_sb_info *sbi, const void *buf,
 	return 0;
 }
 
-static inline int erofs_dev_resize(struct erofs_sb_info *sbi,
-				   erofs_blk_t blocks)
-{
-	return erofs_io_ftruncate(&sbi->bdev, (u64)blocks * erofs_blksiz(sbi));
-}
-
 static inline int erofs_blk_write(struct erofs_sb_info *sbi, const void *buf,
 				  erofs_blk_t blkaddr, u32 nblocks)
 {
diff --git a/lib/super.c b/lib/super.c
index 2bb22ac..b1b3ab6 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -525,3 +525,21 @@ int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit)
 	bmgr->dsunit = dsunit;
 	return 0;
 }
+
+int erofs_flush_all_devices(struct erofs_sb_info *sbi)
+{
+	struct erofs_device_info *di;
+	int err;
+
+	err = erofs_io_ftruncate(&sbi->bdev,
+				 (erofs_off_t)sbi->dif0.blocks << sbi->blkszbits);
+	if (err)
+		return err;
+	for (di = sbi->devs; di < sbi->devs + sbi->extra_devices; ++di) {
+		err = erofs_io_ftruncate(di->bmgr->vf,
+				(erofs_off_t)di->blocks << sbi->blkszbits);
+		if (err)
+			return err;
+	}
+	return 0;
+}
diff --git a/mkfs/main.c b/mkfs/main.c
index cfdffa5..d9b4e22 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -2062,8 +2062,7 @@ int main(int argc, char **argv)
 	if (err)
 		goto exit;
 
-	err = erofs_dev_resize(&g_sbi, g_sbi.dif0.blocks);
-
+	err = erofs_flush_all_devices(&g_sbi);
 	if (!err && erofs_sb_has_sb_chksum(&g_sbi)) {
 		err = erofs_enable_sb_chksum(&g_sbi, &crc);
 		if (!err)
-- 
2.47.3


