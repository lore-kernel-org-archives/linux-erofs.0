Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96518606A32A
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 07:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=NeUC5vhe
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jNzL02DYDz2yDD;
	Tue, 10 Nov 2026 18:48:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=103.209.128.12
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794296920;
	cv=none; b=UpIpCgFo8SCNAYmXfWAQEHPRvzHo5Lv5hikzvSF/V/KL6I18XlhIV1UGKbmlFaiAPLIwX8iSgTQOaT67yQHFYAw8hGXjPORd6joBNL6XSgD2dkG7XK35yIm4mkdWH/kokn00pymlr4HNqbBCvMDCO502oq77iGQUNinWVRPhXDIg9N6Qdh6u8I8NTISk+lAQZYEmoF3rUkH3YKMLpt8cQiIjDKCRFyFaNcGMhd97hvqww7c7wSMCpfSPTVQNmxcEBYZsCQHAC2KJbAA0QtVOGyhlVQ7rZtK8mVv60zYZjlbfkMy4rmU8KRZ9Tv8DGnYVaLX6PtT8iZbcumaeywRjGA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794296920; c=relaxed/relaxed;
	bh=sbFyqcwQLAbw7xvb8gmDxPtUnFsWkRLg6qhy/SS5UmQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geNE/LNYW6lA/C4zubV6J+g69/DyotMEQIYFt+EIDCyPF1a3Xnu8avA/smJ32mw2Oy1aEvYw0rmfmmP1BJiL681htNYZTUbF+ogUuRBGKXKqpiqUCXFeVgwZmmF/n2rSZepZgDSpXOL6AYeCh1B4hILAaFhw1VTokYNG/KervtVxD9b1Zv8n1vL7RHXAe3JZW2LRkME04Qaa4yISRvPAqlty5T0sEbJK/SOJhmbaRdx/qPkjj93OXe0NpeA0Q6wcnaF/03QmWDiIfhUcL+qdV5pkBGNPZc8SURxi7zGFkFr1nOlhylkwBsJJC3DNqyzbwQPgbZcxc0Jza8TrpCZzDw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=NeUC5vhe; dkim-atps=neutral; spf=pass (client-ip=103.209.128.12; helo=mail-m12812.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=NeUC5vhe;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=103.209.128.12; helo=mail-m12812.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m12812.netease.com (mail-m12812.netease.com [103.209.128.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jNzKw5Q5Tz2xfK
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 18:48:33 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.138])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5421a058f;
	Tue, 10 Nov 2026 15:48:28 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 2/3] erofs-utils: lib: avoid duplicate overlay opaque xattrs
Date: Tue, 10 Nov 2026 07:48:21 +0000
Message-ID: <20261110074822.292859-2-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110074822.292859-1-sereno.xu@deepseek.com>
References: <20261110074822.292859-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1c46e0c9c03a3kunmfb1181274ba059
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTEJOVkpMS08ZTExOT0NOQ1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKSENZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=NeUC5vheDYFMpCJypnYckSWt57p7qDSZTbZqb0KM5xQNNAzhM7wM2ZxDswy/5A54MUo23skXX1XgUfC8aXCfW4OuHe3QMuF5xZZYOf48OJ6icysXcG/4nSPMAyzBJTFJgbZJevvG+7AZZlMnEyVObovK8NibLtSEjZOg26Qz+tM=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=sbFyqcwQLAbw7xvb8gmDxPtUnFsWkRLg6qhy/SS5UmQ=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Importing a TAR archive that contains both a trusted.overlay.opaque
PAX attribute and a .wh..wh..opq entry for the same directory can
produce duplicate opaque xattrs, regardless of their order. Repeated
.wh..wh..opq entries can also trigger this problem.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 include/erofs/xattr.h |  1 +
 lib/tar.c             |  6 +++++-
 lib/xattr.c           | 11 +++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index a729b98..3ef1a25 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -45,6 +45,7 @@ int erofs_setxattr(struct erofs_inode *inode, int index, const char *name,
 		   const void *value, size_t size);
 int erofs_vfs_setxattr(struct erofs_inode *inode, const char *name,
 		       const void *value, size_t size);
+bool erofs_test_opaque_xattr(const char *name);
 int erofs_set_opaque_xattr(struct erofs_inode *inode);
 void erofs_clear_opaque_xattr(struct erofs_inode *inode);
 bool erofs_get_opaque_from_disk(struct erofs_inode *inode);
diff --git a/lib/tar.c b/lib/tar.c
index 14b2225..899e82c 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -418,8 +418,13 @@ int tarerofs_apply_xattrs(struct erofs_inode *inode, struct list_head *xattrs)
 		item->kv[item->namelen] = '\0';
 		erofs_dbg("Recording xattr(%s)=\"%.*s\" (of %u bytes) to file %s",
 			  item->kv, vsz, v, vsz, inode->i_srcpath);
+		/* a .wh..wh..opq preceds trusted.overlay.opaque xattr  */
+		if (inode->opaque && erofs_test_opaque_xattr(item->kv))
+			continue;
 		if (erofs_test_origin_xattr(item->kv))
 			inode->origin = true;
+		if (erofs_test_opaque_xattr(item->kv))
+			inode->opaque |= S_ISDIR(inode->i_mode);
 		ret = erofs_vfs_setxattr(inode, item->kv, v, vsz);
 		if (ret == -ENODATA)
 			erofs_err("Failed to set xattr(%s)=%.*s to file %s",
@@ -1082,7 +1087,6 @@ out_eot:
 		 * needed if the tar tree is used soon, thus we have no chance
 		 * to generate it from xattrs.  No impact to mergefs.
 		 */
-		d->inode->opaque = true;
 		ret = erofs_set_opaque_xattr(d->inode);
 		goto out;
 	} else if (th->typeflag == '1') {	/* hard link cases */
diff --git a/lib/xattr.c b/lib/xattr.c
index 4097298..78e2830 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -509,6 +509,8 @@ static int read_xattrs_from_file(struct erofs_sb_info *sbi, const char *path,
 		if (inode) {
 			if (erofs_test_origin_xattr(key))
 				inode->origin = true;
+			if (erofs_test_opaque_xattr(key))
+				inode->opaque |= S_ISDIR(inode->i_mode);
 			ret = erofs_inode_xattr_add(&inode->i_xattrs, item);
 			if (ret < 0)
 				goto err;
@@ -594,14 +596,23 @@ static void erofs_removexattr(struct erofs_inode *inode, const char *key)
 	}
 }
 
+bool erofs_test_opaque_xattr(const char *name)
+{
+	return !strcmp(name, OVL_XATTR_OPAQUE);
+}
+
 int erofs_set_opaque_xattr(struct erofs_inode *inode)
 {
+	if (inode->opaque)
+		return 0;
+	inode->opaque = true;
 	return erofs_vfs_setxattr(inode, OVL_XATTR_OPAQUE, "y", 1);
 }
 
 void erofs_clear_opaque_xattr(struct erofs_inode *inode)
 {
 	erofs_removexattr(inode, OVL_XATTR_OPAQUE);
+	inode->opaque = false;
 }
 
 bool erofs_get_opaque_from_disk(struct erofs_inode *inode)
-- 
2.43.0


