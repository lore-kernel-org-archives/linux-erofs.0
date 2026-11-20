Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ABF606A331
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=pEvRxvtP
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jWBpL5ZL7z2yQn;
	Fri, 20 Nov 2026 21:46:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::435"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795171578;
	cv=none; b=Y1FvdNlBEu7IL4qThXVkAXD4SK1TSq42ErBF/9mSuZNTrcDF3LaenR1zNNjCTyo+11D+Q0Hab668JkzTSCembUbNziJl1b/dlVArtlVFqjkYifaDzHX8N+5mJkKDKbCuU65hYKNGZLs80NG8K7VgHxQBwR6Sqrzc/qBQdPnXTs+BgdeYUg/Yg0w+SECmjEWEU+Wa4AXjjkdNEh3fb+aZFXBrnEjfTamxCzdIMClT1oh007zeZBu301ITPA0RPJ0RP++nKtr1MRdjw2tsX+BQJp77SjkPNNxNNlrJBKROxHfS9H+w0ksDfXH0lk5J5XDU0UZwqcZjtVjw5DMFWIyDSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795171578; c=relaxed/relaxed;
	bh=gNTLUga29PYZDEKAe3GgXqxunGoJ/QvxGmIi6onS/nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dT4Ji3ltNpQVioRHVQtt/Ywg92cWVGLNTCfgD5TsqrrD4/sKO1CdnTRK3YGUNR3iCn2Syae0EGVV0E0U55uqDP+dHKdhKVaNWALTd+GWaMJiCIKRW8iGv1cgn+ZVOTUT6GiwRdM/bSGrx7kQVpjar1lvGPJp/46XX9aDR+KppTWP0m5ItYcg3XyzUO+Lqk+vOHf/m5D/ubqRH5WK11WW1naaQGtKP2z7K9Kxnvj1VQYEJqw9VLtKWmaCVyxx1+EjG3eZIQor9M/lHJce9yMdo4HITFFXSWcF4zU1zm6A3MJSoEw5iSriNGbM4Azxgxg3gb5CZ1qE5bso+WLYEx86mg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=pEvRxvtP; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::435; helo=mail-wr1-x435.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=pEvRxvtP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::435; helo=mail-wr1-x435.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jWBpK51Qxz2yQl
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 21:46:17 +1100 (AEDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-48e09aa5264so357476f8f.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 02:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795171574; x=1795776374; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gNTLUga29PYZDEKAe3GgXqxunGoJ/QvxGmIi6onS/nA=;
        b=pEvRxvtP29dWpgG2bMhVH65iTVZZJBwcMZDss7hM4GQA/9YYaQ+UMjcKmcIvmk0JVr
         26w3nv2eUkWBoqVVNzO2DsLlThCiqWOYTmOHHpym1MMoM3AqqAcRYkLXEget7nGGLLmC
         sQhnwJEEsqG3A1CN4a4Ybo+KeB8MjUyZnxxkPScUN8XTSO7BsJgvWq6UrfMPYObjveT3
         iKHOfXVIzaIARJdlCrv98B2PuFfvnxQZBe8DvAWnOoTYkgcviOjGHTzuLWgz1uK2W+Bz
         rGVWIKErIpwO936uuOcOwGm5fbNF+RFYhzrTzrvFNfSH3bqeM66x5f2dEyWPz2vX474C
         TUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795171574; x=1795776374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gNTLUga29PYZDEKAe3GgXqxunGoJ/QvxGmIi6onS/nA=;
        b=2uy6QO71zfOrb0FflPb7T9X81Jl9fDFWk3tKVJ0k+dX/5FkdiqNKIelg8J/nKXvWTw
         xBtNLEnGxZl6942YXisRCh4XFJHb9iiQt6eqqQGMmxlFthsKus1uLcoa0wIUK2bbXiKK
         bhj9DsLa3yvMR2F85gjxK85joXd06yGblJkDiMQttKDBYUnu5aMiXD87wG9m6jXO5+Y9
         9ENVDA8/ZvXFiH0nUtf5hy3hSqebXk1oUMTiNIxPWO/7p1Qe5LNJSp2j2K62OfbK/XZb
         R3CiTfGb3grT9TCgYcxaqIMWPUbcnUgamEeH24ztEY5fkg2c4AySiTCelKYymuNpLHCd
         ZsgA==
X-Gm-Message-State: APuU4Z8jPcywJ+x0SzoQc78jlstospbzTyyhEEgN/hhpmr2OJJcNQDun
	AXeeNiSyPfLasxkdgcF3jLm4zilaosmy159U2CSi9UyPnIROO4OG9lae1n/dz9l47s1vJUQy9u3
	qQVYXa7M=
X-Gm-Gg: AZFdTZc3X0Cb+bM+KhRDGOLdg3UbmeloU2FU88oulc532yjVm/GEubckfhgQwxF3oRm
	w5/eM+TachLowY/H1pmtc7CpHQ6+4FeP60AVIsAIuLfsFbwkgckHmjz05G5BHiXjgGuuhIRhdEA
	V5n2PX5Qf9hf7BZZMHpsRVK2TCoRsLbL/gJ/wACnLxTHRVMBAXfek5ER0LBSZ45s2a0jcMzetVN
	70FL2BAqJFmeYk9gCu7Rq36ek1Ib2lddeDasDt4yowbbneAzQ4/Y0vfpo1Yqvb/8TSHSNWywdXv
	tIt8FZmYh4rLTF1LNOVtuWpdBIePCFTkNop+/SQZ9Vgs/Kq8abBIhZHjS0OdpMCqJnj4M+OaQFZ
	abHhAN+TWK7Bda6gptCjMEdmrXkZMzKv64Gmf4WCg7YssIR8QCgv7eH3sNY7FPNRqqlyS1o3kWZ
	zkBiVFSle/qXLbJSm13fX1IL3yUbOtB62BIheUArQ5AZ8RrJ9SsMgffHBAHUH2MV18ji8xQV3zO
	U5VVTQwhfBsZ8a9l9kFYlFh01OVz1j4/KG8kxxJXzvaDVYvvdW5n6hkwBjoOgkugC4D0s6UckN/
	TtqYCHwejaDA9lyGUfJtZeySCJmo2Jtcyz6wrdxwF49CRVlMxKKnVrvgVc0beDs=
X-Received: by 2002:a5d:5f86:0:b0:4ac:f79a:28ab with SMTP id ffacd0b85a97d-4acf79a2aa2mr2250494f8f.8.1795171574207;
        Fri, 20 Nov 2026 02:46:14 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5888:55e8:d901:aec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110d56sm4795522f8f.40.2026.11.20.02.46.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:46:13 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Wenyuan Xu <sereno.xu@deepseek.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 3/5] erofs-utils: mkfs: init root inode in local source mode
Date: Fri, 20 Nov 2026 11:46:04 +0100
Message-ID: <20261120104606.25056-3-xiang.gao@docker.com>
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
index b8ca8f4..2099d38 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1335,7 +1335,7 @@ int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
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


