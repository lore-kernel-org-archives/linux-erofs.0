Return-Path: <linux-erofs+bounces-4004-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F64EC531C9
	for <linux-erofs@archiver.kernel.org>; Sat, 25 Jul 2026 02:53:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h6Tvd0TwCz2ySJ;
	Sat, 25 Jul 2026 12:53:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784948028;
	cv=none; b=iCmmmFf0MgIyVGzORWhH029KVsnXFRzcFyoyUO3po3f7sWqCd5zYU3aZtx65867KtrhhxyLQ/Yj8sga4wWLzetFDfkqQZI7insCG4QswxTwpC5qPAMwnRCJGztq8LcSuy0oUKFzf4Q4+1mxuljYmqO8ofW/bUxXQTJPDTzpldeoK/EhktWEl7wDGSt7tQX4HDXPaxQqiqtpDG3XWi7vQ4CLsjm5xmJADT28nUrYzzNpoGwJortIjiPiYa6S1TzeYyJW/SwHsTPDHDUiTUOFkzTeYAJx53z5G/AB2lp0unYlwqJG4BEkrDmBPVI8PU17xCwoR8RZtcF8xG+jy7Nox4g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784948028; c=relaxed/relaxed;
	bh=1QQwLaa/If3ZbVpl6zBTFgEoH0bEcHLwl2TUA1fGkt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLDMHtC/b2jI1qpKz/gSbuNO9ynI/MLlY7Q7ZWLMv4GY6DU5axFuacg1ruGnFJiEm8QW+wvyayB4kk/41BoEnsPNDFgNkgm+HxAv1a5YBmAYr37iqFu41Pc7jxz3Sp+HEwn6Wusvv++IwDOyWx2XCJD+uuh4cOUTyb0HqEA9fhBaf7kKtmJgWUq2fgQZFij1n11TyGTbsnhEmeU2LvxrduSaTSikfBy0HbXtL+BhqoATcW45CcOEYIB6CNsJf7c2EqxpKBWsitX9WOCKZ/ft4a757WW5FRMXewKxiFUZk3Oh1DXzuN8fpYcaeqe3JKoK3mR4TPCvCHVOdJ3XAx9FAQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SndV3qjF; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SndV3qjF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h6Tvb6HQGz2xLd
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 12:53:47 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 203ED600AD;
	Sat, 25 Jul 2026 02:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F28C1F000E9;
	Sat, 25 Jul 2026 02:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784948024;
	bh=1QQwLaa/If3ZbVpl6zBTFgEoH0bEcHLwl2TUA1fGkt0=;
	h=From:To:Cc:Subject:Date;
	b=SndV3qjFtggywuhVuqPo454NAh0yaCrRptNYR88wneTjxfQpVxYXNokltMXPWhrYv
	 BmHQ4DjI6B/7q1hD4uW6GcX/QsteK1+B68ieYekV90r5w94YHcLMwCLoR7n7tp9/GO
	 u0f8w0xJdUrthfp2kkg0VpoicLrXXgu8suZ76vSn5HnWthMaujs0CoEkLCuR7jX9qX
	 RSXXDDwucoG8gZriN4xbDtJT4w2JMBSr/cZgp6Akxg+KTKZ9q9nbbFA3Gq/Q7ZMzNL
	 4LVk1aOP6SY8i2jZz3A+AK/SgxCtWVWrgbH/ZV3qbpJrbP9Mn8urlBrTh+gTUHe9u7
	 MdK50MWwTQ9gg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <zhaoyifan28@huawei.com>,
	Gao Xiang <xiang@kernel.org>,
	cayoub-oai <cayoub@openai.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: fix opaque handling for merged dirs in rebuild mode
Date: Sat, 25 Jul 2026 10:53:28 +0800
Message-ID: <20260725025328.35113-1-xiang@kernel.org>
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

As cayoub-oai reports,

A three-layer opaque-directory case still fails (oldest to newest):
L1: dir/old.txt
L2: dir/.wh..wh..opq
L3: dir/new.txt

After converting each layer with `mkfs.erofs --tar=f --aufs` and
fsmerging with `--aufs --ovlfs-strip=1`, the expected result is
only `dir/new.txt`. However, `dir/old.txt` incorrectly reappears.

Reported-by: cayoub-oai <cayoub@openai.com>
Fixes: 7fbec7d32ce3 ("erofs-utils: lib: honor rebuild whiteouts for recreated dirs")
Fixes: 39147b48b76d ("erofs-utils: lib: add erofs_rebuild_load_tree() helper")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 include/erofs/xattr.h |  2 ++
 lib/inode.c           |  1 +
 lib/rebuild.c         |  6 ++++--
 lib/xattr.c           | 16 ++++++++++++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index 5fe3e91..d12c292 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -47,12 +47,14 @@ int erofs_vfs_setxattr(struct erofs_inode *inode, const char *name,
 		       const void *value, size_t size);
 int erofs_set_opaque_xattr(struct erofs_inode *inode);
 void erofs_clear_opaque_xattr(struct erofs_inode *inode);
+bool erofs_get_opaque_from_disk(struct erofs_inode *inode);
 int erofs_set_origin_xattr(struct erofs_inode *inode);
 int erofs_read_xattrs_from_disk(struct erofs_inode *inode);
 
 bool erofs_xattr_prefix_matches(const char *key, unsigned int *index,
 				unsigned int *len);
 void erofs_xattr_exit(struct erofs_sb_info *sbi);
+void erofs_inode_free_xattrs(struct erofs_inode *inode);
 
 #ifdef __cplusplus
 }
diff --git a/lib/inode.c b/lib/inode.c
index 267694f..9f4d14c 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -166,6 +166,7 @@ unsigned int erofs_iput(struct erofs_inode *inode)
 
 	if (inode->datalayout == EROFS_INODE_CHUNK_BASED)
 		free(inode->chunkindexes);
+	erofs_inode_free_xattrs(inode);
 	free(inode);
 	return 0;
 }
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 108a464..a5308dc 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -403,13 +403,15 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
 		ret = erofs_read_inode_from_disk(&src);
 		if (ret)
 			goto out;
+		mergedir = d->inode;
 		if (erofs_inode_is_whiteout(&src)) {
-			d->inode->opaque = true;
+			mergedir->opaque = true;
 			goto out;
 		}
 		if (!S_ISDIR(src.i_mode))
 			goto out;
-		mergedir = d->inode;
+		mergedir->opaque |= erofs_get_opaque_from_disk(&src);
+		erofs_inode_free_xattrs(&src);
 		inode = dir = &src;
 	} else {
 		u64 nid;
diff --git a/lib/xattr.c b/lib/xattr.c
index 051fdd8..a9486e4 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -576,6 +576,11 @@ void erofs_clear_opaque_xattr(struct erofs_inode *inode)
 	erofs_removexattr(inode, OVL_XATTR_OPAQUE);
 }
 
+bool erofs_get_opaque_from_disk(struct erofs_inode *inode)
+{
+	return (erofs_getxattr(inode, OVL_XATTR_OPAQUE, NULL, 0) >= 0);
+}
+
 int erofs_set_origin_xattr(struct erofs_inode *inode)
 {
 	return erofs_vfs_setxattr(inode, OVL_XATTR_ORIGIN, NULL, 0);
@@ -1123,6 +1128,17 @@ char *erofs_export_xattr_ibody(struct erofs_inode *inode)
 	return buf;
 }
 
+void erofs_inode_free_xattrs(struct erofs_inode *inode)
+{
+	DBG_BUGON(inode->i_count > 0);
+
+	if (erofs_atomic_read(&inode->flags) & EROFS_I_EA_INITED) {
+		free(inode->xattr_shared_xattrs);
+		inode->xattr_shared_xattrs = NULL;
+		inode->xattr_shared_count = 0;
+	}
+}
+
 struct erofs_xattr_iter {
 	struct erofs_sb_info *sbi;
 	struct erofs_buf buf;
-- 
2.47.3


