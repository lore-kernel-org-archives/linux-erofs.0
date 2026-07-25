Return-Path: <linux-erofs+bounces-4003-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E13C531C9
	for <linux-erofs@archiver.kernel.org>; Sat, 25 Jul 2026 01:26:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h6Ryw3mCMz2xLq;
	Sat, 25 Jul 2026 11:26:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::431"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784942792;
	cv=none; b=ZYMLIyTFHqLcVNIn8Or9tswwni/6oHDZglKA46TZJAaHJ43kVFIAy3SJqYrrFPe/MK25ajyd+oDJYJyMfVqHioPgtuEMaIPYI26goh5xnOh9Kg0x6bBCdJY59XTGYaq7OtsCv/LeQJShR5PiGeZd3LcGy+tGJWU2gvVI11aDQuSCg2zbB6hwPa3T500UyqUk5lltOmLsSZRoCuig2X7p+HPAf3zsGMhv6CWaEzHJSJuCCuHojiBSl5A48nFoE4Nu455zRkW90ncu7bjR97XC5rLmTCWZiOOX560ssaewPbWu1Pe/EOx1TRRoU78GLGOK0xH5/Zn1y/o+nhRTtv16cA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784942792; c=relaxed/relaxed;
	bh=0G1N/F5AZhCOKxhNG3khfdIZW8Ms77mHLUohHziIu9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ32aAxQ9ZvEitV33W7EqYpUTYt8QJ9CqKX2fhx7Hs9AwE7esyq324q9rEALLAxlL+t2N4hlf2uX17i5xJXNRCpPlpT69b/bwjrvFpkK9zN4hBWyumIIj7ly3iuYvADxGDrrLRJ93tbJjTPeUeaHT2X5GFri0KIurziHraCNJwD9ckwl/GEmo2wN/TqsRCb0sI+Q748d8eBtmcx6LOabqnw2RJlUXlTSEzON0BUHJd5g4BZkxBWruM/YDbzVVGELocBP4vOXELpx5KMCqnHuMOzXKSTGwgxy8S/mBec/pbGlYOyq5byyzM3egKtg2esrFMoZwDiSLH1pXTcHx6jY8w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=H7BSneXs; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::431; helo=mail-pf1-x431.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=H7BSneXs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::431; helo=mail-pf1-x431.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h6Ryt2CGsz2xJT
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 11:26:28 +1000 (AEST)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-8453427d3f4so1109906b3a.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 24 Jul 2026 18:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784942785; x=1785547585; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0G1N/F5AZhCOKxhNG3khfdIZW8Ms77mHLUohHziIu9Y=;
        b=H7BSneXsY/de3yVMGgZUdznb6aseFNR0bigciyG831DcKSSgp6HDSeeOk/U+yBdtdU
         0pt65nrw8x/x3bCNduEKj2v8RO0s2y9TfBsE0UOi1TeXx+RsSAT1yYoq5Ja6Kn5H2TK8
         ahewh9owgQERbCYhgM5Hf25mvp7JrSbhRyCkYxYfhRF2HDve1eoGA46SXRVUdjD+wkiH
         zhoTI06/oZC7L4Fstk7/5G8wQDbHRElac2S614ux2xcV9rmnMWpEQq/doBxttzkuII7N
         N/PwoHljgmT4ZuoeNQn1rS5ctDkJqf8ivPbB2PnTQ9COxGvnxzlR0JMNcYPD//EVhZl9
         eNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784942785; x=1785547585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0G1N/F5AZhCOKxhNG3khfdIZW8Ms77mHLUohHziIu9Y=;
        b=ngcT+WwVMbbPW0tQWNVcw73lSEjxDnow+emoS+UgUrGu1BhJiJS1Tf3b1bDy2V7bZ5
         CKX7KizEM1QdMS9zblQWsQwobk3KAFuIHqybArSG1ujr6xP1GnvftLNGF3lXRNNdm2zc
         iYvNEU9TssmzqzMa1lrEizCG8EGowAdGWaI0wf+nglFNKAglAjNdDd3PTiAtPtP9qAly
         TwgkvRWCWiN42MunwdsDofs4Ef5EMLcqvHf3Qj1ID8UgFeeEVGtkHUWlhLC7v5a/28MC
         Ix6xE17ZewqvcphKUzkCRN9v9sSKzU6OiKcGA3poHK2kz88SFybOvOqnDC5bl0jEbLGh
         epzw==
X-Forwarded-Encrypted: i=1; AHgh+RpxuGnQxNFhC1RqNxquhOD1RkU0zzMCn4UNEY1VLIrFsQ2QZVubiY8X2nbkqtsqqoCvJCuLHtnPaCVvkA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yy1c9/un9KJ/x12L3JXAFZLOr5xjbvb2FJkpe/Gs9c3EkNqGjJi
	I8D03lxzYsXFTg3sg6w0VYKUFmwxPWu2Drppp5AcLgv4kMJldwKPulQjRnK83w==
X-Gm-Gg: AR+sD11iCPh8lF5MqkrkYuGaEZZ+jMkGXzsEDoeE4S8Zurc3ZE7BN8+RYeHgel7N16S
	zRg6AWNAXXGSqsl+hKYvd6snbN7u33KhqTXuxwb8g3DafQYZ+uS0lMc0e0kApwdDhDA1g3mccol
	wkJAmbzpVIRqxYaedwc4m/pwE5vyA6IWBClF7A1CQT76y4fqPY87pQ6R65ka5o1jvuDYGBTKgN4
	9tPHVuVCn8OW5gwJSpyE/oOxk859/bt/Rha777R18UuPc5lrxsfHA+fksQayGXNU4bsIBKTdUYl
	x3RWuYMO0e19YG6gyD3TufMBRDs1LonMpW1Ca4foAqF3iicCykEPcgGIjZwm8iSbzY1LmKKwU2h
	3rNr9ZVJxknvi4n3yrQ5PKwyJuSXQkRd1l/q3B3gQlF3ExMkWYhEpltDedhN44+sgFLrws+sT34
	S7HhScwBHXLzQUrBupSrbrz6wtXOokygxKMpY=
X-Received: by 2002:a05:6a20:2589:b0:3c3:b57b:6455 with SMTP id adf61e73a8af0-3c67e0b1e4fmr607312637.49.1784942785038;
        Fri, 24 Jul 2026 18:26:25 -0700 (PDT)
Received: from localhost.localdomain ([157.15.11.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc548f5dsm4513896eec.17.2026.07.24.18.26.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Jul 2026 18:26:24 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: nithurshen.dev@gmail.com
Cc: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: [PATCH v3 2/2] fsck.erofs: implement concurrent directory traversal
Date: Sat, 25 Jul 2026 06:56:17 +0530
Message-ID: <20260725012617.9193-1-nithurshen.dev@gmail.com>
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
 fsck/main.c          | 465 ++++++++++++++++++++++++++++++++-----------
 include/erofs/cond.h |  31 +++
 include/erofs/lock.h |   2 +
 3 files changed, 382 insertions(+), 116 deletions(-)
 create mode 100644 include/erofs/cond.h

diff --git a/fsck/main.c b/fsck/main.c
index b2d8f1a..a520af9 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -13,25 +13,51 @@
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
+static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid,
+	const char *path, struct erofsfsck_dirstack *dirstack);
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
+static struct erofsfsck_inode_task *traverse_head;
+static struct erofsfsck_inode_task *traverse_tail;
+static int traverse_pending_tasks;
+static bool traverse_shutdown;
+static pthread_t *traverse_workers;
+static int traverse_num_workers;
+static int traverse_final_err;
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
@@ -205,7 +231,6 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 				/* if path is root, start writing from position 0 */
 				if (len == 1 && fsckcfg.extract_path[0] == '/')
 					len = 0;
-				fsckcfg.extract_pos = len;
 			}
 			break;
 		case 3:
@@ -276,7 +301,7 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 	}
 
 	if (fsckcfg.extract_path) {
-		if (!fsckcfg.extract_pos && !fsckcfg.force) {
+		if (!strcmp(fsckcfg.extract_path, "/") && !fsckcfg.force) {
 			erofs_err("--extract=/ must be used together with --force");
 			return -EINVAL;
 		}
@@ -431,7 +456,7 @@ out:
 	return ret;
 }
 
-static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
+static int erofsfsck_dump_xattrs(struct erofs_inode *inode, const char *path)
 {
 	static bool ignore_xattrs = false;
 	char *keylst, *key;
@@ -477,9 +502,8 @@ static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
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
@@ -648,9 +672,19 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
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
@@ -666,11 +700,11 @@ fail_eio:
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
@@ -683,19 +717,18 @@ static inline int erofs_extract_dir(struct erofs_inode *inode)
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
 
@@ -703,25 +736,185 @@ static inline int erofs_extract_dir(struct erofs_inode *inode)
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
 
+static int erofsfsck_enqueue_task(erofs_nid_t pnid, erofs_nid_t nid,
+	const char *path, struct erofsfsck_dirstack *dirstack)
+{
+#ifdef EROFS_MT_ENABLED
+	if (traverse_num_workers > 1) {
+		struct erofsfsck_inode_task *task = malloc(sizeof(*task));
+
+		if (!task)
+			return -ENOMEM;
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
+			if (task->path)
+				free(task->path);
+			free(task);
+			return traverse_final_err;
+		}
+
+		if (!traverse_tail)
+			traverse_head = traverse_tail = task;
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
+	if (err && !traverse_final_err)
+		traverse_final_err = err;
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
+		if (!traverse_head)
+			traverse_tail = NULL;
+		erofs_mutex_unlock(&traverse_mtx);
+
+		int err = erofsfsck_check_inode(task->pnid, task->nid, task->path, &task->dirstack);
+
+		erofs_mutex_lock(&traverse_mtx);
+		if (err && !traverse_final_err)
+			traverse_final_err = err;
+		traverse_pending_tasks--;
+		if (traverse_pending_tasks == 0)
+			erofs_cond_signal(&traverse_cond_finish);
+		erofs_mutex_unlock(&traverse_mtx);
+
+		if (task->path)
+			free(task->path);
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
+	if (traverse_num_workers <= 1)
+		return 0;
+
+	traverse_workers = calloc(traverse_num_workers, sizeof(pthread_t));
+	if (!traverse_workers)
+		return -ENOMEM;
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
+	if (traverse_num_workers <= 1)
+		return traverse_final_err;
+
+	erofs_mutex_lock(&traverse_mtx);
+	while (traverse_pending_tasks > 0)
+		erofs_cond_wait(&traverse_cond_finish, &traverse_mtx);
+
+	int err = traverse_final_err;
+
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
+	char *path = NULL;
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
@@ -739,8 +932,17 @@ static int erofsfsck_hardlink_insert(erofs_nid_t nid, const char *path)
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
 
@@ -819,38 +1021,36 @@ static int erofsfsck_calc_inode_data(struct erofs_inode *inode, int outfd)
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
+					erofs_err("failed to remove: %s (%s)", path,
+						strerror(errno));
 					return -EISDIR;
 				}
 			} else if (errno == EACCES &&
-				   chmod(fsckcfg.extract_path, 0700) < 0) {
-				erofs_err("failed to set permissions: %s (%s)",
-					  fsckcfg.extract_path, strerror(errno));
+				   chmod(path, 0700) < 0) {
+				erofs_err("failed to set permissions: %s (%s)", path,
+					strerror(errno));
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
 
@@ -859,7 +1059,7 @@ again:
 	return ret;
 }
 
-static inline int erofs_extract_symlink(struct erofs_inode *inode)
+static inline int erofs_extract_symlink(struct erofs_inode *inode, const char *path)
 {
 	struct erofs_vfile vf;
 	bool tryagain = true;
@@ -867,7 +1067,7 @@ static inline int erofs_extract_symlink(struct erofs_inode *inode)
 	int ret;
 	char *buf = NULL;
 
-	erofs_dbg("extract symlink to path: %s", fsckcfg.extract_path);
+	erofs_dbg("extract symlink to path: %s", path);
 
 	/* verify data chunk layout */
 	ret = erofs_verify_inode_data(inode, -1, NULL);
@@ -893,21 +1093,18 @@ static inline int erofs_extract_symlink(struct erofs_inode *inode)
 
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
@@ -916,12 +1113,12 @@ out:
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
@@ -929,25 +1126,21 @@ static int erofs_extract_special(struct erofs_inode *inode)
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
@@ -970,42 +1163,53 @@ static int erofsfsck_get_parent_cb(struct erofs_dir_context *ctx)
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
+	if (fctx->path) {
+		size_t prev_len = strlen(fctx->path);
+		size_t curr_len = prev_len + ctx->de_namelen + 1;
 
-	if (prev_pos + ctx->de_namelen + 1 >= PATH_MAX) {
-		erofs_err("unable to fsck since the path is too long (%llu)",
-			  (curr_pos + ctx->de_namelen + 1) | 0ULL);
-		return -EOPNOTSUPP;
-	}
+		if (curr_len >= PATH_MAX) {
+			erofs_err("unable to fsck since the path is too long (%llu)",
+				(unsigned long long)curr_len);
+			return -EOPNOTSUPP;
+		}
+		newpath = malloc(curr_len + 1);
+		if (!newpath)
+			return -ENOMEM;
 
-	if (fsckcfg.extract_path) {
-		fsckcfg.extract_path[curr_pos++] = '/';
-		strncpy(fsckcfg.extract_path + curr_pos, ctx->dname,
-			ctx->de_namelen);
-		curr_pos += ctx->de_namelen;
-		fsckcfg.extract_path[curr_pos] = '\0';
-	} else {
-		curr_pos += ctx->de_namelen + 1;
+		bool is_root = (fctx->path[0] == '/' && fctx->path[1] == '\0');
+		size_t offset = prev_len;
+
+		memcpy(newpath, fctx->path, prev_len);
+		if (!is_root)
+			newpath[offset++] = '/';
+
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
+	if (newpath)
+		free(newpath);
 	return ret;
 }
 
-static int erofsfsck_extract_inode(struct erofs_inode *inode)
+static int erofsfsck_extract_inode(struct erofs_inode *inode, const char *path)
 {
 	char *oldpath;
 	int ret;
@@ -1018,9 +1222,8 @@ verify:
 
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
@@ -1028,19 +1231,19 @@ verify:
 
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
@@ -1053,12 +1256,12 @@ verify:
 
 	/* record nid and old path for hardlink */
 	if (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode))
-		ret = erofsfsck_hardlink_insert(inode->nid,
-						fsckcfg.extract_path);
+		ret = erofsfsck_hardlink_insert(inode->nid, path);
 	return ret;
 }
 
-static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid)
+static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid,
+	const char *path, struct erofsfsck_dirstack *dirstack)
 {
 	int ret, i;
 	struct erofs_inode inode = {.sbi = &g_sbi, .nid = nid};
@@ -1079,43 +1282,57 @@ static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid)
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
+		if (ret == -ECANCELED)
+			ret = 0;
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
 
@@ -1132,7 +1349,6 @@ int main(int argc, char *argv[])
 	fsckcfg.physical_blocks = 0;
 	fsckcfg.logical_blocks = 0;
 	fsckcfg.extract_path = NULL;
-	fsckcfg.extract_pos = 0;
 	fsckcfg.umask = umask(0);
 	fsckcfg.superuser = geteuid() == 0;
 	fsckcfg.corrupted = false;
@@ -1199,6 +1415,10 @@ int main(int argc, char *argv[])
 	if (fsckcfg.extract_path)
 		erofsfsck_hardlink_init();
 
+	err = erofsfsck_traverse_mt_init();
+	if (err)
+		goto exit_hardlink;
+
 	if (fsckcfg.inode_path) {
 		struct erofs_inode inode = { .sbi = &g_sbi };
 
@@ -1218,10 +1438,12 @@ int main(int argc, char *argv[])
 			if (err) {
 				erofs_err("failed to initialize packedfile: %s",
 					  erofs_strerror(err));
-				goto exit_hardlink;
+				goto exit_mt_exit;
 			}
+			struct erofsfsck_dirstack empty_dirstack = {0};
 
-			err = erofsfsck_check_inode(g_sbi.packed_nid, g_sbi.packed_nid);
+			err = erofsfsck_enqueue_task(g_sbi.packed_nid, g_sbi.packed_nid,
+				NULL, &empty_dirstack);
 			if (err) {
 				erofs_err("failed to verify packed file");
 				goto exit_packedinode;
@@ -1232,6 +1454,7 @@ int main(int argc, char *argv[])
 	{
 		erofs_nid_t pnid = fsckcfg.nid;
 
+
 		if (fsckcfg.nid != g_sbi.root_nid) {
 			struct erofs_inode inode = { .sbi = &g_sbi, .nid = fsckcfg.nid };
 
@@ -1246,7 +1469,15 @@ int main(int argc, char *argv[])
 					pnid = ctx.pnid;
 			}
 		}
-		err = erofsfsck_check_inode(pnid, fsckcfg.nid);
+		struct erofsfsck_dirstack empty_dirstack = {0};
+
+		err = erofsfsck_enqueue_task(pnid, fsckcfg.nid, fsckcfg.extract_path,
+			&empty_dirstack);
+
+		int wait_err = erofsfsck_traverse_mt_wait();
+
+		if (wait_err && !err)
+			err = wait_err;
 	}
 
 	if (fsckcfg.corrupted) {
@@ -1272,6 +1503,8 @@ int main(int argc, char *argv[])
 
 exit_packedinode:
 	erofs_packedfile_exit(&g_sbi);
+exit_mt_exit:
+	erofsfsck_traverse_mt_exit();
 exit_hardlink:
 	if (fsckcfg.extract_path)
 		erofsfsck_hardlink_exit();
diff --git a/include/erofs/cond.h b/include/erofs/cond.h
new file mode 100644
index 0000000..c5e2061
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


