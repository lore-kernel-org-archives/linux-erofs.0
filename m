Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9989C433EF
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Jan 2022 16:00:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JlhyK2wPKz3bTn
	for <linux-erofs@archiver.kernel.org>; Sat, 29 Jan 2022 03:00:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=pFKGU1ab;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::42a;
 helo=mail-wr1-x42a.google.com; envelope-from=igoreisberg@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20210112 header.b=pFKGU1ab; dkim-atps=neutral
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com
 [IPv6:2a00:1450:4864:20::42a])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Jlhy932Cfz2ymg
 for <linux-erofs@lists.ozlabs.org>; Sat, 29 Jan 2022 03:00:47 +1100 (AEDT)
Received: by mail-wr1-x42a.google.com with SMTP id e8so11835984wrc.0
 for <linux-erofs@lists.ozlabs.org>; Fri, 28 Jan 2022 08:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=N23BhzovCpI1agahCgdwLFChjupK7PJOtDjT2cV38/Q=;
 b=pFKGU1ab35o9j8Zg27V8e6PXKkGWBszBcL7Hi21HlfIKxFpSafrqxCeWVwsFnkqI5W
 /KQiOb23+vzJfx7LLpfk+802sgSkgRHwgi3DyRMJ0+DYgC+t+bjThtb3jDTQFBfMM3ju
 9lWtU7EiTWrU122dlaFGW2y6wDFDFnNder3OZon2cNvc7jy5cYdNH/zL/c1npDArfu/K
 7vOQ2dlTBU0qmnX8JqU0YN+Wux1k3aCsrx5OauPQwGL/OE3LZg7x1bEJka3fJz4R/mbf
 oWTG2mpc4s49MwMhs9YqceY8cLGgiJem4nXKaex9LjhlDkDS0oVogzXn1U+J7AfbqRPW
 ym+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=N23BhzovCpI1agahCgdwLFChjupK7PJOtDjT2cV38/Q=;
 b=EM+JydDnqqhbcTlVfMhDiDJidRnqZUkPmMh4oO/rj8RCXo+UUvqXrFqPwBHxkNAWJK
 chwN4W8rIhk1B2VsMCyz6/VSm8ssxo6ICBJaUwjElbEiRxWfW68KdEvEI2E9Edo8DxBV
 L3EaT2+Z4BzuKxGQogWSm6k79qlv1tTgcGVmm9kxDKrx0Q1N8uooFG5816XVYUFpRep+
 ou1zTy3ZhOcqUG47m1BQGeNxgIJdMoO5kzcQx1jgSYc8x8ih/A8y4XhJxXSm3FIrwXf7
 jvlDvZR+uCmL4u7N7L2FxkEQNxinhz+5ujCMkqgF1i2m4xNkVWRskzutDXGslc/8YM+b
 6Waw==
X-Gm-Message-State: AOAM531F8C8CU6rQR1VlW3CggMYr3NGrbOhEDsp8NwKvYMWqJKAvZYtR
 i/evlV+j9M43Iz//U5x3tUYdw4XR2F7feA==
X-Google-Smtp-Source: ABdhPJynfCJN8VsyAXNGl3TuM11/AlAfEFfkMekf46UU/pGpGNHWaTljKQf1Sh3cZ+e0hQhQhKOgqg==
X-Received: by 2002:adf:a4d7:: with SMTP id h23mr7594044wrb.483.1643385641165; 
 Fri, 28 Jan 2022 08:00:41 -0800 (PST)
Received: from Iceberg-PC.localdomain ([185.110.110.225])
 by smtp.gmail.com with ESMTPSA id n13sm2398456wms.8.2022.01.28.08.00.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 28 Jan 2022 08:00:40 -0800 (PST)
From: Igor Ostapenko <igoreisberg@gmail.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: fsck: fix issues related to --extract=X
Date: Fri, 28 Jan 2022 18:00:36 +0200
Message-Id: <20220128160036.101-1-igoreisberg@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YfNvloN0RAX0mHRn@B-P7TQMD6M-0146>
References: <YfNvloN0RAX0mHRn@B-P7TQMD6M-0146>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Cc: Igor Eisberg <igoreisberg@gmail.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Igor Eisberg <igoreisberg@gmail.com>

Fix "--[no-]preserve[-owner/-perms] must be used..." error always thrown
for superuser when fsck used without --extract=X, due to default values
for preserve_owner/preserve_perms being already pre-set to true,
as if the --preserve option was explicitly given by the user.

Signed-off-by: Igor Ostapenko <igoreisberg@gmail.com>
---
 fsck/main.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index 5667f2a..9e3756d 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -95,7 +95,7 @@ static void erofsfsck_print_version(void)
 static int erofsfsck_parse_options_cfg(int argc, char **argv)
 {
 	int opt, ret;
-	bool no_preserve_owner = false, no_preserve_perms = false;
+	bool has_opt_preserve = false;
 
 	while ((opt = getopt_long(argc, argv, "Vd:p",
 				  long_options, NULL)) != -1) {
@@ -154,27 +154,27 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 			break;
 		case 6:
 			fsckcfg.preserve_owner = fsckcfg.preserve_perms = true;
-			no_preserve_owner = no_preserve_perms = false;
+			has_opt_preserve = true;
 			break;
 		case 7:
 			fsckcfg.preserve_owner = true;
-			no_preserve_owner = false;
+			has_opt_preserve = true;
 			break;
 		case 8:
 			fsckcfg.preserve_perms = true;
-			no_preserve_perms = false;
+			has_opt_preserve = true;
 			break;
 		case 9:
 			fsckcfg.preserve_owner = fsckcfg.preserve_perms = false;
-			no_preserve_owner = no_preserve_perms = true;
+			has_opt_preserve = true;
 			break;
 		case 10:
 			fsckcfg.preserve_owner = false;
-			no_preserve_owner = true;
+			has_opt_preserve = true;
 			break;
 		case 11:
 			fsckcfg.preserve_perms = false;
-			no_preserve_perms = true;
+			has_opt_preserve = true;
 			break;
 		default:
 			return -EINVAL;
@@ -195,8 +195,7 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 			erofs_err("--overwrite must be used together with --extract=X");
 			return -EINVAL;
 		}
-		if (fsckcfg.preserve_owner || fsckcfg.preserve_perms ||
-			  no_preserve_owner || no_preserve_perms) {
+		if (has_opt_preserve) {
 			erofs_err("--[no-]preserve[-owner/-perms] must be used together with --extract=X");
 			return -EINVAL;
 		}
-- 
2.30.2

