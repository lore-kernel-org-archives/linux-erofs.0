Return-Path: <linux-erofs+bounces-4408-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 318A2C61DD3
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 02:52:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZS1t3WtXz2xlv;
	Wed, 02 Sep 2026 12:52:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788317538;
	cv=none; b=oV4aKYacHvfLVmEMo7A0qvZ0wi+4oJyAhY5pIOs5vaQXkOTvNUv0xlz21xk2Pbq1Gdc71bXWZxIQQAaESjA/Wvmg5KO5i1OgA5Mc0144//DRNq7fksXEuF4jGL7s2ablSqma4f65Rkxe3FSUQGKTlft2JYkrvJGNMRQW+4sevkoDqdgDUO38liuUG0+iga9HNowqpdHXhy+3dv90HYG/UQOQeZrXYTbkNVKWhPFadEfRVknG5/tnYr8Y2o8UWO8CBQF6oyks5j5nqjphUl8Gm+xB/ys4wGczPd+51Zd9/XmFiRq2WK+NdGyhHocV6Ezhan8mRUfaiXDcVGIQC3nTug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788317538; c=relaxed/relaxed;
	bh=FcccmZ5i5Xo1t3SrDgpyCqCJsJd4e3Juz3EwO8RVby4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLjxmU87+z2pBK8NzsjJgp/XxCJ/DbQwoVzPlf1y1UGInReKZ8VBIBHjaGMlYImnqXdADJVZXMYnk0LytLXuznaa8oDTGf01FpEncYy3HQvS7PpXjUuJyaK4z4cLi6rEd8Vl55PoA21725++0jopm2ssaw6a8ANsgFc0iNs8OFole5H+a/amP9rgYyRZ1jnU4WWoQ8xRoQLAyEilYynLPp1geerLZrq7JnGUYJ0STuYIt7FKyRioZhSuf/qMrkOJpls9u8RIoYhTG6TdzNl2pzcHRjvz/ruM7uKNdqJ1Mu92RgXgvj3pu5hVat6xw9CT22PC9Lsorog+hRcd0/zcWQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eJcLiStO; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eJcLiStO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZS1r3qLCz2x9g
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 12:52:16 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2CE6600D9;
	Wed,  2 Sep 2026 02:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271F51F00A3A;
	Wed,  2 Sep 2026 02:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788317534;
	bh=FcccmZ5i5Xo1t3SrDgpyCqCJsJd4e3Juz3EwO8RVby4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJcLiStOkI3KxRVel4+jk+/GAoGu19reEc6V6oqmawu8LcKs0/z1Qc3jlBkVogVJD
	 LCnx1Al6FCN7Sh21iGhmNw4mi1q/9DSwXy9qt8UQ+z3CczCKtMF/ch6aFAU9Phf2jp
	 5JHcQyEexcfCj/ZysU4IVzzahJM4YnfcI9Zajdfra5Maidx1pxY1q0VtTNjkwQEVEG
	 9n5xsJlShsyqK4hWOel4K26eveWQEEdCBHjymTSXMxcVTEIpCkviJwZn1mWmmJ1vX8
	 VlerJAHDpkg/YswL7HkegCpssMnwRplDrH24K3ka/easvXnBBcyyS2huz67WgvQfXw
	 /k5C3nkL4MDZg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 2/5] erofs-utils: lib: unexport "erofs/chunk.h"
Date: Wed,  2 Sep 2026 10:50:27 +0800
Message-ID: <20260902025031.50499-2-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902025031.50499-1-xiang@kernel.org>
References: <20260902025031.50499-1-xiang@kernel.org>
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

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/Makefile.am                                   | 2 +-
 lib/blobchunk.c                                   | 4 ++--
 lib/inode.c                                       | 2 +-
 include/erofs/blobchunk.h => lib/liberofs_chunk.h | 4 ++--
 lib/rebuild.c                                     | 2 +-
 lib/remotes/s3.c                                  | 2 +-
 lib/super.c                                       | 2 ++
 lib/tar.c                                         | 2 +-
 mkfs/main.c                                       | 3 +--
 9 files changed, 12 insertions(+), 11 deletions(-)
 rename include/erofs/blobchunk.h => lib/liberofs_chunk.h (92%)

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 25d08f2..0a82915 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -2,7 +2,6 @@
 
 noinst_LTLIBRARIES = liberofs.la
 noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
-      $(top_srcdir)/include/erofs/blobchunk.h \
       $(top_srcdir)/include/erofs/block_list.h \
       $(top_srcdir)/include/erofs/config.h \
       $(top_srcdir)/include/erofs/decompress.h \
@@ -23,6 +22,7 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/include/erofs/importer.h \
       $(top_srcdir)/lib/liberofs_base64.h \
       $(top_srcdir)/lib/liberofs_cache.h \
+      $(top_srcdir)/lib/liberofs_chunk.h \
       $(top_srcdir)/lib/liberofs_compress.h \
       $(top_srcdir)/lib/liberofs_fragments.h \
       $(top_srcdir)/lib/liberofs_private.h \
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 480629f..d218b38 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -6,10 +6,10 @@
  */
 #define _GNU_SOURCE
 #include "erofs/print.h"
-#include "erofs/blobchunk.h"
 #include "erofs/block_list.h"
 #include "erofs/importer.h"
 #include "liberofs_cache.h"
+#include "liberofs_chunk.h"
 #include "liberofs_private.h"
 #include "liberofs_sha256.h"
 #include <unistd.h>
@@ -665,7 +665,7 @@ err_out:
 	return ret;
 }
 
-int erofs_blob_exit(struct erofs_sb_info *sbi)
+int erofs_chunkmgr_exit(struct erofs_sb_info *sbi)
 {
 	struct erofs_chunkmgr *cmgr = sbi->chunkmgr;
 	struct erofs_chunkitem *bc, *n;
diff --git a/lib/inode.c b/lib/inode.c
index a69439c..ea3277b 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -23,9 +23,9 @@
 #include "erofs/exclude.h"
 #include "erofs/block_list.h"
 #include "erofs/compress_hints.h"
-#include "erofs/blobchunk.h"
 #include "erofs/importer.h"
 #include "liberofs_cache.h"
+#include "liberofs_chunk.h"
 #include "liberofs_compress.h"
 #include "liberofs_fragments.h"
 #include "liberofs_metabox.h"
diff --git a/include/erofs/blobchunk.h b/lib/liberofs_chunk.h
similarity index 92%
rename from include/erofs/blobchunk.h
rename to lib/liberofs_chunk.h
index 1c8d77d..3af88df 100644
--- a/include/erofs/blobchunk.h
+++ b/lib/liberofs_chunk.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ OR MIT */
 /*
- * erofs-utils/lib/blobchunk.h
+ * erofs-utils/lib/liberofs_chunk.h
  *
  * Copyright (C) 2021, Alibaba Cloud
  */
@@ -25,10 +25,10 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 int erofs_write_zero_inode(struct erofs_inode *inode);
 int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset);
 int erofs_mkfs_dump_blobs(struct erofs_sb_info *sbi);
-int erofs_blob_exit(struct erofs_sb_info *sbi);
 int erofs_blob_init(struct erofs_sb_info *sbi, int blobdev_id,
 		    unsigned int chunkbits_def);
 int erofs_blob_init_device(struct erofs_sb_info *sbi, int device_id);
+int erofs_chunkmgr_exit(struct erofs_sb_info *sbi);
 
 #ifdef __cplusplus
 }
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 55681f9..38ced3c 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -12,9 +12,9 @@
 #include "erofs/inode.h"
 #include "erofs/dir.h"
 #include "erofs/xattr.h"
-#include "erofs/blobchunk.h"
 #include "erofs/internal.h"
 #include "erofs/io.h"
+#include "liberofs_chunk.h"
 #include "liberofs_rebuild.h"
 #include "liberofs_uuid.h"
 
diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index 245efe5..b3352df 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -15,7 +15,7 @@
 #include "erofs/internal.h"
 #include "erofs/print.h"
 #include "erofs/inode.h"
-#include "erofs/blobchunk.h"
+#include "../liberofs_chunk.h"
 #include "erofs/diskbuf.h"
 #include "erofs/importer.h"
 #include "liberofs_rebuild.h"
diff --git a/lib/super.c b/lib/super.c
index 98e1711..9e52dd8 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -7,6 +7,7 @@
 #include "erofs/print.h"
 #include "erofs/xattr.h"
 #include "liberofs_cache.h"
+#include "liberofs_chunk.h"
 #include "liberofs_compress.h"
 #include "liberofs_metabox.h"
 
@@ -185,6 +186,7 @@ int erofs_read_superblock(struct erofs_sb_info *sbi)
 
 void erofs_put_super(struct erofs_sb_info *sbi)
 {
+	erofs_chunkmgr_exit(sbi);
 	if (sbi->devs) {
 		int i;
 
diff --git a/lib/tar.c b/lib/tar.c
index cf60b02..cbe9f40 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -9,7 +9,6 @@
 #include "erofs/list.h"
 #include "erofs/tar.h"
 #include "erofs/xattr.h"
-#include "erofs/blobchunk.h"
 #include "erofs/importer.h"
 #if defined(HAVE_SYS_SYSMACROS_H)
 #include <sys/sysmacros.h>
@@ -19,6 +18,7 @@
 #endif
 #include "liberofs_base64.h"
 #include "liberofs_cache.h"
+#include "liberofs_chunk.h"
 #include "liberofs_gzran.h"
 #include "liberofs_rebuild.h"
 #include "liberofs_sha256.h"
diff --git a/mkfs/main.c b/mkfs/main.c
index b6d215b..8da3753 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -24,8 +24,8 @@
 #include "erofs/exclude.h"
 #include "erofs/block_list.h"
 #include "erofs/compress_hints.h"
-#include "erofs/blobchunk.h"
 #include "../lib/compressor.h"
+#include "../lib/liberofs_chunk.h"
 #include "../lib/liberofs_gzran.h"
 #include "../lib/liberofs_metabox.h"
 #include "../lib/liberofs_oci.h"
@@ -2084,7 +2084,6 @@ exit:
 		fclose(blklst);
 	erofs_cleanup_compress_hints();
 	erofs_cleanup_exclude_rules();
-	erofs_blob_exit(&g_sbi);
 	erofs_xattr_cleanup_name_prefixes();
 	erofs_rebuild_cleanup();
 	erofs_diskbuf_exit();
-- 
2.47.3


