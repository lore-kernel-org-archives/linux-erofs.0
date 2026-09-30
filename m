Return-Path: <linux-erofs+bounces-4641-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE89CA5FC7
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 17:17:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hw1tw480sz2xwP;
	Thu, 01 Oct 2026 03:17:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:31::11"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790788632;
	cv=none; b=fLXbTtkvthjPG2FbVNrNhRgzpqc4x3ooN6GQ67oHXVWoM6UzS9X52lB+w5NyIU4p0iJGjizkFSSo71R20m6xWRa5xtNQyHRZihuHpvuLz5xvJZy/R4lxdKod410LS52m4seMatNzggKCTZNMVI3zNizzwruL7B8Y6nUo/FXSsCVieiUBgmDV2UlqdDqz8FNwwUYO9tS5TIemj/B1W1TDV1/jF+/JVkrlx6c7HA9nFw0kYQKEZ0pP4b4CH5ol22ILfYpj/zTY3Itb604OxLf7SCYJoP2Jap9AzlZO78AoDx6zNk8wGf5cG/RsHxPMunX19q7MiXdyalCKdQGrMcfkbw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790788632; c=relaxed/relaxed;
	bh=mtMmr2wzAd0zXxoQ7ML9THyD1gRCp94/C+agW6L6QPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I6A0HYQG+hha+HASoPApLvJzUHcylj/tbyxS0nDDr295k28MLDAyJCXTBXx+cGOnS5UQBAX11JTsAr2pZPar7/2R4FNB0IQNz4UPHZJ2NLKt7XXeKZj1HkOX1esR+WRzh+0bF7NUQ/eUxTwXMGQq3tk/PAE3YeWl5feSJOTs9ozFpWFYII9XiELOQe856x6t/AwzW/9zC5o/ZrjCrjZPAvsGY+4SiGdbBYQIq5rA7gXL36oxi0g7wbtwidwyffNnA077x6XuE5GLMlVJ3dN4xF2cH6Yt/bkkdyhJBDA+Wdo/p0M0hS2NqPgX5WJNT6q9cSpCJ19SRZTr5rVm83+dmA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=looF4dt9; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:31::11; helo=mail-wm2-x11.google.com; envelope-from=yaroslav.752@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=looF4dt9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:31::11; helo=mail-wm2-x11.google.com; envelope-from=yaroslav.752@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm2-x11.google.com (mail-wm2-x11.google.com [IPv6:2a00:1450:4864:31::11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hw1tt3plmz2xfP
	for <linux-erofs@lists.ozlabs.org>; Thu, 01 Oct 2026 03:17:09 +1000 (AEST)
Received: by mail-wm2-x11.google.com with SMTP id 5b1f17b1804b1-49e8185e037so32512505e9.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 10:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790788625; x=1791393425; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mtMmr2wzAd0zXxoQ7ML9THyD1gRCp94/C+agW6L6QPQ=;
        b=looF4dt9YCKlKV+HzUjT/k6dGT8I26IYALTCi+GsFC4eiiizTtt/DZfMAVT+J+gi8+
         A6KshXxhaGIFDJs1RqABPQuZZl3nBm5R4XCkrwjudMnrOAT4EIVEhEwa+B/r/6MFDkR/
         r/VQ4EzaFFHsswHO8EiFQfgDPOX9lDV/AiQuM0GBahsP06nDiT42FOpM88wO9rbIcqR1
         ns52B/2M/N8o0nuRNvy6O8zCHSIFWPKVk79RO/2hP6CrWFL57hC9hjhdmp+RhTKmMTRl
         EHgcwkWVp1vJUPQrCIcJkdihFw/Q4W6y4OrGFFee+XDHnJCRq1zyQZdGEHbAeNC7t4Kr
         3wrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790788625; x=1791393425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mtMmr2wzAd0zXxoQ7ML9THyD1gRCp94/C+agW6L6QPQ=;
        b=qfY8jrsIpvlaUxI/S37YZD7ZmiOZ98HMlhhNZamOJkt0vqiijb6lEIzg+WGg0Wf04m
         jKiOx/uN4y7uSiWOrQ2rmGUNHjMlwEoKP6T+NiZsB5JzTCujKMEnOLbGL1sj2Eua3wvT
         YdJJz7mvWT7QugQ2OefBJu/2tg3aKuprW0VtGbUEEWNh4fV3JPNbfE7NJy3uNVw0soLR
         G0yoJhW/GRdFyd8WMLqriKZ17cCzmdFKwqS3zp42QJgLxohakwzHEYX6DY2jOypc1jMj
         Sca69Ar7dwcq4/5ZHq8p27FfKdfe4C+rSG/g5haLgRAknJaZiCk8JVdqsTnt61zIxK2+
         f9kg==
X-Gm-Message-State: AFuF++m1i4qhuRm2rt8spgla+U92kcx7Oixy0/shKqWYihTCn6tUlIMt
	yEog/qNp17R36EPK8fzwS07R0klVqIH4kF7trjqXBnpPpYEwYcboBGJ7rvKaWgJc
X-Gm-Gg: AYBFou0S/QaWPdZMq86OnOGkuXiRoGF6Fmp0uyPQBCz67sVyXGKf7/FPmVcVlif0wT9
	stQ4ST51x2ct9yWi2eSRBXc2qFif9HZnE2kzb3yOfSAwuEOeXwzalZDhnTwRIdfocCu90tB+EOz
	78YOKuXBBZp9om4UIhN/ZPFlDeIidOjTVpAfeowmTSEmrdbIZt7gyNuafMlsszSThDRCLnCGFbJ
	nVKSTqImtXQLa37MKFte2ysahEEQLwmdMi/k2dcJ7Gx4y9HE/+3YRnSUD5pqiSRfmKeWcQ+SOoX
	F3uXsx/aZ5oGm5HR3nBaNSleAVYqslONSChoTTH+6UDk4RGlLzyC5dwng+fFhqHHllWdM7i0vCE
	83hKj+MnaKbhomHjbWJo8A7hfy2xqsn1WuR271HSpqbFFOS6iqM0H6lUQ2MUkPj0CG9MWWWTD6h
	0VwqHhPPvVSTpbC1u2CTfrqAcD2hbCHL7ZhPhx9/RfnddL2MsFkVLVDuNdq0isHzndFaI+SnYrg
	oO/esMPTlfZyoLGL/kexYNHaWCBFhU4xFoP6h9OMEhAac/N1R8aKooxW+2qqKlECQFLWbB/Y1Yq
	x2TqEdrjqZw2ONgrZCovgpNXGQ==
X-Received: by 2002:a05:600c:3486:b0:4a0:4c3:1da9 with SMTP id 5b1f17b1804b1-4a01b003c1amr26089885e9.19.1790788625278;
        Wed, 30 Sep 2026 10:17:05 -0700 (PDT)
Received: from lenovo-legion5 (pppoe-77.220.52.232.ttel.ru. [77.220.52.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01eba0ed0sm5936655e9.8.2026.09.30.10.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 10:17:04 -0700 (PDT)
From: Yaroslav Borbat <yaroslav.752@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yaroslav Borbat <yaroslav.752@gmail.com>
Subject: [PATCH] erofs-utils: lib: follow symlinked directories in tar entry paths
Date: Wed, 30 Sep 2026 20:16:54 +0300
Message-ID: <20260930171654.2786771-1-yaroslav.752@gmail.com>
X-Mailer: git-send-email 2.55.0
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

From: Yaroslav Borbat <yaroslav.752@gmail.com>

Some OCI layers store entries under a symlinked directory, e.g.
`./lib64/foo` with `./lib64 -> usr/lib64`.  erofs_rebuild_get_dentry()
fails with -ENOTDIR on them, so containerd's erofs differ cannot
unpack such layers.

Fix it by resolving the rest of the path against the symlink target,
as tar extraction does.

Link: https://github.com/erofs/erofs-utils/issues/55
Signed-off-by: Yaroslav Borbat <yaroslav.752@gmail.com>
---
 lib/rebuild.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index ebac1c5..7030e67 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -82,8 +82,58 @@ struct erofs_dentry *erofs_d_lookup(struct erofs_inode *dir, const char *name)
 	return NULL;
 }
 
+/* the same limit as MAXSYMLINKS in the kernel */
+#define EROFS_REBUILD_MAXSYMLINKS	40
+
+static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *pwd,
+		char *path, bool aufs, bool *whout, bool *opq, bool to_head,
+		unsigned int nlinks);
+
+/*
+ * Some OCI image layers store entries under a symlinked directory, e.g.
+ * `lib64/libfoo.so` with `lib64 -> usr/lib64`.  Tar extraction follows such
+ * symlinks, so resolve the rest of the path against the symlink target in
+ * the same way.  Absolute targets are resolved against the root of the tree
+ * and `..` never goes above it; symlink loops end up with -ELOOP.
+ */
+static struct erofs_dentry *erofs_rebuild_follow_link(struct erofs_inode *dir,
+		const char *link, char *slash, bool aufs, bool *whout,
+		bool *opq, bool to_head, unsigned int nlinks)
+{
+	const char *rest = slash + 1;
+	struct erofs_dentry *d;
+	char *path;
+
+	*slash = '/';
+	while (*rest == '/')
+		++rest;
+	if (!*rest)
+		return ERR_PTR(-ENOTDIR);
+	if (nlinks >= EROFS_REBUILD_MAXSYMLINKS)
+		return ERR_PTR(-ELOOP);
+
+	if (*link == '/')
+		while (dir->i_parent && dir->i_parent != dir)
+			dir = dir->i_parent;
+
+	if (asprintf(&path, "%s/%s", link, rest) < 0)
+		return ERR_PTR(-ENOMEM);
+	d = __erofs_rebuild_get_dentry(dir, path, aufs, whout, opq, to_head,
+				       nlinks + 1);
+	free(path);
+	return d;
+}
+
 struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 		char *path, bool aufs, bool *whout, bool *opq, bool to_head)
+{
+	return __erofs_rebuild_get_dentry(pwd, path, aufs, whout, opq,
+					  to_head, 0);
+}
+
+static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *pwd,
+		char *path, bool aufs, bool *whout, bool *opq, bool to_head,
+		unsigned int nlinks)
 {
 	struct erofs_dentry *d = NULL;
 	char *s = path;
@@ -123,6 +173,11 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 			d = erofs_d_lookup(pwd, s);
 			if (d) {
 				if (d->type != EROFS_FT_DIR) {
+					if (slash && d->type == EROFS_FT_SYMLINK &&
+					    d->inode && d->inode->i_link)
+						return erofs_rebuild_follow_link(pwd,
+							d->inode->i_link, slash, aufs,
+							whout, opq, to_head, nlinks);
 					if (slash)
 						return ERR_PTR(-ENOTDIR);
 				} else if (to_head) {
-- 
2.55.0


