Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC7D606A32D
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 06:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aK+KfTIW
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJdw21WF6z2xKQ;
	Tue, 03 Nov 2026 17:29:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25" arc.chain=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793687378;
	cv=pass; b=V4JX9WizqL6mR4AJ2fNJrpTJXY5neFYGc/7dtBdUbRHgEmTpRfvsTl2nl2AEMU88Bp+3e1x42m005cPgjp5HQuz31RoLZXy80WhwLVg8rGJPfSt+TYN6UH0zU5XPq5He8cIcyAr8KAG9SOKJECCVnMU8n/N2BmbzCpAUsv/7YIUqZFmvlCVCXs8Qs91t1SDJQTFJVNJR/f7zkalb+aSHBGOru/PsmBMlkD4mBuQoF3ACkjtqWsUEhe71yGLmAZXeGQ7j9WNAWjPCU7ck9CeSD5nlnCyk6YwmeSj84mb+dVnwVNqZ57FIZNn6phE6BhMPMoj06jRKBDtp87lh7ZwsqA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793687378; c=relaxed/relaxed;
	bh=0XjH/2JPJXkwiAvbzwNLcBgxkDxcJEjDNFw8+eFT6Wc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hnv5n8ug23MyiHVJhIZB6iXOGaJPHLXupY7dmbethmSlLAWw9Psv9KF5Pdakl+VfyXOtmVnqfZRTIe+tkcvq3Rf58d0l1xcMq6sXzXZIwdpyapgwwgXcs7I7H9LHnQ50cACapOYJhFSt+pXNF8J5bINwch7xAhANdI4Gh2fmNyjNAfGURpp7iyqktP1bj2Iu7IoF15nv1CUtIqQTV3Wwe4rMf0AGEj3l+92yV9GukMh8BrI0L5EAvSTd1BmcKs5R9U32UNb/JbveKgGDziXnafP2zUUZkd+Rmucx07eaK5zquTXc9/beYg0fuF4wf30l6AD+GeqRNjTvvLcJOOFZ3Q==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aK+KfTIW; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aK+KfTIW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJdw005wfz2xN4
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 17:29:35 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E7F16022C;
	Tue,  3 Nov 2026 06:29:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793687373;
	b=JDphZHWnwU22x773L+2SFRJJmnSI8gIg6y+kUXKg7csvEd2xf/QnMpNmtEZwrXmQ/KGw
	 PNoS+4Qq9nnKpT2ulzetJf4t0u7YryEcLctOS4wg53ud3nwbfTv5B5cn1K7NuVY7BNd+a
	 Xk6q0/Uaa+vStD1ScpsM8HBBiPvgIxhgA3QGmMPXxQJ/5/ah0A113Sl0b3RjKq0fTbwaJ
	 DupvNOPyNf7dAUfnG8W+CAaLd42h1Qqddx+EjkZhX5gbNs5RfLKBxpzJ7vPRgnFudh+sR
	 att8SRp4yp1rnSceN8TWcFTEbLyBGFhsZyJnrtBROiJYjCVzPV2En7Zoiuidqm+3gQA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793687373;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0XjH/2JPJXkwiAvbzwNLcBgxkDxcJEjDNFw8+eFT6Wc=;
	b=CueWVq3kAj/fXToy8IePaG1sbDwNrsX5zXNf/r+j/QTGfmLEQ4/K0nhdevIFk8LxQOCq
	 bMTqs1UqvaS8hEs2jYjP4xqv8NeaW77WyXCoyyWi4bc938+XuJ7AyUMq3hLq+yQHvJmyT
	 mGHTH/9tCG/qyiCRd2goUkfwXF8EQgexI5VbYIUFJW+CiKlVqL5O2dwMBdg0tiNQMZqQQ
	 mbezlDr7dp0ZiHiX1CFjm8LpB7KeFYGIKvKwG4UoSzqWukCmuoCgl4JPLfHj4s10BBvIR
	 DLZS9WqRBFw5eXTa2olBQz2SdMQ83zcz9IaEZn3bPV1MRcsgS9Uduzc1MKdMwTDXQNA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B93001F00919;
	Tue,  3 Nov 2026 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793687373;
	bh=0XjH/2JPJXkwiAvbzwNLcBgxkDxcJEjDNFw8+eFT6Wc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aK+KfTIW0+QCrWs6e6WZ0E2y+P4IFcRqG3l/4Y266qBhLC0gtoLAdsI1MkMHFcwzz
	 yeLYcsSIwiWgc4Y9W/JD7LYLEtLXdPd3z0qtTAOypyc0Rhv5mdF3Z2jkZ1WRe81esZ
	 OnHJEjJxESRnQNLCSGFYHl9MIJEhgJSlkIx+iywO/Frfj2TuIrkcU0WOypAFre7Mb4
	 LhjZxMgWghELq6D5gcIERVArtiHs8r5m1LckRz4WSIbKvwo6BwHoFoTf08E64Gr3lw
	 o/Gykdj/MBkfXs184iQMWnk8Vnrdd3EIW47XgrF/dt3MM9ONvtnn0fgSHMh17NQ4LT
	 speJLUka11RZg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4935B467E6;
	Tue,  3 Nov 2026 06:29:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 03 Nov 2026 15:29:33 +0900
Subject: [PATCH v2 3/3] erofs: allocate file-backed mount requests from a
 bio_set
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
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-erofs-fileio-bioset-v2-3-5b91af423f72@samsung.com>
References: <20261103-erofs-fileio-bioset-v2-0-5b91af423f72@samsung.com>
In-Reply-To: <20261103-erofs-fileio-bioset-v2-0-5b91af423f72@samsung.com>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793687370; l=7189;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=JbqJh/FkhKfvIvt36XGJLGfatIdEF7acPZdHkk8NFxw=;
 b=zKwtocBw9GAhkmWaJ39Tvr1TTjwASzS7rfamB0PmQxCn1nTWpnxbyXKlHrShEnC/gc24GI2cy
 LgQ+s6c1q3JBsAe26z4GTEOylTaG4hCRhXUKX3gpdy3zxEWjM2E8dV7
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Daejun Park <daejun7.park@samsung.com>

Since commit 9f74ae8c9ac9 ("erofs: shorten bvecs[] for file-backed
mounts"), a file-backed request holds at most 16 bvecs. A 1 MiB
readahead window of order-0 folios then takes several backing reads.

Allocate requests from a bio_set, using the mempool that commit
considered. Each path submits its request before it allocates the
next one.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
A backing read through loop, FUSE, NFS or a fanotify listener may
allocate from this pool in another task, as fs_bio_set users do under
loop. NFS LOCALIO may allocate in the same task while the outer
request holds an element. Such a request waits for returned reserves.

Tested in a QEMU guest:
- read_ahead_kb=1024, 1 MiB read() calls on 256 files of 1 MiB:
  0.119 s instead of 0.141 s on mm-new with "mm/readahead: align the
  async window in page_cache_ra_order()" (median of 6). The other 15
  workload and mode cases changed by -22% to +0.2%.
- The same reads on erofs dev without that mm patch: 0.170 s instead
  of 0.137 s.
- failslab failing the readers' bio and biovec slab allocations: the
  reserves served 48 to 499 bio allocations in each of 8 cases. All
  data read back correctly.
---
 fs/erofs/fileio.c   | 47 +++++++++++++++++++++++++++++++++++------------
 fs/erofs/internal.h |  4 ++++
 fs/erofs/super.c    |  7 +++++++
 3 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index e13293ec70..a0f745f0c1 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -7,13 +7,18 @@
 #include <trace/events/erofs.h>
 
 struct erofs_fileio_rq {
-	struct bio_vec bvecs[16];
-	struct bio bio;
 	struct kiocb iocb;
 	struct super_block *sb;
 	refcount_t ref;
+	/*
+	 * must be last: the fields above are the front_pad of
+	 * erofs_fileio_bioset, and inline bvecs follow the bio
+	 */
+	struct bio bio;
 };
 
+static struct bio_set erofs_fileio_bioset;
+
 struct erofs_fileio {
 	struct erofs_map_blocks map;
 	struct erofs_map_dev dev;
@@ -38,9 +43,8 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 		rq->bio.bi_status = errno_to_blk_status(ret);
 	}
 	bio_endio(&rq->bio);
-	bio_uninit(&rq->bio);
 	if (refcount_dec_and_test(&rq->ref))
-		kfree(rq);
+		bio_put(&rq->bio);
 }
 
 static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
@@ -56,22 +60,25 @@ static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
 	if (test_opt(&EROFS_SB(rq->sb)->opt, DIRECT_IO) &&
 	    rq->iocb.ki_filp->f_mode & FMODE_CAN_ODIRECT)
 		rq->iocb.ki_flags = IOCB_DIRECT;
-	iov_iter_bvec(&iter, ITER_DEST, rq->bvecs, rq->bio.bi_vcnt,
+	iov_iter_bvec(&iter, ITER_DEST, rq->bio.bi_io_vec, rq->bio.bi_vcnt,
 		      rq->bio.bi_iter.bi_size);
 	scoped_with_creds(rq->iocb.ki_filp->f_cred)
 		ret = vfs_iocb_iter_read(rq->iocb.ki_filp, &rq->iocb, &iter);
 	if (ret != -EIOCBQUEUED)
 		erofs_fileio_ki_complete(&rq->iocb, ret);
 	if (refcount_dec_and_test(&rq->ref))
-		kfree(rq);
+		bio_put(&rq->bio);
 }
 
 static struct erofs_fileio_rq *erofs_fileio_rq_alloc(struct super_block *sb,
-						     struct file *file)
+		struct file *file, unsigned short nr_vecs)
 {
-	struct erofs_fileio_rq *rq = kzalloc_obj(*rq, GFP_KERNEL | __GFP_NOFAIL);
+	struct bio *bio = bio_alloc_bioset(NULL, nr_vecs, REQ_OP_READ,
+					   GFP_NOIO, &erofs_fileio_bioset);
+	struct erofs_fileio_rq *rq =
+			container_of(bio, struct erofs_fileio_rq, bio);
 
-	bio_init(&rq->bio, NULL, rq->bvecs, ARRAY_SIZE(rq->bvecs), REQ_OP_READ);
+	memset(rq, 0, offsetof(struct erofs_fileio_rq, bio));
 	rq->iocb.ki_filp = file;
 	rq->sb = sb;
 	refcount_set(&rq->ref, 2);
@@ -80,7 +87,8 @@ static struct erofs_fileio_rq *erofs_fileio_rq_alloc(struct super_block *sb,
 
 struct bio *erofs_fileio_bio_alloc(struct erofs_map_dev *mdev)
 {
-	return &erofs_fileio_rq_alloc(mdev->m_sb, mdev->m_dif->file)->bio;
+	return &erofs_fileio_rq_alloc(mdev->m_sb, mdev->m_dif->file,
+				      BIO_MAX_VECS)->bio;
 }
 
 void erofs_fileio_submit_bio(struct bio *bio)
@@ -108,11 +116,14 @@ static int erofs_fileio_iomap_read_folio_range(const struct iomap_iter *iter,
 			   offset_in_folio(folio, iter->pos))) {
 		struct super_block *sb = iter_ctx->realinode->i_sb;
 		struct erofs_device_info *dif = iter->iomap.private;
+		unsigned short nr_vecs;
 
 		/* submit the existing range if there was one. */
 		if (ctx->read_ctx)
 			erofs_fileio_iomap_submit_read(iter, ctx);
-		rq = erofs_fileio_rq_alloc(sb, dif->file);
+		nr_vecs = bio_max_segs(DIV_ROUND_UP(iomap_length(iter),
+						    PAGE_SIZE));
+		rq = erofs_fileio_rq_alloc(sb, dif->file, nr_vecs);
 		rq->bio.bi_iter.bi_sector = sector;
 		bio_add_folio_nofail(&rq->bio, folio, plen,
 				offset_in_folio(folio, iter->pos));
@@ -161,10 +172,22 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
 		}
 	}
 
-	io.rq = erofs_fileio_rq_alloc(inode->i_sb, io.dev.m_dif->file);
+	io.rq = erofs_fileio_rq_alloc(inode->i_sb, io.dev.m_dif->file, 1);
 	io.rq->bio.bi_end_io = erofs_fileio_meta_endio;
 	io.rq->bio.bi_iter.bi_sector = pos >> 9;
 	bio_add_folio_nofail(&io.rq->bio, folio, len, 0);
 	erofs_fileio_rq_submit(io.rq);
 	return 0;
 }
+
+int __init erofs_init_fileio(void)
+{
+	return bioset_init(&erofs_fileio_bioset, BIO_POOL_SIZE,
+			   offsetof(struct erofs_fileio_rq, bio),
+			   BIOSET_NEED_BVECS);
+}
+
+void erofs_exit_fileio(void)
+{
+	bioset_exit(&erofs_fileio_bioset);
+}
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 924b37e06e..e6b85bde82 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -510,9 +510,13 @@ int z_erofs_parse_cfgs(struct super_block *sb, struct erofs_super_block *dsb);
 #ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
 struct bio *erofs_fileio_bio_alloc(struct erofs_map_dev *mdev);
 void erofs_fileio_submit_bio(struct bio *bio);
+int __init erofs_init_fileio(void);
+void erofs_exit_fileio(void);
 #else
 static inline struct bio *erofs_fileio_bio_alloc(struct erofs_map_dev *mdev) { return NULL; }
 static inline void erofs_fileio_submit_bio(struct bio *bio) {}
+static inline int erofs_init_fileio(void) { return 0; }
+static inline void erofs_exit_fileio(void) {}
 #endif
 
 #ifdef CONFIG_EROFS_FS_PAGE_CACHE_SHARE
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index e92a7fa90a..17408aef92 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -1106,6 +1106,10 @@ static int __init erofs_module_init(void)
 	if (err)
 		goto ishare_err;
 
+	err = erofs_init_fileio();
+	if (err)
+		goto fileio_err;
+
 	err = register_filesystem(&erofs_fs_type);
 	if (err)
 		goto fs_err;
@@ -1113,6 +1117,8 @@ static int __init erofs_module_init(void)
 	return 0;
 
 fs_err:
+	erofs_exit_fileio();
+fileio_err:
 	erofs_exit_ishare();
 ishare_err:
 	erofs_exit_sysfs();
@@ -1128,6 +1134,7 @@ static int __init erofs_module_init(void)
 static void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
+	erofs_exit_fileio();
 	erofs_exit_ishare();
 
 	/* ensure all delayed rcu free inodes & pclusters are flushed */

-- 
2.43.0



