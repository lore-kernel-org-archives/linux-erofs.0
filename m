Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33415606A31B
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 03:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=ERHbUVNT
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBTs3DJwz2x9N;
	Wed, 04 Nov 2026 14:57:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=160.236.52.230
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793764641;
	cv=none; b=nmmjalgJNO/9QgCV8UFre8ZkS9yhDOa5AmQ9kLPwjdrOmxVtUx6yi4yB6a7aBEhIERKv6q2PnDX25mr5HByx6R2qhOzSEvwUEEMfrKArplnSn7BQhPR2A8KP9oUqzI5k4c7rZabhgoSUKTlT1CPEf3/G3BntXT9HV9HEnQkWkkepArnD4YUMHO99M8GD5DkGm1ISlXCWiMrCRY0SPh02xyCUDLzhW7FJruO7++u68P1Vae5FntVvR88mYkd2OUqoA808dLR7j/lCDCDwCQVOYVnip6KGXggwExsH0dEAiIfh7rxk+Cddk18/yI+r3QMqcWPkYKfOlFnV/k91BQFx6A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793764641; c=relaxed/relaxed;
	bh=ehEO5CPDGMw23U/GPxLR+38YS6WN9VsDWX9U+RZhS6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iFpP0ZRLWkj1pPMOQsHjIRVv0BaCi0BAGNHZft1gTZkbozcaaZGBrCikc7556OdclLekkEPETuytS8yuj5kECzwzmdOlyS38MMWo/cDbF8dTE8KQueyHtTYpOU4146i9GiAIabqfiirgjElf+3K23pAQXJGnA/iHd34qdNQtw1MyfOWoOMiVS/bCtmgpBPvGDMc3MdLDocNdybNj+PJR8XgboVzwlGQZkUQAj0bDX/KLfj6gUDV+pqnGbnRprWCUPxidL1K9HhaElhF3nzKgP47+TPWAFFTvvSQfvJRsWsjwYVHOhYP9HjGmlhYy2Nvgj9xn9dlTkrqraHkpxEIQjQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=ERHbUVNT; dkim-atps=neutral; spf=pass (client-ip=160.236.52.230; helo=mail-m16023652230.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=ERHbUVNT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=160.236.52.230; helo=mail-m16023652230.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 303 seconds by postgrey-1.37 at boromir; Wed, 04 Nov 2026 14:57:19 AEDT
Received: from mail-m16023652230.xmail.ntesmail.com (mail-m16023652230.xmail.ntesmail.com [160.236.52.230])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBTq5WQLz2x99
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 14:57:18 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.176])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536b6a6ce;
	Wed, 4 Nov 2026 11:52:10 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [PATCH] erofs-utils: fsck: extract zero-length xattr values
Date: Wed,  4 Nov 2026 03:52:08 +0000
Message-ID: <20261104035208.2471090-1-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
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
X-HM-Tid: 0aa1a4af8b1f03a3kunm827297e37ba36
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHkpLVhgdHRlOTx1CGBofSlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTE1ZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=ERHbUVNTADl0fSdxuAVvXA8qd1MrQFWxxvBFgcxuzPwOHzOdY4IjvyBKIFNsKWrXJuOEfnxkvjvn68Lsz6N+t2DrurejRpBbXo2uCT149JofzSAUfkBu/zagY2qn56eT2Tmw7xd/Z/8VBTzPKHySDK1dKZB2YPIg0+xalGm58tw=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=ehEO5CPDGMw23U/GPxLR+38YS6WN9VsDWX9U+RZhS6U=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A zero return value from erofs_getxattr() denotes an empty attribute,
but the extraction path treats it as an error.

Accept zero-length values and allocate at least one byte for the value
buffer, avoiding dependence on malloc(0) behavior.

Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 fsck/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index e54c523..9db5ae9 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -458,14 +458,15 @@ static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
 		size_t size = 0;
 
 		ret = erofs_getxattr(inode, key, NULL, 0);
-		if (ret <= 0) {
+		if (ret < 0) {
 			DBG_BUGON(1);
 			erofs_err("failed to get xattr value size of `%s` @ nid %llu",
 				  key, inode->nid | 0ULL);
 			break;
 		}
 		size = ret;
-		value = malloc(size);
+		/* Empty xattrs are valid */
+		value = malloc(size ? size : 1);
 		if (!value) {
 			ret = -ENOMEM;
 			break;
-- 
2.43.0


