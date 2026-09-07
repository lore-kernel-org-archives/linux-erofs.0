Return-Path: <linux-erofs+bounces-4487-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F1BDC79F89
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 08:33:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdgML4b6Jz2y2L;
	Mon, 07 Sep 2026 18:33:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.28.84
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788770014;
	cv=none; b=K1c6O80TRs/TApmA9O+e/fqVxihMog/zQgi9X+aWqGpmkP/U4jEjtvr5spGLaiJo8GxGqiOYStpnH7BRSBy19Ta2FpNBU1joGwsGvLERXGFQB3SEnEiv5kCVQW2NC2T9T0u6rEnmNFaTjJ3TTWOKx3H/gq7LMNl0RMasajhE2lRlMl+7vN/ROTMVUXyJcvpMlRfP2MKmjzDcRuR7vw8NiWQPhFb3KUoVPOB69SIblTOVgyy2SEy/v0A+gfG9uR9dnkzpm6E0XfOlb9H2gziOl4ENNnWSiNb+iy2gD1UfjD14V9U0x8RFiw5/Ew6Fo2HP7M5idpssmiOeDfZjckPQ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788770014; c=relaxed/relaxed;
	bh=4MzBhsZUJKpX3sobr0Vpx+s3UjZbd3aZpcySFBSiWK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRmeWkpbV+Pg23m0XAEoOT+NBfZr7H24ojYndXwrmCsXQTZMBiFGKeQAz1gmNfGUwb9M+dgAjjNqeE0gH26L431/WIZRdLJ20bvZlFC5BMw6LWlVH60BpvclxUBXm3ccNgA8A+kW7vzvoefQNrCnZp04jF/al3YpOzqNuqf/rWbp8INLO6Y1YVgj2lzH/r7ZAWkfA7bd9QN7/YOK/H0wCN2PMn2TUi/8Fl39CTn9lkMUXYbiZF2D5FccnayGyxWjT84KqaEGixrWd1RjsB8NJHzVPWHGZr0VCcqcxXo9BXZRhz46kap65SlrAtZH6gQWtzeRkEsm64OW7ibTxuTKoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com; spf=pass (client-ip=115.124.28.84; helo=out28-84.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org) smtp.mailfrom=cyzhu.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cyzhu.com (client-ip=115.124.28.84; helo=out28-84.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org)
Received: from out28-84.mail.aliyun.com (out28-84.mail.aliyun.com [115.124.28.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdgMJ0CKsz2xpv
	for <linux-erofs@lists.ozlabs.org>; Mon, 07 Sep 2026 18:33:29 +1000 (AEST)
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.08613986|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00802565-0.000192517-0.991782;FP=15356258090571404442|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033068016216;MF=hudson@cyzhu.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.j7gsdpt_1788770001;
Received: from HUDSONZHU-MC1.tencent.com(mailfrom:hudson@cyzhu.com fp:SMTPD_---.j7gsdpt_1788770001 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 16:33:22 +0800
From: ChengyuZhu6 <hudson@cyzhu.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH v2] erofs: delimit inode_share cache key components
Date: Mon,  7 Sep 2026 16:33:19 +0800
Message-ID: <20260907083319.69644-1-hudson@cyzhu.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260907072440.76001-1-hudson@cyzhu.com>
References: <20260907072440.76001-1-hudson@cyzhu.com>
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

From: Chengyu Zhu <hudsonzhu@tencent.com>

Previously, inode_share keys were encoded as follows:

  fingerprint || domain_id

It would be better to have a separator between the fingerprint and domain
ID so that the fingerprint won't be parsed as part of a domain ID.

Change the key encoding as follows:

  domain_id || '\0' || fingerprint

Since domain_id is a NUL-terminated string, this makes the in-memory key
indices unambiguous.

Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>
---
Changes since v1:
- Use int for domainlen and drop the redundant NULL domain_id handling.

 fs/erofs/xattr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index df7ea019526d..57cfb7520782 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -620,7 +620,7 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
 {
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
 	struct erofs_xattr_prefix_item *prefix;
+	int domainlen, valuelen, base_index;
 	const char *infix;
-	int valuelen, base_index;
 
 	if (!test_opt(&sbi->opt, INODE_SHARE))
@@ -633,17 +633,18 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
 	valuelen = erofs_getxattr(inode, base_index, infix, NULL, 0);
 	if (valuelen <= 0 || valuelen > (1 << sbi->blkszbits))
 		return -EFSCORRUPTED;
-	fp->size = valuelen + (domain_id ? strlen(domain_id) : 0);
+	domainlen = strlen(domain_id);
+	fp->size = domainlen + 1 + valuelen;
 	fp->opaque = kmalloc(fp->size, GFP_KERNEL);
 	if (!fp->opaque)
 		return -ENOMEM;
+	memcpy(fp->opaque, domain_id, domainlen + 1);
 	if (valuelen != erofs_getxattr(inode, base_index, infix,
-				       fp->opaque, valuelen)) {
+				       fp->opaque + domainlen + 1, valuelen)) {
 		kfree(fp->opaque);
 		fp->opaque = NULL;
 		return -EFSCORRUPTED;
 	}
-	memcpy(fp->opaque + valuelen, domain_id, fp->size - valuelen);
 	return 0;
 }
 #endif
-- 
2.51.0


