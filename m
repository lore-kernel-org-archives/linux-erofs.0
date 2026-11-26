Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BA2606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=P/oFPnYd
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCc0BpCz2yQl;
	Thu, 26 Nov 2026 23:02:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694555;
	cv=none; b=HaDR3ht9iy6Mxqtljjg72PY12EdlYm1NXtq3rHhrl6Amu/V1Cs90fb5ellH/uU98dg3Uk43Zq1mCc4OvPLx92m0wGbh+XHwuz8ZBljJFXQegejUboo7XpeAADlemiebMQZTyYpSvUtlsVtaVDJpNMoOIUeds4mMax5+KdLZIAZAcG4vYNoMOyv76KXCkFrNUQUVWoA7bKyYP60GluwVDxgBLqNMJlfDNo5wbKrIkVGSCyFtSH9jFEwcrgx180xf0QTGB12G0LJi6dAdaw6g3MVoQ/ZR+BrCziamteRpiIQt0aLThCbDvbqKa+YbmXots4TXnXQf9uVZoErKqKSvpig==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694555; c=relaxed/relaxed;
	bh=eU1Gu/pn2yfIUjKfHH254ZG38yJu180IEpSWJtuiy+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK5Zv3M1i4LNS9ReLY0gRek7ET88zei3WJZdeqga9cKom0xA87+9d48TmYz2Y0VSB104foxrg6Cwr621SvTxNAPvRF7VY2CSP1MYckPVCWkp2/qBM0cuoz2vb3c1/10mW/2uK+RoYxBtk1KeqnJVKCMdLNuWTICLGU7sanoFLPFpXVIQxRlZQfrKtBT5sgYVElnLaJ+Vrf4NWc1aih51AxkStPsct4oB33EzeyZRnllI4o1x0flDK3OUTG7C2ln86T06JzTWSzDjt32V1ioeOg/lr+YPloWlDK2d2E0P83RAcqRUh6O1Z96iagCvQqR5dloJx2OPBO0UuVDW+XsKqQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=P/oFPnYd; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32b; helo=mail-wm1-x32b.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=P/oFPnYd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32b; helo=mail-wm1-x32b.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCb0znVz2yLY
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:35 +1100 (AEDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-4bba60271d7so15604055e9.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694552; x=1796299352; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eU1Gu/pn2yfIUjKfHH254ZG38yJu180IEpSWJtuiy+Q=;
        b=P/oFPnYdyPGNXlCqEbmcJDMGw1Kl9Iy7dKcbBOhPt8K/sbyVW2ppJhFDt4kfe6toU2
         LExnxNUy3fWygtydSRO3lXS98tsIP3nkScd+bZuRQLMLhmeSq2paCjqyDCoBnl4OZ5O2
         aWPys0EKIaQGf1jQItCit0fUcgtHuoNGPNeFfylq8GwRYKNnVGF6vb2z0Ogfa/CtNJZt
         M3qNSPEZjPGPME6UCRazY+2KQSFM6it3AUB8jDRoP4IjlxnDNt7unz++ZfKdIZgBCysB
         /gBsylRWiMTgzBhUOITvVCjZ+z7jUDVROvrmCeI475wJ9UV2aI8WDcKYRr/dPMIFIimq
         Ex5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694552; x=1796299352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eU1Gu/pn2yfIUjKfHH254ZG38yJu180IEpSWJtuiy+Q=;
        b=KCzzkPQpImIvoGoYFauDB2oPFDpnMp9Hbq7+lZB1zawUQ7V9XwEsJovobZbKMhHP7J
         ItQs7zDTJ1GVxZMd3gwl7HC92HcdnS+SntQplUN+bqrC28nKKMk8d/mQws9e6zqcmpVz
         tqBwVD4HRQJ55/sQvMcqAkzYWtytPtrcwFd1Eqm7fG6aSyNGE9X2JUZOJqGVhsS4NwaF
         bgVofa8Z2Jy5wGqdHBYKp/e7UYeKwCHdwWV9aQmDyWftTezbwXDjgp1RBzPeaX6RrlZJ
         oOb/KAdkNdO2VcD2dHKRDeebM/O32xCVfo+VSso6uPSrgO8Y8ifTWZCo6JDWDq/kYyYc
         nozQ==
X-Gm-Message-State: APuU4Z+zftIiXekP1jL0iLICnC5srWoElZLOx2XZCSmwaJ4hX2ktsFYc
	thFSHIRpwfP9cHioXKheNgvs8WbSUS9jvAFAl7ObQRlMCNNeOXf8RBts+E/kaAeZyD7gpchnnuH
	ZOn9iDUk=
X-Gm-Gg: AZFdTZcSmhABT/pqqt8xnu0FZEnZwXmy0gDoxQPZAe5rp4/xC1wxoBUl0O63Sl8TLEl
	2p+cgvOXOTpjttrpibDHz3Fjc4R1EqmxmColk/OOKX1uo9dmHmFebxV2jCncMYt6j698f5wAUxZ
	1zBKh0sK8r7I1X6qMR7Rs1YPyP3WeQoyfYpDOk7FRDAGVuojHbVMW/crTwrDMF+KWyA0LTJIa4z
	v0B8Dy7yAg0vo5BUtDM3PCrR73/WrEf9QwVuoYmevdrConG6HCttPScKbBQvbyK6QfekrexXgmK
	dvjW3/MxrZmDshMmuYVol2Ql1WGLtwcIS2awZspfPAox5dN9Pq4XK9RFB5k8kHvrNdGuQipvbv/
	psLiV+27oPjcRtQ74KQ5d4f0MQzTMHOrjq84rPxpTjY/SNWXBLaOqtASzX5zqrXbrx2m+iNpHN/
	IJWTkRL+do1cMrxCFES+RPNlA4oXVZcd+PIExbtLtpA/BheLIPvFiSHjpJjYElVjf7t9A9IUJWB
	YFlQ0vqV7U4IFNI7gvkLscSsvzupHPdYfZYIshhbedl7+fxVw4yn/Z35qGyNt+4vgF6gF22arXc
	rTOIShmfTxsnP27VUp88axEbzpHVpADmcgfAD4QLEglp/lho/gDcmpmh8pd9600BruyFK7k1+eO
	QkaPYUykWjw+HlA==
X-Received: by 2002:a05:600c:848d:b0:4bb:6687:5386 with SMTP id 5b1f17b1804b1-4bb8880c7f1mr445116665e9.19.1795694551841;
        Thu, 26 Nov 2026 04:02:31 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:31 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 06/10] erofs-utils: lib: introduce erofs_rebuild_params
Date: Thu, 26 Nov 2026 13:02:17 +0100
Message-ID: <20261126120221.4384-6-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261126120221.4384-1-xiang.gao@docker.com>
References: <20261126120221.4384-1-xiang.gao@docker.com>
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Group the merged tree root, source superblock and data import mode in
struct erofs_rebuild_params and pass it to erofs_rebuild_load_tree().
Share these parameters with recursive directory iteration and inode
updates, using mergeroot->sbi instead of g_sbi for the destination.

Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/liberofs_rebuild.h |  9 +++++++--
 lib/rebuild.c          | 27 +++++++++++++--------------
 mkfs/main.c            | 15 ++++++++-------
 3 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/lib/liberofs_rebuild.h b/lib/liberofs_rebuild.h
index 6459dbd..2cf228e 100644
--- a/lib/liberofs_rebuild.h
+++ b/lib/liberofs_rebuild.h
@@ -10,11 +10,16 @@ enum erofs_rebuild_datamode {
 	EROFS_REBUILD_DATA_FULL,
 };
 
+struct erofs_rebuild_params {
+	struct erofs_inode *mergeroot;
+	struct erofs_sb_info *sbi;
+	enum erofs_rebuild_datamode datamode;
+};
+
 struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 		char *path, bool aufs, bool *whout, bool *opq, bool to_head);
 
-int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
-			    enum erofs_rebuild_datamode mode);
+int erofs_rebuild_load_tree(struct erofs_rebuild_params *params);
 
 int erofs_rebuild_load_basedir(struct erofs_inode *dir, u64 *nr_subdirs,
 			       unsigned int *i_nlink);
diff --git a/lib/rebuild.c b/lib/rebuild.c
index e83fd52..6a4aff6 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -389,10 +389,11 @@ static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
 	return err;
 }
 
-static int erofs_rebuild_update_inode(struct erofs_sb_info *dst_sb,
-				      struct erofs_inode *inode,
-				      enum erofs_rebuild_datamode datamode)
+static int erofs_rebuild_update_inode(struct erofs_rebuild_params *params,
+				      struct erofs_inode *inode)
 {
+	struct erofs_sb_info *dst_sb = params->mergeroot->sbi;
+	enum erofs_rebuild_datamode datamode = params->datamode;
 	int err = 0;
 
 	switch (inode->i_mode & S_IFMT) {
@@ -450,8 +451,7 @@ struct erofs_rebuild_dir_context {
 	struct erofs_dir_context ctx;
 	struct erofs_inode *mergedir;	/* parent directory in the merged tree */
 	union {
-		/* indicate how to import inode data */
-		enum erofs_rebuild_datamode datamode;
+		struct erofs_rebuild_params *params;
 		struct {
 			u64 *nr_subdirs;
 			unsigned int *i_nlink;
@@ -581,8 +581,7 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
 			inode->i_ino[1] = inode->nid;
 			inode->i_nlink = 1;
 
-			ret = erofs_rebuild_update_inode(&g_sbi, inode,
-							 rctx->datamode);
+			ret = erofs_rebuild_update_inode(rctx->params, inode);
 			if (ret) {
 				erofs_iput(inode);
 				goto out;
@@ -607,17 +606,17 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
 	}
 
 	/* reset sbi, nid after subdirs are all loaded for the final dump */
-	inode->sbi = &g_sbi;
+	inode->sbi = rctx->params->mergeroot->sbi;
 	inode->nid = EROFS_NID_UNALLOCATED;
 out:
 	free(path);
 	return ret;
 }
 
-int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
-			    enum erofs_rebuild_datamode mode)
+int erofs_rebuild_load_tree(struct erofs_rebuild_params *params)
 {
-	struct erofs_sb_info *dst_sbi = root->sbi;
+	struct erofs_sb_info *dst_sbi = params->mergeroot->sbi;
+	struct erofs_sb_info *sbi = params->sbi;
 	struct erofs_inode inode = {};
 	struct erofs_rebuild_dir_context ctx;
 	char uuid_str[37];
@@ -635,7 +634,7 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 		return ret;
 	}
 
-	if (mode == EROFS_REBUILD_DATA_BLOB_INDEX) {
+	if (params->datamode == EROFS_REBUILD_DATA_BLOB_INDEX) {
 		if (erofs_sb_has_ztailpacking(sbi))
 			erofs_sb_set_ztailpacking(dst_sbi);
 		if (erofs_sb_has_dedupe(sbi))
@@ -664,8 +663,8 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 	ctx = (struct erofs_rebuild_dir_context) {
 		.ctx.dir = &inode,
 		.ctx.cb = erofs_rebuild_dirent_iter,
-		.mergedir = root,
-		.datamode = mode,
+		.mergedir = params->mergeroot,
+		.params = params,
 	};
 	ret = erofs_iterate_dir(&ctx.ctx, false);
 	free(inode.i_srcpath);
diff --git a/mkfs/main.c b/mkfs/main.c
index 22ef23d..ce93166 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1688,17 +1688,17 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 	unsigned int extra_devices = 0;
 	erofs_blk_t nblocks;
 	int ret, idx;
-	enum erofs_rebuild_datamode datamode;
+	struct erofs_rebuild_params params = { .mergeroot = root };
 
 	switch (dataimport_mode) {
 	case EROFS_MKFS_DATA_IMPORT_DEFAULT:
-		datamode = EROFS_REBUILD_DATA_BLOB_INDEX;
+		params.datamode = EROFS_REBUILD_DATA_BLOB_INDEX;
 		break;
 	case EROFS_MKFS_DATA_IMPORT_FULLDATA:
-		datamode = EROFS_REBUILD_DATA_FULL;
+		params.datamode = EROFS_REBUILD_DATA_FULL;
 		break;
 	case EROFS_MKFS_DATA_IMPORT_RVSP:
-		datamode = EROFS_REBUILD_DATA_RESVSP;
+		params.datamode = EROFS_REBUILD_DATA_RESVSP;
 		break;
 	default:
 		return -EINVAL;
@@ -1706,7 +1706,8 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 
 	list_for_each_entry(src, &rebuild_src_list, list) {
 		src->xamgr = g_sbi.xamgr;
-		ret = erofs_rebuild_load_tree(root, src, datamode);
+		params.sbi = src;
+		ret = erofs_rebuild_load_tree(&params);
 		src->xamgr = NULL;
 		if (ret) {
 			erofs_err("failed to load %s", src->dif0.src_path);
@@ -1720,7 +1721,7 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		extra_devices += src->extra_devices;
 	}
 
-	if (datamode == EROFS_REBUILD_DATA_RESVSP)
+	if (params.datamode == EROFS_REBUILD_DATA_RESVSP)
 		return 0;
 
 	/* Each blob has either no extra device or only one device for TarFS */
@@ -1730,7 +1731,7 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		return -EOPNOTSUPP;
 	}
 
-	if (datamode == EROFS_REBUILD_DATA_FULL)
+	if (params.datamode == EROFS_REBUILD_DATA_FULL)
 		return 0;
 
 	ret = erofs_mkfs_init_devices(&g_sbi, rebuild_src_count);
-- 
2.54.0 (Apple Git-157)


