Return-Path: <linux-erofs+bounces-4006-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FE7C531CC
	for <linux-erofs@archiver.kernel.org>; Sun, 26 Jul 2026 11:01:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7Jgs50Lkz2yFP;
	Sun, 26 Jul 2026 21:01:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1030"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785063689;
	cv=none; b=G/wUsvvIeJFnCJQHW/oymyux+hsw/wQZKdS1y6zOPevQ0lEBp7KWYgmFI9dD0DOjqkgBo6luX9UNbFDvqQn0uhlvksGf2f89vmJXv9oYe2uhHhanH96enPGjkn8BMwyLcmWbXSiUkIzqOm1SpQrzws1EbtnfL2oKb531/rHIM9yTBimU5QDGa44Ec05+fFa3Bi+M2m6QbHIefCgvLfA3uZKJL2Qe1H+UNGiQNXbYgyFYW+CR/cdMQbTRGR/Jt5slT6Tp85T2L0ygYIS0MceMPXlrmJLT4FkntxYGYOnGBRpBCGXylO1IzUcAJtTorN3MCenwF1jGcqWkHUjZQdsf7w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785063689; c=relaxed/relaxed;
	bh=8PMbCiX6060qr5cBZeDDnATO82pzUptWoxwTNOBv7tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhgctHQCzhyySHzFMRoVuUHCGJo2Y2NHoKwcObni+4rzK1HFC+WJdn6yV3iXpChKPr8znagADpS9thwzCmuvL44PnU7hnz7v1AvDf1l4aZY5+ejOTRLEBTAJFcklTUa1VGywkowqdT8quCi4Sd+8sUzfTcUIoDDgzbk4VDLdEKGknhK+UQULodwG/A5GOiInqWj6YrFXPZ/ZeD378EWN0SfyiqBD0uhbBodV8+PytzlGMKffHhkysvR97QLZ3qV8wjZL3/pxy/L5B5fKU6X7otrThcFpulj8Kzbv/NSJUBqmgmhqDMIT2rZ1ZqSeHNsxhxMwAoMR4mc5sX6UuOXBRQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=R+hsL90F; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1030; helo=mail-pj1-x1030.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=R+hsL90F;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1030; helo=mail-pj1-x1030.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7Jgr0BRPz2xyk
	for <linux-erofs@lists.ozlabs.org>; Sun, 26 Jul 2026 21:01:27 +1000 (AEST)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-3811f512167so1656992a91.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 26 Jul 2026 04:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785063684; x=1785668484; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8PMbCiX6060qr5cBZeDDnATO82pzUptWoxwTNOBv7tg=;
        b=R+hsL90F136lqm50wbR3wImmpHql9x8nUecZUJxL74opp+Zcnji0JnCYn03SscOCAD
         O9OQ/6fNW0Bbm7cEIsv/6Kv4GXzcBIpexhk3Aycjvwcb7wtaW7r49H7niGAElzZ3/7tk
         BWlPtkzfsUlINs6iXmBH32tqbpHWNN6/BKyPQhtEXsVRo9v4K5XOlPzX0sMPxq92pmnb
         dkPQ4pUq0HXCG1Tp9pSIpLcgMPGLAc7C5JKtYZRQpWegif7uCV98w4Kmz1/ydQ2i6sn1
         BAojbTQq8az5XHBpRc1IruBO5/uE3DuFdVQZMQj95ysjyrivKTecGuF9QRCLIZjg2T4v
         HWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785063684; x=1785668484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8PMbCiX6060qr5cBZeDDnATO82pzUptWoxwTNOBv7tg=;
        b=du204V0qTEfyx11ZqZLX5/c26jKGkImCLhY04rjICbCN3HblsyBPfwmz3ZJ9dwVl9b
         loMev95KQRCj3ItUqid7HRZMKZ2j2YDkvazkAy712BYCVQS7BY0SHS7SkVI9Pc58jeza
         szQwAM4nbiIV6IAjoNpp+JJfEDy7RLEldFK1bP0i1buhZFj2vP5w6/55KHEOnG6pnUfE
         BBUhjXnKU+VQgRKlzhp+69Fzsym6nk/6LymWMk9S32jxByk9Bjl2OA3xZY5Swa8oL0j3
         sEPPnZfAfK/CG02HAJzLhI7LlShSrIjx5xU/BZVInOxDDenkcsUWxUrpC9he4glRW+A6
         W39Q==
X-Forwarded-Encrypted: i=1; AHgh+RpiN1qwkOJdlyqJz8NT4SHHX4swynXbMnif1Ayo6Z3ykGYYt2tMmQ973j+mokTGbu+v/BFIbNhkpybJJw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyYEuKP1Or9fV1qPjoG06O4fxwRFz19IN6gc85ZTJ37cGlK1PsJ
	GjTZWuSavoK/qYgqH+L++ylxFnBPxr79kBRPdba3XNkE7jejlZMNW49lWTnQvQ==
X-Gm-Gg: AR+sD13asKfj/cFI+5RvjkN5Qfn85vHiAQZiRji+k02sqhqFoIuYi/8XEmEcw+eEGM4
	dVfR6IgmPTHVPu0tmQrMMO2RXWheSRRIa2kDITDMwOGm8BdEHvBEQBZk34RNZt8KJ9rZjgc2Avp
	iN+rHP794TX/0O1L0uz1KFR/5+X6Bv1pPcTbV8jmNTZpNl4zay4JcTUmBO3MHC4QRYOO1e5smKy
	C35OuE86jmPf4r71ufOApl3AtAVGtqUenL/od4Uq/uFXMFNcFbHXq3zUvqzd54Ht3q13CrCEwrs
	JZ61VWfISMqK+dPK3e/0F/mUUzGmwYc53rHhDGiYbio1G9t3HzyQx/NdD1ybY01b+nuEQSxE7Hk
	moVmupBEP1fcZ2lyWbKD8L8uvqUydmrZiIjLmRdEPTDYB9WwCGNC6E2WBtMJupGR4gWgBlPmXBK
	BoirffyLjGHUAAb8cA8y78Rd1WxZ4QZRTur0F3R1ru5KZ/SQ==
X-Received: by 2002:a17:90b:57e5:b0:38e:2524:724f with SMTP id 98e67ed59e1d1-38f294ea3a3mr4517001a91.12.1785063684349;
        Sun, 26 Jul 2026 04:01:24 -0700 (PDT)
Received: from localhost.localdomain ([157.15.11.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc447f6bsm22407064eec.12.2026.07.26.04.01.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Jul 2026 04:01:23 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: nithurshen.dev@gmail.com
Cc: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: [PATCH v6] fsck.erofs: add multi-threaded decompression
Date: Sun, 26 Jul 2026 16:31:16 +0530
Message-ID: <20260726110116.61634-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260714011054.71167-1-nithurshen.dev@gmail.com>
References: <20260714011054.71167-1-nithurshen.dev@gmail.com>
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

Currently, fsck.erofs extracts files synchronously. When decompressing
heavily compressed images, the main thread spends most of its time
blocked on a combination of synchronous I/O syscalls and CPU-heavy
decompression routines, bottlenecking overall extraction.

This patch introduces a scalable, multi-threaded decompression
framework to decouple compute operations from the main thread's I/O.
This is achieved by implementing a dedicated, per-CPU worker queue
system alongside custom condition variable wrappers to handle
decompression tasks asynchronously.

To prevent scheduling overhead (futex contention) where worker threads
spend more CPU time waking up than actually decompressing small
clusters, this implementation introduces a batching context
(`z_erofs_mt_read_ctx`). The batch limit is algorithm-aware (e.g.,
batching up to 32 clusters for LZ4/ZSTD vs. 8 for higher-latency
compressors).

Additionally, multi-threading is bypassed entirely for files under a
128KB threshold, and ultra-fast algorithms (LZ4/ZSTD) are executed
synchronously on the traversal thread once batched to avoid queueing
latency.

This patch builds directly on top of the parallel directory traversal
support, enabling full parallelization across both metadata traversal
and data decompression pipelines.

Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
---
 fsck/main.c              | 117 +++++++++----
 include/erofs/internal.h |  16 +-
 lib/data.c               | 356 ++++++++++++++++++++++++++++++++++++---
 lib/global.c             |  12 +-
 4 files changed, 446 insertions(+), 55 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index a520af9..5870564 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -20,6 +20,8 @@
 #include "../lib/liberofs_compress.h"
 #include "../lib/liberofs_sha256.h"
 
+#define EROFS_MT_THRESHOLD (128 * 1024)
+
 struct erofsfsck_dirstack {
 	erofs_nid_t dirs[PATH_MAX];
 	int top;
@@ -550,6 +552,7 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 	u64 pchunk_len = 0;
 	u64 raw_size = 0, buffer_size = 0;
 	char *raw = NULL, *buffer = NULL;
+	struct z_erofs_mt_read_ctx *ctx = NULL;
 
 	erofs_dbg("verify data chunk of nid(%llu): type(%d)",
 		  inode->nid | 0ULL, inode->datalayout);
@@ -563,6 +566,16 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 		if (ret)
 			goto out;
 
+		if (!ctx && !digest && inode->i_size > EROFS_MT_THRESHOLD && compressed &&
+		    (map.m_algorithmformat == Z_EROFS_COMPRESSION_LZMA ||
+		     map.m_algorithmformat == Z_EROFS_COMPRESSION_DEFLATE)) {
+			ctx = z_erofs_mt_read_ctx_alloc(outfd, true);
+			if (!ctx) {
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
+
 		if (!compressed && map.m_llen != map.m_plen) {
 			erofs_err("broken chunk length m_la %" PRIu64 " m_llen %" PRIu64 " m_plen %" PRIu64,
 				  map.m_la, map.m_llen, map.m_plen);
@@ -593,7 +606,7 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 						(const u8 *)zeros, chunk);
 					remain -= chunk;
 				}
-			} else if (outfd >= 0) {
+			} else if (!ctx && outfd >= 0) {
 				ret = lseek(outfd, map.m_llen, SEEK_CUR);
 				if (ret < 0) {
 					ret = -errno;
@@ -616,19 +629,33 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 			alloc_rawsize = map.m_plen;
 		}
 
-		if (alloc_rawsize > raw_size) {
-			char *newraw = realloc(raw, alloc_rawsize);
+		if (!ctx) {
+			if (alloc_rawsize > raw_size) {
+				char *newraw = realloc(raw, alloc_rawsize);
 
-			if (!newraw) {
-				ret = -ENOMEM;
-				goto out;
+				if (!newraw) {
+					ret = -ENOMEM;
+					goto out;
+				}
+				raw = newraw;
+				raw_size = alloc_rawsize;
 			}
-			raw = newraw;
-			raw_size = alloc_rawsize;
 		}
 
 		if (compressed) {
-			if (map.m_llen > buffer_size) {
+			char *c_raw = raw;
+			char *c_buf = buffer;
+
+			if (ctx) {
+				c_raw = malloc(alloc_rawsize);
+				c_buf = malloc(map.m_llen);
+				if (!c_raw || !c_buf) {
+					free(c_raw);
+					free(c_buf);
+					ret = -ENOMEM;
+					goto out;
+				}
+			} else if (map.m_llen > buffer_size) {
 				char *newbuffer;
 
 				buffer_size = map.m_llen;
@@ -638,39 +665,58 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 					goto out;
 				}
 				buffer = newbuffer;
+				c_buf = buffer;
 			}
-			ret = z_erofs_read_one_data(inode, &map, raw, buffer,
-						    0, map.m_llen, false);
-			if (ret)
+
+			ret = z_erofs_read_one_data(inode, &map, c_raw, c_buf,
+						    0, map.m_llen, false,
+						    map.m_la, ctx);
+			if (ret < 0)
 				goto out;
 
-			if (digest)
-				erofs_sha256_process(digest,
-					(const u8 *)buffer, map.m_llen);
-			if (outfd >= 0 && write(outfd, buffer, map.m_llen) < 0)
-				goto fail_eio;
+			if (!ctx) {
+				if (digest)
+					erofs_sha256_process(digest,
+						(const u8 *)c_buf, map.m_llen);
+				if (outfd >= 0 && write(outfd, c_buf, map.m_llen) < 0)
+					goto fail_eio;
+			}
 		} else {
 			u64 p = 0;
+			erofs_off_t m_llen = map.m_llen;
 
 			do {
-				u64 count = min_t(u64, alloc_rawsize,
-						  map.m_llen);
+				u64 count = min_t(u64, alloc_rawsize, m_llen);
 
 				ret = erofs_read_one_data(inode, &map, raw, p, count);
-				if (ret)
+				if (ret < 0)
 					goto out;
 
-				if (digest)
-					erofs_sha256_process(digest,
-						(const u8 *)raw, count);
-				if (outfd >= 0 && write(outfd, raw, count) < 0)
-					goto fail_eio;
-				map.m_llen -= count;
+				if (!ctx) {
+					if (digest)
+						erofs_sha256_process(digest,
+							(const u8 *)raw, count);
+					if (outfd >= 0 && write(outfd, raw, count) < 0)
+						goto fail_eio;
+				} else if (outfd >= 0) {
+					if (pwrite(outfd, raw, count, map.m_la + p) < 0)
+						goto fail_eio;
+				}
+				m_llen -= count;
 				p += count;
-			} while (map.m_llen);
+			} while (m_llen);
 		}
 	}
 
+	if (ctx) {
+		int wait_err;
+
+		z_erofs_mt_read_enqueue(ctx);
+		wait_err = z_erofs_mt_read_ctx_wait(ctx);
+		if (wait_err < 0 && ret == 0)
+			ret = wait_err;
+	}
+
 	if (fsckcfg.print_comp_ratio) {
 		u64 log_blocks = 0;
 		if (!erofs_is_packed_inode(inode))
@@ -687,6 +733,17 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 #endif
 	}
 out:
+	if (outfd >= 0 && ret == 0) {
+		if (ftruncate(outfd, inode->i_size) < 0) {
+			erofs_err("failed to truncate file to %llu: %d",
+				  (unsigned long long)inode->i_size, errno);
+			if (ret == 0)
+				ret = -errno;
+		}
+	}
+
+	if (ctx)
+		z_erofs_mt_read_ctx_free(ctx);
 	if (raw)
 		free(raw);
 	if (buffer)
@@ -1344,7 +1401,9 @@ int main(int argc, char *argv[])
 {
 	int err;
 
-	erofs_init_configure();
+	err = liberofs_global_init();
+	if (err)
+		return 1;
 
 	fsckcfg.physical_blocks = 0;
 	fsckcfg.logical_blocks = 0;
@@ -1516,7 +1575,7 @@ exit_dev_close:
 	erofs_dev_close(&g_sbi);
 exit:
 	erofs_blob_closeall(&g_sbi);
-	erofs_exit_configure();
+	liberofs_global_exit();
 	return err ? 1 : 0;
 }
 
diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 2cc9cc8..d663f57 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -63,6 +63,8 @@ struct erofs_buf {
 #define BLK_ROUND_UP(sbi, addr)	\
 	(roundup(addr, erofs_blksiz(sbi)) >> (sbi)->blkszbits)
 
+#define Z_EROFS_PCLUSTER_MAX_BATCH_SIZE 32
+
 struct erofs_buffer_head;
 struct erofs_bufmgr;
 
@@ -451,6 +453,17 @@ struct z_erofs_paramset {
 	char *extraopts;
 };
 
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
 int liberofs_global_init(void);
 void liberofs_global_exit(void);
 
@@ -487,7 +500,8 @@ int erofs_read_one_data(struct erofs_inode *inode, struct erofs_map_blocks *map,
 			char *buffer, u64 offset, size_t len);
 int z_erofs_read_one_data(struct erofs_inode *inode,
 			struct erofs_map_blocks *map, char *raw, char *buffer,
-			erofs_off_t skip, erofs_off_t length, bool trimmed);
+			erofs_off_t skip, erofs_off_t length, bool trimmed,
+			erofs_off_t out_offset, struct z_erofs_mt_read_ctx *ctx);
 void *erofs_read_metadata(struct erofs_sb_info *sbi, erofs_nid_t nid,
 			  erofs_off_t *offset, int *lengthp);
 int z_erofs_parse_cfgs(struct erofs_sb_info *sbi, struct erofs_super_block *dsb);
diff --git a/lib/data.c b/lib/data.c
index 1bb9269..a378083 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -9,6 +9,241 @@
 #include "erofs/trace.h"
 #include "erofs/decompress.h"
 #include "liberofs_fragments.h"
+#include "erofs/lock.h"
+#include "erofs/cond.h"
+
+#ifdef EROFS_MT_ENABLED
+#include "erofs/config.h"
+
+struct z_erofs_percpu_queue {
+	erofs_mutex_t lock;
+	erofs_cond_t cond;
+	struct z_erofs_decompress_task *head;
+	struct z_erofs_decompress_task *tail;
+	int pending_tasks;
+	bool shutdown;
+	pthread_t thread;
+} __attribute__((aligned(64)));
+
+static struct z_erofs_percpu_queue *worker_queues;
+static int num_workers;
+#endif
+
+struct z_erofs_mt_read_ctx {
+	erofs_mutex_t lock;
+	erofs_cond_t cond;
+	int pending_tasks;
+	int final_err;
+	int outfd;
+	bool free_out;
+	struct z_erofs_decompress_task *current_task;
+};
+
+struct z_erofs_mt_read_ctx *z_erofs_mt_read_ctx_alloc(int outfd, bool free_out)
+{
+	struct z_erofs_mt_read_ctx *ctx = calloc(1, sizeof(*ctx));
+
+	if (!ctx)
+		return NULL;
+
+	erofs_mutex_init(&ctx->lock);
+	erofs_cond_init(&ctx->cond);
+	ctx->outfd = outfd;
+	ctx->free_out = free_out;
+	return ctx;
+}
+
+int z_erofs_mt_read_ctx_wait(struct z_erofs_mt_read_ctx *ctx)
+{
+	int err;
+
+	if (!ctx)
+		return 0;
+
+	erofs_mutex_lock(&ctx->lock);
+	while (ctx->pending_tasks > 0)
+		erofs_cond_wait(&ctx->cond, &ctx->lock);
+	err = ctx->final_err;
+	erofs_mutex_unlock(&ctx->lock);
+
+	return err;
+}
+
+void z_erofs_mt_read_ctx_free(struct z_erofs_mt_read_ctx *ctx)
+{
+	if (!ctx)
+		return;
+
+	erofs_mutex_destroy(&ctx->lock);
+	erofs_cond_destroy(&ctx->cond);
+	free(ctx);
+}
+
+struct z_erofs_decompress_item {
+	struct z_erofs_decompress_req req;
+	char *raw_buf;
+	char *out_buf;
+	erofs_off_t out_offset;
+	unsigned int out_length;
+};
+
+struct z_erofs_decompress_task {
+	struct z_erofs_decompress_task *next;
+	struct z_erofs_mt_read_ctx *ctx;
+	struct z_erofs_decompress_item items[Z_EROFS_PCLUSTER_MAX_BATCH_SIZE];
+	unsigned int nr_reqs;
+};
+
+static void z_erofs_process_task(struct z_erofs_decompress_task *task)
+{
+	struct z_erofs_mt_read_ctx *ctx = task->ctx;
+	int i, ret = 0, first_err = 0;
+
+	for (i = 0; i < task->nr_reqs; ++i) {
+		struct z_erofs_decompress_item *item = &task->items[i];
+
+		ret = z_erofs_decompress(&item->req);
+
+		if (ret >= 0 && ctx && ctx->outfd >= 0) {
+			if (pwrite(ctx->outfd, item->out_buf,
+				   item->out_length, item->out_offset) < 0)
+				ret = -errno;
+		}
+
+		if (ret < 0 && !first_err)
+			first_err = ret;
+
+		free(item->raw_buf);
+		if (ctx && ctx->free_out)
+			free(item->out_buf);
+	}
+
+	if (ctx) {
+		erofs_mutex_lock(&ctx->lock);
+		if (first_err < 0 && !ctx->final_err)
+			ctx->final_err = first_err;
+		ctx->pending_tasks--;
+		if (!ctx->pending_tasks)
+			erofs_cond_signal(&ctx->cond);
+		erofs_mutex_unlock(&ctx->lock);
+	}
+	free(task);
+}
+
+#ifdef EROFS_MT_ENABLED
+static void *z_erofs_worker_thread(void *arg)
+{
+	struct z_erofs_percpu_queue *q = arg;
+
+	while (1) {
+		erofs_mutex_lock(&q->lock);
+		while (!q->head && !q->shutdown)
+			erofs_cond_wait(&q->cond, &q->lock);
+
+		if (q->shutdown && !q->head) {
+			erofs_mutex_unlock(&q->lock);
+			break;
+		}
+
+		struct z_erofs_decompress_task *tasks = q->head;
+
+		q->head = q->tail = NULL;
+		q->pending_tasks = 0;
+		erofs_mutex_unlock(&q->lock);
+
+		while (tasks) {
+			struct z_erofs_decompress_task *task = tasks;
+
+			tasks = tasks->next;
+			z_erofs_process_task(task);
+		}
+	}
+	return NULL;
+}
+
+int z_erofs_mt_workers_init(void)
+{
+	int i;
+
+	num_workers = erofs_get_available_processors();
+
+	if (num_workers < 1)
+		num_workers = 1;
+
+	worker_queues = calloc(num_workers, sizeof(*worker_queues));
+	if (!worker_queues)
+		return -ENOMEM;
+
+	for (i = 0; i < num_workers; ++i) {
+		erofs_mutex_init(&worker_queues[i].lock);
+		erofs_cond_init(&worker_queues[i].cond);
+		worker_queues[i].head = worker_queues[i].tail = NULL;
+		worker_queues[i].pending_tasks = 0;
+		worker_queues[i].shutdown = false;
+		pthread_create(&worker_queues[i].thread, NULL, z_erofs_worker_thread,
+			&worker_queues[i]);
+	}
+	return 0;
+}
+
+void z_erofs_mt_workers_exit(void)
+{
+	int i;
+
+	if (!worker_queues)
+		return;
+	for (i = 0; i < num_workers; ++i) {
+		erofs_mutex_lock(&worker_queues[i].lock);
+		worker_queues[i].shutdown = true;
+		erofs_cond_signal(&worker_queues[i].cond);
+		erofs_mutex_unlock(&worker_queues[i].lock);
+
+		pthread_join(worker_queues[i].thread, NULL);
+		erofs_cond_destroy(&worker_queues[i].cond);
+		erofs_mutex_destroy(&worker_queues[i].lock);
+	}
+	free(worker_queues);
+	worker_queues = NULL;
+}
+#endif
+
+void z_erofs_mt_read_enqueue(struct z_erofs_mt_read_ctx *ctx)
+{
+#ifdef EROFS_MT_ENABLED
+	static int next_worker;
+#endif
+
+	if (!ctx || !ctx->current_task)
+		return;
+
+	struct z_erofs_decompress_task *task = ctx->current_task;
+
+	ctx->current_task = NULL;
+
+#ifdef EROFS_MT_ENABLED
+	if (num_workers > 0) {
+		int target = next_worker;
+
+		next_worker = (next_worker + 1) % num_workers;
+		struct z_erofs_percpu_queue *q = &worker_queues[target];
+
+		erofs_mutex_lock(&q->lock);
+		task->next = NULL;
+		if (!q->tail) {
+			q->head = q->tail = task;
+		} else {
+			q->tail->next = task;
+			q->tail = task;
+		}
+		q->pending_tasks++;
+		erofs_cond_signal(&q->cond);
+		erofs_mutex_unlock(&q->lock);
+		return;
+	}
+#endif
+	task->next = NULL;
+	z_erofs_process_task(task);
+}
 
 void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 {
@@ -277,20 +512,29 @@ static int erofs_read_raw_data(struct erofs_inode *inode, char *buffer,
 
 int z_erofs_read_one_data(struct erofs_inode *inode,
 			struct erofs_map_blocks *map, char *raw, char *buffer,
-			erofs_off_t skip, erofs_off_t length, bool trimmed)
+			erofs_off_t skip, erofs_off_t length, bool trimmed,
+			erofs_off_t out_offset, struct z_erofs_mt_read_ctx *ctx)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
 	struct erofs_map_dev mdev;
-	int ret = 0;
+	struct z_erofs_decompress_task *task;
+	struct z_erofs_decompress_item *item;
+	int ret = 0, idx, batch_limit;
 
 	if (map->m_flags & __EROFS_MAP_FRAGMENT) {
 		if (__erofs_unlikely(inode->nid == sbi->packed_nid)) {
 			erofs_err("fragment should not exist in the packed inode %llu",
 				  sbi->packed_nid | 0ULL);
-			return -EFSCORRUPTED;
+			ret = -EFSCORRUPTED;
+			goto err_out;
+		}
+		ret = erofs_packedfile_read(sbi, buffer, length - skip,
+					inode->fragmentoff + skip);
+		if (ret >= 0 && ctx && ctx->outfd >= 0) {
+			if (pwrite(ctx->outfd, buffer, length - skip, out_offset) < 0)
+				ret = -errno;
 		}
-		return erofs_packedfile_read(sbi, buffer, length - skip,
-				   inode->fragmentoff + skip);
+		goto err_out;
 	}
 
 	/* no device id here, thus it will always succeed */
@@ -300,31 +544,95 @@ int z_erofs_read_one_data(struct erofs_inode *inode,
 	ret = erofs_map_dev(sbi, &mdev);
 	if (ret) {
 		DBG_BUGON(1);
-		return ret;
+		goto err_out;
 	}
 
 	ret = erofs_dev_read(sbi, mdev.m_deviceid, raw, mdev.m_pa, map->m_plen);
 	if (ret < 0)
+		goto err_out;
+
+	if (!ctx) {
+		ret = z_erofs_decompress(&(struct z_erofs_decompress_req) {
+				.sbi = sbi,
+				.in = raw,
+				.out = buffer,
+				.decodedskip = skip,
+				.interlaced_offset =
+					map->m_algorithmformat == Z_EROFS_COMPRESSION_INTERLACED ?
+						erofs_blkoff(sbi, map->m_la) : 0,
+				.inputsize = map->m_plen,
+				.decodedlength = length,
+				.alg = map->m_algorithmformat,
+				.partial_decoding = trimmed ? true :
+					!(map->m_flags & EROFS_MAP_FULL_MAPPED) ||
+						(map->m_flags & EROFS_MAP_PARTIAL_REF),
+				});
 		return ret;
+	}
 
-	ret = z_erofs_decompress(&(struct z_erofs_decompress_req) {
-			.sbi = sbi,
-			.in = raw,
-			.out = buffer,
-			.decodedskip = skip,
-			.interlaced_offset =
-				map->m_algorithmformat == Z_EROFS_COMPRESSION_INTERLACED ?
-					erofs_blkoff(sbi, map->m_la) : 0,
-			.inputsize = map->m_plen,
-			.decodedlength = length,
-			.alg = map->m_algorithmformat,
-			.partial_decoding = trimmed ? true :
-				!(map->m_flags & EROFS_MAP_FULL_MAPPED) ||
-					(map->m_flags & EROFS_MAP_PARTIAL_REF),
-			 });
-	if (ret < 0)
-		return ret;
+	task = ctx->current_task;
+	if (!task) {
+		task = malloc(sizeof(*task));
+		if (!task) {
+			ret = -ENOMEM;
+			goto err_out;
+		}
+		task->nr_reqs = 0;
+		task->ctx = ctx;
+		ctx->current_task = task;
+
+		erofs_mutex_lock(&ctx->lock);
+		ctx->pending_tasks++;
+		erofs_mutex_unlock(&ctx->lock);
+	}
+
+	idx = task->nr_reqs++;
+	item = &task->items[idx];
+
+	item->req = (struct z_erofs_decompress_req) {
+		.sbi = sbi,
+		.in = raw,
+		.out = buffer,
+		.decodedskip = skip,
+		.interlaced_offset =
+			map->m_algorithmformat == Z_EROFS_COMPRESSION_INTERLACED ?
+				erofs_blkoff(sbi, map->m_la) : 0,
+		.inputsize = map->m_plen,
+		.decodedlength = length,
+		.alg = map->m_algorithmformat,
+		.partial_decoding = trimmed ? true :
+			!(map->m_flags & EROFS_MAP_FULL_MAPPED) ||
+				(map->m_flags & EROFS_MAP_PARTIAL_REF),
+	};
+	item->raw_buf = raw;
+	item->out_buf = buffer;
+	item->out_offset = out_offset;
+	item->out_length = length;
+
+	batch_limit = (map->m_algorithmformat == Z_EROFS_COMPRESSION_LZ4 ||
+						map->m_algorithmformat == Z_EROFS_COMPRESSION_ZSTD)
+					? Z_EROFS_PCLUSTER_MAX_BATCH_SIZE : 8;
+
+	if (task->nr_reqs >= batch_limit) {
+		/* Execute fast algorithms synchronously on the traversal thread */
+		if (map->m_algorithmformat == Z_EROFS_COMPRESSION_LZ4 ||
+			map->m_algorithmformat == Z_EROFS_COMPRESSION_ZSTD) {
+			ctx->current_task = NULL;
+			task->next = NULL;
+			z_erofs_process_task(task);
+		} else {
+			z_erofs_mt_read_enqueue(ctx);
+		}
+	}
 	return 0;
+
+err_out:
+	if (ctx) {
+		if (ctx->free_out)
+			free(buffer);
+		free(raw);
+	}
+	return ret;
 }
 
 static int z_erofs_read_data(struct erofs_inode *inode, char *buffer,
@@ -387,7 +695,7 @@ static int z_erofs_read_data(struct erofs_inode *inode, char *buffer,
 		}
 
 		ret = z_erofs_read_one_data(inode, &map, raw,
-				buffer + end - offset, skip, length, trimmed);
+				buffer + end - offset, skip, length, trimmed, 0, NULL);
 		if (ret < 0)
 			break;
 	}
diff --git a/lib/global.c b/lib/global.c
index 938aa0a..39451a3 100644
--- a/lib/global.c
+++ b/lib/global.c
@@ -27,6 +27,13 @@ int liberofs_global_init(void)
 #ifdef S3EROFS_ENABLED
 	xmlInitParser();
 #endif
+
+#ifdef EROFS_MT_ENABLED
+	err = z_erofs_mt_workers_init();
+	if (err)
+		goto out_unlock;
+#endif
+
 #ifdef HAVE_LIBCURL
 	if (!erofs_global_curl_initialized) {
 		if (curl_global_init(CURL_GLOBAL_DEFAULT) != CURLE_OK) {
@@ -35,14 +42,17 @@ int liberofs_global_init(void)
 		}
 		erofs_global_curl_initialized = true;
 	}
-out_unlock:
 #endif
+out_unlock:
 	erofs_mutex_unlock(&erofs_global_mutex);
 	return err;
 }
 
 void liberofs_global_exit(void)
 {
+#ifdef EROFS_MT_ENABLED
+	z_erofs_mt_workers_exit();
+#endif
 	erofs_mutex_lock(&erofs_global_mutex);
 	z_erofs_mt_global_exit();
 #ifdef HAVE_LIBCURL
-- 
2.53.0


