Return-Path: <SRS0=U8k6=JI=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891D6C433B4
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Apr 2021 03:49:06 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2AB1D608FC
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Apr 2021 03:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AB1D608FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FHyXc6Gn1z3bVN
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Apr 2021 13:49:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=iky1FoIC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=iky1FoIC; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FHyXZ1jWZz3btd
 for <linux-erofs@lists.ozlabs.org>; Sun, 11 Apr 2021 13:49:02 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E6A3611AD;
 Sun, 11 Apr 2021 03:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618112940;
 bh=1dw3gEgdqyxvH0FWkimlbsasWa1Wmb8COUKhisjvHis=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=iky1FoICp72ZghtpruGX42dXuF3gcK26rGJp2wNlyhulxaemnG+62wAZYotw5BlmH
 oS0xReAT7RKQQeLxECtlaGYyU1P39gi+HdV0hgmrX4irtu4Tql4Hy0fp2hrU3e2tEl
 Zz+oJjS3HwRq3obLF6Qk4XDX0cNIj2Ja9Azn3NN3HxQ0mxTzcjufuJblTZAq6e4+Fx
 6Ov1gTKQ5/xv/qiKmrVrrXgvef8bM6AHzw3H6zXIumwBhvifklwT5AwI8ZWQGOoHPA
 VGE0ewdCx0/xg1pCpa4isQ2cwOPqam9J95c3yNQYdgZXGyjKs4+v4HnvAaxEbWWk6w
 o/xzJljhZGC5A==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 3/8] erofs-utils: add -C# for the maximum size of pclusters
Date: Sun, 11 Apr 2021 11:48:39 +0800
Message-Id: <20210411034844.12673-4-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210411034844.12673-1-xiang@kernel.org>
References: <20210411034844.12673-1-xiang@kernel.org>
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
Cc: Gao Xiang <xiang@kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Set up -C >= EROFS_BLKSIZ (more specifically, >= lclustersize)
to enable big pcluster feature.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/config.h |  2 ++
 lib/config.c           |  1 +
 mkfs/main.c            | 14 +++++++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/erofs/config.h b/include/erofs/config.h
index 02ddf594ca60..5f5a05a8b796 100644
--- a/include/erofs/config.h
+++ b/include/erofs/config.h
@@ -53,6 +53,8 @@ struct erofs_configure {
 	int c_force_inodeversion;
 	/* < 0, xattr disabled and INT_MAX, always use inline xattrs */
 	int c_inline_xattr_tolerance;
+
+	u32 c_physical_clusterblks;
 	u64 c_unix_timestamp;
 #ifdef WITH_ANDROID
 	char *mount_point;
diff --git a/lib/config.c b/lib/config.c
index 3ecd48140cfd..352a77c8d639 100644
--- a/lib/config.c
+++ b/lib/config.c
@@ -24,6 +24,7 @@ void erofs_init_configure(void)
 	cfg.c_force_inodeversion = 0;
 	cfg.c_inline_xattr_tolerance = 2;
 	cfg.c_unix_timestamp = -1;
+	cfg.c_physical_clusterblks = 1;
 }
 
 void erofs_show_config(void)
diff --git a/mkfs/main.c b/mkfs/main.c
index c2a0214c84e2..fef94e26e86b 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -62,6 +62,7 @@ static void usage(void)
 	fputs("usage: [options] FILE DIRECTORY\n\n"
 	      "Generate erofs image from DIRECTORY to FILE, and [options] are:\n"
 	      " -zX[,Y]            X=compressor (Y=compression level, optional)\n"
+	      " -C#                specify the size of compress physical cluster in bytes\n"
 	      " -d#                set output message level to # (maximum 9)\n"
 	      " -x#                set xattr tolerance to # (< 0, disable xattrs; default 2)\n"
 	      " -EX[,...]          X=extended options\n"
@@ -152,7 +153,7 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 	char *endptr;
 	int opt, i;
 
-	while((opt = getopt_long(argc, argv, "d:x:z:E:T:U:",
+	while((opt = getopt_long(argc, argv, "d:x:z:E:T:U:C:",
 				 long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'z':
@@ -248,6 +249,17 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 			cfg.fs_config_file = optarg;
 			break;
 #endif
+		case 'C':
+			i = strtoull(optarg, &endptr, 0);
+			if (*endptr != '\0' ||
+			    i < EROFS_BLKSIZ || i % EROFS_BLKSIZ) {
+				erofs_err("invalid physical clustersize %s",
+					  optarg);
+				return -EINVAL;
+			}
+			cfg.c_physical_clusterblks = i / EROFS_BLKSIZ;
+			break;
+
 		case 1:
 			usage();
 			exit(0);
-- 
2.20.1

