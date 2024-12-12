Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB1CE77182
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Dec 2024 13:35:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Y8D4D0H9kz3bWH
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Dec 2024 00:35:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1734010521;
	cv=none; b=YYWwtmg0uHyrlHklFMk0NBF3TjMunv+exR/SMUkc9xZ8xlDKRsg38yJstc1il4qF/B9vN3j342t5ULy25lb73+BP9RVMY837lwph6oY7pzDgoO7PHQ+qFwOdQm8tTvTN73ffEb1RjuysFvuP1UHvYjuwo/cVLKTFhP4jbK8GhjNu015N/t7r83n+34KeIN09bfICT4eWjLPSpggyjJngcvIMXmY2pEENNA3/6eHrsu/EEuoDvFYGjTgV+KgBak4kGJJ/6qI01n8asvHfHU1J8tDgSO+knR3yp+fG5RKjBChQm+CJfbxKYbH1dV7nXuL5rdn4cEPGXkwL5LSudhRhDA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1734010521; c=relaxed/relaxed;
	bh=2apY12wQQrBM2u5ZHq7FWtTXJIMm1hk7CsOwd71KbJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ml0tChA16j3Kl1WSXXP+dCIjfazI4CQ5bi3mY85lAOXRFZ4G6Mrs9xk3L4K8pIcqabux2qy2LME4tMB1Lb5lU0ztzeNnqUjkBFR+3pbCZoX+eVRmL2ZHV6oedxmgTLt85HQg5yoFq7fX4cNfkSXRN1FHsssKktcdcmsaAHtyj7834S2njDBGxzfzExIJzYQYwDS3iOxvj5upRa9kwPAAj3oVChD93sSs4HFCogURXXqVrs9y36LIDx2bfH6eY78UIUwwOcJnFnduuvCH/YY62EKYC5IkxHTiUpnhTUkTNI1anupJV/aNasKMw/3Qbl5Uf2J6Cq7eTsdeMmKL2NCyvg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gnJHk1C8; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gnJHk1C8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Y8D475ndCz30WR
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Dec 2024 00:35:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734010515; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=2apY12wQQrBM2u5ZHq7FWtTXJIMm1hk7CsOwd71KbJU=;
	b=gnJHk1C88Y2rw4CglFa7BrQgdLZPZ+W5CYY46A33N38L9qHPWZylJQkvnfQmLFkDC2m8/y7iT2syOXG6nVec4CQAOeIKpWzTq8SfPuCHCaVeT5ik5v8iiIj08uKAmuax9l3XfjFl0oydeWJradYaJe87T4msrBm2bsHmhCkq1Gs=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WLLvJqX_1734010512 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Dec 2024 21:35:13 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 4/4] erofs: use buffered I/O for file-backed mounts by default
Date: Thu, 12 Dec 2024 21:35:04 +0800
Message-ID: <20241212133504.2047178-4-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241212133504.2047178-1-hsiangkao@linux.alibaba.com>
References: <20241212133504.2047178-1-hsiangkao@linux.alibaba.com>
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
Cc: Derek McGowan <derek@mcg.dev>, Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

For many use cases (e.g. container images are just fetched from remote),
performance will be impacted if underlay page cache is up-to-date but
direct i/o will flush dirty pages first.

Instead, let's use buffered I/O by default and add a (re)mount option to
explicitly enable direct I/O if underlay files are supported too.

The startup time for containerd is improved as below:
                                     unpack        1st run  non-1st runs
EROFS snapshotter buffered I/O file  4.586404265s  0.308s   0.198s
EROFS snapshotter direct I/O file    4.581742849s  2.238s   0.222s
EROFS snapshotter loop               4.596023152s  0.346s   0.201s
Overlayfs snapshotter                5.382851037s  0.206s   0.214s

Fixes: fb176750266a ("erofs: add file-backed mount support")
Cc: Derek McGowan <derek@mcg.dev>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/fileio.c   |  7 +++++--
 fs/erofs/internal.h |  1 +
 fs/erofs/super.c    | 21 +++++++++++++--------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index a61b8faec651..33f8539dda4a 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -9,6 +9,7 @@ struct erofs_fileio_rq {
 	struct bio_vec bvecs[BIO_MAX_VECS];
 	struct bio bio;
 	struct kiocb iocb;
+	struct super_block *sb;
 };
 
 struct erofs_fileio {
@@ -52,8 +53,9 @@ static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
 	rq->iocb.ki_pos = rq->bio.bi_iter.bi_sector << SECTOR_SHIFT;
 	rq->iocb.ki_ioprio = get_current_ioprio();
 	rq->iocb.ki_complete = erofs_fileio_ki_complete;
-	rq->iocb.ki_flags = (rq->iocb.ki_filp->f_mode & FMODE_CAN_ODIRECT) ?
-				IOCB_DIRECT : 0;
+	if (test_opt(&EROFS_SB(rq->sb)->opt, DIRECT_IO) &&
+	    rq->iocb.ki_filp->f_mode & FMODE_CAN_ODIRECT)
+		rq->iocb.ki_flags = IOCB_DIRECT;
 	iov_iter_bvec(&iter, ITER_DEST, rq->bvecs, rq->bio.bi_vcnt,
 		      rq->bio.bi_iter.bi_size);
 	ret = vfs_iocb_iter_read(rq->iocb.ki_filp, &rq->iocb, &iter);
@@ -68,6 +70,7 @@ static struct erofs_fileio_rq *erofs_fileio_rq_alloc(struct erofs_map_dev *mdev)
 
 	bio_init(&rq->bio, NULL, rq->bvecs, BIO_MAX_VECS, REQ_OP_READ);
 	rq->iocb.ki_filp = mdev->m_dif->file;
+	rq->sb = mdev->m_sb;
 	return rq;
 }
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 59e7739b7c3b..bc46000ccc6b 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -177,6 +177,7 @@ struct erofs_sb_info {
 #define EROFS_MOUNT_POSIX_ACL		0x00000020
 #define EROFS_MOUNT_DAX_ALWAYS		0x00000040
 #define EROFS_MOUNT_DAX_NEVER		0x00000080
+#define EROFS_MOUNT_DIRECT_IO		0x00000100
 
 #define clear_opt(opt, option)	((opt)->mount_opt &= ~EROFS_MOUNT_##option)
 #define set_opt(opt, option)	((opt)->mount_opt |= EROFS_MOUNT_##option)
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 934fb1513095..cbb9566cc6dc 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -364,14 +364,8 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
 }
 
 enum {
-	Opt_user_xattr,
-	Opt_acl,
-	Opt_cache_strategy,
-	Opt_dax,
-	Opt_dax_enum,
-	Opt_device,
-	Opt_fsid,
-	Opt_domain_id,
+	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
+	Opt_device, Opt_fsid, Opt_domain_id, Opt_directio,
 	Opt_err
 };
 
@@ -398,6 +392,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
 	fsparam_string("device",	Opt_device),
 	fsparam_string("fsid",		Opt_fsid),
 	fsparam_string("domain_id",	Opt_domain_id),
+	fsparam_flag_no("directio",	Opt_directio),
 	{}
 };
 
@@ -511,6 +506,16 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
 		break;
 #endif
+	case Opt_directio:
+#ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
+		if (result.boolean)
+			set_opt(&sbi->opt, DIRECT_IO);
+		else
+			clear_opt(&sbi->opt, DIRECT_IO);
+#else
+		errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
+#endif
+		break;
 	default:
 		return -ENOPARAM;
 	}
-- 
2.43.5

