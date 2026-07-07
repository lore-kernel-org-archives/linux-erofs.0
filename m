Return-Path: <linux-erofs+bounces-3854-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D68C43458
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Jul 2026 13:22:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gvhht1dMqz2xWY;
	Tue, 07 Jul 2026 23:22:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783430526;
	cv=none; b=nh2fUFlPPybVQ1pz0Um63ALB6OjKpzmxXYiISoPIFfjEbcT8m2Ii1z3MlosZHJtRpNtqtEgMbxzAIptyNDNwsiqm1Q2BAB6SIhz3jHFaoQVxwpsuDVo7WKxiedExxTfYsCvzP8gqc89OzDC5VjqDg3iO+HxJ3e523LVsGHtJ0BKhf5di9S72qZ1qrWN82T6cvPuR9B0aIaFkmibUYMbfzDhcpht1yvNrs5I7vZbwL7UBDCSMCmnW3ZUPTCOA9AkH8L4nZIeifHtaa1VhFaV/OJjpP1AxgjpPpOR543KreiBgK272zhGlIBHekL45kGy9QH0jTViBbm9RGTN1+nqo0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783430526; c=relaxed/relaxed;
	bh=a5hsotvxZtzR80XULwNX5K5SDey/8iDcL/FmljrpJ4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cp8nEX0W3DK4ux3UXRmnNxdu8ZV2XNzdi2JGLuNr4cAf9qdkoRn3GrpL/yF6Uz1Mza1vHA15reinCnlknKP5t94F2GCJFJ3aDzTBMQ7lh1aeCclvosbbehlRU2ER0arACNcZiHXhIa7/t/IEQXm/bdCOGWihlwdnXPa8nhP3oWgLyVjHmy5EFXfmepN+LlqusQKdf7GCQiHcexQBvB6vL+SWwSIxSkC61kH3Y3QFJsAD49gkIzGnqX2dwclIp4tRWquxOiSQj5lJ0lt82i8Teu09VmaQnZNKsEilhA+QS7yvEY6hE7F1J5OQKsZdYbCaw0TkfUdsMAme9nF/psiigg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OiwVnYFc; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OiwVnYFc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gvhhq59Q1z2xF8
	for <linux-erofs@lists.ozlabs.org>; Tue, 07 Jul 2026 23:22:02 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783430518; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=a5hsotvxZtzR80XULwNX5K5SDey/8iDcL/FmljrpJ4s=;
	b=OiwVnYFcbKDGdZs2pS1bMMO1eVEgbLrmWpDB+zPVf+P8yW/n06QfsVXvt1Sv3c9hMJ0W5rvH2Xs8XUjZtGVcCbo9AH7u7WfDYsmQa/KYAlNIxPkUBcNtylMI6p6zw0H93ZzpkMV9BpoWiMaf4TRfMbeEB55lJ0JQD4odptjNeGU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X6dnFPA_1783430512;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X6dnFPA_1783430512 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jul 2026 21:21:56 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Alberto Salvia Novella <es20490446e@gmail.com>
Subject: [PATCH] erofs: relax sanity check for tail pclusters on ztailpacking images
Date: Tue,  7 Jul 2026 21:21:52 +0800
Message-ID: <20260707132152.1176967-1-hsiangkao@linux.alibaba.com>
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

If the tail data can be inlined into the inode meta block, it should
be converted into a regular tail pcluster.

In principle, it should be converted into an uncompressed pcluster if
there is not enough gain to use compression (map->m_llen < map->m_plen);
but since there are various shipped images, relax the condition for
ztailpacking tail pclusters instead of reporting corruption incorrectly.

Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
Reported-by: Alberto Salvia Novella <es20490446e@gmail.com>
Closes: https://github.com/erofs/erofs-utils/issues/51
Fixes: a5242d37c83a ("erofs: error out obviously illegal extents in advance")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index bab521613552..f6b0172a6acc 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -732,7 +732,9 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 				  map->m_algorithmformat, EROFS_I(inode)->nid);
 			return -EFSCORRUPTED;
 		}
-		if (EROFS_MAP_FULL(map->m_flags) && map->m_llen < map->m_plen) {
+		if (EROFS_MAP_FULL(map->m_flags) && map->m_llen < map->m_plen &&
+		    (map->m_la + map->m_llen < inode->i_size ||
+		     !erofs_sb_has_ztailpacking(sbi))) {
 			erofs_err(inode->i_sb, "too much compressed data @ la %llu of nid %llu",
 				  map->m_la, EROFS_I(inode)->nid);
 			return -EFSCORRUPTED;
-- 
2.43.5


