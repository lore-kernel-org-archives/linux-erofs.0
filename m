Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A3AC43334
	for <linux-erofs@archiver.kernel.org>; Mon, 25 Jul 2022 04:31:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4LrnDG0c7Xz3bmW
	for <linux-erofs@archiver.kernel.org>; Mon, 25 Jul 2022 14:31:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=gFX0mtVM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::535; helo=mail-pg1-x535.google.com; envelope-from=zbestahu@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=gFX0mtVM;
	dkim-atps=neutral
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4LrnD62d7Fz302d
	for <linux-erofs@lists.ozlabs.org>; Mon, 25 Jul 2022 14:31:01 +1000 (AEST)
Received: by mail-pg1-x535.google.com with SMTP id e132so9302192pgc.5
        for <linux-erofs@lists.ozlabs.org>; Sun, 24 Jul 2022 21:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=0AgySdOYVSXqJQUmS5s5ac65EtO0kNbbhLzvKY9tB6o=;
        b=gFX0mtVMzGxF9IrZC2I+Bptro7UWE/7kLB3zLsLaKYZdWWfrSaq1V2l/sYAy0OD5Vj
         JIwZftPPQ598et8bGSwlsz95hDzL6KwSGOAi07EZmDOzC5TjLkAnDaVXw5d7ctD4YWi6
         uIdiCKj71v/taxk9SAKb7Ubw6gKaGDG865eOGj0QIgzlfIBrE+NJUGUKS595YgzFpLUe
         qGIN9AmkWbiWB4Vhf34sdqoosJlMEAb2NNnEFCpqid0VonBuLfqUgJimiY3GRG1IvXco
         wnnzCXdnqXaUnLGfP796XXymzm6bjOtaqrMtIlNWiU6ROY5TmpIX880RFp979zUkPT3r
         fQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0AgySdOYVSXqJQUmS5s5ac65EtO0kNbbhLzvKY9tB6o=;
        b=k7Jcdku3OyNtoYHZppjG+JO7baeP/TOxfMdW811RTVajyyMaqfpZdFJ0qlklT3ijMz
         Vq1ci/ZGI5cUZAVevJV8lu3D4tilSfSDWPeaT9IGvrZjPVy0YGTBgWccHzUjeT9W2Atw
         asjhqHm9xMbAHctZb5fBaCoVJfSwkQDWM6PJccxBIR98eJT3uBFlBP0QCZWbVxAmd7Ov
         BbOv7QO86WEAYVvy2xq25AqFbnARUD65LloAcz1nCLBYvWEI4arwK7oW5hE4fP3m/S1K
         jGihdLMFVDEIfHqYzbS4/Z3Z4r4cHBkc+WAiClJE7ore6BLfRPdWLKQKndLViGxQ8azv
         slJg==
X-Gm-Message-State: AJIora/+ogBdxfuRaoL/iv7uhWXa8GT8+jVyUaCLRcJCfA3NuBjyBDwy
	JWzzaEvR+NfhSxMSlHjdABHgN62i9AM=
X-Google-Smtp-Source: AGRyM1uggKaqwaWPBBbgydnL5vYgfrCjIPNH6G7f1ws+X+1jlyxvZD3iXnlpLh3XNRtW+WwiETDoSA==
X-Received: by 2002:a63:8849:0:b0:419:a6f3:ba34 with SMTP id l70-20020a638849000000b00419a6f3ba34mr9409046pgd.368.1658723458449;
        Sun, 24 Jul 2022 21:30:58 -0700 (PDT)
Received: from localhost.localdomain ([156.236.96.165])
        by smtp.gmail.com with ESMTPSA id l2-20020a622502000000b005254535a2cfsm8252879pfl.136.2022.07.24.21.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 21:30:58 -0700 (PDT)
From: Yue Hu <zbestahu@gmail.com>
X-Google-Original-From: Yue Hu <huyue2@coolpad.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: mkfs: fix a memory leak of compression type configration
Date: Mon, 25 Jul 2022 12:30:10 +0800
Message-Id: <20220725043010.23134-1-huyue2@coolpad.com>
X-Mailer: git-send-email 2.17.1
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
Cc: huyue2@coolpad.com, zhangwen@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Release the memory allocated for compression type configuration. And no
need to consider !optarg case since getopt_long() will do that.

Signed-off-by: Yue Hu <huyue2@coolpad.com>
---
 lib/config.c | 3 +++
 mkfs/main.c  | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/config.c b/lib/config.c
index 3963df2..c316a54 100644
--- a/lib/config.c
+++ b/lib/config.c
@@ -55,6 +55,9 @@ void erofs_exit_configure(void)
 #endif
 	if (cfg.c_img_path)
 		free(cfg.c_img_path);
+
+	if (cfg.c_compr_alg_master)
+		free(cfg.c_compr_alg_master);
 }
 
 static unsigned int fullpath_prefix;	/* root directory prefix length */
diff --git a/mkfs/main.c b/mkfs/main.c
index deb8e1f..9f5f1dc 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -212,10 +212,6 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'z':
-			if (!optarg) {
-				cfg.c_compr_alg_master = "(default)";
-				break;
-			}
 			/* get specified compression level */
 			for (i = 0; optarg[i] != '\0'; ++i) {
 				if (optarg[i] == ',') {
-- 
2.17.1

