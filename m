Return-Path: <linux-erofs+bounces-2167-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8BD3D3EE75
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 15:47:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxln01NTrz308l;
	Fri, 23 Jan 2026 02:47:16 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769096836;
	cv=none; b=MuV4QRv/7q8t6/lRcQHehZ32ME9k9VAs26hKGd0Hieki/ilIgJtQk6DALSmbMcmce2sBtoXSWWfr0ADsuPbtnKYWD/Iqf4yxIwPq8bNF9rbdQlZIqkNa94kWny9WLDsC+5IdHAJ9lEiefkznl9pAc669ZowYYGY69mjHxI4LiBYytnreCEWckbkcaxojE9cd1Lbsog8ZNJ3XNpQUgLOvNN4cLztXCTanGJ+tWAFsVIrgkF1xdGxF3q0d27rxsBkBZXKDqxlqbUC99sUJJn+84YvXUTeUTK58ZX39gMSpuASb8S6hLCheZ/ItCncVI9naRon/ZnKjgEaJKvNPKO/Vhg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769096836; c=relaxed/relaxed;
	bh=bHJ8+pUveP5svlVbwXvXskyfrLfruh6IJ5eNHjeX9MY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ev1xEqUpu6BJXkMWRDB+IKxEC1cSRVK4tFQXnfpTtLtZM1CPHouxFciDB65Bg3rJb5oLdMvYb5MDdQ9cq+y/tKqTqqevKlQRu/bThJkYXGTMBMh01cpuQkqVhNvyyIke3XDlrSg46tltKdnEpuinrKzUgoJ+3SI2Vy+dwqVCcXmMXRSNWDsGM91p5Ia65IlMOmwD5Fp2m8/7gQyykkRsna3m84GYCB8ASbWdwD2mS3XrS90HfcRuFuM4bsDcNp2FuMBktpXygKhvIEQxwsiSDr3Ph0aFKx/zdyeC1Cz14Rg1K1Q1x5G5ZFZRgYm83OT2I6fIMeVBtHrMVnK1/kJY4Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=giAWo/rr; dkim-atps=neutral; spf=pass (client-ip=113.46.200.218; helo=canpmsgout03.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=giAWo/rr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.218; helo=canpmsgout03.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxlmv1j0dz309y
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 02:47:11 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bHJ8+pUveP5svlVbwXvXskyfrLfruh6IJ5eNHjeX9MY=;
	b=giAWo/rrr36d61qXZy7nal68rbmHJdEjeYRngYq28DWnXnVKPxdQs4UH90wHaoH2epVSG/3Fo
	3cPnC2zjW8mvicpxt81D327RXehW2Y5xtx0GB6U+baNmL27IDjhpW2xm+/WLe00jHXgdWehx7gt
	G1ataZt/JO5XeBUfr7+xPxM=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dxlhQ21SCzpSts;
	Thu, 22 Jan 2026 23:43:18 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 5E5A940570;
	Thu, 22 Jan 2026 23:47:06 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 23:47:05 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <amir73il@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v17 09/10] erofs: support compressed inodes for page cache share
Date: Thu, 22 Jan 2026 15:34:05 +0000
Message-ID: <20260122153406.660073-10-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20260122153406.660073-1-lihongbo22@huawei.com>
References: <20260122153406.660073-1-lihongbo22@huawei.com>
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
Content-Type: text/plain
X-Originating-IP: [10.67.174.162]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500015.china.huawei.com (7.202.195.162)

From: Hongzhen Luo <hongzhen@linux.alibaba.com>

This patch adds page cache sharing functionality for compressed inodes.

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/ishare.c |  2 --
 fs/erofs/zdata.c  | 38 ++++++++++++++++++++++++--------------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index ab459fb62473..ad53a57dbcbc 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -44,8 +44,6 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 	struct inode *sharedinode;
 	unsigned long hash;
 
-	if (erofs_inode_is_data_compressed(vi->datalayout))
-		return false;
 	if (erofs_xattr_fill_inode_fingerprint(&fp, inode, sbi->domain_id))
 		return false;
 	hash = xxh32(fp.opaque, fp.size, 0);
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 93ab6a481b64..59ee9a36d9eb 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -493,7 +493,7 @@ enum z_erofs_pclustermode {
 };
 
 struct z_erofs_frontend {
-	struct inode *const inode;
+	struct inode *inode, *sharedinode;
 	struct erofs_map_blocks map;
 	struct z_erofs_bvec_iter biter;
 
@@ -508,8 +508,8 @@ struct z_erofs_frontend {
 	unsigned int icur;
 };
 
-#define Z_EROFS_DEFINE_FRONTEND(fe, i, ho) struct z_erofs_frontend fe = { \
-	.inode = i, .head = Z_EROFS_PCLUSTER_TAIL, \
+#define Z_EROFS_DEFINE_FRONTEND(fe, i, si, ho) struct z_erofs_frontend fe = { \
+	.inode = i, .sharedinode = si, .head = Z_EROFS_PCLUSTER_TAIL, \
 	.mode = Z_EROFS_PCLUSTER_FOLLOWED, .headoffset = ho }
 
 static bool z_erofs_should_alloc_cache(struct z_erofs_frontend *fe)
@@ -1866,7 +1866,7 @@ static void z_erofs_pcluster_readmore(struct z_erofs_frontend *f,
 		pgoff_t index = cur >> PAGE_SHIFT;
 		struct folio *folio;
 
-		folio = erofs_grab_folio_nowait(inode->i_mapping, index);
+		folio = erofs_grab_folio_nowait(f->sharedinode->i_mapping, index);
 		if (!IS_ERR_OR_NULL(folio)) {
 			if (folio_test_uptodate(folio))
 				folio_unlock(folio);
@@ -1883,11 +1883,13 @@ static void z_erofs_pcluster_readmore(struct z_erofs_frontend *f,
 
 static int z_erofs_read_folio(struct file *file, struct folio *folio)
 {
-	struct inode *const inode = folio->mapping->host;
-	Z_EROFS_DEFINE_FRONTEND(f, inode, folio_pos(folio));
+	struct inode *sharedinode = folio->mapping->host;
+	bool need_iput;
+	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
+	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, folio_pos(folio));
 	int err;
 
-	trace_erofs_read_folio(inode, folio, false);
+	trace_erofs_read_folio(realinode, folio, false);
 	z_erofs_pcluster_readmore(&f, NULL, true);
 	err = z_erofs_scan_folio(&f, folio, false);
 	z_erofs_pcluster_readmore(&f, NULL, false);
@@ -1896,23 +1898,28 @@ static int z_erofs_read_folio(struct file *file, struct folio *folio)
 	/* if some pclusters are ready, need submit them anyway */
 	err = z_erofs_runqueue(&f, 0) ?: err;
 	if (err && err != -EINTR)
-		erofs_err(inode->i_sb, "read error %d @ %lu of nid %llu",
-			  err, folio->index, EROFS_I(inode)->nid);
+		erofs_err(realinode->i_sb, "read error %d @ %lu of nid %llu",
+			  err, folio->index, EROFS_I(realinode)->nid);
 
 	erofs_put_metabuf(&f.map.buf);
 	erofs_release_pages(&f.pagepool);
+
+	if (need_iput)
+		iput(realinode);
 	return err;
 }
 
 static void z_erofs_readahead(struct readahead_control *rac)
 {
-	struct inode *const inode = rac->mapping->host;
-	Z_EROFS_DEFINE_FRONTEND(f, inode, readahead_pos(rac));
+	struct inode *sharedinode = rac->mapping->host;
+	bool need_iput;
+	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
+	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
 	unsigned int nrpages = readahead_count(rac);
 	struct folio *head = NULL, *folio;
 	int err;
 
-	trace_erofs_readahead(inode, readahead_index(rac), nrpages, false);
+	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
 	while ((folio = readahead_folio(rac))) {
 		folio->private = head;
@@ -1926,8 +1933,8 @@ static void z_erofs_readahead(struct readahead_control *rac)
 
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
-			erofs_err(inode->i_sb, "readahead error at folio %lu @ nid %llu",
-				  folio->index, EROFS_I(inode)->nid);
+			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
+				  folio->index, EROFS_I(realinode)->nid);
 	}
 	z_erofs_pcluster_readmore(&f, rac, false);
 	z_erofs_pcluster_end(&f);
@@ -1935,6 +1942,9 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	(void)z_erofs_runqueue(&f, nrpages);
 	erofs_put_metabuf(&f.map.buf);
 	erofs_release_pages(&f.pagepool);
+
+	if (need_iput)
+		iput(realinode);
 }
 
 const struct address_space_operations z_erofs_aops = {
-- 
2.22.0


