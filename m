Return-Path: <linux-erofs+bounces-4483-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667EEC79F9E
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 07:25:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hddrD49m0z2yvX;
	Mon, 07 Sep 2026 17:25:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.28.85
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788765900;
	cv=none; b=Pp6RaAy8CB6Cibr9a/RGVbN5EXfiy0vjtIkVrVFI80ebk7W+/XgX5NRW4YbO9nuyNW95KsGl8o/rfhqDj4NvdegeRUOv0pjQNRVlle1YEHOfK4Am2aEUtcR9rxMjhXJJ2t2qoABQAYZsDa5lwsBABFS8vpVyfwuu7VC3aHKolq7XUkENSXjpZDevndcjGkaMvzaO8lkEz9uIF/aGFLdMCzQBtjBmi449xmf9ZIdZBIRfSQB4zdkY38ZBa70jNjl/8xeEKWcsk03gDesbsn7g4OeiG6t4qtjJ/CXOX8GSZiffKJOb2+/qednH574lkwKWTFJM73BC33/jy72yrepQ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788765900; c=relaxed/relaxed;
	bh=uGESBd6NgO6m1hi91+D09JdfOniAvVzZvjROT6ghQHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vz4Qwb0UBiEeMa75Zqf3k+VKoDvwmAbBPzY6DN6TxR0pOyH+BzerD2wPqB5LtAyIAfXDH+qQjt2u4+MHLekzTneAwzPOR54AkSX5m/FCeTbH51un6Z9NmrrH14unl81kkBtqa6rdjW5fU8gjYEzD5JQWI/EN+yOxVDHegrlQtO/Ts/SnoMVM3qQsUQVEzvi84vX288Jaea218EE+gO3Gby+0Xkg7UruH9mV2StgbTKNUGek/o98TF/wa5QXluk3l7Ilhl7mNIeJP2dbpHn7nEg6pKkxjxKWxg1kwUZwfLgvEYCfZIQv75kLaXvBW/kycqx3o7X0uKs4mu5QXRmvZWw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com; spf=pass (client-ip=115.124.28.85; helo=out28-85.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org) smtp.mailfrom=cyzhu.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cyzhu.com (client-ip=115.124.28.85; helo=out28-85.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org)
Received: from out28-85.mail.aliyun.com (out28-85.mail.aliyun.com [115.124.28.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hddr966VNz2yjw
	for <linux-erofs@lists.ozlabs.org>; Mon, 07 Sep 2026 17:24:52 +1000 (AEST)
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07860313|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00864583-0.000158214-0.991196;FP=15984510238589523610|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037026024;MF=hudson@cyzhu.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.j7UYNlb_1788765882;
Received: from HUDSONZHU-MC1.tencent.com(mailfrom:hudson@cyzhu.com fp:SMTPD_---.j7UYNlb_1788765882 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 15:24:45 +0800
From: ChengyuZhu6 <hudson@cyzhu.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH] erofs: delimit inode_share cache key components
Date: Mon,  7 Sep 2026 15:24:40 +0800
Message-ID: <20260907072440.76001-1-hudson@cyzhu.com>
X-Mailer: git-send-email 2.51.0
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

The selected fingerprint xattr is treated as opaque and accepts any
positive length up to the filesystem block size.  Appending the domain ID
directly to such a value leaves no boundary between the two key components
if a different fingerprint length is used.

Change the key encoding as follows:

  fingerprint || domain_id  ->  domain_id || '\0' || fingerprint

Since a mount option string cannot contain NUL, this makes the in-memory
tuple unambiguous without constraining fingerprint contents or changing
the on-disk format.

Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>
---
 fs/erofs/xattr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index df7ea019526d..17c640aca5f7 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -621,6 +621,7 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
 	struct erofs_xattr_prefix_item *prefix;
 	const char *infix;
+	size_t domainlen;
 	int valuelen, base_index;
 
 	if (!test_opt(&sbi->opt, INODE_SHARE))
@@ -633,17 +634,19 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
 	valuelen = erofs_getxattr(inode, base_index, infix, NULL, 0);
 	if (valuelen <= 0 || valuelen > (1 << sbi->blkszbits))
 		return -EFSCORRUPTED;
-	fp->size = valuelen + (domain_id ? strlen(domain_id) : 0);
+	domain_id = domain_id ?: "";
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


