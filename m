Return-Path: <linux-erofs+bounces-2320-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6195CEF99F3
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Feb 2026 03:16:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fCZ2067P5z2xln;
	Sat, 14 Feb 2026 14:16:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771038984;
	cv=none; b=f5YfT1Yd+EeCfy5nafpRNoLdimLb/bGgIsb+EynLZ3t8laOHihyjD3b69h1/pcXJ2xZ16UX3JSWeg4JwBRDUK/iRibbAqbr7iNwOcwbscZOiUwJNawYRonlcrFUtiT+cl531qN8Xa2knFZO+9kLRTZqCZZgamCwbFZKe3AyRvr6c0Pj4qny914CjSyU2AC4qTa0S3st4ZPB2Ii0glp/pzg3CuZ0mbpRgc/HN7KE3UrNgllPuGfaEi29XnnlzIzfeEXCFKe0N58leVLVMFhyj1/KiY829aRVGlOdVYPX5WsEQ/Hl3wFfrSF6s3wsiljSMZS7rH49DMGRZIl7QJbFsyw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771038984; c=relaxed/relaxed;
	bh=gjMYksSLtua+20VlDHzcEo9SU2/7R4sPYXB+S/4B0fI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k68UaD7OvumRVfYHqAl3uINV3JKQLnxnUsoo9lY1KX9+49T4OqXAOAsh/8d/AMnZ/U+VrEZDqNPPBk5HAuQZY3XHOonoXGaveGt9i2yKel5X069A8xUWxsfrtGil9GMMC0CmBMce8xqbSQI6lS0EZZ2MTJxLv/OY2xzmPmd+kbCFqRdOwcJmB8vGkEDybLM4wnW7U4ClvBiHy9geGjL6dnGZ/NntsDoGNyYyyjtDqaFcewUxi08tXzXYoSZd2WrMzUGUae0lBWaVeBNJ2YNVO5WAQD64mn65rd/dYB/zArXirKxtUlgTWtPoxAyrTL6Cxi5PHqktpBlo9dWQXKjvqw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=SVXvsD20; dkim-atps=neutral; spf=pass (client-ip=113.46.200.219; helo=canpmsgout04.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=SVXvsD20;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.219; helo=canpmsgout04.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fCZ1x6XHJz2xSF
	for <linux-erofs@lists.ozlabs.org>; Sat, 14 Feb 2026 14:16:19 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gjMYksSLtua+20VlDHzcEo9SU2/7R4sPYXB+S/4B0fI=;
	b=SVXvsD20JZGOXvtXGIbQaruj3p0b7A4jkSNSdpytNcXw7sqQvl9uTBz7G/C37dZlBVYRLkuxL
	x8zXJFNuGhzDZUlCOs48HovRrbi5SjLoyhpbtPS3p1z+rEvu8Mo1ykvyedGBZIOElsxWs6faoU5
	uskZ31S/X95mhUs74g2PgVw=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fCYwN02JGz1prKd;
	Sat, 14 Feb 2026 11:11:32 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A0CD40569;
	Sat, 14 Feb 2026 11:16:14 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 14 Feb
 2026 11:16:14 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <xiang@kernel.org>, <chao@kernel.org>
CC: <hsiangkao@linux.alibaba.com>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v2] erofs: allow sharing page cache with the same aops only
Date: Sat, 14 Feb 2026 03:02:48 +0000
Message-ID: <20260214030248.771925-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.22.0
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
Content-Type: text/plain
X-Originating-IP: [10.67.174.162]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500015.china.huawei.com (7.202.195.162)

Inode with identical data but different @aops cannot be mixed
because the page cache is managed by different subsystems (e.g.,
@aops for compressed on-disk inodes cannot handle plain on-disk
inodes).

In this patch, we never allow inodes to share the page cache
among plain, compressed, and fileio cases. When a shared inode
is created, we initialize @aops that is the same as the initial
real inode, and subsequent inodes cannot share the page cache
if the inferred @aops differ from the corresponding shared inode.

This is reasonable as a first step because, in typical use cases,
if an inode is compressible, it will fall into compressed
inodes across different filesystem images unless users use plain
filesystems. However, in that cases, users will use plain
filesystems all the time.

Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
Changes in v2:
- Not assign to inode aops directly and rearrange the logic as
  suggested by Xiang.
- Link to v1: https://lore.kernel.org/all/20260213073345.768320-1-lihongbo22@huawei.com/
---
 fs/erofs/inode.c    |  7 ++++++-
 fs/erofs/internal.h | 16 +++++++---------
 fs/erofs/ishare.c   | 14 +++++++++-----
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 4f86169c23f1..4b3d21402e10 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -222,6 +222,7 @@ static int erofs_read_inode(struct inode *inode)
 
 static int erofs_fill_inode(struct inode *inode)
 {
+	const struct address_space_operations *aops;
 	int err;
 
 	trace_erofs_fill_inode(inode);
@@ -254,7 +255,11 @@ static int erofs_fill_inode(struct inode *inode)
 	}
 
 	mapping_set_large_folios(inode->i_mapping);
-	return erofs_inode_set_aops(inode, inode, false);
+	aops = erofs_get_aops(inode, false);
+	if (IS_ERR(aops))
+		return PTR_ERR(aops);
+	inode->i_mapping->a_ops = aops;
+	return 0;
 }
 
 /*
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index d1634455e389..a4f0a42cf8c3 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -471,26 +471,24 @@ static inline void *erofs_vm_map_ram(struct page **pages, unsigned int count)
 	return NULL;
 }
 
-static inline int erofs_inode_set_aops(struct inode *inode,
-				       struct inode *realinode, bool no_fscache)
+static inline const struct address_space_operations *
+erofs_get_aops(struct inode *realinode, bool no_fscache)
 {
 	if (erofs_inode_is_data_compressed(EROFS_I(realinode)->datalayout)) {
 		if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
-			return -EOPNOTSUPP;
+			return ERR_PTR(-EOPNOTSUPP);
 		DO_ONCE_LITE_IF(realinode->i_blkbits != PAGE_SHIFT,
 			  erofs_info, realinode->i_sb,
 			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
-		inode->i_mapping->a_ops = &z_erofs_aops;
-		return 0;
+		return &z_erofs_aops;
 	}
-	inode->i_mapping->a_ops = &erofs_aops;
 	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && !no_fscache &&
 	    erofs_is_fscache_mode(realinode->i_sb))
-		inode->i_mapping->a_ops = &erofs_fscache_access_aops;
+		return &erofs_fscache_access_aops;
 	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) &&
 	    erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
-		inode->i_mapping->a_ops = &erofs_fileio_aops;
-	return 0;
+		return &erofs_fileio_aops;
+	return &erofs_aops;
 }
 
 int erofs_register_sysfs(struct super_block *sb);
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index ce980320a8b9..829d50d5c717 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -40,10 +40,14 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
 	struct erofs_inode *vi = EROFS_I(inode);
+	const struct address_space_operations *aops;
 	struct erofs_inode_fingerprint fp;
 	struct inode *sharedinode;
 	unsigned long hash;
 
+	aops = erofs_get_aops(inode, true);
+	if (IS_ERR(aops))
+		return false;
 	if (erofs_xattr_fill_inode_fingerprint(&fp, inode, sbi->domain_id))
 		return false;
 	hash = xxh32(fp.opaque, fp.size, 0);
@@ -56,15 +60,15 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 	}
 
 	if (inode_state_read_once(sharedinode) & I_NEW) {
-		if (erofs_inode_set_aops(sharedinode, inode, true)) {
-			iget_failed(sharedinode);
-			kfree(fp.opaque);
-			return false;
-		}
+		sharedinode->i_mapping->a_ops = aops;
 		sharedinode->i_size = vi->vfs_inode.i_size;
 		unlock_new_inode(sharedinode);
 	} else {
 		kfree(fp.opaque);
+		if (aops != sharedinode->i_mapping->a_ops) {
+			iput(sharedinode);
+			return false;
+		}
 		if (sharedinode->i_size != vi->vfs_inode.i_size) {
 			_erofs_printk(inode->i_sb, KERN_WARNING
 				"size(%lld:%lld) not matches for the same fingerprint\n",
-- 
2.22.0


