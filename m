Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82213606A326
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 04:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=avm9FIgm
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBqb3ZKPz2xDD;
	Wed, 04 Nov 2026 15:12:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.79.60.75
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793765563;
	cv=none; b=guUSVI+YYhUtxkBdKGm0infUF6ht3Wmq5PS3d9Et7iEU1N3fNA23+fLepCSHT1w41TtGfb6rkCHkAR3EfuSMfJoSmwHqp4k2ZMCRXoLLgLK893PjQrK0qqIBXqSrfvJfn9+hCknH3ZCL5FWKPQAyB06GmVQcAFHnslz6eyEj1EFbR8Nw/JoRNrYr5gGJofYoqDSCPjHZOXe3ZGCfIh4ICKZraNNHKObhn3v1xreFKtjuMdV+ErsaNCJIldwEjFy2YZx7/u/gIuV6DEoQr3tUyS2tImYAbRsNA+yay26eMHYMlzMa2+aj1dEzVRxKBuAUJqWWw9mRljLSDKh0yL6Ncw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793765563; c=relaxed/relaxed;
	bh=KKoF4E7ntvvV5LR3utxDKmuJ00M+C+6rn3KswMQW7S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bndWLrnzyP8aRu0f2u1JpzIbHqmPcVNnFyq27NefaoUQ9GrcvwTAGrByRE4IoltJlv0Zw2Lath3Oav4jYxUxIuv9sq6rvW4OLlbsCNe9csVwnHSS1sP8M5l2SKdQCO08dI0F0d3x/2eMS1xJfZEfY1InPg93WISm+USeaJuGj9vAr1NA34ai9YugvPx29qPRy7q0UOg51NJ7v4dA9yjphVoiUCpka5SIOn4AcMYvhGt7rr9MlvwUAnxM+IwffUikBEp6VHg2ggTRW5063pGNX8h/HTIFCw+LUFH08bDQLAV/Mkz37rgFNAjQNZRh39PrvfDj4c2w3i9/HgusDqVNhQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=avm9FIgm; dkim-atps=neutral; spf=pass (client-ip=210.79.60.75; helo=mail-m6075.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=avm9FIgm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=210.79.60.75; helo=mail-m6075.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 302 seconds by postgrey-1.37 at boromir; Wed, 04 Nov 2026 15:12:39 AEDT
Received: from mail-m6075.netease.com (mail-m6075.netease.com [210.79.60.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBqW6186z2x99
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 15:12:39 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.173])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536bdc6d3;
	Wed, 4 Nov 2026 12:07:30 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [RFC 1/7] erofs-utils: mkfs: init root inode in local source mode
Date: Wed,  4 Nov 2026 04:07:19 +0000
Message-ID: <20261104040725.2473313-2-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1a4bd94c403a3kunma3fc75f17e041
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTxlDVkMdHxoZQhgeGUpMGlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTEhZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=avm9FIgmZAz/rO2KQnBIZWHIw5zT4aYzGE1eaHWBaWYOdxJnuYg6I4AZyu9JorB6KTq6bw5+qxuWNj/h7gtjs6tjzCBUyxjDbae2DQ8/OGNf+DinNpCZiqp+f01RG4O9rfOlN+ex3xaySyEt24ChtZH5skcdMl9S8+bhEMizahc=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=KKoF4E7ntvvV5LR3utxDKmuJ00M+C+6rn3KswMQW7S8=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 include/erofs/inode.h |  2 ++
 lib/inode.c           | 30 ++++--------------------------
 mkfs/main.c           |  8 +++++++-
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/include/erofs/inode.h b/include/erofs/inode.h
index 5b67b95..88c413b 100644
--- a/include/erofs/inode.h
+++ b/include/erofs/inode.h
@@ -42,6 +42,8 @@ int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
 bool erofs_dentry_is_wht(struct erofs_sb_info *sbi, struct erofs_dentry *d);
 int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 		       struct stat *st, const char *path);
+int erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
+			    struct stat *st, const char *path);
 struct erofs_inode *erofs_new_inode(struct erofs_sb_info *sbi);
 int erofs_importer_load_tree(struct erofs_importer *im, bool rebuild,
 			     bool incremental);
diff --git a/lib/inode.c b/lib/inode.c
index da29b5a..2a3d022 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1334,7 +1334,7 @@ int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 	return 0;
 }
 
-static int erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
+int erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 			    struct stat *st, const char *path)
 {
 	const struct erofs_importer_params *params = im->params;
@@ -2251,30 +2251,6 @@ struct erofs_mkfs_buildtree_ctx {
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
-		struct stat st;
-		int err;
-
-		err = lstat(params->source, &st);
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
@@ -2339,7 +2315,7 @@ static int erofs_mkfs_build_tree(struct erofs_mkfs_btctx *ctx)
 	if (err)
 		goto fail;
 
-	err = __erofs_mkfs_build_tree(ctx);
+	err = erofs_mkfs_dump_tree(ctx);
 	erofs_mkfs_go(ctx, ~0, NULL, 0);
 	err2 = pthread_join(sbi->dfops_worker, &retval);
 	DBG_BUGON(!q->exited);
@@ -2358,6 +2334,8 @@ fail:
 	free(q);
 	return err;
 }
+#else
+#define erofs_mkfs_build_tree erofs_mkfs_dump_tree
 #endif
 
 int erofs_importer_load_tree(struct erofs_importer *im, bool rebuild,
diff --git a/mkfs/main.c b/mkfs/main.c
index 93123c1..d8706d7 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1987,7 +1987,13 @@ int main(int argc, char **argv)
 	}
 
 	importer.root = root;
-	if (source_mode == EROFS_MKFS_SOURCE_TAR) {
+	if (source_mode == EROFS_MKFS_SOURCE_LOCALDIR) {
+		struct stat st;
+
+		err = lstat(cfg.c_src_path, &st);
+		if (!err)
+			err = erofs_fill_inode(&importer, importer.root, &st, cfg.c_src_path);
+	} else if (source_mode == EROFS_MKFS_SOURCE_TAR) {
 		while (!(err = tarerofs_parse_tar(&importer, &erofstar)))
 			;
 	} else if (source_mode == EROFS_MKFS_SOURCE_REBUILD) {
-- 
2.43.0


