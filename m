Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85112606A31C
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 01:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=kIcvDH2/
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTkrH0TjLz2xNC;
	Wed, 18 Nov 2026 12:42:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::330"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794966174;
	cv=none; b=LIpsNmCwfWzJKfsej1jFe8cjOKP9TVq/KxfyNe5ublHHmvfyl9eEX8l4T81sywBwuaiCy/pl3UdzlaGPBxs/tcxjYJllA8/DCJjRK3zAZoJINHZAHsAbjL53ReiE5xbxMhZP48rJ5CFX63G41J2lJtMeltV/h2VjrhawOtKeioVByccBHx0EEeZ50L0xRuGyc5fnAYlY67ZXMPteWvpZy33WdYHKgwGZstd1QideQUonotD6DmObESge9i/38Av9CfiRCbxWmeeUf2iaUCTRdfzj1z819GjQsfEp4fbX3cicnf7nF77St9ljwhKogKd7aOozgxcki3pWckGUE3Z6vw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794966174; c=relaxed/relaxed;
	bh=PkUMoQKuQW82yqoZHSxxOevjyFeoCuKGcL1oKBREmq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQhAs0Zp725MFWLZn0n0X9LUmteVfkOmHayve9lBzsL9BqRdCzde0W5ua9klCxc6nMqif/JBWSCrng9g9X6e2EK8YcqA2MHe83dB8GN/317RfUl1LTLez8COb4g7PjYal8cOm0XLDCjjTMcaB057RPj5KZkq0OSnXuhwPTIcNLSZ8FSd60YEhEbWFGJSJ/0sBVa4nWWM4JreOY+/OSjYnEJGc9KxI+4d9IeV5T2I2Q6hASoPnraEKXf243VynCpo0KpDbgiAbpSXMNKe10AAs3XFeyqS++bowzfuYr+bABMCRkphbtaG84uO7sGigj0QpCbWhkSf7ztH9W8SMhQlDw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=kIcvDH2/; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::330; helo=mail-wm1-x330.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=kIcvDH2/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::330; helo=mail-wm1-x330.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTkrF740wz2xlY
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 12:42:53 +1100 (AEDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso3563015e9.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 17:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1794966171; x=1795570971; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PkUMoQKuQW82yqoZHSxxOevjyFeoCuKGcL1oKBREmq4=;
        b=kIcvDH2/UP1vqC4dGTiZwOgJF8ypTiBpmPs/z32wVEtUAKqy2p/bYiVaQcIph5XKkm
         w+6ZiE7HCQDZjWlr8gKZ9+RM5DZ5T8UMkCNXsrJLFMkD0pJEP70k6m7FycwiQmpy2xpc
         gUy+P1N/i85NbwF455X17cw27CLjMoZbNAunnRt1bO2Qeq/mIUCNIXcNXMfzPr+PBAhM
         L7Dg5h6GNn11uu1jCzsX1FqCMYvhQuGc4ZMXIhOTch21Mh9outclP0hxDI8xrCkmKe8C
         f+tgXPyGVMK7n8ikKV6NwHZ/ELqdr0akowlxZGzutAAwSL3ORXfn7HGnMQTu8CypEqYe
         1drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794966171; x=1795570971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PkUMoQKuQW82yqoZHSxxOevjyFeoCuKGcL1oKBREmq4=;
        b=GIWkq2CVT7ntUC8Bqe7oKMDIiEA7jRbJ5eKwpWqmDU1pIG4nB72FyVRvjMDUxz7+Tz
         t2Wb10cRmibvOGXknj390mEERydJEHCSYnnlEpW4l9Nu0TMeb7kX2GwlDPOqUhZtd01k
         mFeWLngOd+goeFBYC3RYgoVDBsZQDWalQ8HWuCJFR4Tlbt3igvKxOVCc61ah9BOkSt6s
         CFlyLDGERqAOgvY/BCHLoX5hWM97Qv9WDHWF6Nv62derpdXBwL1/Xzim+8sQ3nhRWRpP
         g+HeNJ2ZY+mz4SdrqzzOP8F7Vps2o4bYR2Ak8twqoJU/t0zRbWwsUJzXty89o0/JzmIB
         TxhA==
X-Gm-Message-State: APuU4Z9PfANa4FAb3tPneaZa66zvmOT5ChLhPo3KgkFnv1606qzYBQt+
	b+4DA1IZYVRvTodkPX0/9fDnwNsY5kUnKqcx71ctoY6EwXQxz8ES5v13pfMoz09U9syQyEysnXE
	KzOOI7F4=
X-Gm-Gg: AYBFou1SUZKH8JzvL11IvgsTqGC0hVV+erxhH98mWecr7vyu0Wbpmn9wKksQqoj91JH
	nV8i0LxJOEJuHcmFkM6WuRGHq29otl+hqoRR8FioxS2a4mpKtyQuRU8XUfwgzTCR5NRAzINZD1h
	Xkkgp63u45UC4QiCo8Z1zItJEY9+bH254Xe9Kz5qo7uYD1+0NoOm3EOtu6vyTgBzES1oNJh5N3j
	5HBApl4/UjPX8R1m60oqhERSlYZOsETeLHSCYytZk5xTkwSMRQXyHN0GENvD/hSOx+GxL+cJV+M
	lUl7ezdgZQENjTGsJ8IjmKnmwGE86qL7EBw4QUXtV4ZWgJuVfyMM1W5/XXao6d7yuaSHE4sVvl6
	OroDtoawceL+4YYvsK4TMPLwXrCNeRMDr4Y91q7Z4vbuLjZtFOLOER0X5b3W/3kjJCBw2SOdw4C
	/DxqBrZnlvWaxTWtQuerT74AxVdO0+OG6JY504SE99i5+f86ikoFa6vcAnwpv1nkDOiijVh8DIw
	Nvv5E6HYeKHHYdaFRA+OVwlcpImt8PmvUg4aYqwiZ75vlRewpyxC8uREAgZjdaTTyCRu8xjR4LS
	pT4DN9ZfjXp9/YcOhsMQNQfQC1m6Il4vAolBnW71P46aHASzpMQiMp4+S3EY/oJW2yeQWRFM
X-Received: by 2002:a05:600c:4f93:b0:4a5:1cf1:b7bd with SMTP id 5b1f17b1804b1-4bb7da1c549mr19064555e9.16.1794966170879;
        Tue, 17 Nov 2026 17:42:50 -0800 (PST)
Received: from F7R9GP321C.tail0bfbd.ts.net ([2a02:8108:8388:6600:3844:e3ef:fe85:661a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d2abfc4sm26929965e9.7.2026.11.17.17.42.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 17:42:50 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Wenyuan Xu <sereno.xu@deepseek.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 2/4] erofs-utils: mkfs: init root inode in local source mode
Date: Wed, 18 Nov 2026 02:42:43 +0100
Message-ID: <20261118014245.67917-2-xiang.gao@docker.com>
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

Initialize the root inode in local source mode so other input modes
can supply their own root directory metadata.

Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 include/erofs/inode.h |  2 ++
 lib/inode.c           | 30 ++++--------------------------
 mkfs/main.c           | 10 ++++++++++
 3 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/include/erofs/inode.h b/include/erofs/inode.h
index 8c22dae..6745a73 100644
--- a/include/erofs/inode.h
+++ b/include/erofs/inode.h
@@ -42,6 +42,8 @@ int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
 bool erofs_dentry_is_wht(struct erofs_sb_info *sbi, struct erofs_dentry *d);
 int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 		       erofs_os_stat_t *st, const char *path);
+int erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
+			    erofs_os_stat_t *st, const char *path);
 struct erofs_inode *erofs_new_inode(struct erofs_sb_info *sbi);
 int erofs_importer_load_tree(struct erofs_importer *im, bool rebuild,
 			     bool incremental);
diff --git a/lib/inode.c b/lib/inode.c
index f687857..867cab2 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1334,7 +1334,7 @@ int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 	return 0;
 }
 
-static int erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
+int erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 			    erofs_os_stat_t *st, const char *path)
 {
 	const struct erofs_importer_params *params = im->params;
@@ -2268,30 +2268,6 @@ struct erofs_mkfs_buildtree_ctx {
 	struct erofs_importer *im;
 	bool rebuild, incremental;
 };
-#ifndef EROFS_MT_ENABLED
-#define __erofs_mkfs_build_tree erofs_mkfs_build_tree
-#endif
-
-static int __erofs_mkfs_build_tree(const struct erofs_mkfs_btctx *ctx)
-{
-	struct erofs_importer *im = ctx->im;
-
-	if (!ctx->rebuild) {
-		struct erofs_importer_params *params = im->params;
-		erofs_os_stat_t st;
-		int err;
-
-		err = erofs_os_lstat(params->source, &st);
-		if (err)
-			return -errno;
-
-		err = erofs_fill_inode(im, im->root, &st, params->source);
-		if (err)
-			return err;
-	}
-	return erofs_mkfs_dump_tree(ctx);
-}
-
 #ifdef EROFS_MT_ENABLED
 
 #ifdef HAVE_SYS_RESOURCE_H
@@ -2358,7 +2334,7 @@ static int erofs_mkfs_build_tree(struct erofs_mkfs_btctx *ctx)
 	if (err)
 		goto fail;
 
-	err = __erofs_mkfs_build_tree(ctx);
+	err = erofs_mkfs_dump_tree(ctx);
 	erofs_mkfs_go(ctx, ~0, NULL, 0);
 	err2 = pthread_join(sbi->dfops_worker, &retval);
 	DBG_BUGON(!q->exited);
@@ -2377,6 +2353,8 @@ fail:
 	free(q);
 	return err;
 }
+#else
+#define erofs_mkfs_build_tree erofs_mkfs_dump_tree
 #endif
 
 int erofs_importer_load_tree(struct erofs_importer *im, bool rebuild,
diff --git a/mkfs/main.c b/mkfs/main.c
index f75225b..dbda00e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1950,6 +1950,8 @@ int main(int argc, char **argv)
 	}
 
 	if (source_mode == EROFS_MKFS_SOURCE_LOCALDIR) {
+		erofs_os_stat_t st;
+
 		err = erofs_load_shared_xattrs_from_path(&g_sbi, cfg.c_src_path,
 						mkfscfg.inlinexattr_tolerance);
 		if (err) {
@@ -1971,6 +1973,14 @@ int main(int argc, char **argv)
 			err = PTR_ERR(root);
 			goto exit;
 		}
+		err = erofs_os_lstat(cfg.c_src_path, &st);
+		if (err) {
+			err = -errno;
+			goto exit;
+		}
+		err = erofs_fill_inode(&importer, root, &st, cfg.c_src_path);
+		if (err)
+			goto exit;
 	} else {
 		err = erofs_xattr_flush_name_prefixes(&importer,
 						      mkfs_plain_xattr_pfx);
-- 
2.54.0 (Apple Git-157)


