Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB2A606A31C
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 01:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=HdqD9DhY
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTkrL42swz2y8p;
	Wed, 18 Nov 2026 12:42:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::336"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794966178;
	cv=none; b=Mglefe7vavGrJQbF1OXnjuK2lsfw86ts4qAJE8ElkNDu549yyYFsTO+TiuwdkRS7Zf2enXBEtnBJYvyOqZLR/z3J9p19v17HUBENLub+IlrpPQMOXvsQxsunjw870VAbxFKBqXbLTcCdIHSgglx/aPp4TZRGdANBoOqb6dmvu3agBJdBcBDGNqAJzE4GVvBBWIGWJdRTYxTqx/A36ztLyVf8TLt9m+c9M0N1K6+FvXUcHPpxoaplHFUgCObi7VvJCVIiVpKALWi+y+84j23lPQ+G0WVSkN07jrJ92fbi1zzaAKkpljzp1CFmnfIdZ5ZYYlEwO4Xo6qnmp1+VyyANeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794966178; c=relaxed/relaxed;
	bh=gp0vZR37rY2YlAFNRQBKMIX882vhSBK+kpXfac/WX38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAMWbU8nSA+ncTD8QECURePsP4iFpntLYfhKMxr3h4Qaj1r9iQWCSgSpg+TqrrKgb3vqG3ES9LMXzPVYKsvVsa79GCXI9exiBLSjHJjp4kI/ce78jpiLC0gAFy/2ik+1mul+TC/2bgKYkbVfzB0yoTwWRN71KW/1TgB53mCeH1KB0yrhZj8KH69Dy+eIp4d2IPTwXZd1CR5Q3P3zh7/fT4NwKV9Lb3wHVBp9FNJmxmk4xRBWlfwHopJkcUuO65iY5YeyTu4tFDcHQPWk4CKf+iymohEDTngigamKNtxfDX6nwwx9LAo3+GwPpvxLwjFgTN/IkKzDwPP2UoTwOXpOAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=HdqD9DhY; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=HdqD9DhY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTkrK2MKxz2xlY
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 12:42:57 +1100 (AEDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so4522085e9.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 17:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1794966174; x=1795570974; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gp0vZR37rY2YlAFNRQBKMIX882vhSBK+kpXfac/WX38=;
        b=HdqD9DhYMbcPbskLbUJj5joEhftswRRt/RYu63PNeNZkro5KLmq3TVYgU2Ev4YXPVS
         vmBUWFSnm5p6iTJVXyTwkah8qGMt7+FpSDpZFUjQoQY6KtY++22JqgeUK+u5PofAYdtd
         k/FyxFU4dBdXlOEqEbVCub/p2T0D5fH/0Fnhv+8E0uzQEMhwf5BAw10wekkYZQnB+sAf
         ZAGcx9PBD3yb3waoV5OorJLAt613qPKJ9K3SrZnTSHlJ1TP0DTrbCgoGM1cxQNJDRRm3
         uCX2tMfaPqu/swUJJpaYsh4nm+usiHxUrZ0v0AlyJPqdMKCJJQssnwAEN4Nbs3tI1UDL
         qZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794966174; x=1795570974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gp0vZR37rY2YlAFNRQBKMIX882vhSBK+kpXfac/WX38=;
        b=UqwpEe1tEI9Ws6rspNn2Lh+zwaRUdo3nnhqro0OMPLB21tV+hAZniK8zOkOSzoxGJx
         hu+1jVeKviez7hjQCelT7x7RoMjg85X6mAtEzL3oGLoq/mDkdoAMt2ZLh2lWx6CtoggP
         0KKS/i57ESNbXnkIi6R4ZakO1l3ILeJXYTfNybupOb2xqR5MvsZuUqaLbtXjXe2lbsYG
         nWRNypMBSQk9ldccA0ViturALc1iomurfuc5hODTDO3T6ZFx+E6XiHwGwjtXA1XD1cTm
         cJxFmTTI3ebv0T+R3EtM5TcsIpL8Xd6xi/Q93zJHDdLCmDxWZkAIzYnhvbSFvc25yPZd
         93Hw==
X-Gm-Message-State: APuU4Z9Qxv24YJxmADxbCcNfFGH0UA5w7pCJQcEc4xZN+ZcjXas41Noh
	8skHy30vQVaatm/adk503k7G+YbcjgdHSLlOboTTcHmyl+YooB2sM5/J+TWSJnhqOyQg+GPd2OO
	OB5EWbCk=
X-Gm-Gg: AYBFou0r3J7Yq7OaM+7Rrir3j4WytZFtE8RPWzViVdDLcIHIBTbuFR7FfqJvYt854KA
	f68proMZMNDru16Bbnj4/k969e7kHPVoKZEbhlNuDaPMkOD5iqh6aO3HLJBLojfM2uO5lCTDrW8
	jGVLXHljouvly5K6U1dbcl4LV/LCmY6Ov8QXpU+8ILTdRgxbOojUg0JedUuFts0WKRx29jMjL69
	mu4NsLHXpGNb00jPNMyHUlo7bqP+XYi+8awNKHNTQwk+wtCK6i/zpiKNYFdknlOAyjnzuZ5GoJa
	3FpJnD6XtjsQ4OseQ9uKQMHqoYrhV97m2V2wdkQjuAGhB+mLmOE8naJt8roDGoxEFkiKOr5WPH7
	Ih7uMXzShv/ZtbDha/QLqoqSxUswFAo2Gz0gYkGO3vdQRfpKFjgYZSy19ybIlUPgkU9scK0R0AB
	J6tayTZB9MlvfwEdVJhyUoLrqVmln2zANc2CQ2hA5GjRXw3h1z18MXbM1zg+lHM6yN4C36HjtRm
	mFN5c3gQIqw9nVlUw5ZRZVhgYuLd0j4+tsghCazvv1i83MbC/sq9FF8p+a7hk9GF4oJ9UeJiB9s
	nUWQBcSlNsSBwZA7VzjjpYcrHxwCnlwB+yRSXv2g9y/7Vb8tuDpL8nySwO+aqLvyTCl9eyT6uTZ
	EsEVfaIgvvTPBMrlyRg==
X-Received: by 2002:a05:600c:4f0d:b0:4bb:6f41:399f with SMTP id 5b1f17b1804b1-4bb7da2ba1bmr20801945e9.24.1794966173849;
        Tue, 17 Nov 2026 17:42:53 -0800 (PST)
Received: from F7R9GP321C.tail0bfbd.ts.net ([2a02:8108:8388:6600:3844:e3ef:fe85:661a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d2abfc4sm26929965e9.7.2026.11.17.17.42.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 17:42:53 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Wenyuan Xu <sereno.xu@deepseek.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 4/4] erofs-utils: mkfs: support importing xattrs for manifests
Date: Wed, 18 Nov 2026 02:42:45 +0100
Message-ID: <20261118014245.67917-4-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261118014245.67917-1-xiang.gao@docker.com>
References: <20261118014245.67917-1-xiang.gao@docker.com>
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

From: Wenyuan Xu <sereno.xu@deepseek.com>

Import xattrs from backing files listed in the manifest.  Reuse
shared xattr serialization for the loaded inodes and support
xattr name prefixes.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 include/erofs/xattr.h |  2 ++
 lib/manifest.c        |  7 ++++++
 lib/xattr.c           | 52 +++++++++++++++++++++++++++++++++----------
 mkfs/main.c           | 18 ++++++++++++++-
 4 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index c74f0ae..a8faca7 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -37,6 +37,8 @@ int erofs_prepare_xattr_ibody(struct erofs_inode *inode, bool noroom);
 char *erofs_export_xattr_ibody(struct erofs_inode *inode);
 int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *path,
 				       long inlinexattr_tolerance);
+int erofs_build_shared_xattrs(struct erofs_sb_info *sbi,
+			      long inlinexattr_tolerance);
 int erofs_xattr_insert_name_prefix(const char *prefix);
 int erofs_xattr_set_ishare_prefix(struct erofs_sb_info *sbi,
 				  const char *prefix);
diff --git a/lib/manifest.c b/lib/manifest.c
index 775e462..e7d5b77 100644
--- a/lib/manifest.c
+++ b/lib/manifest.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include "erofs/importer.h"
 #include "erofs/inode.h"
+#include "erofs/xattr.h"
 #include "erofs/print.h"
 #include "erofs/manifest.h"
 #include "liberofs_rebuild.h"
@@ -128,6 +129,12 @@ static int erofs_manifest_load_local(struct erofs_importer *im,
 		inode->i_size = len;
 	}
 
+	if (!im->params->no_xattrs) {
+		ret = erofs_scan_file_xattrs(inode);
+		if (ret)
+			goto out_inode;
+	}
+
 	if (!existing) {
 		d->inode = inode;
 		d->type = erofs_mode_to_ftype(inode->i_mode);
diff --git a/lib/xattr.c b/lib/xattr.c
index 5086ee3..46ede50 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1001,27 +1001,18 @@ static void erofs_write_xattr_entry(char *buf, struct erofs_xattritem *item)
 			item->prefix, item->kvbuf + item->prefix_len);
 }
 
-int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *path,
-				       long inlinexattr_tolerance)
+static int erofs_write_shared_xattrs(struct erofs_sb_info *sbi,
+				     unsigned int sharedxattr_count)
 {
 	struct erofs_xattrmgr *xamgr = sbi->xamgr;
 	struct erofs_xattritem *item, *n, **sorted_n;
-	unsigned int sharedxattr_count, p, i;
+	unsigned int p, i;
 	struct erofs_buffer_head *bh;
 	char *buf;
 	int ret;
 	erofs_off_t off;
 	erofs_off_t shared_xattrs_size = 0;
 
-	/* check if xattr or shared xattr is disabled */
-	if (inlinexattr_tolerance < 0 || inlinexattr_tolerance >= INT_MAX)
-		return 0;
-
-	ret = erofs_count_all_xattrs_from_path(sbi, path);
-	if (ret)
-		return ret;
-
-	sharedxattr_count = erofs_cleanxattrs(xamgr, inlinexattr_tolerance);
 	if (!sharedxattr_count)
 		return 0;
 
@@ -1077,6 +1068,43 @@ int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *pa
 	return ret;
 }
 
+int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *path,
+				       long inlinexattr_tolerance)
+{
+	int ret;
+
+	if (inlinexattr_tolerance < 0 || inlinexattr_tolerance >= INT_MAX)
+		return 0;
+	ret = erofs_count_all_xattrs_from_path(sbi, path);
+	if (ret)
+		return ret;
+	return erofs_write_shared_xattrs(sbi,
+			erofs_cleanxattrs(sbi->xamgr, inlinexattr_tolerance));
+}
+
+int erofs_build_shared_xattrs(struct erofs_sb_info *sbi,
+			      long inlinexattr_tolerance)
+{
+	struct erofs_xattrmgr *xamgr = sbi->xamgr;
+	struct erofs_xattritem *item;
+	unsigned int i, count = 0;
+
+	if (inlinexattr_tolerance < 0 || inlinexattr_tolerance >= INT_MAX)
+		return 0;
+	for (i = 0; i < ARRAY_SIZE(xamgr->hash); ++i) {
+		list_for_each_entry(item, xamgr->hash + i, node) {
+			if (item->count > inlinexattr_tolerance) {
+				/* keep shared items alive after inode references drop */
+				++item->count;
+				item->next_shared_xattr = xamgr->shared_xattrs;
+				xamgr->shared_xattrs = item;
+				++count;
+			}
+		}
+	}
+	return erofs_write_shared_xattrs(sbi, count);
+}
+
 char *erofs_export_xattr_ibody(struct erofs_inode *inode)
 {
 	struct list_head *ixattrs = &inode->i_xattrs;
diff --git a/mkfs/main.c b/mkfs/main.c
index fe996c2..22ef23d 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -2001,7 +2001,15 @@ int main(int argc, char **argv)
 		err = erofs_fill_inode(&importer, root, &st, cfg.c_src_path);
 		if (err)
 			goto exit;
-	} else if (source_mode != EROFS_MKFS_SOURCE_MANIFEST) {
+	} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST)  {
+		err = erofs_xattr_flush_name_prefixes(&importer,
+						      mkfs_plain_xattr_pfx);
+		if (err) {
+			erofs_err("failed to flush long xattr prefixes: %s",
+				  erofs_strerror(err));
+			goto exit;
+		}
+	} else {
 		err = erofs_xattr_flush_name_prefixes(&importer,
 						      mkfs_plain_xattr_pfx);
 		if (err) {
@@ -2032,6 +2040,14 @@ int main(int argc, char **argv)
 		if (err)
 			goto exit;
 		root = importer.root;
+
+		if (!incremental_mode) {
+			err = erofs_build_shared_xattrs(&g_sbi, mkfscfg.inlinexattr_tolerance);
+			if (err) {
+				erofs_err("failed to build shared xattrs: %s", erofs_strerror(err));
+				goto exit;
+			}
+		}
 	} else if (source_mode == EROFS_MKFS_SOURCE_TAR) {
 		while (!(err = tarerofs_parse_tar(&importer, &erofstar)))
 			;
-- 
2.54.0 (Apple Git-157)


