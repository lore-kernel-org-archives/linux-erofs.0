Return-Path: <linux-erofs+bounces-4676-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A89CA5FFF
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 20:49:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0QGQ5z4Yz30V4;
	Thu, 08 Oct 2026 07:49:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791406158;
	cv=none; b=V5zMZvcN0Ri1TLSHXyqXY9DEdio67FnRcWR2wM/zelnVYNQKFqHMgbvgPLOtdHaAza+IQlRCsYwQYlJENLIzDEm7zu1zqr65XCQ30pmDvlC0i5JzZob5lu0PGV6G83KwRPCAkrUipni3QEiOFOfcECI2Y4Ckbp8puggqkMllpVsghZ2nN68eGgSuI59WssTcsWvJnyMYNf+XL01Yb7R/L1QWJel5RF/2bliQFyTnG55xpfSvOiTqwXoSkC1fxVpGH0p0Ifxxypntet15+kUWA1iMsHgrclcDXvi2kq1c47WJhDS+OCSUJ0345/nEZt14Fcybv2twBSauLZwYh+/36A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791406158; c=relaxed/relaxed;
	bh=mm/wA8JZXXMTJCWyor6e/eIAv2QK35rHsp8UcwmND9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TchgA3mz35YS6tZv5E0OvRgaqY4LNq7VGAb11y/RFp00tnsTY8JXd7moqXamlg9E0lXAWYKfFYBvTVjQYblUC682lzYiYusxe7t9u5mPLv/UYCksLcaXC+LOZYG1WBaNg+WVyEVB128XUnNBJv+1Q1NVrZbN5Ej3A367iQlrBgU3oiEtyuw94enssitq3GOyxKgd0IBA0HC4i/iXjhW+slGrwbL0KaFPhD5v3kW+K32VzsBYoBBRkn4TJ9IKVjRaaMl7r7020zJ7gX9EhjiFN7xj7g6cAWp581eTdbFLGr23lPFzfWleQw4jQ6tnU7gt/qvDCoPodyBpquTRFHPJgw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U+eV8OSk; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U+eV8OSk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0QGP75NGz30Nl
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 07:49:17 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D3C14366D
	for <linux-erofs@lists.ozlabs.org>; Wed,  7 Oct 2026 20:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD2D1F000FF;
	Wed,  7 Oct 2026 20:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791406155;
	bh=mm/wA8JZXXMTJCWyor6e/eIAv2QK35rHsp8UcwmND9A=;
	h=From:To:Cc:Subject:Date;
	b=U+eV8OSkwW3S9pWRz0qU2V0iqJRY0njHc9rtWY93SkxtHDd25lcrl+xinreHE5lzZ
	 Cn7jvxZ2rZL/OgnPCHw9gtU8Anx4LgUbxOwl7O1JpiWUSeByQ+oVCnacqMfgcQ8cLX
	 ixmGC8SR9TeEUw+AHuQpErYVlY2BgMcat/0uCWtdiyUIgmsEcZE6OSyFnEgZU2mxF9
	 d384NQMYiYnVghjNwJ++aqxmRd9sgkdFDVsGHJalpjBKoa2RnQ7fRwJXw0J4c/0WZv
	 qQ9afsDEQnxDGH9nT3gw6V6Bs2pkdbeQMHPA1SojHAWI6OrZyTug8QPVF3tGGhgh9/
	 P1v11Z3xk9wLw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH 1/2] erofs-utils: lib: get rid of unused erofs_ftype_to_dtype()
Date: Wed,  7 Oct 2026 22:49:08 +0200
Message-ID: <20261007204909.19426-1-xiang@kernel.org>
X-Mailer: git-send-email 2.50.1
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

It has been unused since commit 9fd2a2250fa9 ("erofs-utils: fuse: switch
to FUSE 2/3 lowlevel APIs").

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/inode.h |  1 -
 lib/inode.c           | 19 -------------------
 2 files changed, 20 deletions(-)

diff --git a/include/erofs/inode.h b/include/erofs/inode.h
index 23848e8..5b67b95 100644
--- a/include/erofs/inode.h
+++ b/include/erofs/inode.h
@@ -28,7 +28,6 @@ struct erofs_importer;
 u32 erofs_new_encode_dev(dev_t dev);
 unsigned char erofs_mode_to_ftype(umode_t mode);
 umode_t erofs_ftype_to_mode(unsigned int ftype, unsigned int perm);
-unsigned char erofs_ftype_to_dtype(unsigned int filetype);
 void erofs_inode_manager_init(void);
 void erofs_insert_ihash(struct erofs_inode *inode);
 void erofs_remove_ihash(struct erofs_inode *inode);
diff --git a/lib/inode.c b/lib/inode.c
index d819659..da29b5a 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -54,17 +54,6 @@ unsigned char erofs_mode_to_ftype(umode_t mode)
 	return erofs_ftype_by_mode[(mode & S_IFMT) >> S_SHIFT];
 }
 
-static const unsigned char erofs_dtype_by_ftype[EROFS_FT_MAX] = {
-	[EROFS_FT_UNKNOWN]	= DT_UNKNOWN,
-	[EROFS_FT_REG_FILE]	= DT_REG,
-	[EROFS_FT_DIR]		= DT_DIR,
-	[EROFS_FT_CHRDEV]	= DT_CHR,
-	[EROFS_FT_BLKDEV]	= DT_BLK,
-	[EROFS_FT_FIFO]		= DT_FIFO,
-	[EROFS_FT_SOCK]		= DT_SOCK,
-	[EROFS_FT_SYMLINK]	= DT_LNK
-};
-
 static const umode_t erofs_dtype_by_umode[EROFS_FT_MAX] = {
 	[EROFS_FT_UNKNOWN]	= S_IFMT,
 	[EROFS_FT_REG_FILE]	= S_IFREG,
@@ -84,14 +73,6 @@ umode_t erofs_ftype_to_mode(unsigned int ftype, unsigned int perm)
 	return erofs_dtype_by_umode[ftype] | perm;
 }
 
-unsigned char erofs_ftype_to_dtype(unsigned int filetype)
-{
-	if (filetype >= EROFS_FT_MAX)
-		return DT_UNKNOWN;
-
-	return erofs_dtype_by_ftype[filetype];
-}
-
 static struct list_head erofs_ihash[65536];
 static erofs_rwsem_t erofs_ihashlock;
 
-- 
2.50.1 (Apple Git-155)


