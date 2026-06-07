Return-Path: <linux-erofs+bounces-3522-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE0ECD8C89
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Jun 2026 17:21:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gYMRG4rwqz2xlV;
	Mon, 08 Jun 2026 03:21:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780852906;
	cv=none; b=Jhp0YB9t66qcVJF0buZXutjEWL0lzu4fBpTcvjQuR6usJ5HSsJ9OBu2Wd9YOzoHNAd/Ei1vLl1bV7B/amCXSDW/6cXlD4qu1sZB2VzIEbG83h5RD9lX9Lk+FjPvKRARqdAqlkQY+EnXhi8bIEAt0esvxgByPLv4hJ5k/fUcRZur3C0AmJHN7hHsD8rGMZQXuL4pAy0CgUubWYIRfMeVwkY/vQdOTDURQzbrY9VXluwtggg8xrqA3jo722z+vKVtG6W8j1gITkSV9jtYRpMyYu4rp/I8oCE7TXYTIfe8LuCSLjlQsiYCnHgWWZUEOCxR6i+rl0iBMteeakl6wYet7xg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780852906; c=relaxed/relaxed;
	bh=qhImzRXmhei5Lr7a0pQpo3qVbnwWVnRGJ4t5QvDiQqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GH7fJbp1vvdKT407RYEd3uNx7UlfdZmr6HQcB5HQNg2KBkTso9XIXY/WW+tIRDKh2YAoLeSQdowOSBuRpXd0X0GzXVarWqB1SrOOsmri2HJ3n7xYg0vgDi+wcd+ka5F1U5CsiEv4RerYopOcAaDNhEBeM4qlFpc8YStD9p39SSRIWe2wyb7C2GybGzt9bxR8bbLcbegDUlreDp48OZLxMPZANOkRLXDG8QaOW9H5BoRb0fX3n+hIwbztRVeocQFIKlOYi3/ICMamp9oU8DUssP17AhEi1ndnIfFqZVCnu5fYogHnwxsMDIN7ZUloyl5Jflk2hLhi3RfCWC4a2VOPmw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Iq+gCMrU; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Iq+gCMrU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gYMRD70Z3z2xl0
	for <linux-erofs@lists.ozlabs.org>; Mon, 08 Jun 2026 03:21:42 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780852899; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qhImzRXmhei5Lr7a0pQpo3qVbnwWVnRGJ4t5QvDiQqk=;
	b=Iq+gCMrU98YcHeR3AGGwhigVkptxbLbT7NUgMkz7vbl9j4VyAVOeDSf2RpTPmDWceRbJEv84ugJSNHdkC0pg7Kcl+K84PCq7G8eD99NJBivPtTeLyDokds0ZIKIUqaymtkzEgpK/IECslW4r9M35GBbtVDSwwrBcpW1l9yLkKTI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X4IBbZn_1780852893;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4IBbZn_1780852893 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 01:21:37 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [PATCH] erofs: clean up erofs_ishare_fill_inode()
Date: Mon,  8 Jun 2026 01:21:32 +0800
Message-ID: <20260607172132.2695176-1-hsiangkao@linux.alibaba.com>
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

 - Use the shorthand `si` to replace the overly long `sharedinode`;

 - Introduce erofs_warn() and get rid of barely-used _erofs_printk();

 - Get rid of the variable `hash`;

 - Simplify error paths.

Cc: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/internal.h |  2 ++
 fs/erofs/ishare.c   | 45 +++++++++++++++++++--------------------------
 2 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 4792490161ec..9e2ae7b61977 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -23,6 +23,8 @@
 __printf(2, 3) void _erofs_printk(struct super_block *sb, const char *fmt, ...);
 #define erofs_err(sb, fmt, ...)	\
 	_erofs_printk(sb, KERN_ERR fmt "\n", ##__VA_ARGS__)
+#define erofs_warn(sb, fmt, ...) \
+	_erofs_printk(sb, KERN_WARNING fmt "\n", ##__VA_ARGS__)
 #define erofs_info(sb, fmt, ...) \
 	_erofs_printk(sb, KERN_INFO fmt "\n", ##__VA_ARGS__)
 
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 6ed66b17359b..35cbd0bc04d7 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -40,49 +40,42 @@ static int erofs_ishare_iget5_set(struct inode *inode, void *data)
 bool erofs_ishare_fill_inode(struct inode *inode)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
-	struct erofs_inode *vi = EROFS_I(inode);
 	const struct address_space_operations *aops;
+	struct erofs_inode *vi = EROFS_I(inode);
 	struct erofs_inode_fingerprint fp;
-	struct inode *sharedinode;
-	unsigned long hash;
+	struct inode *si;
 
 	aops = erofs_get_aops(inode, true);
 	if (IS_ERR(aops))
 		return false;
 	if (erofs_xattr_fill_inode_fingerprint(&fp, inode, sbi->domain_id))
 		return false;
-	hash = xxh32(fp.opaque, fp.size, 0);
-	sharedinode = iget5_locked(erofs_ishare_mnt->mnt_sb, hash,
-				   erofs_ishare_iget5_eq, erofs_ishare_iget5_set,
-				   &fp);
-	if (!sharedinode) {
-		kfree(fp.opaque);
-		return false;
-	}
 
-	if (inode_state_read_once(sharedinode) & I_NEW) {
-		sharedinode->i_mapping->a_ops = aops;
-		sharedinode->i_size = vi->vfs_inode.i_size;
-		unlock_new_inode(sharedinode);
+	si = iget5_locked(erofs_ishare_mnt->mnt_sb,
+			  xxh32(fp.opaque, fp.size, 0),
+			  erofs_ishare_iget5_eq, erofs_ishare_iget5_set, &fp);
+	if (si && (inode_state_read_once(si) & I_NEW)) {
+		si->i_mapping->a_ops = aops;
+		si->i_size = inode->i_size;
+		unlock_new_inode(si);
 	} else {
 		kfree(fp.opaque);
-		if (aops != sharedinode->i_mapping->a_ops) {
-			iput(sharedinode);
+		if (!si || aops != si->i_mapping->a_ops) {
+			iput(si);
 			return false;
 		}
-		if (sharedinode->i_size != vi->vfs_inode.i_size) {
-			_erofs_printk(inode->i_sb, KERN_WARNING
-				"size(%lld:%lld) not matches for the same fingerprint\n",
-				vi->vfs_inode.i_size, sharedinode->i_size);
-			iput(sharedinode);
+		if (si->i_size != inode->i_size) {
+			erofs_warn(inode->i_sb, "i_size mismatch (%lld != %lld) for the same fingerprint",
+				   inode->i_size, si->i_size);
+			iput(si);
 			return false;
 		}
 	}
-	vi->sharedinode = sharedinode;
+	vi->sharedinode = si;
 	INIT_LIST_HEAD(&vi->ishare_list);
-	spin_lock(&EROFS_I(sharedinode)->ishare_lock);
-	list_add(&vi->ishare_list, &EROFS_I(sharedinode)->ishare_list);
-	spin_unlock(&EROFS_I(sharedinode)->ishare_lock);
+	spin_lock(&EROFS_I(si)->ishare_lock);
+	list_add(&vi->ishare_list, &EROFS_I(si)->ishare_list);
+	spin_unlock(&EROFS_I(si)->ishare_lock);
 	return true;
 }
 
-- 
2.43.5


