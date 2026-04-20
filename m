Return-Path: <linux-erofs+bounces-3332-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D190EA71B7
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Apr 2026 03:46:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fzWcf4d9Wz2ySf;
	Mon, 20 Apr 2026 13:46:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776656786;
	cv=none; b=hAQYsFwxD+K9dcL0HbxvN2SwwPOjyxVeDDPBtpF9/6FxEoQbmH5ldQODMebLgWNs59qTSnkcWZBYPg+UcHBwdNnTwPnm2ij6L6QIoK6yrnt4NpRAxeNY6g5vyp6t1h/OMa4C0scbsn+QZPhcvwRGId61ve6Ma8OYwVPzPIhVKEjNdTYSbQNUFeh3q7X4Me0MDxMXXFbA6K75GhJ5yiCNfs+BK2AkgUg5qeA8udL7S+H1CA3ZqpDRycZZzfngd2oa9PwWlRS1W1LQRoHWH7ZrmCtfiZ7JSKQXOQUDtOk04k9xtoMswNyf3DJyowxYp0oAEaRubyceU/ZT89iZl25FYg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776656786; c=relaxed/relaxed;
	bh=C109QfEFhqbV1nVa29ooezzco+8hIG296HCXJnwniwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YCYWeNs6gqRPTBCtG8BTOMZMyGAuhrbDqyiU00tENlrpBSgYjR5deu1aIgncfR/HsyiqkTAU7Q45dUjfjLXegoZnQtvdMhMWLimOp+O2qPH6MUbHtsuxapyYv07Wg9Z57wIRVIHIKc7gBiPbA+JdFSy3LvrssKMpeP4LsnUc7mACuh1Dv0jw1YBa71oQJY0UYK+Z3cG7xe8lSiIFKb5TzjNiEp5CjdnFc2K/zM2qBTUELiDHF0yYEBZCfquzqs88URF/4+7iNkToBNWtYosC0xYzB6fXlLWAHp+KxLjFp91S3ol3KLCgGfRicIj2lpMUWH9rd9ZwQwvPMHgAznRmkw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gIRhIJ8l; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gIRhIJ8l;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fzWcc4JR2z2xnl
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Apr 2026 13:46:22 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776656778; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=C109QfEFhqbV1nVa29ooezzco+8hIG296HCXJnwniwg=;
	b=gIRhIJ8ltU1hGqr5O9cuPDs7EEFp3bFXvpMFB1r7UsEpqiCXMXaJ1bw2ES1MMEtJi30+huHEkkRBtGggErTLEWmmwCwtJwUNxHoVLPYhsfp8KDTxKQpeGhcA5QrpxquwnJk9RLbBu7xfatuoAuVX9NXMahAHoNw2/O6QZu6gIk4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X1GxfIW_1776656773;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1GxfIW_1776656773 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 11:46:17 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs: fix offset truncation when shifting pgoff on 32-bit platforms
Date: Mon, 20 Apr 2026 11:46:12 +0800
Message-ID: <20260420034612.1899973-1-hsiangkao@linux.alibaba.com>
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

On 32-bit platforms, pgoff_t is 32 bits wide, so left-shifting
large arbitrary pgoff_t values by PAGE_SHIFT performs 32-bit arithmetic
and silently truncates the result for pages beyond the 4 GiB boundary.

Cast the page index to loff_t before shifting to produce a correct
64-bit byte offset.

Fixes: 386292919c25 ("erofs: introduce readmore decompression strategy")
Fixes: 307210c262a2 ("erofs: verify metadata accesses for file-backed mounts")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/data.c  | 2 +-
 fs/erofs/zdata.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 132a27deb2f3..b2c12c5856ac 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -39,7 +39,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 	 * However, the data access range must be verified here in advance.
 	 */
 	if (buf->file) {
-		fpos = index << PAGE_SHIFT;
+		fpos = (loff_t)index << PAGE_SHIFT;
 		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
 		if (err < 0)
 			return ERR_PTR(err);
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 8a0b15511931..43bb5a6a9924 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1872,7 +1872,7 @@ static void z_erofs_pcluster_readmore(struct z_erofs_frontend *f,
 
 		if (cur < PAGE_SIZE)
 			break;
-		cur = (index << PAGE_SHIFT) - 1;
+		cur = ((loff_t)index << PAGE_SHIFT) - 1;
 	}
 }
 
-- 
2.43.5


