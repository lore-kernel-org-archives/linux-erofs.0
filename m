Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513DC606A31A
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Oct 2026 03:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hO5/TKe8
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jG6g46jzdz2y8r;
	Fri, 30 Oct 2026 14:54:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25" arc.chain=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793332480;
	cv=pass; b=PtMtG+TO6hS0I0JBCbuDagk2AjdMYzYX0cMevEsN/bleam+S8bZXARfy1Grhll1vjuXzN0FjC2LqPiypWpa4KrNNgoKSPytnc12jQAqHJ6HzFv8IQxuTQQoS6wRt3EFb+PHspOuR6ALs1KJP8n/3/fO/vP2FhlMgc6i9lk2u6+vzueUnX5sU1YewK7NRH0w7Dl38wnmX68YTlMX5VWHls+6nRr56wJNcIwVLEqmebGSYCmp8kY/yDnzEJwdw73AnpvbYmGSjdZVcMj51unyDe+Q6HcpKZ1pxaB+aQwbn0797hXXvsE2Q/xPTtuuzGqnAMf/eMJwP6sIuR9wQLLOqmw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793332480; c=relaxed/relaxed;
	bh=Y94x0XFkUWge/pJ0DfaIyGIPUJpHReZSVXKDZIueDcI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gy0CNqcuiTWnKme8iJRdoqFKZ5WignTuWEY6QL4OJyb10ezvB8iydkvgJ3TsTikhjibRxR9PHU02gEiqmJLg0/c4tTeCoFCWylnTzY5wS7ASo8uPFXS6X74omZ4p1Tqk6xao87hbSiWMIXcgGhK7UEGD9nl1nT2S9krkA/krSiNETJZMlg9MXB+02ULCEn1j7NBMFG+5gAAvOdD/FIylvb8riMJKWWb9fv4zAbr9LfyAZXXLplXUHkz+u0rW0YwOs2vlrslhb7Kb6SlJbGK/qfnuKzTckJzsqDF/vRHiCXrl/geygq1T/1bTfeQJCR5zOqa3AgaN5Nv77rukwrD6qQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hO5/TKe8; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hO5/TKe8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jG6g35dKMz2xwL
	for <linux-erofs@lists.ozlabs.org>; Fri, 30 Oct 2026 14:54:39 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F1C643E96;
	Fri, 30 Oct 2026 03:54:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793332477;
	b=yfCxlAlkqrjdlJcthNwKSA80KDla00Ts66DLx6S7qocZx3GU5i/9EwZPApdfarkJyTZa
	 SBuuqGKB7gqjCLDEVEFMMp5+577SHe8wv2+n671lpF5fCxPrWcHcjBybNbSq51hbExNdC
	 peaqSO6mhf7bIb/dE6frfQSawVALuT575J0L9ITEaBW0IP2FW1Vwe2OgpODBgszAZUwyy
	 qQvE0OgcNwpgd+K8AH5aXazjZnvWYU1L5QY7vZdY5IK93I6D8Tw7YgRJenrC4RfJ3DskC
	 75eOsYQ0lcPBB0+aXpW25XGwQC4o9T+qwDz6HjGbXby0yKZcLieieqgw9AY7g7dMN7w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793332477;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=Y94x0XFkUWge/pJ0DfaIyGIPUJpHReZSVXKDZIueDcI=;
	b=N5rpiaK947K5XrGTiV7NiHlLN4Y3YWxMxdQDqq0Gx67CU+aRf4mlEMJkTKML0HWeR1tc
	 LsfV4C2BSOldzypTOX1PmMhKdmW22z6PIfkJkEcuSTXOzRXuKHpS0/+hfohSc2WgRL17L
	 69mniD6CrhtWqnVK44mEfmH31juqzNhxzIBmlm7PtJ4nkTugng3TvRNUqDHCJ0vpmeLS2
	 oWmZDil11gfUzTEobXzRa4LkOZu+XFP/pUr1ks6/At+CpIfiLh5Y5irwrdT7jrnBnBrtd
	 L6S1vhA9RJFEqyD4R07I+kk19O8728NCCTCGrWQJkO5yyrjDYyY+5SntaO7/JCv0QNw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 836D61F000C1;
	Fri, 30 Oct 2026 03:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793332477;
	bh=Y94x0XFkUWge/pJ0DfaIyGIPUJpHReZSVXKDZIueDcI=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=hO5/TKe8jFMfYu/Y+OnT611ZFlGksbiJgANg/7QvuXs8qHRWqThO1MpnSLrGRbpTh
	 XwPEy4N2W/TydQlZFfOGr/HKwp9hdAlWoJee7Uicp3viS6NS5nadvl+yOqesFJLuLl
	 6paYNSRAWL3PWDyKIveo5NVOVO5DEIAUyS2nK26Ru0ftyonjfCZRYkWDvovOqwlaoG
	 /9umYj4ZNyxAPG50YuRqu1jTNN8tRNerxqLSl/tVn5BeBV2TMTyXYtu9j8TTLiFx4e
	 tQTKMbbwrmG/TdOx4y88VYfYiCxMkCWrpix9tEGYcICftdoLpHMB8N3QfnUJQzz0uw
	 jC0+YnUynxbOQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 10C0F435F8;
	Fri, 30 Oct 2026 03:54:36 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Fri, 30 Oct 2026 12:54:36 +0900
Subject: [PATCH] erofs: allocate file-backed mount requests from a bio_set
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
Message-Id: <20261030-erofs-fileio-bioset-v1-1-caf47adbb3a3@samsung.com>
X-B4-Tracking: v=1; b=H4sIAPsU5GoC/x3MTQqAIBBA4avErBtQo9KuEi36GWsgNJyIILp70
 vJbvPeAUGIS6IoHEl0sHEOGLguYtzGshLxkg1Gm0co4pBS9oOedOOLEUejEVld1qybrFusgl0c
 iz/d/7Yf3/QACpbrhZQAAAA==
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793332475; l=7653;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=gbIxnX8FciCSXpNYzWxLVeaper8bYHxXoy7NVQKYLCc=;
 b=I6WF5AUXX0OQ89qm/VX6quw8eorvh1mBHO9e7AewMvJa0Kcn5MiGTDvcC4lwsZ93fdrT2yliD
 6BIC9qz1LBkDbjbNHf8QEkMl3JZqfJOp+386V0RVbVamf1RBQjgp1Uu
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
synchronous readahead window of order-0 folios can then take several
backing reads.

Allocate requests from a bio_set, using the mempool that commit
considered. With GFP_NOIO, bio_alloc_bioset() does not fail if each
task submits a request before it allocates another:

- Every path submits its request before it allocates the next one.

- Mount already rejects backing files on stacked fses and on
  file-backed EROFS. A backing read cannot reach this pool again in
  the same task.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
This needs "erofs: apply the stacked fs check to extra file-backed
devices" [1].

Tested in QEMU on mm-new with that patch and "mm/readahead: keep at
least half of the async window when aligning it" [2]:

- With read_ahead_kb=1024, 1 MiB read() calls on 256 files of 1 MiB
  take 0.119 s instead of 0.141 s (median of 6). The other 15 cases
  changed by -22% to +0.4%.

- Without the mm patch, this patch makes the same reads about 25%
  slower.

- With failslab failing all bio and biovec slab allocations of 8
  parallel readers, every request came from the bio_set's reserves.
  All data read back correctly.

- KASAN and lockdep found only the lockdep report noted in [1].

[1] https://lore.kernel.org/r/20261030-erofs-stacked-extra-devices-v1-1-39f7df7ac01b@samsung.com
[2] https://lore.kernel.org/r/20261030-mm-readahead-async-align-v1-1-109dea6851fc@samsung.com
---
 fs/erofs/fileio.c   | 44 ++++++++++++++++++++++++++++++++------------
 fs/erofs/internal.h |  4 ++++
 fs/erofs/super.c    |  7 +++++++
 3 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index e13293ec70..0fe6eb6643 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -7,13 +7,15 @@
 #include <trace/events/erofs.h>
 
 struct erofs_fileio_rq {
-	struct bio_vec bvecs[16];
-	struct bio bio;
 	struct kiocb iocb;
 	struct super_block *sb;
 	refcount_t ref;
+	/* must be last: erofs_fileio_bioset allocates the rest as front_pad */
+	struct bio bio;
 };
 
+static struct bio_set erofs_fileio_bioset;
+
 struct erofs_fileio {
 	struct erofs_map_blocks map;
 	struct erofs_map_dev dev;
@@ -38,9 +40,8 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 		rq->bio.bi_status = errno_to_blk_status(ret);
 	}
 	bio_endio(&rq->bio);
-	bio_uninit(&rq->bio);
 	if (refcount_dec_and_test(&rq->ref))
-		kfree(rq);
+		bio_put(&rq->bio);
 }
 
 static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
@@ -56,22 +57,25 @@ static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
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
@@ -80,7 +84,8 @@ static struct erofs_fileio_rq *erofs_fileio_rq_alloc(struct super_block *sb,
 
 struct bio *erofs_fileio_bio_alloc(struct erofs_map_dev *mdev)
 {
-	return &erofs_fileio_rq_alloc(mdev->m_sb, mdev->m_dif->file)->bio;
+	return &erofs_fileio_rq_alloc(mdev->m_sb, mdev->m_dif->file,
+				      BIO_MAX_VECS)->bio;
 }
 
 void erofs_fileio_submit_bio(struct bio *bio)
@@ -108,11 +113,14 @@ static int erofs_fileio_iomap_read_folio_range(const struct iomap_iter *iter,
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
@@ -161,10 +169,22 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
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
index ee01a5ef85..faea77ba25 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -1100,6 +1100,10 @@ static int __init erofs_module_init(void)
 	if (err)
 		goto ishare_err;
 
+	err = erofs_init_fileio();
+	if (err)
+		goto fileio_err;
+
 	err = register_filesystem(&erofs_fs_type);
 	if (err)
 		goto fs_err;
@@ -1107,6 +1111,8 @@ static int __init erofs_module_init(void)
 	return 0;
 
 fs_err:
+	erofs_exit_fileio();
+fileio_err:
 	erofs_exit_ishare();
 ishare_err:
 	erofs_exit_sysfs();
@@ -1122,6 +1128,7 @@ static int __init erofs_module_init(void)
 static void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
+	erofs_exit_fileio();
 	erofs_exit_ishare();
 
 	/* ensure all delayed rcu free inodes & pclusters are flushed */

---
base-commit: 7778e12f447c2b465fd9c8796348521494b5d3e4
change-id: 20261029-erofs-fileio-bioset-713570b89d89

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>



