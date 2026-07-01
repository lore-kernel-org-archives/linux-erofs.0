Return-Path: <linux-erofs+bounces-3796-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2707DC43458
	for <linux-erofs@archiver.kernel.org>; Wed,  1 Jul 2026 08:52:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gqv0m5lShz2xwM;
	Wed, 01 Jul 2026 18:52:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782895960;
	cv=none; b=LwKNkpINflM+OVY8iCGPVoaH3R3SryUjEX4XC54TSLNRHfwwsdyX9fg1XJXXv0rfg0WUqnphVbsssv+Y2HrvkhH2aN4U23eHtKRQhnCZH9vvIVymzJIH4x6hCyJgHELSiZl/LyGAp1nVwg9S9hzL3Xmvd+aqzNg8FfRo79Qkk8xIjf1tuONA4n9RuyomvYF6dbsI1WOG/IEVdt2DCHTzFTDt9NZvGmcLV1LRXH2S4yNMwZs/uo2dA6Eo48fzIfe0cA1E3MTuzsQPoZ+PEw2j1vEfCOFUd79DVM/XMwNeuyn6GRhxLOohvDW7c/+3gsyZbkhNUwjlCY+fa3FXTa2Fgg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782895960; c=relaxed/relaxed;
	bh=/EMA7D9lq6e/2CXNyjM/RTApov9kVqZUZumoMvXXyjY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vx3V4WVk33QVk/UJ5Bm0ZEj572Qdg4lmnLPLN+JlrijS/s6Dzmp5kF3+OQvid1NS5CpB/p64l1URUXCcJGh2OThTEMH1vP3r8TjhVJzCmiQjqgfqqx3Xugln4Lg2dceSYd9cDT5UQ6WopynRVIlefASCwr2cFwvXqaZdNL04i7ajNjDg/jmbMmFh+t7vg8+52SQSpS3aIf/ceaALv2OkWOXacnNS89bYcSAZ32SRJyzOxKsBH6xSc6JN63Z5gWQbvW0c8MpJjy8XFeOqDCCrhAq0sO8yyKQyLPrzOHgVqSjLLB09o2oFnz9DWRjavS9iiXzUtrkfz1xUHszx7qf+DQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Bc4JHVRu; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Bc4JHVRu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gqv0k3z7mz2xPb
	for <linux-erofs@lists.ozlabs.org>; Wed, 01 Jul 2026 18:52:37 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782895953; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/EMA7D9lq6e/2CXNyjM/RTApov9kVqZUZumoMvXXyjY=;
	b=Bc4JHVRuqt7lN7oyGz1cBGGSY+1MTKO5E9cranvITxvrgc85+VUpe700bc1HVBxjSTisi3hGqr3ZJ7hMwaEMgHq0t3XfYJAfhF8x4ys4ol9eKwcM6+CBKEXgVBz4fbKRFWitp4z4LigJz72XkAOpnxSwm1d6GrLXdNmX+glOEMc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X66AdQO_1782895948;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X66AdQO_1782895948 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Jul 2026 16:52:31 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: mkfs: set the default inode fingerprint name
Date: Wed,  1 Jul 2026 16:52:26 +0800
Message-ID: <20260701085226.2390667-1-hsiangkao@linux.alibaba.com>
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

Set `erofs.fingerprint.v1` as the default xattr digest name for
inodes so that these xattrs are invisible to users.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 mkfs/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 4fadb56c7a5c..33c410d71411 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -34,6 +34,8 @@
 #include "../lib/liberofs_s3.h"
 #include "../lib/liberofs_uuid.h"
 
+#define EROFS_EA_INODE_DIGEST_DEFAULT "erofs.fingerprint.v1"
+
 static struct option long_options[] = {
 	{"version", no_argument, 0, 'V'},
 	{"help", no_argument, 0, 'h'},
@@ -102,7 +104,7 @@ static struct option long_options[] = {
 	{"zD", optional_argument, NULL, 536},
 	{"MZ", optional_argument, NULL, 537},
 	{"xattr-prefix", required_argument, NULL, 538},
-	{"xattr-inode-digest", required_argument, NULL, 539},
+	{"xattr-inode-digest", optional_argument, NULL, 539},
 	{0, 0, 0, 0},
 };
 
@@ -256,7 +258,7 @@ static void usage(int argc, char **argv)
 #ifdef EROFS_MT_ENABLED
 		" --workers=#            set the number of worker threads to # (default: %u)\n"
 #endif
-		" --xattr-inode-digest=X specify extended attribute name X to record inode digests\n"
+		" --xattr-inode-digest=X specify extended attribute name X (\"" EROFS_EA_INODE_DIGEST_DEFAULT "\" if omitted) to record inode digests\n"
 		" --xattr-prefix=X       X=extra xattr name prefix\n"
 		" --zfeature-bits=#      toggle filesystem compression features according to given bits #\n"
 #ifdef WITH_ANDROID
@@ -1483,6 +1485,8 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			cfg.c_extra_ea_name_prefixes = true;
 			break;
 		case 539:
+			if (!optarg)
+				optarg = EROFS_EA_INODE_DIGEST_DEFAULT;
 			err = erofs_xattr_set_ishare_prefix(&g_sbi, optarg);
 			if (err < 0) {
 				erofs_err("failed to parse ishare name: %s",
-- 
2.43.5


