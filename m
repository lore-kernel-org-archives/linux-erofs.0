Return-Path: <SRS0=kNa8=YP=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7B4CA9EB7
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Oct 2019 16:36:37 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DADA205ED
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Oct 2019 16:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c8CJojaB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DADA205ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46yK031YyXzDqMf
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Oct 2019 03:36:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::241;
 helo=mail-oi1-x241.google.com; envelope-from=blucerlee@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="c8CJojaB"; 
 dkim-atps=neutral
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46yJzw49P2zDqLx
 for <linux-erofs@lists.ozlabs.org>; Wed, 23 Oct 2019 03:36:28 +1100 (AEDT)
Received: by mail-oi1-x241.google.com with SMTP id a15so14775738oic.0
 for <linux-erofs@lists.ozlabs.org>; Tue, 22 Oct 2019 09:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=IYP9M5N0Z9EGPR8IWv1SfliqGzY0CQDrqeJISPLL4s4=;
 b=c8CJojaBfwDAUS0lbP91EemxtoTnjzrmUZtqeML6wlrdZRUbpfTpAloDItU5B9F6Jn
 PgVfvkepYfAPv+zQsLmQmqzb7Bcvn2ZqDxG6mssw1Ko5QcDIqf125QzeHqbPDZ3ERdqN
 SB6CZg3diPg7hMmao+hBWM7zNzNumMKI8zpJxr5q8w4c+unWU8nUaQohymIVH0vHClql
 RykNVtvO5YoMj6d1AHlbqov1ekWTI4GHY1CuTJ5xaKi9zyUvr3bQDrrKeYtOxZPl06xj
 17KiBV4/BJYdhBNhMckYi18LpAa/zlnDRW+WMgsOszMSgLqZoW0xXUpOviX8gl4L8/Nk
 sCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=IYP9M5N0Z9EGPR8IWv1SfliqGzY0CQDrqeJISPLL4s4=;
 b=uFHhXtgZnys3STTW3YBOp7YdMcR+lFPEzfZaC2q6EBGNweQGIbZoFVI7a8OptXyqWX
 5qo23PBg/eT4xFPONWTJ58UmX4A1O9ylfMfGS6DgUofRX/Y4buJ6btOhmY+as+nnM58Z
 Eoznqf+82GTljSQzd0L2XafJepeVkmda7IoltFQ+E45NFE9Df0r7+RJEHONUx0DdFNAe
 cliNzJNwUjT8awfmSIek5rwwFqS1ZyCO+VHnTo8wCcy5K+QLpKRe5pfRtRKzx0EGEr7n
 9nDB+lRBLhT/ibjqDhiZQzczkWtXh2FQTtC7ZCMmcbsvaARNlNNauPQOnzZ4HBJDpyPB
 61SA==
X-Gm-Message-State: APjAAAWhZeKjnkDTlF72MD4SFMdxfMSxz8Gliu95pswB15BXyrKuv/I5
 3XqOqBBk6J3YLcil2KGQR/NrdhKY
X-Google-Smtp-Source: APXvYqwu6WfFSAwhTNL0PEyiboN/iLPLhE/7hPwiBNgXOAQNhbUbnpzsFxmP4n4ZJ0kRQxXfJUMu7A==
X-Received: by 2002:aca:dcd6:: with SMTP id t205mr3782169oig.128.1571762182484; 
 Tue, 22 Oct 2019 09:36:22 -0700 (PDT)
Received: from localhost (li1104-154.members.linode.com. [45.79.5.154])
 by smtp.gmail.com with ESMTPSA id w25sm5312417oth.39.2019.10.22.09.36.21
 (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
 Tue, 22 Oct 2019 09:36:21 -0700 (PDT)
From: Li Guifu <blucerlee@gmail.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs-utils: list available compressors for help command
Date: Wed, 23 Oct 2019 00:36:16 +0800
Message-Id: <20191022163616.4118-1-blucerlee@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <6a0f0b47-1bb7-7e82-770f-8b039ab634f4@gmail.com>
References: <6a0f0b47-1bb7-7e82-770f-8b039ab634f4@gmail.com>
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <gaoxiang25@huawei.com>

Users can get knowledge of supported compression
algorithms then.

Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Li Guifu <blucerlee@gmail.com>
---
 include/erofs/compress.h |  2 ++
 lib/compressor.c         | 23 ++++++++++++++---------
 lib/compressor.h         |  1 +
 lib/compressor_lz4.c     |  1 +
 lib/compressor_lz4hc.c   |  1 +
 mkfs/main.c              | 15 +++++++++++++++
 6 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/include/erofs/compress.h b/include/erofs/compress.h
index e0abb8f..fa91873 100644
--- a/include/erofs/compress.h
+++ b/include/erofs/compress.h
@@ -21,5 +21,7 @@ int erofs_write_compressed_file(struct erofs_inode *inode);
 int z_erofs_compress_init(void);
 int z_erofs_compress_exit(void);
 
+const char *z_erofs_list_available_compressors(unsigned int i);
+
 #endif
 
diff --git a/lib/compressor.c b/lib/compressor.c
index 8cc2f43..6502437 100644
--- a/lib/compressor.c
+++ b/lib/compressor.c
@@ -12,6 +12,15 @@
 
 #define EROFS_CONFIG_COMPR_DEF_BOUNDARY		(128)
 
+static struct erofs_compressor *compressors[] = {
+#if LZ4_ENABLED
+#if LZ4HC_ENABLED
+		&erofs_compressor_lz4hc,
+#endif
+		&erofs_compressor_lz4,
+#endif
+};
+
 int erofs_compress_destsize(struct erofs_compress *c,
 			    int compression_level,
 			    void *src,
@@ -36,18 +45,14 @@ int erofs_compress_destsize(struct erofs_compress *c,
 	return ret;
 }
 
+const char *z_erofs_list_available_compressors(unsigned int i)
+{
+	return (i >= ARRAY_SIZE(compressors)) ? NULL : compressors[i]->name;
+}
+
 int erofs_compressor_init(struct erofs_compress *c,
 			  char *alg_name)
 {
-	static struct erofs_compressor *compressors[] = {
-#if LZ4_ENABLED
-#if LZ4HC_ENABLED
-		&erofs_compressor_lz4hc,
-#endif
-		&erofs_compressor_lz4,
-#endif
-	};
-
 	int ret, i;
 
 	/* should be written in "minimum compression ratio * 100" */
diff --git a/lib/compressor.h b/lib/compressor.h
index 6429b2a..4b76c4c 100644
--- a/lib/compressor.h
+++ b/lib/compressor.h
@@ -14,6 +14,7 @@
 struct erofs_compress;
 
 struct erofs_compressor {
+	const char *name;
 	int default_level;
 	int best_level;
 
diff --git a/lib/compressor_lz4.c b/lib/compressor_lz4.c
index 0d33223..a9cbb80 100644
--- a/lib/compressor_lz4.c
+++ b/lib/compressor_lz4.c
@@ -39,6 +39,7 @@ static int compressor_lz4_init(struct erofs_compress *c,
 }
 
 struct erofs_compressor erofs_compressor_lz4 = {
+	.name = "lz4",
 	.default_level = 0,
 	.best_level = 0,
 	.init = compressor_lz4_init,
diff --git a/lib/compressor_lz4hc.c b/lib/compressor_lz4hc.c
index 14e0175..a160c1a 100644
--- a/lib/compressor_lz4hc.c
+++ b/lib/compressor_lz4hc.c
@@ -52,6 +52,7 @@ static int compressor_lz4hc_init(struct erofs_compress *c,
 }
 
 struct erofs_compressor erofs_compressor_lz4hc = {
+	.name = "lz4hc",
 	.default_level = LZ4HC_CLEVEL_DEFAULT,
 	.best_level = LZ4HC_CLEVEL_MAX,
 	.init = compressor_lz4hc_init,
diff --git a/mkfs/main.c b/mkfs/main.c
index 31cf1c2..1161b3f 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -29,6 +29,19 @@ static struct option long_options[] = {
 	{0, 0, 0, 0},
 };
 
+static void print_available_compressors(FILE *f, const char *delim)
+{
+	unsigned int i = 0;
+	const char *s;
+
+	while ((s = z_erofs_list_available_compressors(i)) != NULL) {
+		if (i++)
+			fputs(delim, f);
+		fputs(s, f);
+	}
+	fputc('\n', f);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "usage: [options] FILE DIRECTORY\n\n");
@@ -39,6 +52,8 @@ static void usage(void)
 	fprintf(stderr, " -EX[,...] X=extended options\n");
 	fprintf(stderr, " -T#       set a fixed UNIX timestamp # to all files\n");
 	fprintf(stderr, " --help    display this help and exit\n");
+	fprintf(stderr, "\nAvailable compressors are: ");
+	print_available_compressors(stderr, ", ");
 }
 
 static int parse_extended_opts(const char *opts)
-- 
2.17.1

