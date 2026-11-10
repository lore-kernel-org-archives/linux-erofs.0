Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C04606A96E
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 07:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=d2WkbmvO
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jNzL039k9z2yKn;
	Tue, 10 Nov 2026 18:48:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=156.224.81.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794296920;
	cv=none; b=gK1EpufYCi9PGCNjROH5UhCpgGV/5Y63nymlA5ziCFMhjqYEgPyVFvKLV48BZqr1Ru4ziT8Hpaaw+6JL/JG7uyv4D/JdMJYMXqmKaD3y1YSz/zDRKna/aVRfXmXPCma22eO4DB7Oy+PdngFkssCgAcKty27oCUgn+ZG9O+yy7LSqUlhsinn0egLJOLdmN/1gPbZS2ymc8C2BrrSJ3TcuaVwFFfI+5dP5bWFZ9mfhXoAoacqXxDQg2cOM1W1QJAEzveZsSxYerhGrcweS/lyE2Y0Ru0vY3ZAmjC9GVuTP6QPwgSA7RA+bePV2jhUgURe4qXhUVAohthhO1XBSENPBmg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794296920; c=relaxed/relaxed;
	bh=vozIMRZRw4OfnTQmm83KF+9bVM74yKlG4ay6P0WN/N8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZrAxkm2PSLp6rQM0Y7yUiUEJ4hyd2GaDwftUgriEneFBWBRCqqP/OMRv8/mMZlsjSuwM/goyJrIYF7lbWu/Bds4sR0LKUKyoQPWgfCYVddBnCl1msBMMMgntWKqIWyaGtMt8fHAFnAaYiqHX8wcVGcEsCqwhghIlkd5wZSb74zqCYU8zMZBzMC44Vk/mm4hyxGISXG8mdxAaPNkMcTvPGaOMiYC88r0DJ0OQo5Oq2Nxd53/oaemxaVs9ajJ7a8xoTPD+pXAvPWrjMzrurQDKodYbo24FSdA4iOeMUW867xvh16SNBtJEZdNOzvQbJhD2VXnb9ZbH0DEKx+9Q0DSVgg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=d2WkbmvO; dkim-atps=neutral; spf=pass (client-ip=156.224.81.211; helo=mail-m81211.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=d2WkbmvO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=156.224.81.211; helo=mail-m81211.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m81211.xmail.ntesmail.com (mail-m81211.xmail.ntesmail.com [156.224.81.211])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jNzKw5SzRz2yCr
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 18:48:34 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.138])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5421a057c;
	Tue, 10 Nov 2026 15:48:26 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 1/3] erofs-utils: lib: avoid duplicate overlay origin xattrs
Date: Tue, 10 Nov 2026 07:48:20 +0000
Message-ID: <20261110074822.292859-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1c46dffbc03a3kunmfb1181274ba029
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGRhOVh5ITkgfTR1CSE1IGlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKSENZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJDQkpVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=d2WkbmvOHse84X3eP1JbIaMisxUZftm4cBj1eX0j09SlLDUHbXQwPcCYaclpGOCFaFfxttq+PY8uuXlbbm5NJb4BsEz6qYIGuyuxjbRctM6Dmo4HpK4dHALmmg0Ne+GHqgOIP2lS9ajF64xZxeHcBXFrbyHhbVKqkoObZIcqoHs=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=vozIMRZRw4OfnTQmm83KF+9bVM74yKlG4ay6P0WN/N8=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Empty origin xattrs were introduced to mark directories produced by
offline layer merging that retain whiteouts for use with additional
lower layers. This keeps OverlayFS from exposing whiteouts when such a
directory has no matching lower directory and would otherwise be
iterated directly [1].

If a whiteout's parent directory already has a trusted.overlay.origin
xattr, image construction can append another origin xattr with an empty
value. This produces duplicate attributes with the same name. When the
original value is nonempty, the empty attribute can hide it when reading
the resulting image.

[1] https://lore.kernel.org/all/6a43ee5c-cc25-ff9f-1198-7c2b445d3775@linux.alibaba.com/

Fixes: 1d9a3368e254 ("erofs-utils: lib: set OVL_XATTR_ORIGIN for directories with whiteouts")
Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
v1: https://lore.kernel.org/all/20261107042703.3392000-1-sereno.xu@deepseek.com/
---
 include/erofs/internal.h |  1 +
 include/erofs/xattr.h    |  1 +
 lib/inode.c              |  7 +++++--
 lib/tar.c                |  2 ++
 lib/xattr.c              | 30 ++++++++++++++++++------------
 5 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 19e38fb..87c7b9a 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -269,6 +269,7 @@ struct erofs_inode {
 	char idata_type;
 	bool lazy_tailblock;
 	bool opaque;
+	bool origin;		/* with an origin xattr */
 	/* OVL: non-merge dir that may contain whiteout entries */
 	bool whiteouts;
 	bool dot_omitted;
diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index d12c292..a729b98 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -48,6 +48,7 @@ int erofs_vfs_setxattr(struct erofs_inode *inode, const char *name,
 int erofs_set_opaque_xattr(struct erofs_inode *inode);
 void erofs_clear_opaque_xattr(struct erofs_inode *inode);
 bool erofs_get_opaque_from_disk(struct erofs_inode *inode);
+bool erofs_test_origin_xattr(const char *name);
 int erofs_set_origin_xattr(struct erofs_inode *inode);
 int erofs_read_xattrs_from_disk(struct erofs_inode *inode);
 
diff --git a/lib/inode.c b/lib/inode.c
index da29b5a..d0ab536 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -2134,8 +2134,11 @@ static int erofs_mkfs_handle_inode(const struct erofs_mkfs_btctx *ctx,
 	/* strip all unnecessary overlayfs xattrs when ovlfs_strip is enabled */
 	if (params->ovlfs_strip)
 		erofs_clear_opaque_xattr(inode);
-	else if (inode->whiteouts)
-		erofs_set_origin_xattr(inode);
+	else if (inode->whiteouts) {
+		ret = erofs_set_origin_xattr(inode);
+		if (ret)
+			return ret;
+	}
 
 	if (!S_ISDIR(inode->i_mode)) {
 		ret = erofs_mkfs_begin_nondirectory(ctx, inode);
diff --git a/lib/tar.c b/lib/tar.c
index 83b3115..14b2225 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -418,6 +418,8 @@ int tarerofs_apply_xattrs(struct erofs_inode *inode, struct list_head *xattrs)
 		item->kv[item->namelen] = '\0';
 		erofs_dbg("Recording xattr(%s)=\"%.*s\" (of %u bytes) to file %s",
 			  item->kv, vsz, v, vsz, inode->i_srcpath);
+		if (erofs_test_origin_xattr(item->kv))
+			inode->origin = true;
 		ret = erofs_vfs_setxattr(inode, item->kv, v, vsz);
 		if (ret == -ENODATA)
 			erofs_err("Failed to set xattr(%s)=%.*s to file %s",
diff --git a/lib/xattr.c b/lib/xattr.c
index d86d94a..4097298 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -451,7 +451,7 @@ static bool erofs_is_skipped_xattr(const char *key)
 }
 
 static int read_xattrs_from_file(struct erofs_sb_info *sbi, const char *path,
-				 mode_t mode, struct list_head *ixattrs)
+				 mode_t mode, struct erofs_inode *inode)
 {
 	ssize_t kllen = erofs_sys_llistxattr(path, NULL, 0);
 	char *keylst, *key, *klend;
@@ -506,8 +506,10 @@ static int read_xattrs_from_file(struct erofs_sb_info *sbi, const char *path,
 			goto err;
 		}
 
-		if (ixattrs) {
-			ret = erofs_inode_xattr_add(ixattrs, item);
+		if (inode) {
+			if (erofs_test_origin_xattr(key))
+				inode->origin = true;
+			ret = erofs_inode_xattr_add(&inode->i_xattrs, item);
 			if (ret < 0)
 				goto err;
 		}
@@ -519,8 +521,8 @@ out:
 	item = erofs_get_selabel_xattr(sbi, path, mode);
 	if (IS_ERR(item))
 		return PTR_ERR(item);
-	if (item && ixattrs)
-		ret = erofs_inode_xattr_add(ixattrs, item);
+	if (item && inode)
+		ret = erofs_inode_xattr_add(&inode->i_xattrs, item);
 	return ret;
 
 err:
@@ -607,8 +609,16 @@ bool erofs_get_opaque_from_disk(struct erofs_inode *inode)
 	return (erofs_getxattr(inode, OVL_XATTR_OPAQUE, NULL, 0) >= 0);
 }
 
+bool erofs_test_origin_xattr(const char *name)
+{
+	return !strcmp(name, OVL_XATTR_ORIGIN);
+}
+
 int erofs_set_origin_xattr(struct erofs_inode *inode)
 {
+	if (inode->origin)
+		return 0;
+	inode->origin = true;
 	return erofs_vfs_setxattr(inode, OVL_XATTR_ORIGIN, NULL, 0);
 }
 
@@ -658,10 +668,9 @@ static int erofs_droid_xattr_set_caps(struct erofs_inode *inode)
 int erofs_scan_file_xattrs(struct erofs_inode *inode)
 {
 	int ret;
-	struct list_head *ixattrs = &inode->i_xattrs;
 
 	ret = read_xattrs_from_file(inode->sbi, inode->i_srcpath,
-				    inode->i_mode, ixattrs);
+				    inode->i_mode, inode);
 	if (ret < 0)
 		return ret;
 
@@ -720,13 +729,10 @@ int erofs_read_xattrs_from_disk(struct erofs_inode *inode)
 				goto out;
 			}
 			DBG_BUGON(ret != size);
-		} else if (S_ISDIR(inode->i_mode) &&
-			   !strcmp(key, OVL_XATTR_ORIGIN)) {
-			ret = 0;
-			inode->whiteouts = true;
-			continue;
 		}
 
+		if (erofs_test_origin_xattr(key))
+			inode->origin = true;
 		ret = erofs_vfs_setxattr(inode, key, value, size);
 		free(value);
 		if (ret)
-- 
2.43.0


