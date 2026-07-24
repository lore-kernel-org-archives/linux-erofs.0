Return-Path: <linux-erofs+bounces-3997-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF486C53200
	for <linux-erofs@archiver.kernel.org>; Fri, 24 Jul 2026 14:36:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h69XV1KPNz2yFg;
	Sat, 25 Jul 2026 00:36:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::534"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784903770;
	cv=none; b=fPoOl4euFB5IEgHnsoWwYV1Gll+HHOtku34VVHY5hOFSr7aUhr32lEV5nXsUhFre9zGb4qTuFxz/mYVVF9PE3X35f5fx5tMTnzRZuJQgmkFZA+JWmyA9bdxcdogLGyY+KJU9Jn0xlQ2KQfGCYIB1amUMVqfefUi+JOPsEsz0KtmmkuU8R+MHwWFDxDSPa8lZlZMopjqkyx1CoQEWCI7HhOa0+6cn1ymhcr0yvQjPmtg+shyymKQnRFjiTKEF7sOJJpeTMCstkHbrynvediHmOoNQcmGV1jReojvimd4+U+dphrppB5OEaeY328j6etLofllu2DLoy+ygtYRhz5G81A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784903770; c=relaxed/relaxed;
	bh=yADQoHqRbs+J+ZowlSskCZDtkCiNElLO72dR5qkONok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwgwbPt0rG7n4YmxWzSj53tlA0DW1PpqPR8kVKRxYQAbMJn3CzLUz2i91fCF1jXspGInxmq4sxrRmbIgaebrwmoeH/LUMZpyTdT0ZhwFiC66EB+ptDB30qqXGC53Dv8tCrT6ryPNvyDqWBhyr8lNOmWQhIXsiruyZdredw+dh4B5AlD41K++L6vF3A6MNqmDBUgjlptkWnLITLY1OTlBnfaXE5RmFywdDRZLsy8MFoqcQRfnQL1CrP1Su/xoW2p9yyqZEUtCKrD/YvRsK51jHWbQcakaw7lfsneED/JpZ8hKg84mdfIMyj1jii4Y7Usf1sAL0j+XcKWx4AFmNTWzwA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nrXm6mfc; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::534; helo=mail-pg1-x534.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nrXm6mfc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::534; helo=mail-pg1-x534.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h69XR4yJhz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 00:36:07 +1000 (AEST)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso346388a12.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 24 Jul 2026 07:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784903764; x=1785508564; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yADQoHqRbs+J+ZowlSskCZDtkCiNElLO72dR5qkONok=;
        b=nrXm6mfcDo8Wt1tLVHhqkhZDb29EBi2cGYM1+cP+oDf3H5GEJH46JT22nlX9cl2iVH
         YLo1xBMeFP8lnRnu2KkXXhlU2sZxxr0QVzY/TwkMT883QW0JLeasuP3kCA3yX2WsM0qE
         TIl+nYPiFjnswQn1avlGYZahCq7hVXEfHxPjKchml38B1YXHn7uSGHEvcWguxprH1bYA
         TFDt1+rNzydqADozfO3f2Ft9kkpbe8V56fPMW3HOFr4pSDw0B6esy+CX9XwpimpixfwF
         HDl46a7e+QwxMVvJKqa6pQIgOi+lk/VJAEcqN4D5Y6TKarf7cgiBPpzLfq+qlPIP6iyp
         S8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784903764; x=1785508564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yADQoHqRbs+J+ZowlSskCZDtkCiNElLO72dR5qkONok=;
        b=VTLJs/pr/R15OlJkI365P/mmFKlQXfVzZQzBW+l67RmNeg5Og4dnsN+CGaTZEEc/48
         be3yViFg7xC6HxXP/VMTbp9GXiAj8lgUtJT2+xb4lHlyK/EV9GuuMIK1A0sR+4XtcFn6
         KhVMORZOT0qkTro4JFK4XzqL5S+X46TgzLYvZD3ZEaCEOhwRsrEx7iSnkQ6lx2gqdalH
         QgBtvNPa+QGivzmySFo36xclohuts7DfW/9zpYGVTSu7zeKNwbyQ5qZQ9ZC1VrB+D7kt
         p75NlZzo6gLaofZJnOWTNtbgtQ5njNBMMnwffn87QsqsYIrvO3Fxr2ceTtrG6J+Chi4+
         hGoA==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Ku7q+23LtGtC2Q+rGF3/uDYmfTUKfeGhflSiTucZV9KXbC9Rx73dJKM9+ZjJaMVHjza5YS8Ti9NkTw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxhLexxwtAvEWZTRxpEdkMHzLNkn4wMgCjawv/TpUTXvm6AHeXO
	xTN7qyoMIr5kJHRUxHum4/20v52zNMP0fHLLaBA6nmItAI2AvcLc+7r5Zpc+zg==
X-Gm-Gg: AR+sD129t0jcqXzIdXTOLeK4lYt9c83Eke5LhPI/ICYxYxgqs6nckmEjlpd3jpWoJS1
	hlozi3gTekMmP05IEPI1qy0XFuKFjSnikRWVaOY178B5K/hfQO1txR6tCrE8U733CLerIFiNF2y
	KiIjY/LY10Qm86Gr1c9ag0VKcfHTcTKcpal+bKJqVYVvGXhvV71eyu71+bK1zdndYdCJZeUFPLd
	opqnY0X7eaqWQDGcZtwQCAjUqbqYvSPxu9YG2g1V+NzIGr1VIwTAyo1KaDtLkkPG+lfxVkpeepL
	HJaeSJfQzi0G0ryqjxA2tNUp8W9S0GeiRMFQmR7+EwlJx/TVzh2U9s3cwuUptT+sShu9Qs1UOV/
	fA13UxSngSVZSYFTjiI4msh3Fx9TosmGAVhdlr1M1TMOZOUGJqG32HioqfRmMs1coxUo11eeq26
	NOaVWtxVfZO+/WGjUwgxotYE8Wv4vMNh2W8ZE=
X-Received: by 2002:a05:6a21:6b16:b0:3c3:a31b:3949 with SMTP id adf61e73a8af0-3c44afceac0mr8241182637.11.1784903763643;
        Fri, 24 Jul 2026 07:36:03 -0700 (PDT)
Received: from localhost.localdomain ([157.15.11.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5cb670sm320319eec.31.2026.07.24.07.36.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Jul 2026 07:36:03 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: nithurshen.dev@gmail.com
Cc: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: [PATCH v2 2/2] fsck.erofs: implement concurrent directory traversal
Date: Fri, 24 Jul 2026 20:05:56 +0530
Message-ID: <20260724143556.80914-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260621120121.73114-3-nithurshen.dev@gmail.com>
References: <20260621120121.73114-3-nithurshen.dev@gmail.com>
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

Currently, fsck.erofs traverses the filesystem tree and verifies
inodes synchronously on the main thread. While data decompression is
offloaded, the main thread remains a bottleneck during the I/O-heavy
directory walk.

This patch parallelizes the directory traversal and inode extraction
processes. To achieve this safely, globally shared states such as
fsckcfg.extract_path and fsckcfg.dirstack are decoupled and localized
into individual struct erofsfsck_inode_task payloads. These payloads
are dispatched to a dedicated traversal worker pool.

Global statistics and hardlink tables are now secured using native
erofs_mutex_t primitives. By isolating the traversal producers from
the pcluster decompression consumers, the pipeline scales across
directories without thread pool starvation.

Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
---
 fsck/main.c              | 439 ++++++++++++++++++++++++++++-----------
 include/erofs/cond.h     |  31 +++
 include/erofs/internal.h |  16 ++
 include/erofs/lock.h     |   2 +
 4 files changed, 371 insertions(+), 117 deletions(-)
 create mode 100644 include/erofs/cond.h

diff --git a/fsck/main.c b/fsck/main.c
index b2d8f1a..f03a0c3 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -13,25 +13,50 @@
 #include "erofs/decompress.h"
 #include "erofs/dir.h"
 #include "erofs/xattr.h"
+#include "erofs/internal.h"
+#include "erofs/lock.h"
+#include "erofs/cond.h"
 #include "../lib/compressor.h"
 #include "../lib/liberofs_compress.h"
 #include "../lib/liberofs_sha256.h"
 
-static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid);
-
-static char erofsfsck_nullstr[] = "";
-
 struct erofsfsck_dirstack {
 	erofs_nid_t dirs[PATH_MAX];
 	int top;
 };
 
-struct erofsfsck_cfg {
+static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid, const char *path, struct erofsfsck_dirstack *dirstack);
+
+#ifdef EROFS_MT_ENABLED
+struct erofsfsck_inode_task {
+	struct erofsfsck_inode_task *next;
+	erofs_nid_t pnid;
+	erofs_nid_t nid;
+	char *path;
 	struct erofsfsck_dirstack dirstack;
+};
+
+static erofs_mutex_t traverse_mtx;
+static erofs_cond_t traverse_cond;
+static erofs_cond_t traverse_cond_finish;
+static erofs_mutex_t hardlink_mtx;
+static erofs_mutex_t stats_mtx;
+
+static struct erofsfsck_inode_task *traverse_head = NULL;
+static struct erofsfsck_inode_task *traverse_tail = NULL;
+static int traverse_pending_tasks = 0;
+static bool traverse_shutdown = false;
+static pthread_t *traverse_workers;
+static int traverse_num_workers;
+static int traverse_final_err = 0;
+#endif
+
+static char erofsfsck_nullstr[] = "";
+
+struct erofsfsck_cfg {
 	u64 physical_blocks;
 	u64 logical_blocks;
 	char *extract_path;
-	size_t extract_pos;
 	char *digest_xattr_name;
 	mode_t umask;
 	bool superuser;
@@ -205,7 +230,6 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 				/* if path is root, start writing from position 0 */
 				if (len == 1 && fsckcfg.extract_path[0] == '/')
 					len = 0;
-				fsckcfg.extract_pos = len;
 			}
 			break;
 		case 3:
@@ -276,7 +300,7 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 	}
 
 	if (fsckcfg.extract_path) {
-		if (!fsckcfg.extract_pos && !fsckcfg.force) {
+		if (!strcmp(fsckcfg.extract_path, "/") && !fsckcfg.force) {
 			erofs_err("--extract=/ must be used together with --force");
 			return -EINVAL;
 		}
@@ -431,7 +455,7 @@ out:
 	return ret;
 }
 
-static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
+static int erofsfsck_dump_xattrs(struct erofs_inode *inode, const char *path)
 {
 	static bool ignore_xattrs = false;
 	char *keylst, *key;
@@ -477,9 +501,8 @@ static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
 			free(value);
 			break;
 		}
-		if (fsckcfg.extract_path)
-			ret = erofs_sys_lsetxattr(fsckcfg.extract_path, key,
-						  value, size);
+		if (path)
+			ret = erofs_sys_lsetxattr(path, key, value, size);
 		else
 			ret = 0;
 		free(value);
@@ -648,9 +671,19 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 	}
 
 	if (fsckcfg.print_comp_ratio) {
+		u64 log_blocks = 0;
 		if (!erofs_is_packed_inode(inode))
-			fsckcfg.logical_blocks += BLK_ROUND_UP(inode->sbi, inode->i_size);
-		fsckcfg.physical_blocks += BLK_ROUND_UP(inode->sbi, pchunk_len);
+			log_blocks = BLK_ROUND_UP(inode->sbi, inode->i_size);
+		u64 phys_blocks = BLK_ROUND_UP(inode->sbi, pchunk_len);
+
+#ifdef EROFS_MT_ENABLED
+		erofs_mutex_lock(&stats_mtx);
+#endif
+		fsckcfg.logical_blocks += log_blocks;
+		fsckcfg.physical_blocks += phys_blocks;
+#ifdef EROFS_MT_ENABLED
+		erofs_mutex_unlock(&stats_mtx);
+#endif
 	}
 out:
 	if (raw)
@@ -666,11 +699,11 @@ fail_eio:
 	goto out;
 }
 
-static inline int erofs_extract_dir(struct erofs_inode *inode)
+static inline int erofs_extract_dir(struct erofs_inode *inode, const char *path)
 {
 	int ret;
 
-	erofs_dbg("create directory %s", fsckcfg.extract_path);
+	erofs_dbg("create directory %s", path);
 
 	/* verify data chunk layout */
 	ret = erofs_verify_inode_data(inode, -1, NULL);
@@ -683,19 +716,18 @@ static inline int erofs_extract_dir(struct erofs_inode *inode)
 	 * write/execute permission.  These are fixed up later in
 	 * erofsfsck_set_attributes().
 	 */
-	if (mkdir(fsckcfg.extract_path, 0700) < 0) {
+	if (mkdir(path, 0700) < 0) {
 		struct stat st;
 
 		if (errno != EEXIST) {
 			erofs_err("failed to create directory: %s (%s)",
-				  fsckcfg.extract_path, strerror(errno));
+				  path, strerror(errno));
 			return -errno;
 		}
 
-		if (lstat(fsckcfg.extract_path, &st) ||
+		if (lstat(path, &st) ||
 		    !S_ISDIR(st.st_mode)) {
-			erofs_err("path is not a directory: %s",
-				  fsckcfg.extract_path);
+			erofs_err("path is not a directory: %s", path);
 			return -ENOTDIR;
 		}
 
@@ -703,25 +735,171 @@ static inline int erofs_extract_dir(struct erofs_inode *inode)
 		 * Try to change permissions of existing directory so
 		 * that we can write to it
 		 */
-		if (chmod(fsckcfg.extract_path, 0700) < 0) {
+		if (chmod(path, 0700) < 0) {
 			erofs_err("failed to set permissions: %s (%s)",
-				  fsckcfg.extract_path, strerror(errno));
+				path, strerror(errno));
 			return -errno;
 		}
 	}
 	return 0;
 }
 
+static int erofsfsck_enqueue_task(erofs_nid_t pnid, erofs_nid_t nid, const char *path, struct erofsfsck_dirstack *dirstack)
+{
+#ifdef EROFS_MT_ENABLED
+	if (traverse_num_workers > 1) {
+		struct erofsfsck_inode_task *task = malloc(sizeof(*task));
+		if (!task) return -ENOMEM;
+		
+		task->pnid = pnid;
+		task->nid = nid;
+		task->path = path ? strdup(path) : NULL;
+		task->dirstack = *dirstack;
+		task->next = NULL;
+
+		erofs_mutex_lock(&traverse_mtx);
+		if (traverse_final_err) {
+			erofs_mutex_unlock(&traverse_mtx);
+			if (task->path) free(task->path);
+			free(task);
+			return traverse_final_err;
+		}
+		
+		if (!traverse_tail) traverse_head = traverse_tail = task;
+		else {
+			traverse_tail->next = task;
+			traverse_tail = task;
+		}
+		traverse_pending_tasks++;
+		erofs_cond_signal(&traverse_cond);
+		erofs_mutex_unlock(&traverse_mtx);
+		return 0;
+	}
+#endif
+	int err = erofsfsck_check_inode(pnid, nid, path, dirstack);
+#ifdef EROFS_MT_ENABLED
+	if (err && !traverse_final_err) traverse_final_err = err;
+#endif
+	return err;
+}
+
+#ifdef EROFS_MT_ENABLED
+static void *erofsfsck_traverse_worker(void *arg)
+{
+	while (1) {
+		struct erofsfsck_inode_task *task;
+		
+		erofs_mutex_lock(&traverse_mtx);
+		while (!traverse_head && !traverse_shutdown)
+			erofs_cond_wait(&traverse_cond, &traverse_mtx);
+
+		if (traverse_shutdown && !traverse_head) {
+			erofs_mutex_unlock(&traverse_mtx);
+			break;
+		}
+		
+		task = traverse_head;
+		traverse_head = task->next;
+		if (!traverse_head) traverse_tail = NULL;
+		erofs_mutex_unlock(&traverse_mtx);
+
+		int err = erofsfsck_check_inode(task->pnid, task->nid, task->path, &task->dirstack);
+
+		erofs_mutex_lock(&traverse_mtx);
+		if (err && !traverse_final_err) traverse_final_err = err;
+		traverse_pending_tasks--;
+		if (traverse_pending_tasks == 0)
+			erofs_cond_signal(&traverse_cond_finish);
+		erofs_mutex_unlock(&traverse_mtx);
+
+		if (task->path) free(task->path);
+		free(task);
+	}
+	return NULL;
+}
+#endif
+
+static int erofsfsck_traverse_mt_init(void)
+{
+#ifdef EROFS_MT_ENABLED
+	erofs_mutex_init(&traverse_mtx);
+	erofs_cond_init(&traverse_cond);
+	erofs_cond_init(&traverse_cond_finish);
+	erofs_mutex_init(&hardlink_mtx);
+	erofs_mutex_init(&stats_mtx);
+
+	traverse_num_workers = erofs_get_available_processors();
+	if (traverse_num_workers <= 1) return 0;
+	
+	traverse_workers = calloc(traverse_num_workers, sizeof(pthread_t));
+	if (!traverse_workers) return -ENOMEM;
+	
+	for (int i = 0; i < traverse_num_workers; i++)
+		pthread_create(&traverse_workers[i], NULL, erofsfsck_traverse_worker, NULL);
+#endif
+	return 0;
+}
+
+static void erofsfsck_traverse_mt_exit(void)
+{
+#ifdef EROFS_MT_ENABLED
+	if (traverse_workers) {
+		erofs_mutex_lock(&traverse_mtx);
+		traverse_shutdown = true;
+		erofs_cond_broadcast(&traverse_cond);
+		erofs_mutex_unlock(&traverse_mtx);
+		
+		for (int i = 0; i < traverse_num_workers; i++)
+			pthread_join(traverse_workers[i], NULL);
+		
+		free(traverse_workers);
+		traverse_workers = NULL;
+	}
+	erofs_mutex_destroy(&traverse_mtx);
+	erofs_cond_destroy(&traverse_cond);
+	erofs_cond_destroy(&traverse_cond_finish);
+	erofs_mutex_destroy(&hardlink_mtx);
+	erofs_mutex_destroy(&stats_mtx);
+#endif
+}
+
+static int erofsfsck_traverse_mt_wait(void)
+{
+#ifdef EROFS_MT_ENABLED
+	if (traverse_num_workers <= 1) return traverse_final_err;
+
+	erofs_mutex_lock(&traverse_mtx);
+	while (traverse_pending_tasks > 0)
+		erofs_cond_wait(&traverse_cond_finish, &traverse_mtx);
+	int err = traverse_final_err;
+	erofs_mutex_unlock(&traverse_mtx);
+	return err;
+#else
+	return 0;
+#endif
+}
+
 static char *erofsfsck_hardlink_find(erofs_nid_t nid)
 {
 	struct list_head *head =
 			&erofsfsck_link_hashtable[nid % NR_HARDLINK_HASHTABLE];
 	struct erofsfsck_hardlink_entry *entry;
+	char* path = NULL;
+
+#ifdef EROFS_MT_ENABLED
+	erofs_mutex_lock(&hardlink_mtx);
+#endif
+	list_for_each_entry(entry, head, list) {
+		if (entry->nid == nid) {
+			path = entry->path;
+			break;
+		}
+	}
+#ifdef EROFS_MT_ENABLED
+	erofs_mutex_unlock(&hardlink_mtx);
+#endif
+	return path;
 
-	list_for_each_entry(entry, head, list)
-		if (entry->nid == nid)
-			return entry->path;
-	return NULL;
 }
 
 static int erofsfsck_hardlink_insert(erofs_nid_t nid, const char *path)
@@ -739,8 +917,17 @@ static int erofsfsck_hardlink_insert(erofs_nid_t nid, const char *path)
 		return -ENOMEM;
 	}
 
+#ifdef EROFS_MT_ENABLED
+	erofs_mutex_lock(&hardlink_mtx);
+#endif
+
 	list_add_tail(&entry->list,
 		      &erofsfsck_link_hashtable[nid % NR_HARDLINK_HASHTABLE]);
+
+#ifdef EROFS_MT_ENABLED
+	erofs_mutex_unlock(&hardlink_mtx);
+#endif
+
 	return 0;
 }
 
@@ -819,38 +1006,34 @@ static int erofsfsck_calc_inode_data(struct erofs_inode *inode, int outfd)
 	return erofs_verify_inode_data(inode, outfd, NULL);
 }
 
-static inline int erofs_extract_file(struct erofs_inode *inode)
+static inline int erofs_extract_file(struct erofs_inode *inode, const char *path)
 {
 	bool tryagain = true;
 	int ret, fd;
 
-	erofs_dbg("extract file to path: %s", fsckcfg.extract_path);
+	erofs_dbg("extract file to path: %s", path);
 
 again:
-	fd = open(fsckcfg.extract_path,
+	fd = open(path,
 		  O_WRONLY | O_CREAT | O_NOFOLLOW |
 			(fsckcfg.overwrite ? O_TRUNC : O_EXCL), 0700);
 	if (fd < 0) {
 		if (fsckcfg.overwrite && tryagain) {
 			if (errno == EISDIR) {
-				erofs_warn("try to forcely remove directory %s",
-					   fsckcfg.extract_path);
-				if (rmdir(fsckcfg.extract_path) < 0) {
-					erofs_err("failed to remove: %s (%s)",
-						  fsckcfg.extract_path, strerror(errno));
+				erofs_warn("try to forcely remove directory %s", path);
+				if (rmdir(path) < 0) {
+					erofs_err("failed to remove: %s (%s)",path, strerror(errno));
 					return -EISDIR;
 				}
 			} else if (errno == EACCES &&
-				   chmod(fsckcfg.extract_path, 0700) < 0) {
-				erofs_err("failed to set permissions: %s (%s)",
-					  fsckcfg.extract_path, strerror(errno));
+				   chmod(path, 0700) < 0) {
+				erofs_err("failed to set permissions: %s (%s)", path, strerror(errno));
 				return -errno;
 			}
 			tryagain = false;
 			goto again;
 		}
-		erofs_err("failed to open: %s (%s)", fsckcfg.extract_path,
-			  strerror(errno));
+		erofs_err("failed to open: %s (%s)", path, strerror(errno));
 		return -errno;
 	}
 
@@ -859,7 +1042,7 @@ again:
 	return ret;
 }
 
-static inline int erofs_extract_symlink(struct erofs_inode *inode)
+static inline int erofs_extract_symlink(struct erofs_inode *inode, const char *path)
 {
 	struct erofs_vfile vf;
 	bool tryagain = true;
@@ -867,7 +1050,7 @@ static inline int erofs_extract_symlink(struct erofs_inode *inode)
 	int ret;
 	char *buf = NULL;
 
-	erofs_dbg("extract symlink to path: %s", fsckcfg.extract_path);
+	erofs_dbg("extract symlink to path: %s", path);
 
 	/* verify data chunk layout */
 	ret = erofs_verify_inode_data(inode, -1, NULL);
@@ -893,21 +1076,18 @@ static inline int erofs_extract_symlink(struct erofs_inode *inode)
 
 	buf[inode->i_size] = '\0';
 again:
-	if (symlink(buf, fsckcfg.extract_path) < 0) {
+	if (symlink(buf, path) < 0) {
 		if (errno == EEXIST && fsckcfg.overwrite && tryagain) {
-			erofs_warn("try to forcely remove file %s",
-				   fsckcfg.extract_path);
-			if (unlink(fsckcfg.extract_path) < 0) {
-				erofs_err("failed to remove: %s",
-					  fsckcfg.extract_path);
+			erofs_warn("try to forcely remove file %s", path);
+			if (unlink(path) < 0) {
+				erofs_err("failed to remove: %s", path);
 				ret = -errno;
 				goto out;
 			}
 			tryagain = false;
 			goto again;
 		}
-		erofs_err("failed to create symlink: %s",
-			  fsckcfg.extract_path);
+		erofs_err("failed to create symlink: %s", path);
 		ret = -errno;
 	}
 out:
@@ -916,12 +1096,12 @@ out:
 	return ret;
 }
 
-static int erofs_extract_special(struct erofs_inode *inode)
+static int erofs_extract_special(struct erofs_inode *inode, const char *path)
 {
 	bool tryagain = true;
 	int ret;
 
-	erofs_dbg("extract special to path: %s", fsckcfg.extract_path);
+	erofs_dbg("extract special to path: %s", path);
 
 	/* verify data chunk layout */
 	ret = erofs_verify_inode_data(inode, -1, NULL);
@@ -929,25 +1109,21 @@ static int erofs_extract_special(struct erofs_inode *inode)
 		return ret;
 
 again:
-	if (mknod(fsckcfg.extract_path, inode->i_mode, inode->u.i_rdev) < 0) {
+	if (mknod(path, inode->i_mode, inode->u.i_rdev) < 0) {
 		if (errno == EEXIST && fsckcfg.overwrite && tryagain) {
-			erofs_warn("try to forcely remove file %s",
-				   fsckcfg.extract_path);
-			if (unlink(fsckcfg.extract_path) < 0) {
-				erofs_err("failed to remove: %s",
-					  fsckcfg.extract_path);
+			erofs_warn("try to forcely remove file %s", path);
+			if (unlink(path) < 0) {
+				erofs_err("failed to remove: %s", path);
 				return -errno;
 			}
 			tryagain = false;
 			goto again;
 		}
 		if (errno == EEXIST || fsckcfg.superuser) {
-			erofs_err("failed to create special file: %s",
-				  fsckcfg.extract_path);
+			erofs_err("failed to create special file: %s", path);
 			ret = -errno;
 		} else {
-			erofs_warn("failed to create special file: %s, skipped",
-				   fsckcfg.extract_path);
+			erofs_warn("failed to create special file: %s, skipped", path);
 			ret = -ECANCELED;
 		}
 	}
@@ -970,42 +1146,49 @@ static int erofsfsck_get_parent_cb(struct erofs_dir_context *ctx)
 	return 0;
 }
 
+struct erofsfsck_dir_ctx {
+	struct erofs_dir_context ctx;
+	const char *path;
+	struct erofsfsck_dirstack *dirstack;
+};
+
 static int erofsfsck_dirent_iter(struct erofs_dir_context *ctx)
 {
+	struct erofsfsck_dir_ctx *fctx = (void *)ctx;
 	int ret;
-	size_t prev_pos, curr_pos;
+	char *newpath = NULL;
 
 	if (ctx->dot_dotdot)
 		return 0;
 
-	prev_pos = fsckcfg.extract_pos;
-	curr_pos = prev_pos;
+if (fctx->path) {
+		size_t prev_len = strlen(fctx->path);
+		size_t curr_len = prev_len + ctx->de_namelen + 1;
+		if (curr_len >= PATH_MAX) {
+			erofs_err("unable to fsck since the path is too long (%llu)", (unsigned long long)curr_len);
+			return -EOPNOTSUPP;
+		}
+		newpath = malloc(curr_len + 1);
+		if (!newpath) return -ENOMEM;
 
-	if (prev_pos + ctx->de_namelen + 1 >= PATH_MAX) {
-		erofs_err("unable to fsck since the path is too long (%llu)",
-			  (curr_pos + ctx->de_namelen + 1) | 0ULL);
-		return -EOPNOTSUPP;
-	}
+		bool is_root = (fctx->path[0] == '/' && fctx->path[1] == '\0');
+		size_t offset = prev_len;
 
-	if (fsckcfg.extract_path) {
-		fsckcfg.extract_path[curr_pos++] = '/';
-		strncpy(fsckcfg.extract_path + curr_pos, ctx->dname,
-			ctx->de_namelen);
-		curr_pos += ctx->de_namelen;
-		fsckcfg.extract_path[curr_pos] = '\0';
-	} else {
-		curr_pos += ctx->de_namelen + 1;
+		memcpy(newpath, fctx->path, prev_len);
+		if (!is_root) {
+			newpath[offset++] = '/';
+		}
+		memcpy(newpath + offset, ctx->dname, ctx->de_namelen);
+		offset += ctx->de_namelen;
+		newpath[offset] = '\0';
 	}
-	fsckcfg.extract_pos = curr_pos;
-	ret = erofsfsck_check_inode(ctx->dir->nid, ctx->de_nid);
 
-	if (fsckcfg.extract_path)
-		fsckcfg.extract_path[prev_pos] = '\0';
-	fsckcfg.extract_pos = prev_pos;
+	ret = erofsfsck_enqueue_task(ctx->dir->nid, ctx->de_nid, newpath, fctx->dirstack);
+	if (newpath) free(newpath);
 	return ret;
 }
 
-static int erofsfsck_extract_inode(struct erofs_inode *inode)
+static int erofsfsck_extract_inode(struct erofs_inode *inode, const char *path)
 {
 	char *oldpath;
 	int ret;
@@ -1018,9 +1201,8 @@ verify:
 
 	oldpath = erofsfsck_hardlink_find(inode->nid);
 	if (oldpath) {
-		if (link(oldpath, fsckcfg.extract_path) == -1) {
-			erofs_err("failed to extract hard link: %s (%s)",
-				  fsckcfg.extract_path, strerror(errno));
+		if (link(oldpath, path) == -1) {
+			erofs_err("failed to extract hard link: %s (%s)", path, strerror(errno));
 			return -errno;
 		}
 		return 0;
@@ -1028,19 +1210,19 @@ verify:
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFDIR:
-		ret = erofs_extract_dir(inode);
+		ret = erofs_extract_dir(inode, path);
 		break;
 	case S_IFREG:
-		ret = erofs_extract_file(inode);
+		ret = erofs_extract_file(inode, path);
 		break;
 	case S_IFLNK:
-		ret = erofs_extract_symlink(inode);
+		ret = erofs_extract_symlink(inode, path);
 		break;
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
-		ret = erofs_extract_special(inode);
+		ret = erofs_extract_special(inode, path);
 		break;
 	default:
 		erofs_warn("unsupported file type %o @ nid %llu, skipped extraction",
@@ -1053,12 +1235,11 @@ verify:
 
 	/* record nid and old path for hardlink */
 	if (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode))
-		ret = erofsfsck_hardlink_insert(inode->nid,
-						fsckcfg.extract_path);
+		ret = erofsfsck_hardlink_insert(inode->nid, path);
 	return ret;
 }
 
-static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid)
+static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid, const char *path, struct erofsfsck_dirstack *dirstack)
 {
 	int ret, i;
 	struct erofs_inode inode = {.sbi = &g_sbi, .nid = nid};
@@ -1079,43 +1260,56 @@ static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid)
 			goto out;
 	}
 
-	ret = erofsfsck_extract_inode(&inode);
+	ret = erofsfsck_extract_inode(&inode, path);
 	if (ret && ret != -ECANCELED)
 		goto out;
 
 	if (fsckcfg.check_decomp && fsckcfg.dump_xattrs) {
-		ret = erofsfsck_dump_xattrs(&inode);
+		ret = erofsfsck_dump_xattrs(&inode, path);
 		if (ret)
 			return ret;
 	}
 
 	if (S_ISDIR(inode.i_mode)) {
-		struct erofs_dir_context ctx = {
-			.flags = EROFS_READDIR_VALID_PNID,
-			.pnid = pnid,
-			.dir = &inode,
-			.cb = erofsfsck_dirent_iter,
+		struct erofsfsck_dir_ctx ctx = {
+			.ctx.flags = EROFS_READDIR_VALID_PNID,
+			.ctx.pnid = pnid,
+			.ctx.dir = &inode,
+			.ctx.cb = erofsfsck_dirent_iter,
+			.path = path,
+			.dirstack = dirstack,
 		};
+		struct erofsfsck_dirstack next_dirstack;
 
-		/* XXX: support the deeper cases later */
-		if (fsckcfg.dirstack.top >= ARRAY_SIZE(fsckcfg.dirstack.dirs))
+		if (dirstack->top >= ARRAY_SIZE(dirstack->dirs))
 			return -ENAMETOOLONG;
-		for (i = 0; i < fsckcfg.dirstack.top; ++i)
-			if (inode.nid == fsckcfg.dirstack.dirs[i])
+
+		for (i = 0; i < dirstack->top; ++i) {
+			if (inode.nid == dirstack->dirs[i])
 				return -ELOOP;
-		fsckcfg.dirstack.dirs[fsckcfg.dirstack.top++] = pnid;
-		ret = erofs_iterate_dir(&ctx, true);
-		--fsckcfg.dirstack.top;
+		}
+
+		next_dirstack = *dirstack;
+		next_dirstack.dirs[next_dirstack.top++] = pnid;
+		ctx.dirstack = &next_dirstack;
+
+		ret = erofs_iterate_dir(&ctx.ctx, true);
+		if (ret == -ECANCELED) ret = 0;
 	}
 
 	if (!ret && !erofs_is_packed_inode(&inode))
-		erofsfsck_set_attributes(&inode, fsckcfg.extract_path);
+		erofsfsck_set_attributes(&inode, (char *)path);
 
-	if (ret == -ECANCELED)
-		ret = 0;
 out:
-	if (ret && ret != -EIO)
+	if (ret && ret != -EIO) {
+#ifdef EROFS_MT_ENABLED
+		erofs_mutex_lock(&traverse_mtx);
+#endif
 		fsckcfg.corrupted = true;
+#ifdef EROFS_MT_ENABLED
+		erofs_mutex_unlock(&traverse_mtx);
+#endif
+	}
 	return ret;
 }
 
@@ -1132,7 +1326,6 @@ int main(int argc, char *argv[])
 	fsckcfg.physical_blocks = 0;
 	fsckcfg.logical_blocks = 0;
 	fsckcfg.extract_path = NULL;
-	fsckcfg.extract_pos = 0;
 	fsckcfg.umask = umask(0);
 	fsckcfg.superuser = geteuid() == 0;
 	fsckcfg.corrupted = false;
@@ -1199,6 +1392,10 @@ int main(int argc, char *argv[])
 	if (fsckcfg.extract_path)
 		erofsfsck_hardlink_init();
 
+	err = erofsfsck_traverse_mt_init();
+	if (err)
+		goto exit_hardlink;
+
 	if (fsckcfg.inode_path) {
 		struct erofs_inode inode = { .sbi = &g_sbi };
 
@@ -1218,10 +1415,11 @@ int main(int argc, char *argv[])
 			if (err) {
 				erofs_err("failed to initialize packedfile: %s",
 					  erofs_strerror(err));
-				goto exit_hardlink;
+				goto exit_mt_exit;
 			}
-
-			err = erofsfsck_check_inode(g_sbi.packed_nid, g_sbi.packed_nid);
+			struct erofsfsck_dirstack empty_dirstack = {0};
+			err = erofsfsck_enqueue_task(g_sbi.packed_nid, g_sbi.packed_nid, 
+				NULL, &empty_dirstack);
 			if (err) {
 				erofs_err("failed to verify packed file");
 				goto exit_packedinode;
@@ -1232,6 +1430,7 @@ int main(int argc, char *argv[])
 	{
 		erofs_nid_t pnid = fsckcfg.nid;
 
+
 		if (fsckcfg.nid != g_sbi.root_nid) {
 			struct erofs_inode inode = { .sbi = &g_sbi, .nid = fsckcfg.nid };
 
@@ -1246,7 +1445,11 @@ int main(int argc, char *argv[])
 					pnid = ctx.pnid;
 			}
 		}
-		err = erofsfsck_check_inode(pnid, fsckcfg.nid);
+		struct erofsfsck_dirstack empty_dirstack = {0};
+		err = erofsfsck_enqueue_task(pnid, fsckcfg.nid, fsckcfg.extract_path, &empty_dirstack);
+		int wait_err = erofsfsck_traverse_mt_wait();
+		if (wait_err && !err)
+			err = wait_err;
 	}
 
 	if (fsckcfg.corrupted) {
@@ -1272,6 +1475,8 @@ int main(int argc, char *argv[])
 
 exit_packedinode:
 	erofs_packedfile_exit(&g_sbi);
+exit_mt_exit:
+	erofsfsck_traverse_mt_exit();
 exit_hardlink:
 	if (fsckcfg.extract_path)
 		erofsfsck_hardlink_exit();
diff --git a/include/erofs/cond.h b/include/erofs/cond.h
new file mode 100644
index 0000000..90ec838
--- /dev/null
+++ b/include/erofs/cond.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR Apache-2.0 */
+#ifndef __EROFS_COND_H
+#define __EROFS_COND_H
+
+#include "lock.h"
+
+#if defined(HAVE_PTHREAD_H) && defined(EROFS_MT_ENABLED)
+#include <pthread.h>
+
+typedef pthread_cond_t erofs_cond_t;
+
+static inline void erofs_cond_init(erofs_cond_t *cond)
+{
+	pthread_cond_init(cond, NULL);
+}
+#define erofs_cond_wait		pthread_cond_wait
+#define erofs_cond_signal	pthread_cond_signal
+#define erofs_cond_broadcast	pthread_cond_broadcast
+#define erofs_cond_destroy	pthread_cond_destroy
+
+#else
+typedef struct {} erofs_cond_t;
+
+static inline void erofs_cond_init(erofs_cond_t *cond) {}
+static inline int erofs_cond_wait(erofs_cond_t *cond, erofs_mutex_t *mutex) { return 0; }
+static inline int erofs_cond_signal(erofs_cond_t *cond) { return 0; }
+static inline int erofs_cond_broadcast(erofs_cond_t *cond) { return 0; }
+static inline int erofs_cond_destroy(erofs_cond_t *cond) { return 0; }
+#endif
+
+#endif
\ No newline at end of file
diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 2cc9cc8..1fa655b 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -63,6 +63,7 @@ struct erofs_buf {
 #define BLK_ROUND_UP(sbi, addr)	\
 	(roundup(addr, erofs_blksiz(sbi)) >> (sbi)->blkszbits)
 
+
 struct erofs_buffer_head;
 struct erofs_bufmgr;
 
@@ -451,6 +452,21 @@ struct z_erofs_paramset {
 	char *extraopts;
 };
 
+struct z_erofs_decompress_task;
+struct z_erofs_mt_read_ctx;
+
+struct z_erofs_decompress_task;
+struct z_erofs_mt_read_ctx;
+
+struct z_erofs_mt_read_ctx *z_erofs_mt_read_ctx_alloc(int outfd, bool free_out);
+int z_erofs_mt_read_ctx_wait(struct z_erofs_mt_read_ctx *ctx);
+void z_erofs_mt_read_ctx_free(struct z_erofs_mt_read_ctx *ctx);
+void z_erofs_mt_read_enqueue(struct z_erofs_mt_read_ctx *ctx);
+
+int z_erofs_mt_workers_init(void);
+void z_erofs_mt_workers_exit(void);
+
+
 int liberofs_global_init(void);
 void liberofs_global_exit(void);
 
diff --git a/include/erofs/lock.h b/include/erofs/lock.h
index 884f23e..673465f 100644
--- a/include/erofs/lock.h
+++ b/include/erofs/lock.h
@@ -15,6 +15,7 @@ static inline void erofs_mutex_init(erofs_mutex_t *lock)
 }
 #define erofs_mutex_lock	pthread_mutex_lock
 #define erofs_mutex_unlock	pthread_mutex_unlock
+#define erofs_mutex_destroy pthread_mutex_destroy
 
 #define EROFS_DEFINE_MUTEX(lock)	\
 	erofs_mutex_t lock = PTHREAD_MUTEX_INITIALIZER
@@ -35,6 +36,7 @@ typedef struct {} erofs_mutex_t;
 static inline void erofs_mutex_init(erofs_mutex_t *lock) {}
 static inline void erofs_mutex_lock(erofs_mutex_t *lock) {}
 static inline void erofs_mutex_unlock(erofs_mutex_t *lock) {}
+static inline void erofs_mutex_destroy(erofs_mutex_t *lock) {}
 
 #define EROFS_DEFINE_MUTEX(lock)	\
 	erofs_mutex_t lock = {}
-- 
2.53.0


