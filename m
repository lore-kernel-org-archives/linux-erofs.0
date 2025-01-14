Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DAD8E77188
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jan 2025 04:01:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YXFmT5sFhz30Kg
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jan 2025 15:01:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1736827272;
	cv=none; b=l6PIZbeLcXQQPlUS1DkOIeNrFSNMHwP47CVgRv5q2Z4NCo6yBmztSIGGQmz0fD0AYJM5oaprverC1WBfKxipLgmwMfeXY5k7CJD9RExIvBI7sEQ2UoLBxU2jxFp6ZYk0qwwjQ1aPP1l3phlf8aAgIcBsa0etdttiINMdgYwx3aJCB1ILucRKkTuVwxJA00dpMq/lW/k05jiTiN1iTfwLwlQj1V4gw87Wr9rSvIoYr7A9D7W/dMItKD6OaV5dZdFUTPR5cVpxA7Je/Vijc9mDYXfKgEwPVXfFuIOQqILeZLrxmtdg9MCaE2aVHnS7YigbRjOOMocv7CgdDR896ep9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1736827272; c=relaxed/relaxed;
	bh=bX6y3x4nFZgjceOhg17WaZOQnJzQdWpX26Z6BWbAHNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X98vYyWLHcXeiqGQB4RXMjDFs8hyt94eF0MQTFllnZaVENXbWA/1iQ8nziYhZHpIJotfGPfI6cnS+hziuvT1OwUulhz17cJe0oYvBswVdklacyziXgReSOUv9SQ6KQYcc9rSBRq5eBfFid0Qzahly//ojD4l2l3wiDr0wxXAh6rrAL6uCcAcrDHq/iufynZR8N+AUHiWib9ucBJW4dLPlBkTm+Kfp7L2e9TF0RdQW9n+nuGMWjLebiGA/qfbiAEqGJL+eiC4HdrCkSIPYyxnQxoCvOSIC5jOUVmg4gJba3W271GldIdGpvpq8DqGmNxGo2a9SZEcni59OaKrRGHdag==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=b69j4B6Z; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=b69j4B6Z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YXFmP6JdPz3005
	for <linux-erofs@lists.ozlabs.org>; Tue, 14 Jan 2025 15:01:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736827264; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=bX6y3x4nFZgjceOhg17WaZOQnJzQdWpX26Z6BWbAHNg=;
	b=b69j4B6ZLTWg2SHL6io9C9e2ypEoJis9cjT9o9j51GBNXsiNn9FaxPtmCe8L8QYvo1THEfgS86Xmhd5AX0e3A+xt3EGO/tlWXZwjueEZ3pN2abOM+ImNWx5QFXpdiab/vqWMbgQ6/GHFcIu3nRotqUb0X2LigNSM/0VeFZv/noA=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WNdqtDg_1736827258 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jan 2025 12:01:03 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: fix potential return value overflow of z_erofs_shrink_scan()
Date: Tue, 14 Jan 2025 12:00:58 +0800
Message-ID: <20250114040058.459981-1-hsiangkao@linux.alibaba.com>
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

z_erofs_shrink_scan() could return small numbers due to the mistyped
`freed`.

Although I don't think it has any visible impact.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zdata.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 8bafc4d9edbe..057d68eaa5d2 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -915,8 +915,7 @@ unsigned long z_erofs_shrink_scan(struct erofs_sb_info *sbi,
 				  unsigned long nr_shrink)
 {
 	struct z_erofs_pcluster *pcl;
-	unsigned int freed = 0;
-	unsigned long index;
+	unsigned long index, freed = 0;
 
 	xa_lock(&sbi->managed_pslots);
 	xa_for_each(&sbi->managed_pslots, index, pcl) {
-- 
2.43.5

