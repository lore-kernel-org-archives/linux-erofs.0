Return-Path: <linux-erofs+bounces-3986-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C2FC44524
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 05:03:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5JtT04dMz2yfS;
	Thu, 23 Jul 2026 15:03:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784783024;
	cv=none; b=B6B2P1xwfQO5PomOJkAjadegGsnbPKa2CyhEn7DCAIacxIrHFJfYTsNbT61m5uGu2rLJwH8mRKwIFDL/T69Lbc0GlCj1zPR4JhCS75MV62F5FT7Qv0/fRXNtPjYtfOOn8ypgbDkWJsXSwhxUx83RvUWwpQnG2bsyNSEuNMpzmK5xnhG+ze34+XShh8L8e93xnjlOFpjR9DGiiUSGSM8uyTMJWNRnbB08MhbasMQf0vxHF7LrYElVv/1RNfqS8Mr4s+vmCa5KjJSyIlN6q7+ksLtRkWoH6NrWAcgXwZFu7ZC5DxY0PAZXkoD17SDEs317vcxBO9tu2o5w1UkGdpDzjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784783024; c=relaxed/relaxed;
	bh=+c7GCxKZB1sQsBrYlGNqLLjPCtD8xe5RNRiC9QgAq6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FL3DhuJcGi4NsFsmrfWO2ExuY451xkxz/NkdnNorL/DRV3uiD2Iov8wM4ooA9POCI8QwGY2jEiJ/Uvz56Dt7rslwGq7GJiCr9KZdYB5dG/UK9Vl11Z4nC5x5NoXKpSw9ybTxADHP3XRWpHNGH72FDW1SO34DC1lJ8VmmjlciPTCHfhYg+xW+TZFOKiSUNVSvr+K3LASQmrUkb/WI+J9akeOwRnqe+yMpnG60C8y8RiCaE7tCoQRomC1VX5dibbSu27qJ+cl4m8cs66e2vPR41EI15bQF0yN2S+2srKpdvWGoXjs9GbI/18YF9NEfZK7pGr7J01KRpeLNNQD093sqJQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4in9HbK; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4in9HbK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5JtR5S6Kz2yVZ
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 15:03:43 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BD91600AB
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 05:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3252A1F000E9;
	Thu, 23 Jul 2026 05:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784783015;
	bh=+c7GCxKZB1sQsBrYlGNqLLjPCtD8xe5RNRiC9QgAq6A=;
	h=From:To:Cc:Subject:Date;
	b=I4in9HbKVOZxUz8QFX6dRlTvbLo1YgJo0c2e934n3rObIGh3OslpjE+gSgQLCYYUn
	 LwwUfNHWg/Jj0lrvzdV6Pd4YctRIisgrVOZXpzol6A/sO8HImT1kzPDGpi2XmB6Qq1
	 bxU2vbwd6U+9elrL0Ks8/SavG/ARcb4CoRPlhlOVb5xHVVUGdyTHcxrXMokOmQ1Rvl
	 m53X0OgPMM8534L4SeUDhqCo/U18SvQs8vBjLIN7gidtQS3pawUAaZKHdyVBSr74ZY
	 w0eXjvgJ8dhHhnRJIEn22fLi9ESuyNB16JsWStPymrhS1KxPPTh/V624XnDp+MeJcH
	 Wk3Xh5Agd8vfg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs: ensure valid f_path for page cache sharing
Date: Thu, 23 Jul 2026 13:03:13 +0800
Message-ID: <20260723050313.2273-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
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

Previously, backing files for page cache sharing were set up with
f_path left as NULL (only f_inode was valid).  It worked, but a recent
mincore fix relies on f_path.mnt and crashes (found by "erofs/028" on
7.2-rc4):

 BUG: kernel NULL pointer dereference, address: 0000000000000018
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP PTI
 CPU: 3 UID: 0 PID: 675528 Comm: fincore Not tainted 7.2.0-rc4-00002-g[]-dirty #1 PREEMPT(lazy)
 Hardware name: Red Hat KVM, BIOS 1.16.0-4.al8 04/01/2014
 RIP: 0010:__do_sys_mincore+0xc0/0x2c0
 ...

Specify valid paths using valid disconnected dentries together with
erofs_ishare_mnt instead of leaving f_path empty, so they are more
like real backing files in a pseudo filesystem and standard
backing_file_open() can be used directly.

Fixes: e187bc02f8fa ("mm: do file ownership checks with the proper mount idmap")
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 fs/erofs/Kconfig    |  1 +
 fs/erofs/internal.h |  4 +--
 fs/erofs/ishare.c   | 60 ++++++++++++++++++++++-----------------------
 3 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 4789b1077d8c..1feb28cfe557 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -189,6 +189,7 @@ config EROFS_FS_PCPU_KTHREAD_HIPRI
 config EROFS_FS_PAGE_CACHE_SHARE
 	bool "EROFS page cache share support (experimental)"
 	depends on EROFS_FS && EROFS_FS_XATTR
+	select FS_STACK
 	help
 	  This enables page cache sharing among inodes with identical
 	  content fingerprints on the same machine.
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 580f8d9f14e7..57bd21859c65 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -288,8 +288,8 @@ struct erofs_inode {
 			struct erofs_inode_fingerprint fingerprint;
 			spinlock_t ishare_lock;
 		};
-		/* for each real inode */
-		struct inode *sharedinode;
+		/* for each real filesystem inode */
+		struct dentry *sharedentry;
 	};
 #endif
 	/* the corresponding vfs inode */
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index a1a20a5ba548..51b81aaf9ac3 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -2,14 +2,13 @@
 /*
  * Copyright (C) 2024, Alibaba Cloud
  */
+#include <linux/backing-file.h>
 #include <linux/xxhash.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include "internal.h"
 #include "xattr.h"
 
-#include "../internal.h"
-
 static struct vfsmount *erofs_ishare_mnt;
 
 static int erofs_ishare_iget5_eq(struct inode *inode, void *data)
@@ -33,10 +32,12 @@ static int erofs_ishare_iget5_set(struct inode *inode, void *data)
 
 bool erofs_ishare_fill_inode(struct inode *inode)
 {
+	static const struct file_operations empty_fops = {};
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
 	const struct address_space_operations *aops;
 	struct erofs_inode *vi = EROFS_I(inode);
 	struct erofs_inode_fingerprint fp;
+	struct dentry *sd;
 	struct inode *si;
 
 	aops = erofs_get_aops(inode);
@@ -49,7 +50,9 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 			  xxh32(fp.opaque, fp.size, 0),
 			  erofs_ishare_iget5_eq, erofs_ishare_iget5_set, &fp);
 	if (si && (inode_state_read_once(si) & I_NEW)) {
+		si->i_fop = &empty_fops;
 		si->i_mapping->a_ops = aops;
+		si->i_mode = 0444 | S_IFREG;
 		si->i_size = inode->i_size;
 		unlock_new_inode(si);
 	} else {
@@ -65,7 +68,12 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 			return false;
 		}
 	}
-	vi->sharedinode = si;
+	sd = d_obtain_alias(si); /* disconnected denties for sharedinodes */
+	if (IS_ERR(sd)) {
+		iput(si);
+		return false;
+	}
+	vi->sharedentry = sd;
 	INIT_LIST_HEAD(&vi->ishare_list);
 	spin_lock(&EROFS_I(si)->ishare_lock);
 	list_add(&vi->ishare_list, &EROFS_I(si)->ishare_list);
@@ -75,48 +83,40 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 
 void erofs_ishare_free_inode(struct inode *inode)
 {
-	struct erofs_inode *vi = EROFS_I(inode);
-	struct inode *sharedinode = vi->sharedinode;
+	struct erofs_inode *vi = EROFS_I(inode), *svi;
 
-	if (!sharedinode)
+	if (!vi->sharedentry)
 		return;
-	spin_lock(&EROFS_I(sharedinode)->ishare_lock);
+	svi = EROFS_I(d_inode(vi->sharedentry));
+	spin_lock(&svi->ishare_lock);
 	list_del(&vi->ishare_list);
-	spin_unlock(&EROFS_I(sharedinode)->ishare_lock);
-	iput(sharedinode);
-	vi->sharedinode = NULL;
+	spin_unlock(&svi->ishare_lock);
+	dput(vi->sharedentry);
+	vi->sharedentry = NULL;
 }
 
 static int erofs_ishare_file_open(struct inode *inode, struct file *file)
 {
-	struct inode *sharedinode = EROFS_I(inode)->sharedinode;
-	struct file *realfile;
+	struct path sharedpath = {
+		.mnt = erofs_ishare_mnt,
+		.dentry = EROFS_I(inode)->sharedentry,
+	};
+	struct file *rf;
 
 	if (file->f_flags & O_DIRECT)
 		return -EINVAL;
-	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred(),
-					    file);
-	if (IS_ERR(realfile))
-		return PTR_ERR(realfile);
-	ihold(sharedinode);
-	realfile->f_op = &erofs_file_fops;
-	realfile->f_inode = sharedinode;
-	realfile->f_mapping = sharedinode->i_mapping;
-	path_get(&file->f_path);
-	backing_file_set_user_path(realfile, &file->f_path);
-
-	file_ra_state_init(&realfile->f_ra, file->f_mapping);
-	realfile->private_data = EROFS_I(inode);
-	file->private_data = realfile;
+
+	rf = backing_file_open(file, file->f_flags | O_NOATIME | FMODE_NONOTIFY,
+			       &sharedpath, current_cred());
+	if (IS_ERR(rf))
+		return PTR_ERR(rf);
+	file->private_data = rf;
 	return 0;
 }
 
 static int erofs_ishare_file_release(struct inode *inode, struct file *file)
 {
-	struct file *realfile = file->private_data;
-
-	iput(realfile->f_inode);
-	fput(realfile);
+	fput(file->private_data);
 	file->private_data = NULL;
 	return 0;
 }
-- 
2.47.3


