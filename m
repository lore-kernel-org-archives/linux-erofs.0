Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8F2606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ObFa6B9D
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKtS6kmlz30VX;
	Thu, 12 Nov 2026 23:48:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::634"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487680;
	cv=none; b=MQFQcugH1jJ42+3JhimYVehPtMt15gUH/NbCuIalsceNyIc3okLio6yNiJnShS0b4ICceVUQl4NpSbzKcCEJFVztrqbUIFx91W4BYqXHIE3zCjV16bvGV2fipQOxQR6MWQe2CsBWOgA2w83lOQMQnz7OfwM3Ryj45ALWWpZCzivIjJb0UgaA71OrjrZMyimT8pJpPkhvagC/0nkh7MWgvv9taOcX3ih1Ll/I3dBxTqzwhHCpDry747dUGNP23lDJGpqHr1xmwnQBs8OR9c0dGodwHynje/R3hhCsAx6Dy61hNJShoSVHQUTGuPkQ18En6x6Rjnv7j2Lec/SNnPhLQw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487680; c=relaxed/relaxed;
	bh=RZDSKcPuGqtzaQHWFxvoa7ksnsuaNGpnSReCtiGifrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX55/VfnPW77NqFrUQcx9gEWGewMfLTxUC5KZF3BBrC0dSIBmW/tbn2dvPA77UIKKXwf6f08DMIhbOR3/jmdT1gai5QnCVs0zBuO6XCMTvkt0XUXT5xY3jwqU98rgrH9uo5B3yyTAcLLBXmH3fjEcZ+4QonzT4lswaPyAqDN9JTLGkiMDKYupqOHd47Klx4kK6Sav1JXKzSNUzem3uwIU0OHQCnnE+Et/1LlfTPQV/gauR8SdeSgrT7xeocq8d7mT296EQYsUV3j05fTpBCJNh581T9ArUYtJawOpzVF1f9ewsayxNTIIVUsGpdez+THTbU0h+M6h6OtfHMqcqIKxQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ObFa6B9D; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::634; helo=mail-pl1-x634.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ObFa6B9D;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::634; helo=mail-pl1-x634.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKtS2MJlz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:48:00 +1100 (AEDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-2e942864693so22181445ad.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487678; x=1795092478; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RZDSKcPuGqtzaQHWFxvoa7ksnsuaNGpnSReCtiGifrk=;
        b=ObFa6B9DvhINKzv9i5ss/V2qCPZbFNJMQwtXbI3L9XrIge49IfDGkQ8HmP3wv4tud3
         h2PgrFxylHbfDi+qhyjHgGTC0ePal+0iM1ZBiHa8/8Iki2/P4tLqrr9mPLR9xRIRXXjJ
         51F1HHtDStkn/pS54Hlw73Liw7uWIiulAea6dUdinjMtAxfYT/CMKrGLB9yGh0paIRlC
         4KDSGAiSGTgVckIQP2i9mc6PTME1MSyq4HuOkxltWHY8zhx2W9he/dVPhFaINIBVWfD6
         v4miw1HrQThZALgtY9jtKGnfn7thagQGGeV3MuvhqbOI3uOYhrwXMgopYoScfi0zlq7J
         QWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487678; x=1795092478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RZDSKcPuGqtzaQHWFxvoa7ksnsuaNGpnSReCtiGifrk=;
        b=FZei1GeIdLqdszu6JNWOD6Es4aAxPLVMHOywCQAdMZGgMy6P76WAXt4gJQnHOWM1wc
         FHy9KUmwFKb3AaHmrcPdihVidBc8gtILzHPIZpMZn0s4LCGi5ZeiqbdiJY+c1s/8jSu8
         omI7Bxavn6pLElQVTbyWpWW/y6tT6QTkGgVJ+KTrhYd9fPXCDb6acUfAyJ2ThvEQh8lu
         RS914d/bC+Kj1wyjEq5sQRZduDL0Ctw8gYjebwzSGID5uMbf1xtfCqgAvDBU0c10m/R1
         kYm4jq2ZQaChtQg3T/1beJCa/Qs40O90O2EvZ6fvgR6AU2wqRz7t/z9ua5nKIaWOZqYm
         f89w==
X-Gm-Message-State: APuU4Z/tP277LCpDrZ7wRippYbDNmzjIpLoxzMEydoWNwwuGt1wncRIY
	s6+CBm0azZhC4Nm56fi/VNxdqC1RXHaYqTc3DT+gIMujQW468hNb5oWjioT3RxY+rYg=
X-Gm-Gg: AYBFou1+TcUeDcM78Ooa1Eb3nns3YT2Twwj69PsgRW/4FsaQuabLFB9FM7UmRt57iGA
	+beiTTwn3GQtkxdKM+HcVdOxQ/3tP6DkqffWNni2Y67A8TRQJG6epUOihP2uR4w0mXTUImu8rtR
	Ukx+IM2f5PzFVsbkmXzdEB+lkjtx1+MYcqxfyWMp1435nhcugf7EY6daCm2h7IFKaQnNsRYyrG+
	vWsadmsqjTmI5hIgqHOo71seC+FbOLxj68EhmptFfWpmJDQDSfSReymc8vwj5HWNKkXbngkxGus
	J1PDKjKiIUtvYe4HBaTZTZmwyL5/b+22sLcqOsPO9hBWO2o8v8YXVvudNtyJ6pTdTVPNjLKqxzZ
	yFo5BYs6rVVj1fKQG/BAjNoR7hyCJJonhP69lhROSwXSh/X1x2E7lZrTN6f80MV/O3z5H5CKmRy
	NeMzNk/gsV3oqIWGJCmuNwVtwUAX9L5FsVPDMdO638jmL9ctPhKwoLE4GIzJ27yB9EtCpFv3dDz
	blvUutON15u/VxQb+U4E/7Shxp0DfYn5NMC+bIsKqtBy7rsuSBVsHymumeAw9RCBv0utdqJHzTW
	1TU9Yl9NMAuT7VV4KhmBHOfNsXYjb3xKkrsGD7vWvnZFiQ6c
X-Received: by 2002:a17:903:987:b0:2e2:d77b:e587 with SMTP id d9443c01a7336-2edd776059cmr59784985ad.18.1794487678080;
        Thu, 12 Nov 2026 04:47:58 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:57 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 8/8] erofs-utils: fix read error and short read handling
Date: Thu, 12 Nov 2026 20:47:25 +0800
Message-ID: <20261112124725.2774244-9-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112124725.2774244-1-stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com>
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
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several erofs_io_read() and erofs_io_pread() callers mishandle negative
errors or unexpected short reads, potentially reporting success or
looping at EOF.

Propagate negative errors, reject unexpected short reads and premature
EOF, and preserve the result reported by the ublk handler.

Also cap OCI blob copies at the requested length.

Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/backends/fanotify.c |  3 ++-
 lib/backends/nbd.c      |  2 ++
 lib/backends/ublk.c     |  2 +-
 lib/compress.c          |  2 +-
 lib/fragments.c         |  2 +-
 lib/inode.c             | 11 +++++------
 lib/remotes/oci.c       |  1 +
 lib/super.c             |  2 +-
 mount/main.c            | 10 +++++-----
 9 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/lib/backends/fanotify.c b/lib/backends/fanotify.c
index cf8b616..898ea84 100644
--- a/lib/backends/fanotify.c
+++ b/lib/backends/fanotify.c
@@ -169,7 +169,8 @@ static int erofs_fanotify_handle_range(struct erofs_fanotify_ctx *ctx,
 		  (unsigned long long)(offset + length));
 
 	read_len = erofs_io_pread(&ctx->vd, ctx->fetch_buf, length, offset);
-	if (read_len < 0) {
+	if (read_len != length) {
+		read_len = read_len < 0 ? read_len : -EIO;
 		erofs_err("Failed to fetch range [%llu, %llu): %s",
 			  (unsigned long long)offset,
 			  (unsigned long long)(offset + length),
diff --git a/lib/backends/nbd.c b/lib/backends/nbd.c
index db0df44..81506b1 100644
--- a/lib/backends/nbd.c
+++ b/lib/backends/nbd.c
@@ -600,6 +600,8 @@ int erofs_nbd_get_request(int skfd, struct erofs_nbd_request *rq)
 	int err;
 
 	err = erofs_io_read(&vf, rq, sizeof(*rq));
+	if (err < 0)
+		return err;
 	if (err < sizeof(*rq))
 		return -EPIPE;
 
diff --git a/lib/backends/ublk.c b/lib/backends/ublk.c
index d2c5e19..7fa88d9 100644
--- a/lib/backends/ublk.c
+++ b/lib/backends/ublk.c
@@ -630,7 +630,7 @@ static int ublk_handle_io(struct erofs_ublk_queue *q, int tag)
 		if (ret < 0)
 			io->result = ret;
 		else
-			io->result = req.nr_sectors << 9;
+			io->result = req.result;
 	} else {
 		io->result = -EOPNOTSUPP;
 	}
diff --git a/lib/compress.c b/lib/compress.c
index b5f75ca..e764e44 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1386,7 +1386,7 @@ int z_erofs_compress_segment(struct z_erofs_compress_sctx *ctx,
 			erofs_io_pread(vf, ctx->queue + ctx->tail, rx,
 				       ictx->fpos + offset));
 		if (ret != rx)
-			return -errno;
+			return ret < 0 ? ret : -EIO;
 
 		ctx->remaining -= rx;
 		ctx->tail += rx;
diff --git a/lib/fragments.c b/lib/fragments.c
index 3398888..2313daf 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -148,7 +148,7 @@ int erofs_fragment_findmatch(struct erofs_inode *inode,
 	ret = erofs_io_pread(vf, data, s1, fpos + inode->i_size - s1);
 	if (ret != s1) {
 		free(data);
-		return -errno;
+		return ret < 0 ? ret : -EIO;
 	}
 	e1 = s1 - EROFS_TOF_HASHLEN;
 	deduped = 0;
diff --git a/lib/inode.c b/lib/inode.c
index f687857..c9f8dd6 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -2024,18 +2024,17 @@ static int erofs_set_inode_fingerprint(struct erofs_inode *inode, int fd,
 	if (!ishare_xattr_prefix_id)
 		return 0;
 	erofs_sha256_init(&md);
-	do {
+	while (remaining) {
 		u8 buf[32768];
 
 		ret = erofs_io_pread(&vf, buf,
 				     min_t(u64, remaining, sizeof(buf)), pos);
-		if (ret < 0)
-			return ret;
-		if (ret > 0)
-			erofs_sha256_process(&md, buf, ret);
+		if (ret <= 0)
+			return ret < 0 ? ret : -EIO;
+		erofs_sha256_process(&md, buf, ret);
 		remaining -= ret;
 		pos += ret;
-	} while (remaining);
+	}
 	erofs_sha256_done(&md, out + sizeof("sha256:") - 1);
 #if defined(_WIN32) && !defined(__CYGWIN__)
 	ret = erofs_io_lseek(&vf, pos - inode->i_size, SEEK_SET);
diff --git a/lib/remotes/oci.c b/lib/remotes/oci.c
index 948d699..3e86e91 100644
--- a/lib/remotes/oci.c
+++ b/lib/remotes/oci.c
@@ -1491,6 +1491,7 @@ static ssize_t ocierofs_io_pread(struct erofs_vfile *vf, void *buf, size_t len,
 		return ret;
 
 	if (download_buf && download_size > 0) {
+		download_size = min_t(size_t, download_size, len);
 		memcpy(buf, download_buf, download_size);
 		free(download_buf);
 		return download_size;
diff --git a/lib/super.c b/lib/super.c
index 694a3e9..c6a9230 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -89,7 +89,7 @@ int erofs_read_superblock(struct erofs_sb_info *sbi)
 		return 0;
 
 	read = erofs_io_pread(&sbi->bdev, data, EROFS_MAX_BLOCK_SIZE, 0);
-	if (read < EROFS_SUPER_OFFSET + sizeof(*dsb)) {
+	if (read < 0 || read < EROFS_SUPER_OFFSET + sizeof(*dsb)) {
 		ret = read < 0 ? read : -EIO;
 		erofs_err("cannot read erofs superblock: %s",
 			  erofs_strerror(ret));
diff --git a/mount/main.c b/mount/main.c
index 347a71b..345053b 100644
--- a/mount/main.c
+++ b/mount/main.c
@@ -591,8 +591,8 @@ static ssize_t erofsmount_tarindex_pread(struct erofs_vfile *vf, void *buf,
 	if (index_part) {
 		local_read = erofs_io_pread(&tp->tarindex_vf, buf,
 					    index_part, offset);
-		if (local_read < 0)
-			return local_read;
+		if (local_read != index_part)
+			return local_read < 0 ? local_read : -EIO;
 	}
 	if (tardata_part) {
 		remote_read = erofs_io_pread(tp->zinfo_vf, buf + local_read,
@@ -1460,9 +1460,9 @@ static int erofsmount_ublk_handler(void *ctx, struct erofs_ublk_request *rq)
 
 	ret = erofs_io_pread(vf, rq->buf, rq->nr_sectors << 9,
 			     rq->start_sector << 9);
-	if (ret < 0) {
-		rq->result = -EIO;
-		return (int)ret;
+	if (ret != (rq->nr_sectors << 9)) {
+		rq->result = ret < 0 ? ret : -EIO;
+		return rq->result;
 	}
 	rq->result = ret;
 	return 0;
-- 
2.56.0


