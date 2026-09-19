Return-Path: <linux-erofs+bounces-4580-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5ACCC982DA
	for <linux-erofs@archiver.kernel.org>; Sat, 19 Sep 2026 15:15:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hnCjB0Yq8z2xSg;
	Sun, 20 Sep 2026 01:15:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789830910;
	cv=none; b=ifSVOESYlWNOThaT4AzLFNiEXL/9gzozjACByeNpSfdIilFrxdBqT2wW94VIJOy/5ZfUs4jQjYZGpXZCCXlu4gWuw+GFxj/dOluxXWgH5cBSBKDzeJkjI+rqPlOylN8Mgc/82QPAwDtW/P5qdFHw0z+PwRqnoU8ekUnFV/3EI38PL4niTBryvCrWgYZVvxPvWlrFfKEoBc6w7ANSVUOfy09Dla2vqu+PkQ0CWFzMRn54trF+xekmbR/qE1SEmjDwLGXcE+I89Lwkbn42Sl379wMb8NzPu4AueE3DohdOdmqjXNHDBXgomG3WLqb5f3I6GEgcjkjJBLEtTc5m4ODIBw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789830910; c=relaxed/relaxed;
	bh=Z7vHDtj8t4dRHEkTB7xSLIOTyajEys/gBtShQuYwa9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQ68QEVjihkjXeutVU+pOSyzDUD1E2s5Fn2O44wTsZRnp2mKHe8ucr49S76F7Hl+XLshNRf5cUjKW89FtwXa/f5fXOiwPtL4/N58YVtWDCKZZhFab2wIxvXNpGga5tE3M0/ynabTSeR+yP5Kv0zCGQz42OJzjlD89Gg2bBkApWEf7E7iiwbPABP6XhJ1JxXqfbo8gxlziTV6Or0tG+aarfelaAmXtMlJKwyaQ8ivD30REDqeskda/bCsgFKAWrUpg12AWKx66iG2tuZi+c1DFjqYFD28JNTm+K3vJhRQJbs0c6GebF67lhoYB71d1UVyvY9O3lXERRNChDn87XpMUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nZlQ/QTF; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::e; helo=mail-pz2-x0e.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nZlQ/QTF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::e; helo=mail-pz2-x0e.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x0e.google.com (mail-pz2-x0e.google.com [IPv6:2607:f8b0:4864:3b::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hnCj81Twzz2xfP
	for <linux-erofs@lists.ozlabs.org>; Sun, 20 Sep 2026 01:15:07 +1000 (AEST)
Received: by mail-pz2-x0e.google.com with SMTP id 41be03b00d2f7-cc1cebad4adso1232633a12.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 19 Sep 2026 08:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789830906; x=1790435706; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z7vHDtj8t4dRHEkTB7xSLIOTyajEys/gBtShQuYwa9I=;
        b=nZlQ/QTFaReJXB716R+Pkcj3v9kGWUYO/Tx3rReUVKwk9+Yc92Fxt7JcUa+QJg2ik3
         1V+kG6w42F+RMEikQNQaACY14kUHTLi2V1uqqGm/mJcOcwb1hxhZ0rEmBWg9vinu4Wc1
         kPaJhVOf1R8TgAIks1h7XycC5IcXYSisisHZZJqe631w3HA0kN2NFyF8hUy/OAN2rgBy
         Ik9SHEIFVtnVerNpVc2pC0J3Ub+TqvMx//ItrIvbU3WGys3kBxZnk23dS2nlcUVv/Ipy
         u9HAN3RfzSj+gnus3BQbODz59Qif1hbzu/z2qU5Cje56ikmmViSlhOGp45Mq9gYAu8FZ
         GPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789830906; x=1790435706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z7vHDtj8t4dRHEkTB7xSLIOTyajEys/gBtShQuYwa9I=;
        b=f2+BfEJzRptr8YbWFO9BmhpOyEhaD8F2vwdtYXUB9jt2jL0KhwUjeKFm2mLKwsNQDK
         PI+ofoctaTonNlqaU5bNcrrv36NLxB+HZPGWwTkM86mFpYgJ60OQZ4Wl7eJ99Lr7i9Qm
         2+pucOdu9/s0F7FUL14iWAjlPdnxo8ucfXZ+6enyzacV0c+Gf0ww66ye1g1P9rASgHCL
         3zMzuWQXnK0jzdPlus+QhAYNcyJGPBOIJaWsqEj5HYxLcycv0S/e686z7on2SK6JYHiE
         C5Jd+f7ANNn4OLAlS6GZz9heAR3wP2huKP54LT5+CoEmV08o7za+wgA8u+hIjosurMz3
         oLEQ==
X-Gm-Message-State: AFuF++ngvIgUvfXrmdo4llwJXKalFNqR0o6pW5WGkLLwdBlKMWH/e+Hr
	QNK/gd9dHToU6LH5k+Z8t9lQcLhfBqfIPHr0joSzFuk0BkRlmY6nd8IqfNyENA==
X-Gm-Gg: AYBFou30tAlC1tBc24nZP1njKjuW/QxgU9HDywWuqfaiP1Bq3K6p4Zwz0G1b2KW8ev4
	fC0kRWg95pVfwrOk9NnwfyzVikWuM2GzOpKfas7UCBMSMXy7rEpvKZIp0vog/HxSL3RRb5060rw
	sVjgtTfnVie+e7EcvwYf77IHc0NCdXKzATs7YvY2lGnAhgc7D9dBhiya0y3D2/Eu9pRS6VaovZw
	NB8SL8VKYx4FitVWI/ead35UAEcwJ7mFgZlDGtFYdSgpUru8hj/i+/G//J0dRiaV4neAYyPtK8S
	Y1qpViHEh5jb/PrJVxk42gh8/mHRiK9+D6mqfylWLT3zwiuf0L11RgC1ygkrmSLLNv6SLxRRVXr
	3+1tXqFTvKVgM6vw7wtamlCQ6PXj1gL0XLzjYQ+TvER+BReH5d2DkNE4zgsidA+IH8biPu1SG3A
	J2K9WN7AtbSHbvbxCBAmww7C5n+LDEE0sXgooJYIGyJJO7dkvWChyIQMpk/18Z7zNxCWuXmZHhI
	0v6sOUW/vQ0AKnp2XJrqbMceAkbyRayFg==
X-Received: by 2002:a05:6a21:6e4c:b0:3d3:afa7:8101 with SMTP id adf61e73a8af0-3dd8c53b226mr9111532637.28.1789830905568;
        Sat, 19 Sep 2026 08:15:05 -0700 (PDT)
Received: from localhost.localdomain ([103.27.167.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72aee368asm1039661a12.26.2026.09.19.08.15.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 19 Sep 2026 08:15:05 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	hsiangkao@linux.alibaba.com,
	hsiangkao@gmx.com,
	Nithurshen <nithurshen.dev@gmail.com>
Subject: [PATCH 2/2] fsck.erofs: add multi-threaded decompression
Date: Sat, 19 Sep 2026 20:44:43 +0530
Message-ID: <20260919151443.29012-3-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260919151443.29012-1-nithurshen.dev@gmail.com>
References: <20260919151443.29012-1-nithurshen.dev@gmail.com>
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

Currently, fsck.erofs verifies and extracts inode data synchronously
during directory traversal. While directory walking can now run
concurrently across worker threads, CPU-intensive decompression (such
as LZMA or DEFLATE) for large files still blocks traversal threads,
creating a processing bottleneck during extraction and verification.

This patch introduces a multi-threaded decompression pipeline using a
per-CPU worker pool and an asynchronous reading context
(struct z_erofs_mt_read_ctx). For large compressed files exceeding
EROFS_MT_THRESHOLD (128KB), decompression workloads are batched and
offloaded to dedicated background workers.

Decompressed chunks are directly written out at calculated offsets via
pwrite(), allowing concurrent out-of-order decompression while
maintaining output correctness. Global initialization and teardown of
the per-CPU decompression workers are wired into liberofs_global_init()
and liberofs_global_exit().

Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
---
 fsck/main.c              | 117 +++++++++---
 include/erofs/internal.h |  16 +-
 lib/data.c               | 377 ++++++++++++++++++++++++++++++++++++---
 lib/global.c             |  12 +-
 4 files changed, 467 insertions(+), 55 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index a520af91..0336335b 100644
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
+	if (ctx && outfd >= 0 && ret == 0) {
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
index 2cc9cc80..d663f57e 100644
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
index 1bb9269c..3deaa137 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -9,6 +9,262 @@
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
+static pthread_once_t worker_pool_once = PTHREAD_ONCE_INIT;
+static int worker_pool_init_err;
+static int z_erofs_mt_workers_ensure_init(void);
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
+	struct z_erofs_mt_read_ctx *ctx;
+
+#ifdef EROFS_MT_ENABLED
+	z_erofs_mt_workers_ensure_init();
+#endif
+
+	ctx = calloc(1, sizeof(*ctx));
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
+static void z_erofs_mt_workers_create_once(void)
+{
+	int i;
+
+	num_workers = erofs_get_available_processors();
+
+	if (num_workers < 1)
+		num_workers = 1;
+
+	worker_queues = calloc(num_workers, sizeof(*worker_queues));
+	if (!worker_queues) {
+		worker_pool_init_err = -ENOMEM;
+		num_workers = 0;
+		return;
+	}
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
+}
+
+static int z_erofs_mt_workers_ensure_init(void)
+{
+	pthread_once(&worker_pool_once, z_erofs_mt_workers_create_once);
+	return worker_pool_init_err;
+}
+
+int z_erofs_mt_workers_init(void)
+{
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
@@ -277,20 +533,29 @@ static int erofs_read_raw_data(struct erofs_inode *inode, char *buffer,
 
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
 		}
-		return erofs_packedfile_read(sbi, buffer, length - skip,
-				   inode->fragmentoff + skip);
+		ret = erofs_packedfile_read(sbi, buffer, length - skip,
+					inode->fragmentoff + skip);
+		if (ret >= 0 && ctx && ctx->outfd >= 0) {
+			if (pwrite(ctx->outfd, buffer, length - skip, out_offset) < 0)
+				ret = -errno;
+		}
+		goto err_out;
 	}
 
 	/* no device id here, thus it will always succeed */
@@ -300,31 +565,95 @@ int z_erofs_read_one_data(struct erofs_inode *inode,
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
@@ -387,7 +716,7 @@ static int z_erofs_read_data(struct erofs_inode *inode, char *buffer,
 		}
 
 		ret = z_erofs_read_one_data(inode, &map, raw,
-				buffer + end - offset, skip, length, trimmed);
+				buffer + end - offset, skip, length, trimmed, 0, NULL);
 		if (ret < 0)
 			break;
 	}
diff --git a/lib/global.c b/lib/global.c
index 938aa0a7..39451a35 100644
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
2.52.0


