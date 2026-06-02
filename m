Return-Path: <linux-erofs+bounces-3495-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 771F0C5DF71
	for <linux-erofs@archiver.kernel.org>; Tue,  2 Jun 2026 04:05:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gTy0y3jFPz2xy3;
	Tue, 02 Jun 2026 14:05:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780373138;
	cv=none; b=JgySRV1WL2P7GO5qQc8V+q9tQF8xaoVv36y+EWtlhd7xHxr0/8YbMUWqk323kn7j7Q+vIwiU2znJMKrNWYBMuoXFuB/aBnsJd67huBuyDz6eSG9BYbVAQUJEj37xY956oVaKfE4L/g0O05MRARdwODhj9jh1rTdtyxjIK9YRLOqraUuP6MHdBbM63bgcR4u4gmEyWTQMT8qd9vgHeBG1tuBHt25EBcj+VCqliMJy4VBa6xUnvMDZX9SsERQ1KqxAx8l+XE7O4+Es7TjNJgGXZGW2mm/AzmEeErP0dRrf+kTOJdVFj21MVivN4vy4LZd8txmvYn1AiCOa0e3eGiMCog==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780373138; c=relaxed/relaxed;
	bh=YNtIWh5sVQ/l1qKA2p+9kNXMo/wKh+Bzx8SIKah1IU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdkOXAfbnLPj2mQaGuYRFwHRwqZtMBFVkvQHnr2e//N8VKsflz3NueTQcfd1M0rg05UeDTKOrk5Ug6c9oKMw2klSi2GhwvFb3yXu11MYbFamHDepSP9SQ9uVvLL1jNBkX5wXE8n9uDCs4ZwzCiD5fqkmE37W8IdCNMeuoJY+e50EXmR2i9GHCZFKtFVwKcaPrbo2ZTWojNnk77uBnkgAL6cFfG9Z78O5KisXvI1MjMQkMSQZ7JxdzpiKrCZSaWsKbRgXChrFmuduHYuV2PPXOXwV0TNxguQtV4XPeH80ermipyyxdSj4DK4BVx7ZTgIaUb7QfZ9Dd43FR8r9p7T8iA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BMZLSMNz; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BMZLSMNz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gTy0w5r6zz2xdh
	for <linux-erofs@lists.ozlabs.org>; Tue, 02 Jun 2026 14:05:36 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780373132; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=YNtIWh5sVQ/l1qKA2p+9kNXMo/wKh+Bzx8SIKah1IU4=;
	b=BMZLSMNzNsykTwQ0qOzYxtuobzOK1moJuk/rFGXPy8G2urEB5NC1bN6bkKJjiPq/bmER6p798sZL7ZnA2wpAzOM53puKnL1mYE7FjXKaEQfjsc1HIZH+J62kBZzL+12dxD8aYRXu9SY733dCAp/LB70Cq3D6ZLa7Mxsm1coSdXo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X43-fqk_1780373130;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X43-fqk_1780373130 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 12:05:30 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH v2 3/3] erofs-utils: mount: integrate ublk backend
Date: Tue,  2 Jun 2026 12:05:23 +0800
Message-ID: <20260602040523.286074-3-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260602040523.286074-1-hsiangkao@linux.alibaba.com>
References: <20260602040523.286074-1-hsiangkao@linux.alibaba.com>
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

Wire up the ublk userspace block device backend into mount.erofs,
providing an alternative to nbd for block device exposure.

Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>
[ Gao Xiang: drop recovery support for now. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 mount/main.c | 182 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 172 insertions(+), 10 deletions(-)

diff --git a/mount/main.c b/mount/main.c
index 140591006e5d..f3f94d04c4cf 100644
--- a/mount/main.c
+++ b/mount/main.c
@@ -23,6 +23,7 @@
 #include "../lib/liberofs_fanotify.h"
 #endif
 #include "../lib/liberofs_s3.h"
+#include "../lib/liberofs_ublk.h"
 
 #ifdef HAVE_LINUX_LOOP_H
 #include <linux/loop.h>
@@ -59,12 +60,19 @@ struct loop_info {
 #define EROFSMOUNT_FANOTIFY_HELP	""
 #endif
 
+#ifdef HAVE_LIBURING
+#define EROFSMOUNT_UBLK_HELP		", ublk"
+#else
+#define EROFSMOUNT_UBLK_HELP		""
+#endif
+
 enum erofs_backend_drv {
 	EROFSAUTO,
 	EROFSLOCAL,
 	EROFSFUSE,
 	EROFSNBD,
 	EROFSFANOTIFY,
+	EROFSUBLK,
 };
 
 enum erofsmount_mode {
@@ -118,7 +126,7 @@ static void usage(int argc, char **argv)
 		" -d <0-9>                   set output verbosity; 0=quiet, 9=verbose (default=%i)\n"
 		" -o options                 comma-separated list of mount options\n"
 		" -t type[.subtype]          filesystem type (and optional subtype)\n"
-		"                            subtypes: fuse, local, nbd" EROFSMOUNT_FANOTIFY_HELP "\n"
+		"                            subtypes: fuse, local, nbd" EROFSMOUNT_FANOTIFY_HELP EROFSMOUNT_UBLK_HELP "\n"
 		" -u                         unmount the filesystem\n"
 		"    --disconnect            abort an existing NBD device forcibly\n"
 		"    --reattach              reattach to an existing NBD device\n"
@@ -466,6 +474,12 @@ static int erofsmount_parse_options(int argc, char **argv)
 #else
 					erofs_err("fanotify backend support is not built-in");
 					return -EINVAL;
+#endif
+				} else if (!strcmp(dot + 1, "ublk")) {
+#ifdef HAVE_LIBURING
+					mountcfg.backend = EROFSUBLK;
+#else
+					erofs_err("ublk backend support is not built-in");
 #endif
 				} else {
 					erofs_err("invalid filesystem subtype `%s`", dot + 1);
@@ -1402,6 +1416,26 @@ out_fork:
 	return num;
 }
 
+static int erofsmount_ublk_handler(void *ctx, struct erofs_ublk_request *rq)
+{
+	struct erofs_vfile *vf = ctx;
+	ssize_t ret;
+
+	if (rq->op != EROFS_UBLK_OP_READ) {
+		rq->result = -EROFS;
+		return -EOPNOTSUPP;
+	}
+
+	ret = erofs_io_pread(vf, rq->buf, rq->nr_sectors << 9,
+			     rq->start_sector << 9);
+	if (ret < 0) {
+		rq->result = -EIO;
+		return (int)ret;
+	}
+	rq->result = ret;
+	return 0;
+}
+
 static int erofsmount_reattach(const char *target)
 {
 	struct erofsmount_nbd_ctx ctx = { .vd = &ctx._vd };
@@ -2037,6 +2071,109 @@ out:
 }
 #endif
 
+static int erofsmount_ublk(struct erofsmount_source *source,
+			   const char *mountpoint, const char *fstype,
+			   int flags, const char *options)
+{
+	char *dev_path, ready;
+	int dev_id, err;
+	int pipefd[2];
+	pid_t pid;
+
+	err = erofs_ublk_init();
+	if (err) {
+		erofs_err("ublk not supported");
+		return err;
+	}
+
+	if (pipe(pipefd) < 0)
+		return -errno;
+
+	pid = fork();
+	if (pid < 0) {
+		close(pipefd[0]);
+		close(pipefd[1]);
+		return -errno;
+	}
+
+	if (pid == 0) {
+		struct erofsmount_nbd_ctx ctx = { .vd = &ctx._vd };
+		struct erofs_ublk_dev_info info;
+		struct stat st;
+
+		close(pipefd[0]);
+		err = erofsmount_open_source(&ctx, source);
+		if (err)
+			exit(EXIT_FAILURE);
+
+		info = (struct erofs_ublk_dev_info) {
+			.nr_hw_queues = EROFS_UBLK_DEF_NR_HW_QUEUES,
+			.queue_depth = EROFS_UBLK_DEF_QUEUE_DEPTH,
+			.max_io_buf_bytes = EROFS_UBLK_DEF_MAX_IO_BUF_BYTES,
+			.dev_id = -1,
+			.blkbits = EROFS_UBLK_DEF_BLK_BITS,
+			.flags = 0,
+			.dev_size = source->type == EROFSMOUNT_SOURCE_LOCAL &&
+				erofs_io_fstat(ctx.vd, &st) == 0 ?
+					st.st_size : INT64_MAX,
+		};
+
+		dev_id = erofs_ublk_create_dev(&info, erofsmount_ublk_handler,
+					       ctx.vd);
+		if (dev_id < 0) {
+			erofs_err("erofs_ublk_create_dev failed: %s",
+				  strerror(-dev_id));
+			exit(EXIT_FAILURE);
+		}
+
+		if (write(pipefd[1], &dev_id,
+			  sizeof(dev_id)) != sizeof(dev_id))
+			exit(EXIT_FAILURE);
+
+		err = erofs_ublk_start(dev_id, pipefd[1]);
+		if (err)
+			erofs_err("erofs_ublk_start: %s", strerror(-err));
+		erofs_ublk_destroy(dev_id);
+		erofs_io_close(ctx.vd);
+		exit(EXIT_SUCCESS);
+	}
+
+	close(pipefd[1]);
+	if (read(pipefd[0], &dev_id, sizeof(dev_id)) != sizeof(dev_id)) {
+		waitpid(pid, NULL, 0);
+		close(pipefd[0]);
+		return -EIO;
+	}
+
+	if (read(pipefd[0], &ready, 1) != 1) {
+		waitpid(pid, NULL, 0);
+		close(pipefd[0]);
+		return -EIO;
+	}
+	close(pipefd[0]);
+
+	if (asprintf(&dev_path, "/dev/ublkb%d", dev_id) < 0)
+		err = -ENOMEM;
+	else
+		err = mount(dev_path, mountpoint, fstype, flags, options);
+	if (err < 0) {
+		err = -errno;
+		kill(pid, SIGTERM);
+		waitpid(pid, NULL, 0);
+		return err;
+	}
+	return 0;
+}
+
+static int ublk_dev_id_from_path(const char *path)
+{
+	int dev_id;
+
+	if (sscanf(path, "/dev/ublkb%d", &dev_id) == 1)
+		return dev_id;
+	return -1;
+}
+
 int erofsmount_umount(char *target)
 {
 	char *device = NULL, *mountpoint = NULL;
@@ -2110,12 +2247,30 @@ int erofsmount_umount(char *target)
 		goto err_out;
 	}
 
-	if (isblk && !mountpoint &&
-	    S_ISBLK(st.st_mode) && major(st.st_rdev) == EROFS_NBD_MAJOR) {
-		nbdnum = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
-		err = erofs_nbd_nl_disconnect(nbdnum);
-		if (err != -EOPNOTSUPP)
-			return err;
+	if (isblk && !mountpoint && S_ISBLK(st.st_mode)) {
+		if (major(st.st_rdev) == EROFS_NBD_MAJOR) {
+			nbdnum = erofs_nbd_get_index_from_minor(minor(st.st_rdev));
+			err = erofs_nbd_nl_disconnect(nbdnum);
+			if (err != -EOPNOTSUPP)
+				goto err_out;
+		} else if ((nbdnum = ublk_dev_id_from_path(target)) >= 0) {
+			err = erofs_ublk_del_dev_by_id(nbdnum);
+			goto err_out;
+		}
+	}
+
+	/* XXX: ublk doesn't have autoclose feature */
+	nbdnum = ublk_dev_id_from_path(device);
+	if (nbdnum >= 0) {
+		if (mountpoint) {
+			err = umount(mountpoint);
+			if (err) {
+				err = -errno;
+				goto err_out;
+			}
+		}
+		err = erofs_ublk_del_dev_by_id(nbdnum);
+		goto err_out;
 	}
 
 	/* Avoid TOCTOU issue with NBD_CFLAG_DISCONNECT_ON_CLOSE */
@@ -2227,13 +2382,20 @@ int main(int argc, char *argv[])
 		goto exit;
 	}
 
-	if (mountcfg.backend == EROFSNBD) {
+	if (mountcfg.backend == EROFSNBD || mountcfg.backend == EROFSUBLK) {
 		if (mountsrc.type == EROFSMOUNT_SOURCE_OCI)
 			mountsrc.ocicfg.image_ref = mountcfg.device;
 		else
 			mountsrc.device_path = mountcfg.device;
-		err = erofsmount_nbd(&mountsrc, mountcfg.target,
-				     mountcfg.fstype, mountcfg.flags, mountcfg.options);
+
+		if (mountcfg.backend == EROFSNBD)
+			err = erofsmount_nbd(&mountsrc, mountcfg.target,
+					     mountcfg.fstype, mountcfg.flags,
+					     mountcfg.options);
+		else
+			err = erofsmount_ublk(&mountsrc, mountcfg.target,
+					      mountcfg.fstype, mountcfg.flags,
+					      mountcfg.options);
 		goto exit;
 	}
 
-- 
2.43.5


