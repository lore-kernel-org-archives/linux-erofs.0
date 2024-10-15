Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D968CFC264
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Oct 2024 03:36:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XSKWt5K6bz3cK5
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Oct 2024 14:36:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728963384;
	cv=none; b=eY29wtg2BD/oHhD2c+cDgXuT7CSqTAdiZS1mtUXamKhOPOUmjP3DtGfNu1KCZnaZH/edJreQaTcVlDQn7CD53u75pJzJGvAdgcbH7SkyMuopDcz99S+i7hRALA4cLVcuhnuOURw+M1VeRqXea4n9AJ9vXDTbklzKVyRpuBUuUjNPrV7trDea6FgOzblUMCgpKQHTP2MuB+q7U5HoSNqgMtCliGIMrjgGl4qKiV9/NtAF6mal5lvjbOJ3pTtSGMt+qzYUdI6EAi/BvXe3QieFp4EBMc5oxd7drYJRJ1vWJBpCy+be5hhbwUikY8uXbW0+go+PUt2eXZq0IQ8wmnDuPA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728963384; c=relaxed/relaxed;
	bh=KAnLsh6bLgE9XrlGeHLBUwKUDXPUE2E6PeL04XoPxyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aKTNpefby0501SR6gj+luHtcQNslOzxdDSSOZ2EDh5ZZtBwf+eOG73ECa8qcKb1ay6wZOGb7b0MHh4Ioj9r0R7RxXI6ygLL9GTAnFmU63ToJt3q39yY/SbHr9sJSNnYU19R2j7rnuX9SbNmBwaKpMuC3gSaqI9+12k3wmZST0yj5AYnWx5sTAqccfXEVtZw1ZZXG/HgPUAT4+s3PvUqGxIPAw4O6ON0Y9M5lWUNQzvHjMWFs+0QMl3UK+xzQgrhei4qnc8FazpDLb7PafL5ZhclCpHg0bFeTEFQzpewz7BoqNwu7TsU3w/Kx/4uX5IM3kDDu7E/igUM5MSIVZRwxxQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PL60Acov; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PL60Acov;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XSKWk3xp9z3bqx
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Oct 2024 14:36:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728963364; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=KAnLsh6bLgE9XrlGeHLBUwKUDXPUE2E6PeL04XoPxyM=;
	b=PL60AcovyOiN4psNYi0SdZj4+ebmP9S/IDTYvxcCSCRE7B5Y4NBxexCgRHA5Ryr4WRXal4gL9PUFE7/sI5U98Kn0Ycu3BLmkigK7gsOfmEfSwq+HttWElFmqASZqXc2ICo+1Y2iEw2vMamQfvewFzpFajN8WTXauIko4rhN2Z2Q=
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WHBnLfO_1728963363 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Oct 2024 11:36:03 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: fix unsupported blksize in fileio mode
Date: Tue, 15 Oct 2024 11:36:01 +0800
Message-ID: <20241015033601.3206952-1-hongzhen@linux.alibaba.com>
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

In fileio mode, when blcksize is not equal to PAGE_SIZE,
erofs will attempt to set the block size of sb->s_bdev,
which will trigger a panic. This patch fixes this.

Fixes: fb176750266a ("erofs: add file-backed mount support")

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
 fs/erofs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 320d586c3896..a7635e667d4b 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -631,6 +631,10 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 			errorfc(fc, "unsupported blksize for fscache mode");
 			return -EINVAL;
 		}
+		if (erofs_is_fileio_mode(sbi)) {
+			errorfc(fc, "unsupported blksize for fileio mode");
+			return -EINVAL;
+		}
 		if (!sb_set_blocksize(sb, 1 << sbi->blkszbits)) {
 			errorfc(fc, "failed to set erofs blksize");
 			return -EINVAL;
-- 
2.43.5

