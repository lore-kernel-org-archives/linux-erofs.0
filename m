Return-Path: <linux-erofs+bounces-4009-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438DCC531D0
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 04:28:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7lvw22N7z2xyl;
	Mon, 27 Jul 2026 14:28:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785126508;
	cv=none; b=JKNX2IcsO2T7hQ9E0PfN5O1S0eUGjbBxluHq24HPsjj1s2uh+2BCDHvGZl+ZQa/V7vEXFdBQ57fjYvyOMqI0kBJRKqDIc/RZ2PgZzz+nnnVQ47xhdvEv9tNqQg/OlocXQSQI24cWvuKskQ9+bes6dNH/851rneZY1wfiOMFtLXfhtycpoPk9fu7XQ7n7HxIkuIw9zeTgjYhlXMAkXIjfOh09XY8V4Q/TasVD1WCmPDWSa4o1c9NlSLkMOGSyjYpKLnDzwuq/RuJPSPmNDTQK/FhNjJsIhER6DZvZq9r7W+lXq1xN8LZ36onKWwlgT9lWYBwS1EDUSVmDQm60eIVprw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785126508; c=relaxed/relaxed;
	bh=S0TbUMAJpxumCye6eK5ADRCc3bJxOKQaIyrfgtMjKiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoCSRlfygOFnpdSFoFSRJZ7lbFAIJWvqaD1tW9p0SzXWrHNjPUfUmOyxgpXa7C6iuhyyeqvBEDgoPbVbBjbDb92BwbzL9Dgy2mRTuc/uu1tmWx8caI+Alx+eWv6MN/Jzy676yeDH/f9Opwzlj5yDNX70Wmcu27UnmCEzlhb50bkMKVe2wyond4vKjYFvKRas22RbIx95st/v06+mp1XxQ6R3bWgGITuLH0jsfjUpboeEQsZuXNTQ+kvNfPDD66x4bHU1aLiaPd4yD5DnmDvaIThRpKaA9lnYPIfYabEF90/Xw5n7r+HCA+AZG/FmSa3Urn9qdbuiAFTl031/e6baCA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jf6/uSdk; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jf6/uSdk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7lvv1TTdz2xwN
	for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 14:28:27 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2200F40592;
	Mon, 27 Jul 2026 04:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F103D1F000E9;
	Mon, 27 Jul 2026 04:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785126503;
	bh=S0TbUMAJpxumCye6eK5ADRCc3bJxOKQaIyrfgtMjKiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jf6/uSdkCjRURlUOyF42ZUQO9AX+mMVynWTHRjtWhkCitbQZ0QV614etaTWncPbiI
	 V1DAO0CPDB5u/I0gmC975pJWpmr/MB312vz1dGzoDExSMyaH++Gtt0BoK4Ef43YbKW
	 cc+QE5VqOpe0wbMHuCvM5QztNLmyvLBgY1Ftyi5KLXgjX8AOAogyvVbfGQCNz99pH8
	 TfM2wVE05I1izTqqj2HsLUEHy79GrwbhMQ7xU+/49N7YbRVANqSJslpYnBuJYafrWi
	 BRmeMpGs5SYtnPtcxHiVUwX5Ccr3sOEQo/8wbsXLL7mEhqMH9o0CJkhLya34LsLbBD
	 rBVgsdqLzhJUA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Hongbo Li <hongbohbli@tencent.com>
Subject: [PATCH v2] erofs: ensure valid f_path for page cache sharing
Date: Mon, 27 Jul 2026 12:27:39 +0800
Message-ID: <20260727042739.2156-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723050313.2273-1-xiang@kernel.org>
References: <20260723050313.2273-1-xiang@kernel.org>
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
Acked-by: Hongbo Li <hongbohbli@tencent.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
v2:
 - resolve sashiko's reports.

 fs/erofs/Kconfig    |  1 +
 fs/erofs/internal.h |  4 ++--
 fs/erofs/ishare.c   | 58 ++++++++++++++++++++++-----------------------
 3 files changed, 31 insertions(+), 32 deletions(-)

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
index a1a20a5ba548..fa7d4112dec5 100644
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
@@ -65,7 +68,10 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 			return false;
 		}
 	}
-	vi->sharedinode = si;
+	sd = d_obtain_alias(si); /* disconnected denties for sharedinodes */
+	if (IS_ERR(sd))
+		return false;
+	vi->sharedentry = sd;
 	INIT_LIST_HEAD(&vi->ishare_list);
 	spin_lock(&EROFS_I(si)->ishare_lock);
 	list_add(&vi->ishare_list, &EROFS_I(si)->ishare_list);
@@ -75,48 +81,40 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 
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
+	rf = backing_file_open(file, file->f_flags | O_NOATIME,
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


