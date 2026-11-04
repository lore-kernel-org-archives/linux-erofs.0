Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86941606A31B
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 04:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=MwcSJkCs
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBqb3Qtcz2xBb;
	Wed, 04 Nov 2026 15:12:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.79.60.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793765563;
	cv=none; b=jifh1c8LJngqbig3UlxqKiKNBtYs6n/7dYuom7FkxSFjXyfJye+P87dck4pP48F114Jn3/qDvnoiwZoCFhNfua2OssaSkiMNegfnQFyQQGx6X1o/csL34fAWkZ/f6Cn/iRKRn0wgi8/N11tNR9D2FjKFsQ3iS+o5GYHw9ZX/SPjH3F06qpG0N4Ty8P7J+GiJqXJggAHJzu40FnUoGgAG63MpLCM9dx5Lyuv2PydLSUUTyKfbMW75J7VCcEJ29CYqw5LOjduYOT7mvTPuY8bN/i4QDQ2Zd5tkHV0Vj066n89hGh12HuwBDiVhIRN/wT4hxhhYUArap038QhZQ4B6ROg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793765563; c=relaxed/relaxed;
	bh=Ay9MqD9SNXPJ7oFmMxxQJVxxrmJ9mhziKE6nUF7Fjz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXOql5TqRcdYSo5VxLQpxw4ADl+C9jRDKu0VJ21FgmYFsiMcDHdz8m0kX7K4JpYL0V+FhojYWr8gOkTxW7Ow7Py37e/06HCo/V4VQWHUdjRpWSNY3e8X0acCYrV6g3vGmZNBm0TBJvigjoJGUUheHPSWRFm4qG6jKSdOuKKNRm/M9AjddwI6AuZsrfET2S/97QPuU/hgiu1oc7bqMt9BRi+WBrlEwlD+e5Sv58XLC4iQUkYG7PDUBgZLFlceJMbN6a3tH6dxw7tYptdXv8EE9IPm0M3mQw6ySoL7haHBfFrvkyO/mbs4peZ/c4JTsNPC/ibk1SXQRDyNgq5vGszalA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=MwcSJkCs; dkim-atps=neutral; spf=pass (client-ip=210.79.60.98; helo=mail-m6098.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=MwcSJkCs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=210.79.60.98; helo=mail-m6098.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m6098.netease.com (mail-m6098.netease.com [210.79.60.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBqX5Jq3z2x9N
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 15:12:40 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.173])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536bdc6e1;
	Wed, 4 Nov 2026 12:07:33 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [RFC 3/7] erofs-utils: lib: add erofs_build_shared_xattrs() helper
Date: Wed,  4 Nov 2026 04:07:21 +0000
Message-ID: <20261104040725.2473313-4-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104040725.2473313-1-sereno.xu@deepseek.com>
References: <20261104040725.2473313-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1a4bda33103a3kunma3fc75f17e06a
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaS0oaVkIaGUIeTRhMTExITVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTEhZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=MwcSJkCsWI+FT0+t5TZbmZ3NBNzANS1KkpyKfPAAZGx7wc5qk0ZibNs1J2fKMuouqTEz44Yj4+TYOjG2R2yf18hNSaBRqz+3TgkKjk9sIgeal0SprQODKmSm6aFa6U4gaiJSpexfJiOhKJ9zc0i21Hglyrif5TAoIjC4UsrjVvA=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=Ay9MqD9SNXPJ7oFmMxxQJVxxrmJ9mhziKE6nUF7Fjz8=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extract shared xattr serialization from the local-directory scan so it
can also be used with xattrs already attached to inodes.

Add erofs_build_shared_xattrs() to select shared entries  without
freeing inline entries. Retain an extra reference to shared entries
until xattr manager cleanup.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 include/erofs/xattr.h |  2 ++
 lib/xattr.c           | 52 +++++++++++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index 0016ad2..1388a6f 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -32,6 +32,8 @@ int erofs_prepare_xattr_ibody(struct erofs_inode *inode, bool noroom);
 char *erofs_export_xattr_ibody(struct erofs_inode *inode);
 int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *path,
 				       long inlinexattr_tolerance);
+int erofs_build_shared_xattrs(struct erofs_sb_info *sbi,
+			      long inlinexattr_tolerance);
 int erofs_xattr_insert_name_prefix(const char *prefix);
 int erofs_xattr_set_ishare_prefix(struct erofs_sb_info *sbi,
 				  const char *prefix);
diff --git a/lib/xattr.c b/lib/xattr.c
index a0ac76f..4e7ac8b 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -995,27 +995,18 @@ static void erofs_write_xattr_entry(char *buf, struct erofs_xattritem *item)
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
 
@@ -1071,6 +1062,43 @@ int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *pa
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
-- 
2.43.0


