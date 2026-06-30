Return-Path: <linux-erofs+bounces-3790-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FCC7C43458
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Jun 2026 03:18:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gq7db44F3z2yY1;
	Tue, 30 Jun 2026 13:18:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782789507;
	cv=none; b=mhS2u98KI0C0k7M+8auxUP82ky1/7G3/dm8yzd6QA3bXYlMHri5k5CqyLxjEd1GlWn6BoKs6xa0NP+wbkXqeKwA0SM6ZdKQlfkeS3pqH4wst0yjUo4FiLV8VKyHq2fHdjMRZhhq0srjlKdePsuPBoMr2MTr+gZuZavJxUBvcsSPIwnWdLHSrdBhnPVNZE9qlRjS6txR4eKl6pSsfk8MROKqbsOqfQ48kH/UQz6zgd3S8v5KRSswVZzd7ihBVez+bYn1W9Ratoh1pRC2ef69OJrZN3jhY1SXckS4ZFSGdxuiJXFr72TEY6OY91LVSSXKClmQCBOuxxcRYQCNXR4/dwg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782789507; c=relaxed/relaxed;
	bh=UIFfyklStT2rTwa1NawWQDEdc3GahqXjs8gDA8bQPsk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QlaMUPvBk3QQyi6pOZWDz/YyV8b50fdTBPppDWqxU0/5u3v9T9xX8tefO7vPQf4kxuz6YDadZSlOu/8IF81CizxCx5zwStctL/n71QsNWBtpoDE1SWFhqCSk1h8kxyAfcAyBYeEb/0L5jSBUOLZ5nM8CH6qOi9iZ9vhn3+geSynrrJ0wRc6u5uzwBsY7yJ8tWMet4kkyhjzAhaQBW2oFK6yBQgWp5kBAkyNhbC96wfHmUuQ03E76ZXZ6vJeFyiugwWzY1OBaeJXQROXpnSxyajJXC1Ixxn+0XvpsX5+TDpSRoPQRhAVVbhI0AE1hEdUI2WGIxvVmFG3SjchrK74dWw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rpPex5BS; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rpPex5BS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gq7dY0WR8z2yRM
	for <linux-erofs@lists.ozlabs.org>; Tue, 30 Jun 2026 13:18:23 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782789499; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=UIFfyklStT2rTwa1NawWQDEdc3GahqXjs8gDA8bQPsk=;
	b=rpPex5BSgt4GlhKW6Ztynxg+vMR1OKHoyLqr8rZxvjJyt251yaxXMIv5/GBdIkmf7Kij/QKW7aB1/T5qjOSUPzeEneBhBgIggyNsken/kuxdoL+yQEQEc+xq5mWqEqZnaUtk6R25c8Me5HG+1HMsEZh2lQEHCgOMXq+7iMN/JL0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X5zSann_1782789494;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5zSann_1782789494 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 30 Jun 2026 11:18:18 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs: use more informative s_id for file-backed mounts
Date: Tue, 30 Jun 2026 11:18:13 +0800
Message-ID: <20260630031813.3992408-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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

For file-backed mounts, set sb->s_id to the MAJOR:MINOR of sb->s_dev
(which fstat() will return) so that kernel messages and the sysfs
name are more informative rather than just "erofs: (device erofs): ...".

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/super.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 86fa5c6a0c70..c5881bb8d52b 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -595,17 +595,6 @@ static const struct export_operations erofs_export_ops = {
 	.get_parent = erofs_get_parent,
 };
 
-static void erofs_set_sysfs_name(struct super_block *sb)
-{
-	struct erofs_sb_info *sbi = EROFS_SB(sb);
-
-	if (erofs_is_fileio_mode(sbi))
-		super_set_sysfs_name_generic(sb, "%s",
-					     bdi_dev_name(sb->s_bdi));
-	else
-		super_set_sysfs_name_id(sb);
-}
-
 static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -657,12 +646,14 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		err = super_setup_bdi(sb);
 		if (err)
 			return err;
+
+		snprintf(sb->s_id, sizeof(sb->s_id),
+			 "%u:%u", MAJOR(sb->s_dev), MINOR(sb->s_dev));
 	} else {
 		if (!sb_set_blocksize(sb, PAGE_SIZE)) {
 			errorfc(fc, "failed to set initial blksize");
 			return -EINVAL;
 		}
-
 		sbi->dif0.dax_dev = fs_dax_get_by_bdev(sb->s_bdev,
 				&sbi->dif0.dax_part_off, NULL, NULL);
 	}
@@ -740,7 +731,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (err)
 		return err;
 
-	erofs_set_sysfs_name(sb);
+	super_set_sysfs_name_id(sb);
 	err = erofs_register_sysfs(sb);
 	if (err)
 		return err;
-- 
2.43.5


