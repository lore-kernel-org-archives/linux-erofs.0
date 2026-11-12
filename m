Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FD0606A332
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=babvZYTU
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKsn4JFtz2y8F;
	Thu, 12 Nov 2026 23:47:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::102f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487645;
	cv=none; b=n5UUTxipXLmEUOSy7iT/YaHgp83G6SHBJv56uifHRAFgkWmiT2JE9czMkdl0XrV6StvjzhTeek5Fe1VwkMxFsfvDpniTTFV8x+WGi0hOvXN7pLY4H4POVHA+c/M5fVQvyt4Xo+hemuoEb4uGyMEPllTP+4eJZeW382MKDtHc9WmUv768CH9j3N4bcvl+k60d48KGtstuC1ebtxNHYGHgg/Ghp/t3NMIasY6zyDP8Tw6LejaXEpxVIAB8R/TTmxC6O+WxQSl1LeBs9atd/rwshRZ6UI9gODk/i2uvNubROIohBfdC0lfHj+ArZe3dtLVpBuSxCgjFlbBum31zhhTBsw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487645; c=relaxed/relaxed;
	bh=QJJZh5cAUkNmDmaCBEefzS+SiAY3h1yhyXnxUhT8k5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IrZe2BQ1aGkTLJrvNgscuruKDeyGO7JSTJjVzTvDKW4Uw/k/j4rytPWPuWbLfX8skQnsv0ZQuMiFTzFJAG5shk0ZSvEl1BgSvplNgiC4Fh1K5ryYtm28gFkm8WrfOWlZOI4kKR0Z8hfginvpG1QakjY3RQZMMuFlt0lbts6F27HZr6+1LtxLbPJ9sx2yylR/grTyJBt8Xz/NoGRrUuc1T41Iavzvh5xkcPxykPRltqzh6VZqWcnI3rK/2iZ2LHfT3YzZm4rLljL0V7I0+AlnLsxlSMe14yGAyduWmGB3+11+PeNfp+Fi3krMJTwfkNUda6tsbjryxF3s7J86PFseAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=babvZYTU; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::102f; helo=mail-pj1-x102f.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=babvZYTU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102f; helo=mail-pj1-x102f.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKsm4V8Yz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:23 +1100 (AEDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-3b15e46698aso2138133a91.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487641; x=1795092441; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QJJZh5cAUkNmDmaCBEefzS+SiAY3h1yhyXnxUhT8k5g=;
        b=babvZYTU5AB1eyDjYKRKW2sBYLVZdd3UOQF2dr6HtkG6jtT1mE6CrWDFKPQkZMeRNj
         27rqNh9oVviDKEsY6Z7hboVXnDEBW3RxGxU2ZMCufq98e6f8MNTq4fdm8WG9KXSt9/Hi
         oT22da0TY04SccDlwxGkcWik4t/bAcv9D1t1BoAh3fciHcs8096G0eLgZwWuNo9FJ8Po
         V5DG6hphESLzOXOLc6CYPM8c+QUlTupX1d58SekuH9jArTs2bFu6jVwHp+/Ft4RTOugV
         RtGcRXor5ikQiuK2EJ5Y9QPJ5IC0IHcxhDlZq+HWpZgJmKjeJU4b2ZI6dqpssPdcMDcN
         CrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487641; x=1795092441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QJJZh5cAUkNmDmaCBEefzS+SiAY3h1yhyXnxUhT8k5g=;
        b=Uug+qa7w2i1ph/5tJOrFYmxHbdumD8XTghu5Zib5xC3nlN0uIdDwBHLkel223m5pqL
         x9vxYDqyzDNUCknpRAoXNLmoZ4EgbO5adVdwBRL5XiOmgfy/WnzKeLe2czjIZwUTvrmN
         9enz8y0/uJaPYBi8gsUo/dZQmqj3Y5MH6Ezftr7PRTcSe7f/ctPKCKbO+pJrup2WbzHx
         NWkK348Uvr100B3SPWaGg3QnSit4xs9FNGgg07y5pfoyOXTscsOikTAy0mqExxdEEer0
         CpMsHdJu7GkADamp2I7UT5dwLrzxIsMF1d2vZaR4VJNbClqTldgae+zwg+nh4uqqrXQd
         WF9g==
X-Gm-Message-State: APuU4Z/JGODc3KjRKeYpTUYGNWxD/M3kI5VTa82Q1qYrlUUoBi98LjpG
	41lpSN6I2yi71mAtMUprhjwxwW3h/oiJv0LIuqp6FSytHiyYBwlZ8vZM5K/IXQ==
X-Gm-Gg: AYBFou3jKqLFpKBMySpnzxIdsOocvxXBNYHDzI4cg20Vu/fFF18FY+QNzt+OaFChJAM
	ZvgazFVsBUAdJX08uPEoN9rbgI3vAEdnIvl/FMkZ0WiLhjjykl+BGjpZG8L+CooLLaQtL1ZNnuI
	l9AFDbS98Rbdr38x+sXAmRm5e1PuBF7hFgcvqbbC2dV54/DOt6CrSfwQikvi97ys6xvMue+GEDQ
	luOrBoDuReay/OPV+or9x2FUxiHoTT1NYGsX5qfSRSE4ozjEISQfNQ3owW/iTwPnN75VM8q+vrY
	4GmQ7VC+Bpviy5it1+bpoocq97o+BY7D3uNCy+/v3fPyzO6PuRKODOBGwpEaEJ5dvhNAlugyHUP
	z/nwO9xk8qyx5HF2yppw1a7+xlbK+PT+15RC8vy4LEM6yZTbsyAB+r36pCZohv/xMbCRwVkIcJe
	i/ZVsO2oPvBdU/9DNe0zejnTi0EXhAPB4nuouJAV+qNCVLEaUBl2bUg3cYgxM6KLhwJMFUoGMJf
	tUdB95xw2nKHx5WcsZ55Ha88xYhOXXpP74NYfyIe4exZSL5IuW59gspHdZOg/VRsxffW/dkjNpt
	/2unj9g4URJZOXn3YSWaVJ8dwfctMI/TRmyDkLUWC6nNYsthq+eqeALEkCgq1RatxI8LGA==
X-Received: by 2002:a17:90b:1d0c:b0:3a8:c0cd:57f3 with SMTP id 98e67ed59e1d1-3b182e6a2ecmr4662472a91.18.1794487640429;
        Thu, 12 Nov 2026 04:47:20 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c8b287sm4771020a91.15.2026.11.12.04.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:19 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH] erofs-utils: mkfs: strip overlay origin xattrs with --ovlfs-strip
Date: Thu, 12 Nov 2026 20:47:14 +0800
Message-ID: <20261112124714.2774025-1-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
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
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix --ovlfs-strip failing to remove trusted.overlay.origin from output
inodes. Also consolidate the opaque and origin xattr helpers.

Fixes: dd40232ee060 ("erofs-utils: mkfs: add `--ovlfs-strip` option")
Fixes: 8286289d1959 ("erofs-utils: lib: avoid duplicate overlay origin xattrs")
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 include/erofs/xattr.h | 16 ++++++++-----
 lib/inode.c           |  9 ++++----
 lib/rebuild.c         |  3 ++-
 lib/tar.c             |  9 ++++----
 lib/xattr.c           | 53 +++++++++++++++++++++----------------------
 5 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index 2aecf7d..c74f0ae 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -23,6 +23,11 @@ static inline unsigned int inlinexattr_header_size(struct erofs_inode *vi)
 
 struct erofs_importer;
 
+enum erofs_ovl_xattr {
+	EROFS_OVL_XATTR_OPAQUE,
+	EROFS_OVL_XATTR_ORIGIN,
+};
+
 ssize_t erofs_sys_lsetxattr(const char *path, const char *name,
 			    void *value, size_t size);
 
@@ -45,12 +50,11 @@ int erofs_setxattr(struct erofs_inode *inode, int index, const char *name,
 		   const void *value, size_t size);
 int erofs_vfs_setxattr(struct erofs_inode *inode, const char *name,
 		       const void *value, size_t size);
-bool erofs_is_opaque_xattr(const char *name);
-int erofs_set_opaque_xattr(struct erofs_inode *inode);
-void erofs_clear_opaque_xattr(struct erofs_inode *inode);
-bool erofs_get_opaque_from_disk(struct erofs_inode *inode);
-bool erofs_is_origin_xattr(const char *name);
-int erofs_set_origin_xattr(struct erofs_inode *inode);
+bool erofs_is_ovl_xattr(const char *name, enum erofs_ovl_xattr type);
+int erofs_set_ovl_xattr(struct erofs_inode *inode, enum erofs_ovl_xattr type,
+			const void *value, size_t size);
+void erofs_clear_ovl_xattr(struct erofs_inode *inode, enum erofs_ovl_xattr type);
+bool erofs_has_ovl_xattr(struct erofs_inode *inode, enum erofs_ovl_xattr type);
 int erofs_read_xattrs_from_disk(struct erofs_inode *inode);
 
 bool erofs_xattr_prefix_matches(const char *key, unsigned int *index,
diff --git a/lib/inode.c b/lib/inode.c
index e4809e9..3108aa0 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -2139,10 +2139,11 @@ static int erofs_mkfs_handle_inode(const struct erofs_mkfs_btctx *ctx,
 	}
 
 	/* strip all unnecessary overlayfs xattrs when ovlfs_strip is enabled */
-	if (params->ovlfs_strip)
-		erofs_clear_opaque_xattr(inode);
-	else if (inode->whiteouts) {
-		ret = erofs_set_origin_xattr(inode);
+	if (params->ovlfs_strip) {
+		erofs_clear_ovl_xattr(inode, EROFS_OVL_XATTR_OPAQUE);
+		erofs_clear_ovl_xattr(inode, EROFS_OVL_XATTR_ORIGIN);
+	} else if (inode->whiteouts) {
+		ret = erofs_set_ovl_xattr(inode, EROFS_OVL_XATTR_ORIGIN, NULL, 0);
 		if (ret)
 			return ret;
 	}
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 45826ff..94dc66d 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -486,7 +486,8 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
 		}
 		if (!S_ISDIR(src.i_mode))
 			goto out;
-		mergedir->opaque |= erofs_get_opaque_from_disk(&src);
+		mergedir->opaque |= erofs_has_ovl_xattr(&src,
+							EROFS_OVL_XATTR_OPAQUE);
 		erofs_inode_free_xattrs(&src);
 		inode = dir = &src;
 	} else {
diff --git a/lib/tar.c b/lib/tar.c
index 116dbfd..f5034da 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -419,11 +419,12 @@ int tarerofs_apply_xattrs(struct erofs_inode *inode, struct list_head *xattrs)
 		erofs_dbg("Recording xattr(%s)=\"%.*s\" (of %u bytes) to file %s",
 			  item->kv, vsz, v, vsz, inode->i_srcpath);
 		/* a .wh..wh..opq preceds trusted.overlay.opaque xattr  */
-		if (inode->opaque && erofs_is_opaque_xattr(item->kv))
+		if (inode->opaque &&
+		    erofs_is_ovl_xattr(item->kv, EROFS_OVL_XATTR_OPAQUE))
 			continue;
-		if (erofs_is_origin_xattr(item->kv))
+		if (erofs_is_ovl_xattr(item->kv, EROFS_OVL_XATTR_ORIGIN))
 			inode->origin = true;
-		if (erofs_is_opaque_xattr(item->kv))
+		if (erofs_is_ovl_xattr(item->kv, EROFS_OVL_XATTR_OPAQUE))
 			inode->opaque |= S_ISDIR(inode->i_mode);
 		ret = erofs_vfs_setxattr(inode, item->kv, v, vsz);
 		if (ret == -ENODATA)
@@ -1087,7 +1088,7 @@ out_eot:
 		 * needed if the tar tree is used soon, thus we have no chance
 		 * to generate it from xattrs.  No impact to mergefs.
 		 */
-		ret = erofs_set_opaque_xattr(d->inode);
+		ret = erofs_set_ovl_xattr(d->inode, EROFS_OVL_XATTR_OPAQUE, "y", 1);
 		goto out;
 	} else if (th->typeflag == '1') {	/* hard link cases */
 		struct erofs_dentry *d2;
diff --git a/lib/xattr.c b/lib/xattr.c
index 8e98c1e..5086ee3 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -508,9 +508,9 @@ static int read_xattrs_from_file(struct erofs_sb_info *sbi, const char *path,
 		}
 
 		if (inode) {
-			if (erofs_is_origin_xattr(key))
+			if (erofs_is_ovl_xattr(key, EROFS_OVL_XATTR_ORIGIN))
 				inode->origin = true;
-			if (erofs_is_opaque_xattr(key))
+			if (erofs_is_ovl_xattr(key, EROFS_OVL_XATTR_OPAQUE))
 				inode->opaque |= S_ISDIR(inode->i_mode);
 			ret = erofs_inode_xattr_add(&inode->i_xattrs, item);
 			if (ret < 0)
@@ -597,41 +597,40 @@ static void erofs_removexattr(struct erofs_inode *inode, const char *key)
 	}
 }
 
-bool erofs_is_opaque_xattr(const char *name)
-{
-	return !strcmp(name, OVL_XATTR_OPAQUE);
-}
+static const char * const erofs_ovl_xattr_names[] = {
+	[EROFS_OVL_XATTR_OPAQUE] = OVL_XATTR_OPAQUE,
+	[EROFS_OVL_XATTR_ORIGIN] = OVL_XATTR_ORIGIN,
+};
 
-int erofs_set_opaque_xattr(struct erofs_inode *inode)
+bool erofs_is_ovl_xattr(const char *name, enum erofs_ovl_xattr type)
 {
-	if (inode->opaque)
-		return 0;
-	inode->opaque = true;
-	return erofs_vfs_setxattr(inode, OVL_XATTR_OPAQUE, "y", 1);
+	return !strcmp(name, erofs_ovl_xattr_names[type]);
 }
 
-void erofs_clear_opaque_xattr(struct erofs_inode *inode)
+int erofs_set_ovl_xattr(struct erofs_inode *inode, enum erofs_ovl_xattr type,
+			const void *value, size_t size)
 {
-	erofs_removexattr(inode, OVL_XATTR_OPAQUE);
-	inode->opaque = false;
-}
+	bool *flag = type == EROFS_OVL_XATTR_OPAQUE ?
+			&inode->opaque : &inode->origin;
 
-bool erofs_get_opaque_from_disk(struct erofs_inode *inode)
-{
-	return (erofs_getxattr(inode, OVL_XATTR_OPAQUE, NULL, 0) >= 0);
+	if (*flag)
+		return 0;
+	*flag = true;
+	return erofs_vfs_setxattr(inode, erofs_ovl_xattr_names[type], value, size);
 }
 
-bool erofs_is_origin_xattr(const char *name)
+void erofs_clear_ovl_xattr(struct erofs_inode *inode, enum erofs_ovl_xattr type)
 {
-	return !strcmp(name, OVL_XATTR_ORIGIN);
+	bool *flag = type == EROFS_OVL_XATTR_OPAQUE ?
+			&inode->opaque : &inode->origin;
+
+	erofs_removexattr(inode, erofs_ovl_xattr_names[type]);
+	*flag = false;
 }
 
-int erofs_set_origin_xattr(struct erofs_inode *inode)
+bool erofs_has_ovl_xattr(struct erofs_inode *inode, enum erofs_ovl_xattr type)
 {
-	if (inode->origin)
-		return 0;
-	inode->origin = true;
-	return erofs_vfs_setxattr(inode, OVL_XATTR_ORIGIN, NULL, 0);
+	return erofs_getxattr(inode, erofs_ovl_xattr_names[type], NULL, 0) >= 0;
 }
 
 #ifdef WITH_ANDROID
@@ -714,7 +713,7 @@ int erofs_read_xattrs_from_disk(struct erofs_inode *inode)
 		void *value = NULL;
 		size_t size = 0;
 
-		if (!strcmp(key, OVL_XATTR_OPAQUE)) {
+		if (erofs_is_ovl_xattr(key, EROFS_OVL_XATTR_OPAQUE)) {
 			if (!S_ISDIR(inode->i_mode)) {
 				erofs_dbg("file %s: opaque xattr on non-dir",
 					  inode->i_srcpath);
@@ -743,7 +742,7 @@ int erofs_read_xattrs_from_disk(struct erofs_inode *inode)
 			DBG_BUGON(ret != size);
 		}
 
-		if (erofs_is_origin_xattr(key))
+		if (erofs_is_ovl_xattr(key, EROFS_OVL_XATTR_ORIGIN))
 			inode->origin = true;
 		ret = erofs_vfs_setxattr(inode, key, value, size);
 		free(value);
-- 
2.56.0


