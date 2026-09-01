Return-Path: <linux-erofs+bounces-4400-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2753C61DD6
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Sep 2026 06:23:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYwlR0LD4z2y2P;
	Tue, 01 Sep 2026 16:22:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788243778;
	cv=none; b=jemRSCY6/eb1MvEwUukztvZvuC6G30C8blgxq1qy+ZwWFcf0mD8T+63Kb3NLhuF29EAnm47njyLPj+r5Sac5fyLDUFOjoPEdWm4gjlE4gzhUW86CFgOzA+9yDpKzzBa84T0bH8xTtmhUAW+/phwMEURZOyrxdKYN5bwG+feeOQvpxRQnBcCPeky9ZSguJ9HuXBdbS3ufCnXk6AvnNuTQ5dRF3AmkCdba6JOLAgSFFoP6zCfCG8V0bwLzD/+wK0PePTn0ztF62okusxl0Nk/mMz0fWL7EACqapKhi5BFGtfXBq7n8MR2bRnVxsif0eGAh5jry5+flu4xYDEDLoMEzRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788243778; c=relaxed/relaxed;
	bh=45ozspufcHZUV7IFzNQg9IRvWuMvisXbo+FeNLjLT5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B4J0mT2/esLTYPU7xqs5HxEybiGVJnjU4YvdQ1qdGX9ow1kL5CoIVKj0DruD7mzA/KnXwM1yyeGOOwoErjqxWGSwUw0GxK1zSw6yzUsktnGOy7bdETrOYafVWOZLvJjlfRaPbv8/tV9sWz3Qc4Rphxe0TDSCqUcBkozUcz0OlRBSnr4AYB7Hm/dzVEWLFm+zylHOH3gt+AHyezcEhELv+zuweTs4lBKxuAlBYRP+HcdYYHbBtxvzriDNSd41Zl243PlcLNgE1Kts7NqLmYerb3rqLcTvA0KPiD4dgsNesYUNOjEG4l1O7+DZZBlwZfR8PmA+eW1fRmkiw0HfSqMxIQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QvFd0P1w; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QvFd0P1w;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYwlN5RSjz2y2B
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 16:22:55 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788243767; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=45ozspufcHZUV7IFzNQg9IRvWuMvisXbo+FeNLjLT5g=;
	b=QvFd0P1wGhKMSZQ9bVExPxDLDoNh/VjVqtx2PcygGtjDGbYXwZQljOSPmOrQP1lN5+cca1HBt9i7RKXy6HCcHSwRhwrKnbVcuYMNMp8eLpvQPhyaYcC3I5p8qLhIy7BHj2ePNWu8a0MzLZxneAeNe1S6NwPcEDx9+BxuPSgP3sI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0XA3vWPg_1788243763;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0XA3vWPg_1788243763 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 14:22:44 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] erofs: add sysfs feature entry for xattr prefixes
Date: Tue,  1 Sep 2026 14:22:43 +0800
Message-Id: <20260901062243.109172-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.

Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
Cc: <stable@vger.kernel.org> # 6.4+
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
changes since v1:
- add Fixes tag and versioned Cc-stable tag
---
 fs/erofs/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/sysfs.c b/fs/erofs/sysfs.c
index 6734483a440f..dfcec9376cd5 100644
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -95,6 +95,7 @@ EROFS_ATTR_FEATURE(sb_chksum);
 EROFS_ATTR_FEATURE(ztailpacking);
 EROFS_ATTR_FEATURE(fragments);
 EROFS_ATTR_FEATURE(dedupe);
+EROFS_ATTR_FEATURE(xattr_prefixes);
 EROFS_ATTR_FEATURE(48bit);
 EROFS_ATTR_FEATURE(metabox);
 
@@ -108,6 +109,7 @@ static struct attribute *erofs_feat_attrs[] = {
 	ATTR_LIST(ztailpacking),
 	ATTR_LIST(fragments),
 	ATTR_LIST(dedupe),
+	ATTR_LIST(xattr_prefixes),
 	ATTR_LIST(48bit),
 	ATTR_LIST(metabox),
 	NULL,
-- 
2.19.1.6.gb485710b


