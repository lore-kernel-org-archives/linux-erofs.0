Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9FC606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 05:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=ZBIjhV4v
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZlnz52fhz2yDc;
	Thu, 26 Nov 2026 16:43:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=8.221.36.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795671799;
	cv=none; b=AuAhFaFNI4slDfPQoE6lT6xHWk3GPariD/vVaQ0Ryai7Qml8CohNA9vxJVyS/61rJqurONzL1O3F0FZFqyWKD6AGworOea8Fmed/3JbQoZQr3alSoVgW6SXav89VwDPAC6r+qcFWdWVSGi3LcJLut+5SKuZN3B0GPA0C7ZkNc+E6ssGzLfu79zm1+G8l8Gd1uDKnTNKygYE4B9Uz+aw2gmQA9aeAqn+qC4sC3MhvrSqR/ZOCKYO6yID8kezf538cl5NyyvSxJF2dlzQ84/LvL+J//vQxIrFsLCcUdvhAgwWm4TYB6xRI9D6qUz3JlW+ApE+OjRUXX9WV0buTaN+lnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795671799; c=relaxed/relaxed;
	bh=DXEcRoC6dd9vstOaQhU671AxiuawhnM6bCRlg46P3p8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OK1rEMQRoqCitdQhM9T0ODryP5raG3ViDs5QASNK1ztL6Z84Wodc17uD7pNBsiOXL/Xtl6MIGxMlcphFs9mJ8dAaOjweEImUA47GqjJ5DrZVPkTsWbC5U/NUD0pvVuOC1MgBfnHBTYzBwmF0p3HlGA4qqg5+zw7yF/28D57U5jAKn0HAcpDFlCPnPjqYzlt3SnnBXtv/poCJRUDdZg2GYRpMxnsfylQQxQXqlJwJynaS8D7EoQzHgeAyZ49vuRj7gAP5V9YnrXLjvbVuEQjLwdt8z23XFCQt9RRlnstuUZ7p4yelXN/pN5uxMxNh33pjU5l1CpCrOJgkalBfviJRTA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=ZBIjhV4v; dkim-atps=neutral; spf=pass (client-ip=8.221.36.31; helo=mail-m82213631.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=ZBIjhV4v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=8.221.36.31; helo=mail-m82213631.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m82213631.xmail.ntesmail.com (mail-m82213631.xmail.ntesmail.com [8.221.36.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZlnt2XCdz2xnn
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 16:43:10 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.177])
	by smtp.qiye.163.com (Hmail) with ESMTP id 56105e133;
	Thu, 26 Nov 2026 13:43:01 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: lib: persist opaque xattrs for incremental build
Date: Thu, 26 Nov 2026 05:42:58 +0000
Message-ID: <20261126054258.3859270-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa21660ee0a03a3kunm58eaefa59fa7c0
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSkIeVktOGBhKTBlKHUpDTlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTExZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJNSktVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=ZBIjhV4vOFKGZgxsV4bv9u9o66rwmF+Hbh+d71jFKYti8hXrgfabx7PJNh+q3Q/99DF/EUA0uHcFj6pTN7oCkhDXCDV3SIlwTuUKIiyh+5zVEghtnMdjwcysdQK9bPhwJZmnkYXhuZvf1v+LtMPpVnXM4hFdvx3vTFZHZWDELvo=; c=relaxed/relaxed; s=default; d=deepseek.com; v=1;
	bh=DXEcRoC6dd9vstOaQhU671AxiuawhnM6bCRlg46P3p8=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 3233deddbcc1 ("erofs-utils: lib: persist opaque xattrs for
rebuilt merged dirs") fixed opaque xattr persistence in rebuild mode,
but did not fix incremental mode, which merges the base image through a
separate path.

When an incremental build merges a new directory over a whiteout or an
opaque directory in the base image, the resulting directory can lose the
opaque marker. Stacking the updated image above older layers then
exposes entries that should remain hidden.

Mark directories replacing base whiteouts opaque and inherit opaque
xattrs while loading base directory contents. Delay inheriting the
marker until that load so it does not prevent the contents from being
merged. Share the on-disk whiteout lookup through erofs_nid_is_whiteout.

Fixes: f64d9d02576b ("erofs-utils: introduce incremental builds")
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 include/erofs/inode.h |  1 +
 lib/inode.c           | 30 +++++++++++++++++-------------
 lib/rebuild.c         | 23 +++++++++++++++++------
 3 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/include/erofs/inode.h b/include/erofs/inode.h
index 6745a73..5051c77 100644
--- a/include/erofs/inode.h
+++ b/include/erofs/inode.h
@@ -39,6 +39,7 @@ struct erofs_dentry *erofs_d_alloc(struct erofs_inode *parent,
 				   const char *name);
 int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
 				 int device_id);
+bool erofs_nid_is_whiteout(struct erofs_sb_info *sbi, erofs_nid_t nid);
 bool erofs_dentry_is_wht(struct erofs_sb_info *sbi, struct erofs_dentry *d);
 int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 		       erofs_os_stat_t *st, const char *path);
diff --git a/lib/inode.c b/lib/inode.c
index ad6f081..e62bde1 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1917,23 +1917,27 @@ err_closedir:
 	return ret;
 }
 
+bool erofs_nid_is_whiteout(struct erofs_sb_info *sbi, erofs_nid_t nid)
+{
+	struct erofs_inode inode = { .sbi = sbi, .nid = nid };
+	int ret;
+
+	ret = erofs_read_inode_from_disk(&inode);
+	if (ret) {
+		erofs_err("failed to check DT_WHT: %s",
+			  erofs_strerror(ret));
+		DBG_BUGON(1);
+		return false;
+	}
+	return erofs_inode_is_whiteout(&inode);
+}
+
 bool erofs_dentry_is_wht(struct erofs_sb_info *sbi, struct erofs_dentry *d)
 {
 	if (!(d->flags & EROFS_DENTRY_FLAG_VALIDNID))
 		return erofs_inode_is_whiteout(d->inode);
-	if (d->type == EROFS_FT_CHRDEV) {
-		struct erofs_inode ei = { .sbi = sbi, .nid = d->nid };
-		int ret;
-
-		ret = erofs_read_inode_from_disk(&ei);
-		if (ret) {
-			erofs_err("failed to check DT_WHT: %s",
-				  erofs_strerror(ret));
-			DBG_BUGON(1);
-			return false;
-		}
-		return erofs_inode_is_whiteout(&ei);
-	}
+	if (d->type == EROFS_FT_CHRDEV)
+		return erofs_nid_is_whiteout(sbi, d->nid);
 	return false;
 }
 
diff --git a/lib/rebuild.c b/lib/rebuild.c
index e83fd52..0ab9adc 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -695,6 +695,7 @@ static int erofs_rebuild_basedir_dirent_iter(struct erofs_dir_context *ctx)
 		goto out;
 	}
 
+	ret = 0;
 	if (d->type == EROFS_FT_UNKNOWN) {
 		d->nid = ctx->de_nid;
 		d->type = ctx->de_ftype;
@@ -709,21 +710,24 @@ static int erofs_rebuild_basedir_dirent_iter(struct erofs_dir_context *ctx)
 		/* The base image appears to be corrupted */
 		DBG_BUGON(1);
 		ret = -EFSCORRUPTED;
-		goto out;
-	} else {
+	} else if (S_ISDIR(d->inode->i_mode)) {
 		struct erofs_inode *inode = d->inode;
 
+		/* the upper directory hides this whiteout */
+		if (ctx->de_ftype == EROFS_FT_CHRDEV &&
+		    erofs_nid_is_whiteout(dir->sbi, ctx->de_nid))
+			ret = erofs_set_ovl_xattr(inode,
+					EROFS_OVL_XATTR_OPAQUE, "y", 1);
+
 		/* update sub-directories only for recursively loading */
-		if (S_ISDIR(inode->i_mode) &&
-		    (ctx->de_ftype == EROFS_FT_DIR ||
-		     ctx->de_ftype == EROFS_FT_UNKNOWN)) {
+		if (ctx->de_ftype == EROFS_FT_DIR ||
+		    ctx->de_ftype == EROFS_FT_UNKNOWN) {
 			erofs_remove_ihash(inode);
 			inode->dev = dir->sbi->dev;
 			inode->i_ino[1] = ctx->de_nid;
 			erofs_insert_ihash(inode);
 		}
 	}
-	ret = 0;
 out:
 	free(dname);
 	return ret;
@@ -758,6 +762,13 @@ int erofs_rebuild_load_basedir(struct erofs_inode *dir, u64 *nr_subdirs,
 		return 0;
 	}
 
+	/* the lower opaque directory gets merged */
+	if (erofs_has_ovl_xattr(&fakeinode, EROFS_OVL_XATTR_OPAQUE))
+		ret = erofs_set_ovl_xattr(dir, EROFS_OVL_XATTR_OPAQUE, "y", 1);
+	erofs_inode_free_xattrs(&fakeinode);
+	if (ret)
+		return ret;
+
 	ctx = (struct erofs_rebuild_dir_context) {
 		.ctx.dir = &fakeinode,
 		.ctx.cb = erofs_rebuild_basedir_dirent_iter,
-- 
2.43.0


