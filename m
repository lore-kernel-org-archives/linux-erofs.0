Return-Path: <linux-erofs+bounces-2256-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FB1E6E815
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Feb 2026 06:30:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f5VpG6qmYz2xHt;
	Wed, 04 Feb 2026 17:30:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770186614;
	cv=none; b=jrBjL/h64c+aHcgYHfJTVoBMs1Wei7yY8Hk1qZHpmnnil/a9CbyX+r+B7dgS+s+VWeV9YYO0n4y4aHnTKbsnxekvbFJ5/0FlJO7uWWJa5ax7EX15FuH68bnbCRa4cVOtAerwyB0r6zOetttANFLr8TVYGQDUY9IueKna/az+Gg4m7P/XRx0/15i+KNpbK03K4cEOkOi9nsdXFSo+om3BY+5/OzSW/+6d601P23ZtOAHIfGaeZW0qAy4xSLRfdUptY767CT5Y10/9YzD5S0d1ODAM67gPHD/pcsZtvFb7szPL2xxw3Ds8bWve8gQFeItPJtCaICQgYN9Uv1gKo3whCg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770186614; c=relaxed/relaxed;
	bh=u+VEHwJhYQVh4xmStloZYm3eNm0jt4lgYnvgLH1s9U0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X96JC+75XAIZ/GoPJ0mSUWWgT+Jq06AtxkCVDdAMQ1MpzBdscSzR1uUfUuJSLJQGfPL5l2eAsDFnCLnIbNFqLSAefLyhgoujIZOuvzHTXJTbKqTxcyc5WOdxpg1NoI3ti88PMTUFUjm/Gt0Za0eM2lAT1RLqVr5kMUIGouxxlXzfyp9sWEXgpZyiVEM5fmas/PzDhBcNWq9p5YeK6LtkTZeAcroQVXWzRSnquGI1ToIF9GKBjFK50nvrdONah8hKz1wpwsJu9HoR8yWG4zUPS1H1iStKMH4Ml99a6xS7pEaFu45DmRIJHbudTxPHnKTN5aDR5bHHvhhZy+zpSSY8lQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OnnYQCQ/; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OnnYQCQ/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f5VpB5kmyz2xBV
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Feb 2026 17:30:08 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770186599; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=u+VEHwJhYQVh4xmStloZYm3eNm0jt4lgYnvgLH1s9U0=;
	b=OnnYQCQ/kSpFmlCIPOVFMQmkk6hF9HE1APbm1/khDrhBIRtBC2QH2ShqYuESgaulnsIlgGY6p2mC+xRF4Jih/XgIMILguKSkW4lHiO8JB4GDACeqbN5Rtd8uk0Vn5QjqH/OhmNi7lpKn2/C0mUXCGC4jW9IyAa0HbIXRky4M5EA=
Received: from localhost.localdomain(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WyVl5QG_1770186593 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Feb 2026 14:29:57 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Daniel Colascione <dancol@dancol.org>
Subject: [PATCH] erofs-utils: mkfs: avoid hanging if fragment is on and tmpdir is full
Date: Wed,  4 Feb 2026 14:29:48 +0800
Message-ID: <20260204062948.12525-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
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

The main thread should respond to errors from the child process
instead of waiting indefinitely.

Reported-by: Daniel Colascione <dancol@dancol.org>
Closes: https://github.com/erofs/erofs-utils/issues/34
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compress.c | 14 +++++++++++---
 lib/inode.c    |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index 58d1f4d..222e380 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1338,8 +1338,11 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 
 	if (inode->fragment_size) {
 		ret = erofs_fragment_commit(inode, ictx->tofh);
-		if (ret)
+		if (ret) {
+			erofs_err("failed to commit fragment for %s: %s",
+				  inode->i_srcpath, erofs_strerror(ret));
 			goto err_free_idata;
+		}
 		inode->z_advise |= Z_EROFS_ADVISE_FRAGMENT_PCLUSTER;
 		erofs_sb_set_fragments(sbi);
 	}
@@ -1822,8 +1825,13 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 	if (!z_erofs_mt_enabled || all_fragments) {
 #ifdef EROFS_MT_ENABLED
 		pthread_mutex_lock(&g_ictx.mutex);
-		if (g_ictx.seg_num)
+		while (g_ictx.seg_num) {
+			if (g_ictx.seg_num == INT_MAX) {
+				pthread_mutex_unlock(&g_ictx.mutex);
+				return ERR_PTR(-ECHILD);
+			}
 			pthread_cond_wait(&g_ictx.cond, &g_ictx.mutex);
+		}
 		g_ictx.seg_num = 1;
 		pthread_mutex_unlock(&g_ictx.mutex);
 #endif
@@ -1974,7 +1982,7 @@ err_free_idata:
 out:
 #ifdef EROFS_MT_ENABLED
 	pthread_mutex_lock(&ictx->mutex);
-	ictx->seg_num = 0;
+	ictx->seg_num = ret < 0 ? INT_MAX : 0;
 	pthread_cond_signal(&ictx->cond);
 	pthread_mutex_unlock(&ictx->mutex);
 #endif
diff --git a/lib/inode.c b/lib/inode.c
index 7d20fbd..79e5d3b 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -786,6 +786,7 @@ int erofs_iflush(struct erofs_inode *inode)
 	bool nlink_1 = true;
 	int ret, fmt;
 
+	DBG_BUGON(inode->nid == EROFS_NID_UNALLOCATED);
 	DBG_BUGON(bh && erofs_btell(bh, false) != off);
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
 	    S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
-- 
2.43.0


