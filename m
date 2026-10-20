Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDEE606A319
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Oct 2026 05:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Sn5dGr5k
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j81ll4vnXz2ynZ;
	Tue, 20 Oct 2026 16:52:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792475555;
	cv=none; b=Io1f6QwADgc9QWI2GcxNtj828JCMH0605uJAFYooXrF5efoMhV+m50A3jWLrPEb6Ns7yIwvdi9VGrOGBuqR4jtIjPi7lmnqIasEXsRohEtYWr51tXssvBCjBAGGDYODI31p44mPgO+UL9BP6DSKnphyE/gcQAdWJV+52368EYNfzsLfRXUVGyWLoe81YAppJoQ/wDGtMeDJ62f9lGvPRLNmgIixdv9taMdy1YX5xjlWz6NObjsTkihW6WQ4WPZgFzaAN9A4g4Xi/Tp6GGgeD6bOFyouzoAD0PE8nNnpJIDOS+s2Dl3fvbRCSrrwL93vOSVTFRia7my0QJik5rDSZAA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792475555; c=relaxed/relaxed;
	bh=gsrQlLZ/qb9paxVzgIXlLbHzYGK23sCnwKy0Lm/aPwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JMMe9GV+BeB1ogH101R9oYPUt/t3uaQVZSVglelbf9DJvDZGeEwYHryQTkkocFpPrawtKM/nyq+wvP+tuyGPwXrFpkK74CjI+aOqhGz51XuIU0X7va/QUAiST0hyTtK48XqpsUActZzz7wTBGmL5SeobFrZEq5L+SQGzMiiNtWoPBExHWjxNQRQGuHD8mdF+/0rXwpG2i5xxM3rLfonjfNSurvWLXfBT2GBbAhIigVup2aXmfFKRZaR2K7sSK8B/RhHlJspGwr+9rt48bPEhHC+Czu+bKSQPBKACMIYcQtUseOn/XVNyASrKjZeFA8ybrvgLp93CAoOF8YXhmdmQYg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Sn5dGr5k; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Sn5dGr5k;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j81lj0qbHz2y7M
	for <linux-erofs@lists.ozlabs.org>; Tue, 20 Oct 2026 16:52:30 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792475542; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=gsrQlLZ/qb9paxVzgIXlLbHzYGK23sCnwKy0Lm/aPwc=;
	b=Sn5dGr5kOrDp8KnwJYnbEyroot5lsv1KnHvhTBG2GyWnslAppzHsYBKWDFPilLCodjf96S2SM4QiOQQALxp7ntx8mxbu+xSnWcBAzoOKWbKM/YIQQZG0d7iAxmpL3oC0I0vu0rGiQs92DZFH4qsv7/53FmSaLkEXUkqNGOi/cqQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=lanbingying.lby@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XDBiEy1_1792475540;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:lanbingying.lby@linux.alibaba.com fp:SMTPD_---0XDBiEy1_1792475540 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 13:52:21 +0800
From: bingying lan <lanbingying.lby@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	chao@kernel.org,
	bingying lan <lanbingying.lby@linux.alibaba.com>
Subject: [PATCH] erofs-utils: lib: fix xattr prefix offset truncation
Date: Tue, 20 Oct 2026 13:52:18 +0800
Message-ID: <20261020055218.2953541-1-lanbingying.lby@linux.alibaba.com>
X-Mailer: git-send-email 2.53.0.apsara
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xattr_prefix_start stores the long xattr prefix table offset in 4-byte
units.  Casting the byte offset to u32 before shifting discards its
upper bits, even though the overflow check accepts offsets whose
shifted value fits in u32.  The table is written at the full offset,
but the superblock points to the truncated location.

Shift the offset before narrowing it to u32.  This prevents corrupted
images when incremental builds place the prefix table at or beyond
4 GiB.

Fixes: b6b741d8daaf ("erofs-utils: lib: get rid of tmpfile()")
Signed-off-by: bingying lan <lanbingying.lby@linux.alibaba.com>
---
 lib/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/xattr.c b/lib/xattr.c
index d86d94a..e742bfc 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -921,7 +921,7 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 		return -EOVERFLOW;
 	start = offset;
 
-	sbi->xattr_prefix_start = (u32)offset >> 2;
+	sbi->xattr_prefix_start = (u32)(offset >> 2);
 	sbi->xattr_prefix_count = ea_prefix_count;
 
 	list_for_each_entry(tnode, &ea_name_prefixes, list) {
-- 
2.53.0.apsara


