Return-Path: <linux-erofs+bounces-3774-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CD4C43458
	for <linux-erofs@archiver.kernel.org>; Sun, 28 Jun 2026 14:39:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gpBrG1VXjz2yDs;
	Mon, 29 Jun 2026 00:39:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782657566;
	cv=none; b=oFXLsRKl0Jwvm7pjWs62416EgBOCkFU14h4E3UNVdjZKB/2/ZAIRmkw50K3DW76wELFP5g9CUeHJy2PeYkXL0EZNRmjfBXhLfEHeiIJ9mwvD5juXTYHdFa74ThuE2Vx+SMcwsJKqjvl4mpCcyIAXNsKOygKmn3UcTnNFUq01yYSofGnN9Z1Mwqu6L74hOFUbL5zIcnEgR3glfeyL84mvT/7GVnSGrfq0J/U1TihRvPZcTao3BGJZBO0TBQNJYQZsZmuaw/wJwSMUgXhYCNQca39Lk2cXuCgTgTmY5ehgWFEq2q6GHQ92FpcMK9h6Fp8xPapQ3JMAZivCuROyjQPUgg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782657566; c=relaxed/relaxed;
	bh=d93kUc2hrANbQTP/TdKTsRTdr3/Z14zS7WQlowBBmZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gb5OuGtkAo3x7Mu4YY0qOr3pyvhnM/9KkJnfteB6SUoO/xzq/ZD+gbpMN04VvViVBpzBNP/qzqozWE0Z7WfaKGdMrFV07/1aRPb14s3Akcf8M+YMKytn+dmYybIatNfnIZn27EGMGRwZQiA3MqTqNMECw8PfKhdZE1gnANcOkDOtroNx2A6ogpB+S2g6yTTLwHAoRGJXXsDyXPb4zm4rW8qMYsV7/CRlvxyVOfbS9PWdbQW+Ayvep3Rti7zuENDZ1BK8ZhhftZ+rT/4bit4cGqGheCjQubRjvu+6wRXT7FrCD2023uHLrOs7x2jmhaHeY/ywZZD+NhKszRQQ6mPq+Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UYWfIU6o; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UYWfIU6o;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gpBrC75CDz2xjd
	for <linux-erofs@lists.ozlabs.org>; Mon, 29 Jun 2026 00:39:22 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782657557; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=d93kUc2hrANbQTP/TdKTsRTdr3/Z14zS7WQlowBBmZY=;
	b=UYWfIU6oJ5lOOG3SSHi0ybV3URTLY1wXno4hxLGXHjVouVIPC7kDLlDCOunJ6IqiSAOH/0Maw8o9bPb1mSClXkhbhTjfhOoFwauFOzYnW4X332SnkojdAwPUH2XR6Z6EI0t3NkU427razwwS9jtFlIX8jm45z8/UqRq9xsr/CVk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X5kT1Rj_1782657554;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5kT1Rj_1782657554 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 28 Jun 2026 22:39:15 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Chengyu Zhu <hudsonzhu@tencent.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v3 2/2] erofs-utils: mount: rename erofsmount_nbd_ctx to erofsmount_ctx
Date: Sun, 28 Jun 2026 22:39:10 +0800
Message-ID: <20260628143910.1062931-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260628143910.1062931-1-hsiangkao@linux.alibaba.com>
References: <20260624133732.18218-1-hudson@cyzhu.com>
 <20260628143910.1062931-1-hsiangkao@linux.alibaba.com>
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

From: Chengyu Zhu <hudsonzhu@tencent.com>

The struct is shared by NBD, ublk and fanotify paths, so the
nbd-specific name was misleading.

Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 mount/main.c | 79 +++++++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 38 deletions(-)

diff --git a/mount/main.c b/mount/main.c
index dbf5cdddd265..48418275b2d0 100644
--- a/mount/main.c
+++ b/mount/main.c
@@ -772,13 +772,13 @@ err_out:
 	return err;
 }
 
-struct erofsmount_nbd_ctx {
-	struct erofs_vfile _vd;		/* virtual device */
-	struct erofs_vfile sk;		/* socket file */
+struct erofsmount_ctx {
+	struct erofs_vfile _vd;		/* backing source */
+	struct erofs_vfile sk;		/* NBD socket (NBD backend only) */
 	struct erofs_vfile *vd;
 };
 
-static int erofsmount_open_source(struct erofsmount_nbd_ctx *ctx,
+static int erofsmount_open_source(struct erofsmount_ctx *ctx,
 				  struct erofsmount_source *source)
 {
 	int err;
@@ -817,7 +817,7 @@ static int erofsmount_open_source(struct erofsmount_nbd_ctx *ctx,
 
 static void *erofsmount_nbd_loopfn(void *arg)
 {
-	struct erofsmount_nbd_ctx *ctx = arg;
+	struct erofsmount_ctx *ctx = arg;
 	int err;
 
 	while (1) {
@@ -863,7 +863,7 @@ out:
 
 static int erofsmount_startnbd(int nbdfd, struct erofsmount_source *source)
 {
-	struct erofsmount_nbd_ctx ctx = { .vd = &ctx._vd };
+	struct erofsmount_ctx ctx = { .vd = &ctx._vd };
 	uintptr_t retcode;
 	pthread_t th;
 	int err, err2;
@@ -1190,7 +1190,7 @@ static int erofsmount_reattach_oci(struct erofs_vfile *vf,
 #endif
 
 #ifdef S3EROFS_ENABLED
-static int erofsmount_reattach_s3(struct erofsmount_nbd_ctx *ctx, char *source)
+static int erofsmount_reattach_s3(struct erofsmount_ctx *ctx, char *source)
 {
 	char *tokens[5] = {0}, *p = source;
 	char *bucket = NULL, *key = NULL;
@@ -1253,13 +1253,13 @@ err_out:
 	return err;
 }
 #else
-static int erofsmount_reattach_s3(struct erofsmount_nbd_ctx *ctx, char *source)
+static int erofsmount_reattach_s3(struct erofsmount_ctx *ctx, char *source)
 {
 	return -EOPNOTSUPP;
 }
 #endif
 
-static int erofsmount_reattach_gzran_oci(struct erofsmount_nbd_ctx *ctx,
+static int erofsmount_reattach_gzran_oci(struct erofsmount_ctx *ctx,
 					 char *source)
 {
 	char *tokens[6] = {0}, *p = source, *space, *oci_source;
@@ -1313,7 +1313,7 @@ static int erofsmount_reattach_gzran_oci(struct erofsmount_nbd_ctx *ctx,
 	return err;
 }
 
-static int erofsmount_open_recovery_source(struct erofsmount_nbd_ctx *ctx,
+static int erofsmount_open_recovery_source(struct erofsmount_ctx *ctx,
 					   FILE *f)
 {
 	char *line = NULL, *source;
@@ -1398,7 +1398,7 @@ static int erofsmount_startnbd_nl(pid_t *pid, struct erofsmount_source *source)
 		return -errno;
 
 	if ((*pid = fork()) == 0) {
-		struct erofsmount_nbd_ctx ctx = { .vd = &ctx._vd };
+		struct erofsmount_ctx ctx = { .vd = &ctx._vd };
 		char *recp;
 
 		/* Otherwise, NBD disconnect sends SIGPIPE, skipping cleanup */
@@ -1478,7 +1478,7 @@ static int ublk_dev_id_from_path(const char *path)
 
 static int erofsmount_ublk_reattach(int dev_id)
 {
-	struct erofsmount_nbd_ctx ctx = { .vd = &ctx._vd };
+	struct erofsmount_ctx ctx = { .vd = &ctx._vd };
 	char *recp;
 	FILE *f;
 	int err;
@@ -1525,9 +1525,9 @@ static int erofsmount_ublk_reattach(int dev_id)
 
 static int erofsmount_reattach(const char *target)
 {
-	struct erofsmount_nbd_ctx ctx = { .vd = &ctx._vd };
+	struct erofsmount_ctx ctx = { .vd = &ctx._vd };
 	char *identifier;
-	int nbdnum, err;
+	int dev_id, err;
 	struct stat st;
 	FILE *f;
 
@@ -1538,17 +1538,17 @@ static int erofsmount_reattach(const char *target)
 	if (!S_ISBLK(st.st_mode))
 		return -ENOTBLK;
 
-	nbdnum = ublk_dev_id_from_path(target);
-	if (nbdnum >= 0)
-		return erofsmount_ublk_reattach(nbdnum);
+	dev_id = ublk_dev_id_from_path(target);
+	if (dev_id >= 0)
+		return erofsmount_ublk_reattach(dev_id);
 
 	if (major(st.st_rdev) != EROFS_NBD_MAJOR)
 		return -ENOTBLK;
 
-	nbdnum = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
-	if (nbdnum < 0)
-		return nbdnum;
-	identifier = erofs_nbd_get_identifier(nbdnum);
+	dev_id = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
+	if (dev_id < 0)
+		return dev_id;
+	identifier = erofs_nbd_get_identifier(dev_id);
 	if (IS_ERR(identifier)) {
 		identifier = NULL;
 	} else if (identifier && *identifier == '\0') {
@@ -1559,7 +1559,7 @@ static int erofsmount_reattach(const char *target)
 	if (!identifier) {
 		char *recp;
 
-		if (asprintf(&recp, EROFSMOUNT_NBD_REC_FMT, nbdnum) <= 0) {
+		if (asprintf(&recp, EROFSMOUNT_NBD_REC_FMT, dev_id) <= 0) {
 			err = -ENOMEM;
 			goto err_identifier;
 		}
@@ -1577,7 +1577,7 @@ static int erofsmount_reattach(const char *target)
 	if (err)
 		goto err_identifier;
 
-	err = erofs_nbd_nl_reconnect(nbdnum, identifier);
+	err = erofs_nbd_nl_reconnect(dev_id, identifier);
 	if (err >= 0) {
 		ctx.sk.fd = err;
 		if (fork() == 0) {
@@ -2191,7 +2191,7 @@ static int erofsmount_ublk(struct erofsmount_source *source,
 	}
 
 	if (pid == 0) {
-		struct erofsmount_nbd_ctx ctx = { .vd = &ctx._vd };
+		struct erofsmount_ctx ctx = { .vd = &ctx._vd };
 		struct erofs_ublk_dev_info info;
 		char *recp = NULL;
 		struct stat st;
@@ -2275,7 +2275,7 @@ static int erofsmount_ublk(struct erofsmount_source *source,
 int erofsmount_umount(char *target)
 {
 	char *device = NULL, *mountpoint = NULL;
-	int err, fd, nbdnum;
+	int err, fd, dev_id;
 	struct stat st;
 	FILE *mounts;
 	size_t n;
@@ -2347,19 +2347,22 @@ int erofsmount_umount(char *target)
 
 	if (isblk && !mountpoint && S_ISBLK(st.st_mode)) {
 		if (major(st.st_rdev) == EROFS_NBD_MAJOR) {
-			nbdnum = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
-			err = erofs_nbd_nl_disconnect(nbdnum);
+			dev_id = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
+			err = erofs_nbd_nl_disconnect(dev_id);
 			if (err != -EOPNOTSUPP)
 				goto err_out;
-		} else if ((nbdnum = ublk_dev_id_from_path(target)) >= 0) {
-			err = erofs_ublk_del_dev_by_id(nbdnum);
-			goto err_out;
+		} else {
+			dev_id = ublk_dev_id_from_path(target);
+			if (dev_id >= 0) {
+				err = erofs_ublk_del_dev_by_id(dev_id);
+				goto err_out;
+			}
 		}
 	}
 
 	/* XXX: ublk doesn't have autoclose feature */
-	nbdnum = ublk_dev_id_from_path(device);
-	if (nbdnum >= 0) {
+	dev_id = ublk_dev_id_from_path(device);
+	if (dev_id >= 0) {
 		if (mountpoint) {
 			err = umount(mountpoint);
 			if (err) {
@@ -2367,7 +2370,7 @@ int erofsmount_umount(char *target)
 				goto err_out;
 			}
 		}
-		err = erofs_ublk_del_dev_by_id(nbdnum);
+		err = erofs_ublk_del_dev_by_id(dev_id);
 		goto err_out;
 	}
 
@@ -2398,8 +2401,8 @@ int erofsmount_umount(char *target)
 	if (err < 0)
 		err = -errno;
 	else if (S_ISBLK(st.st_mode) && major(st.st_rdev) == EROFS_NBD_MAJOR) {
-		nbdnum = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
-		err = erofs_nbd_nl_disconnect(nbdnum);
+		dev_id = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
+		err = erofs_nbd_nl_disconnect(dev_id);
 		if (err == -EOPNOTSUPP)
 			err = erofs_nbd_disconnect(fd);
 	}
@@ -2413,7 +2416,7 @@ err_out:
 
 static int erofsmount_disconnect(const char *target)
 {
-	int nbdnum, err, fd;
+	int dev_id, err, fd;
 	struct stat st;
 
 	err = lstat(target, &st);
@@ -2423,8 +2426,8 @@ static int erofsmount_disconnect(const char *target)
 	if (!S_ISBLK(st.st_mode) || major(st.st_rdev) != EROFS_NBD_MAJOR)
 		return -ENOTBLK;
 
-	nbdnum = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
-	err = erofs_nbd_nl_disconnect(nbdnum);
+	dev_id = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
+	err = erofs_nbd_nl_disconnect(dev_id);
 	if (err == -EOPNOTSUPP) {
 		fd = open(target, O_RDWR);
 		if (fd < 0) {
-- 
2.43.5


