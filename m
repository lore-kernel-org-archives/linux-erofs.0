Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD5ECFC272
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Oct 2024 07:08:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XSQDS3jk7z3cHC
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Oct 2024 18:08:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728976102;
	cv=none; b=U1G/c8DfmU45Tfc6KwlpSzlMFs1CBkAAlpz/ghe2sEiYYrn6fNhBGoRoTnvQdsKhRO+45ylQS/wqAZMVn1Yzsq3srE0t5RqzwnbEwrWuSyo+JjWAO+7gFSm9ZwC94kr+x9uavMHYVH5i+ZIpgmbQx6zp6YpHFE8t+TTt3fGIJxVu7Zh3YuYBTiuRhoSxmJXzOHl6QwSE7ruwBFXy486YqUC0m1PqLfcoEyuF3GuTorOh2LgUPKIxWberwd840/rttCRyiF/hSvWlQwXmrSfJMf4anIXtFD0UkIeXzOm7UPkPK7wvhdclzSTrRHIqWt7wV8mn53LYw/dXpAvtp1saoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728976102; c=relaxed/relaxed;
	bh=6gFoeTlFavv7EAeAASqltytkDM8bjC0/MUctFJ6l394=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jTCCLZ/4PSRlshihzsAcFPxEZ9PLLkOKBY/uewL7tvm89g0kSntCVNnmCumWJd8+kMPITVk+MjQOjDHkqyRIf49UlqBFyjVTqzkK4cR9TybH4IAix3mqcOpXHB84WmBFeMda7d4jdKReO/fHhEpjiw8IpNT8fGBZfxtRSSnSPy0eGmhlIbXKlqng7tBkgPTlGE4UtASxP452LfximSD4+c6OoCnh1gEh0nB9ScxAJL9pyVBqqS9TfuCld+KQghd3l2cDkKn4fHPg84yCfLBH+hPylb9GZH+KfmQB5F9JsmtAUbd8byuajaWyYYWALskn4TNRPnJPH/URW1Xd7lX8Og==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sdyg/g0j; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sdyg/g0j;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XSQDN0BNTz2xJ5
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Oct 2024 18:08:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728976090; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=6gFoeTlFavv7EAeAASqltytkDM8bjC0/MUctFJ6l394=;
	b=sdyg/g0jBiqlZjoaW9+SpJb3qZOzBBDxYn0jv994eTvBF053a21KYO3DsRlyvoQmMTKyHM9Oir1Gijy78LeVD+wr/bzsOmWadWrMjNnG6N3NxJpw0VTWSFvK+7m6YrMyzHieAINH68nEcUtg6QyI0AYaXx7agNuvkW0X012X0mg=
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WHCbt5k_1728976088 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Oct 2024 15:08:09 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v3] erofs: fix blksize < PAGE_SIZE for file-backed mounts
Date: Tue, 15 Oct 2024 15:07:50 +0800
Message-ID: <20241015070750.3489603-1-hongzhen@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Adjust sb->s_blocksize{,_bits} directly for file-backed
mounts when the fs block size is smaller than PAGE_SIZE.

Previously, EROFS used sb_set_blocksize(), which caused
a panic if bdev-backed mounts is not used.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
v3: Fix trivial typos.
v2: https://lore.kernel.org/linux-erofs/20241015064007.3449582-1-hongzhen@linux.alibaba.com/
v1: https://lore.kernel.org/linux-erofs/20241015033601.3206952-1-hongzhen@linux.alibaba.com/
---
 fs/erofs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 320d586c3896..ca45dfb17d7c 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -631,7 +631,11 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 			errorfc(fc, "unsupported blksize for fscache mode");
 			return -EINVAL;
 		}
-		if (!sb_set_blocksize(sb, 1 << sbi->blkszbits)) {
+
+		if (erofs_is_fileio_mode(sbi)) {
+			sb->s_blocksize = (1 << sbi->blkszbits);
+			sb->s_blocksize_bits = sbi->blkszbits;
+		} else if (!sb_set_blocksize(sb, 1 << sbi->blkszbits)) {
 			errorfc(fc, "failed to set erofs blksize");
 			return -EINVAL;
 		}
-- 
2.43.5

