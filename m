Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56F4606A332
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=WjPpWd8x
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jWBpQ4G9Fz2xpt;
	Fri, 20 Nov 2026 21:46:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795171582;
	cv=none; b=I4jBk8YNRYGK31iev87IFWGQRPU4IzVXW+IBmihlWiVEp9Iu+uMbkYiInna2D7/7TJ0mMlxmc8+xKfUKzh/P1mS7joodmDYnL3Voaklf7ECCGBd1JHR+3K+TD8NCKPOYMfsQNPCcjPthHemPEYybWcfdCbxBXTdizkJ6+NjweX+hVsLHNWbNzNW6jQUFUrjvql6fBgVYAzTxBvd4vKE0BiG7SPuG7Rv6FKuPO66ZJazFQwLxPdJSdkTNhyj5WkpXThM86b0XcM1mv2pJ6+jdh8nH8Bi3Wyn8X5JkYs8F1plvbYTvktVokAur5Cs+aC9Fih58JyrtbS+wfmmmF0uMOg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795171582; c=relaxed/relaxed;
	bh=8DZwU3MWrb1o26dgMUAGOLHJSnjw/I+V4BlOXiCU6Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=If1Q3CJzf/reNlVbmfg09UvnTOEw5ryRtI7+kontnncw0FHH3fcvMe+YZ8qXUmenbmhhHD32mbXyOmi4E0hjLb1QSFa8l7Frev94FBxBA/yM/o/4R5FH3hC/eKdYUpkUrpemg9JDj3T/8Qa5IULbKIB5PkhBRTAFubbbkrSewqU2UxG366YTwvMjy+S5lWET36HJNpHIWCZGX2jfHbTI7gnqWHdm7PyrDl923KXwLfavi/n/CXkAzB4atQ7FppbhEdhHNvf5Moy+8sOPzEY0EUabpLn5CCU+N96VyzODO93prFfpef1j2ToUBO/pKBdTMtut43KKPJ9MIHq/qjBWsg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=WjPpWd8x; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=WjPpWd8x;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jWBpN6jfDz2ySk
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 21:46:20 +1100 (AEDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso6490745e9.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 02:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795171577; x=1795776377; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8DZwU3MWrb1o26dgMUAGOLHJSnjw/I+V4BlOXiCU6Jk=;
        b=WjPpWd8xdSRWqdR6K0HHGV+4jRVMqcByl4V4WpO86y6h8nqLv9ymMcuCXTZOEq+eu/
         z36A6R5z2o9DWXC5F1N26Jwbu7SBnM8jI69HhaC12KofJkvr7EDuG2FApIdNjUdz+hqO
         EFJC/FyhbqnUIdQzH84zN3Da4mjIkpSu7hRloh/Mdj7mt98Fea1qBMPQRCd5ybDkk7WH
         D7OyxkQ/UHAPhycsCiHa3R3E0x7AlfjxWUDDz6+Al79aFEG2I/CEt8je0dsyV94wZ2QY
         5qCeU7xlhsNv+o0ujPJqP+Ot5YkCWeNxWYYbiM3hYLiKs7dFE3BVVGdQrwCeohLPXak9
         la5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795171577; x=1795776377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8DZwU3MWrb1o26dgMUAGOLHJSnjw/I+V4BlOXiCU6Jk=;
        b=IiLcK2mcmUouTBIZx0DY+Anyj2wPipJXZUMDj2sbwCgZ/ovIHy/hG2bO+v2nbjIyAj
         K3JvwZ2mjdzb9lqzLNnTT0yTY5N4skgyHmA40kTLPwQ4K7gpfUtko04cFbHN6L+8DLkF
         Whjo3pYm74EN6Cvtz+gvlKW/sKlGuCDJlCkK6Uu3gdxra2vdqcm1oLm+PyrJuHxRUVpv
         JEezNsokccJQd2/EZKeuxEZ/3nlOT7YJZPL6fJ9TNxOlkN/oGfxWE/VzpKE7Pi/6RAV4
         jWMAO1FGE8rroN83WpsKaAPXt3yUcCi709oJoOxJDy+3AnXRLc3FDynX8oGIqLklK8LL
         Z5CQ==
X-Gm-Message-State: APuU4Z/mzLTnF85nRfx/14LZFqxNF7B50E/SFG7tVyYzmJpRAK5qZmdT
	xC7qcSbTrPK7SEKA3qlBuN7ubdC2IAi8lHWbyoodVhwR7a2zCHvTDfESec/2NlYDFLqGS/oI4hO
	9uytC9m0=
X-Gm-Gg: AYBFou0W0wz53lPx8iOmF4O26Hyqz6k8AjisfQXEzOgImzcc3zmsUy43fO2S+EuzEH9
	gjAZdpGAYPt9ARYfq9UmG8xNXjWXBrxIpLz1sIElRwMjhunKYaBLOZMxacbRhY8RuymeDNSCGxd
	BunKPEJRFbjImNq80q5sP6VgbUKmPo4NfxzTaQJtqz+vo76D8cDGGTP+D8b2J2BmWiZ0M/Zed+w
	9UvqNHOlrYnn7kgljJpufvpP1VAOLjsHjcr6S7kvZlQJAUUTbqiyYMhR4uGxEeMnQw9NmJt9clE
	LOyPVcqoVNQs4Xbmp7IvPP5Y9PSRpcOGNXz5CpNstMdfbGfMuTnGqni55k6nIXemYjcVagdHmDW
	GyJy+OjAlvhmqy+toRF3hKf+ovvJAFbyF1VP6y8WRougVcclXGBPoGR/Nlt+oyz3LporNSPi4Oq
	6lox3JNZMVEBU8FlWdxP9Z0wHH36Crn9gHX9cwAzKafH06AgvokReT2rZXiWlHK8IyMRT1PRpP+
	sP+sj19vi8mIeBH10nFZvFIN3CXfHFQnmP3z3O1Vd701MAzUhuRsFwH1setC5+Pw1e5c5n3qVj8
	KjXJdpQgppqXeoa7ikRl8Yw4gRuPcdzr0L0w/ZGR2nAzgzno/DjZOXPnA6UcuA==
X-Received: by 2002:a05:600d:8402:b0:4a3:5a91:5f61 with SMTP id 5b1f17b1804b1-4bb88806287mr46434715e9.14.1795171577232;
        Fri, 20 Nov 2026 02:46:17 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5888:55e8:d901:aec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110d56sm4795522f8f.40.2026.11.20.02.46.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:46:16 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Wenyuan Xu <sereno.xu@deepseek.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 5/5] erofs-utils: mkfs: support importing xattrs for manifests
Date: Fri, 20 Nov 2026 11:46:06 +0100
Message-ID: <20261120104606.25056-5-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120104606.25056-1-xiang.gao@docker.com>
References: <20261120104606.25056-1-xiang.gao@docker.com>
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
 include/erofs/xattr.h |  3 ++
 lib/manifest.c        |  8 ++++++
 lib/xattr.c           | 65 +++++++++++++++++++++++++++++++++++--------
 mkfs/main.c           | 18 +++++++++++-
 4 files changed, 81 insertions(+), 13 deletions(-)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index c74f0ae..c1cfd01 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -33,10 +33,13 @@ ssize_t erofs_sys_lsetxattr(const char *path, const char *name,
 
 int erofs_xattr_init(struct erofs_sb_info *sbi);
 int erofs_scan_file_xattrs(struct erofs_inode *inode);
+void erofs_inode_clear_xattrs(struct erofs_inode *inode);
 int erofs_prepare_xattr_ibody(struct erofs_inode *inode, bool noroom);
 char *erofs_export_xattr_ibody(struct erofs_inode *inode);
 int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *path,
 				       long inlinexattr_tolerance);
+int erofs_build_shared_xattrs(struct erofs_sb_info *sbi,
+			      long inlinexattr_tolerance);
 int erofs_xattr_insert_name_prefix(const char *prefix);
 int erofs_xattr_set_ishare_prefix(struct erofs_sb_info *sbi,
 				  const char *prefix);
diff --git a/lib/manifest.c b/lib/manifest.c
index 3242b3f..827c588 100644
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
@@ -136,6 +137,7 @@ static int erofs_manifest_load_local(struct erofs_importer *im,
 		free(inode->i_srcpath);
 		inode->i_srcpath = NULL;
 		erofs_remove_ihash(inode);
+		erofs_inode_clear_xattrs(inode);
 	} else {
 		parent = d->inode;
 		if (!S_ISDIR(st.st_mode) && !im->params->hard_dereference) {
@@ -181,6 +183,12 @@ static int erofs_manifest_load_local(struct erofs_importer *im,
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
index 5086ee3..0647b3b 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -688,6 +688,19 @@ int erofs_scan_file_xattrs(struct erofs_inode *inode)
 	return erofs_droid_xattr_set_caps(inode);
 }
 
+void erofs_inode_clear_xattrs(struct erofs_inode *inode)
+{
+	struct erofs_inode_xattr_node *node, *n;
+
+	list_for_each_entry_safe(node, n, &inode->i_xattrs, list) {
+		list_del(&node->list);
+		put_xattritem(node->item);
+		free(node);
+	}
+	inode->opaque = false;
+	inode->origin = false;
+}
+
 int erofs_read_xattrs_from_disk(struct erofs_inode *inode)
 {
 	ssize_t kllen;
@@ -1001,27 +1014,18 @@ static void erofs_write_xattr_entry(char *buf, struct erofs_xattritem *item)
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
 
@@ -1077,6 +1081,43 @@ int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *pa
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


